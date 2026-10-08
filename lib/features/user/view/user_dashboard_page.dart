import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:digital_oms_sheba/core/card_capture_widget/card_capture_page.dart';
import 'package:digital_oms_sheba/core/constant/colors_custom.dart';
import 'package:digital_oms_sheba/core/constant/height_width.dart';
import 'package:digital_oms_sheba/core/constant/navigation_custom.dart';
import 'package:flutter/material.dart';

class UserDashboardPage extends StatefulWidget {
  const UserDashboardPage({super.key});

  @override
  State<UserDashboardPage> createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends State<UserDashboardPage> {
  int _currentBottomNavIndex = 0;

  // TODO: replace with data from your API / model
  static const _phase = 'জুলাই - ২০২৫ (স্মার্ট কার্ড-০৭)';
  static const _package = 'A: ভোজ্য তেল (২ লিঃ)+ডাল (২ কেঃ)+চিনি (১ কে)';

  // Shared tones taken from the screenshot
  static const _panelColor = Color(0xFFE3F1E3); // light green panel
  static const _headerGrey = Color(0xFFDDE5DD); // card header strip

  @override
  Widget build(BuildContext context) {
    final minPanelHeight = MediaQuery.of(context).size.height * 0.55;

    return Scaffold(
      backgroundColor: myGreenAccent,
      appBar: const _DashboardAppBar(shopName: 'নাফিস এন্টারপ্রাইজ', userId: '01566666666'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
        child: Column(
          children: [
            // ── Top info cards ──
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _InfoCard(title: 'ধাপ', value: _phase),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _InfoCard(title: 'প্যাকেজ', value: _package),
                ),
              ],
            ),
            height16(),

            // ── Main panel ──
            Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: minPanelHeight),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _panelColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.25), blurRadius: 6, offset: const Offset(0, 3)),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          title: 'QR কোড স্ক্যান করুন',
                          icon: Icons.qr_code_2,
                          iconColor: Colors.black87,
                          bgColor: myRedAccent,
                          statusIcon: Icons.close,
                          statusColor: Colors.red,
                          onTap: () {},
                        ),
                      ),
                      width12(),
                      Expanded(
                        child: _ActionButton(
                          title: 'কার্ডের ছবি তুলুন',
                          icon: Icons.camera_alt,
                          iconColor: myGreen,
                          bgColor: Colors.white,
                          statusIcon: Icons.check_circle,
                          statusColor: Colors.green,
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
                  const SizedBox(height: 10),
                  // Single line, clipped like the screenshot.
                  // Wrap it in a Marquee package widget if you want it to scroll.
                  const SizedBox(
                    width: double.infinity,
                    child: Text(
                      '!! বরাদ্দ না পেয়ে থাকলে বরাদ্দ প্রদানকারী কর্তৃপক্ষের সাথে যোগাযোগ করুন',
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.clip,
                      style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const _AllocationCard(
                    headerColor: _headerGrey,
                    rows: [
                      _Row('ধাপ', _phase),
                      _Row('প্যাকেজ', _package),
                      _Row('ধাপ শুরুর তারিখ', '07-07-2025 (12:20 PM)'),
                      _Row('বরাদ্দের শেষ তারিখ', '25-07-2025 (12:20 PM)', isWarning: true),
                      _Row('মোট বরাদ্দ', '2'),
                      _Row('মোট বিক্রয়', '0'),
                      _Row('অবশিষ্ট', '2'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // ── Tutorial button ──
            const _TutorialButton(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentBottomNavIndex,
      onTap: (i) => setState(() => _currentBottomNavIndex = i),
      type: BottomNavigationBarType.fixed,
      backgroundColor: myGreen,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'হোম'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_view_month), label: 'বিক্রয় রিপোর্ট'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'প্রোফাইল'),
      ],
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
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: myGreen,
      elevation: 0,
      toolbarHeight: 80,
      automaticallyImplyLeading: false,
      titleSpacing: 16,
      // Background leaf pattern. errorBuilder avoids a crash if asset is missing.
      flexibleSpace: Opacity(
        opacity: 0.15,
        child: Image.asset(
          'assets/images/leaf_pattern.png',
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (_, _, _) => const SizedBox.shrink(),
        ),
      ),
      title: Row(
        children: [
          const Icon(Icons.menu, color: Colors.white, size: 30),
          width12(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  shopName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  'ইউজার আইডি : $userId',
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // Rounded-square avatar (as in screenshot)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 48,
              height: 48,
              color: Colors.white,
              // TODO: Image.network(profileUrl, fit: BoxFit.cover)
              child: const Icon(Icons.person, color: Colors.grey, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Top info card (grey header + white value box)
// ─────────────────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final String title;
  final String value;

  const _InfoCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFDDE5DD),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade400, width: 0.8),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Text(value, style: const TextStyle(fontSize: 14, height: 1.3)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Action button (QR / Camera) with status icon at the top-right
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
    return Material(
      color: bgColor,
      elevation: 3,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: SizedBox(
          height: 160,
          child: Stack(
            children: [
              Positioned(top: 6, right: 6, child: Icon(statusIcon, color: statusColor, size: 28)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 52, color: iconColor),
                    const SizedBox(height: 18),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
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
  final Color headerColor;
  final List<_Row> rows;

  const _AllocationCard({required this.headerColor, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: myGreen, width: 1.5),
      ),
      child: Column(
        children: [
          // Header
          Container(
            color: headerColor,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                const SizedBox(width: 32), // balances refresh icon so title is centered
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.account_balance_wallet, color: myGreen, size: 22),
                      width10(),
                      const Text(
                        'বরাদ্দ',
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {}, // TODO: refresh
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: myBlue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.refresh, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),

          // Details
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
            child: Column(children: [for (final r in rows) _DetailRow(row: r)]),
          ),

          // Bottom actions
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE8ECE8),
              border: Border(top: BorderSide(color: Colors.grey.shade300, width: 4)),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: _BottomAction(icon: Icons.visibility_outlined, label: 'বিস্তারিত দেখুন', onTap: () {}),
                  ),
                  VerticalDivider(width: 1, thickness: 1, color: Colors.grey.shade400),
                  Expanded(
                    child: _BottomAction(
                      icon: Icons.insert_chart_outlined,
                      label: 'বিক্রয় রিপোর্ট\n(সংক্ষিপ্ত)',
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
    final color = row.isWarning ? Colors.red : Colors.black87;
    final weight = row.isWarning ? FontWeight.bold : FontWeight.w500;
    final style = TextStyle(fontSize: 14, color: color, fontWeight: weight);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 4, child: Text(row.label, style: style)),
          SizedBox(width: 14, child: Text(':', style: style)),
          Expanded(flex: 7, child: Text(row.value, style: style)),
        ],
      ),
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
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: Colors.black87),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black87, fontSize: 12),
              ),
            ),
          ],
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
    return Material(
      color: const Color(0xFFFDF4FB),
      elevation: 2,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () {}, // TODO: open YouTube link
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Row(
            children: const [
              Icon(Icons.smart_display, color: Colors.red, size: 36),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'পণ্য বিক্রয়ের নিয়মাবলীর টিউটোরিয়াল দেখুন',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
