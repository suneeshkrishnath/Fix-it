class Resident {
  const Resident({
    required this.name,
    required this.phoneNumber,
    required this.apartmentNumber,
  });

  final String name;
  final String phoneNumber;
  final String apartmentNumber;

  Map<String, Object> toMap() => {
        'name': name,
        'phoneNumber': phoneNumber,
        'apartmentNumber': apartmentNumber,
      };

  factory Resident.fromMap(Map<dynamic, dynamic> map) => Resident(
        name: map['name'] as String,
        phoneNumber: map['phoneNumber'] as String,
        apartmentNumber: map['apartmentNumber'] as String,
      );
}