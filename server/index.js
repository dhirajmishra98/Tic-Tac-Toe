const express = require("express");
const http = require("http");
const mongoose = require("mongoose");

const app = express();
const port = process.env.PORT || 3000; //after deployment port is assigned dynamically by client broweser which we can get by process.env.PORT else 3000
var server = http.createServer(app);
var io = require("socket.io")(server);
const Room = require("./models/room");
app.use(express.json()); //middleware : for modifying data between server and client

//connecting Mongodb database and socket io
var DB =
  "mongodb+srv://gobindmishra22:9811266945dhiraj@tictactoecluster.hxhsoyz.mongodb.net/?retryWrites=true&w=majority"; //this key is from mongodb while connect through native drivers for cluster

io.on("connection", (socket) => {
  console.log("connected!");
  socket.on("createRoom", async ({ nickname }) => {
    console.log(nickname);
    try {
      //creating rooms
      let room = Room();
      let player = {
        nickname,
        socketID: socket.id,
        playerType: "X",
      };
      room.players.push(player);
      room.turn = player;
      room = await room.save();
      console.log(room);
      const roomId = room._id.toString();
      socket.join(roomId);
      console.log(roomId);

      //io -> send data to everyone
      //socket -> send data to yourself only
      io.to(roomId).emit("createRoomSuccess", room); //send this to message to everyone in room with roomId
    } catch (err) {
      console.log(err);
    }
  });
});

mongoose
  .connect(DB)
  .then(() => {
    console.log("connection successfull!");
  })
  .catch((e) => {
    console.log(e);
  });

server.listen(port, "0.0.0.0", () => {
  console.log(`server started and running on port ${port}`);
});

/*
Socket.IO is a JavaScript library that enables real-time, bidirectional communication between a web browser 
and a server. It provides a mechanism for establishing a persistent connection between the client and the 
server, allowing for instant data transmission and event-driven communication. 

Socket.IO can be used in various scenarios that require real-time communication, such as chat applications,
collaborative editing tools, real-time analytics, online gaming, and more. It offers a powerful and
easy-to-use API for building interactive and responsive web applications.
*/
