import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_app/features/auth/cubit/auth_cubit.dart';
import 'package:parent_app/features/auth/cubit/auth_state.dart';
import 'package:parent_app/features/auth/presentation/otp_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  final String userName = "Ahmed Mohamed Ahmed";
  final String primaryPhone = "01020002650";
  final String secondaryPhone = "01030002400";
  final String email = "test@gmail.com";

  final List<Map<String, String>> children = const [
    {"name": "Ahmed Mohsen", "grade": "Grade 2"},
    {"name": "Mohamed Salah", "grade": "Grade 5"},
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {

        if (state is OtpSentState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OtpPage(email: state.email),
            ),
          );
        }


        if (state is UnauthenticatedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error.toString())),
          );
        }
      },

      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            title: const Text(
              "Profile",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),

          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 16),

              const Text(
                "Account Information",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 12),

              _buildInfoRow("Name", userName),
              const SizedBox(height: 8),

              _buildInfoRow("Primary Phone no.", primaryPhone),
              const SizedBox(height: 8),

              _buildInfoRow("Secondary Phone no.", secondaryPhone),

              const SizedBox(height: 24),

              const Text(
                "Your enrolled children",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 12),

              ...children.map((child) => _buildChildTile(child)).toList(),

              const SizedBox(height: 40),


              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: state is AuthLoadingState
                      ? null
                      : () {
                    //TODO send real emaol from local or backend
                    context.read<AuthCubit>().requestOTP(
                      email: email,
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  child: state is AuthLoadingState
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "Reset Password",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title : ",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildChildTile(Map<String, String> child) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade300,
      ),
      title: Text(
        child["name"]!,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        child["grade"]!,
        style: TextStyle(color: Colors.grey.shade600),
      ),
    );
  }
}