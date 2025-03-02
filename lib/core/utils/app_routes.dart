import 'package:inovest/core/utils/index.dart';
import 'package:inovest/presentation/add_project_screen/screens/add_project_screen.dart';
import 'package:inovest/presentation/chat/screens/chats_screen.dart';
import 'package:inovest/presentation/forgot_password/screens/forgot_password_screen.dart';
import 'package:inovest/presentation/home_screen/screens/entrepreneur_home_screen.dart';
import 'package:inovest/presentation/home_screen/screens/investor_home_screen.dart';
import 'package:inovest/presentation/profile_screen/screens/profile_screen.dart';
import 'package:inovest/presentation/reset_password/screens/reset_password_screen.dart';
import 'package:inovest/presentation/settings_screen/screens/settings_screen.dart';
import 'package:inovest/presentation/splash_screen/screens/splash_screen.dart';
import 'package:inovest/presentation/payment_screen/screens/payment_screen.dart';

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
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String payment = '/payment';

  static Map<String, Widget Function(BuildContext)> routes = {
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
    forgotPassword: (context) => const ForgotPasswordScreen(),
    resetPassword: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      final token = args is String ? args : '';
      return ResetPasswordScreen(token: token);
    },
    payment: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args == null || args is! Map<String, dynamic>) {
        return PaymentScreen(
          amount: 0.0,
          userId: '',
          projectId: '',
        );
      }
      
      final Map<String, dynamic> arguments = args;
      return PaymentScreen(
        amount: arguments['amount'] as double? ?? 0.0,
        userId: arguments['userId'] as String? ?? '',
        projectId: arguments['projectId'] as String? ?? '',
      );
    },
  };
}
