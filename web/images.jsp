<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Uploaded Images</title>
        <style>
            /* General body styling */
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f7f7f7;
            }

            /* Page container styling */
            .container {
                max-width: 1200px;
                margin: 30px auto;
                padding: 20px;
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }

            /* Header styling */
            h1 {
                text-align: center;
                color: #333;
                margin-bottom: 30px;
            }

            /* Image grid styling */
            .image-container {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 20px;
                padding: 10px;
            }

            /* Individual image card styling */
            .image-card {
                text-align: center;
                background-color: #f9f9f9;
                border: 1px solid #ddd;
                border-radius: 8px;
                padding: 10px;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .image-card:hover {
                transform: scale(1.05);
                box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
            }

            .image-card img {
                max-width: 100%;
                max-height: 180px;
                border-radius: 4px;
            }

            /* Text under images */
            .image-card p {
                margin-top: 10px;
                font-size: 14px;
                color: #555;
            }
            .back-link {
                text-align: center;
                margin-top: 20px;
            }
            .back-link a {
                color: #3498db;
                text-decoration: none;
                font-size: 14px;
            }
            .back-link a:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Uploaded Images</h1>
            <div class="image-container">
                <%
                    try {
                        // Database connection
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/faceannotation", "root", "");

                        // Query to get all images ordered by upload_date (newest first)
                        String sql = "SELECT id, name FROM uploaded_images ORDER BY upload_date DESC";
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery(sql);

                        while (rs.next()) {
                            int id = rs.getInt("id");
                            String name = rs.getString("name");
                %>
                <div class="image-card">
                    <img src="GetImageServlet?id=<%= id%>" alt="<%= name%>" />
                    <p><%= name%></p>
                </div>
                <%
                        }

                        conn.close();
                    } catch (Exception e) {
                        out.println("<p>Error loading images: " + e.getMessage() + "</p>");
                    }
                %>
            </div>
        </div>
        <div class="back-link">
            <p>Back To <a href="index.html">Dashboard</a></p>
        </div>
    </body>
</html>
