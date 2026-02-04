<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>정보 수정</title>
<style>
body {
	font-family: 'Malgun Gothic', sans-serif;
	background-color: #f7f9fc;
	display: flex;
	justify-content: center;
	align-items: center;
	min-height: 100vh;
	margin: 0;
}

.card {
	background: white;
	padding: 40px;
	border-radius: 15px;
	box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
	width: 400px;
}

h2 {
	text-align: center;
	margin-bottom: 30px;
	color: #333;
}

.input-group {
	margin-bottom: 20px;
}

.label {
	display: block;
	font-weight: bold;
	color: #666;
	margin-bottom: 8px;
	font-size: 14px;
}

.input-field {
	width: 100%;
	padding: 12px;
	border: 1px solid #ddd;
	border-radius: 8px;
	box-sizing: border-box;
	font-size: 16px;
	transition: border-color 0.3s;
}

.input-field:focus {
	border-color: #4A90E2;
	outline: none;
}

.input-field[readonly] {
	background-color: #f0f0f0;
	cursor: not-allowed;
	color: #888;
}

.btn-group {
	margin-top: 30px;
	display: flex;
	flex-direction: column;
	gap: 10px;
}

.btn {
	padding: 12px;
	border-radius: 8px;
	border: none;
	cursor: pointer;
	font-weight: bold;
	text-align: center;
	text-decoration: none;
	transition: 0.3s;
	font-size: 16px;
}

.btn-submit {
	background-color: #4A90E2;
	color: white;
}

.btn-cancel {
	background-color: #e0e0e0;
	color: #333;
}

.btn-delete {
	background-color: #fff;
	color: #ff4d4d;
	border: 1px solid #ff4d4d;
	margin-top: 10px;
	font-size: 14px;
}

.btn:hover {
	opacity: 0.8;
}

.btn-delete:hover {
	background-color: #ff4d4d;
	color: white;
}
</style>
</head>
<body>

	<div class="card">
		<h2>회원 정보 수정</h2>

		<form action="modify.do" method="post" id="modifyForm">
			<input type="hidden" name="m_idx" value="${member.m_idx}">

			<div class="input-group">
				<label class="label">아이디</label> <input type="text"
					class="input-field" value="${member.m_id}" readonly>
			</div>

			<div class="input-group">
				<label class="label">비밀번호 확인</label> <input type="password"
					name="m_pwd" id="m_pwd" class="input-field"
					placeholder="본인 확인을 위해 입력" required>
			</div>

			<div class="input-group">
				<label class="label">닉네임 변경</label> <input type="text"
					name="m_nickname" class="input-field" value="${member.m_nickname}"
					required>
			</div>

			<div class="btn-group">
				<button type="submit" class="btn btn-submit">수정하기</button>
				<a href="mypage.do" class="btn btn-cancel">취소</a>
				<button type="button" class="btn btn-delete" onclick="del_member();">회원
					탈퇴</button>
			</div>
		</form>
	</div>

	<script>
	// 결과 메시지 처리 (수정 실패 등)
	window.onload = function() {
		var result = "${param.result}";
		if(result === "modify_fail") {
			alert("정보 수정에 실패했습니다. 비밀번호를 확인하세요.");
		}
		
		// Controller에서 rttr.addFlashAttribute("msg", ...)로 보낸 경우
		var msg = "${msg}";
		if(msg !== "") {
			alert(msg);
		}
	};

    function del_member() {
        if (!confirm("정말로 탈퇴하시겠습니까?\n모든 데이터가 삭제되며 복구할 수 없습니다.")) {
            return;
        }
        
        // 폼의 비밀번호 입력란 값을 가져옴
        var pwd = document.getElementById("m_pwd").value;
        
        if (pwd.trim() === "") {
            alert("탈퇴를 위해 비밀번호를 입력해주세요.");
            document.getElementById("m_pwd").focus();
            return;
        }

        // 탈퇴를 위한 전용 폼 생성 및 전송
        var f = document.getElementById("modifyForm");
        f.action = "delete.do"; // 목적지를 탈퇴 로직으로 변경
        f.submit();
    }
</script>

</body>
</html>