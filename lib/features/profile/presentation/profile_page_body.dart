import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/features/profile/domain/child.dart';
import 'package:parent_app/features/profile/domain/profile_repository.dart';
import 'package:parent_app/features/profile/presentation/profile_cubit.dart';

import '../data/profile_repository_impl.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  //  appBar: AppBar(centerTitle: true, title: Text("Center")),
  //       body: BlocBuilder<CounterCubit, int>(
  //         builder: (context, count) => Center(child: Text("$count")),
  //       ),
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
        ),
        centerTitle: true,
      ),

      body: BlocBuilder<ProfileCubit, Profile>(
        builder: (context, vm) {
          if (context.read<ProfileCubit>().isClosed) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile = context.read<ProfileCubit>();

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
                //
                // Text("Name: ${profile?.name}"),
                // Text("Primary Phone: ${profile?.primaryPhone}"),
                // Text("Secondary Phone: ${profile?.secondaryPhone}"),

                const SizedBox(height: 30),

                const Text(
                  "Your Enrolled Children",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: ListView.builder(
                  //  itemCount: profile?.children.length,
                    itemBuilder: (context, index) {
                   //   final child = profile?.children[index];

                      return ListTile(
                        leading: const CircleAvatar(),
                      //  title: Text(child!.name),
                      //  subtitle: Text(child.grade),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
