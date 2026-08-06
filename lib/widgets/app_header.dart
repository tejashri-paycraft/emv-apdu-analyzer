import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: AppTheme.background,
        border: Border(bottom: BorderSide(color: AppTheme.border)),
      ),
      child: Row(
        children: [
          //----------------------------------------
          // Logo
          //----------------------------------------
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [Color(0xff6366F1), Color(0xff8B5CF6)],
              ),
            ),
            child: const Icon(Icons.credit_card, color: Colors.white),
          ),

          const SizedBox(width: 16),

          //----------------------------------------
          // Title
          //----------------------------------------
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "EMV APDU Analyzer",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.text,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "EMV Level 2 Debugging Tool",
                style: TextStyle(fontSize: 14, color: AppTheme.subtitle),
              ),
            ],
          ),

          const Spacer(),

          //----------------------------------------
          // Theme Button
          //----------------------------------------
          //_HeaderButton(icon: Icons.dark_mode_outlined, onTap: () {}),

          // const SizedBox(width: 12),

          //----------------------------------------
          // Import
          //----------------------------------------
          // _ActionButton(
          //   icon: Icons.upload_file_outlined,
          //   title: "Import Log",
          //   onTap: () {},
          // ),
          // const SizedBox(width: 12),

          //----------------------------------------
          // Export
          //----------------------------------------
          // _ActionButton(
          //   icon: Icons.download_outlined,
          //   title: "Export",
          //   onTap: () {},
          // ),
          //  const SizedBox(width: 12),

          //----------------------------------------
          // Menu
          //----------------------------------------
          // _HeaderButton(icon: Icons.more_vert, onTap: () {}),
        ],
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppTheme.panel,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.border),
        ),
        child: Icon(icon, color: AppTheme.text),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(title),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.text,
        side: const BorderSide(color: AppTheme.border),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
