import 'package:inovest/core/utils/index.dart';
<<<<<<< Updated upstream
import 'package:inovest/presentation/chat/screens/chats_screen.dart';
=======
import 'package:inovest/presentation/home_screen/screens/entrepreneur_home_screen.dart';
import 'package:inovest/presentation/home_screen/screens/investor_home_screen.dart';
>>>>>>> Stashed changes
import 'package:inovest/presentation/splash_screen/splash_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String landing = '/landing';
  static const String login = '/login';
  static const String signup = '/signup';
<<<<<<< Updated upstream
  static const String chats = '/chats';
  static Map<String, WidgetBuilder> routes = {
    splash: (context) => SplashScreen(),
    landing: (context) => LandingScreen(),
    login: (context) => LoginScreen(),
    signup: (context) => SignupScreen(),
    chats: (context) => const ChatsScreen(),
=======
  static const String entrepreneurHome = '/entrepreneurHome';
  static const String investorHome = '/investorHome';
  static Map<String, WidgetBuilder> routes = {
    splash: (context) => SplashScreen(),
    landing:(context) => LandingScreen(),
    login:(context) => LoginScreen(),
    signup:(context) => SignupScreen(),
    entrepreneurHome:(context) => EntrepreneurHomeScreen(),
    investorHome:(context) => InvestorHomeScreen()
>>>>>>> Stashed changes
  };
}
