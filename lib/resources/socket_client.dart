// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

//singleton class
class SocketClient {
  IO.Socket? socket;
  static SocketClient? _instance;

//making internal construct such that no other isntance can get it
  SocketClient._internal() {
    // socket = IO.io('http:<own ip address>:3000', <String, dynamic>{
    //   'transports': ['websocket'],
    //   'autoConnect': false,
    // });
    socket =
        IO.io('will be hosted on render , thats link', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket!.connect();
  }

  static SocketClient get instance {
    _instance ??= SocketClient._internal(); //calling first instance created
    return _instance!;
  }
}
