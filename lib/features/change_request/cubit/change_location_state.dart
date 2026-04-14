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

  const ChangeLocationState({
    this.addresses = const [],
    this.selectedAddress,
    this.isPickup = true,
    this.selectedDate,
  });

  ChangeLocationState copyWith({
    List<SavedAddress>? addresses,
    SavedAddress? selectedAddress,
    bool? isPickup,
    DateTime? selectedDate,
  }) {
    return ChangeLocationState(
      addresses: addresses ?? this.addresses,
      selectedAddress: selectedAddress ?? this.selectedAddress,
      isPickup: isPickup ?? this.isPickup,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}