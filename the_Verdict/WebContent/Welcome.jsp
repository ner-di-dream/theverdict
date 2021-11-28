<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="Welcome.css">
<link href="https://fonts.googleapis.com/css2?family=Outfit&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;900&family=Outfit&display=swap" rel="stylesheet">
<title>The Verdict</title>
</head>
<body>
<div>
	<img class="welcomeBackground" src="Image/welcomeBackground.jpg">
	<img class="welcomeBackground" src="Image/transluentBlack.png">
	
	<h1 id="title">The Verdict</h1>
	<h4 id="catchPhrase">세상 모든 것을 리뷰한다!</h4>
	<img id="searchIcon" src="Image/searchIcon.png">
	<input id="search" type="text" placeholder="검색어를 입력하세요" autocomplete="off">
	<h4 id="explanation">소비를 할 수 있는 모든 것에 대하여 리뷰를 올리고, 올린 리뷰를 조회할 수 있는 리뷰 전문 사이트 입니다.</h4>
	<button id="login">로그인</button>
	<h4 id="ifNoAccount">혹은 계정이 없다면...</h4>
	<button id="join" onclick="location.href='Join.jsp'">회원가입</button>
	
	<img class="popup" id="popupBackground" src="Image/transluentBlack.png">
	<div class="popup" id="popupDiv" style="color:white;">
		<input class="popup" id="userId" type="text" placeholder="이메일을 입력하세요" autocomplete="off">
		<input class="popup" id="userPwd" type="password" placeholder="비밀번호를 입력하세요" autocomplete="off">
		<button class="popup" id="loginSubmit" type="submit">로그인</button>
	</div>
	
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>
	<script>
    $(document).ready(function() {
    	$(".popup").hide();
        $("#login").click(function() {
            $(".popup").fadeIn();
        });
        $("#popupBackground").click(function() {
            $(".popup").fadeOut();
        });
    });
	</script>
</div>
</body>
</html>