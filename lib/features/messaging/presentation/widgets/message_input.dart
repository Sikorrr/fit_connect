import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../constants/style_guide.dart';

class MessageInput extends StatefulWidget {
  final Function(String) onSend;

  const MessageInput({super.key, required this.onSend});

  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    final content = _controller.text.trim();
    if (content.isNotEmpty) {
      widget.onSend(content);
      _controller.clear();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.p8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "type_your_message".tr(),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
