<%@ page import="util.DBUtil" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %><%--
  Created by IntelliJ IDEA.
  User: zhang
  Date: 2024/10/25
  Time: 14:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="utf-8">
    <title></title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="./static/css/layui.css" rel="stylesheet">
    <style>
        #control {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .layui-btn {
            justify-content: center;
        }
    </style>
</head>
<body>
<div class="layui-row" id="title">
    <div class="layui-col-xs12" style="font-size: 45px;text-align: center">用户管理</div>
</div>
<%
    // 获取 session 信息
    String username = (String) session.getAttribute("user");
    String role = (String) session.getAttribute("role");
%>
<div class="layui-btn-container" id="control">
    <% if ("admin".equals(role)) { %>
    <button type="button" class="layui-btn" lay-on="add"><i class="layui-icon layui-icon-add-circle"></i>添加</button>
    <button type="button" class="layui-btn layui-bg-red" lay-on="rm"><i class="layui-icon layui-icon-delete"></i>删除
    </button>
    <button type="button" class="layui-btn layui-bg-blue" lay-on="edit"><i class="layui-icon layui-icon-edit"></i>修改
    </button>
    <button type="button" class="layui-btn layui-bg-purple"><i class="layui-icon layui-icon-search"></i>查询
    </button>
    <% } %>
    <form id="refreshForm" action="um.jsp" method="post" accept-charset="UTF-8">
        <input type="hidden" name="action" value="List">
        <button type="submit" class="layui-btn layui-btn-normal"><i class="layui-icon layui-icon-refresh-3"></i>刷新
        </button>
    </form>
</div>

<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    String action = request.getParameter("action");
    if (action == null) {
        action = "List"; //进来网页就刷新一次
    }
    if ("List".equals(action)) {
        if ("admin".equals(role)) {
            out.print("<table class='layui-table'>");
            out.print("<thead><tr><th>ID</th><th>登录账号</th><th>昵称</th><th>密码</th><th>权限</th><th>创建时间</th><th>操作</th></tr></thead>");
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            try {
                conn = DBUtil.getConnection();
                pstmt = conn.prepareStatement("SELECT * FROM users");
                rs = pstmt.executeQuery();

                StringBuilder results = new StringBuilder();
                while (rs.next()) {
                    results.append("<tr>")
                            .append("<td>").append(rs.getInt("id")).append("</td>")
                            .append("<td>").append(rs.getString("username")).append("</td>")
                            .append("<td>").append(rs.getString("nickname")).append("</td>")
                            .append("<td>").append(rs.getString("password")).append("</td>")
                            .append("<td>").append(rs.getString("role")).append("</td>")
                            .append("<td>").append(rs.getTimestamp("created_at")).append("</td>")
                            .append("<td>")
                            .append("<div class=\"layui-btn-container\" >")
//                        这个是修改按钮
                            .append("<button class='layui-btn layui-btn-primary' onclick=\"edit_id(").append(rs.getInt("id")).append(")\">修改</button> ")
//                        这个是跟踪按钮
//                            .append("<button class='layui-btn layui-btn-primary' onclick=\"window.location.href='track_task.jsp?id=").append(rs.getInt("id")).append("'\">跟踪</button>")
//
//                            .append("<form style='display:inline;' action='um.jsp' method='post' accept-charset='UTF-8'>")
//                            .append("<input type='hidden' name='action' value='Delete'>")
//                            .append("<input type='hidden' name='name' value='").append(rs.getInt("id")).append("'>")
//                        这个是删除按钮
                            .append("<button type='submit' class='layui-btn layui-btn-primary'>删除</button>")
                            .append("</form>")
                            .append("</div>")
                            .append("</td>")
                            .append("</tr>");
                }
                out.print(results.toString());
                out.print("</table>");
            } catch (SQLException e) {
                e.printStackTrace();
            } finally {
                DBUtil.close(conn, pstmt, rs);
            }
        } else {
            out.print("对不起，您没有访问权限");
        }

    }
%>

<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    if (action != null && !action.equals("List")) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
//            添加任务功能
            if ("Add".equals(action)) {
                String title = request.getParameter("title");
                String content = request.getParameter("content");
                String priority = request.getParameter("priority");
                String extra = request.getParameter("extra");
                pstmt = conn.prepareStatement("INSERT INTO users (username, password, nickname, role) VALUES (?, ?, ?, ?)");
                pstmt.setString(1, title);
                pstmt.setString(2, content);
                pstmt.setString(3, username);
                pstmt.setString(4, priority);
                pstmt.executeUpdate();
                out.print("添加成功 added successfully.<br>5秒后跳转到首页");
                out.print("<script>setTimeout(function() { window.location.href='um.jsp?action=List'; }, 5000);</script>");
            } else if ("Delete".equals(action)) {
                String name = request.getParameter("name");
                pstmt = conn.prepareStatement("UPDATE users SET is_deleted = 1 WHERE id = ?");
                pstmt.setString(1, name);
                int rowsAffected = pstmt.executeUpdate();
                if (rowsAffected > 0) {
                    out.print("删除成功。<br>5秒后跳转到首页");
                } else {
                    out.print("未找到指定的用户，无法删除。<br>5秒后跳转到首页");
                }
                out.print("<script>setTimeout(function() { window.location.href='um.jsp?action=List'; }, 5000);</script>");
            } else if ("Update".equals(action)) {
                String id = request.getParameter("id");
                String title = request.getParameter("title");
                String content = request.getParameter("content");
                String priority = request.getParameter("priority");
                pstmt = conn.prepareStatement("UPDATE work_orders SET title = ?, content = ?, priority = ? WHERE id = ? AND deleted = 0");
                pstmt.setString(1, title);
                pstmt.setString(2, content);
                pstmt.setString(3, priority);
                pstmt.setString(4, id);
                int rowsAffected = pstmt.executeUpdate();
                if (rowsAffected > 0) {
                    out.print("用户更新成功。<br>5秒后跳转到首页");
                } else {
                    out.print("未找到指定的用户，无法更新。<br>5秒后跳转到首页");
                }
                out.print("<script>setTimeout(function() { window.location.href='um.jsp?action=List'; }, 5000);</script>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.print("Error: " + e.getMessage() + "<br>");
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
    }
%>
</body>
<script src="./static/layui.js"></script>
<script>
    layui.use(function () {
        var layer = layui.layer;
        var util = layui.util;
        var laydate = layui.laydate;
        // 渲染
        laydate.render({
            elem: '#ID-laydate-demo'
        });

        util.on('lay-on', {
            add: function () {
                layer.open({
                    type: 1,
                    area: ['350px', '500px'],
                    content:
                        '<form action="2-1shixiang.jsp" method="post" accept-charset="UTF-8">' +
                        '<div class="layui-form">' +
                        '<div class="layui-form-item">' +
                        '<div class="layui-inline">' +
                        '<label class="layui-form-label">标题</label>' +
                        '<div class="layui-input-inline">' +
                        '<input type="text" name="title" placeholder="请输入待办标题" class="layui-input">' +
                        '</div>' +
                        '</div>' +
                        '</div>' +
                        '<div class="layui-form-item">' +
                        '<div class="layui-inline">' +
                        '<label class="layui-form-label">内容</label>' +
                        '<div class="layui-input-inline">' +
                        '<textarea name="content" placeholder="请输入待办内容" class="layui-textarea"></textarea>' +
                        '</div>' +
                        '</div>' +
                        '</div>' +
                        '<div class="layui-form-item">' +
                        '<div class="layui-inline">' +
                        '<label class="layui-form-label">预计完成时间</label>' +
                        '<div class="layui-input-inline">' +
                        '<input type="text" name="comlete_at" class="layui-input" id="ID-laydate-demo" placeholder="yyyy-MM-dd">' +
                        '</div>' +
                        '</div>' +
                        '</div>' +
                        '<div class="layui-form-item">' +
                        '<div class="layui-inline">' +
                        '<label class="layui-form-label">重要性</label>' +
                        '<div class="layui-input-inline">' +
                        '<select name="priority" class="layui-input" name="priority">' +
                        '<option value="3">紧急</option>' +
                        '<option value="2">重要</option>' +
                        '<option value="1">一般</option>' +
                        '</select>' +
                        '</div>' +
                        '</div>' +
                        '</div>' +
                        '<div class="layui-form-item">' +
                        '<div class="layui-inline">' +
                        '<label class="layui-form-label">额外字段</label>' +
                        '<div class="layui-input-inline">' +
                        '<textarea name="extra" placeholder="多个字段请用逗号隔开" class="layui-textarea"></textarea>' +
                        '</div>' +
                        '</div>' +
                        '</div>' +
                        '<div class="layui-form-item">' +
                        '<div class="layui-input-block">' +
                        // '<div class="layui-btn-container">' +
                        '<button type="submit" class="layui-btn">+添加事项</button>' +
                        // '</div>' +
                        '</div>' +
                        '</div>' +
                        '</div>' +
                        // '作业标题：<input type="text" name="title" ><br>' +
                        // '作业内容：<input type="text" name="content" ><br>' +
                        '<input type="hidden" name="action" value="Add"><br>' +
                        // '<input type="submit" value="新建">' +

                        '</form>'

                });
                layui.use(['laydate', 'form'], function () {
                    var laydate = layui.laydate;
                    var form = layui.form;

                    // 初始化日期选择器
                    laydate.render({
                        elem: '#ID-laydate-demo' // 指定日期输入框的id
                    });

                    // 渲染表单中的下拉菜单
                    form.render('select');
                });
            },
            rm: function () {
                layer.open({
                    type: 1,
                    area: ['420px', '240px'],
                    content: '' +
                        '<form action="um.jsp" method="post" accept-charset="UTF-8">' +
                        '请输入事务ID：<input type="text" name="name" required><br>' +
                        '<input type="hidden" name="action" value="Delete"><br>' +
                        '<input type="submit" value="删除事务"><br>' +
                        '</form>'

                });
            },
            edit: function () {
                layer.open({
                    type: 1,
                    area: ['420px', '240px'],
                    content: '' +
                        '<form action="um.jsp" method="post" accept-charset="UTF-8">' +
                        '请输入事务ID：<input type="text" name="name" required><br>' +
                        '<input type="hidden" name="action" value="Delete"><br>' +
                        '<input type="submit" value="删除事务"><br>' +
                        '</form>'
                });
            },
        });
    });

    function edit_id(id) {
        layer.open({
            type: 1,
            area: ['420px', '240px'],
            content: '<form action="um.jsp" method="post" accept-charset="UTF-8">' +
                '用户ID：<input type="text" name="id" value="' + id + '" readonly><br>' +
                '用户名：<input type="text" name="title"><br>' +
                '密码：<input type="text" name="content"><br>' +
                // '已完成：<input type="checkbox" name="state"><br>' +
                '<input type="hidden" name="action" value="Update">' +
                '<input type="submit" value="修改">' +
                '</form>'
        });
    }
</script>

</html>
