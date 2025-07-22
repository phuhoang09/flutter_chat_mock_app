enum OtpType { register, registerGoogle, forgotPassword }

extension OtpTypeExtension on OtpType {
  String get value {
    switch (this) {
      case OtpType.register:
        return 'REGISTER';
      case OtpType.registerGoogle:
        return 'REGISTER_GOOGLE';
      case OtpType.forgotPassword:
        return 'FORGOT_PASSWORD';
    }
  }
}
