<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c"  uri="http://java.sun.com/jsp/jstl/core" %>
    
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
     width: 1000px;
     margin: auto;
     margin-top: 30px;
  }
  
   #title{
       text-align: center;
       font-size: 26px;
       color:rgb(51,122,183);
       text-shadow: 1px 1px 1px black;
       
   }
</style>

<script type="text/javascript">
	if("${not empty param.reason}"=="true")
		$(()=>{
			setTimeout(() => {
				let message = "잘못된 접근입니다"
				switch("${param.reason}"){
				case "no news":message="기사가 없습니다";break;
				case "insert failed":message="기사 작성에 실패했습니다";break;
				case "update failed":message="기사 수정에 실패했습니다";break;
				case "delete failed":message="기사 삭제에 실패했습니다";
				}
				alert(message);
			}, 100);
		});
	function insert_form(){
		if("${ member.m_admin == 2 }" != "true"){
			// 관리자만 가능
			alert("잘못된 접근입니다");
			return;
		}
		location.href = "insert_form.do";
	}
</script>

</head>
<body>
  
  <div id="box">
       <h1 id="title">기사</h1>
       <c:if test="${ member.m_admin == 2 }">
	       <div class="row" style="margin-top: 30px; margin-bottom: 5px;">
			  <div class="col-sm-4">
			      <input class="btn btn-primary" type="button" value="기사 작성" 
			             onclick="insert_form();">
			  </div>
		   </div>
       </c:if>
       
       <!-- 게시글 -->
       <table class="table table-striped table-hover">
           <!-- table title -->
           <tr class="success">
              <th>번호</th>
              <th width="50%">제목</th>
              <th>신문사</th>
              <th>작성일자</th>
              <th>조회수</th>
           </tr>
           
           <!-- table data  -->
           <!-- 게시글이 없는경우 -->
           <c:if test="${ empty list }">
              <tr>
                 <td colspan="5" align="center">
                    <font color="red">등록된 기사가 없습니다</font>
                 </td>
              </tr>
           </c:if>
           
           <!-- 게시글이 있는 경우 -->
           <!-- for(BoardVo vo : list) -->
           <c:forEach var="vo"  items="${ list }">
              <tr>
                 <td>${ vo.n_idx }</td>
                 <td>
                   <a href="view.do?n_idx=${ vo.n_idx }&page=${ (empty param.page) ? 1 : param.page }">${ vo.n_title }</a>
                 </td>
                 <td>${ vo.n_company }</td>
                 <td>${ vo.n_regdate }</td>
                 <td>${ vo.n_readhit }</td>
              </tr>
           </c:forEach>
       </table>
       
       <!-- Page Menu -->
       <div style="text-align: center;">
           ${ paging }
		</div>
  
  </div>
  
</body>
</html>