package profile_picture;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
 
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
 
@WebServlet("/profile_picture")
@MultipartConfig(maxFileSize = 16777215)    // upload file's size up to 16MB
public class profile_picture_change extends HttpServlet {
     
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
			message = "로그인 세션이 만료되어 프로필 사진 변경에 실패했습니다.";
			request.setAttribute("message", message);
            
            // forwards to the message page
            getServletContext().getRequestDispatcher("/Setting-Picture-db.jsp").forward(request, response);
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
        
         
        try {
            // connects to the database
            DriverManager.registerDriver(new com.mysql.jdbc.Driver());
            conn = DriverManager.getConnection(dbURL, dbUser, dbPass);
 
            // constructs SQL statement
            String sql = "update user_data set profile_picture = ? where nickname = '" + nickname + "'";
            PreparedStatement statement = conn.prepareStatement(sql);
             
            if (inputStream != null) {
                // fetches input stream of the upload file for the blob column
                statement.setBlob(1, inputStream);
            }
            else {
            	message = "프로필 사진을 찾지 못했습니다.";
			}
 
            // sends the statement to the database server
            int row = statement.executeUpdate();
            if (row > 0) {
                message = "프로필 사진 변경에 성공했습니다.";
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
            getServletContext().getRequestDispatcher("/Setting-Picture-db.jsp").forward(request, response);
        }
    }
}
