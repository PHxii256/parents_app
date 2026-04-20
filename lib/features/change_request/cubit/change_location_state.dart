import 'package:flutter/material.dart';

class SavedAddress {
  final String id;
  final String name;
  final String address;
  final IconData icon;

  const SavedAddress({
    required this.id,
    required this.name,
    required this.address,
    required this.icon,
  });
}

class ChangeLocationState {
  final List<SavedAddress> addresses;
  final SavedAddress? selectedAddress;
  final bool isPickup;
  final DateTime? selectedDate;
  final bool isLoading;
  final bool blockedByPendingRequest;
  final String? activeRequestId;
  final String? error;
  final bool pendingReview;

  const ChangeLocationState({
    this.addresses = const [],
    this.selectedAddress,
    this.isPickup = true,
    this.selectedDate,
    this.isLoading = false,
    this.blockedByPendingRequest = false,
    this.activeRequestId,
    this.error,
    this.pendingReview = false,
  });

  ChangeLocationState copyWith({
    List<SavedAddress>? addresses,
    SavedAddress? selectedAddress,
    bool? isPickup,
    DateTime? selectedDate,
    bool? isLoading,
    bool? blockedByPendingRequest,
    String? activeRequestId,
    String? error,
    bool clearError = false,
    bool? pendingReview,
  }) {
    return ChangeLocationState(
      addresses: addresses ?? this.addresses,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      isPickup: isPickup ?? this.isPickup,
      selectedDate: selectedDate ?? this.selectedDate,
      isLoading: isLoading ?? this.isLoading,
      blockedByPendingRequest: blockedByPendingRequest ?? this.blockedByPendingRequest,
      activeRequestId: activeRequestId ?? this.activeRequestId,
      error: clearError ? null : error ?? this.error,
      pendingReview: pendingReview ?? this.pendingReview,
    );
  }
}