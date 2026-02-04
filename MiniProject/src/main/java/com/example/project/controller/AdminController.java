package com.example.project.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.project.dao.MemberDao;
import com.example.project.dao.RestaurantDao;
import com.example.project.vo.MemberVo;

import jakarta.servlet.http.HttpSession;

@Controller
public class AdminController {
	@Autowired
    MemberDao member_dao;
    
    @Autowired
    RestaurantDao restaurant_dao;

    @RequestMapping("admin/main.do")
    public String adminMain(HttpSession session, Model model) {
        MemberVo member = (MemberVo) session.getAttribute("member");
        
        // 관리자 권한 체크 (m_admin이 2인 경우만 허용)
        if (member == null || member.getM_admin() != 2) {
            return "redirect:/login_form.do";
        }

        // 전체 회원 및 전체 식당 데이터 조회
        model.addAttribute("member_list", member_dao.selectList());
        model.addAttribute("restaurant_list", restaurant_dao.selectList_admin());
        
        return "admin/admin_main";
    }

    // 회원 강제 탈퇴 (이미 있는 delete 매퍼 활용)
    @RequestMapping("member_del.do")
    public String memberDel(int m_idx) {
        member_dao.delete(m_idx);
        return "redirect:main.do";
    }

    // 식당 정보 삭제 (이미 있는 delete 매퍼 활용)
    @RequestMapping("res_del.do")
    public String resDel(int r_idx) {
        restaurant_dao.delete(r_idx);
        return "redirect:main.do";
    }
}
