import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/datasources/chat_remote_datasource.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/entities/message.dart' as chat_entity;

class ChatDetailPage extends StatefulWidget {
  final String conversationId;
  final String username;
  final String platformKey;

  const ChatDetailPage({
    super.key,
    required this.conversationId,
    required this.username,
    required this.platformKey,
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final ChatRepositoryImpl _chatRepository;
  
  List<chat_entity.Message> _messages = [];
  bool _isLoading = true;
  bool _isSending = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Initialize repository
    final dataSource = ChatRemoteDataSourceImpl(
      supabaseClient: Supabase.instance.client,
    );
    _chatRepository = ChatRepositoryImpl(remoteDataSource: dataSource);
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final messages = await _chatRepository.getMessages(widget.conversationId);
      
      setState(() {
        _messages = messages;
        _isLoading = false;
      });

      // Mark messages as read
      await _chatRepository.markAsRead(widget.conversationId);

      // Scroll to bottom after loading
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load messages: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _isSending) return;

    final messageText = _messageController.text;
    _messageController.clear();

    try {
      setState(() {
        _isSending = true;
      });

      final newMessage = await _chatRepository.sendMessage(
        conversationId: widget.conversationId,
        text: messageText,
      );

      setState(() {
        _messages.add(newMessage);
        _isSending = false;
      });

      // Scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      setState(() {
        _isSending = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: $e')),
        );
      }
      
      // Restore text if failed
      _messageController.text = messageText;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF304369)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF304369),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.person_outline,
                color: Color(0xFF304369),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.username,
                    style: const TextStyle(
                      color: Color(0xFF304369),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    'Last seen 3 hours ago',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _errorMessage!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadMessages,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : _messages.isEmpty
                        ? const Center(
                            child: Text(
                              'No messages yet. Start the conversation!',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount: _messages.length,
                            itemBuilder: (context, index) {
                              final message = _messages[index];
                              return MessageBubble(
                                message: message.text,
                                isSentByMe: message.isSentByMe,
                                timestamp: message.sent,
                                isRead: message.isRead,
                              );
                            },
                          ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.camera_alt_outlined, color: Colors.grey),
              onPressed: () {
                // Handle camera
              },
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message here...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
              onPressed: () {
                // Handle emoji
              },
            ),
            _isSending
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : IconButton(
                    icon: const Icon(Icons.send, color: Color(0xFF304369)),
                    onPressed: _sendMessage,
                  ),
          ],
        ),
      ),
    );
  }
}

class ChatDetailMessage {
  final String message;
  final bool isSentByMe;
  final DateTime timestamp;

  ChatDetailMessage({
    required this.message,
    required this.isSentByMe,
    required this.timestamp,
  });
}

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isSentByMe;
  final DateTime timestamp;
  final bool isRead;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isSentByMe,
    required this.timestamp,
    this.isRead = false,
  });

  String _formatTime(DateTime time) {
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    final displayHour = time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
    return '${displayHour.toString().padLeft(2, '0')}:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          // Timestamp
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              margin: const EdgeInsets.only(bottom: 8),
              child: Text(
                'Today, ${_formatTime(timestamp)}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                ),
              ),
            ),
          ),
          // Message bubble
          Row(
            mainAxisAlignment:
                isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isSentByMe) const SizedBox(width: 50),
              Flexible(
                child: Column(
                  crossAxisAlignment: isSentByMe 
                      ? CrossAxisAlignment.end 
                      : CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: isSentByMe
                            ? const LinearGradient(
                                colors: [Color(0xFFFCDFF5), Color(0xFFF9F1F6)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : const LinearGradient(
                                colors: [Color(0xFFC2E7FF), Color(0xFFE3F2FD)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: Radius.circular(isSentByMe ? 16 : 4),
                          bottomRight: Radius.circular(isSentByMe ? 4 : 16),
                        ),
                      ),
                      child: Text(
                        message,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    // Read indicator (checkmark) for sent messages
                    if (isSentByMe)
                      Padding(
                        padding: const EdgeInsets.only(top: 4, right: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isRead ? Icons.done_all : Icons.done,
                              size: 14,
                              color: isRead 
                                  ? const Color(0xFF4CAF50) // Green for read
                                  : Colors.grey, // Grey for sent
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isRead ? 'Read' : 'Sent',
                              style: TextStyle(
                                fontSize: 10,
                                color: isRead 
                                    ? const Color(0xFF4CAF50)
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              if (!isSentByMe) const SizedBox(width: 50),
            ],
          ),
        ],
      ),
    );
  }
}
