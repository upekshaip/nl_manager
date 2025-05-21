import 'package:flutter/material.dart';

class InstructionsPage extends StatelessWidget {
  const InstructionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.black,
        title: const Text('Instructions'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '1. You can only access this app if you have been provided with a username and password.',
                ),
                SizedBox(height: 8),
                Text(
                  '2. You can only view the active modules. You cannot scan the modules that have been removed from view in NLearn. Only the active modules will be visible. If you want to view removed module, first go to nlearn and make it active. Then it will be visible here after a new refresh.',
                ),
                SizedBox(height: 8),
                Text(
                  '3. Same goes for the downloader. Only the active modules will be visible and downloadable.',
                ),
                SizedBox(height: 8),
                Text(
                  '4. Note that you can schedule this app to refresh the modules and todos every 15 minutes, 30 minutes, 1 hour, 3 hours, 6 hours, 12 hours or 24 hours. The default setting will not refresh the modules and todos automatically. You can change this setting in the settings page.',
                ),
                SizedBox(height: 8),
                Text(
                  '5. If you need to do the scheduled tasks then you must give the username and password for the app. It will save the credentials in the app and use them to refresh the modules and todos.',
                ),
                SizedBox(height: 8),
                Text(
                  '6. You can also refresh the modules and todos manually by clicking the refresh button in the respective pages.',
                ),
                SizedBox(height: 8),
                Text(
                  '7. The refresh button is located in the top right corner of the modules and todos pages.',
                ),
                SizedBox(height: 8),
                Text(
                  '8. You can logout from the app by clicking the logout button in the menu page.',
                ),
                SizedBox(height: 8),
                Text(
                  '9. You can view the app version and the developers in the about page.',
                ),
                SizedBox(height: 8),
                Text(
                  '10. If you have any issues or suggestions, please contact the developers. Thank you.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
