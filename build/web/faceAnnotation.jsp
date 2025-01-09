<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Face Annotation</title>
        <style>
            /* General body styling */
            body {
                font-family: 'Roboto', sans-serif;
                margin: 0;
                padding: 0;
                background-color: #eef2f3;
            }

            /* Page container styling */
            .container {
                max-width: 1200px;
                margin: 30px auto;
                padding: 20px;
                background-color: #ffffff;
                border-radius: 10px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            }

            /* Header styling */
            h1 {
                text-align: center;
                font-size: 2.2em;
                color: #333;
                margin-bottom: 30px;
                border-bottom: 2px solid #e0e0e0;
                padding-bottom: 10px;
            }

            /* Image grid styling */
            .image-container {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 15px;
                padding: 10px;
            }

            /* Individual image card styling */
            .image-card {
                background-color: #ffffff;
                border: 1px solid #e0e0e0;
                border-radius: 8px;
                overflow: hidden;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                transition: transform 0.3s, box-shadow 0.3s;
            }

            .image-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 20px rgba(0, 0, 0, 0.2);
            }

            /* Image styling */
            .image-card img {
                width: 100%;
                height: 200px;
                object-fit: cover;
                border-bottom: 1px solid #e0e0e0;
            }

            /* Text under images */
            .image-card p {
                padding: 15px;
                margin: 0;
                font-size: 16px;
                font-weight: bold;
                color: #555;
                text-align: center;
            }

            /* Responsive design for small screens */
            @media (max-width: 600px) {
                .image-card p {
                    font-size: 14px;
                }
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
            <h1>Face Annotation</h1>
            <div class="image-container">
                <%
                    try {
                        // Database connection
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/faceannotation", "root", "");

                        // Query to get all images
                        String sql = "SELECT id, name FROM uploaded_images";
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
