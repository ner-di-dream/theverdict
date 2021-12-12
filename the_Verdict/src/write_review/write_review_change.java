package write_review;

import java.io.IOException;
import java.io.InputStream;
import java.sql.*;
import java.util.Date;
import java.text.SimpleDateFormat;

import javax.servlet.ServletException;
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
public class write_review_change extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	// database connection settings
    private String dbURL = "jdbc:mysql://localhost:3306/the_verdict_db";
    private String dbUser = "admin";
    private String dbPass = "0000";
    String message = null;  // message will be sent back to client
     
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException {
    	
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
        Part filePart = null; //request.getPart("image");
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
            
            statement.setInt(1, new_id);
            statement.setInt(2, user_number);
            statement.setString(3, nickname);
            
            if(request.getParameter("new_main_category") != null)
            {
            	statement.setString(4, request.getParameter("new_main_category"));
            }
            else
            {
				statement.setString(4, request.getParameter("main_category"));
			}
            
            if(request.getParameter("new_sub_category") != null)
            {
            	statement.setString(5, request.getParameter("new_sub_category"));
            }
            else
            {
				statement.setString(5, request.getParameter("subcategory"));
			}
            
            if(request.getParameter("new_product") != null)
            {
            	statement.setString(6, request.getParameter("new_product"));
            }
            else
            {
				statement.setString(6, request.getParameter("product"));
			}
            
            statement.setString(7, request.getParameter("title"));
            statement.setString(9, request.getParameter("tag"));
            statement.setString(10, request.getParameter("information"));
            statement.setString(11, request.getParameter("content"));
            statement.setString(12, request.getParameter("information"));
            
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
