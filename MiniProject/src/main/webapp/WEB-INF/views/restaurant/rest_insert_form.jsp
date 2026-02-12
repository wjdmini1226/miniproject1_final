<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>

<!-- Bootstrap 3.x -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

<html>
<head>
<meta charset="UTF-8">
<title>Test Rest Insert Form</title>

<!-- Daum 주소검색 API -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<style type="text/css">
	#box{		width:	600px;	margin:	auto;
				margin-top:	80px;			}	
	
	.common{	margin-bottom:	10px;		}
		
</style>

<script type="text/javascript">
	function send(f){
			let r_name 	 = f.r_name.value.trim();
			let r_category = f.r_category.value.trim();
			let r_menu 	 = f.r_menu.value.trim();
			let r_addr 	 = f.r_addr.value.trim();
			// db에 default 없으므로 최초 입력시 default를 추가
			// 유저에게는 보이지 않음
			let r_avescore = 5;
			let r_place_id = f.r_place_id.value.trim(); // 추가
			
			// 1. 필수 입력값(이름) 체크
			if(r_name==""){
				alert("식당명을 입력하세요");
				f.r_name.value="";
				f.r_name.focus();
				return;
			}			
			
			// 2. r_place_id 존재 여부 체크 (카카오맵 클릭을 안 하면 비정상 접근)
		    if(r_place_id==""){
		        alert("잘못된 접근입니다. 지도에서 식당 혹은 식당 마커를 선택해주세요.");
		        return;
		    }
			
		 	// 3. 중복된 r_place_id 체크 (AJAX)
		    $.ajax({
		        url: "/restaurant/search.do",
		        method: "POST",
		        contentType: "application/json",
		        data: JSON.stringify({ "r_place_id": r_place_id }),
		        success: function(data) {
		            // 결과가 리스트 형태로 오므로 길이가 0보다 크면 이미 등록된 것임
		            if (data && data.length > 0) {
		                alert("이미 존재하는 식당입니다. 다시 한 번 확인해주세요.");
		            } else {
		                // 중복이 없을 때만 최종 전송
		                f.method = "POST";
		                f.action = "test_insert.do";
		                f.submit();
		            }
		        },
		        error: function(err) {
		            console.error("중복 체크 중 오류 발생", err);
		            alert("서버 통신 중 오류가 발생했습니다.");
		        }
		    }); // $.ajax fin
	}	// send(f) fin
	
	function find_addr(){
		  
		  //주소찾기 창 띄우기
		  new daum.Postcode({
		        oncomplete: function(data) {
		            
		        	console.log(data);	        	
		        	
		        	//주소넣기
		        	$("#r_addr").val(data.address);
		        	
		        }
		  }).open(); 
		  
	  }//end: find_addr()
	
</script>

</head>
<body>

<form>

	<input type="hidden" name="r_place_id" value="${r_place_id}">

	<div id="box">	 
	 
		<!-- Bootstrap 3.x  Panel -->
		<div class="panel panel-primary">
			<div class="panel-heading">임시식당입력</div>
			<div class="panel-body">
				<!-- 1 식당이름 -->
				<div class="common">
					<label>식당이름</label>
					<input class="form-control" name="r_name" value="${r_name}">
				</div>
				
				<!-- 2 식당종류 -->
				<div class="common">
					<label>식당종류</label>
					<input class="form-control" name="r_category">
				</div>
				
				<!-- 3 식당메뉴 -->
				<div class="common">
					<label>식당메뉴</label>
					<input class="form-control" name="r_menu">
				</div>
				
				<!-- 4 식당주소 -->
				<div class="common">
					<label>식당주소</label>
					<input class="form-control" name="r_addr" id="r_addr" value="${param.r_addr}" readonly>
	                   <input class="btn btn-primary" type="button" value="주소찾기"
	                          onclick="find_addr();">
				</div>
				
				<!-- 이동 -->
				<div class="common" style="text-align: center;">
					<input	class="btn btn-success" type="button" value="식당목록으로" 
							onclick="location.href='/map/mapview.do'">
					<input	class="btn btn-primary" type="button" value="식당추가" 
							onclick="send(this.form);">
				</div>
				
			</div>
		</div>	
	</div>
	 
</form>

</body>
</html>