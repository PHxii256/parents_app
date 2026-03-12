import 'package:parent_app/features/profile/domain/child.dart';

sealed class ProfileState {}

class Loading extends ProfileState {}

class Success extends ProfileState {}

class Error extends ProfileState {}
