<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

  <!-- 카카오산 api -->
  <script type="text/javascript" 
  src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=60c46c644f3be913dd3a7af2d733d805&libraries=services"></script>

  <link rel="stylesheet" href="/mapSauce/css/kakaoMap.css">

  <!-- 카카오산 js 분리 -->
  <script src="${pageContext.request.contextPath}/mapSauce/js/kakaoMap.js"></script>

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
		
		<!-- 리뷰영역 -->
      
</div><!-- layout end -->

</body>
</html>