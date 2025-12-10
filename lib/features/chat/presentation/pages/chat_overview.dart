import 'package:flutter/material.dart';
import '../../../../core/widgets/bottom_navbar.dart';
import '../widgets/chat_header.dart';
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

  // List of messages
  final List<ChatMessage> _messages = [
    ChatMessage(
      username: 'fani_kpoplover',
      message: 'Halo kak, Stock buat PC yang ini masih ada ga yaa?',
      time: '12:35 PM',
      unreadCount: 2,
      platformKey: _kShopeePlatform,
    ),
    ChatMessage(
      username: 'nadya.vibes',
      message: 'sama untuk photocard yang ini masih ada ga ya? terus pengiriman pake Sicepat ke...',
      time: '12:22 PM',
      unreadCount: 0,
      platformKey: _kTokopediaPlatform,
    ),
    ChatMessage(
      username: 'putri.pjms',
      message: 'Kak, ini photocard Jaehyun masih ada? Pengiriman ke Jakarta pakai J&T bisa...',
      time: '10:35 AM',
      unreadCount: 1,
      platformKey: _kTwitterPlatform,
    ),
    ChatMessage(
      username: 'citraa_0406',
      message: 'Halo kak, aku minat sama photocard ini. Masih stok ga ya? Kirim ke Padang...',
      time: '09:25 AM',
      unreadCount: 0,
      platformKey: _kShopeePlatform,
    ),
    ChatMessage(
      username: 'ilhamtzy',
      message: 'Masih ada kak! Kalau butuh bantuan buat order, boleh chat sini aja 🛒',
      time: 'Yesterday',
      unreadCount: 0,
      platformKey: _kTwitterPlatform,
    ),
    ChatMessage(
      username: 'sheilabts',
      message: 'Kak, ini masih tersedia ya. Kalau order hari ini bisa langsung dikirim besok 🙌',
      time: 'Yesterday',
      unreadCount: 0,
      platformKey: _kTokopediaPlatform,
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
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];

                if (_filter != 'All' && message.platformKey != _filter) {
                  return Container();
                }
                if (_readFilter == 'Read' && message.unreadCount > 0) return Container();
                if (_readFilter == 'Unread' && message.unreadCount == 0) return Container();

                return ChatMessageTile(
                  username: message.username,
                  message: message.message,
                  time: message.time,
                  unreadCount: message.unreadCount,
                  platformKey: message.platformKey,
                );
              },
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
  final String username;
  final String message;
  final String time;
  final int unreadCount;
  final String platformKey;

  const ChatMessageTile({
    super.key,
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
        // Handle tap
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