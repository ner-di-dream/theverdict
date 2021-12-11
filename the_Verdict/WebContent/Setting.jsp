<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="false" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.RoundingMode" %>
<%@ page import="java.text.DecimalFormat" %>
<% request.setCharacterEncoding("utf-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="Setting.css">
<link href="https://fonts.googleapis.com/css2?family=Outfit&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;900&family=Outfit&display=swap" rel="stylesheet">
<title>The Verdict</title>
</head>
<body>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<div id="topBar">
	<h1 id="title"><a href="Main.jsp">The Verdict</a></h1>
	<%
		HttpSession loginSession = request.getSession(false);
		String nickname = null;
	
		if(loginSession == null)
		{
		%>
		<script>
			alert("로그인이 필요합니다.");
			document.location.href = "Main.jsp";
		</script>
		<%
		}
		else
		{
			nickname = (String)loginSession.getAttribute("nickname");
		}
		
		Connection conn = null;
		Statement stmt = null;
		String sql = null;
		ResultSet rs = null;
		
		Class.forName("com.mysql.jdbc.Driver");
		String url = "jdbc:mysql://localhost:3306/the_verdict_db";
		conn = DriverManager.getConnection(url, "admin", "0000");
		stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);


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
			if(nickname != null)
			{	
				try {
					sql = "select * from user_data where nickname = '" + nickname + "'";
					rs = stmt.executeQuery(sql);
				}
				catch(Exception e) {
					out.println("DB 연동 오류입니다. : " + e.getMessage());
				}
				
				int rating = 0;
				if(rs != null)
				{
					while(rs.next())
					{
						rating = Integer.parseInt(rs.getString("rating"));
						
						if(rs.getString("profile_picture") == null)
						{
						%>
						<img class="profilePicture" src="Image/NoProfileImage.png">
						<%
						}
						else
						{
						%>
						<img class="profilePicture" src="ProfilePhotoProcess.jsp?nickname=<%= nickname %>" onerror="this.src='Image/NoProfileImage.png';">
						<%
						}
					}
				}
				
				if(rating >= 3000)
				{
				%>
					<img class="topTier" src="Image/Tier_27.png">
				<%
				}
				else if(rating >= 2500)
				{
				%>
					<img class="topTier" src="Image/Tier_26.png">
				<%
				}
				else
				{
				%>
					<img class="topTier" src="Image/Tier_<%= (int)(rating / 100) + 1 %>.png">
				<%
				}
				%>
				<h3 id="nickname" class="topMenuTrigger">
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

<div id="topMenu" class="topMenuTrigger">
<h3 id="myProfile">내 프로필</h3>
<h3 id="myReview">내 리뷰</h3>
<h3 id="setting">계정 및 프로필 관리</h3>
</div>

<div id="topNavigation">
	<div id = "notification">공지사항</div>
	<div id = "classify">분류</div>
	<div id = "leaderboard">리더보드</div>
	<div id = "QnA">문의하기</div>
	<div id = "write">글쓰기</div>
</div>

<%
	try {
		sql = "select * from user_data where nickname = '" + nickname + "'";
		rs = stmt.executeQuery(sql);
	}
	catch(Exception e) {
		out.println("DB 연동 오류입니다. : " + e.getMessage());
	}

	String introduction = "자기소개를 입력해주세요.";

	if(rs != null)
	{
		while(rs.next())
		{
			if(rs.getString("introduction") != null)
			{
				introduction = rs.getString("introduction");
				introduction = introduction.replace("<br>", "\r\n");
			}
		}
	}
%>

<div id="content">
<h1 id="introductionNotice">자기소개 변경</h1>
<form action="Setting-Introduction-db.jsp" method="post">
	<textarea id="introduction" name="introduction" autocomplete="off"><%= introduction %></textarea>
	<h3 id="introductionLength">1000자 제한</h3>
	<button id="introductionSubmit" type="submit">자기소개 변경</button>
</form>

<h1 id="pictureNotice">프로필 사진 변경</h1>
<form action="profile_picture" method="post" enctype="multipart/form-data">
	<input type="file" id="image" name="image" accept="image/*">
	<img id="imagePreview" src="Image/NoProfileImage.png">
	<button id="pictureSubmit" type="submit" disabled="disabled">프로필 사진 변경</button>
</form>

<h1 id="passwordNotice">비밀번호 변경</h1>
<form action="Setting-Password-db.jsp" method="post">
	<input class="joinInfo" id="userOriginalPwd" name="userOriginalPwd" type="password" placeholder="기존 비밀번호" autocomplete="off">
	<input class="joinInfo" id="userPwd" name="userPwd" type="password" placeholder="새로운 비밀번호 (8~24자)" autocomplete="off">
	<input class="joinInfo" id="userPwdCheck" type="password" placeholder="새로운 비밀번호 확인" autocomplete="off">
	<h5 class="warning" id="noOriginalPwd">기존 비밀번호를 입력해주세요</h5>
	<h5 class="warning" id="noPwd">새로운 비밀번호를 입력해주세요</h5>
	<h5 class="warning" id="invalidPwd">8~24자로 입력해주세요</h5>
	<h5 class="warning" id="noPwdCheck">새로운 비밀번호를 확인해주세요</h5>
	<h5 class="warning" id="invalidPwdCheck">새로운 비밀번호가 일치하지 않습니다</h5>
	<button id="passwordSubmit" type="submit" disabled="disabled">비밀번호 변경</button>
</form>
</div>

<div id="bottom">
</div>

<script>
    $(document).ready(function() {
        $("#title").click(function() {
            location.href = "Main.jsp";
        });
        $("#notification").click(function() {
            location.href = "Notification.jsp";
        });
        $("#classify").click(function() {
        	location.href = "Category.jsp";
        });
        $("#leaderboard").click(function() {
            location.href = "Leaderboard.jsp";
        });
        $("#QnA").click(function() {
            location.href = "QnA.jsp";
        });
        $("#write").click(function() {
            location.href = "Write_content.jsp";
        });
        $("#nickname, #myProfile").click(function() {
        	<%
        	if(loginSession != null)
        	{
        	%>
        		location.href = "Profile.jsp?nickname=" + "<%= (String)loginSession.getAttribute("nickname") %>";
        	<%
        	}
        	%>
        });
        $("#myReview").click(function() {
        	<%
        	if(loginSession != null)
        	{
        	%>
        		location.href = "AllReviews.jsp?nickname=" + "<%= (String)loginSession.getAttribute("nickname") %>" + "&page=1";
        	<%
        	}
        	%>
        });
        $("#setting").click(function() {
        	location.href = "Setting.jsp";
        });
        $("#topMenu").hide();
        $("#nickname").mouseenter(function() {
    		$("#topMenu").fadeTo(200, 0.8);
        });
        $("#topMenu").mouseleave(function(){
            $("#topMenu").fadeTo(200, 0);
        });
        $("#introduction").on("keyup", function() {
        	var convert = $(this).val();
        	var convertQuote = convert.split('\'').length;
            $("#introductionLength").html("(" + (convert.length + convertQuote * 4) + " / 1000)");
            if(convert.length + convertQuote * 4 > 1000)
            {
            	$("#introductionSubmit").attr("disabled", true);	
            }
            else
            {
            	$("#introductionSubmit").attr("disabled", false);
            }
        });
        
        document.getElementById("image").onchange = function () {
            var reader = new FileReader();

            reader.onload = function (e) {
                // get loaded data and render thumbnail.
                document.getElementById("imagePreview").src = e.target.result;
            };

            // read the image file as a data URL.
            reader.readAsDataURL(this.files[0]);
            $("#pictureSubmit").attr("disabled", false);
        };
        
        function buttonCheck() {
    		if(originalPwdValid && pwdValid && pwdCheckValid)
    		{
    			$("#passwordSubmit").attr("disabled", false);
    		}
    		else
    		{
    			$("#passwordSubmit").attr("disabled", true);
    		}
    	}
    	
    	var oldPwd = "";
    	var oldPwdCheck = "";
    	
    	var originalPwdValid = false;
    	var pwdValid = false;
    	var pwdCheckValid = false;
    	
    	$("#noPwd").show();
    	$("#invalidPwd").hide();
    	$("#noPwdCheck").show();
    	$("#invalidPwdCheck").hide();
    	
    	$("#userOriginalPwd").on("propertychange change keyup paste input", function() {
    		var currentOriginalPwd = $(this).val();
    		
			$("#noOriginalPwd").hide();	
    		
			if(currentOriginalPwd == "")
			{
				$("#noOriginalPwd").show();
				originalPwdValid = false;
				$("#joinSubmit").attr("disabled", true);
				return;
			}
			else
			{
				originalPwdValid = true;	
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
</body>
</html>