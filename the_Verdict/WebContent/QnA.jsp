<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="false" %>
<% request.setCharacterEncoding("utf-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="Main.css">
<link href="https://fonts.googleapis.com/css2?family=Outfit&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;900&family=Outfit&display=swap" rel="stylesheet">
<title>The Verdict</title>
</head>
<body>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
    $(document).ready(function() {
        $("#title").click(function() {
            location.href = "Main.jsp";
        });
        $("#notification").click(function() {
            location.href = "notification.jsp";
        });
        $("#classify").click(function() {
            
        });
        $("#leaderboard").click(function() {
            location.href = "leaderboard.jsp";
        });
        $("#QnA").click(function() {
            location.href = "QnA.jsp";
        });
        $("#write").click(function() {
            location.href = "Write_content.jsp";
        });
    });
</script>
</head>
<body>
<%
	//if(session.getAttribute("userId") == null){		
	//	response.sendRedirect("Main.jsp");
	//}
%>
<div id="topBar">
	<h1 id="title"><a href="Main.jsp">The Verdict</a></h1>
	<%
		HttpSession loginSession = request.getSession(false);
		if(loginSession == null)
		{
			%>
			<h3 id="login" onclick="location.href='Login.jsp'">
			<%
			out.print("로그인");
			%>
			</h3>
			<%
		}
		else
		{
			String nickname = (String)loginSession.getAttribute("nickname");
			
			if(nickname != null)
			{
				%>
				<h3 id="nickname">
				<%
				out.print(nickname);
				%>
				</h3>
				<h3 id="logout" onclick="location.href='Logout.jsp'">로그아웃</h3>
				<%
			}
			else
			{
				%>
				<h3 id="login" onclick="location.href='Login.jsp'">
				<%
				out.print("로그인");
				%>
				</h3>
				<%
			}
		}
	%>
</div>
<div id="topNavigation">
	<div id = "notification">공지사항</div>
	<div id = "classify">분류</div>
	<div id = "leaderboard">리더보드</div>
	<div id = "QnA">문의하기</div>
	<div id = "write">글쓰기</div>
</div>
<div id="classifyArea">
	
</div>
<div id="content">
</div>
</body>
</html>