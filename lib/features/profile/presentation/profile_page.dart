import 'package:flutter/material.dart';
import 'package:parent_app/features/guardian/data/guardian_repository.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GuardianRepository _guardianRepository = GuardianRepository();
  late final Future<GuardianProfileData> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _guardianRepository.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GuardianProfileData>(
      future: _profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final profile = snapshot.data;
        if (profile == null) {
          return const Scaffold(body: Center(child: Text('Unable to load profile.')));
        }
        return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text("Profile", style: TextStyle(fontWeight: FontWeight.bold)),
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
          _buildInfoRow("Name", profile.name),
          const SizedBox(height: 8),
          _buildInfoRow("Primary Phone no.", profile.primaryPhone),
          const SizedBox(height: 8),
          _buildInfoRow("Secondary Phone no.", profile.secondaryPhone),
          const SizedBox(height: 24),
          const Text(
            "Your enrolled children",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
          ...profile.children.map((child) => _buildChildTile(child)).toList(),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // Reset password logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Reset Password", style: TextStyle(fontSize: 18)),
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
        Text("$title : ", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
      ],
    );
  }

  Widget _buildChildTile(Map<String, String> child) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(backgroundColor: Colors.grey.shade300, child: Icon(Icons.child_care)),
      title: Text(child["name"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(child["grade"]!, style: TextStyle(color: Colors.grey.shade600)),
    );
  }
}
