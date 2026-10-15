class UserProfile {
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final int householdSize;
  final String language; // 'English', 'Kannada'
  final String referralCode;
  final int referralEarnings;
  final bool isGuest;

  const UserProfile({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.email = '',
    this.householdSize = 3,
    this.language = 'English',
    this.referralCode = 'HEERA2026',
    this.referralEarnings = 0,
    this.isGuest = false,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? email,
    int? householdSize,
    String? language,
    String? referralCode,
    int? referralEarnings,
    bool? isGuest,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      householdSize: householdSize ?? this.householdSize,
      language: language ?? this.language,
      referralCode: referralCode ?? this.referralCode,
      referralEarnings: referralEarnings ?? this.referralEarnings,
      isGuest: isGuest ?? this.isGuest,
    );
  }
}
