import 'package:flutter/material.dart';
import '../../../../core/widgets/bottom_navbar.dart';

class ChatOverviewPage extends StatefulWidget {
  const ChatOverviewPage({super.key});

  @override
  _ChatOverviewPageState createState() => _ChatOverviewPageState();
}

class _ChatOverviewPageState extends State<ChatOverviewPage> {
  int _currentIndex = 3;  // Set chat to 4th item (index 3)
  String _filter = 'All'; 
  String _sort = 'Latest'; 
  String _readFilter = 'All'; 

  // List of messages
  final List<ChatMessage> _messages = [
    ChatMessage(
      username: 'fani_kpoplover',
      message: 'Halo kak, Stock buat PC yang ini masih ada ga yaa?',
      time: '12:35 PM',
      unreadCount: 2,
      backgroundColor: Colors.pink[50]!, 
    ),
    ChatMessage(
      username: 'nadya.vibes',
      message: 'sama untuk photocard yang ini masih ada ga ya? terus pengiriman pake Sicepat ke...',
      time: '12:22 PM',
      unreadCount: 0,
      backgroundColor: Colors.purple[50]!, 
    ),
    ChatMessage(
      username: 'putri.pjms',
      message: 'Kak, ini photocard Jaehyun masih ada? Pengiriman ke Jakarta pakai J&T bisa...',
      time: '10:35 AM',
      unreadCount: 1,
      backgroundColor: Colors.blue[50]!, 
    ),
    ChatMessage(
      username: 'citraa_0406',
      message: 'Halo kak, aku minat sama photocard ini. Masih stok ga ya? Kirim ke Padang...',
      time: '09:25 AM',
      unreadCount: 0,
      backgroundColor: Colors.pink[50]!, 
    ),
    ChatMessage(
      username: 'ilhamtzy',
      message: 'Masih ada kak! Kalau butuh bantuan buat order, boleh chat sini aja 🛒',
      time: 'Yesterday',
      unreadCount: 0,
      backgroundColor: Colors.blue[50]!, 
    ),
    ChatMessage(
      username: 'sheilabts',
      message: 'Kak, ini masih tersedia ya. Kalau order hari ini bisa langsung dikirim besok 🙌',
      time: 'Yesterday',
      unreadCount: 0,
      backgroundColor: Colors.purple[50]!, 
    ),
  ];

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
      appBar: AppBar(
        title: const Text("< Back", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.lightBlue),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Header with filters
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Platform filter
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.pink[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: _filter,
                    underline: Container(),
                    items: const [
                      DropdownMenuItem(value: 'All', child: Text('All', style: TextStyle(color: Colors.blueGrey))),
                      DropdownMenuItem(value: 'Shopee', child: Text('Shopee', style: TextStyle(color: Colors.lightBlue))),
                      DropdownMenuItem(value: 'Tokopedia', child: Text('Tokopedia', style: TextStyle(color: Colors.lightBlue))),
                      DropdownMenuItem(value: 'Twitter', child: Text('Twitter', style: TextStyle(color: Colors.blueGrey))),
                    ],
                    onChanged: _onFilterChanged,
                    icon: const Icon(Icons.filter_list),
                  ),
                ),

                // Sort filter
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(color: Colors.pink[50], borderRadius: BorderRadius.circular(8)),
                  child: DropdownButton<String>(
                    value: _sort,
                    underline: Container(),
                    items: const [
                      DropdownMenuItem(value: 'Latest', child: Text('Latest', style: TextStyle(color: Colors.blueGrey))),
                      DropdownMenuItem(value: 'Oldest', child: Text('Oldest')),
                    ],
                    onChanged: _onSortChanged,
                    icon: const Icon(Icons.sort),
                  ),
                ),

                // Read filter
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(color: Colors.pink[50], borderRadius: BorderRadius.circular(8)),
                  child: DropdownButton<String>(
                    value: _readFilter,
                    underline: Container(),
                    items: const [
                      DropdownMenuItem(value: 'All', child: Text('All', style: TextStyle(color: Colors.blueGrey))),
                      DropdownMenuItem(value: 'Unread', child: Text('Unread', style: TextStyle(color: Colors.blueGrey))),
                      DropdownMenuItem(value: 'Read', child: Text('Read', style: TextStyle(color: Colors.blueGrey))),
                    ],
                    onChanged: _onReadFilterChanged,
                    icon: const Icon(Icons.mark_chat_read),
                  ),
                ),
              ],
            ),
          ),

          // Chat list
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];

                // Filters
                if (_filter != 'All' && message.backgroundColor != _getBackgroundColorForFilter(_filter)) {
                  return Container();
                }
                if (_readFilter == 'Read' && message.unreadCount > 0) return Container();
                if (_readFilter == 'Unread' && message.unreadCount == 0) return Container();

                return ChatMessageTile(
                  username: message.username,
                  message: message.message,
                  time: message.time,
                  unreadCount: message.unreadCount,
                  backgroundColor: message.backgroundColor,
                );
              },
            ),
          ),
        ],
      ),
      
      // === THIS IS THE NEW NAVBAR BEING USED ===
      bottomNavigationBar: PhotoKartBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  Color _getBackgroundColorForFilter(String filter) {
    switch (filter) {
      case 'Shopee': return Colors.pink[50]!;
      case 'Tokopedia': return Colors.purple[50]!;
      case 'Twitter': return Colors.blue[50]!;
      default: return Colors.white;
    }
  }
}

// === MODEL CLASS ===
class ChatMessage {
  final String username;
  final String message;
  final String time;
  final int unreadCount;
  final Color backgroundColor;

  ChatMessage({
    required this.username,
    required this.message,
    required this.time,
    required this.unreadCount,
    required this.backgroundColor,
  });
}

// === TILE WIDGET CLASS ===
class ChatMessageTile extends StatelessWidget {
  final String username;
  final String message;
  final String time;
  final int unreadCount;
  final Color backgroundColor;

  const ChatMessageTile({
    super.key,
    required this.username,
    required this.message,
    required this.time,
    required this.unreadCount,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle tap
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Color.fromARGB(255, 48, 68, 105),
              child: Icon(Icons.person, color: Colors.white),
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
                      color: const Color.fromARGB(255, 71, 30, 183),
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