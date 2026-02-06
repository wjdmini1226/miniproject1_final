package com.example.project.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.project.dao.ReviewDao;
import com.example.project.vo.ReviewVo;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/review/")
public class ReviewController {
	
	@Autowired
	ReviewDao reviewDao;
	
	@Autowired
	HttpServletRequest request;
	
	@Autowired
	HttpSession session;
	
	// 전체조회
	@RequestMapping("list.do")
	public String list(Model model) {	
		// vo, dao와 연결하여 list 객체 생성
		List<ReviewVo> list = reviewDao.selectList();	
		// model에 list 담기
		model.addAttribute("list", list);	
		
		return "review/review_list";		
	}	// list() fin
	
	//리뷰쓰기 폼 띄우기
	@RequestMapping("insert_form.do")
	public String insert_form() { 
		return "review/review_insert_form";
	}	// insert_form() fin
	
	// 작성폼에서 내용 받아서 db에 끼워넣기
	@PostMapping("insert.do")
	public String insert(ReviewVo vo, RedirectAttributes ra) {
		
		// 내용 : \n -> <br> 변경
		String v_content = vo.getV_content().replaceAll("\n", "<br>");		
		
		// DB insert
		int res = reviewDao.insert(vo);
		
		return "redirect:list.do";
	}	// insert() fin
	
	//리뷰수정 폼 띄우기
	@RequestMapping("modify_form.do")
	public String modify_form(@RequestParam int v_idx, Model model) {
		
			// v_idx를 이용해 리뷰 하나를 찾아서 담기
			ReviewVo vo = reviewDao.selectOneReview(v_idx);	
			
			// model에 list 담기
			model.addAttribute("vo", vo);			
			
			return "review/review_modify_form";
	}	// modify_form() fin
		
	// 수정폼에서 내용 받아서 db에 끼워넣기
	@PostMapping("modify.do")
	public String modify(ReviewVo vo, RedirectAttributes ra) {
		
		// 내용 : \n -> <br> 변경
		String v_content = vo.getV_content().replaceAll("\n", "<br>");
		
		// DB insert
		int res = reviewDao.update(vo);
		
		return "redirect:list.do";
	}	// insert() fin
	
	// 리뷰 지우기
	@RequestMapping("delete.do")
	public String delete(@RequestParam int v_idx, RedirectAttributes ra) {
		
		int res = reviewDao.delete(v_idx);
		
		return "redirect:list.do";	// 임시로 list.do로 보낸다. 나중에 logout.do 로 수정해야
	}	// delete() fin		

}	// class reviewController
