<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Content-Based Annotation</title>
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
            <h2>Content-Based Annotation</h2>

            <!-- Image File Selection -->
            <label for="file">Choose JPG file:</label>
            <input type="file" id="file" name="file" accept=".jpg,.jpeg" onchange="previewFile()"><br><br>

            <!-- Preview Section -->
            <div class="preview" id="previewSection" style="display: none;">
                <strong>Selected File:</strong> <span id="fileName"></span><br>
                <img id="imagePreview" alt="Image Preview">
            </div>

            <!-- Search Button -->
            <br><br>
            <button class="button" onclick="searchFile()">Search</button>

            <!-- Search Result -->
            <div id="result"></div>

        </div>

        <script>
            // Preview selected image
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

            // Search for the file in the database
            function searchFile() {
                const fileInput = document.getElementById('file');
                const file = fileInput.files[0];

                if (!file) {
                    alert("Please select a file first.");
                    return;
                }

                const fileName = file.name;

                // Send AJAX request to the servlet
                const xhr = new XMLHttpRequest();
                xhr.open('GET', 'FileSearchServlet?filename=' + fileName, true);
                xhr.responseType = 'blob';  // Set the response type to 'blob' to handle binary data
                xhr.onload = function () {
                    if (xhr.status === 200) {
                        const imageBlob = xhr.response;
                        const imageUrl = URL.createObjectURL(imageBlob);
                        const resultContainer = document.getElementById('result');
                        resultContainer.innerHTML = '';  // Clear previous result
                        const img = document.createElement('img');
                        img.src = imageUrl;
                        img.alt = "Image from Database";
                        img.style.maxWidth = '100%';  // Ensure the image fits within the container
                        resultContainer.appendChild(img);
                    } else {
                        document.getElementById('result').innerHTML = "File Not Found " + xhr.statusText;
                    }
                };
                xhr.send();
            }
        </script>
        <div class="back-link">
            <p>Back To <a href="index.html">Dashboard</a></p>
        </div>
    </body>
</html>
