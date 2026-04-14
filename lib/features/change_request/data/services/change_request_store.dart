import 'package:flutter/foundation.dart';
import 'package:parent_app/features/change_request/presentation/models/change_request_payload.dart';

class ChangeRequestStore {
  ChangeRequestStore._();

  static final ChangeRequestStore instance = ChangeRequestStore._();

  final ValueNotifier<ChangeRequestPayload?> activeRequest = ValueNotifier<ChangeRequestPayload?>(
    null,
  );

  void setActiveRequest(ChangeRequestPayload payload) {
    activeRequest.value = payload;
  }

  void clear() {
    activeRequest.value = null;
  }
}
