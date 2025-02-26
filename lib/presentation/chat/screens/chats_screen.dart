import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovest/business_logics/chat/chat_bloc.dart';
import 'package:inovest/core/common/app_array.dart';
import 'package:inovest/core/app_settings/secure_storage.dart';
import '../layouts/chat_list_item.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndLoadChats();
  }

  Future<void> _checkAuthAndLoadChats() async {
    final token = await SecureStorage().getToken();
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
        title: const Text('Chats'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBar(
              hintText: 'Search',
              leading: const Icon(Icons.search),
              backgroundColor: WidgetStateProperty.all(AppArray().colors[1]),
            ),
          ),
        ),
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatsLoaded) {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.chats.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                return ChatListItem(chat: state.chats[index]);
              },
            );
          } else if (state is ChatError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
} 