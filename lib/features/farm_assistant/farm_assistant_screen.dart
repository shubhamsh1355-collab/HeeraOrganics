import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
  });
}

class FarmAssistantScreen extends StatefulWidget {
  const FarmAssistantScreen({super.key});

  @override
  State<FarmAssistantScreen> createState() => _FarmAssistantScreenState();
}

class _FarmAssistantScreenState extends State<FarmAssistantScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Namaskara! I am your Heera Organics Farm Assistant. Ask me about seasonal vegetable availability, our chemical-free soil practices, or storage advice for your basket.',
      isUser: false,
      time: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
  ];

  final List<String> _suggestedPrompts = [
    'What veggies are harvested today?',
    'Why is A2 Gir milk better?',
    'How to store palak without plastic?',
    'Are these tomatoes pesticide free?',
  ];

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(text: text.trim(), isUser: true, time: DateTime.now()),
      );
    });
    _messageController.clear();

    // Simulated Agronomist Response
    Future.delayed(const Duration(milliseconds: 600), () {
      String response =
          'Our Kalaburagi farm cluster harvests all greens and country tomatoes at 5:00 AM daily. We use strictly cow-based jeevamrutha and zero synthetic sprays!';
      if (text.toLowerCase().contains('milk')) {
        response = 'Our A2 Gir cow milk comes from indigenous grass-fed cattle. It is unadulterated, unpasteurized, and delivered cold in reusable glass bottles within 3 hours of morning milking.';
      } else if (text.toLowerCase().contains('store') ||
          text.toLowerCase().contains('palak')) {
        response = 'To keep leafy palak crisp, wrap it loosely in a damp cotton cloth or airtight glass box in your vegetable crisper. It stays garden-fresh for up to 4 days!';
      }

      setState(() {
        _messages.add(
          ChatMessage(text: response, isUser: false, time: DateTime.now()),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                color: AppColors.softGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.psychology,
                size: 18,
                color: AppColors.primaryContainer,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Farm Agronomist', style: AppTypography.titleCard()),
                Text(
                  'Demonstration Prototype',
                  style: AppTypography.labelSm(color: AppColors.mutedText),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Prototype banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            color: AppColors.secondaryContainer.withValues(alpha: 0.4),
            child: Text(
              'Sample responses for farm questions. Live AI backend connects in future release.',
              style: AppTypography.labelSm(color: AppColors.deepText),
              textAlign: TextAlign.center,
            ),
          ),

          // Message List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment: msg.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.78,
                    ),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: msg.isUser
                          ? AppColors.primaryContainer
                          : AppColors.whiteSurface,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(msg.isUser ? 16 : 4),
                        bottomRight: Radius.circular(msg.isUser ? 4 : 16),
                      ),
                      border: msg.isUser
                          ? null
                          : Border.all(color: AppColors.borderSubtle),
                    ),
                    child: Text(
                      msg.text,
                      style: msg.isUser
                          ? AppTypography.bodyMd(color: Colors.white)
                          : AppTypography.bodyMd(color: AppColors.deepText),
                    ),
                  ),
                );
              },
            ),
          ),

          // Suggested Prompts
          SizedBox(
            height: 36,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _suggestedPrompts.length,
              itemBuilder: (context, index) {
                final prompt = _suggestedPrompts[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    label: Text(prompt, style: AppTypography.labelSm()),
                    backgroundColor: AppColors.whiteSurface,
                    side: const BorderSide(color: AppColors.borderSubtle),
                    onPressed: () => _sendMessage(prompt),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // Input Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.whiteSurface,
              border: Border(top: BorderSide(color: AppColors.borderSubtle)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Ask about crops, A2 milk or recipes…',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: AppColors.primaryContainer,
                    ),
                    onPressed: () => _sendMessage(_messageController.text),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
