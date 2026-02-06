<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>    
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

  <!-- Bootstrap 3.x -->
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

  <!-- 카카오산 api -->
  <script type="text/javascript" 
  src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=60c46c644f3be913dd3a7af2d733d805&libraries=services"></script>

  <!-- map CSS -->
  <link rel="stylesheet" href="/mapSauce/css/kakaoMap.css">

  <!-- 카카오산 js 분리 -->
  <script src="${pageContext.request.contextPath}/mapSauce/js/kakaoMap.js"></script>

  <!-- review용 js -->
  
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
		data	:	{
		//			"b_idx" : "${ vo.b_idx }",
		//			"page"	: page
					},
		dataType:	"html",			
		success	:	function(res_data){						
					// 댓글목록을 ip=review인 div 넣는다
					$("#review").html(res_data);
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
 
</script><!-- review용 js 끝 -->

</head>
<body>

<div class="layout">          
	
	<!-- 좌측 : 목록 -->
	<div id="menu_wrap" class="bg_white">
	        <div class="option">	            
	            <form onsubmit="searchPlaces(); return false;">
	                키워드 : <input type="text" value="대구 맛집" id="keyword" size="15"> 
	                <button type="submit">검색하기</button> 
	            </form>
	            
	        </div>
	        <hr>
	        <ul id="placesList"></ul>
	        <div id="pagination"></div>        
	</div>
	
	<!-- 우측 : 지도+리뷰 -->
		<!-- 지도 -->
		<div id="map"></div>
		
		<!-- 식당영역 -->
		<div id="rest_list"></div>
		
		<!-- 리뷰영역 -->
		<div id="review"></div>
      
</div><!-- layout end -->

</body>
</html>