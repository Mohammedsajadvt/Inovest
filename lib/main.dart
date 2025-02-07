import 'package:inovest/business_logics/auth/auth_bloc.dart';
import 'package:inovest/business_logics/checkbox/check_box_bloc.dart';
import 'package:inovest/core/utils/app_routes.dart';
import 'package:inovest/data/services/auth_service.dart';
import '/core/utils/index.dart';

void main() {
  final AuthService authService = AuthService();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CheckBoxBloc(),
        ),
        BlocProvider(
          create: (context) => AuthBloc(authService: authService),
        ),
      ],
      child: MyApp(),
    ),
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
        return MaterialApp(
          theme: ThemeData(fontFamily: "JosefinSans",),
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          home: child,
          initialRoute: AppRoutes.investorHome,
          routes: AppRoutes.routes,
        );
      },
    );
  }
}
