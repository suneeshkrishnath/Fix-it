class ResidentProfile {
  const ResidentProfile({
    required this.tenantName,
    required this.phoneNumber,
    required this.email,
    required this.emiratesId,
    required this.apartmentNumber,
    required this.towerNumber,
    required this.floor,
    required this.address,
    required this.tenancyStart,
    required this.tenancyEnd,
    required this.annualRent,
    required this.paymentFrequency,
    required this.securityDeposit,
    required this.contractNumber,
    required this.landlord,
    required this.contractIssuedOn,
    required this.contractExpiresOn,
  });

  final String tenantName;
  final String phoneNumber;
  final String email;
  final String emiratesId;
  final String apartmentNumber;
  final String towerNumber;
  final String floor;
  final String address;
  final DateTime tenancyStart;
  final DateTime tenancyEnd;
  final String annualRent;
  final String paymentFrequency;
  final String securityDeposit;
  final String contractNumber;
  final String landlord;
  final DateTime contractIssuedOn;
  final DateTime contractExpiresOn;
}
