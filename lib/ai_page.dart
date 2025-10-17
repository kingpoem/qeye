import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AIPage extends StatefulWidget {
  @override
  _AIPageState createState() => _AIPageState();
}

class _AIPageState extends State<AIPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _questionController = TextEditingController();
  final List<ChatMessage> _messages = [];
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeMessages();
  }

  void _initializeMessages() {
    _messages.add(
      ChatMessage(
        text:
            "您好！我是眼科AI助手，可以帮您解答眼部健康问题。您可以：\n\n• 描述症状进行初步诊断\n• 上传眼部图片进行分析\n• 咨询眼部疾病相关问题\n• 获取护眼建议",
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI智能助手'),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Color(0xFF1976D2),
          unselectedLabelColor: Color(0xFF666666),
          indicatorColor: Color(0xFF1976D2),
          tabs: [
            Tab(text: 'AI问答', icon: Icon(Icons.chat)),
            Tab(text: '智能诊断', icon: Icon(Icons.medical_services)),
            Tab(text: '症状分析', icon: Icon(Icons.analytics)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildChatTab(), _buildDiagnosisTab(), _buildAnalysisTab()],
      ),
    );
  }

  Widget _buildChatTab() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              return _buildMessageBubble(_messages[index]);
            },
          ),
        ),
        _buildInputArea(),
      ],
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF1976D2),
              child: Icon(Icons.smart_toy, color: Colors.white, size: 16),
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isUser ? Color(0xFF1976D2) : Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isUser ? Colors.white : Color(0xFF333333),
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      color: message.isUser
                          ? Colors.white70
                          : Color(0xFF999999),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isUser) ...[
            SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFFE0E0E0),
              child: Icon(Icons.person, color: Colors.white, size: 16),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE0E0E0))),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _pickImage,
            color: Color(0xFF1976D2),
          ),
          Expanded(
            child: TextField(
              controller: _questionController,
              decoration: InputDecoration(
                hintText: '请输入您的问题...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Color(0xFFF5F5F5),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              maxLines: null,
            ),
          ),
          SizedBox(width: 8),
          FloatingActionButton(
            mini: true,
            onPressed: _sendMessage,
            backgroundColor: Color(0xFF1976D2),
            child: Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosisTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 上传图片区域
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xFFE0E0E0),
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _selectedImage == null
                ? InkWell(
                    onTap: _pickImage,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload,
                          size: 48,
                          color: Color(0xFF1976D2),
                        ),
                        SizedBox(height: 8),
                        Text('点击上传眼部图片', style: TextStyle(fontSize: 16)),
                        Text(
                          '支持JPG、PNG格式',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                  )
                : Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _selectedImage!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedImage = null),
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          SizedBox(height: 16),

          // 诊断选项
          Text(
            '选择诊断类型：',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildDiagnosisChip('白内障检测'),
              _buildDiagnosisChip('青光眼筛查'),
              _buildDiagnosisChip('视网膜病变'),
              _buildDiagnosisChip('角膜疾病'),
              _buildDiagnosisChip('屈光不正'),
              _buildDiagnosisChip('眼底检查'),
            ],
          ),
          SizedBox(height: 24),

          // 开始诊断按钮
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedImage != null ? _startDiagnosis : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1976D2),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                '开始AI诊断',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 16),

          // 诊断结果区域
          if (_selectedImage != null) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Color(0xFFE0E0E0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI诊断结果：',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('正在分析中...', style: TextStyle(color: Color(0xFF666666))),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAnalysisTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 症状选择
          Text(
            '请选择您的症状：',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSymptomChip('视力模糊'),
              _buildSymptomChip('眼睛干涩'),
              _buildSymptomChip('眼痛'),
              _buildSymptomChip('流泪'),
              _buildSymptomChip('畏光'),
              _buildSymptomChip('飞蚊症'),
              _buildSymptomChip('视野缺损'),
              _buildSymptomChip('复视'),
              _buildSymptomChip('眼红'),
              _buildSymptomChip('眼痒'),
            ],
          ),
          SizedBox(height: 24),

          // 严重程度
          Text(
            '症状严重程度：',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildSeverityChip('轻微')),
              SizedBox(width: 8),
              Expanded(child: _buildSeverityChip('中等')),
              SizedBox(width: 8),
              Expanded(child: _buildSeverityChip('严重')),
            ],
          ),
          SizedBox(height: 24),

          // 持续时间
          Text(
            '症状持续时间：',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildDurationChip('1天内'),
              _buildDurationChip('1周内'),
              _buildDurationChip('1个月内'),
              _buildDurationChip('3个月内'),
              _buildDurationChip('半年以上'),
            ],
          ),
          SizedBox(height: 24),

          // 分析按钮
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _analyzeSymptoms,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1976D2),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                '开始症状分析',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 16),

          // 分析结果
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xFFE0E0E0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '分析结果：',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  '请先选择症状进行智能分析',
                  style: TextStyle(color: Color(0xFF666666)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosisChip(String label) {
    return ActionChip(
      label: Text(label),
      onPressed: () {},
      backgroundColor: Color(0xFFE3F2FD),
      labelStyle: TextStyle(color: Color(0xFF1976D2)),
    );
  }

  Widget _buildSymptomChip(String label) {
    return ActionChip(
      label: Text(label),
      onPressed: () {},
      backgroundColor: Color(0xFFF5F5F5),
      labelStyle: TextStyle(color: Color(0xFF333333)),
    );
  }

  Widget _buildSeverityChip(String label) {
    return ActionChip(
      label: Text(label),
      onPressed: () {},
      backgroundColor: Color(0xFFF5F5F5),
      labelStyle: TextStyle(color: Color(0xFF333333)),
    );
  }

  Widget _buildDurationChip(String label) {
    return ActionChip(
      label: Text(label),
      onPressed: () {},
      backgroundColor: Color(0xFFF5F5F5),
      labelStyle: TextStyle(color: Color(0xFF333333)),
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('图片选择失败：$e')));
    }
  }

  void _sendMessage() {
    if (_questionController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: _questionController.text.trim(),
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
    });

    // 模拟AI回复
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _messages.add(
          ChatMessage(
            text: _getAIResponse(_questionController.text.trim()),
            isUser: false,
            timestamp: DateTime.now(),
          ),
        );
      });
    });

    _questionController.clear();
  }

  String _getAIResponse(String question) {
    // 简单的关键词匹配回复
    if (question.contains('近视') || question.contains('视力')) {
      return "根据您的描述，建议您：\n\n1. 定期进行视力检查\n2. 保持良好的用眼习惯\n3. 适当进行眼部运动\n4. 如有持续恶化，请及时就医\n\n建议您预约专业眼科医生进行详细检查。";
    } else if (question.contains('干眼') || question.contains('干涩')) {
      return "干眼症是常见眼部疾病，建议：\n\n1. 使用人工泪液\n2. 避免长时间用眼\n3. 保持室内湿度\n4. 多眨眼，保持眼部湿润\n5. 如症状严重，请咨询医生";
    } else if (question.contains('疼痛') || question.contains('痛')) {
      return "眼部疼痛可能的原因：\n\n1. 眼疲劳\n2. 眼部感染\n3. 青光眼\n4. 角膜问题\n\n建议您立即就医检查，眼部疼痛不可忽视。";
    } else {
      return "感谢您的咨询。根据您的描述，建议您：\n\n1. 注意眼部卫生\n2. 避免过度用眼\n3. 定期进行眼部检查\n4. 如有持续症状，请及时就医\n\n如需更详细的诊断，建议上传眼部图片或预约专家咨询。";
    }
  }

  void _startDiagnosis() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('AI诊断中'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('正在分析您的眼部图片，请稍候...'),
          ],
        ),
      ),
    );

    // 模拟诊断过程
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pop(context);
      _showDiagnosisResult();
    });
  }

  void _showDiagnosisResult() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('诊断结果'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AI初步分析结果：', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('• 眼部结构正常\n• 无明显病变\n• 建议定期检查\n• 注意用眼卫生'),
            SizedBox(height: 16),
            Text('注意：此结果仅供参考，如有疑虑请咨询专业医生。'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('确定'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _tabController.animateTo(0); // 切换到问答页面
            },
            child: Text('咨询专家'),
          ),
        ],
      ),
    );
  }

  void _analyzeSymptoms() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('症状分析'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('正在分析您的症状，请稍候...'),
          ],
        ),
      ),
    );

    // 模拟分析过程
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
      _showAnalysisResult();
    });
  }

  void _showAnalysisResult() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('分析结果'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('根据您的症状描述：', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('• 可能原因：眼疲劳、干眼症\n• 建议措施：休息、滴眼药水\n• 紧急程度：一般\n• 建议就医：如症状持续'),
            SizedBox(height: 16),
            Text('注意：此分析仅供参考，具体诊断请咨询专业医生。'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('确定'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _tabController.animateTo(0); // 切换到问答页面
            },
            child: Text('详细咨询'),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _tabController.dispose();
    _questionController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
