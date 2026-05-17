import 'package:flutter/material.dart';
import '../shared/app_bar.dart';

class Team extends StatelessWidget {
  const Team({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Time",
        showBackButton: false,
      ),

      backgroundColor: const Color(0xFFF7F1E1),

      body: const Center(
        child: Text(
          "Time",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}