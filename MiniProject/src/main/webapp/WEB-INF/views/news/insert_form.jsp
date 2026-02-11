<%@ page language="java" contentType="text/html; charset=UTF-8"
		pageEncoding="UTF-8"%>
<%@taglib prefix="c"	uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<!-- Bootstrap 3.x -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<!-- CKEditor 4 -->
<script src="https://cdn.ckeditor.com/4.22.1/full/ckeditor.js"></script>

<style type="text/css">
	#box{
		width: 600px;
		margin: auto;
		margin-top: 80px;
	}
	
	textarea {
	resize: none;
	}
	
	.common{
		margin-bottom: 10px;
	}
</style>

<script type="text/javascript">
	const imageServerPrefix = "http://"+document.URL.split('/')[2]+"/news_images/";
	console.log(imageServerPrefix)
	// 한 번이라도 등장했던 파일들은 전부 저장해두기
	let appearedImageNames = [];
	
	// 파일 서버에 올라온 파일명 목록만 반환
	function extractImageNames(html) { 
		const div = document.createElement('div');
		div.innerHTML = html;
		return Array.from(div.querySelectorAll('img'))
					.map(img => img.src)
					.filter(img => img.startsWith(imageServerPrefix))
					.map(img => img.substring(imageServerPrefix.length));
	}
	
	// CKEDITOR에 등장하는 파일명을 저장하기
	$(document).ready(function(){
		const editor = CKEDITOR.instances.n_content;
		editor.on('change', function () {
			extractImageNames(editor.getData()).forEach(filename => {
				if (!appearedImageNames.includes(filename)){
					appearedImageNames.push(filename);
				}
			});
			console.log(appearedImageNames)
		});
		if("${empty vo}"=="false"){
			$('input[name="n_title"]').val("${vo.n_title}");
			$('input[name="n_company"]').val("${vo.n_company}");
			$('#confirm').val("수정하기");
			editor.setData(`${vo.n_content}`);
		}
	});
	
	/**
	* 서버로 이미지 삭제 요청
	*/
	function deleteImageOnServer(filename) {
		$.ajax({
			url			:	imageServerPrefix + "delete.do",
			data		:	{"filename": filename },
			dataType	:	"json",
			success		:	function(res_data){
				console.log(filename, "삭제", res_data.result ? "성공" : "실패");
			},
			error		:	function(err){
				alert(err.responseText);
			}
		});
	}
	
	function send(f){
		let n_title = f.n_title.value.trim();
		let n_company = f.n_company.value.trim();
		//CKEditor 입력값 체크하기
		let n_content = CKEDITOR.instances.n_content.getData();
		n_content_modified = n_content.replace(/<[^>]*>/g, '').replaceAll("&nbsp;","").replace(/\s+/g, '').trim();
		
		if(n_content_modified==""){
			alert("내용을 입력하세요!");
			CKEDITOR.instances.n_content.setData("");
			f.n_content.focus();
			return;
		}
		
		if(n_title==""){
			alert("제목을 입력하세요!");
			f.n_title.value="";
			f.n_title.focus();
			return;
		}
		
		if(n_company==""){
			alert("신문사를 입력하세요!");
			f.n_company.value="";
			f.n_company.focus();
			return;
		}
		
		// 여기서부터 이미지를 파싱하고 넘겨주는 코드
		let currentImageNames = extractImageNames(n_content);
		console.log(currentImageNames)
		f.images.value=currentImageNames.join('/');
		
		// 나머지 언급되었던 파일들은 여기서 업로드 되었던 파일일 가능성이 있기에 삭제해본다
		appearedImageNames.forEach(filename => {
			if (!currentImageNames.includes(filename)){
				deleteImageOnServer(filename);
			}
		});
		
		f.method = "POST";
		if("${empty vo}"=="true")
			f.action = "insert.do";
		else
			f.action = "update.do";
		f.submit();
	}
</script>

</head>
<body>

<form>
	<c:if test="${not empty vo}">
		<input type=hidden name="n_idx" value="${vo.n_idx }">
	</c:if>
	<input type="hidden" name="images">
	<div id="box">
		<div class="panel panel-primary">
			<div class="panel-heading"><h4>새글쓰기</h4></div>
			<div class="panel-body">
				<div class="common">
					<label>제목</label>
					<input class="form-control"	name="n_title">
				</div>
				<div class="common">
					<label>신문사</label>
					<input class="form-control"	name="n_company">
				</div>
				<div class="common">
					<label>내용</label>
					<textarea class="form-control" rows="6" cols="" name="n_content"></textarea>
					<script>
						CKEDITOR.replace( 'n_content', {
						versionCheck: false,
						filebrowserUploadUrl: '${pageContext.request.contextPath}/news_images/upload.do',
						enterMode:CKEDITOR.ENTER_BR,
						shiftEnterMode:CKEDITOR.ENTER_P,
						toolbarGroups : [
							{ name: 'document', groups: [ 'mode', 'document', 'doctools' ] },
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
								case 'image':
									dialogDefinition.removeContents('Link');
									dialogDefinition.removeContents('advanced');
									break;
							}
						});
					</script>
				</div>
				<div class="common"	style="text-align: center;">
					<input class="btn btn-success" type="button" value="메인화면"
							onclick="location.href='list.do'">
					<input class="btn btn-primary" type="button" value="새글쓰기" id="confirm"
							onclick="send(this.form);">
				</div>
			</div>
		</div>
	</div>
</form>

	
</body>
</html>