function sendMessage(input) {
  event.preventDefault(); // prevent form submission (i.e. prevent refreshing page)

  msg = input[0].value;
  input[0].value = "";
  // msg = "This is a Test Message"
  // TODO: msg, username, timestamp
  var div = document.createElement("div");
  div.setAttribute("class","container darker");

  var icon = document.createElement("img");
  icon.setAttribute("class","right");
  icon.setAttribute("src","../user_icons/casit.png");
  icon.setAttribute("alt","Avatar");

  // todo make it an image
  var p = document.createElement("p")
  p.appendChild(document.createTextNode(msg))

  var username = document.createElement("span")
  username.appendChild(document.createTextNode("USERNAME"))
  username.setAttribute("class","username");

  var timestamp = document.createElement("span");
  timestamp.appendChild(document.createTextNode(new Date().toLocaleTimeString()))
  timestamp.setAttribute("class","timestamp");

  div.appendChild(icon)
  div.appendChild(p)
  div.appendChild(username)
  div.appendChild(timestamp)

  // Appends New Message to Chat Interface
  chatlog = document.getElementsByClassName("chatlog")[0];
  chatlog.appendChild(div)
}
