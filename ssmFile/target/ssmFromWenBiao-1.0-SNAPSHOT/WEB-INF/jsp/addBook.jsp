<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <title>新增书籍</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- 引入 Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css" rel="stylesheet">
    <title>书籍列表</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- 引入 Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@3.3.7/dist/css/bootstrap.min.css" rel="stylesheet">
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" href="https://www.naqub.cn/wp-content/uploads/2018/12/cropped-ico-32x32.png" sizes="32x32">
    <title>login</title>
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/gh/come-myLife/come-myLife.github.io/js/myLoginjs/index.css">
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/gh/come-myLife/come-myLife.github.io/js/myLoginjs/prism.css">
    <script src="http://www.jq22.com/jquery/jquery-1.10.2.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/gh/come-myLife/come-myLife.github.io/js/myLoginjs/quietflow.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/gh/come-myLife/come-myLife.github.io/js/myLoginjs/index.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/gh/come-myLife/come-myLife.github.io/js/myLoginjs/prism.js"></script>
    <link href="https://cdn.jsdelivr.net/gh/come-myLife/come-myLife.github.io/js/myLoginjs/logincss.css" rel="stylesheet">
</head>
<body>
<div class="container">

    <div class="row clearfix">
        <div class="col-md-12 column">
            <div class="page-header">
                <h1>
                    <small>新增书籍</small>
                </h1>
            </div>
        </div>
    </div>

    <form action="${pageContext.request.contextPath}/book/addBook" method="post" style="width: 50%;margin: 80px auto;">
        <div class="form-group">
            <label for="bookName">书籍名称：</label>
            <input type="text" class="form-control" id="bookName" name="bookName" placeholder="书籍名称">
        </div>
        <div class="form-group">
            <label for="bookCounts"> 书籍数量：</label>
            <input type="text" class="form-control" id="bookCounts" name="bookCounts" placeholder="书籍数量">
        </div>
        <div class="form-group">
            <label for="detail"> 书籍详情：</label>
            <input type="text" class="form-control" id="detail" name="detail" placeholder="书籍详情">
        </div>
        <input class="btn btn-primary" type="submit" value="提交"/>
    </form>
</div>
</body>
</html>
