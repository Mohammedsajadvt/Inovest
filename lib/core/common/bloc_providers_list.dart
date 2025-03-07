import 'package:inovest/business_logics/chat/chat_bloc.dart';
import 'package:inovest/business_logics/role/role_bloc.dart';
import 'package:inovest/core/utils/index.dart';
import 'package:inovest/data/services/chat_service.dart';

class BlocProvidersList {
  final AuthService authService = AuthService();
  final EntrepreneurService entrepreneurService = EntrepreneurService();
  final ProfileService profileService = ProfileService();
  final InvestorService investorService = InvestorService();
  final ChatService chatService = ChatService();
  List<BlocProvider> getAllProviders() {
    return [
      BlocProvider<CheckBoxBloc>(create: (_) => CheckBoxBloc()),
      BlocProvider<AuthBloc>(create: (_) => AuthBloc(authService: authService)),
      BlocProvider<IdeasBloc>(create: (_) => IdeasBloc(entrepreneurService)),
      BlocProvider<GetCategoriesBloc>(
          create: (_) => GetCategoriesBloc(entrepreneurService)),
      BlocProvider<ProfileBloc>(create: (_) => ProfileBloc(profileService)),
      BlocProvider<InvestorIdeasBloc>(
          create: (_) => InvestorIdeasBloc(investorService)),
      BlocProvider<EntrepreneurIdeasBloc>(
        create: (_) => EntrepreneurIdeasBloc(
          entrepreneurService: EntrepreneurService(),
        ),
      ),
      BlocProvider<ChatBloc>(create: (_) => ChatBloc(chatService)),
      BlocProvider<RoleBloc>(create: (_) => RoleBloc()),
    ];
  }
}
