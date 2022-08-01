import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nativ/bloc/profile/profile_bloc.dart';
import 'package:nativ/main.dart';
import 'package:nativ/view/widgets/bottom_nav_bar.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  types.User otherUser = const types.User(id: '20', firstName: 'Other');
  final List<types.Message> _messages = [];
  var user = const types.User(id: '', firstName: 'Chris');
  @override
  Widget build(BuildContext context) {
    var senderSampleMessage = types.CustomMessage(
      id: 'message_id',
      author: otherUser,
    );
    _messages.add(senderSampleMessage);
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const CircularProgressIndicator();
        }
        if (state is ProfileLoaded) {
          user = types.User(id: state.user.id!, firstName: state.user.name);
          print('${state.user.email!} loaded');

          String randomString() {
            final random = Random.secure();
            final values = List<int>.generate(16, (i) => random.nextInt(255));
            return base64UrlEncode(values);
          }

          void _addMessage(types.Message message) {
            setState(() {
              _messages.insert(0, message);
            });
          }

          void _handlePreviewDataFetched(
            types.TextMessage message,
            types.PreviewData previewData,
          ) {
            final index =
                _messages.indexWhere((element) => element.id == message.id);
            final updatedMessage =
                (_messages[index] as types.TextMessage).copyWith(
              previewData: previewData,
            );

            setState(() {
              _messages[index] = updatedMessage;
            });
          }

          void _handleSendPressed(types.PartialText message) {
            final textMessage = types.TextMessage(
              author: user,
              createdAt: DateTime.now().toLocal().millisecondsSinceEpoch,
              id: randomString(),
              text: message.text,
            );

            _addMessage(textMessage);
          }

          return Scaffold(
            appBar: const PreferredSize(
                preferredSize: Size.fromHeight(60), child: MainAppBar()),
            bottomNavigationBar: BottomNavBar(index: 0),
            body: Chat(
              theme: DefaultChatTheme(
                  sendButtonIcon: const CircleAvatar(
                    radius: 60,
                    child: Icon(
                      FontAwesomeIcons.paperPlane,
                      size: 14,
                    ),
                  ),
                  inputTextColor: Colors.black87,
                  primaryColor: const Color(0xFFf37d64),
                  //inputMargin: const EdgeInsets.only(bottom: 16),
                  sentMessageLinkTitleTextStyle: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                  sentMessageLinkDescriptionTextStyle:
                      Theme.of(context).textTheme.bodyMedium!,
                  sentMessageBodyTextStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white),
                  inputTextDecoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide:
                              const BorderSide(style: BorderStyle.none))),
                  deliveredIcon: const Icon(
                    Icons.check,
                    color: Colors.blueAccent,
                  )),
              showUserNames: true,
              messages: _messages,
              onSendPressed: _handleSendPressed,
              user: user,
              onPreviewDataFetched: _handlePreviewDataFetched,
            ),
          );
        }
        return const Center(
          child: Text('Something Went Wrong...'),
        );
      },
    );
  }
}
