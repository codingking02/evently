import 'package:evently/providers/event_provider.dart';
import 'package:evently/providers/user_provider.dart';
import 'package:evently/theme/apptheme.dart';
import 'package:evently/view/auth/login.dart';
import 'package:evently/view/auth/register.dart';
import 'package:evently/view/event/create_event.dart';
import 'package:evently/view/home/home_screen.dart';
import 'package:evently/view/onboard/slider_screen.dart';
import 'package:evently/view/update/update_event.dart';
import 'package:evently/widgets/event_details.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool hasSeenSlider = prefs.getBool('endSlider') ?? false;
  String seenSlider =
      hasSeenSlider ? Register.routeName : SliderScreen.routeName;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => EventProvider()..getEvents(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
      ],
      child: Evently(
        seenSlider: seenSlider,
      ),
    ),
  );
}

class Evently extends StatelessWidget {
  const Evently({required this.seenSlider, super.key});
  final String seenSlider;
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 841),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Evently',
          debugShowCheckedModeBanner: false,
          theme: Apptheme.lightTheme,
          darkTheme: Apptheme.darkTheme,
          themeMode: ThemeMode.light,
          routes: {
            Login.routeName: (_) => const Login(),
            Register.routeName: (_) => const Register(),
            HomeScreen.routeName: (_) => const HomeScreen(),
            CreateEvent.routeName: (_) => const CreateEvent(),
            SliderScreen.routeName: (_) => const SliderScreen(),
            EventDetails.routeName: (_) => EventDetails(),
            UpdateEvent.routeName: (_) => const UpdateEvent(),
          },
          initialRoute: seenSlider,
        );
      },
    );
  }
}
