class Technician {
  const Technician({
    required this.name,
    required this.specialty,
    required this.phoneNumber,
  });

  final String name;
  final String specialty;
  final String phoneNumber;
}

class ClosedCase {
  const ClosedCase({
    required this.id,
    required this.requestNumber,
    required this.category,
    required this.subcategory,
    required this.raisedOn,
    required this.approvedBy,
    required this.technician,
    required this.appointmentAt,
    required this.fixedOn,
    required this.closingComments,
  });

  final String id;
  final String requestNumber;
  final String category;
  final String subcategory;
  final DateTime raisedOn;
  final String approvedBy;
  final Technician technician;
  final DateTime appointmentAt;
  final DateTime fixedOn;
  final String closingComments;
}
