import 'package:flutter/material.dart';
import 'package:homeautomation_system/screens/login_page.dart';
import 'package:homeautomation_system/screens/main_page.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'imports/import.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //This contain the all routs of the applications.
    return MaterialApp(
      routes: {
        'splashScreen': (context) => const SplashScreen(),
        'loginPage': (context) => const LoginPage(),
        'mainPage': (context) => const MainPage(),
      },
      debugShowCheckedModeBanner: false,
      initialRoute: 'splashScreen',

      // this code is contain the all the theme for the application.
      theme: ThemeData.light().copyWith(
        appBarTheme: AppBarTheme(
          backgroundColor: ColorPalat.skyBlue,
          elevation: 3,
          shadowColor: Colors.black,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontFamily: CommonFonts.josefinBold,
            fontSize: CommonFunctions.getHeight(context, 2.5),
          ),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: ColorPalat.backgroundColor,
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(fontFamily: CommonFonts.josefinLight),
          labelStyle: TextStyle(
              fontFamily: CommonFonts.josefinBold, color: Colors.black),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
            borderSide: BorderSide(color: ColorPalat.skyBlue, width: 2.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
            borderSide: BorderSide(color: Colors.black, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
          errorStyle: TextStyle(fontFamily: CommonFonts.josefinBold),
        ),
        tabBarTheme: const TabBarTheme(
          indicatorColor: Color.fromARGB(255, 39, 39, 39),
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: TextStyle(
            fontFamily: CommonFonts.josefinBold,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: CommonFonts.josefinBold,
          ),
        ),
        textButtonTheme: const TextButtonThemeData(
          style: ButtonStyle(
              iconColor: MaterialStatePropertyAll(Colors.black),
              textStyle: MaterialStatePropertyAll(
                TextStyle(
                  fontFamily: CommonFonts.josefinBold,
                ),
              )),
        ),
      ),
    );
  }
}

//This code for the splash screen.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  String? _id;
  int? _idHash;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xfff5a623),
        body: Center(
          child: Lottie.asset(
            "assets/images/splash_screen.json",
            fit: BoxFit.contain,
            repeat: false,
            controller: _controller,
            onLoaded: (composition) async {
              // this code is vrey important.
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              _id = prefs.getString("_id");
              _idHash = prefs.getInt("_idHash");
              _controller
                ..duration = composition.duration
                ..forward().whenComplete(
                  () {
                    // This code check if user is allredy login then is will redirect to main_page.
                    if (_id != null && _idHash != 0) {
                      _id.hashCode == _idHash
                          ? Navigator.pushNamed(context, "mainPage")
                          : Navigator.pushNamed(context, "loginPage");
                    } else {
                      // If user is not logedin then it will redirect to the LoginPage.
                      Navigator.pushNamed(context, "loginPage");
                    }
                  },
                );
            },
          ),
        ),
      ),
    );
  }
}
