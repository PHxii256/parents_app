import 'child.dart';

abstract class ProfileRepository {
  Future<Profile> getProfile();
}