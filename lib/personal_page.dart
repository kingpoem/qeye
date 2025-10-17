import 'package:flutter/material.dart';
import 'login_page.dart';

class PersonalPage extends StatelessWidget {
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
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                    color: Color(0xFF999999),
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
                      _buildMenuCard("我的问诊", Icons.chat, Color(0xFFE8F4FE)),
                      _buildMenuCard("我的处方", Icons.receipt, Color(0xFFFEF4E8)),
                      _buildMenuCard(
                        "我的收藏",
                        Icons.favorite,
                        Color(0xFFFE8E8E8),
                      ),
                      _buildMenuCard("我的评价", Icons.star, Color(0xFFFFF4E8)),
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
                  _buildMenuItem("通知设置", Icons.notifications),
                  _buildMenuItem("隐私设置", Icons.privacy_tip),
                  _buildMenuItem("关于我们", Icons.info),
                  _buildMenuItem("帮助与反馈", Icons.help),
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
                      (route) => false, // 清空历史路由，防止返回
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

  Widget _buildMenuCard(String title, IconData icon, Color bgColor) {
    return Container(
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
    );
  }

  Widget _buildMenuItem(String title, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0), width: 1)),
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
    );
  }
}
