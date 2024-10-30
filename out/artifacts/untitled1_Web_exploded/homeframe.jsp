<%@ page import="java.sql.Connection" %>
<%@ page import="util.DBUtil" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %><%--
  Created by IntelliJ IDEA.
  User: zhang
  Date: 2024/10/10
  Time: 10:41
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta charset="utf-8">
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="./static/css/layui.css" rel="stylesheet">
    <style>
        html, body {
            margin: 0;
            padding: 0;
            height: 100%;
            overflow: hidden;
        }

        #background {
            position: fixed;
            top: 0;
            right: 0;
            bottom: 0;
            left: 0;
            background-image: url('./static/img/bg.jpeg');
            background-size: cover;
            background-position: center;
        }

        #title {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: white;
            font-size: 3rem;
            text-align: center;
        }
    </style>
</head>
<body>
<div id="background">

    <div class="layui-container">
        <div class="layui-panel">
            <div style="padding: 32px;">
                <%
                    // 查询待办事项数量
                    String countQuery = "SELECT COUNT(*) AS count FROM work_orders WHERE is_deleted = 0 AND status = 'pending'";
                    Connection conn = null;
                    PreparedStatement stmt = null;
                    ResultSet rs = null;
                    int count = 0;

                    try {
                        conn = DBUtil.getConnection();
                        stmt = conn.prepareStatement(countQuery);
                        rs = stmt.executeQuery();

                        if (rs.next()) {
                            count = rs.getInt("count");
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    } finally {
                        DBUtil.close(conn, stmt, rs);
                    }
                %>
                目前有 <%= count %> 个待办事项尚未处理，请尽快完成~
            </div>
        </div>

        <div class="layui-bg-gray" style="padding: 16px;">
            <div class="layui-row layui-col-space15">
                <%
                    // 查询每个月的事件
                    String eventsQuery = "SELECT MONTH(initiated_at) AS month, GROUP_CONCAT(title SEPARATOR '<br>') AS events " +
                            "FROM work_orders WHERE is_deleted = 0 GROUP BY MONTH(initiated_at) ORDER BY month";
                    Map<Integer, String> monthEvents = new HashMap<>();

                    try {
                        conn = DBUtil.getConnection();
                        stmt = conn.prepareStatement(eventsQuery);
                        rs = stmt.executeQuery();

                        while (rs.next()) {
                            int month = rs.getInt("month");
                            String events = rs.getString("events");
                            monthEvents.put(month, events);
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    } finally {
                        DBUtil.close(conn, stmt, rs);
                    }

                    // 生成每个月的事件卡片
                    for (int month = 1; month <= 12; month++) {
                        if (monthEvents.containsKey(month)) {
                            String events = monthEvents.get(month);
                %>
                <div class="layui-col-md6">
                    <div class="layui-card" style="opacity: 0.8;">
                        <div class="layui-card-header"><%= month %>月事件</div>
                        <div class="layui-card-body">
                            <%= events %>
                        </div>
                    </div>
                </div>
                <%
                        }
                    }
                %>
            </div>
        </div>
    </div>
</div>
</body>
</html>