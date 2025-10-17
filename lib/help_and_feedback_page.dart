import 'package:flutter/material.dart';

class HelpAndFeedbackPage extends StatefulWidget {
  @override
  _HelpAndFeedbackPageState createState() => _HelpAndFeedbackPageState();
}

class _HelpAndFeedbackPageState extends State<HelpAndFeedbackPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  String _selectedCategory = '功能问题';
  String _selectedPriority = '中等';

  final List<FAQ> _faqs = [
    FAQ(
      question: '如何预约专家？',
      answer: '在专家页面选择您需要的医生，点击"立即预约"按钮，选择合适的时间段即可完成预约。',
    ),
    FAQ(question: 'AI诊断准确吗？', answer: '我们的AI诊断基于大量医学数据训练，但仅供参考。建议结合专业医生诊断。'),
    FAQ(question: '如何查看检查报告？', answer: '在报告页面可以查看所有历史检查报告，支持筛选和搜索功能。'),
    FAQ(question: '忘记密码怎么办？', answer: '在登录页面点击"忘记密码"，通过手机验证码或邮箱重置密码。'),
    FAQ(question: '如何修改个人信息？', answer: '在个人中心点击头像区域，进入个人资料页面即可修改信息。'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('帮助与反馈'),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Color(0xFF1976D2),
          unselectedLabelColor: Color(0xFF666666),
          indicatorColor: Color(0xFF1976D2),
          tabs: [
            Tab(text: '常见问题'),
            Tab(text: '意见反馈'),
            Tab(text: '联系我们'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildFAQTab(), _buildFeedbackTab(), _buildContactTab()],
      ),
    );
  }

  Widget _buildFAQTab() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _faqs.length,
      itemBuilder: (context, index) {
        return _buildFAQCard(_faqs[index]);
      },
    );
  }

  Widget _buildFAQCard(FAQ faq) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(
          faq.question,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF333333),
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              faq.answer,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '意见反馈',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          SizedBox(height: 16),

          // 问题分类
          Text(
            '问题分类',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: ['功能问题', '界面问题', '性能问题', '内容问题', '其他问题'].map((
              String category,
            ) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCategory = newValue!;
              });
            },
          ),

          SizedBox(height: 16),

          // 优先级
          Text(
            '优先级',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedPriority,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: ['低', '中等', '高', '紧急'].map((String priority) {
              return DropdownMenuItem<String>(
                value: priority,
                child: Text(priority),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedPriority = newValue!;
              });
            },
          ),

          SizedBox(height: 16),

          // 反馈内容
          Text(
            '详细描述',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8),
          TextField(
            controller: _feedbackController,
            decoration: InputDecoration(
              hintText: '请详细描述您遇到的问题或建议...',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(12),
            ),
            maxLines: 6,
          ),

          SizedBox(height: 16),

          // 联系方式
          Text(
            '联系方式（可选）',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8),
          TextField(
            controller: _contactController,
            decoration: InputDecoration(
              hintText: '手机号或邮箱，方便我们回复',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),

          SizedBox(height: 24),

          // 提交按钮
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitFeedback,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1976D2),
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text('提交反馈'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 联系方式卡片
          _buildContactCard(
            '客服热线',
            '400-123-4567',
            '工作日 9:00-18:00',
            Icons.phone,
            Color(0xFF4CAF50),
            () => _makePhoneCall(),
          ),

          SizedBox(height: 16),

          _buildContactCard(
            '客服邮箱',
            'support@qeye.com',
            '24小时内回复',
            Icons.email,
            Color(0xFF2196F3),
            () => _sendEmail(),
          ),

          SizedBox(height: 16),

          _buildContactCard(
            '在线客服',
            '立即咨询',
            '实时在线服务',
            Icons.chat,
            Color(0xFFFF9800),
            () => _startOnlineChat(),
          ),

          SizedBox(height: 24),

          // 其他联系方式
          Text(
            '其他联系方式',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
          SizedBox(height: 16),

          _buildContactItem(
            '微信公众号',
            'QEye眼科助手',
            Icons.wechat,
            () => _openWechat(),
          ),
          _buildContactItem('官方微博', '@QEye眼科助手', Icons.web, () => _openWeibo()),
          _buildContactItem(
            'QQ群',
            '123456789',
            Icons.group,
            () => _joinQQGroup(),
          ),

          SizedBox(height: 24),

          // 工作时间
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '服务时间',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildTimeItem('客服热线', '工作日 9:00-18:00'),
                  _buildTimeItem('在线客服', '工作日 9:00-21:00'),
                  _buildTimeItem('邮件支持', '24小时内回复'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(
    String title,
    String subtitle,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1976D2),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      description,
                      style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFCCCCCC)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, size: 20, color: Color(0xFF666666)),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF333333),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFCCCCCC)),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeItem(String service, String time) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            service,
            style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
          ),
          Text(time, style: TextStyle(fontSize: 14, color: Color(0xFF333333))),
        ],
      ),
    );
  }

  void _submitFeedback() {
    if (_feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('请填写反馈内容')));
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('提交反馈'),
        content: Text('确定要提交反馈吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _feedbackController.clear();
              _contactController.clear();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('反馈提交成功，感谢您的建议！')));
            },
            child: Text('确定'),
          ),
        ],
      ),
    );
  }

  void _makePhoneCall() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('正在拨打电话...')));
  }

  void _sendEmail() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('正在打开邮件应用...')));
  }

  void _startOnlineChat() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('正在连接在线客服...')));
  }

  void _openWechat() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('正在打开微信...')));
  }

  void _openWeibo() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('正在打开微博...')));
  }

  void _joinQQGroup() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('正在打开QQ...')));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _feedbackController.dispose();
    _contactController.dispose();
    super.dispose();
  }
}

class FAQ {
  final String question;
  final String answer;

  FAQ({required this.question, required this.answer});
}
