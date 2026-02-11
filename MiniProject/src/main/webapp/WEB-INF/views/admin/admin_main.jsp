<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마스터 관리자 페이지</title>
<link
	href="https://fonts.googleapis.com/css2?family=Nanum+Gothic:wght@400;700;800&display=swap"
	rel="stylesheet">
<style>
body {
	font-family: 'Nanum Gothic', sans-serif;
	background-color: #f4f7f6;
	margin: 0;
}

.header {
	background: #2c3e50;
	color: white;
	padding: 20px 40px;
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.container {
	max-width: 1200px;
	margin: 30px auto;
	padding: 20px;
	background: white;
	border-radius: 10px;
	box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
}

.tab-btn-group {
	margin-bottom: 20px;
	border-bottom: 2px solid #eee;
}

.tab-btn {
	padding: 15px 30px;
	border: none;
	background: none;
	font-size: 16px;
	font-weight: bold;
	cursor: pointer;
	color: #999;
}

.tab-btn.active {
	color: #ff5e57;
	border-bottom: 3px solid #ff5e57;
}

table {
	width: 100%;
	border-collapse: collapse;
	margin-top: 10px;
}

th {
	background: #f8f9fa;
	padding: 12px;
	border-bottom: 2px solid #dee2e6;
	text-align: left;
}

td {
	padding: 12px;
	border-bottom: 1px solid #eee;
	font-size: 14px;
}

.btn-del {
	background: #ff5e57;
	color: white;
	border: none;
	padding: 5px 10px;
	border-radius: 4px;
	cursor: pointer;
}

.btn-edit {
	background: #48c7ef;
	color: white;
	border: none;
	padding: 5px 10px;
	border-radius: 4px;
	cursor: pointer;
	text-decoration: none;
}
</style>
</head>
<body>

	<div class="header">
		<h2>[Master] 시스템 통합 관리</h2>
		<a href="/home.do" style="color: white; text-decoration: none;">홈으로 돌아가기</a>
	</div>

	<div class="container">
		<div class="tab-btn-group">
			<button class="tab-btn active" onclick="openTab('memberTab')">회원
				관리</button>
			<button class="tab-btn" onclick="openTab('resTab')">식당 관리</button>
		</div>

		<div id="memberTab" class="tab-content">
			<table>
				<tr>
					<th>번호</th>
					<th>아이디</th>
					<th>닉네임</th>
					<th>구분</th>
					<th>명령</th>
				</tr>
				<c:forEach var="m" items="${member_list}">
					<tr>
						<td>${m.m_idx}</td>
						<td>${m.m_id}</td>
						<td><strong>${m.m_nickname}</strong></td>
						<td>${m.m_admin == 1 ? '사장님' : '일반'}</td>
						<td>
							<button class="btn-del"
								onclick="if(confirm('정말 강제탈퇴 시키겠습니까?')) location.href='member_del.do?m_idx=${m.m_idx}'">강제탈퇴</button>
						</td>
					</tr>
				</c:forEach>
			</table>
		</div>

		<div id="resTab" class="tab-content" style="display: none;">
			<table>
				<tr>
					<th>번호</th>
					<th>식당명</th>
					<th>카테고리</th>
					<th>주소</th>
					<th>평점</th>
					<th>명령</th>
				</tr>
				<c:forEach var="r" items="${restaurant_list}">
					<tr>
						<td>${r.r_idx}</td>
						<td><strong>${r.r_name}</strong></td>
						<td>${r.r_category}</td>
						<td>${r.r_addr}</td>
						<td>★ ${r.r_avgscore}</td>
						<td>
							<button class="btn-del"
								onclick="if(confirm('폐업 처리하시겠습니까?')) location.href='res_del.do?r_idx=${r.r_idx}'">폐업처리</button>
						</td>
					</tr>
				</c:forEach>
			</table>
		</div>
	</div>

	<script>
    function openTab(tabName) {
        // 모든 탭 숨기기
        document.querySelectorAll('.tab-content').forEach(t => t.style.display = 'none');
        // 모든 버튼 비활성화
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        
        // 선택한 탭 보이기
        document.getElementById(tabName).style.display = 'block';
        // 클릭한 버튼 활성화
        event.currentTarget.classList.add('active');
    }
</script>

</body>
</html>