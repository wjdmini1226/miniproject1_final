<%@ page language="java" contentType="text/html; charset=UTF-8" 
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
    
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>review_list JSP</title>

	<!-- Bootstrap 3.x -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>	

  </head>
<body>

	<div id="review_sidebar" style="padding: 15px; background: #f9f9f9; height: 100%; border-right: 1px solid #ddd;">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
        <h4 style="font-weight: bold; margin: 0; color: #333;">💬 방문자 리뷰</h4>
        <button class="btn btn-sm btn-primary" 
                onclick="location.href='${pageContext.request.contextPath}/review/insert_form.do'">
            리뷰 쓰기
        </button>
    </div>

    <c:choose>
        <c:when test="${empty list}">
            <div style="text-align: center; padding: 40px 0; color: #999;">
                <span class="glyphicon glyphicon-comment" style="font-size: 30px; margin-bottom: 10px;"></span>
                <p>첫 번째 리뷰를 남겨주세요!</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="list-group" style="max-height: 500px; overflow-y: auto;">
                <c:forEach var="vo" items="${list}">
                    <div class="list-group-item" style="border-left: 4px solid #337ab7; margin-bottom: 5px;">
                        <div class="d-flex w-100 justify-content-between">
                            <h5 class="mb-1" style="font-weight: bold;">
                            	${vo.v_title}
                            </h5>
                            <small class="text-muted">
                            	${vo.v_regdate}
                            </small>
                        </div>
                        	<p class="mb-1" style="font-size: 0.9em; color: #666;">
                       	 	${vo.v_content}
                        	</p>
	                        <small style="color: #f0ad4e;">
	                            <c:forEach begin="1" end="${vo.v_score}">
	                            	⭐
	                            </c:forEach>
	                            (${vo.v_score}점)
	                        </small>
                        <!-- 작성자 or admin 만 볼 수 있는 버튼 -->
						<c:if test="${ (member.m_idx eq vo.m_idx) 
									or (member.m_idx eq 1) }">
	                        <!-- form으로 함께 던질 수 있도록 비밀선물 -->
	                        <form style="display:inline;">
							<input	type="hidden"  name="v_idx" value="${ vo.v_idx }">													
							<input	class="btn btn-danger" type="button" value="삭제하기"
									onclick="review_delete(this.form);">
							</form>
						</c:if>			
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>    
    
	</div>
</body>
</html>