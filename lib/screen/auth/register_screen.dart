import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vp18_firebase/firebase/fb_auth_controller.dart';
import 'package:vp18_firebase/models/process_response.dart';
import 'package:vp18_firebase/utils/context_extension.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscure = true;

  late TextEditingController _fullNameTextController;
  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;

  String? _fullNameError;
  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fullNameTextController = TextEditingController();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _fullNameTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsetsDirectional.only(start: 25),
          child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.only(start: 30, end: 30, top: 60),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sing in",
                style: GoogleFonts.nunito(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                "Create Account",
                style: GoogleFonts.roboto(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w300,
                  color: const Color(0xFF716F87),
                ),
              ),
              SizedBox(height: 30.h),
              TextField(
                controller: _fullNameTextController,
                maxLines: 1,
                style: GoogleFonts.roboto(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w400,
                ),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.send,
                cursorColor: Colors.black,
                cursorHeight: 30.h,
                cursorWidth: 1.w,
                decoration: InputDecoration(
                  hintText: "Full Name",
                  hintMaxLines: 1,
                  errorText: _fullNameError,
                  hintStyle: GoogleFonts.roboto(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w300,
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              TextField(
                controller: _emailTextController,
                maxLines: 1,
                style: GoogleFonts.roboto(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w400,
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.send,
                cursorColor: Colors.black,
                cursorHeight: 30.h,
                cursorWidth: 1.w,
                decoration: InputDecoration(
                  hintText: "Email",
                  hintMaxLines: 1,
                  errorText: _emailError,
                  hintStyle: GoogleFonts.roboto(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w300,
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              TextField(
                controller: _passwordTextController,
                maxLines: 1,
                style: GoogleFonts.roboto(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w400,
                ),
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.send,
                cursorColor: Colors.black,
                cursorHeight: 30.h,
                cursorWidth: 1.w,
                obscureText: _obscure,
                decoration: InputDecoration(
                  hintText: "Password",
                  hintMaxLines: 1,
                  errorText: _passwordError,
                  suffixIcon: IconButton(
                    icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() => _obscure = !_obscure);
                    },
                    color: Colors.grey,
                  ),
                  hintStyle: GoogleFonts.roboto(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w300,
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              ElevatedButton(
                onPressed: () => _performRegister(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFF6A90F2),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  textStyle: GoogleFonts.roboto(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  minimumSize: Size(double.infinity, 53.h),
                ),
                child: const Text("Sign In"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _performRegister() async {
    if (_checkData()) {
      await _register();
    }
  }

  bool _checkData() {
    if (_emailTextController.text.isNotEmpty &&
        _passwordTextController.text.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<void> _register() async {
    ProcessResponse processResponse = await FbAuthController().register(
      _emailTextController.text,
      _passwordTextController.text,
    );
    if (processResponse.success) Navigator.pop(context);
    context.showSnackBar(
      message: processResponse.massage,
      erorr: !processResponse.success,
    );
  }
}
