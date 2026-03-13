import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parent_app/l10n/app_localizations.dart';

class PinCodePage extends StatefulWidget {
  const PinCodePage({super.key});

  @override
  State<PinCodePage> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinCodePage> {
  bool masterPinVisible = false;
  TextEditingController masterPinController = TextEditingController(text: '1234'); // example
  TextEditingController tempPinController = TextEditingController(text: '5678'); // example

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          localizations.pinCodeTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            Text(
              localizations.shareChildPinCodeTitle,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              localizations.pinCodeDescription,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            Text(
              localizations.masterPinTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(localizations.masterPinWarning, style: TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
            TextField(
              controller: masterPinController,
              obscureText: !masterPinVisible,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                suffixIcon: IconButton(
                  icon: Icon(masterPinVisible ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      masterPinVisible = !masterPinVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              localizations.temporaryPinTitle,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(localizations.temporaryPinInfo, style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 8),
            TextField(
              controller: tempPinController,
              readOnly: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: tempPinController.text));
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(localizations.temporaryPinCopied)));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
