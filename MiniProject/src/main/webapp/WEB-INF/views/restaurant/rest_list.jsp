<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>    
    
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>review_list JSP</title>	

	<script type="text/javascript">
	
	function insert_form(){location.href = 
		"${pageContext.request.contextPath}/restaurant/test_insert_form.do";}	
	
	</script>

  </head>
<body>

	<div id="reviewBox" style="width:100%;margin:auto;margin-top:10px;">
			
		<div class="row" style="margin-top: 30px; margin-bottom: 5px;">
			<div class="col-sm-4">
        		<button onclick="location.href='/restaurant/test_insert_form.do'" 
		            class="btn btn-primary">
		        	📝 직접 식당 정보 등록하기
		        </button> 		       	        
       		</div>
		</div>		  
		
		<!-- 약식식당목록 -->	  
		<table class="table table-striped table-hover">
			<tr class="success">
			  <!-- line 1 -->
              <th width="10%">번호</th>
              <!-- line 2 -->
              <th width="10%">제목</th>
              <!-- line 3 -->
              <th width="15%">메뉴</th>
              <!-- line 4 -->
              <th>주소</th>
              <!-- line 5 -->
              <th width="20%">평점</th>
              <!-- line 6 : 삭제버튼을 위한 숨은 자리 -->
              <th></th>

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
                <!-- line 5 --> 
                <td>    
	                <c:forEach begin="1" end="${vo.t_r_avgscore}">
		             ⭐
		            </c:forEach>
		            (${vo.t_r_avgscore}점)      
				</td>     
				
				<!-- admin 만 볼 수 있는 버튼 -->
				<c:if test="${ member.m_idx eq 1 }">
					<td>
                       <!-- form으로 함께 던질 수 있도록 비밀선물 -->	
                       <form style="display:inline;">
                       <input type="hidden" name="r_idx" value="${ vo.t_r_idx }">	
					   <input	class="btn btn-danger" type="button" value="삭제하기"
					    		onclick="rest_delete(this.form);">
					   </form>
					</td>		
				</c:if>
				     
              </tr>                                   
        	</c:forEach> 
			
		</table>	
	</div>
</body>
</html>