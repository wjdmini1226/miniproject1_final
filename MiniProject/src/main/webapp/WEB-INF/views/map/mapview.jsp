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

  <!-- CSS -->
  <link rel="stylesheet" href="/mapSauce/css/kakaoMap.css"> 

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
		url		:	"${pageContext.request.contextPath}/review/list.do",
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
		url		:	"${pageContext.request.contextPath}/restaurant/rest_list.do",
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

function review_delete(f){
	
	if(!confirm("정말 이 리뷰를 삭제하시겠습니까?")) return;

    var v_idx = f.v_idx.value; // form 내의 hidden input 값 읽기 

    $.ajax({
        url     : "${pageContext.request.contextPath}/review/delete.do",
        type    : "GET", // 또는 POST (컨트롤러 설정에 맞춤)
        data    : { "v_idx": v_idx },
        success : function(res_data) {
            alert("리뷰가 삭제되었습니다.");
            // 삭제 후 목록을 다시 불러와 화면 갱신 
            location.replace("${pageContext.request.contextPath}/map/mapview.do"); 
        },
        error   : function(err) {
            alert("삭제 실패: " + err.responseText);
        }
    });
	
}	// review_delete(f) end

function rest_delete(f){
	
	if(!confirm("정말 이 식당 정보를 삭제하시겠습니까?")) return;

    var r_idx = f.r_idx.value; // form 내의 hidden input 값 읽기 

    $.ajax({
        url     : "${pageContext.request.contextPath}/restaurant/delete.do",
        type    : "GET", // 또는 POST (컨트롤러 설정에 맞춤)
        data    : { "r_idx": r_idx },
        success : function(res_data) {
            alert("식당 데이터가 삭제되었습니다.");
            // 삭제 후 목록을 다시 불러와 화면 갱신 
            location.replace("${pageContext.request.contextPath}/map/mapview.do");
        },
        error   : function(err) {
            alert("삭제 실패: " + err.responseText);
        }
    });
	
}	// rest_delete(f) end
 
</script><!-- review/rest용 js 끝 -->

</head>
<body>
  <!--  
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

<div class="main_container">
    <div class="left_section">
        <div id="menu_wrap">
            <div class="option">
                <form onsubmit="searchPlaces(); return false;">
                    키워드 : <input type="text" value="대구 맛집" id="keyword" size="10"> 
                    <button type="submit">검색</button> 
                </form>
            </div>
            <hr>
            <ul id="placesList"></ul>
            <div id="pagination"></div>
        </div>
        <div id="map"></div>
    </div>

    <div class="right_section">
        <div id="rest_list_wrap" class="list_panel">
            <h4 style="font-weight:bold;">📍 주변 식당 목록</h4>
            <div id="rest_list">
                <p class="text-muted">마커를 클릭하면 식당 정보가 표시됩니다.</p>
            </div>
        </div>
        
        <div id="review_list_wrap" class="list_panel">
            <div id="review_list">
                <p class="text-muted">식당을 선택하면 리뷰가 표시됩니다.</p>
            </div>
        </div>
    </div>
</div>

</body>
</html>