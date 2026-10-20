import 'package:flutter/foundation.dart';

import '../../domain/models/property_records.dart';
import '../../domain/repositories/property_repository.dart';

class MockPropertyRepository extends ChangeNotifier
    implements PropertyRepository {
  final List<CampusRecord> _campuses = [
    const CampusRecord(
      id: 'campus-marina',
      name: 'Marina Campus',
      city: 'Dubai',
    ),
    const CampusRecord(id: 'campus-creek', name: 'Creek Campus', city: 'Dubai'),
  ];

  final List<BuildingRecord> _buildings = [
    const BuildingRecord(
      id: 'building-tower-1',
      campusId: 'campus-marina',
      name: 'Tower 1',
      kind: BuildingKind.tower,
      address: 'Marina Promenade, Dubai Marina',
    ),
    const BuildingRecord(
      id: 'building-block-a',
      campusId: 'campus-marina',
      name: 'Block A',
      kind: BuildingKind.block,
      address: 'Marina Promenade, Dubai Marina',
    ),
    const BuildingRecord(
      id: 'building-creek-2',
      campusId: 'campus-creek',
      name: 'Building 2',
      kind: BuildingKind.building,
      address: 'Dubai Creek Harbour',
    ),
  ];

  final List<ApartmentRecord> _apartments = [
    const ApartmentRecord(
      id: 'apt-a302',
      buildingId: 'building-tower-1',
      unitNumber: 'A-302',
      floor: '3',
    ),
    const ApartmentRecord(
      id: 'apt-a405',
      buildingId: 'building-tower-1',
      unitNumber: 'A-405',
      floor: '4',
    ),
    const ApartmentRecord(
      id: 'apt-ba12',
      buildingId: 'building-block-a',
      unitNumber: 'A-12',
      floor: '1',
    ),
    const ApartmentRecord(
      id: 'apt-c201',
      buildingId: 'building-creek-2',
      unitNumber: 'C-201',
      floor: '2',
    ),
  ];

  int _nextId = 1;

  @override
  List<CampusRecord> get campuses => List.unmodifiable(_campuses);

  @override
  List<BuildingRecord> get buildings => List.unmodifiable(_buildings);

  @override
  List<ApartmentRecord> get apartments => List.unmodifiable(_apartments);

  String nextId(String prefix) => '$prefix-${_nextId++}';

  @override
  void saveCampus(CampusRecord record) {
    final index = _campuses.indexWhere((item) => item.id == record.id);
    if (index == -1) {
      _campuses.add(record);
    } else {
      _campuses[index] = record;
    }
    notifyListeners();
  }

  @override
  void saveBuilding(BuildingRecord record) {
    final index = _buildings.indexWhere((item) => item.id == record.id);
    if (index == -1) {
      _buildings.add(record);
    } else {
      _buildings[index] = record;
    }
    notifyListeners();
  }

  @override
  void saveApartment(ApartmentRecord record) {
    final index = _apartments.indexWhere((item) => item.id == record.id);
    if (index == -1) {
      _apartments.add(record);
    } else {
      _apartments[index] = record;
    }
    notifyListeners();
  }

  @override
  void setCampusStatus(String id, PropertyRecordStatus status) {
    final index = _campuses.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _campuses[index] = _campuses[index].copyWith(status: status);
    }
    notifyListeners();
  }

  @override
  void setBuildingStatus(String id, PropertyRecordStatus status) {
    final index = _buildings.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _buildings[index] = _buildings[index].copyWith(status: status);
    }
    notifyListeners();
  }

  @override
  void setApartmentStatus(String id, PropertyRecordStatus status) {
    final index = _apartments.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _apartments[index] = _apartments[index].copyWith(status: status);
    }
    notifyListeners();
  }
}
