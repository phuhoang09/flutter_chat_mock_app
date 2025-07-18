enum SocialPlatform { google, facebook, apple }

extension SocialPlatformExtension on SocialPlatform {
  String get value {
    switch (this) {
      case SocialPlatform.google:
        return "google";
      case SocialPlatform.facebook:
        return "facebook";
      case SocialPlatform.apple:
        return "apple";
    }
  }
}
