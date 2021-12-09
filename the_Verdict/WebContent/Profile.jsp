<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="false" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.util.*" %>
<% request.setCharacterEncoding("utf-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="Profile.css">
<link href="https://fonts.googleapis.com/css2?family=Outfit&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;900&family=Outfit&display=swap" rel="stylesheet">
<title>The Verdict</title>
</head>
<body>
<div id="topBar">
	<h1 id="title"><a href="Main.jsp">The Verdict</a></h1>
	<%
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
				%>
				<h3 id="nickname">
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

<div id="topMenu">
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
	if(profileNickname == null)
	{
%>
		<h1 class="userNotFound">해당 유저의 프로필을 찾을 수 없습니다.</h1>
		<%
	}
	else
	{
		Connection conn = null;
		Statement stmt = null;
		String sql = null;
		ResultSet rs = null;
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			String url = "jdbc:mysql://localhost:3306/the_verdict_db";
			conn = DriverManager.getConnection(url, "admin", "0000");
			stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
			sql = "select * from user_data where nickname = '" + profileNickname + "'";
			rs = stmt.executeQuery(sql);
		}
		catch(Exception e) {
			out.println("DB 연동 오류입니다. : " + e.getMessage());
		}
			
		if(rs == null)
		{
		%>
			<h1 class="userNotFound">해당 유저의 프로필을 찾을 수 없습니다.</h1>
				<%
		}
		else
		{
			while(rs.next())
			{
				int like = Integer.parseInt(rs.getString("like_amount"));
				int dislike = Integer.parseInt(rs.getString("dislike_amount"));
				int realLike = like - dislike;
				int realLikeRating = 0;
				if(realLike >= 0)
				{
					realLikeRating = (int)(Math.pow(realLike, 0.5) * 30);
				}
				if(realLikeRating > 3000)
				{
					realLikeRating = 3000;
				}
				
				int reviewAmount = Integer.parseInt(rs.getString("review_amount"));
				int commentAmount = Integer.parseInt(rs.getString("comment_amount"));
				int reviewRating =  (int)(Math.pow(reviewAmount, 0.5) * 100);
				if(reviewRating > 1000)
				{
					reviewRating = 1000;
				}
				int commentRating = (int)(Math.pow(commentAmount, 0.5) * 10);
				if(commentRating > 1000)
				{
					commentRating = 1000;
				}
				%>
				<div id="profileLayout1"></div>
				<div id="profileLayout2">
				<h3 id=profileIntroduceText>자기소개</h3>
				<h3 id="profileIntroduce">
				<% 
				if(rs.getString("introduction") == null)
				{
					out.println("자기소개가 없습니다.");
				}
				else
				{
					out.println(rs.getString("introduction"));
				}
				%>
				</h3>
				</div>
				<%
				//프로필 사진
				if(rs.getString("profile_picture") == null)
				{
				%>
				<img class="profilePicture" src="Image/NoProfileImage.png">
				<%
				}
				else
				{
				%>
				<img class="profilePicture" src="<% rs.getString("profile_picture"); %>">
				<%
				}
				
				//프로필 이름
				%>
				
				<h1 id="profileNickname"><%= profileNickname %></h1>
				
				<%
				//레이팅 표시
				int rating = realLikeRating + reviewRating + commentRating;
				
				if(rating >= 3000)
				{
				%>
					<img class="profileTier" src="Image/Tier_27.png">
				<%
				}
				else if(rating >= 2500)
				{
				%>
					<img class="profileTier" src="Image/Tier_26.png">
				<%
				}
				else
				{
				%>
					<img class="profileTier" src="Image/Tier_<%= (int)(rating / 100) + 1 %>.png">
				<%
				}
					
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
				
				
				if(rating < 2500)
				{
				%>
					<h1 class="profileTierText"><%= mainTier + " " + detailTier %></h1>
				<%
				}
				else
				{
				%>
					<h1 class="profileTierText"><%= mainTier %></h1>
				<%
				}
					
				%>
				
				<div id="profileLayout3">
				<h1 id="profileRatingText">Verdict Rating</h1>
				<h1 id="profileRating"><%= rating %></h1>
				
				<%
				ResultSet rs2 = null;
				try {
					Class.forName("com.mysql.jdbc.Driver");
					String url = "jdbc:mysql://localhost:3306/the_verdict_db";
					conn = DriverManager.getConnection(url, "admin", "0000");
					stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
					sql = "select * from user_data order by rating desc";
					rs2 = stmt.executeQuery(sql);
				}
				catch(Exception e) {
					out.println("DB 연동 오류입니다. : " + e.getMessage());
				}
				
				int count = 1;
				int rank = 1;
				int previousRating = -1;
				
				while(rs2.next())
				{
					int compareRating = Integer.parseInt(rs2.getString("rating"));
					
					if(compareRating != previousRating)
					{
						rank = count;
					}
					
					if(Objects.equals(rs2.getString("nickname"), profileNickname))
					{
						break;
					}
					
					previousRating = compareRating;
					count++;
				}
				
				%>
				<h3 id="profileRanking"><%= rank %>위</h3>
				
				<h3 id="profileEvaluation1">자신의 모든 리뷰에서 받은 평가 : 좋아요 수 <%= like %>개, 싫어요 수 <%= dislike %>개</h3>
				<h3 id="profileEvaluation1Rating">+ <%= realLikeRating %></h3>
				
				<h3 id="profileEvaluation2">작성한 리뷰 수 : <%= reviewAmount %>개</h3>
				<h3 id="profileEvaluation2Rating">+ <%= reviewRating %></h3>
				
				<h3 id="profileEvaluation3">작성한 리뷰 of 리뷰 수 : <%= commentAmount %>개</h3>
				<h3 id="profileEvaluation3Rating">+ <%= commentRating %></h3>
				</div>
				
				<%
				
				try {
					Class.forName("com.mysql.jdbc.Driver");
					String url = "jdbc:mysql://localhost:3306/the_verdict_db";
					conn = DriverManager.getConnection(url, "admin", "0000");
					stmt = conn.createStatement();
					sql = "update user_data set rating = " + rating + " where nickname = '" + profileNickname + "'";
					stmt.executeUpdate(sql);
				}
				catch(Exception e) {
					out.println("DB 연동 오류입니다. : " + e.getMessage());
				}
			}
				%>
			<button id="allReviewsButton"><%= profileNickname %>의 모든 리뷰 보기</button>
				<%
		}
	}
				%>
</div>

<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
    $(document).ready(function() {
        $("#title").click(function() {
            location.href = "Main.jsp";
        });
        $("#notification").click(function() {
            location.href = "Notification.jsp";
        });
        $("#classify").click(function() {
            
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
        $("#allReviewsButton").click(function() {
        	location.href = "AllReviews.jsp?nickname=" + "<%= profileNickname %>&page=1";
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