<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>File Upload Statistics</title>
    <style>
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
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
        google.charts.load('current', {packages: ['corechart', 'bar']});
        google.charts.setOnLoadCallback(drawChart);

        function drawChart() {
            // Data from the server
            var data = google.visualization.arrayToDataTable([
                ['Name', 'File Count'], // Header row
                <% 
                    try {
                        // Database connection
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/faceannotation", "root", "");

                        // Query to count files grouped by 'name'
                        String sql = "SELECT name, COUNT(*) AS file_count FROM uploaded_images GROUP BY name";
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery(sql);

                        // Add rows dynamically
                        while (rs.next()) {
                            String name = rs.getString("name");
                            int fileCount = rs.getInt("file_count");
                %>
                ['<%= name %>', <%= fileCount %>],
                <% 
                        }

                        conn.close();
                    } catch (Exception e) {
                        out.println("// Error loading chart data: " + e.getMessage());
                    }
                %>
            ]);

            // Chart options
            var options = {
                title: 'Uploaded Files per Name',
                hAxis: {
                    title: 'Name',
                },
                vAxis: {
                    title: 'File Count'
                },
                chartArea: {width: '70%', height: '70%'},
                colors: ['#4CAF50']
            };

            // Draw the chart
            var chart = new google.visualization.ColumnChart(document.getElementById('chart_div'));
            chart.draw(data, options);
        }
    </script>
</head>
<body>
    <h1 style="text-align: center;">File Upload Statistics</h1>
    <div id="chart_div" style="width: 900px; height: 500px; margin: auto;"></div>
    <div class="back-link">
            <p>Back To <a href="index.html">Dashboard</a></p>
        </div>
</body>
</html>
