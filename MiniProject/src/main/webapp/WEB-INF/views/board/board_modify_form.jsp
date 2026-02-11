<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>게시글 수정</title>

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic:wght@400;700;800&display=swap" rel="stylesheet">

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

<script src="https://cdn.ckeditor.com/4.22.1/full/ckeditor.js"></script>

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
    font-family:'Nanum Gothic', sans-serif; /* ✅ 동일 폰트 */
    background: linear-gradient(180deg, var(--bg), #fff 60%);
    color: var(--ink);
  }

  /* ✅ 레이아웃 크기/여백: insert/list와 동일 계열 */
  #box{
    width: min(980px, calc(100vw - 30px));
    margin: 40px auto;
  }

  .panel{
    border-radius: 14px;
    border: 1px solid var(--line);
    box-shadow: 0 14px 32px rgba(0,0,0,.07);
    overflow:hidden;
    background:#fff;
  }
  .panel-primary{ border-color: var(--line); }

  /* ✅ 헤더: 화이트 + 하단 브랜드 라인 */
  .panel-primary>.panel-heading{
    background:#fff;
    border:0;
    border-bottom: 4px solid var(--brand);
    padding: 22px 24px;
  }
  .panel-primary>.panel-heading h4{
    margin:0;
    font-size: 28px;
    font-weight: 800;
    letter-spacing:-0.3px;
    color:#1f2d3d;
  }
  .panel-primary>.panel-heading h4:before{
    content:"🛠️";
    margin-right:10px;
  }

  .panel-body{
    padding: 22px 24px;
  }

  .common{ margin-bottom: 14px; }

  /* 라벨 */
  label{
    font-weight: 800;
    color:#1f2d3d;
    margin-bottom: 8px;
  }

  /* 입력 */
  .form-control{
    border-radius: 12px;
    border: 1px solid var(--line);
    box-shadow: none;
    padding: 12px 12px;
    height: auto;
    font-size: 16px;
  }
  .form-control:focus{
    border-color: rgba(72,199,239,.75);
    box-shadow: 0 0 0 3px rgba(72,199,239,.18);
  }

  /* ✅ 하단 버튼 영역(구분선 추가) */
  .actions{
    text-align:center;
    margin-top: 6px;
    padding-top: 16px;
    border-top: 1px solid var(--line);
  }
  .actions .btn{ min-width: 120px; margin: 0 6px; }

  /* 버튼: 기본형 */
  .btn{
    font-weight: 800;
    border-width: 2px;
    border-radius: 10px;
    padding: 10px 18px;
    transition: background .12s ease, color .12s ease, border-color .12s ease, transform .12s ease;
  }
  .btn:active{ transform: translateY(1px); }

  /* 취소: 기본 */
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

  /* 저장: 브랜드 */
  .btn-primary{
    background: var(--brand);
    border-color: var(--brand);
    color:#fff;
  }
  .btn-primary:hover{
    background: var(--brand-dark);
    border-color: var(--brand-dark);
  }

  /* ✅ CKEditor 컨테이너도 동일 톤 */
  .cke{
    border: 1px solid var(--line) !important;
    border-radius: 12px !important;
    overflow:hidden;
  }
  .cke_top{
    background: #f4fbff !important;
    border-bottom: 1px solid var(--line) !important;
  }
  .cke_bottom{
    background: #fff !important;
    border-top: 1px solid var(--line) !important;
  }

  @media (max-width: 768px){
    #box{ width: calc(100vw - 20px); margin: 16px auto; }
    .panel-body{ padding: 16px; }
    .panel-primary>.panel-heading{ padding: 18px 16px; }
    .panel-primary>.panel-heading h4{ font-size: 24px; }
    .actions .btn{ min-width: 44%; margin: 6px 4px; }
  }
</style>

<script>
function save(f){
  const title = (f.b_title.value || "").trim();
  if(title === ""){
    alert("제목을 입력하세요!");
    f.b_title.focus();
    return;
  }

  const editor = CKEDITOR.instances.b_content;
  const html = editor.getData() || "";

  const hasImage = /<img\b[^>]*>/i.test(html);
  let textOnly = html
    .replace(/<img[^>]*>/gi, '')
    .replace(/<[^>]*>/g, '')
    .replace(/&nbsp;/g, '')
    .replace(/\s+/g, '')
    .trim();

  const hasText = textOnly.length > 0;

  if(!hasText && !hasImage){
    alert("내용 또는 이미지를 입력하세요!");
    editor.setData("");
    return;
  }

  editor.updateElement();

  f.method = "POST";
  f.action = "modify.do";
  f.submit();
}
</script>

</head>
<body>

<div id="box">
  <div class="panel panel-primary">
    <div class="panel-heading"><h4>게시글 수정</h4></div>
    <div class="panel-body">

      <form>
        <input type="hidden" name="b_idx" value="${vo.b_idx}">
        <input type="hidden" name="page" value="${empty param.page ? 1 : param.page}">

        <div class="common">
          <label>제목</label>
          <input class="form-control" type="text" name="b_title" maxlength="100"
                 value="<c:out value='${vo.b_title}'/>">
        </div>

        <div class="common">
          <label>내용</label>
          <textarea class="form-control" rows="12" name="b_content"><c:out value="${vo.b_content}"/></textarea>
        </div>

        <div class="common actions">
          <button type="button" class="btn btn-default"
                  onclick="location.href='view.do?b_idx=${vo.b_idx}&page=${empty param.page ? 1 : param.page}'">
            취소
          </button>

          <button type="button" class="btn btn-primary"
                  onclick="save(this.form);">
            저장
          </button>
        </div>
      </form>

    </div>
  </div>
</div> 

<script>
  CKEDITOR.replace('b_content', {
    versionCheck: false,
    filebrowserUploadUrl: '${pageContext.request.contextPath}/ckeditorImageUpload.do',
    enterMode: CKEDITOR.ENTER_BR,
    shiftEnterMode: CKEDITOR.ENTER_P
  });
</script>

</body>
</html>
