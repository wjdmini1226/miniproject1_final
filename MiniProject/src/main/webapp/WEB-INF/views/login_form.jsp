<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>로그인 - 프로젝트 제목</title>
<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic:wght@400;700;800&display=swap" rel="stylesheet">
<style>

/* 1. 메인 페이지와 동일한 기본 설정 */
body {
	margin: 0;
	font-family: 'Nanum Gothic', sans-serif;
	background-color: #f9f9f9;
	height: 100vh;
	display: flex;
	flex-direction: column;
}

/* 2. 헤더 스타일 완벽 일치 (home.jsp 복사) */
header {
	height: 80px;
	display: flex;
	justify-content: center;
	align-items: center;
	background-color: #ffffff;
	color: #333;
	font-size: 28px; /* 메인과 동일 */
	font-weight: 800;
	border-bottom: 2px solid #eee;
	box-sizing: border-box; /* 크기 어긋남 방지 */
}

.auth-menu a {
	padding: 5px 10px;
	border-radius: 5px;
	transition: background 0.3s;
	text-decoration: none;
	color: #333;
	margin-left: 10px;
}

/* 3. 로그인 박스 레이아웃 */
.main-content {
	flex: 1;
	display: flex;
	justify-content: center;
	align-items: center;
}

.login-box {
	width: 100%;
	max-width: 400px;
	background: #fff;
	padding: 40px;
	border-radius: 15px;
	box-shadow: 0 10px 25px rgba(0,0,0,0.05);
	border: 1px solid #eee;
}

.login-box h2 {
	text-align: center;
	font-size: 24px;
	margin-bottom: 30px;
	color: #333;
}

.login-box h2 span {
	color: #ff5e57; /* 메인 레드 컬러 포인트 */
}

.form-group {
	margin-bottom: 15px;
}

.form-group label {
	display: block;
	font-size: 14px;
	font-weight: 700;
	margin-bottom: 8px;
	color: #555;
}

.form-group input {
	width: 100%;
	padding: 12px;
	border: 1px solid #ddd;
	border-radius: 8px;
	box-sizing: border-box;
	font-size: 16px;
}

.form-group input:focus {
	border-color: #48c7ef; /* 메인 블루 컬러 포인트 */
	outline: none;
}

.btn-login {
	width: 100%;
	padding: 15px;
	background-color: #ff5e57;
	color: white;
	border: none;
	border-radius: 8px;
	font-size: 18px;
	font-weight: 800;
	cursor: pointer;
	margin-top: 10px;
}

.bottom-links {
	text-align: center;
	margin-top: 20px;
	font-size: 13px;
	color: #888;
}

.bottom-links a {
	color: #888;
	text-decoration: none;
}

.err-msg {
	color: #ff5e57;
	font-size: 12px;
	margin-top: 5px;
	display: none;
}
</style>



</head>
<body>

	<header>
		<div style="flex: 1;">
			<a href="home.do" style="text-decoration: none; color: #333; margin-left: 20px; font-size: 16px; font-weight: 400;">← 홈으로</a>
		</div>
		<div style="flex: 1; text-align: center; cursor:pointer;" onclick="location.href='home.do'">프로젝트 제목</div>
		<div class="auth-menu" style="flex: 1; text-align: right; font-size: 16px; padding-right: 20px;">
			<a href="insert_type.do">회원가입</a>
		</div>
	</header>

	<div class="main-content">
		<div class="login-box">
			<h2>LOGIN <span>!</span></h2>
			<form action="login.do" method="post" onsubmit="return validateForm()">
				<div class="form-group">
					<label>아이디</label> 
					<input type="text" name="m_id" id="m_id" placeholder="아이디를 입력하세요">
					<div id="mIdErr" class="err-msg">아이디를 입력해 주세요.</div>
				</div>
				<div class="form-group">
					<label>비밀번호</label> 
					<input type="password" name="m_pwd" id="m_pwd" placeholder="비밀번호를 입력하세요">
					<div id="mPwdErr" class="err-msg">비밀번호를 입력해 주세요.</div>
				</div>
				<button type="submit" class="btn-login">로그인</button>
			</form>
			
			<div class="bottom-links">
				<a href="insert_type.do">회원가입</a>
			</div>
		</div>
	</div>

	<script>
		function validateForm() {
			const m_id = document.getElementById("m_id");
			const m_pwd = document.getElementById("m_pwd");
			let isValid = true;

			document.getElementById("mIdErr").style.display = "none";
			document.getElementById("mPwdErr").style.display = "none";

			if (m_id.value.trim() === "") {
				document.getElementById("mIdErr").style.display = "block";
				m_id.focus();
				isValid = false;
			}
			if (m_pwd.value.trim() === "") {
				document.getElementById("mPwdErr").style.display = "block";
				if(isValid) m_pwd.focus();
				isValid = false;
			}
			return isValid;
		}
	</script>
</body>
</html>