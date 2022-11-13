<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 1. 요청 분석
	if(request.getParameter("boardNo")==null || request.getParameter("boardNo").equals("") || request.getParameter("commentNo")==null || request.getParameter("commentNo").equals("")){
		//System.out.println(request.getParameter("boardNo")+"<--deleteCommentForm/boardNo");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp");
		return;
	}
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String msg="";
	if(request.getParameter("msg")!=null){
		msg = request.getParameter("msg");
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<!-- bootstrap -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<!-- custom css -->
	<link href="../css/style.css" rel="stylesheet">
<title>deleteCommentForm</title>
</head>
<body>
	<div class="container">
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		<h1>자유 게시판</h1>
		<!-- jsp:include는 jsp:param을 이용하여 값을 넘길 수 있음 ** jsp:param 은 String 값만 넘겨줄 수 있다-->
		<!-- jsp:include 안에 주석을 달면 오류가 생김(왠지 모르겠음, 됐다가 안됐다가 함.)/value 표현식 안에 인용부호를 쓰면 예외가 생김 -> 검색해서 인용부호예외처리를 하면 되지만 지금은 아예 변수를 만듦 -->
		<div style="float:left;">
			<jsp:include page="/inc/boardMenu.jsp"></jsp:include>
			<span id="warning"><%=msg%></span>
		</div>
		<form action="<%=request.getContextPath()%>/board/deleteCommentAction.jsp" method="post">
			<input type="hidden" name="boardNo" value="<%=boardNo%>">
			<input type="hidden" name="commentNo" value="<%=commentNo%>">
			<div id="div-table">
				<table class="table">
					<thead>
							<tr>
								<th style="padding: 20px" class="table-success" colspan="2">
									<span style="float:left; font-size: 20px;"> 삭제된 댓글은 복구할 수 없습니다. 삭제하시겠습니까?</span>
								</th>
								
							</tr>
						</thead>
						<tbody>
							<tr>
								<td style="font-size:20px; font-weight:600; padding:20px">
									<span>비밀번호 확인</span>
									<span style="padding: 20px"><input type="password" name="commentPw" maxlength="50"></span>
								</td>
								<td style="padding: 20px">
									<span style="float:right">
										<button type="submit" class="btn btn-primary">확인</button>
										<a class="btn btn-outline-primary" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>">취소</a>
									</span>
								</td>
							</tr>
						</tbody>
				</table>
			</div>
		</form>
	</div>
</body>
</html>