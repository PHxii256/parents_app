import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Pin Code', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            const Text(
              "Share your child's pin code",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "This pin code allows you or other people you trust to safely pick up your children by saying this code to the bus driver or assistant.",
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            const Text("Master Pin", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 4),
            const Text(
              "(Do not share with anyone other than bus staff)",
              style: TextStyle(color: Colors.red),
            ),
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
            const Text(
              "Temporary Pin",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            const Text(
              "(This PIN is safe to share and is valid for one day only)",
              style: TextStyle(color: Colors.black54),
            ),
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
                    ).showSnackBar(const SnackBar(content: Text("Temporary PIN copied!")));
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
