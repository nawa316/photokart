import 'package:flutter/material.dart';

class PhotoKartHeader extends StatelessWidget {
  const PhotoKartHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final paddingTop = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        18,
        paddingTop + 12, // biar aman dari status bar
        18,
        18,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFCFD5FF),
            Color(0xFFF7FAFE),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITLE
          const Text(
            'PhotoKart',
            style: TextStyle(
              color: Color(0xFF304369),
              fontSize: 24,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),

          // SEARCH BAR
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // TextField dengan hint di tengah
                TextField(
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    hintText: 'Search photocards',
                    hintStyle: TextStyle(
                      color: Color(0xFFB0B7D0),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                    ),
                    border: InputBorder.none,
                    // padding kiri-kanan dikasih longgar supaya
                    // teks tetap di tengah walau ada icon di kiri/kanan
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 48, vertical: 0),
                  ),
                  style: const TextStyle(
                    color: Color(0xFF304369),
                    fontSize: 12,
                    fontFamily: 'Poppins',
                  ),
                ),

                // ICON SEARCH DI KIRI
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Icon(
                      Icons.search,
                      size: 18,
                      color: Color(0xFF7B95CF),
                    ),
                  ),
                ),

                // ICON MIC DI KANAN (TANPA BACKGROUND)
                const Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Icon(
                      Icons.mic_none,
                      size: 18,
                      color: Color(0xFF7B95CF),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
