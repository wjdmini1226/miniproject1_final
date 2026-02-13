<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>게시판 목록</title>

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
    --bg:#f6fcff;
  }

  html,body{ height:100%; }
  body{
    margin:0;
    font-family:'Nanum Gothic', sans-serif;
    background: linear-gradient(180deg, var(--bg), #fff 60%);
    color: var(--ink);
  }

  /* ✅ 페이지 폭 확대 */
  #box{
    width: min(1200px, calc(100vw - 40px));
    margin: 40px auto;
  }

  .panel{
    border-radius: 14px;
    border: 1px solid var(--line);
    box-shadow: 0 14px 32px rgba(0,0,0,.07);
    overflow:hidden;
  }

  .panel-primary>.panel-heading{
    background:#fff;
    border-bottom: 4px solid var(--brand);
    padding: 22px 24px;
  }

  /* ✅ 헤더 글자 크게 */
  .panel-primary>.panel-heading h4{
    margin:0;
    font-size: 28px;
    font-weight: 800;
    letter-spacing:-0.3px;
    color:#1f2d3d;   /* ← 여기만 교체 */
}

  .panel-primary>.panel-heading h4:before{
    content:"💬";
    margin-right:10px;
  }

  .panel-body{
    padding: 22px;
  }

  /* 상단 버튼 영역 */
  .topbar{
    display:flex;
    align-items:center;
    justify-content:space-between;
    gap:12px;
    margin-bottom: 20px;
    padding: 16px;
    border: 1px solid var(--line);
    border-radius: 12px;
    background:#fff;
  }

  .text-muted{
    font-size:18px;     /* 🔥 확대 */
    font-weight:700;
    color:var(--muted) !important;
  }

  /* 버튼 확대 */
  .btn{
    font-size:18px;     /* 🔥 확대 */
    font-weight:800;
    padding:10px 18px;
    border-radius:10px;
    border-width:2px;
  }

  .btn-success{
    background: var(--brand);
    border-color: var(--brand);
    color:#fff;
  }
  .btn-success:hover{
    background: var(--brand-dark);
    border-color: var(--brand-dark);
  }

  .btn-primary{
    background:#fff;
    border-color: var(--brand);
    color: var(--brand-dark);
  }
  .btn-primary:hover{
    background: rgba(72,199,239,.15);
  }

  /* 테이블 확대 */
  .table{
    font-size:20px;     /* 🔥 전체 글자 확대 */
    background:#fff;
    border:1px solid var(--line);
    border-radius:12px;
    overflow:hidden;
  }

  .table>thead>tr>th{
    font-size:20px;
    font-weight:800;
    padding:16px 14px;
    background:#f4fbff;
  }

  .table>tbody>tr>td{
    padding:16px 14px;
  }

  .table-hover>tbody>tr:hover{
    background: rgba(72,199,239,.12);
  }

  .table>tbody>tr>td:nth-child(1),
  .table>tbody>tr>td:nth-child(3),
  .table>tbody>tr>td:nth-child(4){
    text-align:center;
    font-weight:700;
  }

  /* 제목 더 강조 */
  .table a{
    font-size:21px;    /* 🔥 제목 조금 더 큼 */
    font-weight:800;
    color:#333;
    text-decoration:none;
  }
  .table a:hover{
    color: var(--brand-dark);
    text-decoration:underline;
  }

  /* 배지 확대 */
  .label{
    font-size:15px;
    font-weight:800;
    padding:6px 10px;
    border-radius:8px;
  }
  .label-danger{ background:#ff5e57; }
  .label-info{ background:var(--brand); }

  /* 페이지 메뉴 확대 */
  .page-menu{
    text-align:center;
    margin-top:18px;
  }

  .page-menu a,
  .page-menu span{
    font-size:18px;     /* 🔥 확대 */
    font-weight:800;
    padding:10px 16px;
    margin:0 5px;
    border-radius:10px;
    border:1px solid var(--line);
    background:#fff;
    text-decoration:none;
    color:#333;
  }

  .page-menu a:hover{
    border-color:var(--brand);
    background:rgba(72,199,239,.15);
  }

  .page-menu span{
    border-color:var(--brand);
    background:rgba(72,199,239,.25);
    color:var(--brand-dark);
  }

  @media (max-width: 768px){
    #box{ width: calc(100vw - 20px); }
    .topbar{ flex-direction: column; align-items: stretch; }
  }
</style>


<script>
function find(){
    	 //             document.getElementById("search").value; 
    	 //             document.querySelector("#search").value; 
    	 let search			=	$("#search").val();
    	 let search_text 	=	$("#search_text").val().trim();
    	 
    	 //전체보기가 아닐때 값이 비어있으면 
    	 if(search != "all" && search_text== ""){
    		 alert("검색어를 입력하세요!");
    		 $("#search_text").val("");
    		 $("#search_text").focus();
    		 return;
    	 }
    	 
    	 //검색요청
    	 location.href = "list.do?search=" + search + 
    			         "&search_text="  +  encodeURIComponent(search_text , "utf-8");
    	 
    	 
     }//end:find()
  
  </script>
  
  
  <!-- 초기화 이벤트 -->
  <script type="text/javascript">
     
     $(document).ready(function(){
    	 
    	 
    	 if("${ not empty param.search }" == "true"){
    		 
    	 	$("#search").val("${ param.search }");
    	 }
    	 
    	 //전체보기면
    	 if("${ param.search eq 'all' }" == "true"){
    		 
    		 $("#search_text").val("");
    	 }
    	 
     });
  
  </script>

</head>
<body>

<div id="box">

	<!-- 검색메뉴 수정@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ -->
	 
  <div class="panel panel-primary">
    <div class="panel-heading">
    <div class="row">

        <!-- 🔹 왼쪽 : 제목 -->
        <div class="col-sm-4">
            <h4 style="margin:0;">자유게시판</h4>
        </div>

        <!-- 🔹 오른쪽 : 검색메뉴 -->
        <div class="col-sm-8 text-right">
            <form class="form-inline" method="get" action="list.do">
  <select name="search" class="form-control"
          onchange="if(this.value==='all'){ location.href='list.do'; }">
    <option value="all" ${param.search == 'all' || empty param.search ? 'selected' : ''}>전체보기</option>
    <option value="b_title" ${param.search == 'b_title' ? 'selected' : ''}>제목</option>
    <option value="b_content" ${param.search == 'b_content' ? 'selected' : ''}>내용</option>
  
  </select>

  <input type="text" name="search_text" class="form-control"
         value="<c:out value='${param.search_text}'/>" placeholder="검색어" />

  <button type="submit" class="btn btn-primary">검색</button>
</form>


        </div>

    </div>
</div>

    

		  
    <div class="panel-body">

      <c:set var="userObj" value="${sessionScope.member}" />

      <div class="topbar">
        <div>
          <c:if test="${not empty userObj}">
            <button class="btn btn-success"
              onclick="location.href='insert_form.do?page=${empty param.page ? 1 : param.page}'">
              글쓰기
            </button>

            <span class="text-muted">
              ${userObj.m_nickname} 님 환영합니다!
            </span>
          </c:if>

          <c:if test="${empty userObj}">
            <span class="text-muted">로그인 후 글쓰기가 가능합니다.</span>
          </c:if>
        </div>

        <div>
          <button class="btn btn-primary"
            onclick="location.href='${pageContext.request.contextPath}/home.do'">
            홈으로
          </button>
        </div>
      </div>

      <table class="table table-bordered table-hover">
        <thead>
          <tr>
            <th style="width:100px; text-align:center;">번호</th>
            <th style="text-align:center;">제목</th>
            <th style="width:120px; text-align:center;">조회수</th>
            <th style="width:220px; text-align:center;">작성일자</th>

          </tr>
        </thead>

        <tbody>
          <c:if test="${empty list}">
            <tr>
              <td colspan="4" style="text-align:center;">게시물이 없습니다.</td>
            </tr>
          </c:if>

          <c:forEach var="vo" items="${list}">
            <tr>
              <td>${vo.b_idx}</td>

              <td>
                <c:if test="${vo.b_is_notice eq 'Y'}">
                  <span class="label label-danger badge-wrap">공지</span>
                </c:if>
                <c:if test="${vo.b_is_ad eq 'Y'}">
                  <span class="label label-info badge-wrap">홍보</span>
                </c:if>

                <a href="view.do?b_idx=${vo.b_idx}&page=${empty param.page ? 1 : param.page}">
                  <c:out value="${vo.b_title}"/>
                </a>
              </td>

              <td>${vo.b_readhit}</td>
              <td><fmt:formatDate value="${vo.b_regdate}"/></td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
		
		
		<!-- 페이지 메뉴 수정@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ -->
		
		
      <!-- Page Menu -->
       <div style="text-align: center;">
       
           ${ pageMenu }

			<!-- <ul class='pagination'>
				<li><a href='#'>◀</a></li>
				<li class='active'><a href='#'>1</a></li>
				<li><a href='list.do?page=2'>2</a></li>
				<li><a href='list.do?page=3'>3</a></li>
				<li><a href='list.do?page=4'>▶</a></li>
			</ul> -->


		</div>

    

      

		</div>
	</div>
</div>

</body>
</html>
