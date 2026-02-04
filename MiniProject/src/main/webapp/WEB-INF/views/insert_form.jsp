<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<link
	href="https://fonts.googleapis.com/css2?family=Nanum+Gothic:wght@400;700;800&display=swap"
	rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script
	src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<style>
:root {
	--primary-blue: #48c7ef;
	--primary-red: #ff5e57;
	--text-gray: #777;
}

body {
	margin: 0;
	font-family: 'Nanum Gothic', sans-serif;
	background-color: #f4f7f6;
	display: flex;
	justify-content: center;
	align-items: center;
	min-height: 100vh;
	padding: 40px 0;
}

.join-container {
	background: #fff;
	width: 100%;
	max-width: 500px;
	padding: 40px;
	border-radius: 20px;
	box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
}

h2 {
	text-align: center;
	color: #333;
	margin-bottom: 30px;
	font-weight: 800;
}

.input-group {
	margin-bottom: 20px;
	position: relative;
}

.input-group label {
	display: block;
	margin-bottom: 8px;
	font-weight: 700;
	font-size: 14px;
	color: #444;
}

input[type="text"], input[type="password"], select {
	width: 100%;
	padding: 12px 15px;
	border: 1px solid #ddd;
	border-radius: 8px;
	box-sizing: border-box;
	font-size: 15px;
	transition: border-color 0.3s;
}

input:focus {
	border-color: var(--primary-blue);
	outline: none;
}

/* 유효성 검사 메시지 */
.msg {
	font-size: 12px;
	margin-top: 5px;
	display: block;
	min-height: 15px;
}

/* 사장님 전용 섹션 업그레이드 */
.owner-section {
	background: #ffffff;
	border: 2px solid #ff5e57; /* 사장님 포인트 컬러: 레드 */
	border-radius: 15px;
	padding: 25px;
	margin-top: 30px;
	position: relative;
	box-shadow: 0 8px 20px rgba(255, 94, 87, 0.1);
	animation: slideUp 0.5s ease-out; /* 등장 애니메이션 */
}

/* 상단에 "사장님 전용" 뱃지 추가 */
.owner-section::before {
	content: "OWNER ONLY";
	position: absolute;
	top: -12px;
	left: 20px;
	background: #ff5e57;
	color: #fff;
	padding: 2px 12px;
	font-size: 11px;
	font-weight: bold;
	border-radius: 20px;
	letter-spacing: 1px;
}

.owner-section h3 {
	margin-top: 5px;
	margin-bottom: 20px;
	font-size: 18px;
	color: #333;
	display: flex;
	align-items: center;
	gap: 8px;
}

/* 주소 검색 버튼 스타일 */
.addr-btn {
	background-color: #333;
	color: white;
	border: none;
	padding: 0 15px;
	border-radius: 8px;
	cursor: pointer;
	font-size: 13px;
	transition: background 0.3s;
	white-space: nowrap;
}

.addr-btn:hover {
	background-color: #000;
}

/* 등장 애니메이션 효과 */
@
keyframes slideUp {from { opacity:0;
	transform: translateY(20px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}
.submit-btn {
	width: 100%;
	padding: 15px;
	border: none;
	border-radius: 8px;
	font-size: 16px;
	font-weight: 800;
	cursor: pointer;
	color: white;
	margin-top: 20px;
	transition: opacity 0.3s;
}

/* 가입 버튼 색상 분기 */
.bg-blue {
	background-color: var(--primary-blue);
}

.bg-red {
	background-color: var(--primary-red);
}

.submit-btn:hover {
	opacity: 0.9;
}
</style>
</head>
<body>

	<div class="join-container">
		<h2>${param.m_admin == 1 ? '사장님 가입' : '일반 회원가입'}</h2>

		<form action="insert.do" method="post" id="joinForm">
			<input type="hidden" name="m_admin" value="${param.m_admin}">

			<div class="input-group">
				<label>아이디</label> <input type="text" id="m_id" name="m_id"
					placeholder="4~12자 영문/숫자"> <span id="id_msg" class="msg"></span>
			</div>

			<div class="input-group">
				<label>비밀번호</label> <input type="password" id="m_pwd" name="m_pwd"
					placeholder="8자 이상 입력"> <span id="pwd_msg" class="msg"></span>
			</div>

			<div class="input-group">
				<label>비밀번호 확인</label> <input type="password" id="m_pwd_check"
					placeholder="비밀번호 재입력"> <span id="pwd_check_msg"
					class="msg"></span>
			</div>

			<div class="input-group">
				<label>닉네임</label> <input type="text" id="m_nickname"
					name="m_nickname" placeholder="사용할 닉네임"> <span
					id="nick_msg" class="msg"></span>
			</div>

			<c:if test="${param.m_admin == '1'}">
				<div class="owner-section">
					<h3>🏠 가게 정보를 입력해주세요</h3>

					<div class="input-group">
						<label>가게 이름</label> <input type="text" name="r_name"
							placeholder="예: 맛나식당 강남점">
					</div>

					<div class="input-group">
						<label>가게 주소</label>
						<div style="display: flex; gap: 8px;">
							<input type="text" id="r_addr" name="r_addr"
								placeholder="주소 검색을 클릭하세요" readonly
								style="background-color: #f9f9f9; cursor: not-allowed;">
							<button type="button" class="addr-btn" onclick="searchAddr()">주소
								검색</button>
						</div>
					</div>

					<div class="input-group">
						<label>업종 카테고리</label> <select name="r_category">
							<option value="" disabled selected>카테고리 선택</option>
							<option value="한식">🍱 한식</option>
							<option value="중식">🥡 중식</option>
							<option value="일식">🍣 일식</option>
							<option value="양식">🍝 양식</option>
							<option value="카페">☕ 카페/디저트</option>
						</select>
					</div>
				</div>
			</c:if>

			<button type="button"
				class="submit-btn ${param.m_admin == 1 ? 'bg-red' : 'bg-blue'}"
				onclick="send(this.form)">가입하기</button>
		</form>
	</div>

	<script>
	let isIdValid = false;
	let isPwdValid = false;
	let isNickValid = false; // 닉네임 상태 추가
	let timer;

	// [공통 중복체크 함수]
	function checkDuplicateAjax(key, value, msgElement, successCallback) {
	    let sendData = {};
	    sendData[key] = value; // 호출 시점에 {m_id: "..."} 또는 {m_nickname: "..."} 가 됨

	    $.ajax({
	        url: 'checkDuplicate.do',
	        type: 'post',
	        data: sendData,
	        dataType: 'json',
	        success: function(res) {
	            // 컨트롤러가 반환하는 isDuplicate 필드 사용
	            if(!res.isDuplicate) { 
	                $(msgElement).text(res.msg).css('color', 'green');
	                successCallback(true);
	            } else {
	                $(msgElement).text(res.msg).css('color', 'red');
	                successCallback(false);
	            }
	        }
	    });
	}

	// 아이디 실시간 체크
	$('#m_id').on('input', function() {
	    const id = $(this).val();
	    clearTimeout(timer);
	    timer = setTimeout(() => {
	        if(!/^[a-z0-9]{4,12}$/.test(id)) {
	            $('#id_msg').text('4~12자 영문/숫자만 가능합니다.').css('color', 'red');
	            isIdValid = false;
	        } else {
	            // "m_id" 키로 호출
	            checkDuplicateAjax("m_id", id, '#id_msg', (valid) => isIdValid = valid);
	        }
	    }, 300);
	});
	
	// 비밀번호 체크
	$('#m_pwd, #m_pwd_check').on('input', function() {
	    const p1 = $('#m_pwd').val();
	    const p2 = $('#m_pwd_check').val();
	    const pwdReg = /^.{8,}$/; // 8자 이상 예시

	    // 1. 비밀번호 기본 유효성 검사
	    if(!pwdReg.test(p1)) {
	        $('#pwd_msg').text('비밀번호는 8자 이상이어야 합니다.').css('color', 'red');
	        isPwdValid = false;
	    } else {
	        $('#pwd_msg').text('사용 가능한 비밀번호입니다.').css('color', 'green');
	        
	        // 2. 비밀번호 확인(p2) 입력란이 비어있지 않을 때만 일치 여부 검사
	        if(p2.length > 0) {
	            if(p1 === p2) {
	                $('#pwd_check_msg').text('비밀번호가 일치합니다.').css('color', 'green');
	                isPwdValid = true;
	            } else {
	                $('#pwd_check_msg').text('비밀번호가 일치하지 않습니다.').css('color', 'red');
	                isPwdValid = false;
	            }
	        }
	    }
	});

	// 닉네임 실시간 체크
	$('#m_nickname').on('input', function() {
	    const nick = $(this).val().trim();
	    clearTimeout(timer);
	    timer = setTimeout(() => {
	        if(nick.length < 2) {
	            $('#nick_msg').text('닉네임은 2자 이상 입력해주세요.').css('color', 'red');
	            isNickValid = false;
	        } else {
	            // "m_nickname" 키로 호출
	            checkDuplicateAjax("m_nickname", nick, '#nick_msg', (valid) => isNickValid = valid);
	        }
	    }, 300);
	});

    function send(f) {
        if(!isIdValid) { alert("아이디 중복 확인을 해주세요."); return; }
        if(!isPwdValid) { alert("비밀번호를 확인해주세요."); return; }
        if(!isNickValid) { alert("닉네임 중복 확인을 해주세요."); return; }
        
        // 사장님 정보 추가 체크
        if(f.m_admin.value == "1") {
            if(f.r_name.value.trim() == "" || f.r_addr.value.trim() == "") {
                alert("가게 정보를 모두 입력해주세요.");
                return;
            }
        }
        f.submit();
    }
    function searchAddr() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져옴
                let addr = ''; 
                if (data.userSelectedType === 'R') { // 도로명 주소
                    addr = data.roadAddress;
                } else { // 지번 주소
                    addr = data.jibunAddress;
                }

                // 주소 정보를 input 박스에 넣기
                document.getElementById("r_addr").value = addr;
                
                // (선택) 상세주소가 필요하다면 다음 input에 포커스를 줄 수 있습니다.
                // document.getElementById("r_detail_addr").focus();
            }
        }).open();
    }
</script>

</body>
</html>