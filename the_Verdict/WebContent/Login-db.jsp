<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="false" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.util.*" %>
<% request.setCharacterEncoding("utf-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="Join-db.css">
<link href="https://fonts.googleapis.com/css2?family=Outfit&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;900&family=Outfit&display=swap" rel="stylesheet">
<title>The Verdict</title>
</head>
<body>
<div id="topBar">
	<h1 id="title" onclick="location.href='Main.jsp'">The Verdict</h1>
</div>
<div id="content">
<h3 id="error">
<%
	String e_mail = null;
	String password = null;
	String answer = null;
	String nickname = null;
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;
	String sql_update;
	
	e_mail = request.getParameter("userId");
	password = request.getParameter("userPwd");
	
	try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		String url = "jdbc:mysql://172.30.1.47:3306/the_verdict_db";
		conn = DriverManager.getConnection(url, "admin", "0000");
		stmt = conn.createStatement();
		
		sql_update = "select password as answer from user_data where e_mail = '" + e_mail + "'";
		rs = stmt.executeQuery(sql_update);
	}
	catch(Exception e) {
		out.println("DB 연동 오류입니다. : " + e.getMessage());
	}
	
	while(rs.next()) {
		answer = rs.getString("answer");
	}
	
	if(Objects.equals(answer, password) && answer != null)
	{
		try {
			sql_update = "select nickname as nickname from user_data where e_mail = '" + e_mail + "'";
			rs = stmt.executeQuery(sql_update);
		}
		catch(Exception e) {
			out.println("DB 연동 오류입니다. : " + e.getMessage());
		}
		
		while(rs.next()) {
			nickname = rs.getString("nickname");
		}
		
		HttpSession loginSession = request.getSession(true);
		loginSession.setAttribute("nickname", nickname);
		%>
		<script src="http://code.jquery.com/jquery-latest.min.js"></script>
		<script>
			location.href="Main.jsp";
		</script>
		<%
	}
	else
	{
		%>
		<script>
			location.href="Login-failed.jsp";
		</script>
		<%
	}
%>
</h3>
	<h3 id="notice">로그인 중...</h3>
	<!-- <button id="back" onclick="location.href='Welcome.jsp'">첫 화면으로 돌아가기</button> -->
</div>
</body>
</html>