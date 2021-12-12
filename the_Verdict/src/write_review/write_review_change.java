package write_review;

import java.io.IOException;
import java.io.InputStream;
import java.sql.*;
import java.util.Date;
import java.util.Objects;
import java.text.SimpleDateFormat;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

/**
 * Servlet implementation class write_review_change
 */
@WebServlet("/write_review_change")
@MultipartConfig(maxFileSize = 16777215)

public class write_review_change extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	// database connection settings
    private String dbURL = "jdbc:mysql://localhost:3306/the_verdict_db";
    private String dbUser = "admin";
    private String dbPass = "0000";
    String message = null;  // message will be sent back to client
     
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException {
    	
    	response.setContentType("text/html;charset=UTF-8");  
    	response.setCharacterEncoding("UTF-8"); 
    	
    	HttpSession loginSession = request.getSession(false);
		String nickname = null;
		
		if(loginSession == null)
		{
			message = "로그인 세션이 만료되어 리뷰 작성에 실패했습니다.";
			request.setAttribute("message", message);
            
            // forwards to the message page
            getServletContext().getRequestDispatcher("/Write_content_db.jsp").forward(request, response);
		}
		else
		{
			nickname = (String)loginSession.getAttribute("nickname");
		}
         
        InputStream inputStream = null; // input stream of the upload file
         
        // obtains the upload file part in this multipart request
        Part filePart = request.getPart("image");
        if (filePart != null) {
            // prints out some information for debugging
            System.out.println(filePart.getName());
            System.out.println(filePart.getSize());
            System.out.println(filePart.getContentType());
             
            // obtains input stream of the upload file
            inputStream = filePart.getInputStream();
        }
         
        Connection conn = null; // connection to the database
        PreparedStatement statement = null;
        Statement stmt = null;
        String sql = null;
        ResultSet rs = null;
        int new_id = 0;
        
        try {
    		Class.forName("com.mysql.jdbc.Driver");
    		String url = "jdbc:mysql://localhost:3306/the_verdict_db";
    		conn = DriverManager.getConnection(url, "admin", "0000");
    		stmt = conn.createStatement();
    		
    		sql = "select max(id) as max_id from board_data";
    		rs = stmt.executeQuery(sql);
    	}
    	catch(Exception e) {
    		message = e.getMessage();
    	}
    	
    	try {
			while(rs.next()) {
				try {
					new_id = Integer.parseInt(rs.getString("max_id"));
				} catch (NumberFormatException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	new_id++;
    	try {
    		Class.forName("com.mysql.jdbc.Driver");
    		String url = "jdbc:mysql://localhost:3306/the_verdict_db";
    		conn = DriverManager.getConnection(url, "admin", "0000");
    		stmt = conn.createStatement();
    		
    		sql = "select * from user_data where nickname = '" + nickname + "'";
    		rs = stmt.executeQuery(sql);
    	}
    	catch(Exception e) {
    		message = e.getMessage();
    	}
    	
    	int user_number = 0;
    	
    	try {
			while(rs.next())
			{
				user_number = Integer.parseInt(rs.getString("user_number"));
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        
        try {
            // connects to the database
            DriverManager.registerDriver(new com.mysql.jdbc.Driver());
            conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
 
            // constructs SQL statement
            sql = "insert into board_data values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, null, null, ?, 0, 0, 0, ?, ?)";
            statement = conn.prepareStatement(sql);
            
            statement.setBlob(8, inputStream);
            
            String str;
            
            statement.setInt(1, new_id);
            statement.setInt(2, user_number);
            
            statement.setString(3, nickname);
            
            str = new String(request.getParameter("new_main_category").getBytes("8859_1"),"utf-8");
            
            if(!Objects.equals(str, ""))
            {
            	str = new String(request.getParameter("new_main_category").getBytes("8859_1"),"utf-8");
            	statement.setString(4, str);
            }
            else
            {
            	str = new String(request.getParameter("main_category").getBytes("8859_1"),"utf-8");
            	statement.setString(4, str);
			}
            
            str = new String(request.getParameter("new_sub_category").getBytes("8859_1"),"utf-8");
            
            if(!Objects.equals(str, ""))
            {
            	str = new String(request.getParameter("new_sub_category").getBytes("8859_1"),"utf-8");
            	statement.setString(5, str);
            }
            else
            {
            	str = new String(request.getParameter("subcategory").getBytes("8859_1"),"utf-8");
            	statement.setString(5, str);
			}
            
            str = new String(request.getParameter("new_product").getBytes("8859_1"),"utf-8");
            
            if(!Objects.equals(str, ""))
            {
            	str = new String(request.getParameter("new_product").getBytes("8859_1"),"utf-8");
            	statement.setString(6, str);
            }
            else
            {
            	str = new String(request.getParameter("product").getBytes("8859_1"),"utf-8");
            	statement.setString(6, str);
			}
            
            str = new String(request.getParameter("title").getBytes("8859_1"),"utf-8");
        	statement.setString(7, str);
        	
        	str = new String(request.getParameter("tag").getBytes("8859_1"),"utf-8");
        	statement.setString(9, str);
        	
        	str = new String(request.getParameter("information").getBytes("8859_1"),"utf-8");
        	statement.setString(10, str);
        	
        	str = new String(request.getParameter("content").getBytes("8859_1"),"utf-8");
        	statement.setString(11, str);
        	
            statement.setString(12, request.getParameter("average_score"));
            
            java.sql.Timestamp date = new java.sql.Timestamp(new java.util.Date().getTime());

            statement.setTimestamp(13, date);
 
            // sends the statement to the database server
            int row = statement.executeUpdate();
            if (row > 0) {
                message = "리뷰 작성에 성공했습니다.";
            }
        } catch (SQLException ex) {
            message = "ERROR: " + ex.getMessage();
            ex.printStackTrace();
        } finally {
            if (conn != null) {
                // closes the database connection
                try {
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            // sets the message in request scope
            request.setAttribute("message", message);
             
            // forwards to the message page
            getServletContext().getRequestDispatcher("/Write_content_db.jsp").forward(request, response);
        }
    }
}
