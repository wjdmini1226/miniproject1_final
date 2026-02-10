<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h3 style="margin: 20px 0 10px;">📋 전체 리뷰 목록</h3>

<c:if test="${empty list}">
    <p class="text-muted">아직 등록된 리뷰가 없습니다.</p>
</c:if>

<table class="table table-striped table-hover">
    <tr class="info">
        <th width="10%">번호</th>
        <th>제목</th>
        <th width="15%">점수</th>
        <th width="20%">작성일</th>
    </tr>
    <c:forEach var="vo" items="${list}">
        <tr>
            <td>${vo.v_idx}</td>
            <td>${vo.v_title}</td>
            <td>${vo.v_score} 점</td>
            <td>${vo.v_regdate}</td>
        </tr>
    </c:forEach>
</table>