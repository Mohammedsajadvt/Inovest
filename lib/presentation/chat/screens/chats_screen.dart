import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovest/business_logics/chat/chat_bloc.dart';
import 'package:inovest/business_logics/role/role_bloc.dart'; // Import RoleBloc
import 'package:inovest/core/app_settings/secure_storage.dart';
import 'package:inovest/core/common/app_array.dart';
import 'package:inovest/core/utils/user_utils.dart';
import '../layouts/chat_list_item.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndLoadChats();
    context.read<RoleBloc>().add(LoadRole());
  }

  Future<void> _checkAuthAndLoadChats() async {
    final token = await UserUtils.getToken();
    if (token == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please login to view chats'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      if (mounted) {
        context.read<ChatBloc>().add(LoadChats());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back)),
        backgroundColor: AppArray().colors[1],
        title: const Text('Chats'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocBuilder<RoleBloc, RoleState>(
              builder: (context, roleState) {
                Color bgColor;
                if (roleState is RoleLoading || roleState is RoleInitial) {
                  bgColor = AppArray().colors[1]; 
                } else if (roleState is RoleLoaded) {
                  bgColor = roleState.role == 'INVESTOR'
                      ? AppArray().colors[0]
                      : AppArray().colors[2];
                } else {
                  bgColor = AppArray().colors[1];
                }
                return SearchBar(
                  hintText: 'Search',
                  hintStyle: WidgetStateProperty.all(TextStyle(color: AppArray().colors[1])),
                  leading:  Icon(Icons.search,color: AppArray().colors[1],),
                  backgroundColor: WidgetStateProperty.all(bgColor),
                );
              },
            ),
          ),
        ),
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, chatState) {
          if (chatState is ChatsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (chatState is ChatsLoaded) {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: chatState.chats.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return ChatListItem(chat: chatState.chats[index]);
              },
            );
          } else if (chatState is ChatError) {
            return Center(child: Text(chatState.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}