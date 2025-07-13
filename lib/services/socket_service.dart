// import 'dart:io';

// WebSocket? _socket;

// void connectWebSocket() async {
//   try {
//     _socket = await WebSocket.connect('ws://<your-ip>:3001');

//     print('✅ Connected to backend');

//     _socket!.listen(
//       (data) => print('📩 Message from server: $data'),
//       onDone: () => print('❌ Connection closed'),
//       onError: (e) => print('❗ Error: $e'),
//     );

//     // Gửi test
//     _socket!.add('Hello from Flutter!');
//   } catch (e) {
//     print('❌ WebSocket error: $e');
//   }
// }
