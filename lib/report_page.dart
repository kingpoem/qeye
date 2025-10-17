import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = '全部';
  final List<String> _filters = ['全部', '本月', '近3个月', '近半年', '近一年'];

  final List<Report> _reports = [
    Report(
      id: 'R001',
      title: '视力检查报告',
      type: '视力检查',
      date: DateTime.now().subtract(Duration(days: 2)),
      status: '已完成',
      doctor: '李医生',
      hospital: '北京同仁医院',
      summary: '双眼视力正常，左眼1.0，右眼1.0',
      details: {
        '左眼视力': '1.0',
        '右眼视力': '1.0',
        '眼压': '正常',
        '眼底': '正常',
        '建议': '保持良好用眼习惯，定期复查',
      },
      images: ['assets/images/eye_exam1.jpg', 'assets/images/eye_exam2.jpg'],
    ),
    Report(
      id: 'R002',
      title: '眼底检查报告',
      type: '眼底检查',
      date: DateTime.now().subtract(Duration(days: 15)),
      status: '已完成',
      doctor: '王医生',
      hospital: '上海眼耳鼻喉科医院',
      summary: '眼底血管正常，无异常发现',
      details: {
        '视网膜': '正常',
        '视神经': '正常',
        '血管': '正常',
        '黄斑': '正常',
        '建议': '每年定期检查',
      },
      images: ['assets/images/fundus1.jpg'],
    ),
    Report(
      id: 'R003',
      title: '角膜地形图检查',
      type: '角膜检查',
      date: DateTime.now().subtract(Duration(days: 30)),
      status: '已完成',
      doctor: '张医生',
      hospital: '广州中山眼科中心',
      summary: '角膜形态正常，适合进行屈光手术',
      details: {'角膜厚度': '正常', '角膜曲率': '正常', '散光': '轻微', '建议': '可考虑屈光手术'},
      images: ['assets/images/cornea1.jpg', 'assets/images/cornea2.jpg'],
    ),
    Report(
      id: 'R004',
      title: '眼压检查报告',
      type: '眼压检查',
      date: DateTime.now().subtract(Duration(days: 45)),
      status: '已完成',
      doctor: '陈医生',
      hospital: '深圳眼科医院',
      summary: '眼压正常，无青光眼风险',
      details: {
        '左眼眼压': '15mmHg',
        '右眼眼压': '16mmHg',
        '正常范围': '10-21mmHg',
        '建议': '继续观察，定期检查',
      },
      images: [],
    ),
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
        title: Text('检查报告'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Color(0xFF1976D2),
          unselectedLabelColor: Color(0xFF666666),
          indicatorColor: Color(0xFF1976D2),
          tabs: [
            Tab(text: '报告列表', icon: Icon(Icons.list)),
            Tab(text: '数据统计', icon: Icon(Icons.bar_chart)),
            Tab(text: '趋势分析', icon: Icon(Icons.trending_up)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildReportList(),
          _buildStatisticsTab(),
          _buildTrendAnalysisTab(),
        ],
      ),
    );
  }

  Widget _buildReportList() {
    final filteredReports = _getFilteredReports();

    return Column(
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
        // 报告列表
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: filteredReports.length,
            itemBuilder: (context, index) {
              return _buildReportCard(filteredReports[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReportCard(Report report) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showReportDetail(report),
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
                      color: _getStatusColor(report.status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      report.status,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    DateFormat('MM-dd').format(report.date),
                    style: TextStyle(color: Color(0xFF666666), fontSize: 12),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text(
                report.title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                report.summary,
                style: TextStyle(color: Color(0xFF666666), fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: Color(0xFF666666)),
                  SizedBox(width: 4),
                  Text(
                    report.doctor,
                    style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.location_on, size: 16, color: Color(0xFF666666)),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      report.hospital,
                      style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (report.images.isNotEmpty) ...[
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.image, size: 16, color: Color(0xFF666666)),
                    SizedBox(width: 4),
                    Text(
                      '包含${report.images.length}张图片',
                      style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 检查统计卡片
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  '总检查次数',
                  '${_reports.length}',
                  Icons.visibility,
                  Color(0xFF1976D2),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  '本月检查',
                  '2',
                  Icons.calendar_today,
                  Color(0xFF4CAF50),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  '正常报告',
                  '${_reports.where((r) => r.status == '已完成').length}',
                  Icons.check_circle,
                  Color(0xFF4CAF50),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  '异常报告',
                  '0',
                  Icons.warning,
                  Color(0xFFFF9800),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),

          // 检查类型分布
          Text(
            '检查类型分布',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Container(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: _getPieChartData(),
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              ),
            ),
          ),
          SizedBox(height: 24),

          // 月度检查趋势
          Text(
            '月度检查趋势',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Container(
            height: 200,
            child: BarChart(
              BarChartData(
                barGroups: _getBarChartData(),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendAnalysisTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 视力趋势
          Text(
            '视力变化趋势',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Container(
            height: 200,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 1.0),
                      FlSpot(1, 1.0),
                      FlSpot(2, 0.9),
                      FlSpot(3, 0.9),
                      FlSpot(4, 0.8),
                    ],
                    isCurved: true,
                    color: Color(0xFF1976D2),
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                  ),
                ],
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: true),
                gridData: FlGridData(show: true),
              ),
            ),
          ),
          SizedBox(height: 24),

          // 健康建议
          Text(
            '健康建议',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          _buildAdviceCard(
            '用眼卫生',
            '保持良好的用眼习惯，避免长时间用眼',
            Icons.visibility,
            Color(0xFF1976D2),
          ),
          SizedBox(height: 12),
          _buildAdviceCard(
            '定期检查',
            '建议每6个月进行一次全面眼部检查',
            Icons.calendar_today,
            Color(0xFF4CAF50),
          ),
          SizedBox(height: 12),
          _buildAdviceCard(
            '营养补充',
            '适当补充维生素A和叶黄素',
            Icons.restaurant,
            Color(0xFFFF9800),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          Icon(icon, size: 32, color: color),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(title, style: TextStyle(fontSize: 12, color: Color(0xFF666666))),
        ],
      ),
    );
  }

  Widget _buildAdviceCard(
    String title,
    String content,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Report> _getFilteredReports() {
    if (_selectedFilter == '全部') {
      return _reports;
    }

    DateTime cutoffDate;
    switch (_selectedFilter) {
      case '本月':
        cutoffDate = DateTime.now().subtract(Duration(days: 30));
        break;
      case '近3个月':
        cutoffDate = DateTime.now().subtract(Duration(days: 90));
        break;
      case '近半年':
        cutoffDate = DateTime.now().subtract(Duration(days: 180));
        break;
      case '近一年':
        cutoffDate = DateTime.now().subtract(Duration(days: 365));
        break;
      default:
        return _reports;
    }

    return _reports.where((report) => report.date.isAfter(cutoffDate)).toList();
  }

  List<PieChartSectionData> _getPieChartData() {
    final typeCount = <String, int>{};
    for (var report in _reports) {
      typeCount[report.type] = (typeCount[report.type] ?? 0) + 1;
    }

    final colors = [
      Color(0xFF1976D2),
      Color(0xFF4CAF50),
      Color(0xFFFF9800),
      Color(0xFFE91E63),
    ];

    return typeCount.entries.map((entry) {
      final index = typeCount.keys.toList().indexOf(entry.key);
      return PieChartSectionData(
        color: colors[index % colors.length],
        value: entry.value.toDouble(),
        title: entry.key,
        radius: 50,
        titleStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  List<BarChartGroupData> _getBarChartData() {
    return [
      BarChartGroupData(
        x: 0,
        barRods: [BarChartRodData(toY: 2, color: Color(0xFF1976D2))],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [BarChartRodData(toY: 1, color: Color(0xFF1976D2))],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [BarChartRodData(toY: 3, color: Color(0xFF1976D2))],
      ),
      BarChartGroupData(
        x: 3,
        barRods: [BarChartRodData(toY: 1, color: Color(0xFF1976D2))],
      ),
      BarChartGroupData(
        x: 4,
        barRods: [BarChartRodData(toY: 2, color: Color(0xFF1976D2))],
      ),
    ];
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case '已完成':
        return Color(0xFF4CAF50);
      case '进行中':
        return Color(0xFFFF9800);
      case '待处理':
        return Color(0xFF2196F3);
      default:
        return Color(0xFF9E9E9E);
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('筛选报告'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: _filters.map((filter) {
            return RadioListTile<String>(
              title: Text(filter),
              value: filter,
              groupValue: _selectedFilter,
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showReportDetail(Report report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(report.title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('检查日期：${DateFormat('yyyy-MM-dd').format(report.date)}'),
              Text('检查医生：${report.doctor}'),
              Text('检查医院：${report.hospital}'),
              SizedBox(height: 16),
              Text('检查结果：', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(report.summary),
              SizedBox(height: 16),
              Text('详细数据：', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              ...report.details.entries.map((entry) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.key),
                      Text(
                        entry.value,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              }).toList(),
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
              _shareReport(report);
            },
            child: Text('分享报告'),
          ),
        ],
      ),
    );
  }

  void _shareReport(Report report) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('报告分享功能开发中...')));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class Report {
  final String id;
  final String title;
  final String type;
  final DateTime date;
  final String status;
  final String doctor;
  final String hospital;
  final String summary;
  final Map<String, String> details;
  final List<String> images;

  Report({
    required this.id,
    required this.title,
    required this.type,
    required this.date,
    required this.status,
    required this.doctor,
    required this.hospital,
    required this.summary,
    required this.details,
    required this.images,
  });
}
