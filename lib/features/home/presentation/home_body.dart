import 'package:flutter/material.dart';
import 'package:parent_app/features/settings/presentation/settings_page.dart';

class HomeBody extends StatelessWidget {
  final Widget body;
  const HomeBody({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actionsPadding: const EdgeInsets.only(right: 8),
        title: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Row(
            spacing: 6,
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage('lib/shared/assets/images/logo.png')),
                  ),
                ),
              ),
              Text('Safe Route', style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => SettingsPage()));
            },
            icon: const Icon(Icons.settings, size: 24),
            color: Colors.black,
          ),
        ],
      ),
      body: body,
    );
  }
}
