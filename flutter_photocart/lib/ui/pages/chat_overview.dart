import 'package:flutter/material.dart';

class ChatOverviewPage extends StatefulWidget {
  const ChatOverviewPage({super.key});

  @override
  _ChatOverviewPageState createState() => _ChatOverviewPageState();
}

class _ChatOverviewPageState extends State<ChatOverviewPage> {
  int _currentIndex = 3;  // Set chat to 4th item (index 3)
  String _filter = 'All'; // Default filter for messages
  String _sort = 'Latest'; // Default sort option
  String _readFilter = 'All'; // Default read/unread filter

  // List of messages
  final List<ChatMessage> _messages = [
    ChatMessage(
      username: 'fani_kpoplover',
      message: 'Halo kak, Stock buat PC yang ini masih ada ga yaa?',
      time: '12:35 PM',
      unreadCount: 2,
      backgroundColor: Colors.pink[50]!, // Shopee pink
    ),
    ChatMessage(
      username: 'nadya.vibes',
      message: 'sama untuk photocard yang ini masih ada ga ya? terus pengiriman pake Sicepat ke...',
      time: '12:22 PM',
      unreadCount: 0,
      backgroundColor: Colors.purple[50]!, // Tokopedia purple
    ),
    ChatMessage(
      username: 'putri.pjms',
      message: 'Kak, ini photocard Jaehyun masih ada? Pengiriman ke Jakarta pakai J&T bisa...',
      time: '10:35 AM',
      unreadCount: 1,
      backgroundColor: Colors.blue[50]!, // Twitter blue
    ),
    ChatMessage(
      username: 'citraa_0406',
      message: 'Halo kak, aku minat sama photocard ini. Masih stok ga ya? Kirim ke Padang...',
      time: '09:25 AM',
      unreadCount: 0,
      backgroundColor: Colors.pink[50]!, // Shopee pink
    ),
    ChatMessage(
      username: 'ilhamtzy',
      message: 'Masih ada kak! Kalau butuh bantuan buat order, boleh chat sini aja 🛒',
      time: 'Yesterday',
      unreadCount: 0,
      backgroundColor: Colors.blue[50]!, // Twitter blue
    ),
    ChatMessage(
      username: 'sheilabts',
      message: 'Kak, ini masih tersedia ya. Kalau order hari ini bisa langsung dikirim besok 🙌',
      time: 'Yesterday',
      unreadCount: 0,
      backgroundColor: Colors.purple[50]!, // Tokopedia purple
    ),
  ];

  // Handle bottom navigation bar tap
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // Handle the platform filter changes
  void _onFilterChanged(String? value) {
    setState(() {
      _filter = value ?? 'All';
    });
  }

  // Handle the sort changes
  void _onSortChanged(String? value) {
    setState(() {
      _sort = value ?? 'Latest';
    });
  }

  // Handle the read/unread filter changes
  void _onReadFilterChanged(String? value) {
    setState(() {
      _readFilter = value ?? 'All';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("< Back"),
        backgroundColor: Colors.white, // White background for the header
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.lightBlue),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Header with separate filters (side by side)
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white, // White background
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Platform filter (Shopee, Tokopedia, Twitter)
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.pink[50], // Light pink background
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: _filter,
                    items: [
                      DropdownMenuItem<String>(
                        value: 'All',
                        child: Text('All',
                                  style: TextStyle(color: Colors.blueGrey), // Light blue text

                        ),
                        
                            

                      ),
                      DropdownMenuItem<String>(
                        value: 'Shopee',
                        child: Text('Shopee',
                                  style: TextStyle(color: Colors.lightBlue), // Light blue text
),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Tokopedia',
                        child: Text('Tokopedia',
                                  style: TextStyle(color: Colors.lightBlue), // Light blue text
),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Twitter',
                        child: Text('Twitter',
                                  style: TextStyle(color: Colors.blueGrey), // Light blue text
),
                      ),
                    ],
                    onChanged: _onFilterChanged,
                    hint: Text('Platform'),
                    underline: Container(), // Remove underline
                    isExpanded: false,
                    icon: Icon(Icons.filter_list),
                  ),
                ),

                // Sort filter (Latest/Oldest)
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.pink[50], // Light pink background
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: _sort,
                    items: [
                      DropdownMenuItem<String>(
                        value: 'Latest',
                        child: Text('Latest',style: TextStyle(color: Colors.blueGrey),),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Oldest',
                        child: Text('Oldest'),
                      ),
                    ],
                    onChanged: _onSortChanged,
                    hint: Text('Sort'),
                    underline: Container(), // Remove underline
                    isExpanded: false,
                    icon: Icon(Icons.sort),
                  ),
                ),

                // Read/Unread filter
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.pink[50], // Light pink background
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    value: _readFilter,
                    items: [
                      DropdownMenuItem<String>(
                        value: 'All',
                        child: Text('All',
                        style: TextStyle(color: Colors.blueGrey),),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Unread',
                        child: Text('Unread',
                        style: TextStyle(color: Colors.blueGrey),),
                      ),
                      DropdownMenuItem<String>(
                        value: 'Read',
                        child: Text('Read' ,
                        style: TextStyle(color: Colors.blueGrey),
                      ),)
                    ],
                    onChanged: _onReadFilterChanged,
                    hint: Text('Read/Unread'),
                    underline: Container(), // Remove underline
                    isExpanded: false,
                    icon: Icon(Icons.mark_chat_read),
                  ),
                ),
              ],
            ),
          ),

          // Chat list - scrollable
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];

                // Filtering the messages based on the filters
                if (_filter != 'All' && message.backgroundColor != _getBackgroundColorForFilter(_filter)) {
                  return Container(); // Skip messages if they don't match the platform filter
                }

                if (_readFilter == 'Read' && message.unreadCount > 0) {
                  return Container(); // Hide unread messages if "Read" filter is applied
                }

                if (_readFilter == 'Unread' && message.unreadCount == 0) {
                  return Container(); // Hide read messages if "Unread" filter is applied
                }

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
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Light blue background
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart, color: const Color.fromARGB(255, 123, 149, 206)),
            label: 'Shop',
          ),
          
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, color: const Color.fromARGB(255, 123, 149, 206)),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, color: const Color.fromARGB(255, 123, 149, 206)),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble, color: const Color.fromARGB(255, 123, 149, 206)),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: const Color.fromARGB(255, 123, 149, 206)),
            label: 'Settings',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  // Get background color based on filter (Shopee = pink, Tokopedia = purple, Twitter = blue)
  Color _getBackgroundColorForFilter(String filter) {
    switch (filter) {
      case 'Shopee':
        return Colors.pink[50]!;
      case 'Tokopedia':
        return Colors.purple[50]!;
      case 'Twitter':
        return Colors.blue[50]!;
      default:
        return Colors.white;
    }
  }
}

// Chat Message Model
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

// Chat Message Tile widget with background color
class ChatMessageTile extends StatelessWidget {
  final String username;
  final String message;
  final String time;
  final int unreadCount;
  final Color backgroundColor;

  const ChatMessageTile({
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
        // Handle tap event (e.g., open chat)
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 48, 68, 105),
              child: Icon(Icons.person, color: Colors.white),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Text(
                    message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            Text(time, style: TextStyle(color: Colors.black)),
            if (unreadCount > 0)
              Container(
                margin: EdgeInsets.only(left: 8),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 71, 30, 183),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$unreadCount',
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
