<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<% 
        String url = "jdbc:mysql://localhost:3306/the_verdict_db";
        Connection conn = null;
        Statement stmt = null;
        String sql = "";
        ResultSet rs;
        
        String score = request.getParameter("score");
        String review_id = request.getParameter("review_id");
        String comment = request.getParameter("comment");
        String nickname = (String)session.getAttribute("ID");
        
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(url, "admin", "0000");
            stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            
            
            
        }
        catch(Exception e) {
            out.println("DB 연동 오류입니다. : " + e.getMessage());
        }
%>
</body>
</html>