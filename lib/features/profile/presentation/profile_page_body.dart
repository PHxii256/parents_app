import 'package:flutter/material.dart';
import 'package:parent_app/features/profile/presentation/profile_viewmodel.dart';
import 'package:parent_app/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../shared/theme/app_colors.dart';
import '../data/profile_repository_impl.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(ProfileRepositoryImpl())..loadProfile(),

      child: Scaffold(
        appBar: AppBar(
          title: Text(
            localizations.profileTab,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
          ),
          centerTitle: true,
        ),

        body: Consumer<ProfileViewModel>(
          builder: (context, vm, _) {
            if (vm.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final profile = vm.profile!;

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.accountInformationTitle,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Text(localizations.nameLabel(profile.name)),
                  Text(localizations.primaryPhoneLabel(profile.primaryPhone)),
                  Text(
                    localizations.secondaryPhoneLabel(profile.secondaryPhone),
                  ),

                  const SizedBox(height: 30),

                  Text(
                    localizations.yourEnrolledChildrenTitle,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Expanded(
                    child: ListView.builder(
                      itemCount: profile.children.length,
                      itemBuilder: (context, index) {
                        final child = profile.children[index];

                        return ListTile(
                          leading: const CircleAvatar(),
                          title: Text(child.name),
                          subtitle: Text(child.grade),
                        );
                      },
                    ),
                  ),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(10),
                        ),
                      ),

                      onPressed: () {
                        //navigate to reset pass page and send request
                      },
                      child: Text(
                        localizations.resetPasswordButton,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
