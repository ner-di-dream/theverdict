<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<% request.setCharacterEncoding("utf-8"); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<% 

    Connection conn = null;
    Statement stmt = null;

    String sql, sql_update, mainParent = "", subParent = "";
    String nickname = (String)session.getAttribute("nickname");
    
    ResultSet rs1, rs2, rs3;
    int review_amount = 0;
    String id = request.getParameter("id");
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/the_verdict_db";
        conn = DriverManager.getConnection(url, "admin", "0000");
        stmt = conn.createStatement();
        
        sql = "select * from board_data where id = "+id+"";
        rs1 = stmt.executeQuery(sql);
        
        while(rs1.next()){
        	mainParent = rs1.getString("main_category");
        	subParent = rs1.getString("sub_category");
        }

        sql_update = "delete from board_data where id = "+id+"";
        stmt.executeUpdate(sql_update);
        
        sql = "select review_amount from category_data where mainParent ='"+ mainParent +"' and subParent ='"+ subParent +"'";
        rs2 = stmt.executeQuery(sql);
        
        while(rs2.next()){
        	review_amount = rs2.getInt("review_amount");
        }
        
        sql_update = "update category_data set review_amount = " + (review_amount - 1) + "where mainParent ='"+ mainParent +"' and subParent ='"+ subParent +"'";
        stmt.executeUpdate(sql_update);
        
        sql = "select review_amount from user_data where nickname ='"+ nickname+ "'";
        rs3 = stmt.executeQuery(sql);
        
        while(rs3.next()){
        	review_amount = rs3.getInt("review_amount");
        }
        
        sql_update = "update user_data set review_amount = " + (review_amount - 1) + "where nickname ='"+ nickname+ "'";
        stmt.executeUpdate(sql_update);
        
        rs1.close();
        rs2.close();
        rs3.close();
        stmt.close();
        conn.close();
        response.sendRedirect("Main.jsp");
    }
    catch(Exception e) {
        out.println("DB 연동 오류입니다. : " + e.getMessage());
    }
    
%>
</body>
</html>