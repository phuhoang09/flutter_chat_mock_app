import 'package:flutter/material.dart';
import 'package:flutter_chat_mock_app/utils/register_screen_handlers.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String password;

  const OtpScreen({
    super.key,
    required this.phoneNumber,
    required this.password,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  bool isLoading = false;

  // void _verifyOtp() async {
  //   setState(() => isLoading = true);
  //   final isValid = await ApiService.verifyOtp(
  //     widget.phoneNumber,
  //     _otpController.text,
  //   );

  //   if (isValid) {
  //     await AuthService.registerAndNavigate(
  //       context,
  //       widget.phoneNumber,
  //       widget.password,
  //       _otpController.text,
  //     );
  //   } else {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text("OTP không đúng")));
  //   }

  //   setState(() => isLoading = false);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Xác nhận OTP")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _otpController,
              decoration: InputDecoration(labelText: "Nhập mã OTP"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      await RegisterScreenHandlers.handleRegisterPhone(
                        context,
                        widget.phoneNumber,
                        widget.password,
                        _otpController.text,
                      );
                    },
                    child: Text("Xác nhận"),
                  ),
          ],
        ),
      ),
    );
  }
}
