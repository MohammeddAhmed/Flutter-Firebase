import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vp18_firebase/bloc/bloc/images_bloc.dart';
import 'package:vp18_firebase/bloc/states/image_state.dart';
import 'package:vp18_firebase/firebase/fb_notifications.dart';
import 'package:vp18_firebase/firebase_options.dart';
import 'package:vp18_firebase/screen/app/home_screen.dart';
import 'package:vp18_firebase/screen/auth/login_screen.dart';
import 'package:vp18_firebase/screen/auth/register_screen.dart';
import 'package:vp18_firebase/screen/core/launch_screen.dart';
import 'package:vp18_firebase/screen/images/images_screen.dart';
import 'package:vp18_firebase/screen/images/upload_image_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FbNotifications.initNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => ImagesBloc(LoadingState(),),),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: AppBarTheme(
                iconTheme: const IconThemeData(color: Colors.black),
                centerTitle: true,
                elevation: 0,
                color: Colors.white,
                titleTextStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 20.sp,
                ),
              ),
            ),
            initialRoute: "/launch_screen",
            routes: {
              "/launch_screen": (context) => const LaunchScreen(),
              "/login_screen": (context) => const LoginScreen(),
              "/register_screen": (context) => const RegisterScreen(),
              "/home_screen": (context) => const HomeScreen(),
              "/images_screen": (context) => const ImagesScreen(),
              "/upload_image_screen": (context) => const UploadImageScreen(),
            },
          ),
        );
      },
    );
  }
}