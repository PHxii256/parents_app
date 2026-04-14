import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'change_location_state.dart';

class ChangeLocationCubit extends Cubit<ChangeLocationState> {
  ChangeLocationCubit() : super(const ChangeLocationState()) {
    _loadAddresses();
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
    // Mock backend submit
    await Future.delayed(const Duration(seconds: 1));
    return true; // mock success
  }
}