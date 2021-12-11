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
<link rel="stylesheet" href="AllReviews.css">
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

<%
	String profileNickname = request.getParameter("nickname");
	String pageString = request.getParameter("page");
	int profilePage = 1;
	int count = 0;
	
	if(pageString != null)
	{
		profilePage = Integer.parseInt(pageString);
	}
	if(profileNickname == null)
	{
		%>
		<div>
		<h1 id="userNotFound">해당 유저의 리뷰를 찾을 수 없습니다.</h1>
		</div>
		<%
	}
	else
	{
%>

<h3 id="bestReviewTab"><%= profileNickname %>의 모든 리뷰</h3>
<hr id="bestReviewLine">

<%
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(url, "admin", "0000");
			stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
			sql = "select * from board_data where nickname = '" + profileNickname + "' order by date desc";
			rs = stmt.executeQuery(sql);
		}
		catch(Exception e) {
			out.println("DB 연동 오류입니다. : " + e.getMessage());
		}
			
		if(rs != null)
		{
			
			
			while(rs.next())
			{
				count++;
				if(count >= (profilePage - 1) * 10 + 1 && count <= profilePage * 10)
				{
%>
			<div class="bestReview">
				<h3 class="bestReviewCategory">
				<% out.print(rs.getString("main_category")); %> > <% out.print(rs.getString("subcategory")); %> > <% out.print(rs.getString("product")); %>
				</h3>
				
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
				<img class="bestReviewImage" src="<% rs.getString("picture"); %>">
				<%
				}
				%>
				
				<h3 class="bestReviewTitle"><% out.print(rs.getString("title")); %></h3>
				<h3 class="bestReviewContent"><% out.print(rs.getString("content")); %></h3>
				
				<%
					float avgScore = Float.parseFloat(rs.getString("average_score"));
					DecimalFormat df = new DecimalFormat("0.00");
					df.setRoundingMode(RoundingMode.DOWN);
				%>
				
				<h3 class="bestReviewAvgScore"><% out.print("Verdict Score : ★ " + df.format(avgScore)); %></h3>
				
				<%
					String tag = rs.getString("tag");
					String tagSplit[] = tag.split(";");
				%>
				
				<div class="bestReviewTag1"><% if(tagSplit.length >= 1) out.print("#" + tagSplit[0]); %></div>
				
				<div class="bestReviewTag2"><% if(tagSplit.length >= 2) out.print("#" + tagSplit[1]); %></div>
				
				<div class="bestReviewTag3"><% if(tagSplit.length >= 3) out.print("#" + tagSplit[2]); %></div>
				
				<%
					tag = rs.getString("information");
					String infoSplit[] = tag.split(";");
				%>
				
				<div class="bestReviewInfo1"><% if(infoSplit.length >= 1) out.print("#" + infoSplit[0]); %></div>
				
				<div class="bestReviewInfo2"><% if(infoSplit.length >= 2) out.print("#" + infoSplit[1]); %></div>
				
				<div class="bestReviewInfo3"><% if(infoSplit.length >= 3) out.print("#" + infoSplit[2]); %></div>
				
				<img class="bestReviewLikeImg" src="Image/like.png">
				<h3 class="bestReviewLike"><% out.print(rs.getString("like_amount")); %></h3>
				<img class="bestReviewDislikeImg" src="Image/dislike.png">
				<h3 class="bestReviewDislike"><% out.print(rs.getString("dislike_amount")); %></h3>
			</div>
	<%
				}
			}
			
			if(count == 0)
			{
			%>
			<h3 class="noReviews">작성된 리뷰가 없어요!</h3>
			<%	
			}
		}
		else 
		{
			%>
			<h3 class="noReviews">작성된 리뷰가 없어요!</h3>
			<%	
		}
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
        	var page = <%= profilePage %>
        	if(page == 1)
        	{
        		alert("첫 페이지입니다!");
        	}
        	else
        	{
        		location.href = "AllReviews.jsp?nickname=" + <%= profileNickname %> + "&page=" + (page - 1);
        	}
        });
        
        $("#nextPage").click(function() {
        	var page = <%= profilePage %>
        	if(page > (<%= count %> - 1) / 10)
        	{
        		alert("마지막 페이지입니다!");
        	}
        	else
        	{
        		location.href = "AllReviews.jsp?nickname=" + <%= profileNickname %> + "&page=" + (page * 1 + 1);
        	}
        });
        
        $("#nickname").click(function() {
        	<%
        	if(loginSession != null)
        	{
        	%>
        		location.href = "Profile.jsp?nickname=" + "<%= (String)loginSession.getAttribute("nickname") %>";
        	<%
        	}
        	%>
        });
        $("#topMenu").hide();
        $("#nickname").hover(function() {
    		$("#topMenu").fadeIn();
            }, function(){
            $("#topMenu").fadeOut();
        });
    });
</script>
</body>
</html>