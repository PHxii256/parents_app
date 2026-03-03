import 'package:flutter/material.dart';

import '../domain/child.dart';
import '../domain/profile_repository.dart';

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
