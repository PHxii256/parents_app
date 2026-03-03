import 'package:flutter/material.dart';

class ChangeRequestPage extends StatefulWidget {
  const ChangeRequestPage({super.key});

  @override
  State<ChangeRequestPage> createState() => _ChangeRequestPage();
}

class _ChangeRequestPage extends State<ChangeRequestPage> {
  // Pickup / Dropoff selection
  bool isPickup = true;
  // Saved addresses selection
  String selectedAddress = 'Home';
  // Date selection
  String selectedDateOption = 'Tomorrow';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Pickup / Dropoff toggle
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade200,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isPickup = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isPickup ? Colors.brown.shade200 : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                        ),
                        child: const Center(child: Text("Pickup")),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isPickup = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: !isPickup ? Colors.brown.shade200 : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: const Center(child: Text("Dropoff")),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Saved Addresses
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Saved Addresses',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextButton(onPressed: () {}, child: const Text('Add New Address')),
              ],
            ),
            Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  subtitle: const Text('123 Maple Street'),
                  trailing: selectedAddress == 'Home' ? const Icon(Icons.check) : null,
                  onTap: () => setState(() => selectedAddress = 'Home'),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text("Grandma's House"),
                  subtitle: const Text('789 Pine Lane'),
                  trailing: selectedAddress == "Grandma's House" ? const Icon(Icons.check) : null,
                  onTap: () => setState(() => selectedAddress = "Grandma's House"),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Date options
            RadioGroup<String>(
              groupValue: selectedDateOption,
              onChanged: (value) => setState(() => selectedDateOption = value!),
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('Today (Monday)'),
                    value: 'Today',
                    controlAffinity: ListTileControlAffinity.trailing,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  RadioListTile<String>(
                    title: const Text('Tomorrow'),
                    value: 'Tomorrow',
                    controlAffinity: ListTileControlAffinity.trailing,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  RadioListTile<String>(
                    title: const Text('Specific date'),
                    value: 'Specific date',
                    controlAffinity: ListTileControlAffinity.trailing,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  RadioListTile<String>(
                    title: const Text('Duration'),
                    value: 'Duration',
                    controlAffinity: ListTileControlAffinity.trailing,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow.shade700),
                  onPressed: () {},
                  child: const Text('Next', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}
