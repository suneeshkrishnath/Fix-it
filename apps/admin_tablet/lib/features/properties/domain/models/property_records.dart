enum PropertyRecordStatus { active, inactive }

enum BuildingKind { block, tower, building }

class CampusRecord {
  const CampusRecord({
    required this.id,
    required this.name,
    required this.city,
    this.status = PropertyRecordStatus.active,
  });

  final String id;
  final String name;
  final String city;
  final PropertyRecordStatus status;

  CampusRecord copyWith({
    String? name,
    String? city,
    PropertyRecordStatus? status,
  }) => CampusRecord(
    id: id,
    name: name ?? this.name,
    city: city ?? this.city,
    status: status ?? this.status,
  );
}

class BuildingRecord {
  const BuildingRecord({
    required this.id,
    required this.campusId,
    required this.name,
    required this.kind,
    required this.address,
    this.status = PropertyRecordStatus.active,
  });

  final String id;
  final String campusId;
  final String name;
  final BuildingKind kind;
  final String address;
  final PropertyRecordStatus status;

  BuildingRecord copyWith({
    String? campusId,
    String? name,
    BuildingKind? kind,
    String? address,
    PropertyRecordStatus? status,
  }) => BuildingRecord(
    id: id,
    campusId: campusId ?? this.campusId,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    address: address ?? this.address,
    status: status ?? this.status,
  );
}

class ApartmentRecord {
  const ApartmentRecord({
    required this.id,
    required this.buildingId,
    required this.unitNumber,
    required this.floor,
    this.status = PropertyRecordStatus.active,
  });

  final String id;
  final String buildingId;
  final String unitNumber;
  final String floor;
  final PropertyRecordStatus status;

  ApartmentRecord copyWith({
    String? buildingId,
    String? unitNumber,
    String? floor,
    PropertyRecordStatus? status,
  }) => ApartmentRecord(
    id: id,
    buildingId: buildingId ?? this.buildingId,
    unitNumber: unitNumber ?? this.unitNumber,
    floor: floor ?? this.floor,
    status: status ?? this.status,
  );
}
