<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("utf-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="Login-failed.css">
<link href="https://fonts.googleapis.com/css2?family=Outfit&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;900&family=Outfit&display=swap" rel="stylesheet">
<title>The Verdict</title>
</head>
<body>
<div id="topBar">
	<h1 id="title" onclick="location.href='Main.jsp'">The Verdict</h1>
</div>
<div id="content">
	<h3 id="notice">로그인</h3>
	<form action="Login-db.jsp" method="post">
		<input id="userId" type="text" name="userId" placeholder="이메일을 입력하세요" autocomplete="on">
		<input id="userPwd" type="password" name="userPwd" placeholder="비밀번호를 입력하세요" autocomplete="off">
		<button id="loginSubmit" type="submit">로그인</button>
	</form>
	<button id="join" onclick="location.href='Join.jsp'">회원가입</button>
</div>
</body>
</html>