<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>가게 정보 수정</title>
<style>
.modify-container {
	max-width: 600px;
	margin: 50px auto;
	padding: 30px;
	border: 1px solid #ddd;
	border-radius: 10px;
}

.form-group {
	margin-bottom: 20px;
}

.form-group label {
	display: block;
	margin-bottom: 5px;
	font-weight: bold;
}

.form-group input, .form-group textarea, .form-group select {
	width: 100%;
	padding: 10px;
	border: 1px solid #ccc;
	border-radius: 5px;
	box-sizing: border-box;
}

.btn-save {
	width: 100%;
	padding: 12px;
	background-color: #48c7ef;
	color: white;
	border: none;
	border-radius: 5px;
	cursor: pointer;
	font-size: 16px;
}

.btn-save:hover {
	background-color: #38b7df;
}
</style>
<!-- CKEditor 4 -->
<script src="https://cdn.ckeditor.com/4.22.1/full/ckeditor.js"></script>
<script type="text/javascript">
   //CKEditor내에서 이미지 삭제시 이벤트 처리
   let previousImageUrls = [];
   
   $(document).ready(function(){
	   
	   // CKEditor 내용을 작성하는 <textarea name="content">
	   const editor = CKEDITOR.instances.r_menu; 
	   
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
			url			:	"/ckeditorImageDelete.do",
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
	function send(f){
		   
		   
		//let content	= f.content.value.trim();
		//CKEditor 입력값 체크하기
		let r_menu = CKEDITOR.instances.r_menu.getData();
		r_menu = r_menu.replace(/<[^>]*>/g, '').trim();
		r_menu = r_menu.replace(/\s+/g, '');
		r_menu = r_menu.replaceAll("<br />","").replaceAll("&nbsp;","");
		   
		if(r_menu==""){
			alert("내용을 입력하세요!");
			CKEDITOR.instances.r_menu.setData("");
			f.r_menu.focus();
			return;
		}  
	}
</script>
</head>
<body>

	<div class="modify-container">
		<h2>🏠 가게 정보 수정</h2>
		<hr>
		<form action="update.do" method="post">
			<input type="hidden" name="r_member" value="${rs.r_member}">

			<div class="form-group">
				<label>식당 이름</label> <input type="text" name="r_name"
					value="${rs.r_name}" required>
			</div>

			<div class="form-group">
				<label>카테고리</label> <select name="r_category">
					<option value="한식" ${rs.r_category == '한식' ? 'selected' : ''}>한식</option>
					<option value="일식" ${rs.r_category == '일식' ? 'selected' : ''}>일식</option>
					<option value="중식" ${rs.r_category == '중식' ? 'selected' : ''}>중식</option>
					<option value="양식" ${rs.r_category == '양식' ? 'selected' : ''}>양식</option>
				</select>
			</div>

			<div class="form-group">
				<label>주소</label> <input type="text" name="r_addr"
					value="${rs.r_addr}" required>
			</div>

			<div class="form-group">
				<label>메뉴 상세 소개</label>
				<textarea name="r_menu" rows="8" placeholder="메뉴 정보를 입력하세요.">${rs.r_menu}</textarea>
				<script>
					// Replace the <textarea id="editor1"> with a CKEditor
					// instance, using default configuration.
					CKEDITOR.replace( 'r_menu', {
					versionCheck: false,
					filebrowserUploadUrl: '${pageContext.request.contextPath}/ckeditorImageUpload.do',
					enterMode:CKEDITOR.ENTER_BR,
					shiftEnterMode:CKEDITOR.ENTER_P,
					toolbarGroups : [
						{ name: 'document', groups: [ 'mode', 'document', 'doctools' ] },
						/* { name: 'clipboard', groups: [ 'clipboard', 'undo' ] },
						{ name: 'editing', groups: [ 'find', 'selection', 'spellchecker' ] },
						{ name: 'forms' },
						'/', */
						/* { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
						{ name: 'paragraph', groups: [ 'list', 'indent', 'blocks', 'align', 'bidi' ] }, */
						{ name: 'links' },
						{ name: 'insert' },
						'/',
						{ name: 'styles' },
						{ name: 'colors' },
						{ name: 'tools' },
						{ name: 'others' },
						{ name: 'about' }
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

			<button type="submit" class="btn-save">수정 내용 저장하기</button>
			<button type="button" onclick="history.back();"
				style="width: 100%; margin-top: 10px; background: none; border: none; color: #888; cursor: pointer;">취소</button>
		</form>
	</div>

</body>
</html>