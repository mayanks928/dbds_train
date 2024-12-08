<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat"%>
<%@ include file="navbar.jsp"%>
<%
String transitName = request.getParameter("transitName");
String transitId = request.getParameter("transitId");
String originId = request.getParameter("originId");
String originName = request.getParameter("originName");
String destinationName = request.getParameter("destinationName");
String destinationId = request.getParameter("destinationId");
String date = request.getParameter("date");
double fare = Double.parseDouble(request.getParameter("fare"));

String loggedInUser = (String) session.getAttribute("loggedInUser");
if (loggedInUser == null) {
    response.sendRedirect("login.jsp");
    return;
}
int customerId = (int) session.getAttribute("customerId");
%>
<div class="container my-5" style="max-width:700px;">
    <h1 class="text-center mb-4">Book Ticket for Transit: <%=transitName%></h1>
    <div class="alert alert-info">
        <p><strong>Depart from:</strong> <%=originName%></p>
        <p><strong>Arrive at:</strong> <%=destinationName%></p>
        <p><strong>Regular Ticket Fare:</strong> $<%=fare%></p>
    </div>
    <div class="card p-4 shadow-sm">
        <form id="reservationForm" method="POST" action="processReservation.jsp">
            <input type="hidden" name="transitId" value="<%=transitId%>">
            <input type="hidden" name="originId" value="<%=originId%>">
            <input type="hidden" name="destinationId" value="<%=destinationId%>">
            <input type="hidden" name="customerId" value="<%=customerId%>">
            <input type="hidden" name="totalFare" id="totalFareInput" value="0">
            <input type="hidden" name="date" value="<%=date%>">
            <input type="hidden" name="fare" value="<%=fare%>">

            <div class="mb-3">
                <label for="ticketCount" class="form-label">Number of Tickets:</label>
                <input type="number" name="ticketCount" id="ticketCount" min="1" class="form-control" required onkeydown="return event.key != 'Enter';">
            </div>
            <button type="button" class="btn btn-primary mb-3" onclick="addTicketOptions()">Select Tickets</button>
            
            <div id="ticketOptions"></div>

            <p class="fw-bold mt-3">Total Price: $<span id="totalPrice">0.00</span></p>

            <div class="mb-3">
                <label for="payment_mode" class="form-label">Payment Mode:</label>
                <select name="payment_mode" id="payment_mode" class="form-select">
                    <option value="Credit Card">Credit Card</option>
                    <option value="Debit Card">Debit Card</option>
                    <option value="Apple Pay">Apple Pay</option>
                    <option value="Paypal">Paypal</option>
                    <option value="Google Wallet">Google Wallet</option>
                </select>
            </div>
            <button type="submit" class="btn btn-success w-100">Confirm Reservation</button>
        </form>
    </div>
</div>

<script>
const fareValue = parseFloat(<%=fare%>);
function addTicketOptions() {
    const ticketOptions = document.getElementById('ticketOptions');
    const ticketCount = parseInt(document.getElementById('ticketCount').value);

    ticketOptions.innerHTML = '';
    for (let i = 1; i <= ticketCount; i++) {
        const ticketDiv = document.createElement('div');
        ticketDiv.className = 'card p-3 mb-3';
        ticketDiv.innerHTML = `
            <h5>Ticket ${i}</h5>
            <div class="mb-3">
                <label class="form-label">Ticket Type:</label>
                <select name="ticketType${i}" id="ticketType${i}" class="form-select" onchange="updateTicketPrice(${i}, true)">
                    <option value="Regular">Regular</option>
                    <option value="Child">Child (70% Discount)</option>
                    <option value="Senior">Senior (60% Discount)</option>
                </select>
            </div>
            <div class="mb-3">
                <label class="form-label">Trip Type:</label>
                <select name="tripType${i}" id="tripType${i}" class="form-select" onchange="updateTicketPrice(${i}, true)">
                    <option value="OneWay">One Way</option>
                    <option value="RoundTrip">Round Trip</option>
                </select>
            </div>
            <p>Price: $<span id="ticketPrice${i}">0.00</span></p>
        `;
        ticketOptions.appendChild(ticketDiv);
        updateTicketPrice(i, false);
    }
    updateTotalPrice();
}

function updateTicketPrice(ticketIndex, updateTotal = true) {
    const ticketType = document.getElementById('ticketType'+ticketIndex).value;
    const tripType = document.getElementById('tripType'+ticketIndex).value;
    let ticketPrice = fareValue;

    if (ticketType === 'Child') {
        ticketPrice *= 0.3; 
    } else if (ticketType === 'Senior') {
        ticketPrice *= 0.4; 
    }

    if (tripType === 'RoundTrip') {
        ticketPrice *= 2;
    }

    document.getElementById('ticketPrice'+ticketIndex).innerText = ticketPrice.toFixed(2);
    if (updateTotal) {
        updateTotalPrice();
    }
}

function updateTotalPrice() {
    const ticketCount = document.getElementById('ticketCount').value;
    let totalPrice = 0;
    for (let i = 1; i <= ticketCount; i++) {
        const ticketPrice = parseFloat(document.getElementById('ticketPrice'+i).innerText || 0);
        totalPrice += ticketPrice;
    }
    document.getElementById('totalPrice').innerText = totalPrice.toFixed(2);
    document.getElementById('totalFareInput').value = totalPrice.toFixed(2);
}

document.getElementById('reservationForm').addEventListener('submit', function(event) {
    const ticketCount = parseInt(document.getElementById('ticketCount').value);
    const totalFare = document.getElementById('totalFareInput').value;
    if (ticketCount <= 0 || totalFare <= 0) {
        alert('Please add at least one ticket before submitting.');
        event.preventDefault();
        return;
    }

    const isConfirmed = confirm('Are you sure you want to confirm the reservation?');
    if (isConfirmed) {
        let ticketsData = [];
        for (let i = 1; i <= ticketCount; i++) {
            const ticketType = document.getElementById("ticketType"+i).value;
            const tripType = document.getElementById("tripType"+i).value;
            const fare = document.getElementById("ticketPrice"+i).innerText;
            ticketsData.push({ ticketType, tripType, fare });
        }

        const ticketsDataJson = JSON.stringify(ticketsData);
        const ticketsDataInput = document.createElement('input');
        ticketsDataInput.type = 'hidden';
        ticketsDataInput.name = 'ticketsData';
        ticketsDataInput.value = ticketsDataJson;
        document.getElementById('reservationForm').appendChild(ticketsDataInput);
    } else {
        event.preventDefault();
    }
});
</script>
