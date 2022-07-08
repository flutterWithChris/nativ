import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart' hide List;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<types.Message> _messages = [];
  var user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');
  @override
  Widget build(BuildContext context) {
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
      final index = _messages.indexWhere((element) => element.id == message.id);
      final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
        previewData: previewData,
      );

      setState(() {
        _messages[index] = updatedMessage;
      });
    }

    void _handleSendPressed(types.PartialText message) {
      final textMessage = types.TextMessage(
        author: user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: randomString(),
        text: message.text,
      );

      _addMessage(textMessage);
    }

    return Chat(
      messages: _messages,
      onSendPressed: _handleSendPressed,
      user: user,
      onPreviewDataFetched: _handlePreviewDataFetched,
    );
  }
}
