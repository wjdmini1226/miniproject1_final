package com.example.project.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.project.dao.MemberDao;
import com.example.project.dao.RestaurantDao;
import com.example.project.service.LoginService;
import com.example.project.vo.MemberVo;
import com.example.project.vo.RestaurantVo;

import jakarta.servlet.http.HttpSession;

@Controller
public class HomeController {

	@Autowired
	MemberDao memberDao;

	@Autowired
	HttpSession session;

	@Autowired
	LoginService service;
	
	@Autowired
	RestaurantDao restaurantDao;

	@RequestMapping("home.do")
	public String home() {
		return "home";
	}

	@RequestMapping("login_form.do")
	public String login_form() {
		return "login_form";
	}

	@RequestMapping("login.do")
	public String login(String m_id, String m_pwd, HttpSession session) {
		MemberVo member = memberDao.selectById(m_id);

		if (member != null && member.getM_pwd().equals(m_pwd)) {
			session.setAttribute("member", member);

			return "redirect:home.do";
		}
		return "redirect:login_form.do?result=failed";
	}

	@RequestMapping("logout.do")
	public String logout() {
		session.removeAttribute("member");

		return "redirect:home.do?result=logout";
	}

	@RequestMapping("insert.do")
	public String insert1(MemberVo mVo, RestaurantVo rVo) {
		if (rVo.getR_menu() == null || rVo.getR_menu().trim().isEmpty()) {
			rVo.setR_menu("등록된 메뉴가 없습니다. 설정 페이지에서 메뉴를 등록해 주세요!");
		}
		try {
			service.insertMember(mVo, rVo);
			return "redirect:login_form.do?join=success";
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			return "redirect:login_form.do?error=fail";
		}
	}

	@RequestMapping("insert_type.do")
	public String insert_type() {
		return "insert_type";
	}

	@RequestMapping("insert_form.do")
	public String insert_form() {
		return "insert_form";
	}

	@RequestMapping("checkDuplicate.do")
	@ResponseBody
	public Map<String, Object> checkDuplicate(@RequestParam Map<String, Object> params) {
		Map<String, Object> result = new HashMap<String, Object>();
		int count = memberDao.checkDuplicate(params);

		result.put("isDuplicate", count > 0);
		result.put("msg", count > 0 ? "이미 사용 중 입니다." : "사용 가능 합니다.");

		return result;
	}

	@RequestMapping("checkNickname.do")
	@ResponseBody
	public Map<String, Object> checkNickname(String m_nickname) {
		Map<String, Object> result = new HashMap<>();
		// memberDao에 닉네임 중복 체크용 메서드(예: checkNickname)가 있다고 가정
		int count = memberDao.checkNickname(m_nickname);

		result.put("count", count);
		result.put("msg", count > 0 ? "이미 사용 중인 닉네임입니다." : "사용 가능한 닉네임입니다.");
		return result;
	}
}
