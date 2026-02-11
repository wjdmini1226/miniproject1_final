package com.example.project.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.project.dao.T_CommentDao;
import com.example.project.vo.T_CommentVo;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/t_comment/")
public class T_CommentController {
	
	@Autowired
	T_CommentDao t_commentDao;
	
	@Autowired
	HttpServletRequest request;
	
	@Autowired
	HttpSession session;
	
	//CRUD위주로 먼저 작성해보자
	
	//댓글 조회
	@RequestMapping("list.do")
	public String list(int b_idx,@RequestParam(name="page", defaultValue="1")int nowPage, Model model) {
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("b_idx", b_idx);
		
		//start/end 계산
		int start = (nowPage-1) * com.example.project.constant.MyConstant.T_Comment.BLOCK_LIST+1;
		int end = start + com.example.project.constant.MyConstant.T_Comment.BLOCK_LIST-1;
		map.put("start", start);
		map.put("end", end);
		
		
		List<T_CommentVo> list = t_commentDao.selectListByBoard(b_idx);
		
		model.addAttribute("list",list);
		
		return "t_comment/t_comment_list";
	}
	
	@RequestMapping("insert.do")
	@ResponseBody
	public Map<String, Boolean> insertReply(T_CommentVo vo){
		
		int res = t_commentDao.insertReply(vo);
		
		Map<String, Boolean> map = new HashMap<String, Boolean>();
		map.put("result", (res==1));
		
		return map;
	}
	
	
	//삭제
		@RequestMapping("delete.do")
		@ResponseBody
		public Map<String, Boolean> delete(int c_idx) {
			
			
			int res = t_commentDao.delete(c_idx);
			
			// JSONConverter에 의해서 map -> json을 변환되서 반환
			Map<String, Boolean> map = new HashMap<String, Boolean>();
			map.put("result", (res==1));
			return map;
		}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
