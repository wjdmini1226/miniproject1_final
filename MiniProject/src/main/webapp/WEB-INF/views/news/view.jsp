<%@ page language="java" contentType="text/html; charset=UTF-8"
		pageEncoding="UTF-8"%>

<%@taglib prefix="c"	uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!-- Bootstrap 3.x -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

<style type="text/css">
	#box{
		width: 800px;
		margin: auto;
		margin-top: 50px;
	}

	.common{
		border: 1px solid #dddddd;
		border-radius: 5px;
		padding: 5px;

	}

	.content{
		min-height: 80px;
	}

	textarea {
	resize: none;
	}

	.cmt_common{
		height: 80px !important;
	}

</style>

<script type="text/javascript">
	function board_delete(f){
		if(confirm("정말 삭제 하시겠습니까?")==false) return;
		f.action = "delete.do";
		f.submit();
	}
</script>
</head>
<body>
	<div id="box">
		<!-- Bootstrap 3.x	Panel -->
		<div class="panel panel-primary">
			<div class="panel-heading"><h4>${ vo.n_company }</h4></div>
				<div class="panel-body">
				<div>
					<label>제목</label>
					<p class="common subject">${ vo.n_title }</p>
				</div>
				<div>
					<label>내용</label>
					<p class="common content">
						${ vo.n_content }
					</p>
				</div>
				<div>
					<label>작성일자</label>
					<p class="common regdate">${ vo.n_regdate }</p>
				</div>
				<div class="common">
					<form class="form-inline">
						<input	class="btn btn-primary" type="button" value="메인화면"
									onclick="location.href='list.do?page=${ param.page }'">
						<!-- 관리자일 경우에만 -->
						<c:if test="${ member.m_admin > 0 }">
			
							<input type="hidden"	name="n_idx" value="${ vo.n_idx }">
							<input type="hidden"	name="page"	value="${ param.page }">
							
							<input	class="btn btn-success" type="button" value="수정하기"
									onclick="location.href='update_form.do?n_idx=${vo.n_idx}'">
							<input	class="btn btn-danger"	type="button" value="삭제하기"
									onclick="board_delete(this.form);">
						</c:if>
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
</html>