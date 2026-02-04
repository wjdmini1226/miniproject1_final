package com.example.project.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.project.dao.MemberDao;
import com.example.project.vo.MemberVo;

import jakarta.servlet.http.HttpSession;

@Controller
public class MemberController {
	@Autowired
	MemberDao memberDao;
	
	@Autowired
	HttpSession session;
	
	@RequestMapping("mypage.do")
	public String mypage(HttpSession session, Model model) {
		MemberVo member = (MemberVo) session.getAttribute("member");
		
		if (member == null) {
			return "redirect:login_form.do";
		}
		return "member/mypage";
	}
	
	@RequestMapping("modify_form.do")
	public String modify_form(Model model) {
		MemberVo user = (MemberVo) session.getAttribute("member");
		
		if (user == null) {
			return "redirect:login_form.do";
		}
		MemberVo member = memberDao.selectOne(user.getM_idx());
		
		model.addAttribute("member", member);
		
		return "member/modify_form";
	}
	
	@RequestMapping("modify.do")
	public String modify(MemberVo mVo) {
		int res = memberDao.update(mVo);
		
		if (res > 0) {
			MemberVo updateMember = memberDao.selectOne(mVo.getM_idx());
			session.setAttribute("member", updateMember);
			
			return "redirect:mypage.do?result=modify_success";
		}else {
			return "redirect:modify_form.do?result=modify_fail";
		}
	}
	
	@RequestMapping("delete.do")
	public String delete(String m_pwd, HttpSession session, RedirectAttributes ra) {
		MemberVo user = (MemberVo) session.getAttribute("member");
		
		if (user != null && user.getM_pwd().equals(m_pwd)) {
			int res = memberDao.delete(user.getM_idx());
			
			if (res > 0) {
				session.invalidate();
				return "redirect:home.do?result=delete_success";
			}
		}
		ra.addFlashAttribute("msg", "비밀번호가 일치하지 않습니다.");
		return "redirect:moidfy_form.do";
	}
}
