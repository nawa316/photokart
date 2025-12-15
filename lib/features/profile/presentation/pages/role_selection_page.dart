import 'package:flutter/material.dart';

class RoleSelectionPage extends StatelessWidget {
  final String initialRole;

  const RoleSelectionPage({
    super.key,
    required this.initialRole,
  });

  void _selectRole(BuildContext context, String role) {
    Navigator.pop(context, role);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFE),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose your role',
                style: TextStyle(
                  color: Color(0xFF304369),
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),
              _RoleCard(
                title: 'Seller',
                isSelected: initialRole == 'Seller',
                onTap: () => _selectRole(context, 'Seller'),
                gradient: const LinearGradient(
                  colors: [Color(0xFFDDEEFF), Color(0xFFEAF4FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              const SizedBox(height: 16),
              _RoleCard(
                title: 'Buyer',
                isSelected: initialRole == 'Buyer',
                onTap: () => _selectRole(context, 'Buyer'),
                gradient: const LinearGradient(
                  colors: [Color(0xFFEAE4FF), Color(0xFFF5E9FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final Gradient gradient;

  const _RoleCard({
    required this.title,
    required this.isSelected,
    required this.onTap,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: gradient,
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A7B95CF),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
          border: isSelected
              ? Border.all(color: const Color(0xFF7B95CF), width: 1.5)
              : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF304369).withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_outline,
                size: 18,
                color: Color(0xFF304369),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF304369),
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: Color(0xFF304369),
            ),
          ],
        ),
      ),
    );
  }
}
