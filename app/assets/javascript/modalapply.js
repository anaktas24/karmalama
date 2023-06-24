document.addEventListener('DOMContentLoaded', function() {
  var applyButton = document.getElementById('applyButton');
  applyButton.addEventListener('click', function() {
    $('#applyModal').modal('show');
  });

  var confirmButton = document.getElementById('confirmButton');
  confirmButton.addEventListener('click', function() {
    var userId = '<%= current_user.id %>'; // Replace with your actual code to get the user ID

    // Retrieve the listing ID or any other necessary data from the form
    var listingId = document.getElementById('listingId').value;

    // Create the URL for the user-specific booking path
    var bookingPath = '/users/' + userId + '/my_bookings';

    // Send the AJAX request to the user-specific booking path
    fetch(bookingPath, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        listing_id: listingId, // Include the listing ID or any other necessary data in the body
      }),
    })
      .then(function(response) {
        // Handle the response from the server
        // For example, display a success message or redirect to another page
      })
      .catch(function(error) {
        // Handle any error that occurred during the request
        console.error('Error:', error);
      });
  });
});
