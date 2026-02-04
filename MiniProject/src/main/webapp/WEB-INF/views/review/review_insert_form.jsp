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
<title>Review Insert Form</title>

<style type="text/css">
	#box{		width:	600px;	margin:	auto;
				margin-top:	80px;			}
			
	textarea{	resize:	none;				}	
	
	.common{	margin-bottom:	10px;		}
		
</style>

<script type="text/javascript">
	function send(f){
			let v_title = f.v_title.value.trim();
			let v_content = f.v_content.value.trim();
			
			if(v_title==""){
				alert("제목을 입력하세요");
				f.v_title.value="";
				f.v_title.focus();
				return;
			}
			
			if(v_content==""){
				alert("내용을 입력하세요");
				f.v_content.value="";
				f.v_content.focus();
				return;
			}
			
			f.method="POST";
			f.action="insert.do";
			f.submit();		
	}	// send(f) fin
	
</script>

</head>
<body>

<form>
	 <div id="box">
		<!-- Bootstrap 3.x  Panel -->
		<div class="panel panel-primary">
			<div class="panel-heading">리뷰쓰기</div>
			<div class="panel-body">
				<!-- 제목 -->
				<div class="common">
					<label>제목</label>
					<input class="form-control" name="v_title">
				</div>
				
				<!-- 별점 -->
				<div class="common">
					<label>점수 선택:</label><br>
				    <label class="radio-inline">
				      <input type="radio" name="v_score" value="1"> 1
				    </label>
				    <label class="radio-inline">
				      <input type="radio" name="v_score" value="2"> 2
				    </label>
				    <label class="radio-inline">
				      <input type="radio" name="v_score" value="3"> 3
				    </label>
				    <label class="radio-inline">
				      <input type="radio" name="v_score" value="4"> 4
				    </label>
				    <label class="radio-inline">
				      <input type="radio" name="v_score" value="5"> 5
				    </label>
				</div>
				
				<!-- 내용 -->
				<div class="common">
					<label>내용</label>
					<textarea class="form-control" rows="6" cols="" name="v_content"></textarea>
				</div>
				
				<!-- 이동 -->
				<div class="common" style="text-align: center;">
					<input	class="btn btn-success" type="button" value="리뷰목록으로" 
							onclick="location.href='list.do'">
					<input	class="btn btn-primary" type="button" value="리뷰제출" 
							onclick="send(this.form);">
				</div>
				
			</div>
		</div>	
	</div>
	 
</form>

</body>
</html>