package com.example.project.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.project.dao.RestaurantDao;
import com.example.project.dao.TestRestDao;
import com.example.project.vo.MemberVo;
import com.example.project.vo.RestaurantVo;
import com.example.project.vo.TestRestVo;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/restaurant/*")
public class RestaurantController {

	@Autowired
	RestaurantDao restaurantDao;
	
	@Autowired
	TestRestDao testRestDao;
	
	// 1. 관리 메인 대시보드
	@RequestMapping("dashboard.do")
	public String dashboard(HttpSession session, Model model) {
		MemberVo member = (MemberVo) session.getAttribute("member");
		if (member == null || member.getM_admin() != 1)
			return "redirect:/login_form.do";

		// 내 식당 정보 가져오기
		RestaurantVo rs = restaurantDao.selectOne(member.getM_idx());
		model.addAttribute("rs", rs);
		return "restaurant/dashboard";
	}

	// 2. 가게 정보 수정 페이지 진입
	@RequestMapping("modify_info.do")
	public String modifyInfo(HttpSession session, Model model) {
		MemberVo member = (MemberVo) session.getAttribute("member");
		if (member == null)
			return "redirect:/login_form.do";

		// DB에서 현재 내 식당의 최신 정보를 가져와서 수정 폼에 뿌려줌
		RestaurantVo rs = restaurantDao.selectOne(member.getM_idx());
		model.addAttribute("rs", rs);

		return "restaurant/modify_info";
	}

	// 3. 실제 수정 처리 (DB 업데이트)
	@RequestMapping("update.do")
	public String update(RestaurantVo vo) {
		restaurantDao.update(vo);
		// 수정한 뒤에는 다시 대시보드로 이동
		return "redirect:dashboard.do";
	}

	// 4. 예약 (추후 구현)
	@RequestMapping("reserve_list.do")
	public String reserveList() {
		return "restaurant/reserve_list";
	}

	@RequestMapping("review_manage.do")
	public String reviewManage(HttpSession session, Model model) {
		MemberVo member = (MemberVo) session.getAttribute("member");
		
		// List<ReviewVo> list = reviewDao.selectList(r_idx);
	    // model.addAttribute("review_list", list);
		
		return "restaurant/review_manage";
	}
	
	// 5. 레스토랑 목록 표시
	@RequestMapping("rest_list.do")
	public String rest_list(String name, String address, Model model) {
	    List<TestRestVo> list;
	    Map<String, Object> map = new HashMap<>(); // String, String 대신 Object 권장
	    
	    if (name != null && !name.trim().isEmpty()) {
	        // 검색어가 있는 경우 (마커 클릭)
	        String keyword = name.length() >= 2 ? name.substring(0, 2) : name;
	        
	        map.put("name", name);
	        map.put("keyword", keyword);
	        map.put("address", address);
	        
	        list = testRestDao.findSimilarRestaurant(map); // 이제 타입이 일치함!
	    } else {
	        // 전체 목록
	        list = testRestDao.selectList(map);
	    }

	    model.addAttribute("list", list);
	    return "restaurant/rest_list";
	}
	
	// 5-1. 테스트용임시데이터입력form
	@RequestMapping("test_insert_form.do")
	public String test_insert_form(HttpSession session, Model model) {		
		return "restaurant/test_rest_insert";
	}
	
	// 5-2. 테스트용임시데이터입력
	
	@RequestMapping("test_insert.do")
	public String test_insert(TestRestVo vo, HttpSession session, 
		   RedirectAttributes ra) {
		
		// 세션정보 소환
		MemberVo member = (MemberVo) session.getAttribute("member");
		// 비로그인시 로그인 유도
	    if(member == null){return "redirect:/login_form.do";}
	    // 현재 로그인유저 정보를 멤버정보에 추가
	    vo.setT_r_member(member.getM_idx());
		
		// DB insert
		int res = testRestDao.insert(vo);
		
		return "redirect:/mapview.do";
	}
	
	@RequestMapping("mapview.do")
	public String mapview() {
	    return "mapview";
	}
	
	// 5-3. 테스트데이터와 카카오 연결
	@PostMapping("/search.do")
	@ResponseBody
	public List<TestRestVo> searchRestaurant(@RequestBody Map<String, String> param) {

		// 안전하게 null 체크
	    String name = param.getOrDefault("name", "").replaceAll("\\s+", "");
	    String address = param.getOrDefault("address", "");
	    String keyword = name.length() >= 2 ? name.substring(0, 2) : name;

	    System.out.println("검색 요청 → name: " + name + ", keyword: " + keyword);

	    // Map으로 넘김
	    Map<String, Object> map = new HashMap<>();
	    map.put("name", name);
	    map.put("keyword", keyword);
	    map.put("address", address);

	    return testRestDao.findSimilarRestaurant(map);
	}
	
	// 카카오 지도에서 클릭한 식당을 DB에 바로 등록
	@PostMapping("insert_from_kakao.do")
	@ResponseBody
	public Map<String, Object> insertFromKakao(@RequestBody Map<String, String> param, HttpSession session) {

	    Map<String, Object> result = new HashMap<>();

	    String name    = param.get("name");
	    String address = param.get("address");

	    // 로그인 안 한 경우 테스트용으로 member_idx = 1 사용
	    MemberVo member = (MemberVo) session.getAttribute("member");
	    int memberIdx = (member != null) ? member.getM_idx() : 1;

	    TestRestVo vo = new TestRestVo();
	    vo.setT_r_name(name);
	    vo.setT_r_addr(address);
	    vo.setT_r_category("기타");
	    vo.setT_r_menu("메뉴 미등록");
	    vo.setT_r_avgscore(0.0);
	    vo.setT_r_member(memberIdx);

	    int res = testRestDao.insert(vo);

	    if (res > 0) {
	        result.put("success", true);
	        result.put("message", "등록 성공");
	    } else {
	        result.put("success", false);
	        result.put("message", "DB 삽입 실패");
	    }

	    return result;
	}
	
}