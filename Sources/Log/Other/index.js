var socket = null
var setingJSON = {
    "excludes": [],
    "colors": {
        "Debug": "#0000FF",
        "Info": "#000000",
        "Warning": "#FFFF00",
        "Error": "#ff0000",
        "Net": "#00FF00"
    }
}
var excludes = {}

var connectButton = document.getElementById("connectButton")
var messageTextView = document.getElementById("messageTextView")
var setingAlert = document.getElementById("setingAlert")
var setingTextView = document.getElementById("setingTextView")

document.getElementById("setingButton").onclick = function () {
    setingTextView.value = JSON.stringify(setingJSON, null, 4)
    setingAlert.style.display = "block"
}
document.getElementById("setingCloseButton").onclick = function () {
    setingJSON = JSON.parse(setingTextView.value)
    excludes = {}
    setingJSON.excludes.forEach(function (element) {
        excludes[element] = true
    });
    setingAlert.style.display = "none"
}
document.getElementById("clearButton").onclick = function () {
    messageTextView.innerHTML = ""
}

connectButton.onclick = function () {
    if (connectButton.classList.contains("buttonSelected")) {
        deconnect()
    } else {
        connectButton.disabled = true
        connectButton.innerText = "连接中..."
        connect(document.getElementById("portField").value)
    }
}

function connect(port) {
    deconnect()
    socket = new WebSocket("ws://" + window.location.hostname + ":" + port)
    socket.onopen = function () {
        connectButton.innerText = "断开"
        connectButton.disabled = false
        connectButton.classList.add("buttonSelected")
    }
    socket.onmessage = function (event) {
        addLog(event.data)
    }
    socket.onerror = function () {
        deconnect()
        alert("连接失败")
    }
    socket.onclose = function () {
        deconnect()
    }
}

function deconnect() {
    if (socket == null) { return }
    socket.close()
    socket = null

    connectButton.innerText = "连接"
    connectButton.disabled = false
    connectButton.classList.remove("buttonSelected")
}

function addLog(log) {
    var type = log.substring(25, log.indexOf("]", 25))
    if (excludes[type] == true) { return }
    
    var isBottom = messageTextView.scrollHeight - messageTextView.clientHeight < messageTextView.scrollTop + 1.0

    var logLabel = document.createElement("div")
    logLabel.className = "logLabel"
    logLabel.innerText = log
    logLabel.style.color = setingJSON.colors[type]
    messageTextView.appendChild(logLabel)

    if (isBottom) {
        messageTextView.scrollTop = messageTextView.scrollHeight - messageTextView.clientHeight
    }
}
