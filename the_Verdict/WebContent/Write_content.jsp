<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="false"%>
<%@ page import = "java.sql.*" %>
<% request.setCharacterEncoding("UTF-8"); %>
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
	var main_data = new Array();
	var sub_data = new Array();
	var pre_main, pre_sub, pre_product;
	var taglist = new Array();
	var infoListProperty = new Array();
	var infoListValue = new Array();
	
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
		classify_data.push(['<%=rs.getString("main_category")%>', '<%=rs.getString("subcategory")%>', '<%=rs.getString("product")%>']);
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
			pre_main = '<%=request.getParameter("main_category")%>';
<%
		}
%>
<%		
		if(request.getParameter("subcategory") != null){
%>
			pre_sub = '<%=request.getParameter("subcategory")%>';
<%
		}
%>

<%		
		if(request.getParameter("product") != null){
%>
			pre_product = '<%=request.getParameter("product")%>';
<%
		}
%>


		//console.table(classify_data);
		//sql에 가져온 json 형식의 데이터를 분리해서 저장한다
		for(var i = 0; i < classify_data.length ; i++){
			main_data.push(classify_data[i][0]);
			sub_data.push([classify_data[i][0], classify_data[i][1]]);
		}
		
		removeDup = new Set(main_data);
		main_data = Array.from(removeDup);
		removeDup = new Set(sub_data);
		sub_data = Array.from(removeDup);
		
		
		//console.table(main_data);
		//console.table(sub_data);
		
		
		
		for(var i = 0; i < main_data.length ; i++){
			if(main_data[i][0] == pre_main){
				$("#main_category").append("<option value = '" + main_data[i]+ "' selected>"+ main_data[i]+ "</option>");
			}
			else $("#main_category").append("<option value = '" + main_data[i] + "'>"+ main_data[i] +"</option>");
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
        

    	document.getElementById("image").onchange = function () {
            var reader = new FileReader();

            reader.onload = function (e) {
                // get loaded data and render thumbnail.
                document.getElementById("imagePreview").src = e.target.result;
            };

            // read the image file as a data URL.
            reader.readAsDataURL(this.files[0]);
            $("#submit").attr("disabled", false);
        };
    });
    function getSubCategory(){
    	$("#newMain").hide();
    	$("#newSub").hide();
    	$("#newProduct").hide();
    	$("#subcategory").empty().append("<option value = '1'>소분류를 선택하세요</option>");
    	$("#product").empty().append("<option value = '1'>제품을 선택하세요</option>");
    	if($("#main_category option:selected").val() == '1'){
    		//console.log("1");
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
    	$("#subcategory").append("<option value = 'setSub'>직접선택</option>");
    	getValue = $("#main_category option:selected").val();
    	for(var i = 0; i < sub_data.length; i++){
    		if(sub_data[i][0] != getValue)	continue;
			if(sub_data[i][1] == pre_sub){
				$("#subcategory").append("<option value = '" + sub_data[i][1] + "' selected>"+ sub_data[i][1] +"</option>");
			}
			else $("#subcategory").append("<option value = '" + sub_data[i][1] + "'>"+ sub_data[i][1] +"</option>");
    	}
    }
	function getProduct(){
		$("#product").empty().append("<option value = '1'>제품을 선택하세요</option>");
		$("#newMain").hide();
		$("#newSub").hide();
    	$("#newProduct").hide();
		if($("#subcategory option:selected").val() == '1'){
			//console.log('k');
    		return;
    	}
    	else if($("#subcategory option:selected").val() == 'setSub'){
    		$("#newSub").show('fast');
    		$("#newProduct").show('fast');
    		return;
    	}
		$("#product").append("<option value = 'setProduct'>직접선택</option>");
		getValueMain = $("#main_category option:selected").val();
		getValueSub = $("#subcategory option:selected").val();
    	for(var i = 0; i < classify_data.length; i++){
    		if(classify_data[i][0] != getValueMain || classify_data[i][1] != getValueSub)	continue;
			if(classify_data[i][1] == pre_product){
				$("#product").append("<option value = '" + classify_data[i][2] + "' selected>"+ classify_data[i][2] +"</option>");
			}
			else $("#product").append("<option value = '" + classify_data[i][2] + "'>"+ classify_data[i][2] +"</option>");
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
		var value = $("input[name = inputTag]").val();
		if(value == null)	return;
		else{
			taglist.push(value);
			$("#showTaglist").append("<div class = 'tagDesign' onclick = 'deleteTag(this)'>"+value+"</div>");
		}
		$("input[name = inputTag]").val('');
	}
	
	function deleteTag(e){
		var value = $(e).text();
		for(var i = 0; i < taglist.length; i++){
			if(taglist[i] == value){
				for(var j = i ; j < taglist.length - 1; j++){
					taglist[j] = taglist[j+1];
				}
				taglist.pop();
			}
		}
		$(e).remove();
	}
	
	function addInfo(){
		var value1 = $("input[name = inputInfo1]").val();
		var value2 = $("input[name = inputInfo2]").val();
		if(value1 == null || value2 == null)	return;
		else{
			infoListProperty.push(value1);
			infoListValue.push(value2);
			$("#showInfolist").append("<div onclick = 'deleteInfo(this)'><span class = 'info1Design'>" + value1 + "</span><span class = 'info2Design'>" + value2 + "</span></div>");
		}
		$("input[name = inputInfo1]").val('');
		$("input[name = inputInfo2]").val('');
	}
	
	function deleteInfo(e){
		var value = $(e).children('.infoDesign').text();
		for(var i = 0; i < infoListProperty.length; i++){
			if(infoListProperty[i] == value){
				for(var j = i ; j < infoListProperty.length - 1; j++){
					infoListProperty[j] = infoListProperty[j+1];
					infoListValue[j] = infoListValue[j+1];
				}
				infoListProperty.pop();
				infoListValue.pop();
			}
		}
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
		if($("input[name = average_score]").val() == null){
			alert("평가 점수를 입력하세요");
			return false;
		}
		if(parseInt($("input[name = average_score]").val()) > 10){
			alert("별점은 10 이하 이어야 합니다.");
			return false;
		}
		if(parseInt($("input[name = average_score]").val()) < 0){
			alert("별점은 0 이상 이어야 합니다.");
			return false;
		}
		if($("textarea[name = content]").val() == null){
			alert("내용을 입력하세요");
			return false;
		}
		
		
		
		
		var value = "";
		for(var i = 0; i < taglist.length; i++){
			console.log(taglist[i]);
			value = value + (taglist[i] + ";");
		}
		$("#currentTag").val(value);
		
		var valueInfo = "";
		for(var i = 0; i < infoListValue.length; i++){
			console.log(infoListProperty[i] + " " + infoListValue[i]);
			valueInfo = valueInfo + (infoListProperty[i] + ";" + infoListValue[i] + ";");
		}
		$("#currentInformation").val(valueInfo);
		
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
<form method="post" action="write_review_change" onSubmit="return checkForm()" enctype="multipart/form-data" accept-charset="UTF-8">
<div id = "content">
				<h1 class = "categoryText" id = "main_categoryText">대분류</h1>
				<select name = "main_category" id = "main_category" onChange = "getSubCategory()">
				</select>
				
				<input name = "new_main_category" id = "newMain" type = "text" placeholder = "대분류 직접 입력" style = "display: none" >
				
				<h1 class = "categoryText" id = "subcategoryText">소분류</h1>
				<select name = "subcategory" id = "subcategory" onChange = "getProduct()">
				</select>
				
				<input name = "new_sub_category" id = "newSub" type = "text" placeholder = "소분류 직접 입력" style = "display: none" >
				
				<h1 class = "categoryText" id = "productText">제품</h1>
				<select name = "product" id = "product" onChange = "productCheck()">
				</select>
				
				<input name = "new_product" id = "newProduct" type = "text" placeholder = "제품 직접 입력" style = "display: none" >
				
				<h1 class = "categoryText" id = "titleText">제목</h1>
				<input type = "text" name = "title" id = "title2" placeholder = "제목 입력">
				
				<h1 class = "categoryText" id = "scoreText">Verdict Score</h1>
				<input type = "number" step="0.01" name = "average_score" id = "avgScore" placeholder = "Verdict Score (10점 만점)">
		<br>
		
		<input type="file" id="image" name="image" accept="image/*">
		<img id="imagePreview" src="Image/mainImage.png">

		<textarea name = "content" id = "reviewContent" rows = "40" cols = "150"></textarea><br>
		
		<h3 id = "tagDeleteNotice">추가된 태그와 정보를 클릭하면 삭제할 수 있습니다.</h3>
		
		<div id = "showTaglist"></div>
		<input type = "text" name = "inputTag" id = "inputTag" placeholder = "추가할 태그 입력">
		<div onclick = "addTag()" id = "addTag">입력하기</div>
		<input type = "hidden" name="tag" id = "currentTag">
		
	<div>
		<input type = "text" name = "inputInfo1" id = "inputInfo1" placeholder = "정보 종류 입력 (예시 : 화면 크기)"> <input type = "text" name = "inputInfo2" id = "inputInfo2" placeholder = "대응하는 정보 입력 (예시 : 6인치)">
		<div onclick = "addInfo()" id = "addInfo">입력하기</div>
		<input type = "hidden" name="information" id = "currentInformation">
		<div id = "showInfolist"></div>
	</div>
</div>
	<input type = "submit" value = "등록하기" id = "submit">
</form>
<div id = "blank"></div>
</body>

</html>

<%
	stmt.close();
	conn.close();
%>