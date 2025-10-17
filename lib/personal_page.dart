import 'package:flutter/material.dart';
import 'login_page.dart';
import 'user_profile_page.dart';
import 'my_consultations_page.dart';
import 'my_prescriptions_page.dart';
import 'my_favorites_page.dart';
import 'my_reviews_page.dart';
import 'notification_settings_page.dart';
import 'privacy_settings_page.dart';
import 'help_and_feedback_page.dart';

class PersonalPage extends StatefulWidget {
  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 用户信息卡片
            Container(
              padding: EdgeInsets.all(20),
              color: Color(0xFFF5F7FA),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xFFE8EEF7),
                    child: Icon(
                      Icons.account_circle,
                      size: 60,
                      color: Color(0xFF1890FF),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "张三",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "手机: 138****8888",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showUserProfile(),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ),

            // 功能菜单区域
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "我的",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  SizedBox(height: 12),

                  // 菜单项网格
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    children: [
                      _buildMenuCard(
                        "我的问诊",
                        Icons.chat,
                        Color(0xFFE8F4FE),
                        () => _showMyConsultations(),
                      ),
                      _buildMenuCard(
                        "我的处方",
                        Icons.receipt,
                        Color(0xFFFEF4E8),
                        () => _showMyPrescriptions(),
                      ),
                      _buildMenuCard(
                        "我的收藏",
                        Icons.favorite,
                        Color(0xFFFE8E8E8),
                        () => _showMyFavorites(),
                      ),
                      _buildMenuCard(
                        "我的评价",
                        Icons.star,
                        Color(0xFFFFF4E8),
                        () => _showMyReviews(),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Divider(height: 1, color: Color(0xFFEEEEEE)),

            // 设置区域
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "设置",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildMenuItem(
                    "通知设置",
                    Icons.notifications,
                    () => _showNotificationSettings(),
                  ),
                  _buildMenuItem(
                    "隐私设置",
                    Icons.privacy_tip,
                    () => _showPrivacySettings(),
                  ),
                  _buildMenuItem("关于我们", Icons.info, () => _showAboutUs()),
                  _buildMenuItem(
                    "帮助与反馈",
                    Icons.help,
                    () => _showHelpAndFeedback(),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // 退出登录按钮
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF4444),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "退出登录",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    String title,
    IconData icon,
    Color bgColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Color(0xFF1890FF)),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF333333),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFF0F0F0), width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: Color(0xFF666666)),
                SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(fontSize: 15, color: Color(0xFF333333)),
                ),
              ],
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFCCCCCC)),
          ],
        ),
      ),
    );
  }

  // 用户资料页面
  void _showUserProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserProfilePage()),
    );
  }

  // 我的问诊页面
  void _showMyConsultations() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyConsultationsPage()),
    );
  }

  // 我的处方页面
  void _showMyPrescriptions() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyPrescriptionsPage()),
    );
  }

  // 我的收藏页面
  void _showMyFavorites() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyFavoritesPage()),
    );
  }

  // 我的评价页面
  void _showMyReviews() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyReviewsPage()),
    );
  }

  // 通知设置页面
  void _showNotificationSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotificationSettingsPage()),
    );
  }

  // 隐私设置页面
  void _showPrivacySettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PrivacySettingsPage()),
    );
  }

  // 关于我们页面
  void _showAboutUs() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('关于我们'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'QEye - 眼科医疗智能助手',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('版本：1.0.0'),
            Text('开发者：QEye团队'),
            SizedBox(height: 8),
            Text('我们致力于为患者提供专业的眼科医疗服务，通过AI技术和专家资源，让眼部健康管理更加便捷高效。'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('确定'),
          ),
        ],
      ),
    );
  }

  // 帮助与反馈页面
  void _showHelpAndFeedback() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HelpAndFeedbackPage()),
    );
  }
}

