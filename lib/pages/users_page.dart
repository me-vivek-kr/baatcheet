import 'package:baatcheet/models/chat_user.dart';
import 'package:baatcheet/providers/user_page_Provider.dart';
import 'package:baatcheet/widgets/custom_input_field.dart';
import 'package:baatcheet/widgets/custom_listViewTile.dart';
import 'package:baatcheet/widgets/topbar.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:baatcheet/providers/authentication_provider.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late double deviceHeight;
  late double deviceWidth;

  late AuthenticationProvider _auth;
  late UsersPageProvider _pageProvider;

  final TextEditingController _searchFieldTextEditingController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    _auth = Provider.of<AuthenticationProvider>(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UsersPageProvider>(
          create: (_) => UsersPageProvider(_auth),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(
      builder: (BuildContext context) {
        _pageProvider = context.watch<UsersPageProvider>();
        return Container(
          padding: EdgeInsets.symmetric(
              horizontal: deviceWidth * 0.03, vertical: deviceHeight * 0.02),
          height: deviceHeight * 0.98,
          width: deviceWidth * 0.97,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Topbar(
                "Users",
                fontSize: 30,
                primaryAction: IconButton(
                  onPressed: () {
                    _auth.logout();
                  },
                  icon: Icon(
                    Icons.logout,
                    color: Color.fromRGBO(0, 82, 218, 1.0),
                  ),
                ),
              ),
              CustomTextField(
                onEditingComplete: (value) {
                  _pageProvider.getUsers(name: value);
                  FocusScope.of(context).unfocus();
                },
                hintText: "Search...",
                obscureText: false,
                controller: _searchFieldTextEditingController,
                icon: Icons.search,
              ),
              _userList(),
              createChatButton(),
            ],
          ),
        );
      },
    );
  }

  Widget _userList() {
    List<ChatUser>? _users = _pageProvider.users;
    return Expanded(
      child: () {
        if (_users != null) {
          if (_users.length != 0) {
            return ListView.builder(
              itemCount: _users.length,
              itemBuilder: (BuildContext _context, int index) {
                return CustomListViewTile(
                  height: deviceHeight * .10,
                  title: _users[index].name,
                  subtitle: "Last_Active: ${_users[index].lastDayActive()}",
                  imagePath: _users[index].image,
                  isActive: _users[index].wasRecentlyActive(),
                  isSelected:
                      _pageProvider.selectedUsers.contains(_users[index]),
                  onTap: () {
                    _pageProvider.updateSelectedUsers(_users[index]);
                  },
                );
              },
            );
          } else {
            return Center(
              child: Text(
                "No Users Found",
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

  Widget createChatButton() {
    return Visibility(
      visible: _pageProvider.selectedUsers.isNotEmpty,
      child: ElevatedButton(
        onPressed: _pageProvider.createChat,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromRGBO(0, 82, 218, 0.5),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: Text(
          _pageProvider.selectedUsers.length == 1
              ? "Chat With ${_pageProvider.selectedUsers.first.name}"
              : "Create Group Chat",
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
