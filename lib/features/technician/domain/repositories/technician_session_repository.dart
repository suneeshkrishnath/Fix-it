abstract interface class TechnicianSessionRepository {
  String? readTechnicianId();

  Future<bool> signIn(String technicianId);

  Future<void> signOut();
}
