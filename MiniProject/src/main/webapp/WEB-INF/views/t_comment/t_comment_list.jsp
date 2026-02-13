<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>댓글 목록</title>

<!-- 부트스트랩 3.x버전 -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic:wght@400;700;800&display=swap" rel="stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

<style>
  :root{
    --brand:#48c7ef;
    --brand-dark:#1aa6d6;
    --ink:#333;
    --muted:#666;
    --line:#e9eef3;
  }

  body{
    margin:0;
    font-family:'Nanum Gothic', sans-serif;
    color: var(--ink);
    background: transparent; /* ✅ view.jsp 안에 삽입되므로 */
  }

  /* ✅ 댓글 상단 페이징(기존 ul.pagination 스타일 개선) */
  .pagination{
    margin: 0 0 12px 0;
  }
  .pagination>li>a{
    border: 1px solid var(--line);
    color:#1f2d3d;
    font-weight: 800;
    border-radius: 10px !important;
    margin-right: 6px;
    padding: 8px 12px;
    transition: background .12s ease, border-color .12s ease, color .12s ease;
  }
  .pagination>li>a:hover{
    background: rgba(72,199,239,.14);
    border-color: rgba(72,199,239,.35);
    color: var(--brand-dark);
  }

  /* ✅ 댓글 카드 */
  .cmt{
    border: 1px solid var(--line);
    border-radius: 14px;
    background:#fff;
    padding: 12px 14px;
    margin-bottom: 10px;
  }

  .cmt-top{
    display:flex;
    align-items:center;
    justify-content:space-between;
    gap: 10px;
    margin-bottom: 6px;
  }

  .cmt-writer{
    font-weight: 900;
    color:#1f2d3d;
    font-size: 15px;
  }

  .cmt-date{
    color:#8a8a8a;
    font-weight: 700;
    font-size: 12.5px;
    margin-bottom: 8px;
  }

  .cmt-content{
    font-size: 14.5px;
    line-height: 1.55;
    color:#333;
    white-space: pre-wrap; /* 줄바꿈 유지 */
    word-break: break-word;
  }

  /* ✅ 삭제 버튼: 작게, 둥글게, 너무 세지 않게 */
  .btn-danger.cmt-del{
    border-radius: 10px;
    border: 2px solid rgba(255,94,87,.55);
    background:#fff;
    color:#ff3b30;
    font-weight: 900;
    padding: 6px 10px;
    line-height: 1;
    min-width: 34px;
    transition: background .12s ease, border-color .12s ease;
  }
  .btn-danger.cmt-del:hover{
    background: rgba(255,94,87,.12);
    border-color: rgba(255,94,87,.85);
  }

  /* 기존 hr 제거/대체 (카드형이라 hr 필요 없음) */
  hr{ display:none; }

  @media (max-width: 768px){
    .pagination>li>a{ padding: 7px 10px; }
    .cmt{ padding: 12px; }
    .cmt-writer{ font-size: 14.5px; }
    .cmt-content{ font-size: 14px; }
  }
</style>

</head>
<body>

<!-- 댓글 메뉴 -->
<c:if test="${ not empty list }">
  <ul class="pagination">
    <li><a href="#disp" onclick="t_comment_list(1);">1</a></li>
    <li><a href="#disp" onclick="t_comment_list(2);">2</a></li>
    <li><a href="#disp" onclick="t_comment_list(3);">3</a></li>
    <li><a href="#disp" onclick="t_comment_list(4);">4</a></li>
    <li><a href="#disp" onclick="t_comment_list(5);">5</a></li>
  </ul>
</c:if>

<!-- forEach -->
<c:forEach var="vo" items="${ list }">

  <div class="cmt">
    <div class="cmt-top">
      <div class="cmt-writer">${vo.c_member}</div>

      <!-- 작성자, 관리자만 삭제 권한 -->
         <c:if test="${member.m_idx eq vo.c_member or member.m_admin eq 2}">
           <input class="btn btn-danger cmt-del" type="button" value="✕"
                           onclick="t_comment_delete('${vo.c_idx}');">
      </c:if>
    </div>

    <div class="cmt-date">${vo.c_regdate}</div>
    <div class="cmt-content">${vo.c_content}</div>
  </div>

</c:forEach>

</body>
</html>
