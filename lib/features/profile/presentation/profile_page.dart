import 'package:flutter/material.dart';
import 'package:parent_app/features/auth/data/repositories/auth_repository.dart';
import 'package:parent_app/features/auth/presentation/otp_page.dart';
import 'package:parent_app/features/guardian/data/guardian_repository.dart';
import 'package:parent_app/l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GuardianRepository _guardianRepository = GuardianRepository();
  late Future<GuardianProfileData> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadProfile();
  }

  Future<GuardianProfileData> _loadProfile() {
    return _guardianRepository.getProfile();
  }

  Future<void> _refreshProfile() async {
    final refreshedProfile = _loadProfile();
    setState(() {
      _profileFuture = refreshedProfile;
    });
    await refreshedProfile;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return FutureBuilder<GuardianProfileData>(
      future: _profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: RefreshIndicator(
              onRefresh: _refreshProfile,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(
                    height: 420,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ],
              ),
            ),
          );
        }
        final profile = snapshot.data;
        if (profile == null) {
          return Scaffold(
            body: RefreshIndicator(
              onRefresh: _refreshProfile,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: 420,
                    child: Center(child: Text(localizations.profileLoadError)),
                  ),
                ],
              ),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            foregroundColor: Colors.black,
            elevation: 0,
            title: Text(
              localizations.profileTab,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: RefreshIndicator(
            onRefresh: _refreshProfile,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 16),
                Text(
                  localizations.accountInformationTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12),
                _buildInfoRow(localizations.profileNameLabel, profile.name),
                const SizedBox(height: 8),
                _buildInfoRow(
                  localizations.profilePrimaryPhoneLabel,
                  profile.primaryPhone,
                ),
                const SizedBox(height: 8),
                _buildInfoRow(
                  localizations.profileSecondaryPhoneLabel,
                  profile.secondaryPhone,
                ),
                const SizedBox(height: 24),
                Text(
                  localizations.yourEnrolledChildrenTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 12),
                ...profile.children
                    .map((child) => _buildChildTile(child, localizations))
                    .toList(),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (_) => OtpPage(
                            email: profile.email,
                            role: AuthRepository.authPathRoleForEmail(
                              profile.email,
                            ),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      localizations.resetPasswordButton,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
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
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
      ],
    );
  }

  Widget _buildChildTile(
    Map<String, String> child,
    AppLocalizations localizations,
  ) {
    final gradeText = child["grade"] ?? '';
    final gradeMatch = RegExp(r'\d+').firstMatch(gradeText);
    final localizedGrade = gradeMatch == null
        ? gradeText
        : localizations.gradeWithNumber(gradeMatch.group(0)!);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade300,
        child: Icon(Icons.child_care),
      ),
      title: Text(
        child["name"]!,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        localizedGrade,
        style: TextStyle(color: Colors.grey.shade600),
      ),
    );
  }
}
