import 'package:flutter/material.dart';
import 'package:parent_app/features/login/presentation/login_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  void logout(BuildContext ctx) {
    // first we should clear local jwt storage
    // this logic should be done in a bloc.
    if (ctx.mounted) {
      Navigator.of(
        ctx,
        rootNavigator: true,
      ).pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Settings", style: TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Column(
          children: [
            ListTile(
              title: Text("Logout"),
              onTap: () => logout(context),
              trailing: Icon(Icons.logout_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
