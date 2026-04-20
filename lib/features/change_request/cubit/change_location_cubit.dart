import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/features/change_request/data/change_request_repository.dart';
import 'change_location_state.dart';

class ChangeLocationCubit extends Cubit<ChangeLocationState> {
  final ChangeRequestRepository _changeRequestRepository;

  ChangeLocationCubit({ChangeRequestRepository? changeRequestRepository})
    : _changeRequestRepository = changeRequestRepository ?? ChangeRequestRepository(),
      super(const ChangeLocationState()) {
    _loadAddresses();
    loadActiveRequest();
  }

  void _loadAddresses() {
    // Mock backend fetch
    final mockAddresses = [
      const SavedAddress(
        id: '1',
        name: 'Home',
        address: '123 Main St',
        icon: Icons.home,
      ),
      const SavedAddress(
        id: '2',
        name: "Grandma's House",
        address: '456 Oak Ave',
        icon: Icons.home,
      ),
    ];
    emit(state.copyWith(addresses: mockAddresses));
  }
  void addAddress(String name, String address) {
    final newAddress = SavedAddress(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      address: address,
      icon: Icons.location_on,
    );

    final updatedList = List<SavedAddress>.from(state.addresses)..add(newAddress);

    emit(state.copyWith(
      addresses: updatedList,
      selectedAddress: newAddress, // ✅ auto-select the new one
    ));
  }
  void selectAddress(SavedAddress address) {
    emit(state.copyWith(selectedAddress: address));
  }

  void setPickup(bool isPickup) {
    emit(state.copyWith(isPickup: isPickup));
  }

  void selectDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  Future<bool> submitRequest() async {
    final selectedAddress = state.selectedAddress;
    final selectedDate = state.selectedDate;
    if (selectedAddress == null || selectedDate == null) {
      emit(state.copyWith(error: 'Please select address and date.'));
      return false;
    }
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final request = await _changeRequestRepository.submitRequest(
        targetDate: selectedDate,
        changeType: state.isPickup ? 'pickup' : 'dropoff',
        locationId: selectedAddress.id,
      );
      emit(
        state.copyWith(
          isLoading: false,
          pendingReview: true,
          blockedByPendingRequest: true,
          activeRequestId: request.id,
        ),
      );
      return true;
    } catch (_) {
      emit(state.copyWith(isLoading: false, error: 'Failed to submit request.'));
      return false;
    }
  }

  Future<void> loadActiveRequest() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final request = await _changeRequestRepository.getActiveRequest();
      final status = request?.status ?? '';
      final isBlocked = status == 'pending_review' || status == 'accepted';
      emit(
        state.copyWith(
          isLoading: false,
          blockedByPendingRequest: isBlocked,
          activeRequestId: request?.id,
          pendingReview: status == 'pending_review',
        ),
      );
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> cancelActiveRequest() async {
    final requestId = state.activeRequestId;
    if (requestId == null || requestId.isEmpty) return;
    emit(state.copyWith(isLoading: true, clearError: true));
    final ok = await _changeRequestRepository.cancelRequest(requestId);
    if (!ok) {
      emit(state.copyWith(isLoading: false, error: 'Failed to cancel active request.'));
      return;
    }
    emit(
      state.copyWith(
        isLoading: false,
        blockedByPendingRequest: false,
        activeRequestId: null,
        pendingReview: false,
      ),
    );
  }
}