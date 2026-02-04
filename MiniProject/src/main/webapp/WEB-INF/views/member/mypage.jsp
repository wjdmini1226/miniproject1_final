<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
<style>
    body { font-family: 'Malgun Gothic', sans-serif; background-color: #f7f9fc; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
    .card { background: white; padding: 40px; border-radius: 15px; box-shadow: 0 4px 20px rgba(0,0,0,0.1); width: 400px; text-align: center; }
    .profile-img { font-size: 60px; margin-bottom: 20px; }
    h2 { margin-bottom: 30px; color: #333; }
    .info-row { display: flex; justify-content: space-between; margin-bottom: 15px; padding-bottom: 10px; border-bottom: 1px solid #eee; }
    .label { font-weight: bold; color: #666; }
    .value { color: #333; }
    .btn-group { margin-top: 30px; display: flex; flex-direction: column; gap: 10px; }
    .btn { padding: 12px; border-radius: 8px; border: none; cursor: pointer; font-weight: bold; text-decoration: none; transition: 0.3s; }
    .btn-edit { background-color: #4A90E2; color: white; }
    .btn-home { background-color: #e0e0e0; color: #333; }
    .btn:hover { opacity: 0.8; }
</style>
</head>
<body>

<div class="card">
    <div class="profile-img">👤</div>
    <h2>내 정보</h2>
    
    <div class="info-row">
        <span class="label">아이디</span>
        <span class="value">${member.m_id}</span>
    </div>
    
    <div class="info-row">
        <span class="label">닉네임</span>
        <span class="value">${member.m_nickname}</span>
    </div>
    
    <div class="info-row">
        <span class="label">회원등급</span>
        <span class="value">
            <c:choose>
                <c:when test="${ member.m_admin == 1 }">사장님 회원</c:when>
                <c:when test="${ member.m_admin == 2 }">관리자</c:when>
                <c:otherwise>일반 회원</c:otherwise>
            </c:choose>
        </span>
    </div>

    <div class="btn-group">
        <a href="modify_form.do" class="btn btn-edit">정보 수정</a>
        <a href="home.do" class="btn btn-home">홈으로 돌아가기</a>
    </div>
</div>

</body>
</html>