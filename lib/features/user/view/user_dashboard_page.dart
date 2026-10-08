import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:digital_oms_sheba/core/card_capture_widget/card_capture_page.dart';
import 'package:digital_oms_sheba/core/constant/colors_custom.dart';
import 'package:digital_oms_sheba/core/constant/navigation_custom.dart';
import 'package:flutter/material.dart';

class UserDashboardPage extends StatefulWidget {
  const UserDashboardPage({super.key});

  @override
  State<UserDashboardPage> createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends State<UserDashboardPage> {
  int _currentBottomNavIndex = 0;

  static const _phase = 'সেপ্টেম্বর - ২০২৬';
  static const _package = 'চাল, ডাল, চিনি';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade100,
      appBar: const _DashboardAppBar(shopName: 'নাফিস এন্টারপ্রাইজ', userId: '01566666666'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
        child: Column(
          children: [
            // ── Top info cards ──
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _InfoCard(title: 'ধাপ', value: _phase),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _InfoCard(title: 'প্যাকেজ', value: _package),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // ── Main panel ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: myGreen.withValues(alpha: 0.4)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 16,
                    spreadRadius: 2,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          title: 'QR কোড স্ক্যান করুন',
                          icon: Icons.qr_code_2_rounded,
                          iconColor: Colors.black87,
                          bgColor: myRedAccent,
                          statusIcon: Icons.close_rounded,
                          statusColor: Colors.red.shade600,
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ActionButton(
                          title: 'কার্ডের ছবি তুলুন',
                          icon: Icons.camera_alt_rounded,
                          iconColor: myGreen,
                          bgColor: Colors.white,
                          statusIcon: Icons.check_circle_rounded,
                          statusColor: Colors.green.shade600,
                          onTap: () async {
                            final cameras = await availableCameras();
                            if (context.mounted) {
                              pushPage(
                                context,
                                KycCardCaptureCamera(
                                  fileName: 'tcb_front',
                                  cameras: cameras,
                                  onImageCaptured: (String frontPath) {
                                    log(frontPath);
                                  },
                                  hint: "কার্ডের সামনের অংশের ছবি তুলুন",
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const _AllocationCard(
                    rows: [
                      _Row('ধাপ', _phase),
                      _Row('প্যাকেজ', _package),
                      _Row('ধাপ শুরুর তারিখ', '07-10-2026 (12:20 PM)'),
                      _Row('বরাদ্দের শেষ তারিখ', '31-10-2026 (11:59 PM)', isWarning: true),
                      _Row('মোট বরাদ্দ', '2'),
                      _Row('মোট বিক্রয়', '0'),
                      _Row('অবশিষ্ট', '2'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Tutorial button ──
            const _TutorialButton(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, -3)),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (i) => setState(() => _currentBottomNavIndex = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: myGreen,
        unselectedItemColor: Colors.grey.shade400,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
        iconSize: 22,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'হোম'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_rounded), label: 'বিক্রয় রিপোর্ট'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'প্রোফাইল'),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// App bar
// ─────────────────────────────────────────────────────────────
class _DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String shopName;
  final String userId;

  const _DashboardAppBar({required this.shopName, required this.userId});

  @override
  Size get preferredSize => const Size.fromHeight(75);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: myGreen,
      elevation: 0,
      toolbarHeight: 75,
      automaticallyImplyLeading: false,
      titleSpacing: 12,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(16))),
      flexibleSpace: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
        child: Opacity(
          opacity: 0.1,
          child: Image.asset(
            'assets/images/leaf_pattern.png',
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (_, _, _) => const SizedBox.shrink(),
          ),
        ),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.menu_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  shopName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'ইউজার আইডি: $userId',
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2)),
              ],
            ),
            child: Icon(Icons.person_rounded, color: Colors.grey.shade400, size: 22),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Top info card
// ─────────────────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final String title;
  final String value;

  const _InfoCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: myGreen.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: myGreen.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: myGreen),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, height: 1.3, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Action button (QR / Camera)
// ─────────────────────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final IconData statusIcon;
  final Color statusColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.statusIcon,
    required this.statusColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: myGreen.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: bgColor == Colors.white
                            ? iconColor.withValues(alpha: 0.1)
                            : Colors.white.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, size: 24, color: bgColor == Colors.white ? iconColor : Colors.black87),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: Icon(statusIcon, color: statusColor, size: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Allocation card
// ─────────────────────────────────────────────────────────────
class _Row {
  final String label;
  final String value;
  final bool isWarning;

  const _Row(this.label, this.value, {this.isWarning = false});
}

class _AllocationCard extends StatelessWidget {
  final List<_Row> rows;

  const _AllocationCard({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 14,
            spreadRadius: 2,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: myGreen.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            color: myGreen.withValues(alpha: 0.06),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                const SizedBox(width: 28),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.account_balance_wallet_rounded, color: myGreen, size: 16),
                      const SizedBox(width: 6),
                      const Text(
                        'বরাদ্দ',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
                Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  elevation: 1,
                  child: InkWell(
                    onTap: () {},
                    customBorder: const CircleBorder(),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(Icons.refresh_rounded, color: myGreen, size: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

          // Details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: [
                for (int i = 0; i < rows.length; i++) ...[
                  _DetailRow(row: rows[i]),
                  if (i != rows.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Divider(height: 1, thickness: 1, color: Colors.grey.shade100),
                    ),
                ],
              ],
            ),
          ),

          // Bottom actions
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: _BottomAction(icon: Icons.visibility_outlined, label: 'বিস্তারিত দেখুন', onTap: () {}),
                  ),
                  VerticalDivider(width: 1, thickness: 1, color: Colors.grey.shade200),
                  Expanded(
                    child: _BottomAction(
                      icon: Icons.insert_chart_outlined,
                      label: 'বিক্রয় রিপোর্ট (সংক্ষিপ্ত)',
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final _Row row;

  const _DetailRow({required this.row});

  @override
  Widget build(BuildContext context) {
    final color = row.isWarning ? Colors.red.shade700 : Colors.black87;
    final weight = row.isWarning ? FontWeight.bold : FontWeight.w600;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Text(
            row.label,
            style: const TextStyle(fontSize: 10, color: Colors.black54, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(
          width: 8,
          child: Text(':', style: TextStyle(fontSize: 10, color: Colors.black54)),
        ),
        Expanded(
          flex: 7,
          child: Text(
            row.value,
            style: TextStyle(fontSize: 10, color: color, fontWeight: weight),
          ),
        ),
      ],
    );
  }
}

class _BottomAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _BottomAction({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: Colors.black87),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black87, fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Tutorial button
// ─────────────────────────────────────────────────────────────
class _TutorialButton extends StatelessWidget {
  const _TutorialButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withValues(alpha: 0.15),
            blurRadius: 14,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {}, // TODO: open YouTube link
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.red.shade50, shape: BoxShape.circle),
                  child: Icon(Icons.smart_display_rounded, color: Colors.red.shade600, size: 22),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'পণ্য বিক্রয়ের নিয়মাবলীর টিউটোরিয়াল দেখুন',
                    style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade400, size: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
