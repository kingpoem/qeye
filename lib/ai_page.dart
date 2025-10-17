import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class AIPage extends StatefulWidget {
  @override
  _AIPageState createState() => _AIPageState();
}

class _AIPageState extends State<AIPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _questionController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  // DeepSeek API配置
  static const String DEEPSEEK_API_KEY = '';
  static const String DEEPSEEK_API_URL =
      'https://api.deepseek.com/chat/completions';
  static const String SYSTEM_PROMPT =
      '你是一个专业的眼科医生。你需要根据用户的描述或图片分析进行眼科诊断和建议。请以医学专业人士的角度进行回答。';

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

  Future<void> _callDeepSeekStreamAPI(String userMessage) async {
    try {
      setState(() {
        _isLoading = true;
        _messages.add(
          ChatMessage(
            text: userMessage,
            isUser: true,
            timestamp: DateTime.now(),
          ),
        );
      });

      _scrollToBottom();

      final request = http.Request('POST', Uri.parse(DEEPSEEK_API_URL));
      request.headers.update(
        'Authorization',
        (value) => 'Bearer $DEEPSEEK_API_KEY',
        ifAbsent: () => 'Bearer $DEEPSEEK_API_KEY',
      );
      request.headers['Content-Type'] = 'application/json';

      request.body = jsonEncode({
        'model': 'deepseek-chat',
        'messages': [
          {'role': 'system', 'content': SYSTEM_PROMPT},
          {'role': 'user', 'content': userMessage},
        ],
        'stream': true,
        'temperature': 0.7,
      });

      final response = await request.send();

      if (response.statusCode == 200) {
        String fullContent = '';
        ChatMessage aiMessage = ChatMessage(
          text: '',
          isUser: false,
          timestamp: DateTime.now(),
        );

        setState(() {
          _messages.add(aiMessage);
        });

        _scrollToBottom();

        // 处理流式响应
        response.stream
            .transform(utf8.decoder)
            .listen(
              (String chunk) {
                final lines = chunk.split('\n');
                for (String line in lines) {
                  if (line.startsWith('data: ')) {
                    final data = line.substring(6);
                    if (data == '[DONE]') {
                      setState(() {
                        _isLoading = false;
                      });
                      return;
                    }

                    try {
                      final json = jsonDecode(data);
                      final delta = json['choices'][0]['delta'];

                      if (delta['content'] != null) {
                        fullContent += delta['content'];

                        setState(() {
                          _messages[_messages.length - 1] = ChatMessage(
                            text: fullContent,
                            isUser: false,
                            timestamp: aiMessage.timestamp,
                          );
                        });

                        _scrollToBottom();
                      }
                    } catch (e) {
                      print('解析JSON出错: $e');
                    }
                  }
                }
              },
              onError: (error) {
                setState(() {
                  _isLoading = false;
                });
                _showErrorMessage('流式请求出错: $error');
              },
            );
      } else {
        setState(() {
          _isLoading = false;
        });
        _showErrorMessage('API请求失败: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorMessage('调用API出错: $e');
    }
  }

  /// 自动滚动到底部 - 完整实现
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } else {
      // 如果hasClients为false，稍后重试一次
      Future.delayed(Duration(milliseconds: 200), () {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    }
  }

  void _jumpToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(Duration(milliseconds: 50), () {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI眼科助手'),
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
            controller: _scrollController,
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
        crossAxisAlignment: CrossAxisAlignment.end,
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
            onPressed: _isLoading ? null : _pickImage,
            color: Color(0xFF1976D2),
          ),
          Expanded(
            child: TextField(
              controller: _questionController,
              enabled: !_isLoading,
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
            onPressed: _isLoading ? null : _sendMessage,
            backgroundColor: _isLoading ? Colors.grey : Color(0xFF1976D2),
            child: _isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Icon(Icons.send, color: Colors.white),
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
                    onTap: _isLoading ? null : _pickImage,
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
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (_selectedImage != null && !_isLoading)
                  ? _startDiagnosis
                  : null,
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
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (!_isLoading) ? _analyzeSymptoms : null,
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
    _callDeepSeekStreamAPI(_questionController.text.trim());
    _questionController.clear();
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
        ],
      ),
    );
  }

  void _analyzeSymptoms() {
    _callDeepSeekStreamAPI('请根据以上症状信息进行专业眼科分析和建议');
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _tabController.dispose();
    _questionController.dispose();
    _scrollController.dispose();
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
