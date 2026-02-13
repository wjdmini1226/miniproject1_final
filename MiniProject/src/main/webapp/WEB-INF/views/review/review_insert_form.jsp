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
<title>Review Insert Form</title>

<style type="text/css">
	#box{		width:	600px;	margin:	auto;
				margin-top:	80px;			}
			
	textarea{	resize:	none;				}	
	
	.common{	margin-bottom:	10px;		}
		
</style>

<script type="text/javascript">

$(document).ready(function() {
    // URL에서 파라미터 추출
    const urlParams = new URLSearchParams(window.location.search);
    const rNameParam = urlParams.get('r_name');
    
    if (rNameParam) {
        $("#r_name").val(rNameParam); // 식당 이름 칸에 자동 입력
        checkRestaurant();            // 자동으로 '식당 확인' 버튼 로직 실행 (선택사항)
    }
});

let isRestaurantValid = false;

function checkRestaurant() {
    let r_name = $("#r_name").val().trim();
    if (r_name == "") {
        alert("식당 이름을 입력하세요");
        return;
    }

    $.ajax({
        url: "${pageContext.request.contextPath}/restaurant/check_name.do", // 식당 존재 확인용 컨트롤러 주소
        data: { "r_name": r_name },
        dataType: "json",
        success: function(res_data) {
            // res_data = { "exists": true, "r_idx": 5 } 또는 { "exists": false }
            let msg = $("#res_msg");
            msg.show();

            if (res_data.exists) {
                msg.css("color", "blue").text("✅ 확인된 식당입니다.");
                
             	// 서버에서 오는 값이 t_r_idx인지 r_idx인지 둘 다 체크해서 넣기
                let idxValue = res_data.t_r_idx || res_data.r_idx;
                
                $("#r_idx").val(idxValue); // 찾은 식당 번호를 hidden에 저장
                isRestaurantValid = true;
                
                console.log("저장된 식당 번호:", idxValue); // 확인용
                
            } else {
                if (confirm("등록되지 않은 식당입니다. 식당 등록 페이지로 이동하시겠습니까?")) {
                    location.href = "${pageContext.request.contextPath}/restaurant/insert_form.do";
                }
                msg.css("color", "red").text("❌ 등록되지 않은 식당입니다.");
                isRestaurantValid = false;
            }
        },
        error: function(err) { alert("통신 오류가 발생했습니다."); }
    });
}	// checkRestaurant

	function send(f){
		
		console.log("식당 유효성 상태:", isRestaurantValid);
	    console.log("r_idx 값:", f.r_idx.value);
	
		// 1. 식당 확인 여부 체크
	    if (!isRestaurantValid || f.r_idx.value == "") {
	        alert("먼저 식당확인 버튼을 눌러 등록된 식당인지 확인해주세요.");
	        return;
	    }
		
		// 2. 제목내용유효성검사
		let v_title = f.v_title.value.trim();
		//CKEditor 입력값 체크하기 : 각종 tag나 공백을 지우기
		let v_content = CKEDITOR.instances.v_content.getData();
		v_content = v_content.replace(/<[^>]*>/g, '').trim();
		v_content = v_content.replace(/\s+/g, '');
		v_content = v_content.replaceAll("<br />","").replaceAll("&nbsp;","");
		let r_name = f.r_name.value.trim();
		
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
		
	    if (!f.v_score.value) {
	        alert("점수를 선택해주세요");
	        return;
	    }
		
		f.method="POST";
		f.action="insert.do";
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
					<input class="form-control" name="v_title">
				</div>
				
				<!-- 식당명 조회 -->
				<div class="common">
					<label>식당</label>
					<div class="input-group">
				        <input class="form-control" name="r_name" id="r_name" placeholder="리뷰를 작성할 식당 이름을 입력하세요">
				        <span class="input-group-btn">
				            <button class="btn btn-default" type="button" onclick="checkRestaurant();">식당확인</button>
				        </span>
				    </div>
				    <input type="hidden" name="r_idx" id="r_idx">
				    <small id="res_msg" style="display:none;"></small>
				</div>
				
				<!-- 유저번호 몰래 넘기기 는 controller의 responsebody 로 대체함
				<input type="hidden" name="m_idx" value="${member.m_idx}">
				-->
				
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
				      <input type="radio" name="v_score" value="5" checked="checked"> 5
				    </label>
				</div>
				
				<!-- 내용 -->
				<div class="common">
					<label>내용</label>
					<textarea class="form-control" rows="6" cols="" name="v_content"></textarea>
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
							onclick="location.href='../map/mapview.do'">
					<input	class="btn btn-primary" type="button" value="리뷰제출" 
							onclick="send(this.form);">
				</div>
				
			</div>
		</div>	
	</div>
	 
</form>

</body>
</html>