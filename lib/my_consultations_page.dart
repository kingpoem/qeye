import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyConsultationsPage extends StatefulWidget {
  @override
  _MyConsultationsPageState createState() => _MyConsultationsPageState();
}

class _MyConsultationsPageState extends State<MyConsultationsPage> {
  String _selectedFilter = '全部';
  final List<String> _filters = ['全部', '进行中', '已完成', '已取消'];

  final List<Consultation> _consultations = [
    Consultation(
      id: 'C001',
      doctorName: '李医生',
      doctorTitle: '主任医师',
      department: '白内障科',
      hospital: '北京同仁医院',
      date: DateTime.now().subtract(Duration(days: 1)),
      status: '进行中',
      type: '视频问诊',
      duration: 30,
      fee: 200,
      description: '视力模糊，眼睛干涩',
    ),
    Consultation(
      id: 'C002',
      doctorName: '王医生',
      doctorTitle: '副主任医师',
      department: '青光眼科',
      hospital: '上海眼耳鼻喉科医院',
      date: DateTime.now().subtract(Duration(days: 5)),
      status: '已完成',
      type: '图文问诊',
      duration: 15,
      fee: 150,
      description: '眼压检查结果咨询',
    ),
    Consultation(
      id: 'C003',
      doctorName: '张医生',
      doctorTitle: '主任医师',
      department: '视网膜科',
      hospital: '广州中山眼科中心',
      date: DateTime.now().subtract(Duration(days: 10)),
      status: '已完成',
      type: '电话问诊',
      duration: 20,
      fee: 180,
      description: '眼底检查报告解读',
    ),
    Consultation(
      id: 'C004',
      doctorName: '陈医生',
      doctorTitle: '主治医师',
      department: '角膜科',
      hospital: '深圳眼科医院',
      date: DateTime.now().subtract(Duration(days: 15)),
      status: '已取消',
      type: '视频问诊',
      duration: 0,
      fee: 120,
      description: '角膜问题咨询',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的问诊'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: _showSearchDialog),
        ],
      ),
      body: Column(
        children: [
          // 筛选标签
          Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                    selectedColor: Color(0xFFE3F2FD),
                    checkmarkColor: Color(0xFF1976D2),
                  ),
                );
              },
            ),
          ),
          // 问诊列表
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _getFilteredConsultations().length,
              itemBuilder: (context, index) {
                return _buildConsultationCard(
                  _getFilteredConsultations()[index],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startNewConsultation,
        backgroundColor: Color(0xFF1976D2),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildConsultationCard(Consultation consultation) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showConsultationDetail(consultation),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(consultation.status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      consultation.status,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    DateFormat('MM-dd HH:mm').format(consultation.date),
                    style: TextStyle(color: Color(0xFF666666), fontSize: 12),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Color(0xFFE3F2FD),
                    child: Text(
                      consultation.doctorName[0],
                      style: TextStyle(
                        color: Color(0xFF1976D2),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${consultation.doctorName} ${consultation.doctorTitle}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${consultation.department} · ${consultation.hospital}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '¥${consultation.fee}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.chat, size: 16, color: Color(0xFF666666)),
                    SizedBox(width: 8),
                    Text(
                      consultation.type,
                      style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                    ),
                    SizedBox(width: 16),
                    Icon(Icons.access_time, size: 16, color: Color(0xFF666666)),
                    SizedBox(width: 8),
                    Text(
                      '${consultation.duration}分钟',
                      style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Text(
                consultation.description,
                style: TextStyle(fontSize: 14, color: Color(0xFF333333)),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  if (consultation.status == '进行中') ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _continueConsultation(consultation),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Color(0xFF1976D2)),
                        ),
                        child: Text('继续问诊'),
                      ),
                    ),
                    SizedBox(width: 12),
                  ],
                  if (consultation.status == '已完成') ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _viewReport(consultation),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Color(0xFF4CAF50)),
                        ),
                        child: Text('查看报告'),
                      ),
                    ),
                    SizedBox(width: 12),
                  ],
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _rateConsultation(consultation),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(0xFFFF9800)),
                      ),
                      child: Text('评价'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Consultation> _getFilteredConsultations() {
    if (_selectedFilter == '全部') {
      return _consultations;
    }
    return _consultations.where((c) => c.status == _selectedFilter).toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case '进行中':
        return Color(0xFFFF9800);
      case '已完成':
        return Color(0xFF4CAF50);
      case '已取消':
        return Color(0xFF9E9E9E);
      default:
        return Color(0xFF2196F3);
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('搜索问诊'),
        content: TextField(
          decoration: InputDecoration(
            hintText: '请输入医生姓名或医院',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('搜索'),
          ),
        ],
      ),
    );
  }

  void _startNewConsultation() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '选择问诊方式',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildConsultationTypeOption('视频问诊', Icons.video_call, '面对面视频交流'),
            _buildConsultationTypeOption('图文问诊', Icons.chat, '文字图片交流'),
            _buildConsultationTypeOption('电话问诊', Icons.phone, '语音电话交流'),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildConsultationTypeOption(
    String title,
    IconData icon,
    String description,
  ) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF1976D2)),
      title: Text(title),
      subtitle: Text(description),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('正在为您匹配专家...')));
      },
    );
  }

  void _showConsultationDetail(Consultation consultation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('问诊详情'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('医生：${consultation.doctorName} ${consultation.doctorTitle}'),
              Text('科室：${consultation.department}'),
              Text('医院：${consultation.hospital}'),
              Text(
                '问诊时间：${DateFormat('yyyy-MM-dd HH:mm').format(consultation.date)}',
              ),
              Text('问诊方式：${consultation.type}'),
              Text('问诊时长：${consultation.duration}分钟'),
              Text('费用：¥${consultation.fee}'),
              Text('状态：${consultation.status}'),
              SizedBox(height: 8),
              Text('问题描述：${consultation.description}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('关闭'),
          ),
          if (consultation.status == '进行中')
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _continueConsultation(consultation);
              },
              child: Text('继续问诊'),
            ),
        ],
      ),
    );
  }

  void _continueConsultation(Consultation consultation) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('正在连接医生...')));
  }

  void _viewReport(Consultation consultation) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('正在加载问诊报告...')));
  }

  void _rateConsultation(Consultation consultation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('评价问诊'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('请为这次问诊打分：'),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    Icons.star,
                    color: index < 4 ? Colors.amber : Colors.grey,
                  ),
                  onPressed: () {
                    // 处理评分逻辑
                  },
                );
              }),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: '请输入评价内容（可选）',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('评价提交成功')));
            },
            child: Text('提交'),
          ),
        ],
      ),
    );
  }
}

class Consultation {
  final String id;
  final String doctorName;
  final String doctorTitle;
  final String department;
  final String hospital;
  final DateTime date;
  final String status;
  final String type;
  final int duration;
  final int fee;
  final String description;

  Consultation({
    required this.id,
    required this.doctorName,
    required this.doctorTitle,
    required this.department,
    required this.hospital,
    required this.date,
    required this.status,
    required this.type,
    required this.duration,
    required this.fee,
    required this.description,
  });
}
