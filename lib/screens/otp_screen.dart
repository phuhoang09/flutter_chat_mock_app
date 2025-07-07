import 'package:flutter/material.dart';
import '../services/api_service.dart'; // dùng để gửi OTP xác minh
import '../services/auth_service.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String password;

  const OtpScreen({Key? key, required this.phoneNumber, required this.password})
    : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  bool isLoading = false;

  void _verifyOtp() async {
    setState(() => isLoading = true);
    final isValid = await ApiService.verifyOtp(
      widget.phoneNumber,
      _otpController.text,
    );

    if (isValid) {
      await AuthService.registerAndNavigate(
        context,
        widget.phoneNumber,
        widget.password,
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("OTP không đúng")));
    }

    setState(() => isLoading = false);
  }

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
                    onPressed: _verifyOtp,
                    child: Text("Xác nhận"),
                  ),
          ],
        ),
      ),
    );
  }
}
