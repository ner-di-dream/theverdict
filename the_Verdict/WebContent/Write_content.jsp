<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="false"%>
<%@ page import = "java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="Write_content.css">
<link href="https://fonts.googleapis.com/css2?family=Outfit&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;900&family=Outfit&display=swap" rel="stylesheet">
<title>The Verdict</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>

<%
HttpSession loginSession = request.getSession(false);
if(loginSession == null)
{
%>
		alert("로그인이 필요합니다.");
		document.location.href = "Main.jsp";
<%
}
%>

	var classify_data = new Array();
	var main_data = new Set();
	var sub_data = new Set();
	var product_data = new Set();
	var pre_main, pre_sub, pre_product;
<%
	String main_category, subcategory, product;
	Connection conn = null;
	Statement stmt = null;
	String sql = null;
	ResultSet rs = null;
	
	try{
		Class.forName("com.mysql.jdbc.Driver");
		String url = "jdbc:mysql://localhost:3306/the_verdict_db?serverTimezone=UTC";
		conn = DriverManager.getConnection(url, "admin", "0000");
		stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
		sql = "select main_category, subcategory, product from board_data group by main_category, subcategory, product order by 1, 2, 3 ";
		rs = stmt.executeQuery(sql);
	}
	catch(Exception e){
		out.println("DB 연동 오류입니다.:" + e.getMessage());
	}
	
	while(rs.next()){
%>
		classify_data.push({"main_category" : "<%=rs.getString("main_category")%>"}, {"subcategory" : "<%=rs.getString("subcategory")%>"},{"product" : "<%=rs.getString("product")%>"} );
<%
	}
%>
    $(document).ready(function() {
    	
    	//init
    	$("#main_category").empty().append("<option value = '1'>대분류를 선택하세요</option>");
    	$("#subcategory").empty().append("<option value = '1'>소분류를 선택하세요</option>");
    	$("#product").empty().append("<option value = '1'>제품을 선택하세요</option>");
    	pre_main = null;
    	pre_sub = null;
    	pre_product = null;
<%		
		if(request.getParameter("main_category") != null){
%>
			pre_main = <%=request.getParameter("main_category")%>;
<%
		}
%>
<%		
		if(request.getParameter("subcategory") != null){
%>
			pre_sub = <%=request.getParameter("subcategory")%>;
<%
		}
%>

<%		
		if(request.getParameter("product") != null){
%>
			pre_product = <%=request.getParameter("product")%>;
<%
		}
%>


		//sql에 가져온 json 형식의 데이터를 분리해서 저장한다
		for(var x in classify_data){
			main_data.add({"main_category": x["main_category"]});
			sub_data.add({"main_category": x["main_category"], "subcategory": x["subcategory"]});
			product_data.add(x);
		}
		
		for(var x in main_data){
			if(x[main_category] == pre_main){
				$("#main_category").append("<option value = '" + x[main_category] + "' selected>"+x[main_category]+"</option>");
			}
			else $("#main_category").append("<option value = '" + x[main_category] + "'>"+x[main_category]+"</option>");
    	}
		
		if(pre_main != null){
			getSubCategory();
		}
		if(pre_sub != null){
			getProduct();
		}

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
        
    });
    function getSubCategory(){
    	$("#subcategory").empty().append("<option value = '1'>소분류를 선택하세요</option>");
    	$("#product").empty().append("<option value = '1'>제품을 선택하세요</option>");
    	getValue = $("#main_category").val();
    	for(var x in sub_data){
    		if(x[main_category] != getValue)	continue;
			if(x[subcategory] == pre_sub){
				$("subcategory").append("<option value = '" + x[subcategory] + "' selected>"+x[subcategory]+"</option>");
			}
			else $("#subcategory").append("<option value = '" + x[subcategory] + "'>"+x[subcategory]+"</option>");
    	}
    }
	function getProduct(){
		$("#product").empty().append("<option value = '1'>제품을 선택하세요</option>");
		getValueMain = $("#main_category").val();
		getValueSub = $("#subcategory").val();
    	for(var x in product_data){
    		if(x[main_category] != getValueMain || x[subcategory] != getValueSub)	continue;
			if(x[subcategory] == pre_sub){
				$("#subcategory").append("<option value = '" + x[product] + "' selected>"+x[product]+"</option>");
			}
			else $("#subcategory").append("<option value = '" + x[product] + "'>"+x[product]+"</option>");
    	}
    }
</script>
</head>
<body>
<div id="topBar">
	<h1 id="title"><a href="Main.jsp">The Verdict</a></h1>
	<%
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
<div id="topNavigation">
	<div id = "notification">공지사항</div>
	<div id = "classify">분류</div>
	<div id = "leaderboard">리더보드</div>
	<div id = "QnA">문의하기</div>
	<div id = "write">글쓰기</div>
</div>
<div id="classifyArea">
	
</div>
<div id="content">
	<form method = "post" action = "" >
	<table border = "0">
		<tr>
			<td>메인 카테고리:</td>
			<td>
				<select name = "main_category" id = "main_category" onChange = "getSubCategory()">
				</select>
			</td>
		</tr>
		<tr>
			<td>하위 카테고리:</td>
			<td>
				<select name = "subcategory" id = "subcategory" onChange = "getProduct()">
				</select>
			</td>
		</tr>
		<tr>
			<td>제목:</td>
			<td>
				<select name = "product" id = "product">
				</select>
			</td>
		</tr>
		<tr>
			<td>제목:</td>
			<td>
				<input type = "text" name = "title">
			</td>
		</tr>
		<tr>
			<td>사진:</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>tag:</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>내용:</td>
			<td>
				<input type = "text" name = "content">
			</td>
		</tr>
	</table>
	
	
	</form>
</div>

</body>

</html>

<%
	stmt.close();
	conn.close();
%>