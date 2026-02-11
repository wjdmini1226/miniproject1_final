package com.example.project.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.project.constant.MyConstant;
import com.example.project.dao.BoardDao;
import com.example.project.util.Paging;
import com.example.project.vo.BoardVo;
import com.example.project.vo.MemberVo;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/board")
public class BoardController {

	@Autowired
	BoardDao boardDao;

	@Autowired
	HttpServletRequest request;

	@Autowired
	HttpSession session;

	@RequestMapping("/list.do")
	public String list(
	        @RequestParam(name="page", defaultValue="1") int nowPage,
	        @RequestParam(name="search", defaultValue="all") String search,
	        @RequestParam(name="search_text", required=false) String search_text,
	        Model model) {

	    Map<String, Object> map = new HashMap<>();

	    // 1) 페이징 범위 먼저 계산
	    int start = (nowPage - 1) * MyConstant.Board.BLOCK_LIST + 1;
	    int end   = start + MyConstant.Board.BLOCK_LIST - 1;
	    map.put("start", start);
	    map.put("end", end);

	    // 2) 검색어 정리
	    if (search_text != null) search_text = search_text.trim();

	    // 3) 검색 조건을 MyBatis mapper가 기대하는 key(b_title/b_content)로 넣기
	    if (search_text != null && !search_text.isEmpty()) {
	        if ("b_title".equals(search)) {
	            map.put("b_title", search_text);
	        } else if ("b_content".equals(search)) {
	            map.put("b_content", search_text);
	        } else if ("b_title_b_content".equals(search)) {
	            map.put("b_title", search_text);
	            map.put("b_content", search_text);
	        }
	        // search=all 이면 아무것도 안 넣어서 전체 조회처럼 동작
	    }

	    // 4) 검색조건 포함한 총 개수
	    int rowTotal = boardDao.selectRowTotal(map);

	    // 5) 검색/전체 공통: 조건+페이징 적용된 리스트 조회 (※ 덮어쓰기 금지)
	    List<BoardVo> list = boardDao.selectConditionList(map);

	    // 6) pageMenu 생성 시 검색파라미터 유지 (Paging.getPaging2가 query 포함 URL을 받는 방식이면 가능)
	    String baseUrl = "list.do";
	    if (search_text != null && !search_text.isEmpty() && !"all".equals(search)) {
	        String enc = java.net.URLEncoder.encode(search_text, java.nio.charset.StandardCharsets.UTF_8);
	        baseUrl += "&search=" + search + "&search_text=" + enc;
	    }

	    String pageMenu = Paging.getPaging2(baseUrl,
	            nowPage,
	            rowTotal,
	            MyConstant.Board.BLOCK_LIST,
	            MyConstant.Board.BLOCK_PAGE);

	    session.removeAttribute("show");

	    model.addAttribute("list", list);
	    model.addAttribute("pageMenu", pageMenu);

	    return "board/board_list";
	}


	
	
	
	// 새글쓰기 폼 띄우기
	@RequestMapping("/insert_form.do")
	public String insert_form() {
		return "board/board_insert_form";
	}

	// 새글쓰기
	@PostMapping("insert.do")
	public String insert(BoardVo vo, RedirectAttributes ra) {

		// ✅ MemberVo 기준 세션 키 통일: login.do에서 member로 저장 중
		MemberVo user = (MemberVo) session.getAttribute("member");
		if (user == null) {
			ra.addAttribute("reason", "session_timeout");
			// ✅ 절대경로 권장(상대경로 꼬임 방지)
			return "redirect:/member/login_form.do";
		}

		// m_idx 매핑 (작성자)
		vo.setM_idx(user.getM_idx());

		// CKEditor HTML은 그대로 저장 (null 방지)
		if (vo.getB_content() == null) vo.setB_content("");

		// 기본값
		vo.setB_is_notice("N");
		vo.setB_is_ad("N");

		// ✅ m_admin: 0=일반, 1=사장, 2=관리자
		int adminLevel = user.getM_admin();
		boolean isOwner = (adminLevel == 1);
		boolean isAdmin = (adminLevel == 2);

		// 사장은 무조건 홍보 태그
		if (isOwner) {
			vo.setB_is_ad("Y");
		}

		// 관리자는 공지 가능(폼에서 Y면 Y로), 그 외는 공지 강제 N
		if (isAdmin) {
			if ("Y".equalsIgnoreCase(vo.getB_is_notice())) {
				vo.setB_is_notice("Y");
			} else {
				vo.setB_is_notice("N");
			}
		} else {
			vo.setB_is_notice("N");
		}

		boardDao.insert(vo);
		return "redirect:list.do";
	}

	// 게시글 상세보기
	@RequestMapping("view.do")
	public String view(int b_idx, Model model) {

		BoardVo vo = boardDao.selectOne(b_idx);

		// 현재 게시물을 봤냐?
		if (session.getAttribute("show") == null) {

			// 조회수 증가
			boardDao.updateReadHit(b_idx);

			// 봤다는 정보를 세션에 넣는다
			session.setAttribute("show", true);
		}

		model.addAttribute("vo", vo);
		return "board/board_view";
	}

	// 답글쓰기 폼 띄우기
	@RequestMapping("reply_form.do")
	public String reply_form() {
		return "board/board_reply_form";
	}

	// 수정폼 띄우기
	@RequestMapping("/modify_form.do")
	public String modify_form(int idx, Model model) {

		BoardVo vo = boardDao.selectOne(idx);

		String b_content = vo.getB_content().replaceAll("<br>", "\n");
		vo.setB_content(b_content);

		model.addAttribute("vo", vo);

		return "board/board_modify_form";
	}

	// 수정
	@RequestMapping("modify.do")
	public String modify(BoardVo vo,
						 @RequestParam(defaultValue="1") int page,
						 RedirectAttributes ra) {

		String b_content = vo.getB_content().replaceAll("<br>", "\n");
		vo.setB_content(b_content);

		boardDao.update(vo);

		return "redirect:list.do";
	}

	// 삭제
	@PostMapping("delete.do")
	public String delete(int b_idx,
						 @RequestParam(defaultValue="1") int page,
						 RedirectAttributes ra) {

		// ✅ insert와 동일하게 member로 통일
		MemberVo member = (MemberVo) session.getAttribute("member");
		if (member == null) return "redirect:/member/login_form.do";

		BoardVo target = boardDao.selectOne(b_idx);
		if (target == null) return "redirect:list.do";

		// ✅ m_admin: 0=일반, 1=사장, 2=관리자
		boolean isAdmin = (member.getM_admin() == 2); // 관리자만 전체 삭제 가능
		boolean isOwnerOfPost = (member.getM_idx() == target.getM_idx());

		if (!isAdmin && !isOwnerOfPost) {
			ra.addFlashAttribute("msg", "삭제 권한이 없습니다.");
			ra.addAttribute("page", page);
			return "redirect:view.do?b_idx=" + b_idx;
		}

		boardDao.delete(b_idx);
		ra.addAttribute("page", page);
		return "redirect:list.do";
	}
}
