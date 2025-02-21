import 'package:inovest/business_logics/auth/auth_bloc.dart';
import 'package:inovest/business_logics/category/category_bloc.dart';
import 'package:inovest/business_logics/checkbox/check_box_bloc.dart';
import 'package:inovest/business_logics/ideas/ideas_bloc.dart';
import 'package:inovest/business_logics/investor_ideas/investor_ideas_bloc.dart';
import 'package:inovest/business_logics/profile/profile_bloc.dart';
import 'package:inovest/core/common/app_array.dart';
import 'package:inovest/core/utils/app_routes.dart';
import 'package:inovest/data/services/auth_service.dart';
import 'package:inovest/data/services/entrepreneur_service.dart';
import 'package:inovest/data/services/investor_service.dart';
import 'package:inovest/data/services/profile_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/core/utils/index.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  final AuthService authService = AuthService();
  final EntrepreneurService entrepreneurService = EntrepreneurService();
  final ProfileService profileService = ProfileService();
  final InvestorService investorService = InvestorService();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CheckBoxBloc(),
        ),
        BlocProvider(
          create: (context) => AuthBloc(authService: authService),
        ),
        BlocProvider(
          create: (context) => IdeasBloc(entrepreneurService),
        ),
        BlocProvider(
          create: (context) => GetCategoriesBloc(entrepreneurService),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(profileService),
        ),
        BlocProvider(
          create: (context) => InvestorIdeasBloc(investorService),
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
          theme: ThemeData(
              fontFamily: "JosefinSans",
              textSelectionTheme:
                  TextSelectionThemeData(cursorColor: AppArray().colors[5])),
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          initialRoute: AppRoutes.splash,
          routes: AppRoutes.routes,
        );
      },
    );
  }
}
