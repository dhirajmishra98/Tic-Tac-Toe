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
      const roomId = room._id.toString();
      socket.join(roomId);

      //io -> send data to everyone
      //socket -> send data to yourself only
      io.to(roomId).emit("createRoomSuccess", room); //send this to message to everyone in room with roomId so used io here
    } catch (err) {
      console.log(err);
    }
  });

  socket.on("joinRoom", async ({ nickname, roomId }) => {
    try {
      // Regex for MongoDB ID Validation :  /^[0-9a-fA-F]{24}$/ => can be found on internet
      if (!roomId.match(/^[0-9a-fA-F]{24}$/)) {
        //checking if roomid didn't match with regex from mongodb we have to return from here
        socket.emit("errorOccurred", "Please enter valid room ID");
        return;
      }
      let room = await Room.findById(roomId); //goto room collection in database and find room with given room id
      if (room.isJoin) {
        let player = {
          nickname,
          socketID: socket.id,
          playerType: "O",
        };
        socket.join(roomId);
        room.players.push(player);
        room.isJoin = false;
        room = await room.save();
        io.to(roomId).emit("joinRoomSuccess", room); //notify listener in socketmethods and to everyone
        io.to(roomId).emit("updatePlayers", room.players); //update players properties
        io.to(roomId).emit("updateRoom", room);
      } else {
        socket.emit(
          "errorOccurred",
          "The game is in progress, Please try again later!"
        );
      }
    } catch (err) {
      console.log(err);
    }
  });

  socket.on("tap", async ({ index, roomId }) => {
    try {
      let room = await Room.findById(roomId);
      let choice = room.turn.playerType; //X or O
      if (room.turnIndex == 0) {
        room.turn = room.players[1];
        room.turnIndex = 1;
      } else {
        room.turn = room.players[0];
        room.turnIndex = 0;
      }
      room = await room.save();
      io.to(roomId).emit("tapped", {
        index,
        choice,
        room,
      });
    } catch (err) {
      console.log(err);
    }
  });

  socket.on("winner", async ({ winnerSocketId, roomId }) => {
    try {
      if (socket.id != winnerSocketId) {
        return;
      }
      let room = await Room.findById(roomId);
      let player = room.players.find(
        (playerr) => playerr.socketID == winnerSocketId
      );
      player.points += 1;
      room = await room.save();

      if (player.points >= room.maxRounds) {
        io.to(roomId).emit("endGame", player);
      } else {
        io.to(roomId).emit("pointIncrease", player);
      }
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
