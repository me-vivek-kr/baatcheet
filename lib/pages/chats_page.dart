import 'package:baatcheet/models/chat_message.dart';
import 'package:baatcheet/pages/chat_page.dart';
import 'package:baatcheet/services/navigation_service.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:baatcheet/models/chat.dart';
import 'package:baatcheet/widgets/topbar.dart';
import 'package:baatcheet/models/chat_user.dart';
import 'package:baatcheet/widgets/custom_listViewTile.dart';
import 'package:baatcheet/providers/chatsPage_provider.dart';
import 'package:baatcheet/providers/authentication_provider.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  late double deviceHeight;
  late double deviceWidth;

  late AuthenticationProvider _auth;
  late NavigationService _navigation;
  late ChatsPageProvider _pageProvider;

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    _auth = Provider.of<AuthenticationProvider>(context);
    _navigation = GetIt.instance.get<NavigationService>();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatsPageProvider>(
          create: (_) => ChatsPageProvider(_auth),
        ),
      ],
      child: buildUI(),
    );
  }

  Widget buildUI() {
    return Builder(
      builder: (BuildContext context) {
        _pageProvider = context.watch<ChatsPageProvider>();
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: deviceWidth * 0.03,
            vertical: deviceHeight * 0.02,
          ),
          height: deviceHeight * 0.98,
          width: deviceWidth * 0.97,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Topbar(
                'Chats', // Pass the string title
                fontSize: 30,
                primaryAction: IconButton(
                  onPressed: () {
                    _auth.logout();
                  },
                  icon: const Icon(
                    Icons.logout,
                    color: Color.fromRGBO(0, 82, 218, 1.0),
                  ),
                ),
              ),
              _chatList(),
            ],
          ),
        );
      },
    );
  }

  Widget _chatList() {
    List<Chat>? _chats = _pageProvider.chats;
    return Expanded(
      child: () {
        if (_chats != null) {
          if (_chats.isNotEmpty) {
            return ListView.builder(
              itemCount: _chats.length,
              itemBuilder: (BuildContext _context, int _index) {
                return _chatTile(_chats[_index]);
              },
            );
          } else {
            return Center(
              child: Text(
                "No Chats Found",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      }(),
    );
  }

  Widget _chatTile(Chat _chat) {
    List<ChatUser> _recepients = _chat.recepients();
    bool _isActive = _recepients.any((d) => d.wasRecentlyActive());
    String _subtitleText = "";

    if (_chat.messages.isNotEmpty) {
      _subtitleText = _chat.messages.first.type != MessageType.TEXT
          ? "Media Attachement"
          : _chat.messages.first.content;
    }

    return CustomListViewTileWithActivity(
      height: deviceHeight * 0.10,
      title: _chat.title(),
      subtitle: _subtitleText,
      imagePath: _chat.imageURL(),
      isActive: _isActive,
      isActivity: _chat.activity,
      onTap: () {
        _navigation.navigateToPage(
          ChatPage(chat: _chat),
        );
      },
    );
  }
}
