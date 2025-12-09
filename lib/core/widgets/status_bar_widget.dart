import 'package:flutter/material.dart';

class StatusBarWidget extends StatelessWidget {
  const StatusBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 22,
      child: Row(
        children: [
          const Text(
            '9:41',
            style: TextStyle(
              color: Color(0xFF394265),
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
            ),
          ),
          const Spacer(),
          Row(
            children: const [
              Icon(
                Icons.signal_cellular_4_bar,
                size: 16,
                color: Color(0xFF394265),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.wifi,
                size: 16,
                color: Color(0xFF394265),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.battery_full,
                size: 18,
                color: Color(0xFF394265),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
