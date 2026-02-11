<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>답글쓰기</title>

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

<style>
  #box{ width: 700px; margin: 60px auto; }
</style>
</head>
<body>

<div id="box" class="panel panel-warning">
  <div class="panel-heading"><h4>답글쓰기</h4></div>
  <div class="panel-body">
    <p>현재 프로젝트의 DAO/XML/Controller에 답글 등록 로직이 구현되어 있지 않습니다.</p>
    <p>원하면 <b>reply 테이블 구조/컬럼</b> 또는 <b>board 답글형 컬럼(b_ref, b_step, b_depth)</b>로 확장해서 완성해줄게요.</p>
    <button class="btn btn-default" onclick="location.href='list.do'">목록으로</button>
  </div>
</div>

</body>
</html>
