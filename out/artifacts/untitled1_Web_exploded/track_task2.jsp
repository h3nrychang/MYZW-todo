<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Task Tracking</title>
</head>
<body>
<%@ page import="java.sql.*" %>
<%@ page import="util.DBUtil" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    String action = request.getParameter("action");

    // 处理列名编辑
    if ("editColumns".equals(action)) {
        String[] columnNames = request.getParameterValues("columnNames[]");
        if (columnNames != null) {
            try (Connection conn = DBUtil.getConnection()) {
                String deleteSQL = "DELETE FROM task_tracking2"; // 清空列名
                PreparedStatement psDelete = conn.prepareStatement(deleteSQL);
                psDelete.executeUpdate();

                String insertSQL = "INSERT INTO task_tracking2 (col_key) VALUES (?)";
                PreparedStatement psInsert = conn.prepareStatement(insertSQL);

                for (String columnName : columnNames) {
                    if (columnName != null && !columnName.trim().isEmpty()) {
                        psInsert.setString(1, columnName.trim());
                        psInsert.executeUpdate();
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // 查询当前列名
    List<String> columnHeaders = new ArrayList<>();
    try (Connection conn = DBUtil.getConnection()) {
        String headerQuery = "SELECT DISTINCT col_key FROM task_tracking2 ORDER BY id";
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(headerQuery);
        while (rs.next()) {
            columnHeaders.add(rs.getString("col_key"));
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    // 查询数据
    Map<String, List<Map<String, String>>> groupedData = new HashMap<>();
    try (Connection conn = DBUtil.getConnection()) {
        String dataQuery = "SELECT row_id, col_key, col_value FROM task_tracking2 ORDER BY row_id, col_key";
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(dataQuery);

        while (rs.next()) {
            String rowId = rs.getString("row_id");
            String colKey = rs.getString("col_key");
            String colValue = rs.getString("col_value");

            if (!groupedData.containsKey(rowId)) {
                groupedData.put(rowId, new ArrayList<>());
            }
            Map<String, String> rowData = new HashMap<>();
            rowData.put(colKey, colValue);
            groupedData.get(rowId).add(rowData);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>

<h2>数据列表</h2>
<table border="1">
    <thead>
    <tr>
        <%
            // 输出表头
            for (String header : columnHeaders) {
        %>
        <th><%= header %></th>
        <%
            }
        %>
    </tr>
    </thead>
    <tbody>
    <%
        // 输出每个 row_id 的数据
        for (String rowId : groupedData.keySet()) {
            List<Map<String, String>> rowValues = groupedData.get(rowId);
            // 输出每个 row_id 对应的行数据
            for (Map<String, String> rowData : rowValues) {
    %>
    <tr>
        <%
            // 输出列数据
            for (String header : columnHeaders) {
                String value = rowData.getOrDefault(header, ""); // 获取当前列的数据
        %>
        <td><%= value != null ? value : "" %></td>
        <%
            }
        %>
    </tr>
    <%
            }
        }
    %>
    </tbody>
</table>

</body>
</html>
