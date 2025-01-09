/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package MWL;

import java.io.*;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

/**
 *
 * @author LuckyCharm
 */
public class FileSearchServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    // Database connection URL
    private static final String DB_URL = "jdbc:mysql://localhost:3306/faceannotation";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");  // Explicitly load the driver
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            response.getWriter().println("Error: JDBC Driver not found.");
            return;
        }

        String filename = request.getParameter("filename");
        if (filename == null || filename.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().println("Error: Filename is missing.");
            return;
        }

        try (Connection connection = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String sql = "SELECT filename, file_path FROM uploaded_images WHERE filename = ?";
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                statement.setString(1, filename);
                try (ResultSet resultSet = statement.executeQuery()) {
                    if (resultSet.next()) {
                        Blob blob = resultSet.getBlob("file_path");
                        byte[] imageBytes = blob.getBytes(1, (int) blob.length());

                        // Set the correct content type for image/jpeg (assuming it's JPEG)
                        response.setContentType("image/jpeg");
                        response.setContentLength(imageBytes.length);

                        // Write the image bytes directly to the output stream
                        try (OutputStream out = response.getOutputStream()) {
                            out.write(imageBytes);
                        }
                    } else {
                        // If no file is found, set a 404 status and message
                        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                        response.getWriter().println("No file found with the name: " + filename);
                    }
                }
            }
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().println("Database Error: " + e.getMessage());
        }
    }


    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
