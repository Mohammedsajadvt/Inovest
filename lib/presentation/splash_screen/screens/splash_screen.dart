import '../index.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<void> _checkLoginStatus(BuildContext context) async {
    SecureStorage secureStorage = SecureStorage();

    String? token = await secureStorage.getToken();
    String? role = await secureStorage.getRole();

    if (!context.mounted) return;

    if (token != null && token.isNotEmpty) {
      if (role == "INVESTOR") {
        Navigator.pushReplacementNamed(context, '/investorHome');
      } else if (role == "ENTREPRENEUR") {
        Navigator.pushReplacementNamed(context, '/entrepreneurHome');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/landing');
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      _checkLoginStatus(context);
    });

    return Scaffold(
      backgroundColor: AppArray().colors[0],
      body: Center(
        child: Image.asset(ImageAssets.splashScreenLogo),
      ),
    );
  }
}
