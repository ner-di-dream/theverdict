<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.*" %>
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
	<h1 id="title">The Verdict</h1>
</div>
<div id="content">
<h3 id="error">
<%
	int temp = 0, cnt = 0;
	int new_id = 0, ref = 0;
	String e_mail, nickname, password;
	Connection conn = null;
	Statement stmt = null;
	ResultSet rs = null;
	String sql_update;
	
	try {
		Class.forName("com.mysql.jdbc.Driver");
		String url = "jdbc:mysql://172.30.1.47:3306/the_verdict_db";
		conn = DriverManager.getConnection(url, "admin", "0000");
		stmt = conn.createStatement();
		
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
	
	sql_update = "insert into user_data values (" +  cnt + ", '" + e_mail + "', '" + nickname + "', '" + password + "', null, null, 0, 1, 0, 0, 0, 0, 0)";
	try {
		stmt.executeUpdate(sql_update);
	}
	catch(Exception e) {
		out.println("DB 연동 오류입니다. : " + e.getMessage());
	}
%>
</h3>
	<h3 id="notice">회원가입이 완료되었습니다.</h3>
	<button id="back" onclick="location.href='Welcome.jsp'">첫 화면으로 돌아가기</button>
</div>
</body>
</html>