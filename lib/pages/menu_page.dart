import 'package:flutter/material.dart';
import 'package:nl_manager/components/my_square_btn.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Menu', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            MySquareBtn(
                onPressed: () {
                  Navigator.pushNamed(context, '/modules');
                },
                icon: Icons.document_scanner_outlined,
                label: "Modules")
          ],
        ),
      ),
    );
  }
}
