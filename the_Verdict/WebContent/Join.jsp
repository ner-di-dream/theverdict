<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("utf-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="Join.css">
<link href="https://fonts.googleapis.com/css2?family=Outfit&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;900&family=Outfit&display=swap" rel="stylesheet">
<title>The Verdict</title>
</head>
<body>
<div id="topBar">
	<h1 id="title" onclick="location.href='Main.jsp'">The Verdict</h1>
</div>
<div id="content">
	<h3 id="notice">회원가입</h3>
	<form action="Join-db.jsp" method="post">
		<input class="joinInfo" id="userId" name="userId" type="email" placeholder="이메일" autocomplete="on">
		<input class="joinInfo" id="userNickname" name="userNickname" type="text" placeholder="닉네임 (16자 이내)" autocomplete="off">
		<input class="joinInfo" id="userPwd" name="userPwd" type="password" placeholder="비밀번호 (8~24자)" autocomplete="off">
		<input class="joinInfo" id="userPwdCheck" type="password" placeholder="비밀번호 확인" autocomplete="off">
		<h5 class="warning" id="noId">이메일을 입력해주세요</h5>
		<h5 class="warning" id="invalidId">유효하지 않은 이메일입니다.</h5>
		<h5 class="warning" id="noNickname">닉네임을 입력해주세요</h5>
		<h5 class="warning" id="invalidNickname">16자 이내로 입력해주세요</h5>
		<h5 class="warning" id="noPwd">비밀번호를 입력해주세요</h5>
		<h5 class="warning" id="invalidPwd">8~24자로 입력해주세요</h5>
		<h5 class="warning" id="noPwdCheck">비밀번호를 확인해주세요</h5>
		<h5 class="warning" id="invalidPwdCheck">비밀번호가 일치하지 않습니다</h5>
		<button id="joinSubmit" type="submit" disabled="disabled">회원가입</button>
	</form>
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>
	<script>
    $(document).ready(function() {
    	
    	function validateEmail(sEmail) {
    		var filter = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
    		if (filter.test(sEmail)) {
    		return true;
    		}
    		else {
    		return false;
    		}
    	}
    	
    	function buttonCheck() {
    		if(idValid && nicknameValid && pwdValid && pwdCheckValid)
    		{
    			$("#joinSubmit").attr("disabled", false);
    		}
    		else
    		{
    			$("#joinSubmit").attr("disabled", true);
    		}
    	}
    	
    	var oldId = "";
    	var oldNickname = "";
    	var oldPwd = "";
    	var oldPwdCheck = "";
    	
    	var idValid = false;
    	var nicknameValid = false;
    	var pwdValid = false;
    	var pwdCheckValid = false;
    	
    	$("#noId").show();
    	$("#invalidId").hide();
    	$("#noNickname").show();
    	$("#invalidNickname").hide();
    	$("#noPwd").show();
    	$("#invalidPwd").hide();
    	$("#noPwdCheck").show();
    	$("#invalidPwdCheck").hide();
    		
    	$("#userId").on("propertychange change keyup paste input", function() {
    		var currentId = $(this).val();
    		if(currentId == oldId) {
    		    return;
    		}
    		oldId = currentId;
    		
			$("#noId").hide();
    		$("#invalidId").hide();	
    		
			if(currentId == "")
			{
				$("#noId").show();
				idValid = false;
				$("#joinSubmit").attr("disabled", true);
				return;
			}
			
			if(!validateEmail(currentId))
			{
				$("#invalidId").show();	
				idValid = false;
			}
			else
			{
				idValid = true;	
			}
			buttonCheck();
    	});
    	
    	$("#userNickname").on("propertychange change keyup paste input", function() {
    		var currentNickname = $(this).val();
    		if(currentNickname == oldNickname) {
    		    return;
    		}
    		oldNickname = currentNickname;
    		
			$("#noNickname").hide();
    		$("#invalidNickname").hide();	
    		
			if(currentNickname == "")
			{
				$("#noNickname").show();
				nicknameValid = false;
				$("#joinSubmit").attr("disabled", true);
				return;
			}
			
			if(currentNickname.length > 16)
			{
				$("#invalidNickname").show();
				nicknameValid = false;
			}
			else
			{
				nicknameValid = true;
			}
			buttonCheck();
    	});
    	
    	$("#userPwd").on("propertychange change keyup paste input", function() {
    		var currentPwd = $(this).val();
    		if(currentPwd == oldPwd) {
    		    return;
    		}
    		oldPwd = currentPwd;
    		
			$("#noPwd").hide();
    		$("#invalidPwd").hide();	
    		
			if(currentPwd == "")
			{
				$("#noPwd").show();
				pwdValid = false;
				$("#joinSubmit").attr("disabled", true);
				return;
			}
			
			if(currentPwd.length > 24 || currentPwd.length < 8)
			{
				$("#invalidPwd").show();
				pwdValid = false;
			}
			else
			{
				pwdValid = true;
			}
			buttonCheck();
    	});
    	
    	$("#userPwdCheck").on("propertychange change keyup paste input", function() {
    		var currentPwdCheck = $(this).val();
    		if(currentPwdCheck == oldPwdCheck) {
    		    return;
    		}
    		oldPwdCheck = currentPwdCheck;
    		
			$("#noPwdCheck").hide();
    		$("#invalidPwdCheck").hide();	
    		
			if(currentPwdCheck == "")
			{
				$("#noPwdCheck").show();
				pwdCheckValid = false;
				$("#joinSubmit").attr("disabled", true);
				return;
			}
			
			if(currentPwdCheck != oldPwd)
			{
				$("#invalidPwdCheck").show();
				pwdCheckValid = false;
			}
			else
			{
				pwdCheckValid = true;
			}
			buttonCheck();
    	});
    	
    });
	</script>
</div>
</body>
</html>