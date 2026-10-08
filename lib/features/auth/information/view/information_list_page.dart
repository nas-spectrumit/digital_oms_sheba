import 'package:digital_oms_sheba/core/constant/colors_custom.dart';
import 'package:digital_oms_sheba/core/constant/custom_background.dart';
import 'package:digital_oms_sheba/core/constant/height_width.dart';
import 'package:digital_oms_sheba/core/constant/navigation_custom.dart';
import 'package:digital_oms_sheba/features/auth/information/view/information_webview_page.dart';
import 'package:flutter/material.dart';

class InformationListPage extends StatelessWidget {
  const InformationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'তথ্য বাতায়ন',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: myGreen,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: CustomBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'তথ্য ও সেবা',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.grey.shade800),
                ),
                height16(),
                _buildInfoTile(
                  context: context,
                  title: 'উন্নয়ন প্রকল্পসমূহ',
                  url: 'https://mofood.gov.bd/pages/static-pages/694032d435ce18e1c0563186',
                  icon: Icons.lightbulb_outline,
                ),
                height10(),
                _buildInfoTile(
                  context: context,
                  title: 'অধীনস্থ দপ্তর/ সংস্থা',
                  url: 'https://mofood.gov.bd/pages/static-pages/6940329835ce18e1c055f0a4',
                  icon: Icons.account_balance_outlined,
                ),
                height10(),
                _buildInfoTile(
                  context: context,
                  title: 'ফটোগ্যালারি',
                  url: 'https://mofood.gov.bd/pages/photo-galleries',
                  icon: Icons.photo_library_outlined,
                ),
                height10(),
                _buildInfoTile(
                  context: context,
                  title: 'অফিসের ঠিকানা',
                  url: 'https://mofood.gov.bd/pages/static-pages/694032cc35ce18e1c056294c',
                  icon: Icons.location_on_outlined,
                ),
                height10(),
                _buildInfoTile(
                  context: context,
                  title: 'রূপকল্প (Vision)',
                  url: 'https://mofood.gov.bd/pages/static-pages/694032c235ce18e1c0561eb7',
                  icon: Icons.visibility_outlined,
                ),
                height10(),
                _buildInfoTile(
                  context: context,
                  title: 'কর্মকর্তাবৃন্দ',
                  url: 'https://mofood.gov.bd/pages/officers',
                  icon: Icons.groups_outlined,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required BuildContext context,
    required String title,
    required String url,
    required IconData icon,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          pushPage(
            context,
            InformationWebviewPage(
              title: title,
              url: url,
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: myGreen.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: myGreen, size: 20),
              ),
              width12(),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
