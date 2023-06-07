import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

extension ContextExtension on BuildContext {
  void showSnackBar({
    required String message,
    bool erorr = false,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins(),),
        backgroundColor: erorr ? Colors.red.shade700 : Colors.green.shade700,
        dismissDirection: DismissDirection.horizontal,
        duration: const Duration(seconds: 4),
        //behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
