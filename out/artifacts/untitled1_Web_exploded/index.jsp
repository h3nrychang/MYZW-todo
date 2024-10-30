<%--
  Created by IntelliJ IDEA.
  User: zhang
  Date: 2024/10/10
  Time: 10:19

  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

%>

<html>
<head>
    <meta charset="utf-8">
    <title>演示</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="./static/css/layui.css" rel="stylesheet">
</head>
<body>
<%
    // 获取 session 中的用户名
    String username = (String) session.getAttribute("user");
%>
<div class="layui-layout layui-layout-admin">
    <div class="layui-header">
        <div class="layui-logo layui-hide-xs layui-bg-black"  id="demo-logo">综维待办管理系统</div>
        <!-- 头部区域（可配合layui 已有的水平导航） -->
        <ul class="layui-nav layui-layout-left">
            <!-- 移动端显示 -->
            <li class="layui-nav-item layui-show-xs-inline-block layui-hide-sm" lay-header-event="menuLeft">
                <i class="layui-icon layui-icon-spread-left"></i>
            </li>
<%--            <li class="layui-nav-item layui-hide-xs"><a href="javascript:;">nav 1</a></li>--%>
<%--            <li class="layui-nav-item layui-hide-xs"><a href="javascript:;">nav 2</a></li>--%>
<%--            <li class="layui-nav-item layui-hide-xs"><a href="javascript:;">nav 3</a></li>--%>
<%--            <li class="layui-nav-item">--%>
<%--                <a href="javascript:;">nav groups</a>--%>
<%--                <dl class="layui-nav-child">--%>
<%--                    <dd><a href="javascript:;">menu 11</a></dd>--%>
<%--                    <dd><a href="javascript:;">menu 22</a></dd>--%>
<%--                    <dd><a href="javascript:;">menu 33</a></dd>--%>
<%--                </dl>--%>
            </li>
        </ul>
        <ul class="layui-nav layui-layout-right">
            <li class="layui-nav-item layui-hide layui-show-sm-inline-block">
                <a href="javascript:;">
                    <img src="//unpkg.com/outeres@0.0.10/img/layui/icon-v2.png" class="layui-nav-img">
                    <%= username %>
                </a>
                <dl class="layui-nav-child">
<%--                    <dd><a href="javascript:;">个人资料</a></dd>--%>
<%--                    <dd><a href="javascript:;">系统设置</a></dd>--%>
                    <dd><a href="logout.jsp">退出登录</a></dd>
                </dl>
            </li>
            <li class="layui-nav-item" lay-header-event="menuRight" lay-unselect>
                <a href="javascript:;">
                    <i class="layui-icon layui-icon-more-vertical"></i>
                </a>
            </li>
        </ul>
    </div>
    <div class="layui-side layui-bg-black">
        <div class="layui-side-scroll">
            <!-- 左侧导航区域（可配合layui已有的垂直导航） -->
            <ul class="layui-nav layui-nav-tree" lay-filter="test">

                <li class="layui-nav-item layui-nav-itemed">
                    <a href="javascript:;">事务管理</a>
                    <dl class="layui-nav-child">
                        <dd><a href="javascript:;" data-iframe="./2-0yilan.jsp">待办事项一览</a></dd>
                        <dd><a href="javascript:;" data-iframe="./2-1shixiang.jsp">待办事项管理系统</a></dd>
                        <dd><a href="javascript:;" data-iframe="./2-2liucheng.jsp">作业流程管理系统</a></dd>
<%--                        <dd><a href="javascript:;">list 2</a></dd>--%>
<%--                        <dd><a href="javascript:;">超链接</a></dd>--%>
                    </dl>
                </li>
                <li class="layui-nav-item">
                    <a class="" href="javascript:;">系统管理</a>
                    <dl class="layui-nav-child">
                        <dd><a href="javascript:;" data-iframe="./um.jsp">用户管理</a></dd>
                        <dd><a href="javascript:;" data-iframe="./2zhengzhi.jsp">修改资料</a></dd>
                        <dd><a href="javascript:;" data-iframe="./3jifangxunjian.jsp">修改密码</a></dd>
                        <dd><a href="javascript:;" data-iframe="./sys/about.jsp">关于</a></dd>
                        <%--                        <dd><a href="javascript:;" data-iframe="iframe4.html">the links</a></dd>--%>
                    </dl>
                </li>
<%--                <li class="layui-nav-item"><a href="javascript:;">看不见我</a></li>--%>
<%--                <li class="layui-nav-item"><a href="javascript:;"></a></li>--%>
            </ul>
        </div>
    </div>
    <div class="layui-body">
        <!-- 内容主体区域 -->
        <iframe id="contentFrame" src="homeframe.jsp" style="width:100%; height:100%;padding: 0;margin:0"></iframe>
    </div>

</div>

<script src="./static/layui.js"></script>
<script>
    //JS
    layui.use(['element', 'layer', 'util','jquery'], function(){
        var element = layui.element;
        var layer = layui.layer;
        var util = layui.util;
        var $ = layui.$;
        var $1 = layui.jquery;

        // 点击标题进入默认大屏展示页面
        $('#demo-logo').on('click', function(){
            $('#contentFrame').attr('src', 'homeframe.jsp');
            $('.layui-nav .layui-this').removeClass('layui-this');
        });

        // 点击左侧切换中间iframe
        $1('.layui-nav-child dd a').on('click', function(){
            var iframeSrc = $(this).data('iframe');
            $('#contentFrame').attr('src', iframeSrc);
        });

        //左侧菜单事件
        util.event('lay-header-event', {
            menuLeft: function(othis){ // 左侧菜单事件
                layer.msg('展开左侧菜单的操作', {icon: 0});
            },
            menuRight: function(){  // 右侧菜单事件
                layer.open({
                    type: 1,
                    title: '更多',
                    content: '<div style="padding: 15px;">综维-张赫原<br>' +
                        'zhangheyuan@sc.chinamobile.com<br>' +
                        'zhangheyuan@msn.com</div>',
                    area: ['260px', '100%'],
                    offset: 'rt', // 右上角
                    anim: 'slideLeft', // 从右侧抽屉滑出
                    shadeClose: true,
                    scrollbar: false
                });
            }
        });
    });
</script>
</body>
</html>
