package com.example.project.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.project.dao.NewsDao;
import com.example.project.dao.NewsImagesDao;
import com.example.project.util.NewsImagesUtil;
import com.example.project.util.Paging;
import com.example.project.vo.MemberVo;
import com.example.project.vo.NewsImageVo;
import com.example.project.vo.NewsVo;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpSession;

@Controller
public class NewsController {
	final int PAGE_LENGTH = 10;
	final int PAGE_WINDOW = 5;
	
	@Autowired
	NewsDao newsDao;
	
	@Autowired
	NewsImagesDao newsImagesDao;

	@Autowired
	ServletContext application;
	
	@Autowired
	HttpSession session;
	
	@RequestMapping("/news/list.do")
	public String list(@RequestParam(defaultValue = "1") int page,Model model) {
		Map<String,Integer> map = new HashMap<String, Integer>();
		map.put("start"	,(page-1)*PAGE_LENGTH+1);
		map.put("end"	, page	 *PAGE_LENGTH);
		List<NewsVo> list = newsDao.selectPageList(map);
		model.addAttribute("list",list);
		model.addAttribute("paging", Paging.getPaging("/news/list.do", page, newsDao.selectRowTotal(), PAGE_LENGTH, PAGE_WINDOW));
		return "news/list";
	}
	
	@RequestMapping("/news/view.do")
	public String view(int n_idx,Model model,RedirectAttributes ra) {
		NewsVo vo = newsDao.selectOne(n_idx);
		if(vo==null) {
			ra.addAttribute("reason", "no news");
			return "redirect:list.do";
		}
		newsDao.read_update(n_idx);
		model.addAttribute("vo", vo);
		return "news/view";
	}
	
	@RequestMapping("/news/insert_form.do")
	public String insert_form(RedirectAttributes ra) {
		MemberVo member = (MemberVo) session.getAttribute("member");
		if(member==null||member.getM_admin()==0) {
			ra.addAttribute("reason", "invalid access");
			return "redirect:list.do";
		}
		return "news/insert_form";
	}
	
	@RequestMapping("/news/insert.do")
	public String insert(NewsVo vo,String images,RedirectAttributes ra) {
		MemberVo member = (MemberVo) session.getAttribute("member");
		if(member==null||member.getM_admin()==0) {
			ra.addAttribute("reason", "invalid access");
			return "redirect:list.do";
		}
		int res = newsDao.insert(vo);
		if(res==0)
			ra.addAttribute("reason","insert failed");
		if(!images.isEmpty())
			for(String image : images.split("/"))
				NewsImagesUtil.insert(newsImagesDao, image, vo.getN_idx());
		return "redirect:list.do";
	}
	@RequestMapping("/news/update_form.do")
	public String update_form(int n_idx,Model model,RedirectAttributes ra) {
		MemberVo member = (MemberVo) session.getAttribute("member");
		if(member==null||member.getM_admin()==0) {
			ra.addAttribute("reason", "invalid access");
			return "redirect:list.do";
		}
		NewsVo vo = newsDao.selectOne(n_idx);
		if(vo==null) {
			ra.addAttribute("reason","no news");
			return "redirect:list.do";
		}
		model.addAttribute("vo", vo);
		return "news/insert_form";
	}
	@RequestMapping("/news/update.do")
	public String update(NewsVo vo,String images,RedirectAttributes ra) {
		MemberVo member = (MemberVo) session.getAttribute("member");
		if(member==null||member.getM_admin()==0) {
			ra.addAttribute("reason", "invalid access");
			return "redirect:list.do";
		}
		int res = newsDao.update(vo);
		if(res==0)
			ra.addAttribute("reason","update failed");
		else {
			List<NewsImageVo> previousImages = newsImagesDao.selectNews(vo.getN_idx());
			for(NewsImageVo prev: previousImages) {
				newsImagesDao.delete(prev.getN_i_idx());
				NewsImagesUtil.delete(newsImagesDao,application,prev.getN_i_name());
			}
			if(!images.isEmpty())
				for(String image : images.split("/"))
					NewsImagesUtil.insert(newsImagesDao, image, vo.getN_idx());
		}
		return "redirect:list.do";
	}
	@RequestMapping("/news/delete.do")
	public String delete(int n_idx,RedirectAttributes ra) {
		MemberVo member = (MemberVo) session.getAttribute("member");
		if(member==null||member.getM_admin()==0) {
			ra.addAttribute("reason", "invalid access");
			return "redirect:list.do";
		}
		List<NewsImageVo> images = newsImagesDao.selectNews(n_idx);
		int res = newsDao.delete(n_idx);
		if(res==0)
			ra.addAttribute("reason","delete failed");
		newsImagesDao.deleteNews(n_idx);
		for(NewsImageVo image:images)
			NewsImagesUtil.delete(newsImagesDao,application,image.getN_i_name());
		return "redirect:list.do";
	}
}
