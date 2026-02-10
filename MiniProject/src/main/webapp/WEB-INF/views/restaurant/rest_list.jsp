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
	
	function insert_form(){location.href = 
		"${pageContext.request.contextPath}/restaurant/test_insert_form.do";}	
	
	</script>

  </head>
<body>

	<div id="reviewBox" style="width:50%;margin:auto;margin-top:50px;">
			
		<div class="row" style="margin-top: 30px; margin-bottom: 5px;">
			<div class="col-sm-4">
        		<input class="btn btn-primary" type="button" value="식당데이타입력임시"
        			onclick="insert_form()">
       		</div>
		</div>		  
		
		<!-- 약식식당목록 -->	  
		<table class="table table-striped table-hover">
			<tr class="success">
			  <!-- line 1 -->
              <th>번호</th>
              <!-- line 2 -->
              <th width="20%">제목</th>
              <!-- line 3 -->
              <th>메뉴</th>
              <!-- line 4 -->
              <th>주소</th>

        	</tr>
        	
        	<c:forEach var="vo"  items="${ list }">
              <tr>
                <!-- line 1 -->
                <td>${ vo.t_r_idx }</td>  
                <!-- line 2 -->              
                <td>${ vo.t_r_name }</td>
                <!-- line 3 -->
                <td>${ vo.t_r_menu }</td>
                <!-- line 4 -->
                <td>${ vo.t_r_addr }</td>              
				          
              </tr>
        	</c:forEach> 
			
		</table>	
	</div>
</body>
</html>