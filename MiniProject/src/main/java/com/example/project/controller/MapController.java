package com.example.project.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/map/")
public class MapController {
	
	//1. mapview 호출
	@RequestMapping("mapview.do")
	public String mapView() {
		return "map/mapview";
	}

}
