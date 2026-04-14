import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:parent_app/shared/theme/app_colors.dart';
import '../cubit/change_location_cubit.dart';
import '../cubit/change_location_state.dart';

class ChangeRequestSummaryPage extends StatelessWidget {
  const ChangeRequestSummaryPage({super.key});

  String _formatDate(DateTime date) {
    const weekdays = [
      'Monday', 'Tuesday', 'Wednesday',
      'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    final weekday = weekdays[date.weekday - 1];
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$weekday $month/$day';
  }

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [


                  Text(
                    localizations.changePickupDropoff,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                    ),
                  ),

                  const SizedBox(height: 15),
                  BlocBuilder<ChangeLocationCubit, ChangeLocationState>(
                    buildWhen: (prev, curr) =>
                    prev.selectedDate != curr.selectedDate,
                    builder: (context, state) {
                      final dateText = state.selectedDate != null
                          ? '(${_formatDate(state.selectedDate!)})'
                          : '';
                      return RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 22,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(text: localizations.requestSummaryFor),
                            if (dateText.isNotEmpty) ...[
                              const TextSpan(text: ' '),
                              TextSpan(
                                text: dateText,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 22,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 18),


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
                              child: Container(
                                padding:
                                const EdgeInsets.symmetric(vertical: 12),
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
                                child: Center(
                                    child: Text(localizations.pickupLabel)),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding:
                                const EdgeInsets.symmetric(vertical: 12),
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
                                child: Center(
                                    child: Text(localizations.dropoffLabel)),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),


                  Text(
                    localizations.savedAddressesTitle,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<ChangeLocationCubit, ChangeLocationState>(
                    buildWhen: (prev, curr) =>
                    prev.selectedAddress != curr.selectedAddress,
                    builder: (context, state) {
                      final selected = state.selectedAddress;
                      if (selected == null) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'No address selected',
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                        );
                      }
                      return ListTile(
                        leading: Icon(selected.icon),
                        title: Text(selected.name),
                        subtitle: Text(selected.address),
                        tileColor: AppColors.highlight,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      );
                    },
                  ),


                ],
              ),
            ),
          ),


          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      localizations.returnAndEdit,
                      style: const TextStyle(
                          fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cta,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      final cubit = context.read<ChangeLocationCubit>();
                      final isAccepted = await cubit.submitRequest();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isAccepted
                                  ? 'Request Accepted'
                                  : 'Request Failed',
                            ),
                            backgroundColor:
                            isAccepted ? Colors.green : Colors.red,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    child: Text(
                      localizations.doneButton,
                      style: const TextStyle(
                          fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}