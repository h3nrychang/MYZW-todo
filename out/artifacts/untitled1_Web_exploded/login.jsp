<%@ page import="java.sql.*" %>
<%@ page import="util.DBUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>登录页面</title>
</head>
<body>
<h2>登录系统</h2>
<form action="login.jsp" method="post">
    用户名：<input type="text" name="username" required><br>
    密码：<input type="password" name="password" required><br>
    <input type="submit" value="登录">
</form>

<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    if (username != null && password != null) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement("SELECT * FROM users WHERE username = ? AND password = ?");
            pstmt.setString(1, username);
            pstmt.setString(2, password);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                session.setAttribute("user", username);
                session.setAttribute("userId", rs.getInt("id"));
                session.setAttribute("role", rs.getString("role")); // loggedInUser 是从数据库中查询的用户对象
                response.sendRedirect("index.jsp");
                return;
            } else {
                out.print("用户名或密码错误，请重试。");
            }
        } catch (SQLException e) {
            out.print("数据库错误：" + e.getMessage());
        } finally {
            DBUtil.close(conn, pstmt, rs);
        }
    }
%>

</body>
</html>
