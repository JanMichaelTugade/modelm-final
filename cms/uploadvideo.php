<?php
require "dbcon.php";
session_start();

ini_set('display_errors', 1);

if (isset($_FILES['file']) && isset($_POST['submit'])) {
    $name = $_FILES['file']['name'];
    $target_dir = "videos/";
    $target_file = $target_dir . $name;

    $extension = strtolower(pathinfo($target_file, PATHINFO_EXTENSION));
    $extensions_arr = array("mp3", "mp4");

    if (in_array($extension, $extensions_arr)) {
        if (move_uploaded_file($_FILES['file']['tmp_name'], $target_file)) {
            // Get duration using custom function
            $duration_seconds = getVideoDuration($target_file, $extension);

            $contentID = '';
            $name = mysqli_real_escape_string($conn, $name);
            $fileType = $extension;
            $path = $target_file;

            $sql = "INSERT INTO content (contentID, name, fileType, path, duration) VALUES ('$contentID', '$name', '$fileType', '$path', '$duration_seconds')";

            echo "Debug: Duration in seconds: $duration_seconds<br>"; // Debug line

            if (mysqli_query($conn, $sql)) {
                $_SESSION['message'] = "File uploaded successfully and details inserted into the database.";
                echo "success";
            } else {
                $_SESSION['message'] = "Error inserting details into the database: " . mysqli_error($conn);
                echo "error";
            }
        }
    }
}

function getVideoDuration($file_path, $file_extension) {
    if ($file_extension == "mp4") {
        // Get duration for MP4 files (assumes the file is in MP4 format)
        $duration_seconds = shell_exec("mediainfo --Inform=\"Video;%Duration%\" $file_path");
        echo "Debug: Raw duration from mediainfo: $duration_seconds<br>"; // Debug line
        return round(floatval($duration_seconds) / 1000); // Convert milliseconds to seconds
    } elseif ($file_extension == "mp3") {
        // Get duration for MP3 files (replace this with your MP3 duration retrieval logic)
        return 0; // Placeholder, replace with actual MP3 duration retrieval
    } else {
        return 0; // Unknown format, set to default
    }
}
?>
