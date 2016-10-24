<html>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<body>
<h2>文件上传</h2>
<form action="FileUploadServlet" method="post" enctype="multipart/form-data">
	<input type="file" name="file1" onclick="info()"><br>
	<input type="submit" value="submit">
</form>
<script>
	function info() {
		alert("请选择文件！");
	}
</script>
</body>
</html>
