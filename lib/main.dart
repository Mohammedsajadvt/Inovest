import '/core/utils/index.dart';
import 'package:inovest/firebase_options.dart';


bool _isFirebaseInitialized = false;

Future<void> initializeFirebase() async {
  if (!_isFirebaseInitialized) {
    try {
      if (Platform.isAndroid) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      } else if (Platform.isIOS) {
        await Firebase.initializeApp();
      }
      _isFirebaseInitialized = true; 
    } catch (e) {
      if (e.toString().contains('duplicate-app')) {
        _isFirebaseInitialized = true;
      } else {
        rethrow; 
      }
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPreferences.getInstance();

  await initializeFirebase();

  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  final notificationService = NotificationService();
  notificationService.initialize();

  final AuthService authService = AuthService();
  final EntrepreneurService entrepreneurService = EntrepreneurService();
  final ProfileService profileService = ProfileService();
  final InvestorService investorService = InvestorService();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => CheckBoxBloc()),
        BlocProvider(create: (context) => AuthBloc(authService: authService)),
        BlocProvider(create: (context) => IdeasBloc(entrepreneurService)),
        BlocProvider(create: (context) => GetCategoriesBloc(entrepreneurService)),
        BlocProvider(create: (context) => ProfileBloc(profileService)),
        BlocProvider(create: (context) => InvestorIdeasBloc(investorService)),
        BlocProvider<EntrepreneurIdeasBloc>(
          create: (context) => EntrepreneurIdeasBloc(
            entrepreneurService: EntrepreneurService(),
          ),
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
            scaffoldBackgroundColor: AppArray().colors[1],
            fontFamily: "JosefinSans",
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: AppArray().colors[5],
            ),
          ),
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          initialRoute: AppRoutes.splash,
          routes: AppRoutes.routes,
        );
      },
    );
  }
}