import 'package:flutter/material.dart';
import 'package:parent_app/features/change_request/domain/child.dart';
import 'package:parent_app/features/change_request/domain/profile_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  final ProfileRepository repository;

  ProfileViewModel(this.repository);

  Profile? profile;
  bool isLoading = true;

  Future<void> loadProfile() async {
    profile = await repository.getProfile();

    isLoading = false;

    notifyListeners();
  }
}
