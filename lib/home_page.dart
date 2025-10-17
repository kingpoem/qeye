import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'expert_page.dart';
import 'ai_page.dart';
import 'report_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  String _selectedTag = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: '请输入搜索内容',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Color(0xFFF5F5F5),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                      });
                    },
                  )
                : null,
          ),
          onSubmitted: (value) => _performSearch(value),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 推荐眼部疾病案例
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '推荐眼部疾病案例',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            // 第一行标签
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildTagButton('最新眼科病', 'latest'),
                  _buildTagButton('视觉脑萎缩', 'vision'),
                  _buildTagButton('视网膜疾病', 'retina'),
                  _buildTagButton('常见眼病例', 'common'),
                  _buildTagButton('近视热门', 'myopia'),
                ],
              ),
            ),
            SizedBox(height: 12),
            // 第二行标签
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildTagButton('专家新见解', 'expert'),
                  _buildTagButton('个性化病例', 'personal'),
                  _buildTagButton('医学案例精选', 'case'),
                  _buildTagButton('智能诊断助手', 'ai'),
                  _buildTagButton('眼科疾病研究', 'research'),
                ],
              ),
            ),
            SizedBox(height: 20),
            // 图片上传预览
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Stack(
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: _selectedImage != null
                          ? DecorationImage(
                              image: FileImage(_selectedImage!),
                              fit: BoxFit.cover,
                            )
                          : DecorationImage(
                              image: AssetImage('assets/images/logo.jpeg'),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.black.withOpacity(0.3),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _selectedImage != null ? '图片已选择' : '上传图片预览',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            _selectedImage != null ? '点击重新选择图片' : '点击上传眼部症状图片',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: _pickImageFromCamera,
                                icon: Icon(Icons.camera_alt, size: 18),
                                label: Text('拍照'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              ElevatedButton.icon(
                                onPressed: _pickImageFromGallery,
                                icon: Icon(Icons.photo_library, size: 18),
                                label: Text('相册'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (_selectedImage != null) ...[
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: _analyzeImage,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF1976D2),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 10,
                                ),
                              ),
                              child: Text('AI分析图片'),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            // 功能卡片
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '功能中心',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildFeatureCard(
                    icon: Icons.medical_services,
                    title: '专家咨询',
                    subtitle: '在线问诊',
                    onTap: () => _navigateToExperts(),
                  ),
                  _buildFeatureCard(
                    icon: Icons.smart_toy,
                    title: 'AI诊断',
                    subtitle: '智能分析',
                    onTap: () => _navigateToAI(),
                  ),
                  _buildFeatureCard(
                    icon: Icons.article,
                    title: '检查报告',
                    subtitle: '查看报告',
                    onTap: () => _navigateToReports(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTagButton(String label, String tagId) {
    final isSelected = _selectedTag == tagId;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: GestureDetector(
        onTap: () => _onTagSelected(tagId, label),
        child: Column(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: isSelected
                  ? Color(0xFF1976D2)
                  : Colors.grey[300],
              child: Icon(
                _getTagIcon(tagId),
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Color(0xFF1976D2) : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  color: Color(0xFFE3F2FD),
                ),
                child: Icon(icon, size: 40, color: Color(0xFF1976D2)),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                      textAlign: TextAlign.center,
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

  // 搜索功能
  void _performSearch(String query) {
    if (query.trim().isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('搜索结果'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('搜索关键词：$query'),
            SizedBox(height: 16),
            Text('找到相关结果：'),
            SizedBox(height: 8),
            _buildSearchResult('专家：李医生 - 白内障专家'),
            _buildSearchResult('文章：如何预防近视'),
            _buildSearchResult('案例：视网膜病变治疗'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('关闭'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _searchController.clear();
            },
            child: Text('清空搜索'),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResult(String result) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.search, size: 16, color: Color(0xFF666666)),
          SizedBox(width: 8),
          Expanded(child: Text(result, style: TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  // 标签选择功能
  void _onTagSelected(String tagId, String label) {
    setState(() {
      _selectedTag = _selectedTag == tagId ? '' : tagId;
    });

    if (_selectedTag.isNotEmpty) {
      _showTagContent(tagId, label);
    }
  }

  void _showTagContent(String tagId, String label) {
    String content = _getTagContent(tagId);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(label),
        content: SingleChildScrollView(child: Text(content)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('关闭'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToRelatedContent(tagId);
            },
            child: Text('查看更多'),
          ),
        ],
      ),
    );
  }

  String _getTagContent(String tagId) {
    switch (tagId) {
      case 'latest':
        return '最新眼科疾病案例包括：\n\n• 青少年近视防控新方法\n• 老年性白内障微创手术\n• 糖尿病视网膜病变早期诊断\n• 青光眼激光治疗技术\n• 角膜移植手术进展';
      case 'vision':
        return '视觉脑萎缩相关案例：\n\n• 视神经萎缩的早期识别\n• 脑部病变对视觉的影响\n• 视觉康复训练方法\n• 神经眼科检查技术\n• 多学科联合诊疗';
      case 'retina':
        return '视网膜疾病案例：\n\n• 视网膜脱离紧急处理\n• 黄斑病变治疗方案\n• 糖尿病视网膜病变分期\n• 视网膜静脉阻塞治疗\n• 遗传性视网膜疾病';
      case 'common':
        return '常见眼病案例：\n\n• 干眼症的综合治疗\n• 结膜炎的预防与治疗\n• 麦粒肿的处理方法\n• 眼疲劳的缓解技巧\n• 眼部外伤的急救';
      case 'myopia':
        return '近视相关案例：\n\n• 青少年近视防控策略\n• 高度近视并发症预防\n• 角膜塑形镜验配\n• 近视手术适应症\n• 视力保护日常方法';
      case 'expert':
        return '专家新见解：\n\n• 人工智能在眼科的应用\n• 基因治疗在眼科的前景\n• 微创手术技术发展\n• 个性化治疗方案\n• 远程医疗新模式';
      case 'personal':
        return '个性化病例：\n\n• 基于基因检测的精准治疗\n• 个体化用药方案\n• 定制化康复计划\n• 家庭遗传史分析\n• 生活方式干预';
      case 'case':
        return '医学案例精选：\n\n• 疑难病例诊断过程\n• 罕见疾病治疗经验\n• 多学科会诊案例\n• 手术技巧分享\n• 并发症处理经验';
      case 'ai':
        return '智能诊断助手：\n\n• AI辅助影像诊断\n• 智能症状分析\n• 风险评估系统\n• 治疗方案推荐\n• 预后预测模型';
      case 'research':
        return '眼科疾病研究：\n\n• 最新研究成果\n• 临床试验进展\n• 新药研发动态\n• 医疗器械创新\n• 基础研究突破';
      default:
        return '暂无相关内容';
    }
  }

  IconData _getTagIcon(String tagId) {
    switch (tagId) {
      case 'latest':
        return Icons.new_releases;
      case 'vision':
        return Icons.visibility;
      case 'retina':
        return Icons.center_focus_strong;
      case 'common':
        return Icons.healing;
      case 'myopia':
        return Icons.visibility_off;
      case 'expert':
        return Icons.person;
      case 'personal':
        return Icons.person_pin;
      case 'case':
        return Icons.folder_open;
      case 'ai':
        return Icons.smart_toy;
      case 'research':
        return Icons.science;
      default:
        return Icons.image;
    }
  }

  // 图片选择功能
  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('拍照失败：$e')));
    }
  }

  Future<void> _pickImageFromGallery() async {
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
      ).showSnackBar(SnackBar(content: Text('选择图片失败：$e')));
    }
  }

  // AI分析图片功能
  void _analyzeImage() {
    if (_selectedImage == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('AI分析中'),
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

    // 模拟分析过程
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pop(context);
      _showAnalysisResult();
    });
  }

  void _showAnalysisResult() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('AI分析结果'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('初步分析结果：', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('• 眼部结构正常'),
            Text('• 无明显病变'),
            Text('• 建议定期检查'),
            Text('• 注意用眼卫生'),
            SizedBox(height: 16),
            Text('注意：此结果仅供参考，如有疑虑请咨询专业医生。'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('关闭'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToAI();
            },
            child: Text('详细咨询'),
          ),
        ],
      ),
    );
  }

  // 导航功能
  void _navigateToExperts() {
    // 通过回调函数切换到专家页面
    if (context.mounted) {
      // 使用Navigator来导航到专家页面
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ExpertPage()),
      );
    }
  }

  void _navigateToAI() {
    // 通过回调函数切换到AI页面
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AIPage()),
      );
    }
  }

  void _navigateToReports() {
    // 通过回调函数切换到报告页面
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ReportPage()),
      );
    }
  }

  void _navigateToRelatedContent(String tagId) {
    // 根据标签导航到相关内容
    switch (tagId) {
      case 'expert':
      case 'personal':
        _navigateToExperts();
        break;
      case 'ai':
        _navigateToAI();
        break;
      case 'case':
      case 'research':
        _navigateToReports();
        break;
      default:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('正在加载相关内容...')));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
