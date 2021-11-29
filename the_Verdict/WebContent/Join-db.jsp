<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.*" %>
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
	int cnt = 0;
	String e_mail, nickname, password;
	int e_mailOverlap = -1;
	int nicknameOverlap = -1;
	
	String url = "jdbc:mysql://172.30.1.47:3306/the_verdict_db?useUnicode=true&characterEncoding=UTF-8";
	
	String sql_update;
	ResultSet rs = null;
	
	try {
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection(url, "admin", "0000");
		Statement stmt = conn.createStatement();
		
		sql_update = "select count(*) as cnt from user_data";
		rs = stmt.executeQuery(sql_update);
	}
	catch(Exception e) {
		out.println("DB 연동 오류입니다. : " + e.getMessage());
	}
	
	while(rs.next()) {
		cnt = Integer.parseInt(rs.getString("cnt"));
	}
	
	cnt++;
	e_mail = request.getParameter("userId");
	nickname = request.getParameter("userNickname");
	password = request.getParameter("userPwd");
	
	try {
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection(url, "admin", "0000");
		Statement stmt = conn.createStatement();
		
		sql_update = "select user_number as num1 from user_data where e_mail = '" + e_mail + "'";
		rs = stmt.executeQuery(sql_update);
	}
	catch(Exception e) {
		out.println("DB 연동 오류입니다. : " + e.getMessage());
	}
	
	while(rs.next()) {
		e_mailOverlap = Integer.parseInt(rs.getString("num1"));
	}
	
	try {
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection(url, "admin", "0000");
		Statement stmt = conn.createStatement();
		
		sql_update = "select user_number as num2 from user_data where nickname = '" + nickname + "'";
		rs = stmt.executeQuery(sql_update);
	}
	catch(Exception e) {
		out.println("DB 연동 오류입니다. : " + e.getMessage());
	}
	
	while(rs.next()) {
		nicknameOverlap = Integer.parseInt(rs.getString("num2"));
	}
	
	// out.println(e_mailOverlap + " " + nicknameOverlap);
	
	if(e_mailOverlap == -1 && nicknameOverlap == -1)
	{
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection conn = DriverManager.getConnection(url, "admin", "0000");
			Statement stmt = conn.createStatement();
			
			sql_update = "insert into user_data values (" +  cnt + ", '" + e_mail + "', '" + nickname + "', '" + password + "', null, null, 0, 1, 0, 0, 0, 0, 0)";
			
			stmt.executeUpdate(sql_update);
		}
		catch(Exception e) {
			out.println("DB 연동 오류입니다. : " + e.getMessage());
		}
	}
	
%>
</h3>
<%
	if(e_mailOverlap == -1 && nicknameOverlap == -1)
	{
		%>
		<h3 id="notice">회원가입이 완료되었습니다.</h3>
		<%
	}
	else
	{
		%>
		<button id="join" onclick="location.href='Join.jsp'">다시 회원가입</button>
		<%
	}

	if(e_mailOverlap != -1)
	{
		%>
		<h3 id="e_mailError">해당 이메일로 가입된 계정이 이미 존재합니다.</h3>
		<%
	}
	if(nicknameOverlap != -1)
	{
		%>
		<h3 id="nicknameError">닉네임이 중복되어 사용할 수 없습니다.</h3>
		<%
	}
%>
<button id="back" onclick="location.href='Welcome.jsp'">첫 화면으로 돌아가기</button>
</div>
</body>
</html>