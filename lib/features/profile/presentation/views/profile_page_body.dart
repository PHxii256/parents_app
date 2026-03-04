import 'package:flutter/material.dart';
import 'package:parent_app/features/profile/presentation/profile_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../data/profile_repository_impl.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(ProfileRepositoryImpl())..loadProfile(),

      child: Scaffold(
        appBar: AppBar(
          title: const Text("Profile", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22)),
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
                  const Text(
                    "Account Information",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  Text("Name: ${profile.name}"),
                  Text("Primary Phone: ${profile.primaryPhone}"),
                  Text("Secondary Phone: ${profile.secondaryPhone}"),

                  const SizedBox(height: 30),

                  const Text(
                    "Your Enrolled Children",
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
