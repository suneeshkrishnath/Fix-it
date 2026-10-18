import '../../../auth/domain/models/resident.dart';
import '../models/resident_profile.dart';

abstract interface class ResidentProfileRepository {
  Future<ResidentProfile> loadProfile(Resident resident);
}
