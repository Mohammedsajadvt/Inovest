import '../index.dart';


class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        backgroundColor: AppArray().colors[1],
        body:CircleLayoutSignup(),
      ),
    );
  }
}