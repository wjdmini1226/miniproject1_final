<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사장님 관리 대시보드</title>
<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic:wght@400;700;800&display=swap" rel="stylesheet">
<style>
    body { margin: 0; font-family: 'Nanum Gothic', sans-serif; background-color: #f8f9fa; }
    header { height: 70px; background: white; display: flex; align-items: center; padding: 0 30px; border-bottom: 1px solid #ddd; justify-content: space-between; }
    
    .container { max-width: 1000px; margin: 50px auto; padding: 0 20px; }
    .welcome-msg { margin-bottom: 30px; }
    .welcome-msg h1 { color: #333; font-size: 28px; }
    .welcome-msg span { color: #48c7ef; }

    /* 카드 레이아웃 */
    .dashboard-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; }
    .card {
        background: white; border-radius: 15px; padding: 30px; text-align: center;
        box-shadow: 0 4px 6px rgba(0,0,0,0.05); transition: all 0.3s ease;
        cursor: pointer; border: 1px solid transparent;
    }
    .card:hover { transform: translateY(-10px); box-shadow: 0 10px 20px rgba(0,0,0,0.1); border-color: #48c7ef; }
    
    .card .icon { font-size: 50px; margin-bottom: 15px; }
    .card h3 { margin: 10px 0; font-size: 20px; color: #333; }
    .card p { color: #777; font-size: 14px; line-height: 1.5; }

    /* 버튼 스타일 (필요시) */
    .home-btn { text-decoration: none; color: #555; font-weight: bold; border: 1px solid #ccc; padding: 8px 15px; border-radius: 5px; }
</style>
</head>
<body>

<header>
    <div style="font-weight: 800; font-size: 20px;">Owner <span style="color: #ff5e57;">Restaurant</span></div>
    <a href="/home.do" class="home-btn">메인으로 돌아가기</a>
</header>

<div class="container">
    <div class="welcome-msg">
        <h1><span>${rs.r_name}</span> 사장님, 환영합니다!</h1>
        <p>오늘의 매장 관리를 시작해 보세요.</p>
    </div>

    <div class="dashboard-grid">
        <div class="card" onclick="location.href='modify_info.do';">
            <div class="icon">🏠</div>
            <h3>가게 정보 관리</h3>
            <p>메뉴, 카테고리, 위치 등<br>기본 정보를 수정합니다.</p>
        </div>

        <div class="card" onclick="location.href='review_manage.do';">
            <div class="icon">💬</div>
            <h3>리뷰 관리</h3>
            <p>손님들이 남긴 소중한 리뷰에<br>답글을 남겨보세요.</p>
        </div>
    </div>
</div>

</body>
</html>