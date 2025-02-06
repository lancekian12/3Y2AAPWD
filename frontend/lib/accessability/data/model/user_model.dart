class UserModel {
  final String id;
  final String name;
  final String email;
  final String password;
  final UserDetails details;
  final UserSettings settings;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool hasCompletedOnboarding; // Required (no longer nullable)
  final String token; // Required (no longer nullable)

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.details,
    required this.settings,
    required this.createdAt,
    required this.updatedAt,
    this.hasCompletedOnboarding = false, // Default value false
    this.token = '', // Default empty string
  });

  // Copy constructor to create a new instance with updated properties
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    UserDetails? details,
    UserSettings? settings,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? hasCompletedOnboarding,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      details: details ?? this.details,
      settings: settings ?? this.settings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      token: token ?? this.token,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '', // Fallback to empty string if null
      name: json['name'] ?? 'Unknown', // Fallback to 'Unknown' if null
      email: json['email'] ?? '', // Fallback to empty string if null
      password: json['password'] ?? '', // Fallback to empty string if null
      details: UserDetails.fromJson(
          json['details'] ?? {}), // Fallback to empty map if null
      settings: UserSettings.fromJson(
          json['settings'] ?? {}), // Fallback to empty map if null
      createdAt: DateTime.parse(json['createdAt'] ??
          DateTime.now().toIso8601String()), // Fallback to current time if null
      updatedAt: DateTime.parse(json['updatedAt'] ??
          DateTime.now().toIso8601String()), // Fallback to current time if null
      hasCompletedOnboarding:
          json['hasCompletedOnboarding'] ?? false, // Fallback to false if null
      token: json['token'] ?? '', // Fallback to empty string if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'password': password,
      'details': details.toJson(),
      'settings': settings.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'hasCompletedOnboarding': hasCompletedOnboarding,
      'token': token,
    };
  }
}

class UserDetails {
  final String address;
  final String phoneNumber;
  final String profilePicture;

  UserDetails({
    this.address = '', // Default to empty string if null
    required this.phoneNumber,
    this.profilePicture = '', // Default to empty string if null
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      address: json['address'] ?? '', // Fallback to empty string if null
      phoneNumber:
          json['phoneNumber'] ?? '', // Fallback to empty string if null
      profilePicture:
          json['profilePicture'] ?? '', // Fallback to empty string if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
    };
  }
}

class UserSettings {
  final String verificationCode;
  final String codeExpiresAt;
  final bool verified;
  final String passwordChangedAt;
  final String passwordResetToken;
  final String passwordResetExpiresAt;
  final bool active;

  UserSettings({
    this.verificationCode = '', // Default to empty string if null
    this.codeExpiresAt = '', // Default to empty string if null
    this.verified = false, // Default to false if null
    this.passwordChangedAt = '', // Default to empty string if null
    this.passwordResetToken = '', // Default to empty string if null
    this.passwordResetExpiresAt = '', // Default to empty string if null
    this.active = true, // Default to true if null
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      verificationCode:
          json['verificationCode'] ?? '', // Fallback to empty string if null
      codeExpiresAt:
          json['codeExpiresAt'] ?? '', // Fallback to empty string if null
      verified: json['verified'] ?? false, // Fallback to false if null
      passwordChangedAt:
          json['passwordChangedAt'] ?? '', // Fallback to empty string if null
      passwordResetToken:
          json['passwordResetToken'] ?? '', // Fallback to empty string if null
      passwordResetExpiresAt: json['passwordResetExpiresAt'] ??
          '', // Fallback to empty string if null
      active: json['active'] ?? true, // Fallback to true if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'verificationCode': verificationCode,
      'codeExpiresAt': codeExpiresAt,
      'verified': verified,
      'passwordChangedAt': passwordChangedAt,
      'passwordResetToken': passwordResetToken,
      'passwordResetExpiresAt': passwordResetExpiresAt,
      'active': active,
    };
  }
}
