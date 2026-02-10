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
			let t_r_name 	 = f.t_r_name.value.trim();
			let t_r_category = f.t_r_category.value.trim();
			let t_r_menu 	 = f.t_r_menu.value.trim();
			let t_r_addr 	 = f.t_r_addr.value.trim();
			
			
			if(t_r_name==""){
				alert("식당명을 입력하세요");
				f.t_r_name.value="";
				f.t_r_name.focus();
				return;
			}			
			
			f.method="POST";
			f.action="test_insert.do";
			f.submit();		
	}	// send(f) fin
	
	function find_addr(){
		  
		  //주소찾기 창 띄우기
		  new daum.Postcode({
		        oncomplete: function(data) {
		            
		        	console.log(data);	        	
		        	
		        	//주소넣기
		        	$("#t_r_addr").val(data.address);
		        	
		        }
		  }).open(); 
		  
	  }//end: find_addr()
	
</script>

</head>
<body>

<form>
	 <div id="box">
		<!-- Bootstrap 3.x  Panel -->
		<div class="panel panel-primary">
			<div class="panel-heading">임시식당입력</div>
			<div class="panel-body">
				<!-- 1 식당이름 -->
				<div class="common">
					<label>식당이름</label>
					<input class="form-control" name="t_r_name">
				</div>
				
				<!-- 2 식당종류 -->
				<div class="common">
					<label>식당종류</label>
					<input class="form-control" name="t_r_category">
				</div>
				
				<!-- 3 식당메뉴 -->
				<div class="common">
					<label>식당메뉴</label>
					<input class="form-control" name="t_r_menu">
				</div>
				
				<!-- 4 식당평점 -->
				<div class="common">
					<label>식당평점</label>
					<input class="form-control" name="t_r_avgscore">
				</div>
				
				<!-- 5 식당주소 -->
				<div class="common">
					<label>식당주소</label>
					<input class="form-control" name="t_r_addr" id="t_r_addr">
                    <input class="btn btn-primary" type="button" value="주소찾기"
                           onclick="find_addr();">
				</div>
				
				<!-- 이동 -->
				<div class="common" style="text-align: center;">
					<input	class="btn btn-success" type="button" value="식당목록으로" 
							onclick="location.href='mapview.jsp'">
					<input	class="btn btn-primary" type="button" value="식당추가" 
							onclick="send(this.form);">
				</div>
				
			</div>
		</div>	
	</div>
	 
</form>

</body>
</html>