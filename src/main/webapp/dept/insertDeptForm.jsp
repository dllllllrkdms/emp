<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// msg 파라메타 값 저장
	String msg = null;
	if(request.getParameter("msg")==null){
		msg = "";
	} else{
		msg= "* " +request.getParameter("msg");
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<!-- bootstrap -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<!-- custom css -->
	<link href="../css/style.css" rel="stylesheet">
	<style>
		h1{
			text-align:center;
		}
	</style>
</head>
<body>
	<div class="container">
		<!-- 중복 영역 처리 메뉴 partial jsp 구성 -->
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include> 
		</div>
		<div><h1>ADD DEPT LIST</h1></div>
		<div id="warning"><%=msg%></div>
		<br>
			<form action="<%=request.getContextPath()%>/dept/insertDeptAction.jsp" method="post">
			<div id="div-table">
				<table class="table">
					<thead class="table-danger">
						<tr>
							<th>부서번호</th>
							<th>부서명</th>
							<th>&nbsp;</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><input type="text" name="deptNo" placeholder="d001"></td>
							<td><input type="text" name="deptName"></td>
							<td><button type="submit" class="btn btn-outline-secondary cellBtn">ADD</button>
						</tr>
					</tbody>
				</table>
			</div>
		</form>
	</div>
</body>
</html>