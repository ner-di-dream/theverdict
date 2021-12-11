<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="false" %>
<%@ page import="java.sql.*" %>
<% request.setCharacterEncoding("utf-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="Leaderboard.css">
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

<div id="content">

<h3 id="halloffameTab">Leaderboard</h3>
<hr id="halloffameLine">

<table id="halloffame" border="1">

			<tr>
				<td align="center" width="100px">Ranking</td>
				<td align="center" width="600px">Nickname</td>
				<td align="center" width="200px">Rating</td>
				<td align="center" width="400px">Tier</td>
			</tr>

<%
	String pageString = request.getParameter("page");
	int rankingPage = 1;
	if(pageString != null)
	{
		rankingPage = Integer.parseInt(pageString);
	}

	try {
		Class.forName("com.mysql.jdbc.Driver");
		conn = DriverManager.getConnection(url, "admin", "0000");
		stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
		sql = "select * from user_data order by rating desc";
		rs = stmt.executeQuery(sql);
	}
	catch(Exception e) {
		out.println("DB 연동 오류입니다. : " + e.getMessage());
	}
	int count = 0;
	int rank = 1;
	int previousRating = -1;
	
	while(rs.next())
	{
		count++;
		
		int rating = Integer.parseInt(rs.getString("rating"));
		
		if(rating != previousRating)
		{
			rank = count;
		}
		
		previousRating = Integer.parseInt(rs.getString("rating"));
		
		if(count > (rankingPage - 1) * 25 && count <= rankingPage * 25)
		{
%>
			<tr>
				<td align="center" width="200px"> <%= rank %> </td>
				<td align="center" width="500px"> <%= rs.getString("nickname") %> </td>
				<td align="center" width="300px"> <%= rs.getString("rating") %> </td>
				<td align="center" width="700px">
				
				<%
				String mainTier = null;
				String detailTier = null;
				
				if(rating >= 3000)
				{
					mainTier = "The Verdict";
				}
				else if(rating >= 2500)
				{
					mainTier = "Master";
				}
				else if(rating >= 2000)
				{
					mainTier = "Diamond";
				}
				else if(rating >= 1500)
				{
					mainTier = "Platinum";
				}
				else if(rating >= 1000)
				{
					mainTier = "Gold";
				}
				else if(rating >= 500)
				{
					mainTier = "Sliver";
				}
				else
				{
					mainTier = "Bronze";
				}
				
				if(rating < 2500)
				{
					if((rating % 500) / 100 == 4)
					{
						detailTier = "I";
					}
					else if((rating % 500) / 100 == 3)
					{
						detailTier = "II";
					}
					else if((rating % 500) / 100 == 2)
					{
						detailTier = "III";
					}
					else if((rating % 500) / 100 == 1)
					{
						detailTier = "IV";
					}
					else
					{
						detailTier = "V";
					}
				}
				
				if(rating < 2500)
				{
					%>
					<%= mainTier + " " + detailTier %>
					<%
				}
				else
				{
					%>
					<%= mainTier %>
					<%
				}
				%>
				
				</td>
			</tr>
<%		
		}
	}
%>
</table>

<%
	if(count == 0)
	{
		%>
		<h1 id="noRanking">리더보드에 등록된 사용자가 없어요!</h1>
		<%
	}
%>

<button id="previousPage">이전 페이지</button>
<button id="nextPage">다음 페이지</button>

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
        
        $("#previousPage").click(function() {
        	var page = <%= rankingPage %>
        	if(page == 1)
        	{
        		alert("리더보드의 첫 페이지입니다!");
        	}
        	else
        	{
        		location.href = "Leaderboard.jsp?page=" + (page - 1);
        	}
        });
        
        $("#nextPage").click(function() {
        	var page = <%= rankingPage %>
        	if(page > (<%= count %> - 1 )/ 25)
        	{
        		alert("리더보드의 마지막 페이지입니다!");
        	}
        	else
        	{
        		location.href = "Leaderboard.jsp?page=" + (page * 1 + 1);
        	}
        });
    });
</script>
</body>
</html>