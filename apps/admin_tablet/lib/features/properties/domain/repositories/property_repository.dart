import '../models/property_records.dart';

abstract interface class PropertyRepository {
  List<CampusRecord> get campuses;
  List<BuildingRecord> get buildings;
  List<ApartmentRecord> get apartments;

  void saveCampus(CampusRecord record);
  void saveBuilding(BuildingRecord record);
  void saveApartment(ApartmentRecord record);
  void setCampusStatus(String id, PropertyRecordStatus status);
  void setBuildingStatus(String id, PropertyRecordStatus status);
  void setApartmentStatus(String id, PropertyRecordStatus status);
}
