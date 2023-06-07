import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vp18_firebase/firebase/fb_auth_controller.dart';


class LaunchScreen extends StatefulWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      String route = FbAuthController().isLoggedIn ? "/home_screen" : "/login_screen";
      Navigator.pushReplacementNamed(context, route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'FireBase App',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 25.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
