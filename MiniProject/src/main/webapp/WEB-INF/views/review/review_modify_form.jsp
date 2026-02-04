<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>

<!-- Bootstrap 3.x -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

<!-- CKEditor 4 -->
<script src="https://cdn.ckeditor.com/4.22.1/full/ckeditor.js"></script>

<html>
<head>
<meta charset="UTF-8">
<title>Review Modify Form</title>

<style type="text/css">
	#box{		width:	600px;	margin:	auto;
				margin-top:	80px;			}
			
	textarea{	resize:	none;				}	
	
	.common{	margin-bottom:	10px;		}
		
</style>

<script type="text/javascript">
	function send(f){
			let v_title = f.v_title.value.trim();
			//CKEditor 입력값 체크하기 : 각종 tag나 공백을 지우기
			let v_content = CKEDITOR.instances.v_content.getData();
			v_content = v_content.replace(/<[^>]*>/g, '').trim();
			v_content = v_content.replace(/\s+/g, '');
			v_content = v_content.replaceAll("<br />","").replaceAll("&nbsp;","");
			
			if(v_content==""){
				alert("내용을 입력하세요");
				CKEDITOR.instances.v_content.setData("");
				f.v_content.focus();
				return;
			}
			
			if(v_title==""){
				alert("제목을 입력하세요");
				f.v_title.value="";
				f.v_title.focus();
				return;
			}			
			
			f.method="POST";
			f.action="modify.do";
			f.submit();		
	}	// send(f) fin
	
</script>

<script type="text/javascript">	
   // CKEditor내에서 이미지 삭제시 이벤트 처리
   // 즉 작성하다가 글 수정 등을 위해서 이미지를 날릴 때의 이야기다
   let previousImageUrls = [];
   
   $(document).ready(function(){
	   
	   // CKEditor 내용을 작성하는 <textarea name="content">
	   const editor = CKEDITOR.instances.v_content; 
	   
	   editor.on('change', function () {

		    const currentHtml = editor.getData();
		    const currentImageUrls = extractImageUrls(currentHtml);

		    // 이전 이미지 중 현재 HTML에 없는 항목은 삭제 대상
		    previousImageUrls.forEach(oldUrl => {
		        if (!currentImageUrls.includes(oldUrl)) {
		        	
		        	//oldUrl =  http://localhost:8080/images/1763707289780_병아리.png
		            //console.log("삭제할 기존 이미지:", oldUrl);
		        	let lastIndex = oldUrl.lastIndexOf("/");
		        	let filename  = oldUrl.substring(lastIndex+1);
		        	filename      = decodeURIComponent(filename);
		        	//console.log("삭제할 화일명:", filename);
		            deleteImageOnServer(filename);
		        }
		    });
		    
		    // 현재 이미지 목록을 저장
		    previousImageUrls = currentImageUrls;
		  
		});
   });
      
   
   function extractImageUrls(html) {
	    const div = document.createElement('div');
	    div.innerHTML = html;

	    return Array.from(div.querySelectorAll('img')).map(img => img.src);
	}

	/**
	 * 서버로 이미지 삭제 요청
	 */
	function deleteImageOnServer(filename) {
		
		$.ajax({
			url			:	"${pageContext.request.contextPath}/ckeditorImageDelete.do",
			data		:	{"filename": filename },
			dataType	:	"json",
			success		:	function(res_data){
				
				// res_data = { "result" : true}
				console.log(res_data.result ? "삭제성공" : "삭제실패");
				
			},
			error		:	function(err){
				alert(err.responseText);
			}
		});
	}
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
					<input class="form-control" name="v_title" value="${ vo.v_title }">
				</div>
				
				<!-- 별점 -->
				<div class="common">
					<label>점수 선택:</label><br>
				    <label class="radio-inline">
				      <input type="radio" name="v_score" value="1" ${v_score == 1 ? "checked" : ""}> 1
				    </label>
				    <label class="radio-inline">
				      <input type="radio" name="v_score" value="2" ${v_score == 2 ? "checked" : ""}> 2
				    </label>
				    <label class="radio-inline">
				      <input type="radio" name="v_score" value="3" ${v_score == 3 ? "checked" : ""}> 3
				    </label>
				    <label class="radio-inline">
				      <input type="radio" name="v_score" value="4" ${v_score == 4 ? "checked" : ""}> 4
				    </label>
				    <label class="radio-inline">
				      <input type="radio" name="v_score" value="5" ${v_score == 5 ? "checked" : ""}> 5
				    </label>
				</div>
				
				<!-- 내용 -->
				<div class="common">
					<label>내용</label>
					<textarea class="form-control" rows="6" cols="" name="v_content" value="${ vo.v_content }">												
					</textarea>
						<script>
							// Replace the <textarea id="editor1"> with a CKEditor
							// instance, using default configuration.
							CKEDITOR.replace( 'v_content', {
							versionCheck: false,
							filebrowserUploadUrl: '${pageContext.request.contextPath}/ckeditorImageUpload.do',
							enterMode:CKEDITOR.ENTER_BR,
							shiftEnterMode:CKEDITOR.ENTER_P,
							toolbarGroups : [							
								{ name: 'insert' },							
								]
							});
							
							//이미지 업로드	
							CKEDITOR.on('dialogDefinition', function( ev ){
							   var dialogName = ev.data.name;
							   var dialogDefinition = ev.data.definition;
							 
							   switch (dialogName) {
							       case 'image': //Image Properties dialog
								   //dialogDefinition.removeContents('info');
								   dialogDefinition.removeContents('Link');
								   dialogDefinition.removeContents('advanced');
								   break;
							   }
						       });
						</script>						
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