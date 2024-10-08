<%@ include file="/header.jsp" %>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.SQLException"%>
<%@page import="org.cysecurity.cspf.jvl.model.DBConnect"%>
<%@page import="java.sql.Connection"%>

<%
    // try-with-resources для автоматичного закриття Connection та Statement
    try (
        Connection con = new DBConnect().connect(getServletContext().getRealPath("/WEB-INF/config.properties"));
        Statement stmt = con.createStatement();
    ) {
        if(request.getParameter("delete") != null) {
            String user = request.getParameter("user");      
            stmt.executeUpdate("DELETE FROM users WHERE username='" + user + "'");
        }

        // try-with-resources для автоматичного закриття ResultSet
        try (ResultSet rs = stmt.executeQuery("SELECT * FROM users WHERE privilege='user'")) {
            while(rs.next()) {
                out.print("<input type='radio' name='user' value='" + rs.getString("username") + "'/> " + rs.getString("username") + "<br/>");
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
        out.print("Error: Unable to execute query.");
    }
%>

<form action="manageusers.jsp" method="POST">
    <br/>
    <input type="submit" value="Delete" name="delete"/>
</form>

<br/>
<a href="admin.jsp">Back to Admin Panel</a>

<%@ include file="/footer.jsp" %>