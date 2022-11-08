<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>index</title>
	<style>
		.list{
			position: absolute; 
			width: 150px;
			height: 150px;
			background-color: rgb(248,215,218);
			border-radius: 16px;
			text-align:center;
			display:table-cell;
			vertical-align:middle;
	
		}
		.center{
		    position: absolute; /* 부모객체를 따라 맞춰짐 */
		    top: 30%;	
		    left: 50%;
		    transform: translate(-50%, -50%);
		}
		a{
			text-decoration: none;
		}
	</style>
</head>
<body>
	<div class="center">
		<h1>INDEX</h1>
		<!-- 목차 페이지 -->
		<div class="list"><a href="<%=request.getContextPath()%>/dept/deptList.jsp" class="center">부서관리</a></div>
	</div>
</body>
</html>