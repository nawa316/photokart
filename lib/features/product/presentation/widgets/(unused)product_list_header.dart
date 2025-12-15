import 'package:flutter/material.dart';

class ProductListHeader extends StatelessWidget {
  const ProductListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;

    final horizontalPadding = w * 0.06;
    final topPadding = MediaQuery.of(context).padding.top + w * 0.04;

    return Container(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        topPadding,
        horizontalPadding,
        w * 0.05,
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
          Text(
            'PhotoKart',
            style: TextStyle(
              color: const Color(0xFF304369),
              fontSize: w * 0.09,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: w * 0.03),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).maybePop();
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back_ios_new,
                      size: w * 0.045,
                      color: const Color(0xFF7B95CF),
                    ),
                    SizedBox(width: w * 0.01),
                    Text(
                      'Back',
                      style: TextStyle(
                        color: const Color(0xFF7B95CF),
                        fontSize: w * 0.04,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: w * 0.03),
              Expanded(
                child: Container(
                  height: w * 0.11,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFF7B95CF),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: w * 0.03),
                      Icon(
                        Icons.search,
                        size: w * 0.045,
                        color: const Color(0xFF7B95CF),
                      ),
                      SizedBox(width: w * 0.02),
                      Expanded(
                        child: Text(
                          'Search photocards',
                          style: TextStyle(
                            fontSize: w * 0.035,
                            color: const Color(0xFF7B95CF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: w * 0.03),
              Container(
                width: w * 0.11,
                height: w * 0.11,
                decoration: BoxDecoration(
                  color: const Color(0xFF7B95CF),
                  borderRadius: BorderRadius.circular(w * 0.055),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: w * 0.06,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
