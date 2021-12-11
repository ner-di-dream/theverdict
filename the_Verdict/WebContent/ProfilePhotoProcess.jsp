<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.io.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Photo</title>
</head>
<body>
<% 

Blob image = null;
Connection conn = null;
byte[ ] imgData = null ;
Statement stmt = null;
ResultSet rs = null;
String nickname = request.getParameter("nickname");

try {
Class.forName("com.mysql.jdbc.Driver");
conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/the_verdict_db", "admin", "0000");
stmt = conn.createStatement();
rs = stmt.executeQuery("select * from user_data where nickname = '" + nickname + "'");

out.clear();
out = pageContext.pushBody();

if (rs.next()) {
	image = rs.getBlob(6);
	imgData = image.getBytes(1,(int)image.length());
}
else {
	out.println("Display Blob Example");
	out.println("image not found");
return;
}
// display the image
response.setContentType("image/gif");
OutputStream o = response.getOutputStream();
o.write(imgData);
o.flush();
o.close();
} catch (Exception e) {

out.println("Unable To Display image");
out.println("Image Display Error=" + e.getMessage());
return;

} finally {

try {
rs.close();
stmt.close();
conn.close();
} catch (SQLException e) {
e.printStackTrace();
}

}

%>
</body>
</html>