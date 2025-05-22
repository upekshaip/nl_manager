import 'package:flutter/material.dart';
import 'package:nlmanager/components/primary_btn.dart';
import 'package:nlmanager/tasks/settings_state.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsStateProvider>(
      builder: (context, mySettings, child) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Colors.black,
          title: const Text('Settings', style: TextStyle(color: Colors.white)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Auto Loggin and Schedule Task",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                SwitchListTile(
                  title: const Text('Auto Login'),
                  value: mySettings.autoLogin,
                  onChanged: (bool value) {
                    mySettings.autoLoginChange(value);
                  },
                ),
                const Text(
                  "You can optionally save your username and password here. "
                  "This will enable auto login and scanning for missing files and todos. "
                  "If you prefer not to use this feature, you can leave these fields empty to disable auto login.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: mySettings.usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                  enabled: mySettings.autoLogin,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: mySettings.passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  enabled: mySettings.autoLogin,
                ),
                const SizedBox(height: 28),
                const Text('Schedule Tasks'),
                const SizedBox(height: 10),
                const Text(
                  'We recommend setting the schedule to 6 hours for optimal balance between performance and battery consumption.',
                ),
                const SizedBox(height: 10),
                DropdownButtonHideUnderline(
                  child: AbsorbPointer(
                    absorbing: !mySettings.autoLogin,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900, // Dark background
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.grey.shade700), // Subtle border
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12), // Inner padding
                      child: DropdownButton<int>(
                        dropdownColor: Colors.black87, // Dark dropdown menu
                        value: mySettings.schedule,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                        isExpanded: true,
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.white),
                        onChanged: (int? newValue) {
                          mySettings.setSchedule(newValue!);
                        },
                        items: [15, 30, 1, 3, 6, 12, 24].map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(
                              '$value ${(value == 15 || value == 30) ? "minutes" : "hours"}',
                              style: TextStyle(
                                color: Colors.white70, // Light grey text
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                PrimaryBtn(
                  onTap: () {
                    String saved = mySettings.saveChanges();
                    if (saved != "") {
                      // notification (snackbar widget)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            saved,
                            style: TextStyle(color: Colors.white),
                          ), // Your message
                          duration: Duration(
                              seconds:
                                  5), // Duration for which the Snackbar will be shown
                        ),
                      );
                    }
                  },
                  text: "Save Changes",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
