import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyReviewsPage extends StatefulWidget {
  @override
  _MyReviewsPageState createState() => _MyReviewsPageState();
}

class _MyReviewsPageState extends State<MyReviewsPage> {
  String _selectedFilter = '全部';
  final List<String> _filters = ['全部', '待评价', '已评价'];

  final List<Review> _reviews = [
    Review(
      id: 'R001',
      doctorName: '李医生',
      doctorTitle: '主任医师',
      hospital: '北京同仁医院',
      date: DateTime.now().subtract(Duration(days: 1)),
      status: '待评价',
      rating: 0,
      comment: '',
      type: '视频问诊',
    ),
    Review(
      id: 'R002',
      doctorName: '王医生',
      doctorTitle: '副主任医师',
      hospital: '上海眼耳鼻喉科医院',
      date: DateTime.now().subtract(Duration(days: 5)),
      status: '已评价',
      rating: 5,
      comment: '医生很专业，解答详细，态度很好。',
      type: '图文问诊',
    ),
    Review(
      id: 'R003',
      doctorName: '张医生',
      doctorTitle: '主任医师',
      hospital: '广州中山眼科中心',
      date: DateTime.now().subtract(Duration(days: 10)),
      status: '已评价',
      rating: 4,
      comment: '诊断准确，建议很实用。',
      type: '电话问诊',
    ),
    Review(
      id: 'R004',
      doctorName: '陈医生',
      doctorTitle: '主治医师',
      hospital: '深圳眼科医院',
      date: DateTime.now().subtract(Duration(days: 15)),
      status: '已评价',
      rating: 5,
      comment: '非常满意，医生很耐心，解释得很清楚。',
      type: '视频问诊',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的评价'),
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
          // 评价列表
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _getFilteredReviews().length,
              itemBuilder: (context, index) {
                return _buildReviewCard(_getFilteredReviews()[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Review review) {
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(review.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    review.status,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Spacer(),
                Text(
                  DateFormat('MM-dd').format(review.date),
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
                    review.doctorName[0],
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
                        '${review.doctorName} ${review.doctorTitle}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        review.hospital,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    review.type,
                    style: TextStyle(fontSize: 10, color: Color(0xFF666666)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            if (review.status == '已评价') ...[
              Row(
                children: [
                  Text('我的评分：', style: TextStyle(fontSize: 14)),
                  SizedBox(width: 8),
                  ...List.generate(5, (index) {
                    return Icon(
                      Icons.star,
                      size: 16,
                      color: index < review.rating ? Colors.amber : Colors.grey,
                    );
                  }),
                  SizedBox(width: 8),
                  Text(
                    '${review.rating}.0',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                ],
              ),
              if (review.comment.isNotEmpty) ...[
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    review.comment,
                    style: TextStyle(fontSize: 14, color: Color(0xFF333333)),
                  ),
                ),
              ],
            ],
            SizedBox(height: 12),
            Row(
              children: [
                if (review.status == '待评价') ...[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _rateDoctor(review),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF1976D2),
                      ),
                      child: Text('立即评价'),
                    ),
                  ),
                ],
                if (review.status == '已评价') ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _editReview(review),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(0xFF1976D2)),
                      ),
                      child: Text('修改评价'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _deleteReview(review),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(0xFFFF4444)),
                      ),
                      child: Text('删除评价'),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Review> _getFilteredReviews() {
    if (_selectedFilter == '全部') {
      return _reviews;
    }
    return _reviews.where((r) => r.status == _selectedFilter).toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case '待评价':
        return Color(0xFFFF9800);
      case '已评价':
        return Color(0xFF4CAF50);
      default:
        return Color(0xFF2196F3);
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('搜索评价'),
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

  void _rateDoctor(Review review) {
    int rating = 0;
    String comment = '';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('评价医生'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('请为${review.doctorName}医生打分：'),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        rating = index + 1;
                      });
                    },
                    child: Icon(
                      Icons.star,
                      size: 32,
                      color: index < rating ? Colors.amber : Colors.grey,
                    ),
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
                onChanged: (value) {
                  comment = value;
                },
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
                if (rating > 0) {
                  setState(() {
                    review.status = '已评价';
                    review.rating = rating;
                    review.comment = comment;
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('评价提交成功')));
                } else {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('请先选择评分')));
                }
              },
              child: Text('提交'),
            ),
          ],
        ),
      ),
    );
  }

  void _editReview(Review review) {
    _rateDoctor(review);
  }

  void _deleteReview(Review review) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('删除评价'),
        content: Text('确定要删除对${review.doctorName}医生的评价吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                review.status = '待评价';
                review.rating = 0;
                review.comment = '';
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('评价已删除')));
            },
            child: Text('确定'),
          ),
        ],
      ),
    );
  }
}

class Review {
  final String id;
  final String doctorName;
  final String doctorTitle;
  final String hospital;
  final DateTime date;
  String status;
  int rating;
  String comment;
  final String type;

  Review({
    required this.id,
    required this.doctorName,
    required this.doctorTitle,
    required this.hospital,
    required this.date,
    required this.status,
    required this.rating,
    required this.comment,
    required this.type,
  });
}
