<<<<<<< HEAD
import 'package:inovest/business_logics/auth/auth_bloc.dart';
import 'package:inovest/business_logics/checkbox/check_box_bloc.dart';
import 'package:inovest/core/utils/app_routes.dart';
import 'package:inovest/data/services/auth_service.dart';
import '/core/utils/index.dart';

void main()  {
  final AuthService authService = AuthService();
=======
// import 'package:firebase_core/firebase_core.dart';
import 'package:inovest/business_logics/checkbox/check_box_bloc.dart';
import 'package:inovest/core/utils/app_routes.dart';
// import 'package:inovest/firebase_options.dart';
import '/core/utils/index.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
>>>>>>> 30ca87d6817116739782f7d1759198a2e6408e42
  runApp(
    MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) => ThemeBloc(),
      ),
      BlocProvider(
        create: (context) => CheckBoxBloc(),
      ),
      BlocProvider(
        create: (context) => AuthBloc(authService: authService),
      ),
    ], child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: MediaQuery.of(context).size,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: state.themeData,
              home: child,
              initialRoute: AppRoutes.chats,
              routes: AppRoutes.routes,
            );
          },
        );
      },
    );
  }
}
