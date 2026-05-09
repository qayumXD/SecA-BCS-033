class Submission {
  const Submission({
    this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.gender,
    this.createdAt,
  });

  final int? id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String address;
  final String gender;
  final DateTime? createdAt;

  factory Submission.fromJson(Map<String, dynamic> json) {
    return Submission(
      id: json['id'] as int?,
      fullName: json['full_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phone_number'] as String? ?? '',
      address: json['address'] as String? ?? '',
      gender: json['gender'] as String? ?? 'Other',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.tryParse(json['created_at'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'email': email,
      'phone_number': phoneNumber,
      'address': address,
      'gender': gender,
    };
  }

  Submission copyWith({
    int? id,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? address,
    String? gender,
    DateTime? createdAt,
  }) {
    return Submission(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
