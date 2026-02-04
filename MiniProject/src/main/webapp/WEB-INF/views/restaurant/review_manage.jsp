<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰 관리 - 사장님 페이지</title>
<link
	href="https://fonts.googleapis.com/css2?family=Nanum+Gothic:wght@400;700;800&display=swap"
	rel="stylesheet">
<style>
body {
	margin: 0;
	font-family: 'Nanum Gothic', sans-serif;
	background-color: #f8f9fa;
	color: #333;
}

header {
	height: 70px;
	background: white;
	display: flex;
	align-items: center;
	padding: 0 40px;
	border-bottom: 1px solid #ddd;
	justify-content: space-between;
}

.container {
	max-width: 900px;
	margin: 40px auto;
	padding: 0 20px;
}

.title-area {
	margin-bottom: 30px;
}

.review-card {
	background: white;
	border-radius: 12px;
	padding: 25px;
	margin-bottom: 20px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.review-header {
	display: flex;
	justify-content: space-between;
	margin-bottom: 15px;
	border-bottom: 1px dotted #eee;
	padding-bottom: 10px;
}

.user-info {
	font-weight: 700;
	color: #444;
}

.rating {
	color: #ffdd59;
	font-size: 18px;
}

.review-body {
	line-height: 1.6;
	margin-bottom: 15px;
}

/* 답글 영역 */
.reply-area {
	background: #f9f9f9;
	border-radius: 8px;
	padding: 15px;
	margin-top: 10px;
	border-left: 4px solid #48c7ef;
}

.reply-status {
	font-size: 13px;
	font-weight: bold;
	margin-bottom: 5px;
}

.status-none {
	color: #ff5e57;
}

.status-done {
	color: #48c7ef;
}

textarea {
	width: 100%;
	height: 80px;
	border: 1px solid #ddd;
	border-radius: 5px;
	padding: 10px;
	resize: none;
	font-family: inherit;
	box-sizing: border-box;
}

.btn-submit {
	background: #48c7ef;
	color: white;
	border: none;
	padding: 8px 15px;
	border-radius: 5px;
	cursor: pointer;
	margin-top: 10px;
	float: right;
	font-weight: bold;
}

.btn-submit:hover {
	background: #3bb3d9;
}

.home-btn {
	text-decoration: none;
	color: #555;
	font-weight: bold;
	border: 1px solid #ccc;
	padding: 8px 15px;
	border-radius: 5px;
	font-size: 14px;
}

.clearfix::after {
	content: "";
	clear: both;
	display: table;
}
</style>
</head>
<body>
	<header>
		<div style="font-weight: 800; font-size: 20px;">
			Owner <span style="color: #48c7ef;">Review</span>
		</div>
		<a href="/restaurant/dashboard.do" class="home-btn">대시보드로 복귀</a>
	</header>

	<div class="container">
		<div class="title-area">
			<h1>우리 가게 리뷰 관리</h1>
			<p>고객님의 소중한 리뷰에 답글을 남겨주세요.</p>
		</div>

		<c:forEach var="vo" items="${ review_list }">
			<div class="review-card">
				<div class="review-header">
					<span class="user-info">${vo.m_nickname} <small
						style="font-weight: 400; color: #999;">| ${vo.rv_date}</small></span> <span
						class="rating"> <c:forEach begin="1" end="${vo.rv_star}">★</c:forEach>
						<c:forEach begin="${vo.rv_star + 1}" end="5">☆</c:forEach>
					</span>
				</div>

				<div class="review-body">${vo.rv_content}</div>

				<div class="reply-area clearfix">
					<c:choose>
						<c:when test="${ empty vo.rv_reply }">
							<div class="reply-status status-none">● 아직 답글이 없습니다.</div>
							<form action="/restaurant/insert_reply.do" method="POST">
								<input type="hidden" name="rv_idx" value="${vo.rv_idx}">
								<textarea name="rv_reply" placeholder="사장님의 따뜻한 답글을 입력해 주세요."></textarea>
								<button type="submit" class="btn-submit">답글 등록</button>
							</form>
						</c:when>
						<c:otherwise>
							<div class="reply-status status-done">● 사장님 답글 완료</div>
							<div style="color: #666; font-style: italic;">"${vo.rv_reply}"</div>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		</c:forEach>

		<c:if test="${ empty review_list }">
			<div style="text-align: center; padding: 50px; color: #999;">
				아직 작성된 리뷰가 없습니다.</div>
		</c:if>
	</div>
</body>
</html>