enum OtpType { register, change }

extension OtpTypeExtension on OtpType {
  String get value {
    switch (this) {
      case OtpType.register:
        return 'REGISTER';
      case OtpType.change:
        return 'CHANGE';
    }
  }
}
