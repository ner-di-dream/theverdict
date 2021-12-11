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
	var taglist = new Set();
	
<%
	String main_category, subcategory, product;
	Connection conn = null;
	Statement stmt = null;
	String sql = null;
	ResultSet rs = null;
	
	try{
		Class.forName("com.mysql.cj.jdbc.Driver");
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
    	$("#main_category").append("<option value = 'setMain'>직접선택</option>");
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
    	$("#newMain").hide();
    	$("#newSub").hide();
    	$("#newProduct").hide();
    	if($("#main_category option:selected").val() == '1'){
    		console.log("1");
    		return;
    	}
    	else if($("#main_category option:selected").val() == 'setMain'){
    		//새로 등록할 매인 카테고리 입력창 띄우기
    		$("#newMain").show('fast');
    		//새로 등록할 서브 카테고리 입력창 띄우기
    		$("#newSub").show('fast');
    		//새로 등록할 입력 카테고리 입력창 띄우기
    		$("#newProduct").show('fast');
    		return;
    	}
    	$("#subcategory").empty().append("<option value = '1'>소분류를 선택하세요</option>");
    	$("#subcategory").append("<option value = 'setSub'>직접선택</option>");
    	$("#product").empty().append("<option value = '1'>제품을 선택하세요</option>");
    	getValue = $("#main_category").val();
    	for(var x in sub_data){
    		if(x[main_category] != getValue)	continue;
			if(x[subcategory] == pre_sub){
				$("#subcategory").append("<option value = '" + x[subcategory] + "' selected>"+x[subcategory]+"</option>");
			}
			else $("#subcategory").append("<option value = '" + x[subcategory] + "'>"+x[subcategory]+"</option>");
    	}
    }
	function getProduct(){
		$("#newSub").hide();
    	$("#newProduct").hide();
		if($("#product option:selected").val() == '1'){
    		return;
    	}
    	else if($("#product option:selected").val() == 'setSub'){
    		$("#newSub").show('fast');
    		$("#newProduct").show('fast');
    		return;
    	}
		$("#product").empty().append("<option value = '1'>제품을 선택하세요</option>");
		$("#product").append("<option value = 'setProduct'>직접선택</option>");
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
	function productCheck(){
		$("#newProduct").hide();
		if($("#product option:selected").val() == '1'){
    		return;
    	}
    	else if($("#product option:selected").val() == 'setProduct'){
    		//새로 등록할 입력 카테고리 입력창 띄우기
    		$("#newProduct").show('fast');
    		return;
    	}
	}
	
	function addTag(){
		console.log("check");
		var value = $("input[name = inputTag]").val();
		if(value == null)	return;
		else{
			taglist.add(value);
			$("#showTaglist").append("<span class = 'tagDesign' onclick = 'deleteTag(this)'>"+value+"</span>");
		}
		$("input[name = inputTag]").val('');
	}
	
	function deleteTag(e){
		var value = $(e).text();
		taglist.delete(value);
		$(e).remove();
	}
	
	//입력값 검증
	function checkForm(){
		if($("#main_category option:selected").val() == '1' || ($("#main_category option:selected").val() == 'setMain' && $("#newMain").val() == null) ){
			alert("메인 카테고리를 입력하세요");
			return false;
		}
		if(($("#sub_category option:selected").val() == '1' || $("#sub_category option:selected").val() == 'setSub') && $("#newSub").val() == null){
			alert("서브 카테고리를 입력하세요");
			return false;
		}
		if(($("#product option:selected").val() == '1' || $("#product option:selected").val() == 'setProduct') && $("#newProduct").val() == null){
			alert("상품명을 입력하세요");
			return false;
		}
		if($("input[name = title]").val() == null){
			alert("제목을 입력하세요");
			return false;
		}
		if($("input[name = evaluation_score]").val() == null){
			alert("평가 점수를 입력하세요");
			return false;
		}
		if($("textarea[name = content]").val() == null){
			alert("내용을 입력하세요");
			return false;
		}
		
		
		
		var value = "";
		for(var x in taglist){
			console.log(x);
			value = value + (x + ";");
		}
		$("input[name = tag]").val(value);
		alert();
		return true;
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
	<form method = "post" action = "Write_content_db.jsp" onSubmit="return checkForm()" >
	<table border = "0">
		<tr>
			<td>메인 카테고리:</td>
			<td>
				<select name = "main_category" id = "main_category" onChange = "getSubCategory()">
				</select>
			</td>
			<td>
				<input name = "new_main_category" id = "newMain" type = "text" style = "display:none" >
			</td>
		</tr>
		<tr>
			<td>하위 카테고리:</td>
			<td>
				<select name = "subcategory" id = "subcategory" onChange = "getProduct()">
				</select>
			</td>
			<td>
				<input name = "new_sub_category" id = "newSub" type = "text" style = "display:none" >
			</td>
		</tr>
		<tr>
			<td>상품명:</td>
			<td>
				<select name = "product" id = "product" onChange = "productCheck()">
				</select>
			</td>
			<td>
				<input name = "new_product" id = "newProduct" type = "text" style = "display:none" >
			</td>
		</tr>
		<tr>
			<td>제목:</td>
			<td>
				<input type = "text" name = "title">
			</td>
		</tr>
		<tr>
			<td>태그 추가(상품에 대한 간단한 정보):</td>
			<td>
				<input type = "text" name = "inputTag" >
				<div onclick = "addTag()">입력하기</div>
				<input type = "hidden" name = "tag">
			</td>
			<td>
				<div id = "showTaglist"></div>
			</td>
		</tr>
		<tr>
			<td>총점 입력:</td>
			<td>
				<input type = "text" name = "evaluation_score">/10
			</td>
		</tr>
		
	</table>
		내용:<br>
		<hr>
		<textarea name = "content" rows = "50" cols = "200"></textarea><br>
		<input type = "submit" value = "등록하기"> <input type = "reset" value = "초기화 하기">
	</form>
</div>

</body>

</html>

<%
	stmt.close();
	conn.close();
%>