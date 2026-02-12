<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>  
    
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
    
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <title>review_list JSP</title>
  </head>
<body>

	<div id="reviewBox" style="width:100%;margin:auto;margin-top:10px;">
			
		<div style="display: flex; justify-content: space-between; align-items: center; margin-top: 30px; margin-bottom: 10px;">
		    <h4 style="font-weight:bold; margin: 0;">📍 주변 식당 목록</h4>
		    
		    <button onclick="goToInsertForm()" 
	            class="btn btn-primary" style="white-space: nowrap;">
		        📝 직접 식당 정보 등록하기
		    </button>
		</div>	
		
		<script type="text/javascript">
			function goToInsertForm() {
			    // kakaoMap.js에 선언한 selectedPlace 변수를 참조합니다.
			    if (!selectedPlace) {
			        alert("지도에서 등록할 식당을 먼저 클릭해주세요!");
			        return;
			    }
			
			    // 선택된 식당 정보를 쿼리 스트링으로 만들어 이동
			    let name = encodeURIComponent(selectedPlace.place_name);
			    let id = selectedPlace.id;
			    let addr = encodeURIComponent(selectedPlace.address_name);
			
			    location.href = "/restaurant/insert_form.do?r_name=" + name + "&r_place_id=" + id + "&r_addr=" + addr;
			} 	  
		</script>
		
		<!-- 약식식당목록 -->	  
		<table class="table table-striped table-hover">
			<tr class="info">
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
                <td>${ vo.r_idx }</td>  
                <!-- line 2 -->              
                <td>${ vo.r_name }</td>
                <!-- line 3 -->
                <td>${ vo.r_menu }</td>
                <!-- line 4 -->
                <td>${ vo.r_addr }</td>   
                <!-- line 5 --> 
                <td>    
	                <c:forEach begin="1" end="${vo.r_avgscore}">
		             ⭐
		            </c:forEach>
		            (${vo.r_avgscore}점)      
				</td>     
				
				<!-- admin 만 볼 수 있는 버튼 -->
				<c:if test="${ member.m_admin eq 2 }">
					<td>
                       <!-- form으로 함께 던질 수 있도록 비밀선물 -->	
                       <form style="display:inline;">
                       <input type="hidden" name="r_idx" value="${ vo.r_idx }">	
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