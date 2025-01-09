<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Face Images</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 20px;
            }
            .container {
                max-width: 600px;
                margin: auto;
                border: 1px solid #ccc;
                padding: 20px;
                border-radius: 8px;
            }
            .preview {
                margin-top: 20px;
            }
            .preview img {
                max-width: 100%;
                max-height: 300px;
            }
            .button {
                background-color: #4CAF50;
                color: white;
                padding: 10px 20px;
                border: none;
                cursor: pointer;
                border-radius: 4px;
            }
            .button:hover {
                background-color: #45a049;
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
            <h2>Image Upload</h2>
            <form id="uploadForm" action="FileUploadServlet" method="post" enctype="multipart/form-data">
                <!-- Name Input -->
                <label for="name">Enter Name:</label>
                <input type="text" id="name" name="name" placeholder="Enter name" required><br><br>

                <!-- File Input -->
                <label for="file">Choose JPG file:</label>
                <input type="file" id="file" name="file" accept=".jpg,.jpeg" required onchange="previewFile()"><br><br>

                <!-- Preview Section -->
                <div class="preview" id="previewSection" style="display: none;">
                    <strong>Selected File:</strong> <span id="fileName"></span><br>
                    <img id="imagePreview" alt="Image Preview">
                </div>
                <br>

                <!-- Submit Button -->
                <button type="submit" class="button">Submit</button>
            </form>
        </div>

        <script>
            function previewFile() {
                const fileInput = document.getElementById('file');
                const file = fileInput.files[0];
                const previewSection = document.getElementById('previewSection');
                const fileName = document.getElementById('fileName');
                const imagePreview = document.getElementById('imagePreview');

                if (file) {
                    fileName.textContent = file.name;

                    const reader = new FileReader();
                    reader.onload = function (e) {
                        imagePreview.src = e.target.result;
                        previewSection.style.display = 'block';
                    };
                    reader.readAsDataURL(file);
                }
            }
        </script>
        <div class="back-link">
            <p>Back To <a href="index.html">Dashboard</a></p>
        </div>
    </body>
</html>
