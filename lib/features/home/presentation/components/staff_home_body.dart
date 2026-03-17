import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/features/auth/cubit/auth_cubit.dart';
import 'package:parent_app/features/auth/cubit/auth_state.dart';

class StaffHomeBody extends StatelessWidget {
  const StaffHomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final role = switch (state) {
          AuthenticatedState() => state.user.role,
          _ => 'staff',
        };
        return Center(child: Text('Bus staff home (${role.toLowerCase()})'));
      },
    );
  }
}
