<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>게시글 보기</title>

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
    --bg:#f6fcff; /* ✅ 원래 배경 톤 */
    
    
  }

  html,body{ height:100%; }
  body{
    margin:0;
    font-family:'Nanum Gothic', sans-serif;
    background: linear-gradient(180deg, var(--bg), #fff 60%); /* ✅ 원래처럼 */
    color: var(--ink);
   
    
  }

  #box{
    width: min(980px, calc(100vw - 30px));
    margin: 28px auto;
    
    
  }

  .panel{
    border-radius: 14px;
    box-shadow: 0 12px 26px rgba(0,0,0,.06);
    overflow:hidden;
    background:#fff;
  }
  
  .panel.panel-primary {
  border: 1px solid var(--line) !important;
  }




  /* ✅ 헤더는 댓글쓰기 버튼 색과 동일 */
  .panel-primary>.panel-heading{
    background: var(--brand);
    border:0;
    padding: 18px 20px;
  }
  .panel-primary>.panel-heading h4{
    margin:0;
    font-size: 24px;
    font-weight: 800;
    letter-spacing:-0.25px;
    color:#fff;
    
  }
  .panel-primary>.panel-heading h4:before{
    content:"📄";
    margin-right:10px;
  }

  .panel-body{
    padding: 18px 20px;
   
    
  }

  /* 배지 */
  .badge-wrap{ margin-right:6px; }
  .label{
    border-radius: 10px;
    padding: 5px 9px;
    font-weight: 800;
    font-size: 13px;
  }
  .label-danger{ background:#ff5e57; }
  .label-info{ background: var(--brand-dark); }

  /* 필드 */
  .field{ margin-bottom: 12px; }
  .field label{
    display:block;
    font-weight: 800;
    color:#1f2d3d;
    margin-bottom: 7px;
    font-size: 14px;
  }
  .box{
    border: 1px solid var(--line);
    border-radius: 12px;
    padding: 12px 12px;
    background:#fff;
    word-break: break-word;
    font-size: 15px;
    
  }
  .content{
    min-height: 160px;
    line-height: 1.65;
  }
  .content img{
    max-width: 100%;
    height: auto;
    border-radius: 10px;
  }

  /* 메시지 */
  .alert.alert-warning{
    border-radius: 12px;
    border: 1px solid rgba(255, 193, 7, .35);
    background: rgba(255, 193, 7, .12);
    color:#6a4b00;
    padding: 10px 12px;
    margin-top: 10px;
  }

  /* 버튼 */
  .actions{
    text-align:center;
    margin-top: 14px;
    padding-top: 14px;
    border-top: 1px solid var(--line);
  }
  .btn{
    font-weight: 800;
    border-width: 2px;
    border-radius: 10px;
    padding: 9px 16px;
    transition: background .12s ease, color .12s ease, border-color .12s ease, transform .12s ease;
    min-width: 104px;
    margin: 0 5px;
  }
  .btn:active{ transform: translateY(1px); }

  .btn-default{
    background:#fff;
    border-color: var(--line);
    color:#333;
  }
  .btn-default:hover{
    background:#f7fbff;
    border-color: rgba(72,199,239,.35);
    color:#1f2d3d;
  }

  .btn-success{
    background:#fff;
    border-color: var(--brand);
    color: var(--brand-dark);
  }
  .btn-success:hover{
    background: rgba(72,199,239,.15);
    border-color: var(--brand-dark);
    color: var(--brand-dark);
  }

  .btn-danger{
    background:#fff;
    border-color: rgba(255,94,87,.65);
    color:#ff3b30;
  }
  .btn-danger:hover{
    background: rgba(255,94,87,.12);
    border-color: rgba(255,94,87,.85);
    color:#ff3b30;
  }

  .text-muted{
    color: var(--muted) !important;
    font-weight: 700;
  }

  hr{
    border-top: 1px solid rgba(233,238,243,.9);
    margin: 18px 0;
  }

  /* 댓글 카드 */
  .comment-card{
    border: 1px solid rgba(233,238,243,.95);
    border-radius: 14px;
    background:#fff;
    box-shadow: 0 12px 26px rgba(0,0,0,.05);
    padding: 14px;
  }

  textarea{ resize:none; }
  .c_common{ height: 84px !important; }

  #c_content.form-control{
    border-radius: 12px;
    border: 1px solid var(--line);
    box-shadow:none;
    padding: 10px 10px;
    font-size: 15px;
  }
  #c_content.form-control:focus{
    border-color: rgba(72,199,239,.75);
    box-shadow: 0 0 0 3px rgba(72,199,239,.18);
  }

  /* 댓글쓰기 버튼 */
  input.btn.btn-primary.c_common{
    width:100%;
    height: 84px !important;
    border-radius: 12px;
    border: 2px solid var(--brand);
    background: var(--brand);
    font-weight: 800;
    font-size: 15px;
    color:#fff;
  }
  input.btn.btn-primary.c_common:hover{
    background: var(--brand-dark);
    border-color: var(--brand-dark);
  }

  #disp{ margin-top: 10px; }

  @media (max-width: 768px){
    #box{ width: calc(100vw - 20px); margin: 16px auto; }
    .panel-body{ padding: 16px; }
    .panel-primary>.panel-heading{ padding: 16px; }
    .panel-primary>.panel-heading h4{ font-size: 22px; }
    .btn{ min-width: 44%; margin: 6px 4px; }
    .actions{ text-align:left; }
  }
</style>

<script>
function doDelete(f){
  if(!confirm("삭제하시겠습니까?")) return;
  f.method = "POST";
  f.action = "delete.do";
  f.submit();
}
</script>

<script type="text/javascript">

  $(document).ready(function(){
    t_comment_list(1);
  });

  function t_comment_insert(){

    if("${empty sessionScope.member}"=="true"){

      if(confirm("댓글은 로그인후 작성 가능합니다\n로그인 하시겠습니까?")==false) return;

      location.href = "${pageContext.request.contextPath}/login_form.do?url=" + encodeURIComponent(location.href);
      return;
    }

    let c_content = $("#c_content").val().trim();
    if(c_content==""){
      alert("내용을 입력하세요");
      $("#c_content").val("");
      $("#c_content").focus();
      return;
    }

    $.ajax({
      url      : "../t_comment/insert.do",
      data     : {
                  "c_board"     : "${vo.b_idx}",
                  "c_content" : c_content,
                  "c_member"     : "${sessionScope.member.m_idx}",
                  "m_name"    : "${sessionScope.member.m_nickname}"
                },
      dataType : "json",
      success  : function(res_data){
                  if(res_data.result==false){
                    alert("댓글쓰기 실패!!");
                    return;
                  }

                  $("#c_content").val("");
                  t_comment_list(1);
                },
      error    : function(err){
                  alert(err.responseText);
                }
    });

  }

  function t_comment_list(p){
    $.ajax({
      url      : "../t_comment/list.do",
      data     : { "b_idx" : "${vo.b_idx}", "page" : p },
      dataType : "html",
      success  : function(res_data){
                  $("#disp").html(res_data);
                },
      error    : function(err){
                  alert(err.responseText);
                }
    });
  }

  function t_comment_delete(c_idx) {
    if(!confirm("정말 이 댓글을 삭제하시겠습니까?")) return;

    $.ajax({
      url : "../t_comment/delete.do",
      data: {"c_idx": c_idx},
      dataType: "json",
      success: function(res_data) {
        if(res_data.result) {
          alert("삭제되었습니다.");
          t_comment_list(1);
        } else {
          alert("삭제 실패!");
        }
      },
      error: function(err) {
        console.log(err.responseText);
      }
    });
  }
</script>

</head>
<body>

<c:set var="pageNo" value="${empty param.page ? 1 : param.page}" />

<c:set var="login" value="${sessionScope.member}" />
<c:set var="isAdmin" value="${not empty login and login.m_admin == 2}" />
<c:set var="isOwner" value="${not empty login and not empty vo and (login.m_idx eq vo.m_idx)}" />

<div id="box">

  <div class="panel panel-primary">
    <div class="panel-heading" style="background: var(--brand)"><h4>${vo.b_title} 상세보기</h4></div>

    <div class="panel-body">

      <div style="margin-bottom:12px;">
        <c:if test="${vo.b_is_notice eq 'Y'}">
          <span class="label label-danger badge-wrap">공지</span>
        </c:if>
        <c:if test="${vo.b_is_ad eq 'Y'}">
          <span class="label label-info badge-wrap">홍보</span>
        </c:if>
      </div>

      <div class="field">
        <label>제목</label>
        <div class="box"><c:out value="${vo.b_title}"/></div>
      </div>

      <div class="field">
        <label>내용</label>
        <div class="box content">
          <c:out value="${vo.b_content}" escapeXml="false"/>
        </div>
      </div>

      <div class="field">
        <label>조회수</label>
        <div class="box">${vo.b_readhit}</div>
      </div>

      <div class="field">
        <label>작성/수정일</label>
        <div class="box">${vo.b_regdate} (${vo.b_modifydate})</div>
      </div>

      <c:if test="${not empty msg}">
        <div class="alert alert-warning">
          <c:out value="${msg}"/>
        </div>
      </c:if>

      <div class="actions">
        <button type="button" class="btn btn-default"
                onclick="location.href='list.do?page=${pageNo}'">
          목록
        </button>

        <c:if test="${isAdmin or isOwner}">
          <button type="button" class="btn btn-success"
                  onclick="location.href='modify_form.do?idx=${vo.b_idx}&page=${pageNo}'">
            수정
          </button>

          <form style="display:inline;">
            <input type="hidden" name="b_idx" value="${vo.b_idx}">
            <input type="hidden" name="page" value="${pageNo}">
            <button type="button" class="btn btn-danger" onclick="doDelete(this.form);">삭제</button>
          </form>
        </c:if>

        <c:if test="${empty login}">
          <span class="text-muted" style="margin-left:10px;">로그인 후 수정/삭제가 가능합니다.</span>
        </c:if>
      </div>

    </div>
  </div>

  <hr>

  <div class="comment-card">
    <div class="row" style="margin:0;">
      <div class="col-sm-10" style="padding-left:0;">
        <textarea id="c_content" class="form-control c_common" placeholder="댓글은 로그인후에 작성가능합니다"></textarea>
      </div>
      <div class="col-sm-2" style="padding-right:0;">
        <input class="btn btn-primary c_common" type="button" value="댓글쓰기" onclick="t_comment_insert();">
      </div>
    </div>

    <hr style="margin:14px 0;">

    <div id="disp"></div>
  </div>

</div>

</body>
</html>
