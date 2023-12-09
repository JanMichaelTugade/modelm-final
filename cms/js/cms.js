document.addEventListener("DOMContentLoaded", function () {
  $(document).ready(function () {
    $("#inputfile").change(function () {
      var formData = new FormData();
      formData.append("file", $("#inputfile")[0].files[0]);
      formData.append("submit", true);

      console.log(formData.get("file"));
      console.log(formData.get("submit"));

      $.ajax({
        url: "php/Model/uploadvideo.php",
        type: "POST",
        data: formData,
        processData: false,
        contentType: false,
        success: function (response) {
          console.log("Server response:", response);
          handleUploadResponse(response);
      },
      
        error: function (error) {
          console.log(error);
        },
      });
    });
  });
  fetchData(); // Move fetchData inside the DOMContentLoaded event
  getCurrentTime();
  setInterval(getCurrentTime, 1000);
  populateQueueTable();
});

function handleUploadResponse(response) {
  console.log("Server response:", response);

  if (response.includes('success')) {
    alert("File uploaded successfully!");
  } else if (response.includes('error_insert')) {
    alert("Error inserting details into the database. Check server logs for more information.");
  } else if (response.includes('error_upload')) {
    alert("Error uploading the file.");
  } else if (response.includes('invalid_extension')) {
    alert("Invalid file extension");
  } else if (response.includes('no_file')) {
    alert("Please select a file");
  } else {
    alert("Unknown error. Check server logs for more information.");
  }
}



function fetchData() {
  // Use fetch API to make an asynchronous request to the server
  fetch("php/Model/resultsBody.php")
    .then((response) => response.json())
    .then((data) => {
      console.log("Fetched data:", data);
      updateTable(data);
    })
    .catch((error) => console.error("Error:", error));
}

function secondsToMinutes(seconds) {
  const minutes = Math.floor(seconds / 60);
  const remainingSeconds = seconds % 60;
  return `${minutes}:${remainingSeconds < 10 ? '0' : ''}${remainingSeconds}`;
}

function searchTable() {
  var input, filter;
  input = document.getElementById("searchfld");
  filter = input.value.toUpperCase();

  // Fetch data and pass the filter to the updateTable function
  fetchData(filter);
}

function updateTable(data) {
  const resultsBody = document.getElementById("resultsBody");

  // Clear existing table rows
  resultsBody.innerHTML = "";

  // Loop through the fetched data and append rows to the table
  data.forEach((row) => {
    const tr = document.createElement("tr");
    tr.innerHTML = 
    `<td><button class="viewButton" style="
    font-family: Century Gothic; 
    font-weight: bold; 
    color: #fff; 
    width: 50px; 
    height: 20px; 
    background-color: white; 
    color: #1854a4;
    border-radius: 10px; 
    border:none; 
    outline: none; 
    transition: transform 0.2s;" 
    onclick="viewFunction('${row.contentID}')">View</button></td><td>${row.name}</td><td>${secondsToMinutes(row.duration)}</td><td>${row.contentID}</td>`;
    resultsBody.appendChild(tr);
  });
}

function fetchData(filter) {
  fetch("php/Model/resultsBody.php")
    .then((response) => response.json())
    .then((data) => {
      console.log("Fetched data:", data);

      if (!filter) {
        updateTable(data);
      } else {
        const filteredData = data.filter(row =>
          row.name.toUpperCase().includes(filter)
        );
        updateTable(filteredData);
      }
    })
    .catch((error) => console.error("Error:", error));
}

function viewFunction(contentID) {
  // Make an AJAX request to fetch video URL
  $.ajax({
    type: 'GET',
    url: 'php/Model/getVideoURL.php',
    data: { contentID: contentID },
    success: function(response) {
      const videoURL = response;
      openVideoModal(videoURL);
    },
    error: function(error) {
      console.error('Error fetching video URL:', error);
    }
  });
}

function openVideoModal(videoURL) {
  // Check if the video exists by making a HEAD request
  $.ajax({
    type: 'HEAD',
    url: videoURL,
    success: function () {
      createVideoModal(videoURL);
    },
    error: function () {
      alert('Sorry, the selected video is not available.');
    }
  });
}

function createVideoModal(videoURL) {
  const modalHTML = `
    <div class="modal" id="videoModal" tabindex="-1" role="dialog">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Video Viewer</h5>
          </div>
          <div class="modal-body" style="display: flex; flex-direction: column; align-items: center; position: relative;">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="position: static; padding:10px; 
              background-color: red; border-radius:10px; color:white; z-index: 2;">
              <span aria-hidden="true">&times;</span>
            </button>
            <video style="max-width: 100%; max-height: 100%;" controls>
              <source src="${videoURL}" type="video/mp4">
              <!-- Your browser does not support the video tag. -->
            </video>
            
          </div>
        </div>
      </div>
    </div>
  `;

  $('body').append(modalHTML);

  // Attach click event to the close button
  $('.close').on('click', function () {
    $('#videoModal').remove();
  });
}

var timeslot = document.getElementById("addTimeslot");
var addslot = document.getElementById("addslotbtn");
var closeaddslot = document.getElementById("save-addslotbtn");
var backbutton = document.getElementById("backbtn");

function getCurrentTime() {
  var now = new Date();
  var hours = now.getHours();
  var minutes = now.getMinutes();
  var seconds = now.getSeconds();
  var ampm = hours >= 12 ? 'pm' : 'am';
  hours = hours % 12;
  hours = hours ? hours : 12; // Convert 0 to 12
  minutes = minutes < 10 ? '0' + minutes : minutes;
  seconds = seconds < 10 ? '0' + seconds : seconds;
  var timeString = hours + ':' + minutes + ':' + seconds + ' ' + ampm;
  document.getElementById('time').innerHTML = timeString;
}

document.addEventListener('DOMContentLoaded', function () {
  var videoPlayer = document.getElementById("videoPlayer");
  var startLiveBtn = document.getElementById("startLivebtn");
  var endLiveBtn = document.getElementById("endLivebtn");

  var liveStreamContentID = 8; // Variable to store content ID associated with the live stream
  var liveStreamStartTime = null; // Variable to store the start time of the live stream

  console.log('Event listeners attached successfully.');

  startLiveBtn.addEventListener('click', function () {
    console.log('Start Live button clicked.');
    // Record the start time of the live stream
    liveStreamStartTime = new Date().getTime();

    // Request access to camera and microphone
    window.navigator.mediaDevices.getUserMedia({ video: true, audio: true })
      .then(stream => {
        videoPlayer.srcObject = stream;
        videoPlayer.play();
      })
      .catch(error => {
        console.error('Error accessing media devices:', error);
        alert('There was an error accessing the camera or microphone. Please check permissions and try again.');
      });
  });

  endLiveBtn.addEventListener('click', function () {
    videoPlayer.pause();
    console.log('End Live button clicked.');
    
    // Stop the video stream
    var stream = videoPlayer.srcObject;
    var tracks = stream.getTracks();

    tracks.forEach(track => track.stop());

    videoPlayer.srcObject = null;

    // Calculate the duration of the live stream
    var liveStreamDuration = null;
    if (liveStreamStartTime !== null) {
      liveStreamDuration = Math.floor((new Date().getTime() - liveStreamStartTime) / 1000); // Duration in seconds
    }

    // Assuming you have a function to update the database with live stream duration
    updateDatabaseWithLiveStreamDuration(liveStreamContentID, liveStreamDuration);
  });

  // Function to update the database with live stream duration
  function updateDatabaseWithLiveStreamDuration(contentID, duration) {
    const xhr = new XMLHttpRequest();
    xhr.open('POST', 'php/Model/save_live_duration.php');
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.onload = function () {
        if (xhr.status === 200) {
            console.log(xhr.responseText);
        }
    };
    xhr.send('contentID=' + encodeURIComponent(contentID) + '&duration=' + encodeURIComponent(duration));
    populateQueueTable();
    videoPlayer.currentTime = currentTimeStamp;
    videoPlayer.play();
  }
});

