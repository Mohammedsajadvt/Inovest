import 'package:inovest/core/utils/index.dart';
import 'package:inovest/presentation/add_project_screen/screens/add_project_screen.dart';
import 'package:inovest/presentation/chat/screens/chats_screen.dart';
import 'package:inovest/presentation/home_screen/screens/entrepreneur_home_screen.dart';
import 'package:inovest/presentation/home_screen/screens/investor_home_screen.dart';
import 'package:inovest/presentation/profile_screen/screens/profile_screen.dart';
import 'package:inovest/presentation/settings_screen/screens/settings_screen.dart';
import 'package:inovest/presentation/splash_screen/screens/splash_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String landing = '/landing';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String chats = '/chats';
  static const String entrepreneurHome = '/entrepreneurHome';
  static const String investorHome = '/investorHome';
  static const String project = '/project';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static Map<String, WidgetBuilder> routes = {
    splash: (context) => SplashScreen(),
    landing: (context) => LandingScreen(),
    login: (context) => LoginScreen(),
    signup: (context) => SignupScreen(),
    chats: (context) => const ChatsScreen(),
    entrepreneurHome: (context) => const EntrepreneurHomeScreen(),
    investorHome: (context) => const InvestorHomeScreen(),
    project: (context) => const AddProjectScreen(),
    settings: (context) => const SettingsScreen(),
    profile:(context) => const ProfileScreen(),
  };
}
