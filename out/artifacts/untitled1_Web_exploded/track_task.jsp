<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBUtil" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="java.nio.file.Paths" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");

    // 获取当前任务ID
    int taskId = Integer.parseInt(request.getParameter("id"));
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        conn = DBUtil.getConnection();
        // 查询工单标题
        pstmt = conn.prepareStatement("SELECT * FROM work_orders WHERE id = ?");
        pstmt.setInt(1, taskId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
%>

<html>
<head>
    <meta charset="utf-8">
    <title></title>
    <link href="./static/css/layui.css" rel="stylesheet">
    <script>
        window.onload = function () {
            addTextBoxes();
        };

        function addTextBoxes() {
            // 获取表格的thead中的tr元素
            var thead = document.querySelector('thead tr');
            // 获取所有的th元素
            var ths = thead.getElementsByTagName('th');
            // 指定的列名
            var specifiedHeaders = ['用户', '完成情况说明', '图片', '更新时间'];
            // 计算除了指定列之外的列数
            var additionalCols = 0;
            for (var i = 0; i < ths.length; i++) {
                if (!specifiedHeaders.includes(ths[i].textContent.trim())) {
                    additionalCols++;
                }
            }

            // 获取表单元素
            var form = document.getElementById('myForm');
            // 根据额外的列数动态添加文本框
            for (var i = 0; i < additionalCols; i++) {
                var input = document.createElement('input');
                input.type = 'text';
                input.name = 'additionalCol' + i; // 可以根据需要修改name的格式
                form.appendChild(input);
            }

            // 拼接文本框的name属性值
            var textBoxNames = [];
            var inputs = form.getElementsByTagName('input');
            for (var i = 0; i < inputs.length; i++) {
                if (inputs[i].type === 'text') {
                    textBoxNames.push(inputs[i].name);
                }
            }

            // 创建提交按钮
            var submitButton = document.createElement('input');
            submitButton.type = 'submit';
            submitButton.value = '提交';

            // 将提交按钮添加到表单中
            form.appendChild(submitButton);

            // 输出拼接后的字符串
            console.log(textBoxNames.join(', '));

        }
    </script>
</head>
<body>

<div class="layui-row" id="title">
    <div class="layui-col-xs12" style="font-size: 45px;text-align: center"><%=rs.getString("title")%>-跟踪记录表</div>
</div>

<%--下面是菜单栏--%>
<div class="layui-btn-container" id="control">
    <button type="button" class="layui-btn layui-bg-blue" onclick="location.href='2-1shixiang.jsp'"><i
            class="layui-icon layui-icon-left"></i>返回
    </button>
</div>

<%
    // 接收额外的extra字段
//    out.print("【调试】准备接受额外字段<br>");
    PreparedStatement trackingPstmt = conn.prepareStatement(
            "SELECT t.*, u.username, t.extra " +
                    "FROM task_tracking t " +
                    "JOIN users u ON t.user_id = u.id " +
                    "WHERE t.work_order_id = ?"
    );
    trackingPstmt.setInt(1, taskId);
    ResultSet trackingRs = trackingPstmt.executeQuery();

    JSONArray headers = null;
    JSONArray data = null;

    if (trackingRs.next()) {

    }

//    trackingRs.next();

    System.out.println("【调试】trackingRs.getString(\"extra\")：" + trackingRs.getString("extra"));
//    out.print("【调试】" + trackingRs.getString("extra") + "<br>");

    if (trackingRs.getString("extra") != "") {
        // 获取extra字段（假设是JSON格式）
        String extraJson = trackingRs.getString("extra");

        // 解析extra字段（如果是JSON格式）
        JSONObject json = new JSONObject(extraJson);
        headers = json.getJSONArray("headers");
        data = json.getJSONArray("data");
    }
//    out.print("【调试】执行完毕！<br>");
%>


<%--接下来是数据表的部分--%>
<table class="layui-table">
    <thead>
    <tr>
        <th>用户</th>
        <th>完成情况说明</th>
        <th>图片</th>
        <th>更新时间</th>
        <%--        <th>附加信息</th>--%>
        <%--        下面是额外的行信息--%>
        <%
            for (int i = 0; i < headers.length(); i++) {
                out.println("<th>" + headers.getString(i) + "</th>");
            }
        %>
    </tr>
    </thead>
    <tbody>
    <% while (trackingRs.next()) {
//        String extraJson = trackingRs.getString("extra");
//        headers = new JSONObject(trackingRs.getString("extra")).getJSONArray("headers");
        data = new JSONObject(trackingRs.getString("extra")).getJSONArray("data");
    %>

    <tr>
        <td><%=trackingRs.getString("username")%>
        </td>
        <td><%=trackingRs.getString("tracking_comment") != null ? trackingRs.getString("tracking_comment") : "无内容"%>
        </td>
        <td>
            <% if (trackingRs.getString("tracking_image") != null) { %>
            <img src="<%=trackingRs.getString("tracking_image")%>" alt="图片" width="100">
            <% } else { %>
            无
            <% } %>
        </td>
        <td><%=trackingRs.getTimestamp("updated_at")%>
        </td>

        <%
            // 遍历 data 数组，生成数据行
            for (int i = 0; i < data.length(); i++) {
                out.println("<td>" + data.getString(i) + "</td>");
//                trackingRs.getString("extra");
            }
        %>

    </tr>
    <% } %>
    </tbody>
</table>

<!-- 提交表单，添加新的跟踪记录 -->
<form id="myForm" action="track_task.jsp?action=update&id=<%=taskId%>" method="post">
    <input type="hidden" name="action" value="update">
    <input type="hidden" name="id" value="<%=taskId%>">
    <div>
        <label>完成情况说明：</label>
        <textarea name="tracking_comment"></textarea>
    </div>
    <div>
        <label>上传图片：</label>
        <input type="file" name="tracking_image">
    </div>
    <input type="submit" value="提交">
</form>


<%
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        DBUtil.close(conn, pstmt, rs);
    }

    // 处理提交的表单
    String action = request.getParameter("action");
    if ("update".equals(action)) {
        Integer userId = (Integer) session.getAttribute("userId");
        String trackingComment = request.getParameter("tracking_comment");
        String trackingImagePath = null;

        // 获取请求的参数名称枚举
        Enumeration<String> parameterNames = request.getParameterNames();
        List<String> paramValues = new ArrayList<>();

        // 遍历参数名称
        while (parameterNames.hasMoreElements()) {
            String paramName = parameterNames.nextElement();
            String paramValue = request.getParameter(paramName);

//            out.println("【调试】【遍历参数名称】参数名: " + paramName + ", 参数值: " + paramValue + "<br>");
            System.out.println("【调试】【遍历参数名称】参数名: " + paramName + ", 参数值: " + paramValue + "<br>");

            paramValues.add(paramValue);
        }
        String[] valuesArray = paramValues.toArray(new String[0]);

        // 检查是否有文件上传


        // 处理自定义列并将其格式化为JSON
        String[] customColumnNames = request.getParameterValues("custom_column_name[]");
        String[] customColumnValues = request.getParameterValues("custom_column_value[]");
        System.out.println(Arrays.toString(customColumnValues));

        JSONObject extraJson = new JSONObject();
        JSONObject customColumns = new JSONObject();
//        去掉没用的四个参数
//        【调试】【遍历参数名称】参数名: action, 参数值: update<br>
//【调试】【遍历参数名称】参数名: id, 参数值: 39<br>
//【调试】【遍历参数名称】参数名: tracking_comment, 参数值: 1<br>
//【调试】【遍历参数名称】参数名: tracking_image, 参数值: <br>
//【调试】【遍历参数名称】参数名: additionalCol0, 参数值: a<br>
//【调试】【遍历参数名称】参数名: additionalCol1, 参数值: a<br>
//【调试】【遍历参数名称】参数名: additionalCol2, 参数值: a<br>
        if (valuesArray.length > 4) {
            valuesArray = Arrays.copyOfRange(valuesArray, 4, valuesArray.length);
        } else {
            valuesArray = new String[0]; // 如果长度小于等于4，返回空数组
        }
//        if (customColumnNames != null && customColumnValues != null) {
//            for (int i = 0; i < customColumnNames.length; i++) {
//                customColumns.put(customColumnNames[i], customColumnValues[i]);
//            }
//            extraJson.put("custom_columns", customColumns);
        extraJson.put("data", valuesArray);
//            System.out.println("组建的数组为" + Arrays.toString(valuesArray));

//        } else {
//            extraJson.put("headers", new ArrayList<>());
//            extraJson.put("data", new ArrayList<>());
//            System.out.println("没检测到数据");
//        }


        String extraJsonString = extraJson.toString(); // 将JSON对象转换为字符串
        System.out.println("最终字符串：" + extraJsonString);


        try {
            conn = DBUtil.getConnection();
            String insertSql = "INSERT INTO task_tracking (work_order_id, user_id, tracking_comment, tracking_image, extra) VALUES (?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(insertSql);
            pstmt.setInt(1, taskId);
            pstmt.setInt(2, userId);
            pstmt.setString(3, trackingComment);
            pstmt.setString(4, trackingImagePath);
            pstmt.setString(5, extraJsonString);
            pstmt.executeUpdate();
            response.sendRedirect("track_task.jsp?id=" + taskId);
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
    }
%>


</body>
<script src="./static/layui.js"></script>

</html>
