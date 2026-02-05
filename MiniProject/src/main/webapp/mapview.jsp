<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

  <!-- 대 카 오 -->
  <script type="text/javascript" 
  src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=60c46c644f3be913dd3a7af2d733d805&libraries=services"></script>

  <link rel="stylesheet" href="/mapSauce/css/kakaoMap.css">

  <!-- js분리 -->
  <script src="${pageContext.request.contextPath}/resources/js/kakaoMap.js"></script>

</head>
<body>

<div class="map_wrap">
    <div id="map" style="width:1000px;height:500px;position:relative;overflow:hidden;text-align:center;"></div>      
      
</div>

<div id="menu_wrap" class="bg_white">
        <div class="option">
            <div>
                <form onsubmit="searchPlaces(); return false;">
                    키워드 : <input type="text" value="대구 맛집" id="keyword" size="15"> 
                    <button type="submit">검색하기</button> 
                </form>
            </div>
        </div>
        <hr>
        <ul id="placesList"></ul>
        <div id="pagination"></div>        
</div>

</body>
</html>