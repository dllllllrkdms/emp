<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="vo.*"%>
<%
	// 1. 요청 분석
	request.setCharacterEncoding("UTF-8");
	if(request.getParameter("boardNo")==null || request.getParameter("boardNo").equals("") || request.getParameter("commentNo")==null || request.getParameter("commentNo").equals("")){
		System.out.println(request.getParameter("boardNo")+"<--deleteCommentForm/boardNo");
		response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp");
		return;
	}
	String boardNoStr = request.getParameter("boardNo");
	int boardNo = Integer.parseInt(boardNoStr);
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String msg="";
	if(request.getParameter("msg")!=null){
		msg = request.getParameter("msg");
		System.out.println(msg+"<--updateCommentForm/if문 안");
	}
	System.out.println(msg+"<--updateCommentForm/if문 밖");
	// 2. 요청 처리
		Class.forName("org.mariadb.jdbc.Driver"); // 드라이버로딩
		Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3306/employees","root","java1234"); // db연결
		String commentSql = "SELECT comment_no commentNo, comment_content commentContent, createdate FROM comment WHERE comment_no =?";
		PreparedStatement commentStmt = conn.prepareStatement(commentSql);
		commentStmt.setInt(1, commentNo);
		ResultSet commentRs = commentStmt.executeQuery();
		Comment comment = new Comment();
		if(commentRs.next()){
			comment.commentNo = commentRs.getInt("commentNo");
			comment.commentContent = commentRs.getString("commentContent");
			comment.createdate = commentRs.getString("createdate");
		}
		// 3. 결과 출력
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>updateCommentForm</title>
	<!-- bootstrap -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
	<!-- custom css -->
	<link href="../css/style.css" rel="stylesheet">
	<style>
		textarea {
			width: 100%;
			resize: none; /* 크기고정*/
		}
	</style>
</head>
<body>
	<div class="container">
		 <!-- 메뉴 partial jsp 구성 -->
		<div>
			<jsp:include page="/inc/menu.jsp"></jsp:include>
		</div>
		<h1>자유 게시판</h1>
		<!-- jsp:include는 jsp:param을 이용하여 값을 넘길 수 있음 ** param 은 String 값만 넘겨줄 수 있다-->
		<!-- jsp:include 안에 주석을 달면 오류가 생김(왠지 모르겠음, 됐다가 안됐다가 함.)/value 표현식 안에 인용부호를 쓰면 예외가 생김 -> 검색해서 인용부호예외처리를 하면 되지만 지금은 아예 변수를 만듦 -->
		<div style="float:left">
			<jsp:include page="/inc/boardMenu.jsp"></jsp:include>
			<span id="warning"><%=msg%></span>
		</div>
		<!-- 댓글 수정 -->
		<div id="div-table">
			<form action="<%=request.getContextPath()%>/board/updateCommentAction.jsp">
				<input type="hidden" name="boardNo" value="<%=boardNo%>">
				<input type="hidden" name="commentNo" value="<%=comment.commentNo%>">
				<table class="table table-sm">
					<tr>
						<th colspan="3" style="background-color: #D1E7DD;">&nbsp;</th>
					</tr>
					<tr>
						<td style="vertical-align:top; padding-left:20px; padding-top:20px">
							<div style="padding-bottom: 20px"><input type="password" name="commentPw" placeholder="비밀번호 확인"></div>
							<div><%=comment.createdate%></div>
						</td>
						<td style="padding: 20px"><textarea cols="100" rows="5" name="commentContent"><%=comment.commentContent%></textarea></td>
						<td style="padding: 20px">
							<span style="float:right">
								<button type="submit" class="btn btn-primary">확인</button>
								<a class="btn btn-outline-primary" href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>">취소</a>
							</span>
						</td>
					</tr>
				</table>
			</form>
		</div>
	</div>
</body>
</html>