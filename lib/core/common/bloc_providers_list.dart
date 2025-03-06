import 'package:inovest/business_logics/chat/chat_bloc.dart';
import 'package:inovest/business_logics/role/role_bloc.dart';
import 'package:inovest/core/utils/index.dart';
import 'package:inovest/data/services/chat_service.dart';

class BlocProvidersList{
  
  final AuthService authService = AuthService();
  final EntrepreneurService entrepreneurService = EntrepreneurService();
  final ProfileService profileService = ProfileService();
  final InvestorService investorService = InvestorService();
  final ChatService chatService = ChatService();
   List<BlocProvider> getAllProviders(){
    return [
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
        BlocProvider(create: (context)=> RoleBloc()),
    ];
  }
}