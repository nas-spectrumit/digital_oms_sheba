import 'package:digital_oms_sheba/core/constant/colors_custom.dart';
import 'package:digital_oms_sheba/core/constant/height_width.dart';
import 'package:digital_oms_sheba/core/constant/navigation_custom.dart';
import 'package:digital_oms_sheba/core/services/device_info_controller.dart';
import 'package:digital_oms_sheba/core/services/svg_preload.dart';
import 'package:digital_oms_sheba/features/auth/onboarding/view/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserDashboardPage extends StatefulWidget {
  const UserDashboardPage({super.key});

  @override
  State<UserDashboardPage> createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends State<UserDashboardPage> {
  int _currentBottomNavIndex = 0;

  void _showDigitalCardSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _DigitalCardModal(),
    );
  }

  void _showServiceDetailDialog({required String title, required String message}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.info_outline, color: myGreen),
            width8(),
            Expanded(
              child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
        content: Text(message, style: TextStyle(fontSize: 13, color: Colors.grey.shade800, height: 1.4)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: myGreen),
            child: const Text('ঠিক আছে', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('লগআউট নিশ্চিতকরণ', style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text('আপনি কি আপনার ওএমএস অ্যাকাউন্ট থেকে বের হতে চান?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('না', style: TextStyle(color: Colors.grey.shade700)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              pushAndRemoveAll(context, const WelcomePage());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: myRed,
              minimumSize: const Size(80, 36),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              'লগআউট',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: myGreen,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset('assets/images/main_logo.png', height: 32, width: 32),
            width10(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ডিজিটাল ওএমএস সেবা',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  Text(
                    'খাদ্য অধিদপ্তর, বাংলাদেশ',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white),
            tooltip: 'ডিজিটাল ওএমএস কার্ড',
            onPressed: () => _showDigitalCardSheet(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            tooltip: 'লগআউট',
            onPressed: _confirmLogout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Beneficiary Profile Header ───────────────────────────
            _buildBeneficiaryHeader(),

            // ── Notice Announcement Banner ───────────────────────────
            _buildNoticeBanner(),

            // ── Current Month Allocation & Balance Cards ─────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'চলতি মাসের বরাদ্দ ও কোটা (অক্টোবর)',
                        style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: Colors.grey.shade900),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: myGreen.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'নির্ধারিত মূল্য',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: myGreen),
                        ),
                      ),
                    ],
                  ),
                  height10(),
                  Row(
                    children: [
                      // Rice Card
                      Expanded(
                        child: _buildAllocationItemCard(
                          title: 'চাল (Rice)',
                          icon: Icons.grain_rounded,
                          color: const Color(0xff137547),
                          allocated: '৫ কেজি',
                          drawn: '২ কেজি',
                          remaining: '৩ কেজি',
                          rate: '৩০ ৳ / কেজি',
                          percent: 0.4,
                        ),
                      ),
                      width12(),
                      // Atta / Flour Card
                      Expanded(
                        child: _buildAllocationItemCard(
                          title: 'আটা (Flour)',
                          icon: Icons.bakery_dining_rounded,
                          color: const Color(0xff00607a),
                          allocated: '৫ কেজি',
                          drawn: '০ কেজি',
                          remaining: '৫ কেজি',
                          rate: '২৪ ৳ / কেজি',
                          percent: 0.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Digital OMS Card CTA Banner ──────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
              child: _buildDigitalCardBanner(context),
            ),

            // ── Services Section Grid ────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'নাগরিক সেবাসমূহ',
                    style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: Colors.grey.shade900),
                  ),
                  height12(),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.88,
                    children: [
                      _buildServiceTile(
                        title: 'বিক্রয় কেন্দ্র',
                        subtitle: 'নিকটস্থ ডিলার',
                        svgPath: SvgMyAsset.shop,
                        onTap: () => _showServiceDetailDialog(
                          title: 'নিকটস্থ ওএমএস বিক্রয় কেন্দ্র',
                          message: 'আপনার নিকটস্থ ওএমএস বিতরণ কেন্দ্র:\n\n• কেন্দ্র: মিরপুর-১০ গোলচত্বর বিক্রয় কেন্দ্র\n• ডিলার: মেসার্স আলম ট্রেডার্স\n• মোবাইল: ০১৭১১-২৩৪৫৬৭\n• বিতরণের সময়: সকাল ৯:০০ - বিকাল ৫:০০ (রবি-বৃহস্পতি)',
                        ),
                      ),
                      _buildServiceTile(
                        title: 'উত্তোলনের তথ্য',
                        subtitle: 'পূর্ববর্তী হিসাব',
                        svgPath: SvgMyAsset.doc1,
                        onTap: () => _showServiceDetailDialog(
                          title: 'খাদ্যপণ্য উত্তোলন ইতিহাস',
                          message: 'সর্বশেষ উত্তোলন:\n\n• তারিখ: ০২ অক্টোবর, ২০২৬\n• পণ্য: চাল ২ কেজি\n• পরিশোধিত মূল্য: ৬০ টাকা\n• কেন্দ্র: মিরপুর-১০ বিক্রয় পয়েন্ট',
                        ),
                      ),
                      _buildServiceTile(
                        title: 'মূল্য তালিকা',
                        subtitle: 'সরকারি দর',
                        svgPath: SvgMyAsset.calculator,
                        onTap: () => _showServiceDetailDialog(
                          title: 'সরকারি ওএমএস মূল্য তালিকা',
                          message: 'খাদ্য অধিদপ্তর কর্তৃক অনুমোদিত দর:\n\n• চাল: ৩০ টাকা/কেজি (একবারে সর্বোচ্চ ৫ কেজি)\n• আটা: ২৪ টাকা/কেজি (একবারে সর্বোচ্চ ৫ কেজি)',
                        ),
                      ),
                      _buildServiceTile(
                        title: 'পরিবার তথ্য',
                        subtitle: 'সদস্য তালিকা',
                        svgPath: SvgMyAsset.marital,
                        onTap: () => _showServiceDetailDialog(
                          title: 'পরিবারের নিবন্ধিত সদস্য',
                          message: 'সুবিধাভোগী কার্ডে অন্তর্ভুক্ত সদস্য:\n\n১. মোঃ আব্দুল করিম (প্রধান)\n২. মোছাঃ শাহিদা বেগম (স্ত্রী)\n৩. তানভীর করিম (পুত্র)',
                        ),
                      ),
                      _buildServiceTile(
                        title: 'ওএমএস নির্দেশিকা',
                        subtitle: 'নীতিমালা',
                        svgPath: SvgMyAsset.notice,
                        onTap: () => _showServiceDetailDialog(
                          title: 'ওএমএস নীতিমালার নির্দেশিকা',
                          message: '১. প্রতিটি কার্ডধারী মাসে সর্বোচ্চ নির্ধারিত কোটা পর্যন্ত পণ্য পাবেন।\n২. পণ্য ক্রয়ের সময় জাতীয় পরিচয়পত্র ও ওএমএস ডিজিটাল কার্ড প্রদর্শন বাধ্যতামূলক।\n৩. কোনো ধরনের বাড়তি মূল্য প্রদান করবেন না।',
                        ),
                      ),
                      _buildServiceTile(
                        title: 'অভিযোগ ও মতামত',
                        subtitle: 'হেল্পডেস্ক',
                        svgPath: SvgMyAsset.call,
                        onTap: () => _showServiceDetailDialog(
                          title: 'অভিযোগ ও নাগরিক হেল্পলাইন',
                          message: 'ওএমএস সংক্রান্ত যেকোনো অনিয়ম বা অভিযোগের জন্য যোগাযোগ করুন:\n\n• ওএমএস হেল্পলাইন: ১৬২৫১\n• সরকারি অভিযোগ প্রতিকার: ৩৩৩\n• ইমেইল: info@dgfood.gov.bd',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Recent Transaction Activity ──────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'সাম্প্রতিক উত্তোলন বিবরণী',
                        style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800, color: Colors.grey.shade900),
                      ),
                      Text(
                        'সকল দেখুন',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: myGreen),
                      ),
                    ],
                  ),
                  height10(),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: myGreenAccent.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.check_circle_outline_rounded, color: myGreen, size: 24),
                        ),
                        width12(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'চাল - ২ কেজি (৬০ ৳)',
                                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700),
                              ),
                              height2(),
                              Text(
                                '০২ অক্টোবর ২০২৬ • মিরপুর-১০ বিতরণ কেন্দ্র',
                                style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.green.shade300),
                          ),
                          child: Text(
                            'গৃহীত',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.green.shade800),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Bottom Govt Helpline & Copyright ─────────────────────
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.headset_mic_rounded, color: myGreen, size: 20),
                        width8(),
                        Text(
                          'জরুরি ওএমএস তথ্য ও সহায়তা কেন্দ্র',
                          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Colors.grey.shade800),
                        ),
                      ],
                    ),
                    height8(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildHelplineChip('ওএমএস সেবা', '১৬২৫১'),
                        _buildHelplineChip('সরকারি তথ্য', '৩৩৩'),
                        _buildHelplineChip('জরুরি সেবা', '৯৯৯'),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'খাদ্য অধিদপ্তর, বাংলাদেশ • সংস্করণ ',
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                        ),
                        AppVersionDetails(fontColor: Colors.grey.shade600, fontSize: 10),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            height20(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          setState(() {
            _currentBottomNavIndex = index;
          });
          if (index == 1) {
            _showDigitalCardSheet(context);
          } else if (index == 2) {
            _showServiceDetailDialog(
              title: 'ওএমএস বিক্রয় কেন্দ্র',
              message: 'আপনার জন্য বরাদ্দকৃত বিক্রয় কেন্দ্র:\nমিরপুর-১০ গোলচত্বর ওএমএস পয়েন্ট।\nবিতরণের সময়: সকাল ৯:০০ - বিকাল ৫:০০ পর্যন্ত।',
            );
          } else if (index == 3) {
            _showServiceDetailDialog(
              title: 'সুবিধাভোগী প্রোফাইল',
              message: 'নাম: মোঃ আব্দুল করিম\nকার্ড আইডি: OMS-DH-2026-89421\nএনআইডি: ১৯৮৯২৬১২৩৪৫৬৭৮\nমোবাইল: ০১৭XXXXXXXX\nঠিকানা: মিরপুর, ঢাকা',
            );
          }
        },
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withValues(alpha: 0.65),
        backgroundColor: myGreen,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'হোম'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_2_rounded), label: 'ওএমএস কার্ড'),
          BottomNavigationBarItem(icon: Icon(Icons.storefront_rounded), label: 'বিক্রয় কেন্দ্র'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'প্রোফাইল'),
        ],
      ),
    );
  }

  // ── Helper Widgets ──────────────────────────────────────────────────

  Widget _buildBeneficiaryHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: myGreen,
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Beneficiary ID Box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 26,
                  backgroundColor: myGreenAccent.withValues(alpha: 0.7),
                  child: Icon(Icons.person, color: myGreen, size: 30),
                ),
                width12(),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Flexible(
                            child: Text(
                              'মোঃ আব্দুল করিম',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          width5(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.green.shade400, width: 0.8),
                            ),
                            child: const Text(
                              'সক্রিয়',
                              style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                      height2(),
                      Text(
                        'কার্ড নং: OMS-DH-2026-89421',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                      ),
                      height2(),
                      Text(
                        'এনআইডি: ১৯৮৯ ২৬১ ২৩৪ ৫৬৭৮',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xfffdf8e1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xffe3bb00).withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.campaign_rounded, color: Color(0xffb59500), size: 22),
          width10(),
          Expanded(
            child: Text(
              'জরুরি নোটিশ: শুক্রবার ব্যতীত প্রতিদিন সকাল ৯টা থেকে বিকাল ৫টা পর্যন্ত ওএমএস পয়েন্টে খাদ্য সহায়তা বিতরণ করা হবে। পণ্য ক্রয়ে আপনার ডিজিটাল কার্ড প্রদর্শন করুন।',
              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Colors.brown.shade800, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllocationItemCard({
    required String title,
    required IconData icon,
    required Color color,
    required String allocated,
    required String drawn,
    required String remaining,
    required String rate,
    required double percent,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: color, size: 18),
              ),
              width8(),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: color),
                ),
              ),
            ],
          ),
          height10(),
          _buildRowInfo('মাসিক কোটা:', allocated),
          _buildRowInfo('উত্তোলিত:', drawn),
          _buildRowInfo('অবশিষ্ট:', remaining, highlight: true),
          const Divider(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('দর:', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              Text(
                rate,
                style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: color),
              ),
            ],
          ),
          height5(),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowInfo(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
          Text(
            value,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
              color: highlight ? const Color(0xff137547) : Colors.grey.shade900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDigitalCardBanner(BuildContext context) {
    return InkWell(
      onTap: () => _showDigitalCardSheet(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xff137547), const Color(0xff0e5936)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: myGreen.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: SvgPicture.asset(SvgMyAsset.qr, height: 38, width: 38),
            ),
            width14(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ডিজিটাল ওএমএস কার্ড ও কিউআর',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                  height2(),
                  Text(
                    'বিতরণ পয়েন্টে স্ক্যান করতে কার্ডটি প্রদর্শন করুন',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Text(
                    'দেখুন',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: myGreen),
                  ),
                  const Icon(Icons.chevron_right, size: 16, color: Color(0xff137547)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceTile({
    required String title,
    required String subtitle,
    required String svgPath,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 6, offset: const Offset(0, 2)),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 40,
                width: 40,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: myGreenAccent.withValues(alpha: 0.4), shape: BoxShape.circle),
                child: SvgPicture.asset(svgPath, colorFilter: ColorFilter.mode(myGreen, BlendMode.srcIn)),
              ),
              height8(),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              height2(),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 9.5, color: Colors.grey.shade600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelplineChip(String label, String number) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: myGreen.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: myGreen.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.phone, size: 12, color: myGreen),
          width5(),
          Text(
            '$label: $number',
            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: myGreen),
          ),
        ],
      ),
    );
  }

  Widget width8() => const SizedBox(width: 8);
  Widget height8() => const SizedBox(height: 8);
}

// ── Digital Card Modal Bottom Sheet ─────────────────────────────────

class _DigitalCardModal extends StatelessWidget {
  const _DigitalCardModal();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
          ),
          height16(),

          // Card header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ডিজিটাল ওএমএস কার্ড',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: myGreen),
              ),
              IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
            ],
          ),
          height10(),

          // Realistic Smart Digital Card UI
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xff137547), const Color(0xff0a4529)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.shade900.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card Top Govt Brand
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/images/main_logo.png', height: 32, width: 32),
                        width8(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'খাদ্য অধিদপ্তর • ওএমএস কার্ড',
                              style: TextStyle(fontSize: 9, color: Colors.white.withValues(alpha: 0.8)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xffe3bb00),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'সুবিধাভোগী',
                        style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.white24, height: 20),

                // Card body with QR and Beneficiary Info
                Row(
                  children: [
                    // QR Code Box
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: SvgPicture.asset(SvgMyAsset.qr, height: 70, width: 70),
                    ),
                    width14(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'মোঃ আব্দুল করিম',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white),
                          ),
                          height2(),
                          Text(
                            'কার্ড নং: OMS-DH-2026-89421',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                          height2(),
                          Text(
                            'এনআইডি: ১৯৮৯ ২৬১ ২৩৪ ৫৬৭৮',
                            style: TextStyle(fontSize: 10.5, color: Colors.white.withValues(alpha: 0.8)),
                          ),
                          height2(),
                          Text(
                            'কেন্দ্র: মিরপুর-১০, ঢাকা',
                            style: TextStyle(fontSize: 10, color: Colors.white.withValues(alpha: 0.8)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                height14(),

                // Barcode strip
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
                  child: SvgPicture.asset(SvgMyAsset.barcode, height: 24, fit: BoxFit.contain),
                ),
              ],
            ),
          ),
          height16(),

          Text(
            'খাদ্য সহায়তা গ্রহণের সময় ডিলার পয়েন্টে এই কিউআর কোডটি স্ক্যান করান।',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500, color: Colors.grey.shade600),
          ),
          height16(),
        ],
      ),
    );
  }

  Widget width8() => const SizedBox(width: 8);
}
