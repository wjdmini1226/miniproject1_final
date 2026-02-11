<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>미니 프로젝트 메인</title>
<link
	href="https://fonts.googleapis.com/css2?family=Nanum+Gothic:wght@400;700;800&display=swap"
	rel="stylesheet">
<style>
body {
	margin: 0;
	font-family: 'Nanum Gothic', sans-serif;
	overflow: hidden;
	background-color: #fff;
}

/* 헤더: 3분할 레이아웃 핵심 */
header {
	height: 80px;
	display: flex;
	align-items: center;
	background-color: #ffffff;
	border-bottom: 2px solid #eee;
	padding: 0 40px;
	box-sizing: border-box;
}

/* 좌측/중앙/우측 공간을 똑같이 1:1:1로 배분 */
.h-left {
	flex: 1;
}

.h-center {
	flex: 1;
	text-align: center;
	font-size: 26px;
	font-weight: 800;
	color: #333;
	white-space: nowrap; /* 제목이 줄어들어도 줄바꿈 방지 */
}

.h-right {
	flex: 1;
	display: flex;
	justify-content: flex-end;
	align-items: center;
}

/* 사용자 정보 및 버튼 스타일 */
.auth-menu {
	display: flex;
	align-items: center;
	font-size: 14px;
}

.user-greeting {
	margin-right: 15px;
	color: #666;
	white-space: nowrap;
}

.auth-menu a {
	padding: 7px 14px;
	text-decoration: none;
	color: #444;
	margin-left: 8px;
	border-radius: 6px;
	font-weight: 700;
	white-space: nowrap;
	display: inline-block;
}

.admin-btn {
	background-color: #ff5e57 !important;
	color: #fff !important;
}

.logout-btn {
	border: 2px solid #ff5e57 !important;
	color: #ff5e57 !important;
	background-color: #fff !important;
	box-sizing: border-box;
}

.logout-btn:hover {
	background-color: #ff5e57 !important;
	color: #fff !important;
}

/* 하단 컨테이너 */
.main-container {
	display: flex;
	width: 100%;
	height: calc(100vh - 82px);
}

.column {
	flex: 1;
	display: flex;
	flex-direction: column;
	justify-content: center;
	align-items: center;
	transition: all 0.7s cubic-bezier(0.19, 1, 0.22, 1);
	color: white;
	text-decoration: none;
	cursor: pointer;
}

.promo {
	background-color: #ff5e57;
}

.list {
	background-color: #ffdd59;
	color: #333;
}

.board {
	background-color: #48c7ef;
}

.column:hover {
	flex: 4;
}

.column h2 {
	font-size: 2.5rem;
	margin: 0;
}

.column p {
	opacity: 0;
	transform: translateY(20px);
	transition: all 0.5s;
	font-size: 1.2rem;
	margin-top: 20px;
}

.column:hover p {
	opacity: 1;
	transform: translateY(0);
}
</style>
</head>
<body>
	<header>
		<div class="h-left"></div>
		<div class="h-center">프로젝트 제목</div>
		<div class="h-right">
			<div class="auth-menu">
				<c:if test="${ empty member }">
					<a href="/login_form.do">로그인</a>
					<a href="/insert_type.do">회원가입</a>
				</c:if>

				<c:if test="${ not empty member }">
					<span class="user-greeting"> <strong style="color: #48c7ef;">${member.m_nickname}</strong>님
						반가워요!
					</span>

					<c:if test="${ member.m_admin == 2 }">
						<a href="/admin/main.do" class="admin-btn"
							style="background-color: #2c3e50 !important;">시스템 관리</a>
					</c:if>

					<c:if test="${ member.m_admin == 1 }">
						<a href="/restaurant/dashboard.do" class="admin-btn">내 가게 관리</a>
					</c:if>

					<a href="mypage.do">마이페이지</a>
					<a href="/logout.do" class="logout-btn">로그아웃</a>
				</c:if>
			</div>
		</div>
	</header>

	<div class="main-container">
		<div class="column promo" onclick="location.href='/news/list.do';">
			<h2>미식 매거진</h2>
			<p>에디터가 엄선한 맛집 트렌드와 뉴스</p>
		</div>
		<div class="column list"
			onclick="location.href='/map/mapview.do';">
			<h2>맛집 리스트</h2>
			<p>실패 없는 맛집 탐방!</p>
		</div>
		<div class="column board" onclick="location.href='/board/list.do';">
			<h2>자유게시판</h2>
			<p>함께 나누는 맛있는 이야기</p>
		</div>
	</div>
</body>
</html>