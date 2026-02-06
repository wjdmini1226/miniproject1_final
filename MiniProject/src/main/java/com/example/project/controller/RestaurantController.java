package com.example.project.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

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
	public String rest_list(Model model) {
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		// List<RestaurantVo> list = restaurantDao.selectList(map);
		List<TestRestVo> list = testRestDao.selectList(map);
		
		model.addAttribute("list", list);
		
		return "restaurant/rest_list";
	}
	
	// 5-1. 테스트용임시데이터입력form
	@RequestMapping("test_insert_form.do")
	public String test_insert(HttpSession session, Model model) {		
		return "restaurant/test_rest_insert";
	}
}