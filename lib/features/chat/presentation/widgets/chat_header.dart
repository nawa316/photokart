import 'package:flutter/material.dart';
import './chat_search_widget.dart'; 

class ChatHeader extends StatelessWidget {
  final String title; 
  final bool showSearch;
  final VoidCallback? backButtonOnPressed; 
  final String? searchHintText;

  const ChatHeader({
    super.key,
    required this.title,
    this.showSearch = false,
    this.backButtonOnPressed,
    this.searchHintText,
  });

  @override
  Widget build(BuildContext context) {
    final bool showMainRow = showSearch || backButtonOnPressed != null;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFF7FAFE), // RGB(247, 250, 254) - Light
            Color(0xFFEAE6F5), // RGB(234, 230, 245) - Pale Lavender
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border(
          bottom: BorderSide(
            color: Color.fromARGB(255, 67, 89, 133), // A deep blue color for the line
            width: 0.7, // A thin line (1.0 pixel thick)
          ),
        ),
      ),
      
      
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 18), 
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          if (showMainRow)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                
                if (backButtonOnPressed != null)
                  GestureDetector(
                    onTap: backButtonOnPressed,
                    child: const Padding(
                      padding: EdgeInsets.only(right: 10.0), // Space between button and search bar
                      child: Row(
                        children: [
                         
                          Icon(
                            Icons.chevron_left, 
                              color: Color(0xFF7B95CF),
                            size: 30, // Increased size to match the height of the text beside it
                          ),

                          Text(
                            'Back', // Display the text "Back"
                            style: TextStyle(
                              color: Color(0xFF7B95CF),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                if (showSearch)
                  Expanded(
                    child: SearchBarWidget( 
                      hintText: searchHintText,
                    ),
                  ),
              ],
            ),
            
        ],
      ),
    );
  }
}