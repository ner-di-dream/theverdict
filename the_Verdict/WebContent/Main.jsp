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
<link rel="stylesheet" href="Main.css">
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

<h3 id="bestReviewTab">Best Review of the week</h3>
<hr id="bestReviewLine">

<%
		Connection conn = null;
		Statement stmt = null;
		String sql = null;
		ResultSet rs = null;
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			String url = "jdbc:mysql://172.30.1.47:3306/the_verdict_db";
			conn = DriverManager.getConnection(url, "admin", "0000");
			stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
			sql = "select * from board_data where date between date_add(now(), interval -1 week) and now() order by (like_amount - dislike_amount) desc limit 3";
			rs = stmt.executeQuery(sql);
		}
		catch(Exception e) {
			out.println("DB 연동 오류입니다. : " + e.getMessage());
		}
			
		if(rs != null)
		{
			while(rs.next())
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
		else 
		{
			%>
			<h3 id="noReviews">작성된 글이 없어요!</h3>
			<%	
		}
	%>
	
<h3 id="halloffameTab">Hall of Fame</h3>
<hr id="halloffameLine">

<table id="halloffame" border="1">

			<tr>
				<td align="center" width="100px">Ranking</td>
				<td align="center" width="600px">Nickname</td>
				<td align="center" width="200px">Rating</td>
				<td align="center" width="400px">Tier</td>
			</tr>

<%
	try {
		sql = "select * from user_data order by rating desc limit 5";
		rs = stmt.executeQuery(sql);
	}
	catch(Exception e) {
		out.println("DB 연동 오류입니다. : " + e.getMessage());
	}
	int count = 1;
	int rank = 1;
	int previousRating = 0;
	
if(rs != null)
{
	while(rs.next())
	{
		int rating = Integer.parseInt(rs.getString("rating"));
		
		if(rating != previousRating)
		{
			rank = count;
		}
		
		previousRating = Integer.parseInt(rs.getString("rating"));
		
%>
			<tr>
				<td align="center" width="100px"> <%= rank %> </td>
				<td align="center" width="400px"> <%= rs.getString("nickname") %> </td>
				<td align="center" width="200px"> <%= rs.getString("rating") %> </td>
				<td align="center" width="600px">
				
				<%
				String mainTier = null;
				String detailTier = null;
				
				if(rating >= 2500)
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
				%>
				
				<%= mainTier + " " + detailTier %>
				
				</td>
			</tr>
<%		
		count++;
	}
%>
</table>
<%
}
else
{
	%>
	<h3 id="noRanking">명예의 전당에 등록된 사용자가 없어요!</h3>
	<%
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