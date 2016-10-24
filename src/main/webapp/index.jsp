<html>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<style type="text/css">

    .fileInputContainer {
        height: 256px;
        background: url(http://images.cnblogs.com/cnblogs_com/dreamback/437546/o_ff6.png);
        position: relative;
        width: 256px;
    }

    .fileInput {
        height: 256px;
        font-size: 300px;
        position: absolute;
        right: 0;
        top: 0;
        opacity: 0;
        filter: alpha(opacity=0);
        cursor: pointer;
    }
</style>
<body>
<h2>文件上传</h2>
<form action="FileUploadServlet" method="post" enctype="multipart/form-data">
    <div class="fileInputContainer">
        <input class="fileInput" type="file" name="file1"><br>
    </div>
    <input type="submit" value="submit">
</form>
</body>
</html>
