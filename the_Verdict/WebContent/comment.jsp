<%@page import="com.mysql.cj.log.Log"%>
<%@page import="java.io.Console"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<% request.setCharacterEncoding("utf-8"); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>The Verdict</title>
</head>
<body>
<% 
        String url = "jdbc:mysql://localhost:3306/the_verdict_db";
        Connection conn = null;
        Statement stmt = null;
        String sql = "";
        ResultSet rs = null;
        
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
        
        String score = request.getParameter("score");
        String review_id = request.getParameter("review_id");
        int id = 0;
        if(review_id != null)
        {
        	id = Integer.parseInt(review_id);
        }
        
        int max_id = 0;
        int realScore = 0;
        if(Objects.equals(score, "1"))
        {
        	realScore = 1;
        }
        else
        {
        	realScore = -1;
        }
        String comment = request.getParameter("comment");
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(url, "admin", "0000");
            stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            
            sql = "select max(id) as max_id from comment_data";
            rs = stmt.executeQuery(sql);
        }
        catch(Exception e) {
            out.println("DB 연동 오류입니다. : " + e.getMessage());
        }
        
        if(rs != null)
        {
        	while(rs.next())
        	{
        		if(rs.getString("max_id") != null)
        		max_id = Integer.parseInt(rs.getString("max_id"));
        	}
        }
        
        max_id++;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(url, "admin", "0000");
            stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            
            java.sql.Timestamp date = new java.sql.Timestamp(new java.util.Date().getTime());
            
            sql = "insert into comment_data values (" + max_id + ", '" + comment + "', " + id + ", '" + nickname + "', " + realScore + ", '" + date + "')";
            stmt.executeUpdate(sql);
        }
        catch(Exception e) {
            out.println("DB 연동 오류입니다. : " + e.getMessage());
        }
        response.sendRedirect("Review.jsp?id=" + id);
%>


</body>
</html>