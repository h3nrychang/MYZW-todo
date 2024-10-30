<%--
  Created by IntelliJ IDEA.
  User: zhang
  Date: 2024/10/11
  Time: 16:35
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, util.DBUtil" %>

<html>
<head>
    <meta charset="utf-8">
    <title></title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="./static/css/layui.css" rel="stylesheet">
</head>
<body>
<div class="layui-row" id="title">
    <div class="layui-col-xs12" style="font-size: 60px;text-align: center">待办流程一览</div>
</div>
<div class="layui-timeline">
    <%
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
//            out.println("【调试】Connecting to the database...<br>");
            conn = DBUtil.getConnection();
//            out.println("【调试】Connection established.<br>");

            // 查询所有待办事项
//            String sql = "SELECT * FROM work_orders WHERE status = 'pending' ORDER BY initiated_at";
            String sql = "SELECT * FROM work_orders WHERE status = 'pending' AND is_deleted = 0 ORDER BY initiated_at DESC";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            // 使用 HashMap 按月分组待办事项
            java.util.Map<String, java.util.List<String>> monthlyTodos = new java.util.HashMap<>();

            while (rs.next()) {
                int id = rs.getInt("id");
                String title = rs.getString("title");
                String content = rs.getString("content");
                String initiator = rs.getString("initiator");
                Timestamp initiatedAt = rs.getTimestamp("initiated_at");

                // 获取年份和月份
                java.util.Calendar cal = java.util.Calendar.getInstance();
                cal.setTime(initiatedAt);
                String yearMonth = cal.get(java.util.Calendar.YEAR) + "-" + (cal.get(java.util.Calendar.MONTH) + 1);

                // 初始化列表并添加待办事项
                monthlyTodos.putIfAbsent(yearMonth, new java.util.ArrayList<String>());
                monthlyTodos.get(yearMonth).add("ID: " + id + ", 标题: " + title + ", 内容: " + content + ", 发起人: " + initiator);
            }

            // 获取当前年份
            int currentYear = java.util.Calendar.getInstance().get(java.util.Calendar.YEAR);

            // 遍历所有月份并输出待办事项
            for (int month = 12; month >= 1; month--) {
                String yearMonth = currentYear + "-" + month;
                java.util.List<String> todos = monthlyTodos.getOrDefault(yearMonth, new java.util.ArrayList<String>());
    %>
    <div class="layui-timeline-item">
        <i class="layui-icon layui-timeline-axis"></i>
        <div class="layui-timeline-content layui-text">
            <h3 class="layui-timeline-title"><%= yearMonth %></h3>
            <p>
                <%
                    if (todos.isEmpty()) {
                        out.println("本月无待办事项");
                    } else {
                        for (String todo : todos) {
                %>
                <li><%= todo %></li>
                <%
                        }
                    }
                %>
            </p>
        </div>
    </div>
    <%
            }
        } catch (SQLException e) {
            e.printStackTrace(); // 打印异常堆栈跟踪
            out.println("Error: " + e.getMessage());
        } finally {
            // 使用 DBUtil 关闭连接
            DBUtil.close(conn, pstmt, rs);
        }
    %>
</div>


<%--<%--%>
<%--//    Connection conn = null;--%>
<%--//    PreparedStatement pstmt = null;--%>
<%--//    ResultSet rs = null;--%>

<%--    try {--%>
<%--        out.println("【调试】Connecting to the database...<br>");--%>
<%--        conn = DBUtil.getConnection();--%>
<%--        out.println("【调试】Connection established.<br>");--%>

<%--        // 查询所有待办事项--%>
<%--        String sql = "SELECT * FROM work_orders WHERE status = 'pending' ORDER BY initiated_at";--%>
<%--        pstmt = conn.prepareStatement(sql);--%>
<%--        rs = pstmt.executeQuery();--%>

<%--        // 使用 HashMap 按月分组待办事项--%>
<%--        java.util.Map<String, java.util.List<String>> monthlyTodos = new java.util.HashMap<>();--%>

<%--        while (rs.next()) {--%>
<%--            int id = rs.getInt("id");--%>
<%--            String title = rs.getString("title");--%>
<%--            String content = rs.getString("content");--%>
<%--            String initiator = rs.getString("initiator");--%>
<%--            Timestamp initiatedAt = rs.getTimestamp("initiated_at");--%>

<%--            // 获取年份和月份--%>
<%--            java.util.Calendar cal = java.util.Calendar.getInstance();--%>
<%--            cal.setTime(initiatedAt);--%>
<%--            String yearMonth = cal.get(java.util.Calendar.YEAR) + "-" + (cal.get(java.util.Calendar.MONTH) + 1);--%>

<%--            // 初始化列表并添加待办事项--%>
<%--            monthlyTodos.putIfAbsent(yearMonth, new java.util.ArrayList<String>()); // 指定泛型为 String--%>
<%--            monthlyTodos.get(yearMonth).add("ID: " + id + ", 标题: " + title + ", 内容: " + content + ", 发起人: " + initiator);--%>
<%--        }--%>

<%--        // 获取当前年份--%>
<%--        int currentYear = java.util.Calendar.getInstance().get(java.util.Calendar.YEAR);--%>
<%--%>--%>

<%--&lt;%&ndash;<h2>待办事项统计</h2>&ndash;%&gt;--%>
<%--<table border="1">--%>
<%--    <tr>--%>
<%--        <th>月份</th>--%>
<%--        <th>待办事项</th>--%>
<%--    </tr>--%>
<%--    <%--%>
<%--        // 遍历所有月份并输出待办事项--%>
<%--        for (int month = 12; month >= 1; month--) {--%>
<%--            String yearMonth = currentYear + "-" + month;--%>
<%--            java.util.List<String> todos = monthlyTodos.getOrDefault(yearMonth, new java.util.ArrayList<String>()); // 指定泛型为 String--%>
<%--    %>--%>
<%--    <tr>--%>
<%--        <td><%= yearMonth %></td>--%>
<%--        <td>--%>
<%--            <ul>--%>
<%--                <%--%>
<%--                    if (todos.isEmpty()) {--%>
<%--                %>--%>
<%--                <li>本月无待办事项</li>--%>
<%--                <%--%>
<%--                } else {--%>
<%--                    for (String todo : todos) {--%>
<%--                %>--%>
<%--                <li><%= todo %></li>--%>
<%--                <%--%>
<%--                        }--%>
<%--                    }--%>
<%--                %>--%>
<%--            </ul>--%>
<%--        </td>--%>
<%--    </tr>--%>
<%--    <%--%>
<%--        }--%>
<%--    %>--%>
<%--</table>--%>
<%--<%--%>
<%--    } catch (SQLException e) {--%>
<%--        e.printStackTrace(); // 打印异常堆栈跟踪--%>
<%--        out.println("Error: " + e.getMessage());--%>
<%--    } finally {--%>
<%--        // 使用 DBUtil 关闭连接--%>
<%--        DBUtil.close(conn, pstmt, rs);--%>
<%--    }--%>
<%--%>--%>
</body>
</html>
