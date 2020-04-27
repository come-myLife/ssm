<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<html>
<head>
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
    <style>
            .box{
                width: 50%;
                margin: 0px auto;
                border-radius: 10px;
            }
            .img-box{
                width: 100%;
                position:relative;
                z-index:1;
                border-radius: 10px;
            }
            .img-box img{
                position:absolute;
                top:0;
                bottom:0;
                left:0;
                right:0;
                border-radius: 10px;
                width:100%;
                margin:auto;
                z-index: -1;
                *zoom:1;
            }
            .img-box:before {
                content: "";
                display: inline-block;
                padding-bottom: 55%;
                width: 0.1px;	/*必须要有数值，否则无法把高度撑起来*/
                vertical-align: middle;
            }
    </style>
</head>

<body ondragstart="return false;"><%--禁止鼠标拖动产生新的页面--%>

<div class="container">

    <div class="row clearfix">
        <div class="col-md-12 column">
            <div class="page-header">
                <h1>
                    <small>书籍列表 —— 显示所有书籍</small>
                </h1>

            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-9 column">
            <a class="btn btn-primary" href="${pageContext.request.contextPath}/book/toaddBook">新增</a>
            <a class="btn btn-primary" href="${pageContext.request.contextPath}/book/allBook">显示所有书籍</a>
            <span style="color: red">${error}</span>
        </div>
        <div class="col-md-3 column">
            <form action="${pageContext.request.contextPath}/book/queryBook" method="" >
                <div class="input-group">
                    <input type="text" name="queryBookName" class="form-control" placeholder="请输入要查找的书籍">
                    <span class="input-group-btn">
                        <button class="btn btn-primary" type="submit">查询</button>
                        </span>
                </div><!-- /input-group -->
            </form>
        </div>
    </div>

    <div class="row clearfix">
        <div class="col-md-12 column">
            <table class="table table-hover table-striped">
                <thead>
                <tr>
                    <th>书籍编号</th>
                    <th>书籍名字</th>
                    <th>书籍数量</th>
                    <th>书籍详情</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <c:if test="${not empty list}">
                    <c:forEach var="book" items="${list}">
                        <tr>
                            <td>${book.bookId}</td>
                            <td>${book.bookName}</td>
                            <td>${book.bookCounts}</td>
                            <td>${book.detail}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/book/toUpdateBook?id=${book.bookId}">更改</a> |
                                <a href="${pageContext.request.contextPath}/book/deleteBook?id=${book.bookId}">删除</a>
                            </td>
                        </tr>
                    </c:forEach>
                </c:if>
                </tbody>
            </table>
            <c:if test="${empty list}">
            <div class="box">
                <div class="img-box">
                    <img src="https://cdn.jsdelivr.net/gh/come-myLife/come-myLife.github.io/medias/dwrgIMG/8.jpg"/>
                        <span style="margin-left: 260px">一本都没有了</span>
                </div>
            </div>
            </c:if>
            <div style="margin:auto 0">

                <h1>${page.}</h1>
                <div style="position: relative;top: 50px;left: 500px">
                    <a class="btn btn-primary" href="${pageContext.request.contextPath}/book/allBook?pageNum=${page.navigateFirstPage}">首页</a>
                    <c:if test="${page.pageNum>1

                    }">
                        <a class="btn btn-primary" href="${pageContext.request.contextPath}/book/allBook?pageNum=${page.prePage}">上一页</a>
                    </c:if>
                    <c:if test="${page.pageNum<page.nextPage}">
                        <a class="btn btn-primary" href="${pageContext.request.contextPath}/book/allBook?pageNum=${page.nextPage}">下一页</a>
                        <a class="btn btn-primary" href="${pageContext.request.contextPath}/book/allBook?pageNum=${page.navigateLastPage}">尾页</a>
                    </c:if>
                    <c:if test="${page.pageNum!=0&&page.pageNum==2}">
                        <a class="btn btn-primary" href="${pageContext.request.contextPath}/book/allBook?pageNum=${page.navigateLastPage}">尾页</a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

</div>
