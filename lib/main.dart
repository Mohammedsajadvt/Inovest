import '/core/utils/index.dart';
import 'package:inovest/firebase_options.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:inovest/business_logics/chat/chat_bloc.dart';
import 'package:inovest/data/services/chat_service.dart';
import 'package:inovest/core/services/deep_link_service.dart';


bool _isFirebaseInitialized = false;

Future<void> initializeFirebase() async {
  if (!_isFirebaseInitialized) {
    try {
      if (kIsWeb) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      } else {
        if (Platform.isAndroid) {
          await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          );
        } else if (Platform.isIOS) {
          await Firebase.initializeApp();
        }
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

  if (!kIsWeb) {
    await FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    final notificationService = NotificationService();
    notificationService.initialize();
  }

  final AuthService authService = AuthService();
  final EntrepreneurService entrepreneurService = EntrepreneurService();
  final ProfileService profileService = ProfileService();
  final InvestorService investorService = InvestorService();
  final ChatService chatService = ChatService();
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
        BlocProvider(create: (context) => ChatBloc(chatService)),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _initializeDeepLinks();
  }

  Future<void> _initializeDeepLinks() async {
    await Future.delayed(Duration.zero);
    if (!mounted) return;
    
    final context = _navigatorKey.currentContext;
    if (context != null) {
      await DeepLinkService.setupDeepLinks(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: MediaQuery.of(context).size,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          navigatorKey: _navigatorKey,
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