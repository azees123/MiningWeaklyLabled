/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package MWL;

import java.io.*;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;

/**
 *
 * @author LuckyCharm
 */
@MultipartConfig
public class FileUploadServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private static final String UPLOAD_DIR = "uploads";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Load MySQL JDBC Driver
        // Load MySQL JDBC Driver
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            response.getWriter().println("Error: JDBC Driver not found.");
            return;
        }

        // Get form data
        String name = request.getParameter("name");
        Part filePart = request.getPart("file"); // Get the file part from the request
        String fileName = extractFileName(filePart);

        // Read file into a byte array (for BLOB storage)
        InputStream fileContent = filePart.getInputStream();
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        byte[] buffer = new byte[1024];
        int bytesRead;

        // Read file content into byte array
        while ((bytesRead = fileContent.read(buffer)) != -1) {
            byteArrayOutputStream.write(buffer, 0, bytesRead);
        }

        byte[] fileBytes = byteArrayOutputStream.toByteArray();

        if (name != null && fileBytes.length > 0) {
            // Database connection and insert
            try (Connection connection = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/faceannotation?useSSL=false&serverTimezone=UTC", "root", "")) {

                String sql = "INSERT INTO uploaded_images (filename, file_path, name) VALUES (?, ?, ?)";
                try (PreparedStatement statement = connection.prepareStatement(sql)) {
                    statement.setString(1, fileName);
                    statement.setBytes(2, fileBytes);  // Store the file content as a BLOB
                    statement.setString(3, name);
                    statement.executeUpdate();
                }

            } catch (SQLException e) {
                e.printStackTrace();
                response.getWriter().println("Database Error: " + e.getMessage());
                return;
            }

            // Success response
            response.getWriter().println("File uploaded successfully! Name: " + name + ", File: " + fileName);

// Redirect to index.html
            response.setHeader("Refresh", "2; URL=index.html");
        } else {
            response.getWriter().println("File upload failed!");
        }
    }

    // Extract file name from the Part object
    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        for (String content : contentDisp.split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf("=") + 2, content.length() - 1);
            }
        }
        return null;
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
