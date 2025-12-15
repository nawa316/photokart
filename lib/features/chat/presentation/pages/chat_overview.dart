import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/widgets/bottom_navbar.dart';
import '../widgets/chat_header.dart';
import 'chat_detail_page.dart';
import '../../data/datasources/chat_remote_datasource.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/entities/conversation.dart';
// import '../widgets/chat_search_widget.dart';

const String _kTwitterPlatform = 'Twitter'; // Blue
const String _kTokopediaPlatform = 'Tokopedia'; // Purple
const String _kShopeePlatform = 'Shopee'; // Pink

final Map<String, List<Color>> _kPlatformGradients = {
  // Blue (Twitter): left: #c2e7ff, right: #85c8fc
  _kTwitterPlatform: [
    const Color(0xFFC2E7FF), // Start (Left)
    const Color(0xFF85C8FC), // End (Right)
  ],
  // Purple (Tokopedia): left: #f4eefa, right: #dad2ea
  _kTokopediaPlatform: [
    const Color(0xFFF4EEFA), // Start (Left)
    const Color(0xFFDAD2EA), // End (Right)
  ],
  // Pink (Shopee): left: #f9f1f6, right: #fcdff5
  _kShopeePlatform: [
    const Color(0xFFF9F1F6), // Start (Left)
    const Color(0xFFFCDFF5), // End (Right)
  ],
};

class ChatOverviewPage extends StatefulWidget {
  const ChatOverviewPage({super.key});

  @override
  _ChatOverviewPageState createState() => _ChatOverviewPageState();
}

class _ChatOverviewPageState extends State<ChatOverviewPage> {
  int _currentIndex = 3;  
  String _filter = 'All'; 
  String _sort = 'Latest'; 
  String _readFilter = 'All'; 

  late final ChatRepositoryImpl _chatRepository;
  List<Conversation> _conversations = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Initialize repository
    final dataSource = ChatRemoteDataSourceImpl(
      supabaseClient: Supabase.instance.client,
    );
    _chatRepository = ChatRepositoryImpl(remoteDataSource: dataSource);
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final conversations = await _chatRepository.getConversations();
      
      setState(() {
        _conversations = conversations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load conversations: $e';
        _isLoading = false;
      });
    }
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays == 0) {
      // Today - show time
      final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
      final period = dateTime.hour >= 12 ? 'PM' : 'AM';
      return '${hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} $period';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  // Handle bottom navigation bar tap
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // Handle filters
  void _onFilterChanged(String? value) {
    setState(() { _filter = value ?? 'All'; });
  }

  void _onSortChanged(String? value) {
    setState(() { _sort = value ?? 'Latest'; });
  }

  void _onReadFilterChanged(String? value) {
    setState(() { _readFilter = value ?? 'All'; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  
      body: Column(
        children: [
          ChatHeader(
          title: "", 
          showSearch: true, // Enables the search bar field
          backButtonOnPressed: () {
            // Makes the back button functional, navigating to the previous screen
            Navigator.of(context).pop(); 
          },
       
  
          searchHintText: "Search chat",
        ),
          // Header with filters
          Container(
            // padding: const EdgeInsets.all(16),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20), 

            // color: Colors.white,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade200, 
                  width: 1.0, 
                ),
              ),
            ),
            
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Platform filter
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 0),
                  decoration: BoxDecoration(
                    color: Colors.pink[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: _filter,
                    isDense: true,
                    underline: Container(),
                    iconSize: 20,
                    icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF304369)),

                    items: const [
                      DropdownMenuItem(value: 'All', child: Text('All', style: TextStyle(color: Colors.blueGrey))),
                      DropdownMenuItem(value: 'Shopee', child: Text('Shopee', style: TextStyle(color: Colors.blueGrey))),
                      DropdownMenuItem(value: 'Tokopedia', child: Text('Tokopedia', style: TextStyle(color: Colors.blueGrey))),
                      DropdownMenuItem(value: 'Twitter', child: Text('Twitter', style: TextStyle(color: Colors.blueGrey))),
                    ],
                    onChanged: _onFilterChanged,
                  ),
                ),
                const SizedBox(width: 8),

                // Sort filter
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  decoration: BoxDecoration(color: Colors.pink[50], borderRadius: BorderRadius.circular(8)),
                  child: DropdownButton<String>(
                    value: _sort,
                    isDense: true,
                    underline: Container(),
                    iconSize: 20,
                    icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF304369)),
                    items: const [
                      DropdownMenuItem(value: 'Latest', child: Text('Latest', style: TextStyle(color: Colors.blueGrey))),
                      DropdownMenuItem(value: 'Oldest', child: Text('Oldest')),
                    ],
                    onChanged: _onSortChanged,
                  ),
                ),
                const SizedBox(width: 8),


                // Read filter
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  decoration: BoxDecoration(color: Colors.pink[50], borderRadius: BorderRadius.circular(8)),
                  child: DropdownButton<String>(
                    value: _readFilter,
                    isDense: true,
                    underline: Container(),
                    iconSize: 20, 
                    icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF304369)),

                    items: const [
                      DropdownMenuItem(value: 'All', child: Text('All', style: TextStyle(color: Colors.blueGrey))),
                      DropdownMenuItem(value: 'Unread', child: Text('Unread', style: TextStyle(color: Colors.blueGrey))),
                      DropdownMenuItem(value: 'Read', child: Text('Read', style: TextStyle(color: Colors.blueGrey))),
                    ],
                    onChanged: _onReadFilterChanged,
                  ),
                ),
              ],
            ),
          ),

          // Chat list
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
                              onPressed: _loadConversations,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : _conversations.isEmpty
                        ? const Center(
                            child: Text(
                              'No conversations yet',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _loadConversations,
                            child: ListView.builder(
                              itemCount: _conversations.length,
                              itemBuilder: (context, index) {
                                final conversation = _conversations[index];
                                final platform = conversation.platform ?? 'Shopee';

                                // Apply filters
                                if (_filter != 'All' && platform != _filter) {
                                  return const SizedBox.shrink();
                                }
                                if (_readFilter == 'Read' && conversation.unreadCount > 0) {
                                  return const SizedBox.shrink();
                                }
                                if (_readFilter == 'Unread' && conversation.unreadCount == 0) {
                                  return const SizedBox.shrink();
                                }

                                return ChatMessageTile(
                                  conversationId: conversation.id,
                                  username: conversation.otherUserName ?? 'Unknown',
                                  message: conversation.lastMessage ?? 'No messages yet',
                                  time: _formatTime(conversation.lastMessageTime),
                                  unreadCount: conversation.unreadCount,
                                  platformKey: platform,
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
      
      bottomNavigationBar: PhotoKartBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}

class ChatMessage {
  final String username;
  final String message;
  final String time;
  final int unreadCount;
  final String platformKey;

  ChatMessage({
    required this.username,
    required this.message,
    required this.time,
    required this.unreadCount,
    required this.platformKey,});
}

// === TILE WIDGET CLASS ===
class ChatMessageTile extends StatelessWidget {
  final String conversationId;
  final String username;
  final String message;
  final String time;
  final int unreadCount;
  final String platformKey;

  const ChatMessageTile({
    super.key,
    required this.conversationId,
    required this.username,
    required this.message,
    required this.time,
    required this.unreadCount,
    required this.platformKey,
  });

  LinearGradient _getGradient(String key) {
    final colors = _kPlatformGradients[key] ?? [Colors.white, Colors.white]; 

    return LinearGradient(
      colors: colors,
      begin: Alignment.topLeft, 
      end: Alignment.bottomRight,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailPage(
              conversationId: conversationId,
              username: username,
              platformKey: platformKey,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 13, left: 20, right: 20),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: _getGradient(platformKey), // <-- ADD THIS LINE
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
              BoxShadow(
                  color: const Color.fromARGB(60, 0, 0, 0),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: const Offset(0, 2), 
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF304369), 
                  width: 2.5,
                ),
                color: Colors.transparent, 
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
                    username,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Text(
                    message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(time, style: const TextStyle(color: Colors.black, fontSize: 12)),
                if (unreadCount > 0)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 48, 68, 104),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('$unreadCount', style: const TextStyle(color: Colors.white, fontSize: 10)),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}