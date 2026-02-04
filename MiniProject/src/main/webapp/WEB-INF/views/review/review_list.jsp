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
	
	<style type="text/css">
		#box{	width		: 1200px;
				margin		: auto;
				margin-top	: 50px;			}
				
		#title{	text-align	: center;
				font-size	: 26px;
				text-shadow	: 1px 1px 1px black;
				color		: hotpink;		}		
	</style>

	<script type="text/javascript">
	
	function insert_form(){location.href = "insert_form.do";}
	
	function modify_form(){location.href = "modify_form.do";}
	
	</script>

  </head>
<body>
	<div id="box">
	
		<h1>TITLE</h1>
		
		<div class="row" style="margin-top: 30px; margin-bottom: 5px;">
			<div class="col-sm-4">
        		<input class="btn btn-primary" type="button" value="리뷰작성"
        			onclick="insert_form()">
       		</div>
		</div>		  
		
		<!-- 리뷰목록. 한줄평은 vo 및 sql 수정하여 글자수 줄일 필요성 -->	  
		<table class="table table-striped table-hover">
			<tr class="success">
              <th>번호</th>
              <th width="50%">제목</th>
              <th>평가점</th>
              <th>한줄평</th>
              <th>작성일</th>
        	</tr>
        	
        	<c:forEach var="vo"  items="${ list }">
              <tr>
                <td>${ vo.v_idx }</td>
                <td>
                 	<a href="view.do?v_idx=${ vo.v_idx }">
                    	${ vo.v_title }
                	</a>                 
                </td>
                <td>                 
                 	<c:forEach begin="1" end="${ vo.v_score }">
                 		<span style="color:gold;">★</span>
                 	</c:forEach>         
                 	<c:forEach begin="${ vo.v_score + 1 }" end="5">
                 		<span style="color:lightgray;">★</span>
                	</c:forEach>       
                </td>
                <td>${ vo.v_content }</td>
                <td>${ vo.v_regdate }</td>
                 
                <!-- 수정버튼 -->
				<td>
                 	<input class="btn btn-success" type="button" value="수정"
					 	   onclick="modify_form()">
            	</td>                 
                 
              </tr>
        	</c:forEach> 
			
		</table>	
	</div>
</body>
</html>