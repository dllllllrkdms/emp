<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 요청 분석 
	String msg = "";
	if(request.getParameter("msg")!=null){
		msg = request.getParameter("msg");
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>insertBoardForm</title>
	<!-- bootstrap -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<!-- custom css -->
	<link href="../css/style.css" rel="stylesheet">
<style>
	input,textarea {
		width: 100%; 
		box-sizing : border-box;
		padding: 13px;
	}
	input:focus,textarea:focus{
		background-color: white;
	}
</style>
</head>
<body>
	<div class="container">
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		<h1>자유 게시판</h1>
		<div style="float:left">
			<a href="<%=request.getContextPath()%>/board/boardList.jsp" class="btn btn-secondary">목록</a>
			<span id="warning"><%=msg%></span>
		</div>
		
		<div id="div-table">
			<form action="<%=request.getContextPath()%>/board/insertBoardAction.jsp" method="post">
				<table class="table">
					<thead>
						<tr>
							<th colspan="2" style="padding: 20px" class="table-success">
								<span style="float:left; font-size:30px;">글쓰기</span>
								<span style="float:right"><button type="submit" class="btn btn-primary">등록</button></span>
							</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td colspan="2"><input type="text" name="boardTitle" placeholder="제목을 입력해주세요." maxlength="500"></td>
						</tr>
						<tr>
							<td colspan="2"><textarea cols="100" rows="10" name="boardContent" placeholder="내용을 입력해주세요."></textarea></td>
						</tr>
						<tr>
							<td style="font-size:20px; font-weight:600; padding:20px">작성자</td>
							<td><input type="text" name="boardWriter" maxlength="50"></td>
						</tr>
						<tr>
							<td style="font-size:20px; font-weight:600; padding:20px">비밀번호</td>
							<td><input type="password" name="boardPw" maxlength="50"></td>
						</tr>
					</tbody>
				</table>
			</form>
		</div>
	</div>
</body>
</html>