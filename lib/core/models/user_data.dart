import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_data.freezed.dart';
part 'user_data.g.dart';

@freezed
abstract class User with _$User {
  const factory User({required String id, required String email, required String username}) = _User;

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}
