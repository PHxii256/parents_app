import 'package:flutter/material.dart';
import 'package:parent_app/features/auth/cubit/auth_context_extensions.dart';

class StaffHomeBody extends StatelessWidget {
  const StaffHomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final role = context.authRole;
    return Center(child: Text('Bus staff home ($role)'));
  }
}
