<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.*" %>
<% request.setCharacterEncoding("utf-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="Setting-Introduction-db.css">
<link href="https://fonts.googleapis.com/css2?family=Outfit&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;900&family=Outfit&display=swap" rel="stylesheet">
<title>The Verdict</title>
</head>
<body>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<div id="topBar">
	<h1 id="title" onclick="location.href='Main.jsp'">The Verdict</h1>
	
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
<div id="content">
<h3 id="error">
<%
	int cnt = 0;
	String introduction = null;
	
	introduction = request.getParameter("introduction");
	introduction = introduction.replace("\'", "\\\'");
	
	if(introduction.length() > 1000)
	{
		out.print("자기소개가 1000자를 넘어 변경에 실패했습니다.");	
	}
	else
	{
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(url, "admin", "0000");
			stmt = conn.createStatement();
			
			sql = "update user_data set introduction = '" + introduction + "' where nickname = '" + nickname + "'";
			
			stmt.executeUpdate(sql);
		}
		catch(Exception e) {
			out.println("DB 연동 오류입니다. : " + e.getMessage());
		}
		out.print("자기소개 변경에 성공했습니다.");
	}
%>
</h3>
<%
%>
<button id="back" onclick="location.href='Main.jsp'">메인 화면으로 돌아가기</button>
</div>

<script>
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
</script>
</body>
</html>