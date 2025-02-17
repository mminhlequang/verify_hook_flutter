import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:gap/gap.dart';
import 'package:internal_core/internal_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VerifyHook – Verify. Automate. Simplify'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                title: 'Giới thiệu',
                content:
                    'VerifyHook là nền tảng giúp bạn xác minh, tự động hóa và đơn giản hóa các quy trình.',
              ),
              _buildSection(
                title: 'Liên hệ',
                content:
                    'Liên hệ với chúng tôi qua email: support@verifyhook.com hoặc số điện thoại: 123-456-7890.',
              ),
              _buildSection(
                title: 'Hỗ trợ',
                content:
                    'Chúng tôi cung cấp hỗ trợ 24/7 để đảm bảo bạn luôn nhận được sự trợ giúp cần thiết.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
