import 'package:chat_app/theme.dart';
import 'package:chat_app/views/account_view.dart';
import 'package:chat_app/views/chat_view.dart';
import 'package:chat_app/views/first_view.dart';
import 'package:chat_app/views/onboarding.dart';
import 'package:chat_app/views/signin_view.dart';
import 'package:chat_app/views/signup_view.dart';
// import 'package:chat_app/views/onboarding.dart';
// import 'package:chat_app/views/signin_view.dart';
// import 'package:chat_app/views/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseUrl = 'https://nrvgmmktbfjkyvwfmwsy.supabase.co';
String supabaseKey = dotenv.env['SUPABASE_KEY'].toString();
bool _redirecting = false;
SupabaseClient supabase = Supabase.instance.client;
String root = '';
Future<void> main() async {
  await dotenv.load(fileName: "lib/.env"); //path to your .env file);
  // print("======================= s $supabaseKey");
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);

  supabase.auth.onAuthStateChange.listen((data) {
    if (_redirecting) {
      return;
    }
    final session = data.session;
    if (session != null) {
      _redirecting = true;
      root = 'account_view';
    } else {
      root = 'onboarding_view';
    }
  });
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'first_view': (context) => const FirstView(),
        'onboarding_view': (context) => const OnBoardingView(),
        'signin_view': (context) => const SignInView(),
        'signup_view': (context) => const SingUpView(),
        'account_view': (context) => const AccountView(),
        const ChatView().chatViewId: (context) => const ChatView(),
      },
      theme: lightThemeData(context),
      darkTheme: darkThemeData(context),
      themeMode: ThemeMode.system,
      initialRoute: root, //'onboarding_view',
      debugShowCheckedModeBanner: false,
    );
  }
}
