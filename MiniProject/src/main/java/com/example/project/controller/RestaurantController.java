package com.example.project.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.project.dao.RestaurantDao;
import com.example.project.vo.MemberVo;
import com.example.project.vo.RestaurantVo;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/restaurant/*")
public class RestaurantController {

	@Autowired
	RestaurantDao restaurantDao;
	
	// 1. 관리 메인 대시보드
	@RequestMapping("dashboard.do")
	public String dashboard(HttpSession session, Model model) {
		MemberVo member = (MemberVo) session.getAttribute("member");
		if (member == null || member.getM_admin() != 1)
			return "redirect:/login_form.do";

		// 내 식당 정보 가져오기
		RestaurantVo rs = restaurantDao.selectOne(member.getM_idx());
		model.addAttribute("rs", rs);
		return "restaurant/dashboard";
	}

	// 2. 가게 정보 수정 페이지 진입
	@RequestMapping("modify_info.do")
	public String modifyInfo(HttpSession session, Model model) {
		MemberVo member = (MemberVo) session.getAttribute("member");
		if (member == null)
			return "redirect:/login_form.do";

		// DB에서 현재 내 식당의 최신 정보를 가져와서 수정 폼에 뿌려줌
		RestaurantVo rs = restaurantDao.selectOne(member.getM_idx());
		model.addAttribute("rs", rs);

		return "restaurant/modify_info";
	}

	// 3. 실제 수정 처리 (DB 업데이트)
	@RequestMapping("update.do")
	public String update(RestaurantVo vo) {
		restaurantDao.update(vo);
		// 수정한 뒤에는 다시 대시보드로 이동
		return "redirect:dashboard.do";
	}

	// 4. 예약 (추후 구현)
	@RequestMapping("reserve_list.do")
	public String reserveList() {
		return "restaurant/reserve_list";
	}

	@RequestMapping("review_manage.do")
	public String reviewManage(HttpSession session, Model model) {
		MemberVo member = (MemberVo) session.getAttribute("member");
		
		return "restaurant/review_manage";
	}
	
	// 5. 레스토랑 목록 표시 (r_place_id 기반으로 변경)
	@RequestMapping("rest_list.do")
	public String rest_list(String r_place_id, Model model) {
	    List<RestaurantVo> list;
	    
	    if (r_place_id != null && !r_place_id.trim().isEmpty()) {
	        // [수정] 유사 검색 대신 고유 ID로 정확히 조회
	        list = restaurantDao.selectListByPlaceId(r_place_id); 
	    } else {
	        list = restaurantDao.selectList(new HashMap<>()); // 전체 목록
	    }

	    model.addAttribute("list", list);
	    return "restaurant/rest_list";
	}
	
	// 5-1. 식당데이터입력form (아이디도 함께 전달받음)
	@RequestMapping("insert_form.do")
	public String insert_form(
	        @RequestParam(value="r_name", required=false) String r_name, 
	        @RequestParam(value="r_place_id", required=false) String r_place_id,
	        @RequestParam(value="r_addr", required=false) String r_addr,
	        Model model) {

	    model.addAttribute("r_name", r_name);
	    model.addAttribute("r_place_id", r_place_id);
	    model.addAttribute("r_addr", r_addr);
	    
	    return "restaurant/rest_insert_form";
	}
	
	// 5-2. 식당데이터입력
	
	@RequestMapping("test_insert.do")
	public String test_insert(RestaurantVo vo, HttpSession session, 
		   RedirectAttributes ra) {
		
		// 세션정보 소환
		MemberVo member = (MemberVo) session.getAttribute("member");
		// 비로그인시 로그인 유도
	    if(member == null){return "redirect:/login_form.do";}
	    // 현재 로그인유저 정보를 멤버정보에 추가
	    vo.setR_member(member.getM_idx());
		
		// DB insert
		int res = restaurantDao.insert(vo);
		
		return "/map/mapview";
	}
	
	@RequestMapping("mapview.do")
	public String mapview() {
	    return "mapview";
	}
	
	// 5-3. 데이터와 카카오 연결 (마커 클릭 시 호출)
	@PostMapping("/search.do")
	@ResponseBody
	public List<RestaurantVo> searchRestaurant(@RequestBody Map<String, String> param) {
	    // [수정] JS에서 보낸 r_place_id를 꺼냅니다.
	    String r_place_id = param.get("r_place_id");

	    // DB에서 고유 ID로 검색하여 결과 반환
	    return restaurantDao.selectListByPlaceId(r_place_id);
	}
	
	// 5-4 카카오 지도에서 클릭한 식당을 DB에 바로 등록
	@PostMapping("insert_from_kakao.do")
	@ResponseBody
	public Map<String, Object> insertFromKakao(@RequestBody Map<String, String> param, HttpSession session) {
	    Map<String, Object> result = new HashMap<>();

	    // [수정] param에서 직접 데이터를 꺼냅니다.
	    String name    = param.get("r_name");
	    String address = param.get("r_addr");
	    String r_place_id = param.get("r_place_id"); // [수정] 변수 선언 오류 해결
	    
	    MemberVo member = (MemberVo) session.getAttribute("member");
	    int memberIdx = (member != null) ? member.getM_idx() : 1;

	    RestaurantVo vo = new RestaurantVo();
	    vo.setR_name(name);
	    vo.setR_addr(address);
	    vo.setR_place_id(r_place_id); // [수정]
	    vo.setR_category("기타");
	    vo.setR_menu("메뉴 미등록");
	    vo.setR_avgscore(0.0);
	    vo.setR_member(memberIdx);

	    int res = restaurantDao.insert(vo);

	    if (res > 0) {
	        result.put("success", true);
	        result.put("message", "등록 성공");
	    } else {
	        result.put("success", false);
	        result.put("message", "DB 삽입 실패");
	    }
	    return result;
	}	// insertFormKakao
	
	// 6. 레스토랑 이름 일치 확인
	@RequestMapping("check_name.do")
	@ResponseBody
	public Map<String, Object> checkName(String r_name) {

	    Map<String, Object> map = new HashMap<>();
	    
	    // DB에서 이름으로 식당 정보를 가져옴 (VO가 null인지 체크)
	    List<RestaurantVo> list = restaurantDao.searchByName(r_name);	    
	    
	    RestaurantVo matchVo = null;
	    // 리스트가 존재하고 비어있지 않은지 확인
	    if (list != null && !list.isEmpty()) {

	        // 정확히 일치하는 이름을 찾기 위해 반복문을 돌리거나, 첫 번째 요소를 선택	        
	        for(RestaurantVo vo : list) {	  
	        	// trim()을 추가하여 공백 문제 차단
	        	if(vo.getR_name() != null && vo.getR_name().trim().equals(r_name.trim())) {
	                matchVo = vo;
	                break;
	            }
	        }	// for문 end
	        
	        // 완전히 일치하는 식당이 있는 경우
	        if(matchVo != null) {
	            map.put("exists", true);
	            map.put("r_idx", matchVo.getR_idx());
	        } else {
	            // 유사한 이름은 있으나 정확히 일치하는 이름은 없는 경우
	            map.put("exists", false);
	        }
	        
	    } else {
	        // 검색 결과가 아예 없는 경우
	        map.put("exists", false);
	    }
	    
	    return map;
	    
	}	// checkName
	
	// 7. 식당 데이터 삭제
	@RequestMapping("delete.do")
	public String delete(@RequestParam int r_idx, RedirectAttributes ra) {
		
		int res = restaurantDao.delete(r_idx);
		
		return "map/mapview";	
	}	// delete() fin	
	
}