import 'package:parent_app/features/change_request/domain/child.dart';
import 'package:parent_app/features/change_request/domain/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  @override
  Future<Profile> getProfile() async {
    // simulate API delay
    await Future.delayed(const Duration(seconds: 2));

    return Profile(
      name: "Ahmed Mohamed Ahmed",
      primaryPhone: "01020002650",
      secondaryPhone: "01030002400",
      children: [
        Child(name: "Ahmed Mohsen", grade: "Grade 2"),
        Child(name: "Mohamed Salah", grade: "Grade 5"),
      ],
    );
  }
}
