import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/features/change_request/presentation/add_location_page.dart';
import 'package:parent_app/features/change_request/presentation/changeRequest(summary).dart';
import 'package:parent_app/features/change_request/presentation/components/date_radio_group.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:parent_app/shared/theme/app_colors.dart';
import '../cubit/change_location_cubit.dart';
import '../cubit/change_location_state.dart';

class ChangeRequestPage extends StatelessWidget {
  const ChangeRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChangeLocationCubit(),
      child: const _ChangeRequestView(),
    );
  }
}

class _ChangeRequestView extends StatelessWidget {
  const _ChangeRequestView();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.requestTitle,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              localizations.changePickupDropoff,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
            ),
            const SizedBox(height: 18),

            // Pickup / Dropoff toggle
            BlocBuilder<ChangeLocationCubit, ChangeLocationState>(
              buildWhen: (prev, curr) => prev.isPickup != curr.isPickup,
              builder: (context, state) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              context.read<ChangeLocationCubit>().setPickup(true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: state.isPickup
                                  ? AppColors.highlight
                                  : Colors.transparent,
                              borderRadius: isRtl
                                  ? const BorderRadius.only(
                                topRight: Radius.circular(32),
                                bottomRight: Radius.circular(32),
                              )
                                  : const BorderRadius.only(
                                topLeft: Radius.circular(32),
                                bottomLeft: Radius.circular(32),
                              ),
                            ),
                            child: Center(child: Text(localizations.pickupLabel)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              context.read<ChangeLocationCubit>().setPickup(false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: !state.isPickup
                                  ? AppColors.highlight
                                  : Colors.transparent,
                              borderRadius: isRtl
                                  ? const BorderRadius.only(
                                topLeft: Radius.circular(32),
                                bottomLeft: Radius.circular(32),
                              )
                                  : const BorderRadius.only(
                                topRight: Radius.circular(32),
                                bottomRight: Radius.circular(32),
                              ),
                            ),
                            child: Center(child: Text(localizations.dropoffLabel)),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Saved Addresses header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  localizations.savedAddressesTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          // ✅ Pass the SAME cubit instance so addAddress updates this page
                          value: context.read<ChangeLocationCubit>(),
                          child: AddLocationPage(),
                        ),
                      ),
                    );
                  },
                  child: Text(
                    localizations.addNewAddress,
                    style: TextStyle(color: AppColors.cta),
                  ),
                ),
              ],
            ),

            // Address list
            BlocBuilder<ChangeLocationCubit, ChangeLocationState>(
              buildWhen: (prev, curr) =>
              prev.addresses != curr.addresses ||
                  prev.selectedAddress != curr.selectedAddress,
              builder: (context, state) {
                return Column(
                  children: state.addresses.map((addr) {
                    final isSelected = state.selectedAddress?.id == addr.id;
                    return ListTile(
                      leading: Icon(addr.icon),
                      title: Text(addr.name),
                      subtitle: Text(addr.address),
                      trailing: isSelected ? const Icon(Icons.check) : null,
                      onTap: () =>
                          context.read<ChangeLocationCubit>().selectAddress(addr),
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 12),

            // Date options
            DateRadioGroup(
              onDateSelected: (DateTime selected) {
                context.read<ChangeLocationCubit>().selectDate(selected);
              },
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.cta),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<ChangeLocationCubit>(),
                        child: const ChangeRequestSummaryPage(),
                      ),
                    ),
                  );
                },
                child: Text(
                  localizations.nextButton,
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}