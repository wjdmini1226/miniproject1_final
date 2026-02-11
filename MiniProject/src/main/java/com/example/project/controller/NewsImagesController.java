package com.example.project.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.example.project.dao.NewsImagesDao;
import com.example.project.util.NewsImagesUtil;
import com.example.project.vo.NewsImageVo;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpServletRequest;

@Controller
public class NewsImagesController {
	List<String> orphans = new ArrayList<String>();
	@Autowired
	NewsImagesDao newsImagesDao;
	
	@Autowired
	ServletContext application;
	
	@Autowired
	HttpServletRequest request;
	
	@RequestMapping("/news_images/upload.do")
	@ResponseBody
	public Map<String, Object> upload(@RequestParam(name="upload") MultipartFile photo) throws IllegalStateException, IOException {
		String webPath = "/news_images/";
		String absPath = application.getRealPath(webPath);
		String p_filename="no_file";
		if(!photo.isEmpty()) {
			p_filename = photo.getOriginalFilename();
			File f = new File(absPath, p_filename);
			if(f.exists()) {
				long tm = System.currentTimeMillis();
				p_filename = String.format("%d_%s", tm, p_filename);
				f = new File(absPath, p_filename);
			}
			// news_images에도 추가
			photo.transferTo(f);
			newsImagesDao.insertNull(p_filename);
		}
		
		String url = request.getRequestURL().toString().replaceAll("/news_images/upload.do", "");
		url = String.format("%s/news_images/%s", url,p_filename);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("filename", p_filename);
		map.put("uploaded",1);
		map.put("url", url);
		return map;
	}
	
	@RequestMapping("/news_images/delete.do")
	@ResponseBody
	public Map<String, Boolean> delete(String filename){
		Map<String, Boolean> map  = new HashMap<String, Boolean>();
		boolean bResult = NewsImagesUtil.delete(newsImagesDao,application,filename);
		map.put("result", bResult);
		return map;
	}
	
	@Scheduled(cron = "0 0 * * * *")
	public void checkImages() {
		String webPath = "/news_images/";
		String absPath = application.getRealPath(webPath);
		List<String> knownNames = newsImagesDao.getNames();
		// 등록되지 않은 이미지가 있다면 지우기 (실제로는 일어나지 않아야 함)
		for(File f : new File(absPath).listFiles())
			if(!knownNames.contains(f.getName()))
				NewsImagesUtil.delete(newsImagesDao, application, f.getName());
		// 적어도 한 시간이 지나도 기사에 등록되지 않은 이미지는 삭제됨
		for(String name : orphans)
			NewsImagesUtil.delete(newsImagesDao, application, name);
		// 다시 기사에 등록되지 않은 이미지를 찾는다
		orphans.clear();
		for(NewsImageVo orphan: newsImagesDao.selectOrphans())
			if(newsImagesDao.selectName(orphan.getN_i_name()).isEmpty())
				orphans.add(orphan.getN_i_name());
			else
				newsImagesDao.delete(orphan.getN_i_idx());
	}
}
