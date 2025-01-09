<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Image Search</title>
    <style>
        /* General styling */
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f7f7f7;
        }

        /* Container styling */
        .container {
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        /* Header styling */
        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }

        /* Form styling */
        .search-form {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 20px;
        }

        label {
            font-size: 16px;
            color: #555;
        }

        input[type="text"] {
            width: 100%;
            max-width: 400px;
            padding: 10px;
            font-size: 14px;
            border: 1px solid #ddd;
            border-radius: 4px;
            outline: none;
        }

        input[type="text"]:focus {
            border-color: #4CAF50;
        }

        .button {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            cursor: pointer;
            border-radius: 4px;
            font-size: 16px;
        }

        .button:hover {
            background-color: #45a049;
        }

        /* Image result styling */
        .image-result {
            margin-top: 30px;
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: center;
        }

        .image-card {
            text-align: center;
            background-color: #f9f9f9;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 10px;
            max-width: 250px;
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
        <h1>Image Search</h1>
        <form class="search-form" method="get">
            <label for="name">Enter Name:</label>
            <input type="text" id="name" name="name" placeholder="Type a name..." required>
            <button type="submit" class="button">Search</button>
        </form>

        <div class="image-result">
            <%
                // Check if a name is provided in the request
                String nameQuery = request.getParameter("name");
                if (nameQuery != null && !nameQuery.isEmpty()) {
                    try {
                        // Database connection
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/faceannotation", "root", "");

                        // Query to search images by name
                        String sql = "SELECT name, file_path FROM uploaded_images WHERE name LIKE ?";
                        PreparedStatement pstmt = conn.prepareStatement(sql);
                        pstmt.setString(1, "%" + nameQuery + "%");
                        ResultSet rs = pstmt.executeQuery();

                        // Check if any result exists
                        boolean hasResults = false;
                        while (rs.next()) {
                            hasResults = true;
                            String name = rs.getString("name");

                            // Convert BLOB to Base64 for display
                            Blob blob = rs.getBlob("file_path");
                            byte[] blobBytes = blob.getBytes(1, (int) blob.length());
                            String base64Image = java.util.Base64.getEncoder().encodeToString(blobBytes);
            %>
                            <div class="image-card">
                                <img src="data:image/jpeg;base64,<%= base64Image %>" alt="<%= name %>">
                                <p><%= name %></p>
                            </div>
            <%
                        }

                        if (!hasResults) {
                            out.println("<p style='text-align: center; color: #888;'>No results found for '<strong>" + nameQuery + "</strong>'.</p>");
                        }

                        conn.close();
                    } catch (Exception e) {
                        out.println("<p style='color: red;'>Error: " + e.getMessage() + "</p>");
                    }
                }
            %>
        </div>
    </div>
        <div class="back-link">
            <p>Back To <a href="index.html">Dashboard</a></p>
        </div>
</body>
</html>
