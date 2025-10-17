import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpertPage extends StatefulWidget {
  @override
  _ExpertPageState createState() => _ExpertPageState();
}

class _ExpertPageState extends State<ExpertPage> {
  String _selectedCategory = '全部';
  final List<String> _categories = ['全部', '白内障', '青光眼', '视网膜', '角膜', '屈光'];

  final List<Expert> _experts = [
    Expert(
      name: '李医生',
      title: '主任医师',
      department: '白内障科',
      hospital: '北京同仁医院',
      rating: 4.9,
      experience: '15年',
      specialties: ['白内障手术', '人工晶体植入', '复杂白内障'],
      avatar: '👨‍⚕️',
      consultationFee: 200,
      availableSlots: ['09:00', '10:30', '14:00', '15:30'],
    ),
    Expert(
      name: '王医生',
      title: '副主任医师',
      department: '青光眼科',
      hospital: '上海眼耳鼻喉科医院',
      rating: 4.8,
      experience: '12年',
      specialties: ['青光眼诊断', '激光治疗', '手术治疗'],
      avatar: '👩‍⚕️',
      consultationFee: 180,
      availableSlots: ['09:30', '11:00', '14:30', '16:00'],
    ),
    Expert(
      name: '张医生',
      title: '主任医师',
      department: '视网膜科',
      hospital: '广州中山眼科中心',
      rating: 4.9,
      experience: '18年',
      specialties: ['视网膜手术', '黄斑病变', '糖尿病视网膜病变'],
      avatar: '👨‍⚕️',
      consultationFee: 250,
      availableSlots: ['08:30', '10:00', '13:30', '15:00'],
    ),
    Expert(
      name: '陈医生',
      title: '主治医师',
      department: '角膜科',
      hospital: '深圳眼科医院',
      rating: 4.7,
      experience: '8年',
      specialties: ['角膜移植', '干眼症治疗', '角膜感染'],
      avatar: '👩‍⚕️',
      consultationFee: 150,
      availableSlots: ['09:00', '10:30', '14:00', '15:30', '16:30'],
    ),
    Expert(
      name: '刘医生',
      title: '主任医师',
      department: '屈光科',
      hospital: '成都爱尔眼科医院',
      rating: 4.8,
      experience: '20年',
      specialties: ['近视手术', '散光矫正', '老花眼治疗'],
      avatar: '👨‍⚕️',
      consultationFee: 220,
      availableSlots: ['08:00', '09:30', '11:00', '14:30'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('专家咨询'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _showSearchDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 分类筛选
          Container(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    selectedColor: Color(0xFFE3F2FD),
                    checkmarkColor: Color(0xFF1976D2),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 16),
          // 专家列表
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: _getFilteredExperts().length,
              itemBuilder: (context, index) {
                final expert = _getFilteredExperts()[index];
                return _buildExpertCard(expert);
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Expert> _getFilteredExperts() {
    if (_selectedCategory == '全部') {
      return _experts;
    }
    return _experts
        .where(
          (expert) =>
              expert.department.contains(_selectedCategory) ||
              expert.specialties.any(
                (specialty) => specialty.contains(_selectedCategory),
              ),
        )
        .toList();
  }

  Widget _buildExpertCard(Expert expert) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xFFE3F2FD),
                  child: Text(expert.avatar, style: TextStyle(fontSize: 24)),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        expert.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${expert.title} · ${expert.department}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                        ),
                      ),
                      Text(
                        expert.hospital,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF999999),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 4),
                        Text(
                          expert.rating.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      '¥${expert.consultationFee}/次',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF1976D2),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12),
            // 专业领域
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: expert.specialties.map((specialty) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    specialty,
                    style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 12),
            // 经验年限和可预约时间
            Row(
              children: [
                Icon(Icons.work, size: 16, color: Color(0xFF666666)),
                SizedBox(width: 4),
                Text(
                  '${expert.experience}经验',
                  style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                ),
                SizedBox(width: 16),
                Icon(Icons.access_time, size: 16, color: Color(0xFF666666)),
                SizedBox(width: 4),
                Text(
                  '今日可预约',
                  style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                ),
              ],
            ),
            SizedBox(height: 16),
            // 操作按钮
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _showExpertDetail(expert);
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Color(0xFF1976D2)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('查看详情'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _showBookingDialog(expert);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1976D2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('立即预约'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('搜索专家'),
        content: TextField(
          decoration: InputDecoration(
            hintText: '请输入专家姓名或专业领域',
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

  void _showExpertDetail(Expert expert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${expert.name} - ${expert.title}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('医院：${expert.hospital}'),
              Text('科室：${expert.department}'),
              Text('经验：${expert.experience}'),
              Text('评分：${expert.rating}'),
              SizedBox(height: 8),
              Text('专业领域：'),
              Wrap(
                spacing: 8,
                children: expert.specialties.map((specialty) {
                  return Chip(
                    label: Text(specialty),
                    backgroundColor: Color(0xFFE3F2FD),
                  );
                }).toList(),
              ),
              SizedBox(height: 8),
              Text('咨询费用：¥${expert.consultationFee}/次'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('关闭'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showBookingDialog(expert);
            },
            child: Text('立即预约'),
          ),
        ],
      ),
    );
  }

  void _showBookingDialog(Expert expert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('预约${expert.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('选择预约时间：'),
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: expert.availableSlots.map((slot) {
                return ActionChip(
                  label: Text(slot),
                  onPressed: () {
                    Navigator.pop(context);
                    _confirmBooking(expert, slot);
                  },
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('取消'),
          ),
        ],
      ),
    );
  }

  void _confirmBooking(Expert expert, String timeSlot) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('预约确认'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('专家：${expert.name}'),
            Text(
              '时间：${DateFormat('yyyy-MM-dd').format(DateTime.now())} $timeSlot',
            ),
            Text('费用：¥${expert.consultationFee}'),
            SizedBox(height: 8),
            Text('预约成功！专家将在预约时间前30分钟提醒您。'),
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
}

class Expert {
  final String name;
  final String title;
  final String department;
  final String hospital;
  final double rating;
  final String experience;
  final List<String> specialties;
  final String avatar;
  final int consultationFee;
  final List<String> availableSlots;

  Expert({
    required this.name,
    required this.title,
    required this.department,
    required this.hospital,
    required this.rating,
    required this.experience,
    required this.specialties,
    required this.avatar,
    required this.consultationFee,
    required this.availableSlots,
  });
}
