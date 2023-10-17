import 'package:hive_flutter/hive_flutter.dart';

part 'config.g.dart';

@HiveType(typeId: 2)
class Config extends HiveObject {
  Config({
    // For Onboarding. If user has completed onboarding, it will be saved here.
    this.onboardingCompleted,

    // For Notification Permission. If user has given permission, it will be saved here.
    this.checkNotification,

    // For Referance Code. If user has referance code, it will be saved here.
    // After that, the reference code can be used in the places where the reference code is requested.
    this.referanceCode,

    // For Apple Login
    this.email,
    this.name,
    this.surname,
    this.username,
  });
  @HiveField(0)
  bool? onboardingCompleted;
  @HiveField(1)
  bool? checkNotification;
  @HiveField(2)
  String? referanceCode;

  // For Apple Login
  @HiveField(3)
  String? name;
  @HiveField(4)
  String? surname;
  @HiveField(5)
  String? email;
  @HiveField(6)
  String? username;

  Config copyWith({
    bool? onboardingCompleted,
    bool? checkNotification,
    String? referanceCode,
    String? email,
    String? name,
    String? surname,
    String? username,
  }) {
    return Config(
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      checkNotification: checkNotification ?? this.checkNotification,
      referanceCode: referanceCode ?? this.referanceCode,
      email: email ?? this.email,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      username: username ?? this.username,
    );
  }
}
