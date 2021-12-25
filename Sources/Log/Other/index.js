var socket = new WebSocket("ws://127.0.0.1:8081");
socket.onmessage = function (event) {
    console.log(event.data)
}
