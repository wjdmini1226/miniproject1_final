package com.example.project.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.project.dao.ReviewDao;
import com.example.project.vo.MemberVo;
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
	public String list(Model model, 
            @RequestParam(value="r_idx", required=false, defaultValue="0") int r_idx) {
		
		List<ReviewVo> list;
		
		// r_idx가 0이면(기본값) 전체 조회를 수행합니다.
	    if (r_idx == 0) {
	        list = reviewDao.selectList(); // 전체 리뷰 조회
	    } else {
	        // r_idx가 0이 아니면(특정 식당 선택 시) 해당 식당의 리뷰만 조회
	        list = reviewDao.selectOneRestaurantList(r_idx);
	    }
	    
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
	@ResponseBody // 에러 메시지를 자바스크립트로 출력하기 위해 추가
	public String insert(ReviewVo vo, HttpSession session) {
	    
	    // [검증 1] 로그인 체크 (m_idx가 세션에 있는지)
	    MemberVo member = (MemberVo) session.getAttribute("member");
	    if (member == null) {
	        return "<script>" +
	               "alert('로그인이 만료되었거나 필요한 서비스입니다.');" +
	               "location.href='/map/mapview.do';" +
	               "</script>";
	    }

	    // [검증 2] 식당 번호 체크 (r_idx가 0이거나 안 넘어왔는지)
	    if (vo.getR_idx() == 0) {
	        return "<script>" +
	               "alert('리뷰를 쓰기 위해 지도의 식당 마커를 다시 클릭해주세요.');" +
	               "location.href='/map/mapview.do';" +
	               "</script>";
	    }

	    try {
	        // [데이터 세팅] JSP에서 넘어온 값 대신 세션의 확실한 정보를 세팅
	        vo.setM_idx(member.getM_idx());

	        // [DB 저장]
	        int res = reviewDao.insert(vo);
	        
	        if(res > 0) {
	            // 평균 점수 갱신 로직
	            int r_idx = vo.getR_idx(); 
	            double newAvg = reviewDao.selectAvgScore(r_idx);
	            
	            // scoreMap을 따로 만들 필요 없이 직접 인자로 전달 (DAO의 @Param과 매칭)
	            reviewDao.updateRestaurantAvgScore(r_idx, newAvg);
	            
	            return "<script>" +
	                   "alert('리뷰가 성공적으로 등록되었습니다.');" +
	                   "location.href='/map/mapview.do';" +
	                   "</script>";
	        } else {
	            return "<script>alert('등록에 실패했습니다.'); history.back();</script>";
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        return "<script>alert('서버 오류가 발생했습니다.'); location.href='/map/mapview.do';</script>";
	    }
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
		
		return "map/mapview";
	}	// insert() fin
	
	// 리뷰 지우기
	@RequestMapping("delete.do")
	public String delete(@RequestParam int v_idx, RedirectAttributes ra) {
		
		int res = reviewDao.delete(v_idx);
		
		return "map/mapview";	// 임시로 list.do로 보낸다. 나중에 logout.do 로 수정해야
	}	// delete() fin		

}	// class reviewController
