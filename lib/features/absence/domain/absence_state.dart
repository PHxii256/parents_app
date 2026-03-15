import 'package:equatable/equatable.dart';
import 'package:parent_app/features/absence/domain/request_state.dart';

class AbsenceState extends Equatable {

  final bool isAbsent;
  final RequestStatus status;
  final String? message;

  const AbsenceState({
    required this.isAbsent,
    required this.status,
    this.message,
  });

  factory AbsenceState.initial() {
    return const AbsenceState(
      isAbsent: false,
      status: RequestStatus.initial,
    );
  }

  AbsenceState copyWith({
    bool? isAbsent,
    RequestStatus? status,
    String? message,
  }) {
    return AbsenceState(
      isAbsent: isAbsent ?? this.isAbsent,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [isAbsent, status, message];
}

