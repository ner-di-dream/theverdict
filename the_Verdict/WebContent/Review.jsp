<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="false" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.math.RoundingMode" %>
<%@ page import="java.text.DecimalFormat" %>
<% request.setCharacterEncoding("utf-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="Review.css">
<link href="https://fonts.googleapis.com/css2?family=Outfit&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;900&family=Outfit&display=swap" rel="stylesheet">
<title>The Verdict</title>
</head>
<body>
<div id="topBar">
	<h1 id="title"><a href="Main.jsp">The Verdict</a></h1>
	
	<input id="search" type="text" placeholder="검색어를 입력하세요" autocomplete="off">
	<img id="searchIcon" src="Image/searchIcon.png">
	
	<%
		Connection conn = null;
		Statement stmt = null;
		String sql = null;
		ResultSet rs = null;
		
		Class.forName("com.mysql.jdbc.Driver");
		String url = "jdbc:mysql://localhost:3306/the_verdict_db";
		conn = DriverManager.getConnection(url, "admin", "0000");
		stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
		
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
		
<%	
		String idString = request.getParameter("id");
		int id = 0;
	if(idString != null)
	{
		id = Integer.parseInt(idString);
		try {
			sql = "select * from board_data where id = " + id;
			rs = stmt.executeQuery(sql);
		}
		catch(Exception e) {
			out.println("DB 연동 오류입니다. : " + e.getMessage());
		}
			
		if(rs != null)
		{
			int reviewCount = 0;
			while(rs.next())
			{
				reviewCount++;
%>
		<div class="div1">
			<h3 class="categoryTab" id="leftTab" onClick="location.href='Category.jsp'">분류</h3>
			<h3 class="categoryTab" onClick="location.href='Category.jsp?category=<%= rs.getString("main_category") %>'">&nbsp;> <%= rs.getString("main_category") %></h3>
			<h3 class="categoryTab" onClick="location.href='Category.jsp?category=<%= rs.getString("subcategory") %>'">&nbsp;> <%= rs.getString("subcategory") %></h3>
			<h3 class="categoryTab" onClick="location.href='Category.jsp?category=<%= rs.getString("product") %>'">&nbsp;> <%= rs.getString("product") %></h3>
		</div>
			<hr class="categoryLine">
		<div class="div6">
		<div class="div2">
			<div class="div3">
				<%
				if(rs.getString("picture") == null)
				{
				%>
				<img class="bestReviewImage" src="Image/NoImage.png">
				<%
				}
				else
				{
				%>
				<img class="bestReviewImage" src="ReviewPhotoProcess.jsp?id=<%= rs.getString("id") %>" onerror="this.src='Image/NoImage.png';">
				<%
				}
				%>
				
				<h3 class="bestReviewTitle"><% out.print(rs.getString("title")); %></h3>
				<img class="bestReviewLikeImg" src="Image/like.png">
				<h3 class="bestReviewLike"><% out.print(rs.getString("like_amount")); %></h3>
				<img class="bestReviewDislikeImg" src="Image/dislike.png">
				<h3 class="bestReviewDislike"><% out.print(rs.getString("dislike_amount")); %></h3>
				
				<%
				ResultSet rs2 = null;
				try {
					Class.forName("com.mysql.jdbc.Driver");
					conn = DriverManager.getConnection(url, "admin", "0000");
					stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
					sql = "select * from user_data where nickname = '" + rs.getString("nickname") + "'";
					rs2 = stmt.executeQuery(sql);
				}
				catch(Exception e) {
					out.println("DB 연동 오류입니다. : " + e.getMessage());
				}
				
				int rating = 0;
				if(rs2 != null)
				{
					while(rs2.next())
					{
						rating = Integer.parseInt(rs2.getString("rating"));
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
				
				<h3 class="bestReviewWriter"><%= rs.getString("nickname") %></h3>
				
				<h3 class="bestReviewDate"><%= rs.getString("date") %></h3>
			</div>
				<div class="div4">
				<h3 class="bestReviewContent">
				
				<% 
					String content = rs.getString("content");
					content = content.replace("\n", "<br>");
					content = content.replace(" ", "&nbsp;");
					out.print(content);
				%>
				</h3>
				</div>
			</div>
			<div class="div5">
				<%
					float avgScore = Float.parseFloat(rs.getString("average_score"));
					DecimalFormat df = new DecimalFormat("0.00");
					df.setRoundingMode(RoundingMode.DOWN);
				%>
				
				<div class="bestReviewAvgScore"><h3><% out.print("Verdict Score : ★ " + df.format(avgScore)); %></h3></div>
				<div class="div7">
				<%
					String tag = rs.getString("tag");
					String tagSplit[] = tag.split(";");
					
					for(int i = 0; i < tagSplit.length; i++)
					{
				%>
					<div class="bestReviewTag"><% out.print("#" + tagSplit[i]); %></div>
				<%
					}
					
				%>
				</div>
					<div class="blank"></div>
					<div class="div8">
					<%
					tag = rs.getString("information");
					String infoSplit[] = tag.split(";");
					
					for(int i = 0; i < infoSplit.length; i += 2)
					{
					%>
					<div class="div9">
					<div class="bestReviewInfo1"><% out.print(infoSplit[i]); %></div>
					<div class="bestReviewInfo2"><% out.print(infoSplit[i + 1]); %></div>
					</div>
					<%
					}
					%>
					</div>
			</div>
			</div>
				
				<%
			}
			if(reviewCount == 0)
			{
				%>
				<h3 class="noReviews">해당 리뷰를 찾을 수 없습니다.</h3>
				<%
			}
		}
		else 
		{
			%>
			<h3 class="noReviews">해당 리뷰를 찾을 수 없습니다.</h3>
			<%	
		}
	}
	else
	{
		%>
		<h3 class="noReviews">해당 리뷰를 찾을 수 없습니다.</h3>
		<%
	}
	%>
</div>

<div class="blank2"></div>

<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
    $(document).ready(function() {
        $("#title").click(function() {
            location.href = "Main.jsp";
        });
        
        $("#searchIcon").click(function() {
        	location.href = "Search.jsp?topic=" + $("#search").val();
        });
        
        $("#search").keydown(function(key) {
            if (key.keyCode == 13) {
            	location.href = "Search.jsp?topic=" + $("#search").val();
            }
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
    });
</script>
</body>
</html>