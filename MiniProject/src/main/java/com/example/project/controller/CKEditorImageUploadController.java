package com.example.project.controller;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpServletRequest;

@Controller
public class CKEditorImageUploadController {

	
	@Autowired
	ServletContext application;
	
	@Autowired
	HttpServletRequest request;
	
	@RequestMapping("/ckeditorImageUpload.do")
	@ResponseBody
	public Map<String, Object> impageUpload(@RequestParam(name="upload") MultipartFile photo) throws IllegalStateException, IOException {
		
		//상대경로(웹경로) -> 절대경로(저장경로)
		String webPath = "/images/";
		String absPath = application.getRealPath(webPath);
		//System.out.println(absPath);
		
		
		String p_filename="no_file";
		
		if(!photo.isEmpty()) { //업로드화일이 있으면
			
			p_filename = photo.getOriginalFilename();
			//저장할 화일정보
			File f = new File(absPath, p_filename);
			
			if(f.exists()) { //같은이름의 화일이 존재하면
				
				long tm = System.currentTimeMillis();
				p_filename = String.format("%d_%s", tm, p_filename);
				
				f = new File(absPath, p_filename);
			}
			
			//임시화일->f로 지정된 화일로 복사
			photo.transferTo(f);
		}
		
		String url = request.getRequestURL().toString().replaceAll("/ckeditorImageUpload.do", "");
		
		url = String.format("%s/images/%s", url,p_filename);
		
		Map<String, Object> map  = new HashMap<String, Object>();
		
		map.put("filename", p_filename);
		map.put("uploaded",1);
		map.put("url", url);
		
		//System.out.println(map);
		
		return map;
	}
	
	
	
	@RequestMapping("/ckeditorImageDelete.do")
	@ResponseBody
	public Map<String, Boolean> ckeditorImageDelete(String filename){
		
		//System.out.println(filename);
		
		//상대경로(웹경로) -> 절대경로(저장경로)
		String webPath = "/images/";
		String absPath = application.getRealPath(webPath);
		
		//삭제할 화일정보
		File f = new File(absPath, filename);
		boolean bResult = f.delete();
		
		Map<String, Boolean> map  = new HashMap<String, Boolean>();
		map.put("result", bResult);
		return map;
		
	}
	
	
}
