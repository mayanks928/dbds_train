<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat"%>
<%@ include file="navbar.jsp"%>
<%
// Retrieve the data passed from the previous page

String transitName = request.getParameter("transitName");
String transitId = request.getParameter("transitId");
String originId = request.getParameter("originId");
String originName = request.getParameter("originName");
String destinationName = request.getParameter("destinationName");
String destinationId = request.getParameter("destinationId");
String date = request.getParameter("date");
double fare = Double.parseDouble(request.getParameter("fare"));

// Ensure the user is logged in
if (loggedInUser == null) {
	response.sendRedirect("login.jsp");
	return;
}
int customerId = (int) session.getAttribute("customerId");
%>
<!DOCTYPE html>
<html>
<head>
<title>Book Train</title>
<style>
body {
	font-family: Arial, sans-serif;
	background-color: #f4f4f4;
	color: #333;
	margin: 0;
	padding: 0;
}

h1 {
	color: #007BFF;
	text-align: center;
	margin-top: 30px;
}

p {
	font-size: 1.2em;
	margin-left: 20px;
}

form {
	background-color: white;
	padding: 20px;
	margin: 20px;
	border-radius: 8px;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

label {
	font-size: 1.1em;
	margin-right: 10px;
}

input[type="number"], select {
	padding: 8px;
	margin-top: 10px;
	width: 200px;
	font-size: 1em;
	border: 1px solid #ddd;
	border-radius: 4px;
}

button {
	background-color: #007BFF;
	color: white;
	padding: 10px 20px;
	border: none;
	border-radius: 4px;
	font-size: 1em;
	cursor: pointer;
	margin-top: 20px;
}

button:hover {
	background-color: #0056b3;
}

.total-price {
	font-size: 1.2em;
	font-weight: bold;
	margin-top: 10px;
}

.ticket-details {
	background-color: #f9f9f9;
	padding: 15px;
	margin-top: 15px;
	border-radius: 8px;
	border: 1px solid #ddd;
}

.ticket-details h3 {
	color: #007BFF;
}

.ticket-details label {
	font-size: 1.1em;
}

.ticket-details select {
	width: 100%;
}

#ticketOptions {
	margin-top: 20px;
}
</style>
</head>
<body>

	<h1>
		Book Ticket for Transit:
		<%=transitName%></h1>
	<p>
		Depart from:
		<%=originName%></p>
	<p>
		Arrive at:
		<%=destinationName%></p>
	<p>
		Regular Ticket Fare: $<%=fare%></p>
	<form id='reservationForm' method="POST" action="processReservation.jsp"
		>
		<input type="hidden" name="transitId" value="<%=transitId%>">
		<input type="hidden" name="originId" value="<%=originId%>"> <input
			type="hidden" name="destinationId" value="<%=destinationId%>">
		<input type="hidden" name="customerId" value="<%=customerId%>">
		<input type="hidden" name="totalFare" id="totalFareInput"> <input
			type="hidden" name="date" value="<%=date%>"> <input
			type="hidden" name="fare" value="<%=fare%>"> <label>Number
			of Tickets:</label> <input type="number" name="ticketCount" id="ticketCount"
			min="1" onkeydown="return event.key != 'Enter';" required><br>
		<br>
		<button type="button" onclick="addTicketOptions()">Select
			Tickets</button>
		<!-- Dynamic ticket options -->
		<div id="ticketOptions"></div>

		<br> <br>
		<p class="total-price">
			Total Price: $<span id="totalPrice">0.00</span>
		</p>
		<label>Payment Mode:</label> <select name="payment_mode"
			id="payment_mode">
			<option value="Credit Card">Credit Card</option>
			<option value="Debit Card">Debit Card</option>
			<option value="Apple Pay">Apple Pay</option>
			<option value="Paypal">Paypal</option>
			<option value="Google Wallet">Google Wallet</option>
		</select><br> <br>
		<button type="submit">Confirm
			Reservation</button>
	</form>

	<script>
        const fare = parseFloat(<%=fare%>);

        function addTicketOptions() {
            const ticketOptions = document.getElementById('ticketOptions');
            const ticketCount = parseInt(document.getElementById('ticketCount').value);

            // Clear existing ticket options
            ticketOptions.innerHTML = '';
			
            
            // Generate form fields for each ticket
            for (let i = 1; i <= ticketCount; i++) {
                const ticketDiv = document.createElement('div');
                ticketDiv.className = 'ticket-details';
                ticketDiv.innerHTML = '<h3>Ticket ' + i + '</h3>' +
                    '<label>Ticket Type:</label>' +
                    '<select name="ticketType' + i + '" id="ticketType' + i + '" onchange="updateTicketPrice(' + i + ', true)">' +
                    '<option value="Regular">Regular</option>' +
                    '<option value="Child">Child (70% Discount)</option>' +
                    '<option value="Senior">Senior (60% Discount)</option>' +
                    '</select><br><br>' +
                    '<label>Trip Type:</label>' +
                    '<select name="tripType' + i + '" id="tripType' + i + '" onchange="updateTicketPrice(' + i + ', true)">' +
                    '<option value="OneWay">One Way</option>' +
                    '<option value="RoundTrip">Round Trip</option>' +
                    '</select><br><br>' +
                    '<p>Price: $<span id="ticketPrice' + i + '">0.00</span></p>';

                ticketOptions.appendChild(ticketDiv);
                // Initialize ticket price for this ticket
                updateTicketPrice(i, false);
            }
			
            // Update the total price for all tickets
            updateTotalPrice();
        }

        function updateTicketPrice(ticketIndex, updateTotal = true) {
            // Get ticket type and trip type for the current ticket
            const ticketType = document.getElementById('ticketType' + ticketIndex).value;
            const tripType = document.getElementById('tripType' + ticketIndex).value;

            let ticketPrice = fare;

            // Apply discounts based on ticket type
            if (ticketType === 'Child') {
                ticketPrice *= 0.3; // 70% discount
            } else if (ticketType === 'Senior') {
                ticketPrice *= 0.4; // 60% discount
            }

            // Double the price for round trips
            if (tripType === 'RoundTrip') {
                ticketPrice *= 2;
            }

            // Update the individual ticket price
            document.getElementById('ticketPrice' + ticketIndex).innerText = ticketPrice.toFixed(2);
            if (updateTotal) {
                // Update the total price for all tickets
                updateTotalPrice();
            }
        }

        function updateTotalPrice() {
            const ticketCount = document.getElementById('ticketCount').value;
            let totalPrice = 0;

            for (let i = 1; i <= ticketCount; i++) {
                const ticketPrice = parseFloat(document.getElementById('ticketPrice' + i).innerText || 0);
                totalPrice += ticketPrice;
            }

            // Update the total price on the form
            document.getElementById('totalPrice').innerText = totalPrice.toFixed(2);
            document.getElementById('totalFareInput').value = totalPrice.toFixed(2);
        }
     // Function to handle form submission
        function handleSubmit(event) {
            // Validate if tickets have been added
            const ticketCount = parseInt(document.getElementById('ticketCount').value);
            if (ticketCount <= 0) {
                alert('Please add at least one ticket before submitting.');
                event.preventDefault(); // Prevent form submission
                return; // Exit the function
            }

            // Ask user for confirmation
/*             const isConfirmed = confirm('Are you sure you want to confirm the reservation?'); */
				const isConfirmed=true;

            if (isConfirmed) {
                // Loop through all ticket options and gather the ticket data
                let ticketsData = [];  // Array to hold ticket data for the current submission

                for (let i = 1; i <= ticketCount; i++) {
                    const ticketType = document.getElementById("ticketType"+i).value;
                    const tripType = document.getElementById("tripType"+i).value;
                    const fare = document.getElementById("ticketPrice"+i).innerText;

                    ticketsData.push({
                        ticketType: ticketType,
                        tripType: tripType,
                        fare: fare
                    });
                }
				console.log(ticketsData)
                // Serialize the ticketsData array into JSON
                const ticketsDataJson = JSON.stringify(ticketsData);

                // Create a hidden input element to store the serialized data
                const ticketsDataInput = document.createElement('input');
                ticketsDataInput.type = 'hidden';
                ticketsDataInput.name = 'ticketsData';
                ticketsDataInput.value = ticketsDataJson;

                // Append the hidden input to the form
                document.getElementById('reservationForm').appendChild(ticketsDataInput);
                event.preventDefault();
                return false;
                // Submit the form
                /* document.getElementById('reservationForm').submit(); */
            } else {
                // Prevent form submission if not confirmed
                event.preventDefault();
            }
        }

        // Attach the submit handler to the form
        document.getElementById('reservationForm').addEventListener('submit', handleSubmit);


    </script>

</body>
</html>
