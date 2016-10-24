## 一、准备工作
### 1.1 jar包
`servlet-api` 是servlet的核心api包
`commons-fileupload` 上传功能的通用工具包
`fastjson` 阿里的json工具包

### 1.2 pom文件

```
        <dependency>
            <groupId>commons-fileupload</groupId>
            <artifactId>commons-fileupload</artifactId>
            <version>1.3.1</version>
        </dependency>
        <dependency>
            <groupId>javax.servlet</groupId>
            <artifactId>servlet-api</artifactId>
            <version>2.5</version>
        </dependency>
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>fastjson</artifactId>
            <version>1.2.7</version>
        </dependency>
```

## 二、项目介绍
### 1.1 web.xml配置
此项目是采用maven构建的java web项目，传统的jsp作为页面交互。

```
<web-app>
	<listener>
		<listener-class>
			org.apache.commons.fileupload.servlet.FileCleanerCleanup
		</listener-class>
	</listener>
	<servlet>
		<servlet-name>FileUploadServlet</servlet-name>
		<display-name>FileUploadServlet</display-name>
		<description>FileUploadServlet</description>
		<servlet-class>com.ghj.servlet.FileUploadServlet</servlet-class>
	</servlet>
	<servlet-mapping>
		<servlet-name>FileUploadServlet</servlet-name>
		<url-pattern>/FileUploadServlet</url-pattern>
	</servlet-mapping>
</web-app>
```

配置的servlet的位置，那么我们就要去写代码了。

### 1.2 上传功能
新建一个class文件`com.ghj.servlet.FileUploadServlet`，继承自`HttpServlet`。重写它的`init()`和`doPost()`方法。

代码

```
package com.ghj.servlet;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.FileCleanerCleanup;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.FileCleaningTracker;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * 把今天最好的表现当作明天最新的起点．．～
 * いま 最高の表現 として 明日最新の始発．．～
 * Today the best performance  as tomorrow newest starter!
 * Created by IntelliJ IDEA.
 *
 * @author: xiaomo
 * @github: https://github.com/qq83387856
 * @email: hupengbest@163.com
 * @QQ_NO: 83387856
 * @Date: 2016/10/24 9:15.
 * @Description:
 * @Copyright(©) 2016 by xiaomo.
 **/
public class FileUploadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private File fileUploadPath;
    private static final String fileDirectory = "/data";

    /**
     * 设置文件存储位置
     */
    @Override
    public void init() {
        String realPath = this.getServletConfig().getServletContext().getRealPath("/");
        fileUploadPath = new File(realPath + fileDirectory);
        if (!fileUploadPath.exists()) {
            boolean isCreate = fileUploadPath.mkdirs();
            if (isCreate) {
                System.out.println("文件夹己被创建");
            }
        }
    }


    /**
     * post请求(文件上传的操作)
     * 说明：该方法支持同时上传多个文件（在index.jsp中添加文件上传的控件）
     * 注意：文件名只能为英文
     *
     * @param request  request
     * @param response response
     * @throws ServletException ServletException
     * @throws IOException      IOException
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        boolean isMultipart = ServletFileUpload.isMultipartContent(request);
        if (isMultipart) {
            ServletContext servletContext = this.getServletConfig().getServletContext();
            File repository = (File) servletContext.getAttribute("javax.servlet.context.tempdir");
            DiskFileItemFactory factory = newDiskFileItemFactory(servletContext, repository);

            ServletFileUpload upload = new ServletFileUpload(factory);
            upload.setHeaderEncoding("utf-8");

            PrintWriter printWriter = response.getWriter();
            response.setContentType("application/json");
            response.setCharacterEncoding("utf-8");
            JSONArray files = new JSONArray();
            try {
                List<FileItem> items = upload.parseRequest(request);
                for (FileItem item : items) {
                    if (item.isFormField()) { //表单输入域
                        System.out.println(item.getFieldName());
                    } else { // 文件上传域
                        String name = item.getName();
                        if (!name.equals("")) {
                            int index = name.indexOf("\\");
                            File uploadedFile;
                            if (index == -1) {
                                uploadedFile = new File(fileUploadPath,
                                        File.separator + name);
                            } else {
                                uploadedFile = new File(fileUploadPath, File.separator + name.substring(name.lastIndexOf(File.separator) + 1));
                            }
                            item.write(uploadedFile);
                            JSONObject file = new JSONObject();
                            file.put("name", name);
                            file.put("size", item.getSize());
                            file.put("url", fileUploadPath + "/" + name);
                            file.put("deleteType", "post");
                            files.add(file);
                        } else {
                            JSONObject file = new JSONObject();
                            file.put("result", "please choose a file");
                            files.add(file);
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                JSONObject result = new JSONObject();
                result.put("files", files);
                printWriter.write(result.toString());
                printWriter.close();
            }
        }
    }

    /**
     * 将请求的每个项目封装成单独的文件项目
     *
     * @param context    context
     * @param repository repository
     * @return DiskFileItemFactory
     */
    private DiskFileItemFactory newDiskFileItemFactory(ServletContext context, File repository) {
        FileCleaningTracker fileCleaningTracker = FileCleanerCleanup.getFileCleaningTracker(context);
        DiskFileItemFactory factory = new DiskFileItemFactory(DiskFileItemFactory.DEFAULT_SIZE_THRESHOLD, repository);
        factory.setFileCleaningTracker(fileCleaningTracker);
        return factory;
    }

}

```


### 2.3 页面

```
<html>
<%@page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<body>
<h2>文件上传</h2>
<form action="FileUploadServlet" method="post" enctype="multipart/form-data">
	<input type="file" name="file1""><br>
	<input type="submit" value="submit">
</form>
</body>
</html>

```

看起来清新简单，就不加那么style的修饰了。

## 三、效果图
![效果图](http://static.xiaomo.info/images/java_upload.gif)


## 四、源代码

https://github.com/java-user/ServletFileUploadDemo  需要的朋友自取，随意使用不用客气