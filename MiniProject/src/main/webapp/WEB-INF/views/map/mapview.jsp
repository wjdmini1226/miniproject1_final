<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>    
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>지도+식당검색</title>

  <!-- Bootstrap 3.x -->
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

  <!-- 카카오산 api -->
  <script type="text/javascript" 
  src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=60c46c644f3be913dd3a7af2d733d805&libraries=services"></script>

  <!-- map 전용 CSS -->
  <link rel="stylesheet" href="/mapSauce/css/kakaoMap.css">
  
  <style>

/* 전체 레이아웃 */
.layout { display: flex; flex-direction: column; width: 100%; height: auto; }

/* 지도 아래 목록 영역 (가로 배치) */
.content_bottom_area {
    display: flex;
    padding: 20px;
    gap: 20px;
    background-color: #f8f9fa;
    border-top: 1px solid #ddd;
}

/* 식당/리뷰 박스 스타일 */
#rest_list_wrap, #review_wrap {
    flex: 1; /* 너비를 반반씩 */
    background: white;
    border: 1px solid #ddd;
    border-radius: 8px;
    padding: 15px;
    max-height: 500px; /* 너무 길면 내부 스크롤 */
    overflow-y: auto;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
}

/* 검색창(기존 menu_wrap) 위치 고정 */
#menu_wrap {
    position: absolute; /* 지도 위에 띄움 */
    top: 10px;
    left: 10px;
    z-index: 2; /* 지도보다 위로 */
    width: 300px; /* 너비 적절히 조절 */
    height: 550px;
    background: rgba(255, 255, 255, 0.9);
    overflow-y: auto;
}
  </style>

  <!-- 카카오산 js 분리 -->
  <script src="${pageContext.request.contextPath}/mapSauce/js/kakaoMap.js"></script>

  <!-- review/rest용 js -->
  
<script type="text/javascript">
  
//jQuery 초기화되면 댓글 1번목록으로 돌아가라
//$(function(){comment_list(1);});
$(document).ready(function(){
	console.log("페이지 로딩됨");
	review_list();
	rest_list(); // 나중에는 일치함수를 별도로 만들어서 대체해넣자
});
  
function review_list(){		
	
	// 현재 보고 있는 page 정보를 전역변수에 저장
	// g_current_comment_page = page;
	// 이것 살리려면 함수 이름은 review_list(page){}로 간다
	
	// ajax로 요청
	$.ajax({
		url		:	"../review/list.do",
		dataType:	"html",			
		success	:	function(res_data){
					$("#review_list").html(res_data);
					},
		error	:	function(err){ alert(err.responseText); }	
	})
}	// review_list() end

function rest_list(){		
	
	// 현재 보고 있는 page 정보를 전역변수에 저장
	// g_current_comment_page = page;
	// 이것 살리려면 함수 이름은 review_list(page){}로 간다
	
	// ajax로 요청
	$.ajax({
		url		:	"../restaurant/rest_list.do",
		data	:	{
		//			"b_idx" : "${ vo.b_idx }",
		//			"page"	: page
					},
		dataType:	"html",			
		success	:	function(res_data){						
					// 댓글목록을 ip=review인 div 넣는다
					$("#rest_list").html(res_data);
					},
		error	:	function(err){ alert(err.responseText); }	
	})
}	// restaurant_list() end

	
 
</script><!-- review/rest용 js 끝 -->

</head>
<body>
  
<div class="layout">
    <div style="display: flex; width: 100%; height: 500px; border-bottom: 1px solid #ddd;"">
    	<div id="menu_wrap" class="bg_white">
    		<div class="option">
       			<form onsubmit="searchPlaces(); return false;">
            		키워드 : <input type="text" value="대구 맛집" id="keyword" size="10"> 
           		 <button type="submit">검색하기</button> 
        		</form>
    		</div>
    		<hr>
    		<ul id="placesList"></ul>
    		<div id="pagination"></div>
    	</div>
    	<div id="map"></div>
	</div>

	<div class="content_bottom_area" style="display: flex; gap: 20px; padding: 20px;">
	    <div id="rest_list_wrap" style="flex: 1; min-height: 400px; border: 1px solid #ddd; background: white; overflow-y: auto;">
	        <div id="rest_list" style="padding: 15px;">
	            <p class="text-muted">마커를 클릭하면 주변 식당이 표시됩니다.</p>
	        </div>
	    </div>

	    <div id="review_list_wrap" style="flex: 1; min-height: 400px; border: 1px solid #ddd; background: white; overflow-y: auto;">
	        <div id="review_list" style="padding: 15px;">
	            <p class="text-muted">식당을 선택하면 리뷰가 표시됩니다.</p>
	        </div>
	    </div>
	</div>
</div><!-- layout end -->

</body>
</html>