<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입 유형 선택</title>
<link
	href="https://fonts.googleapis.com/css2?family=Nanum+Gothic:wght@400;700;800&display=swap"
	rel="stylesheet">
<style>
body {
	margin: 0;
	font-family: 'Nanum Gothic', sans-serif;
	background-color: #f9f9f9;
	display: flex;
	justify-content: center;
	align-items: center;
	height: 100vh;
}

.container {
	text-align: center;
	width: 100%;
	max-width: 900px;
}

h1 {
	margin-bottom: 50px;
	color: #333;
	font-weight: 800;
}

.type-wrapper {
	display: flex;
	gap: 30px;
	padding: 20px;
}

.type-card {
	flex: 1;
	background: white;
	border-radius: 20px;
	padding: 50px 30px;
	box-shadow: 0 10px 30px rgba(0, 0, 0, 0.05);
	transition: all 0.3s ease;
	cursor: pointer;
	border: 2px solid transparent;
}
/* 일반 유저 카드 호버 */
.user-card:hover {
	transform: translateY(-10px);
	border-color: #48c7ef;
}
/* 사장님 카드 호버 */
.owner-card:hover {
	transform: translateY(-10px);
	border-color: #ff5e57;
}

.icon {
	font-size: 60px;
	margin-bottom: 20px;
}

h2 {
	margin: 10px 0;
	font-size: 24px;
}

p {
	color: #777;
	line-height: 1.6;
	margin-bottom: 30px;
}

.btn {
	display: inline-block;
	padding: 12px 30px;
	border-radius: 30px;
	text-decoration: none;
	font-weight: bold;
	color: white;
}

.btn-user {
	background-color: #48c7ef;
}

.btn-owner {
	background-color: #ff5e57;
}
</style>
</head>
<body>

	<div class="container">
		<h1>어떤 회원으로 가입하시겠어요?</h1>

		<div class="type-wrapper">
			<div class="type-card user-card"
				onclick="location.href='insert_form.do?m_admin=0';">
				<div class="icon">😋</div>
				<h2>일반 회원</h2>
				<p>
					맛집을 검색하고 리뷰를 남기며<br>자유게시판에서 소통할 수 있습니다.
				</p>
				<span class="btn btn-user">일반 회원으로 함께하기</span>
			</div>

			<div class="type-card owner-card"
				onclick="location.href='insert_form.do?m_admin=1';">
				<div class="icon">👨‍🍳</div>
				<h2>가게 사장님</h2>
				<p>
					우리 가게를 홍보하고 관리하며<br>새로운 손님들을 만날 수 있습니다.
				</p>
				<span class="btn btn-owner">사장님으로 함께하기</span>
			</div>
		</div>
	</div>

</body>
</html>