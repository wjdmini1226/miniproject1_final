<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>    
    
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>review_list JSP</title>

	<!-- Bootstrap 3.x -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

	<script type="text/javascript">
	
	function insert_form(){location.href = "insert_form.do";}	
	
	</script>

  </head>
<body>

	<div id="reviewBox" style="width:50%;margin:auto;margin-top:50px;">
			
		<div class="row" style="margin-top: 30px; margin-bottom: 5px;">
			<div class="col-sm-4">
        		<input class="btn btn-primary" type="button" value="리뷰작성"
        			onclick="insert_form()">
       		</div>
		</div>		  
		
		<!-- 리뷰목록. 한줄평은 vo 및 sql 수정하여 글자수 줄일 필요성? -->	  
		<table class="table table-striped table-hover">
			<tr class="success">
              <th>번호</th>
              <th width="20%">제목</th>
              <th>작성자</th>
              <th>식당</th>
              <th>평가점</th>
              <th width="40%">한줄평</th>
              <th>작성일</th>
              <th></th><!-- 수정버튼과의 맞춤을 위한 공백 th -->
              <th></th><!-- 삭제버튼과의 맞춤을 위한 공백 th -->
        	</tr>
        	
        	<c:forEach var="vo"  items="${ list }">
              <tr>
                <!-- line 1 -->
                <td>${ vo.v_idx }</td>  
                <!-- line 2 -->              
                <td>${ vo.v_title }</td>
                <!-- line 3 -->
                <td>작성자</td>
                <!-- line 4 -->
                <td>식당</td>
                <!-- line 5 -->
                <td>                 
                 	<c:forEach begin="1" end="${ vo.v_score }">
                 		<span style="color:gold;">★</span>
                 	</c:forEach>         
                 	<c:forEach begin="${ vo.v_score + 1 }" end="5">
                 		<span style="color:lightgray;">★</span>
                	</c:forEach>       
                </td>
                <!-- line 6 -->
                <td>${ vo.v_content }</td>
                <!-- line 7 -->
                <td>${ vo.v_regdate }</td>
                 
                <!-- line 8 : 수정버튼 -->
                <td><form action="modify_form.do" method="post">
  					<input type="hidden" name="v_idx" value="${vo.v_idx}">
  					<input class="btn btn-success" type="button" value="수정"
  							onclick="this.form.submit()">
				</form></td>				
            	
            	<!-- line 9 : 삭제버튼 -->                 
                <td><form action="delete.do" method="post" onsubmit="return confirm('정말 삭제하시겠습니까?');">
  					<input type="hidden" name="v_idx" value="${vo.v_idx}">
  					<input class="btn btn-danger" type="submit" value="삭제">
				</form></td>       
				          
              </tr>
        	</c:forEach> 
			
		</table>	
	</div>
</body>
</html>