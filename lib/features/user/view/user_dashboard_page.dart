import 'package:digital_oms_sheba/core/constant/colors_custom.dart';
import 'package:digital_oms_sheba/core/constant/height_width.dart';
import 'package:flutter/material.dart';

class UserDashboardPage extends StatefulWidget {
  const UserDashboardPage({super.key});

  @override
  State<UserDashboardPage> createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends State<UserDashboardPage> {
  int _currentBottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myGreenAccent, // Light green background based on app color
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: Container(
          decoration: BoxDecoration(
            color: myGreen,
            // Assuming we use a pattern or just green gradient/color
            image: const DecorationImage(
              image: AssetImage('assets/images/leaf_pattern.png'), // placeholder, may not exist
              fit: BoxFit.cover,
              opacity: 0.1,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.menu, color: Colors.white, size: 28),
                  width12(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'নাফিস এন্টারপ্রাইজ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'ইউজার আইডি : 01566666666',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Top two cards
            Row(
              children: [
                Expanded(child: _buildTopCard('ধাপ', 'জুলাই - ২০২৫ (স্মার্ট কার্ড-০৭)')),
                width12(),
                Expanded(child: _buildTopCard('প্যাকেজ', 'A: ভোজ্য তেল (২ লিঃ)+ডাল (২ কেঃ)+চিনি (১ কে)')),
              ],
            ),
            height16(),
            // Main container
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          title: 'QR কোড স্ক্যান করুন',
                          icon: Icons.qr_code_2,
                          statusIcon: Icons.close,
                          statusColor: Colors.red,
                          bgColor: myRedAccent,
                          borderColor: myRedAccent,
                        ),
                      ),
                      width12(),
                      Expanded(
                        child: _buildActionButton(
                          title: 'কার্ডের ছবি তুলুন',
                          icon: Icons.camera_alt_outlined,
                          statusIcon: Icons.check,
                          statusColor: Colors.white,
                          statusBgColor: Colors.green,
                          bgColor: Colors.white,
                          borderColor: myGreen,
                        ),
                      ),
                    ],
                  ),
                  height16(),
                  // Warning text
                  const Text(
                    '!! বরাদ্দ না পেয়ে থাকলে বরাদ্দ প্রদানকারী কর্তৃপক্ষের সাথে যোগাযোগ করুন',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  height16(),
                  // Allocation Details Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: myGreen),
                    ),
                    child: Column(
                      children: [
                        // Header
                        Container(
                          decoration: BoxDecoration(
                            color: myGreen.withOpacity(0.1),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                          child: Row(
                            children: [
                              Icon(Icons.account_balance_wallet, color: myGreen, size: 20),
                              width10(),
                              Expanded(
                                child: Text(
                                  'বরাদ্দ',
                                  style: TextStyle(
                                    color: myGreen,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Icon(Icons.refresh, color: myBlue, size: 20),
                            ],
                          ),
                        ),
                        const Divider(height: 1, thickness: 1),
                        // Details
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              _buildDetailRow('ধাপ', ': জুলাই - ২০২৫ (স্মার্ট কার্ড-০৭)'),
                              height5(),
                              _buildDetailRow('প্যাকেজ', ': A: ভোজ্য তেল (২ লিঃ)+ডাল (২\n  কেঃ)+চিনি (১ কে)'),
                              height5(),
                              _buildDetailRow('ধাপ শুরুর তারিখ', ': 07-07-2025 (12:20 PM)'),
                              height5(),
                              _buildDetailRow('বরাদ্দের শেষ\nতারিখ', ': 25-07-2025 (12:20 PM)', labelColor: Colors.red, valueColor: Colors.red),
                              height5(),
                              _buildDetailRow('মোট বরাদ্দ', ': 2'),
                              height5(),
                              _buildDetailRow('মোট বিক্রয়', ': 0'),
                              height5(),
                              _buildDetailRow('অবশিষ্ট', ': 2'),
                            ],
                          ),
                        ),
                        Container(height: 5, color: Colors.grey.shade200),
                        // Bottom Actions
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              Expanded(
                                child: TextButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.visibility_outlined, size: 16, color: Colors.black87),
                                  label: const Text(
                                    'বিস্তারিত দেখুন',
                                    style: TextStyle(color: Colors.black87, fontSize: 12),
                                  ),
                                ),
                              ),
                              const VerticalDivider(width: 1, thickness: 1),
                              Expanded(
                                child: TextButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.insert_chart_outlined, size: 16, color: Colors.black87),
                                  label: const Text(
                                    'বিক্রয় রিপোর্ট\n(সংক্ষিপ্ত)',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.black87, fontSize: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            height16(),
            // YouTube Button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFBE9E7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.play_circle_fill, color: Colors.red, size: 28),
                  width12(),
                  const Text(
                    'পণ্য বিক্রয়ের নিয়মাবলীর টিউটোরিয়াল দেখুন',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          setState(() {
            _currentBottomNavIndex = index;
          });
        },
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        backgroundColor: myGreen,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'হোম'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'বিক্রয় রিপোর্ট'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'প্রোফাইল'),
        ],
      ),
    );
  }

  Widget _buildTopCard(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          height10(),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade800),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String title,
    required IconData icon,
    required IconData statusIcon,
    required Color statusColor,
    Color? statusBgColor,
    required Color bgColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 50,
            width: 70,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(icon, size: 40, color: Colors.black87),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: statusBgColor ?? Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(statusIcon, color: statusColor, size: 20),
                  ),
                ),
              ],
            ),
          ),
          height10(),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? labelColor, Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: labelColor ?? Colors.black87,
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
