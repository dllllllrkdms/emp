<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>index</title>
	<style>	
		a:link, a:visited {
			color: black;
			text-decoration: none;
		}
		a:hover {
			color: blue;
		}
		th{
			font-size: 100px;
			text-align: center;
		}
		.center{
		    position: absolute; /* 부모객체를 따라 맞춰짐 */
		    top: 30%;	
		    left: 50%;
		    transform: translate(-50%, -50%);
		}
		.btn{ 
			height: 200px;
			width: 200px; 
			border-radius: 16px;
			font-size: 30px;
			color: black;
			/* 가운데 정렬 */
			display: flex; 
			justify-content: center;
			align-items: center;
			white-space: nowrap;
			
		}
	</style>
</head>
<body>
	<!-- 목차 페이지 -->
	<div class="center">
		<table>
			<tr><th colspan="3">INDEX</th></tr>
			<tr>
				<td><span class="btn" style="background-color: rgb(248,215,218);"><a href="<%=request.getContextPath()%>/dept/deptList.jsp">부서 관리</a></span></td>
				<td><span class="btn" style="background-color: rgb(207,226,255);"><a href="<%=request.getContextPath()%>/emp/empList.jsp">사원 관리</a></span></td>
				<td><span class="btn" style="background-color: rgb(209,231,221);"><a href="<%=request.getContextPath()%>/board/boardList.jsp">게시판 관리</a></span></td>
			</tr>
		</table>	
	</div>
</body>
</html>