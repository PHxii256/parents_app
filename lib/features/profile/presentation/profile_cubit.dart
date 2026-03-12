import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/features/profile/data/profile_repository_impl.dart';
import 'package:parent_app/features/profile/presentation/profile_state.dart';

import '../domain/child.dart';
import '../domain/profile_repository.dart';

//Cubit
//    ↓ emits
// State
//    ↓ contains
// Data
class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(super.initialState, {required this.repository});

  final ProfileRepository repository;
}
