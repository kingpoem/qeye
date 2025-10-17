import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyPrescriptionsPage extends StatefulWidget {
  @override
  _MyPrescriptionsPageState createState() => _MyPrescriptionsPageState();
}

class _MyPrescriptionsPageState extends State<MyPrescriptionsPage> {
  String _selectedFilter = '全部';
  final List<String> _filters = ['全部', '待取药', '已取药', '已过期'];

  final List<Prescription> _prescriptions = [
    Prescription(
      id: 'P001',
      doctorName: '李医生',
      doctorTitle: '主任医师',
      hospital: '北京同仁医院',
      date: DateTime.now().subtract(Duration(days: 2)),
      status: '待取药',
      totalAmount: 156.50,
      items: [
        PrescriptionItem(
          name: '左氧氟沙星滴眼液',
          specification: '5ml:15mg',
          quantity: 2,
          unit: '支',
          price: 28.50,
          usage: '滴眼，一日3次',
        ),
        PrescriptionItem(
          name: '玻璃酸钠滴眼液',
          specification: '0.1% 5ml',
          quantity: 1,
          unit: '支',
          price: 45.00,
          usage: '滴眼，一日4次',
        ),
        PrescriptionItem(
          name: '维生素A软胶囊',
          specification: '5000IU*30粒',
          quantity: 1,
          unit: '盒',
          price: 55.00,
          usage: '口服，一日1次',
        ),
      ],
    ),
    Prescription(
      id: 'P002',
      doctorName: '王医生',
      doctorTitle: '副主任医师',
      hospital: '上海眼耳鼻喉科医院',
      date: DateTime.now().subtract(Duration(days: 10)),
      status: '已取药',
      totalAmount: 89.20,
      items: [
        PrescriptionItem(
          name: '妥布霉素滴眼液',
          specification: '5ml:15mg',
          quantity: 1,
          unit: '支',
          price: 34.20,
          usage: '滴眼，一日3次',
        ),
        PrescriptionItem(
          name: '复方硫酸软骨素滴眼液',
          specification: '5ml',
          quantity: 1,
          unit: '支',
          price: 55.00,
          usage: '滴眼，一日4次',
        ),
      ],
    ),
    Prescription(
      id: 'P003',
      doctorName: '张医生',
      doctorTitle: '主任医师',
      hospital: '广州中山眼科中心',
      date: DateTime.now().subtract(Duration(days: 30)),
      status: '已过期',
      totalAmount: 234.80,
      items: [
        PrescriptionItem(
          name: '阿托品眼用凝胶',
          specification: '2.5g:25mg',
          quantity: 1,
          unit: '支',
          price: 45.80,
          usage: '滴眼，一日1次',
        ),
        PrescriptionItem(
          name: '氟米龙滴眼液',
          specification: '5ml:5mg',
          quantity: 2,
          unit: '支',
          price: 89.00,
          usage: '滴眼，一日2次',
        ),
        PrescriptionItem(
          name: '叶黄素软胶囊',
          specification: '20mg*60粒',
          quantity: 1,
          unit: '盒',
          price: 100.00,
          usage: '口服，一日1次',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的处方'),
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
          // 处方列表
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _getFilteredPrescriptions().length,
              itemBuilder: (context, index) {
                return _buildPrescriptionCard(
                  _getFilteredPrescriptions()[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrescriptionCard(Prescription prescription) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showPrescriptionDetail(prescription),
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
                      color: _getStatusColor(prescription.status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      prescription.status,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    DateFormat('MM-dd').format(prescription.date),
                    style: TextStyle(color: Color(0xFF666666), fontSize: 12),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.receipt, color: Color(0xFF1976D2), size: 20),
                  SizedBox(width: 8),
                  Text(
                    '处方单号：${prescription.id}',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                '${prescription.doctorName} ${prescription.doctorTitle}',
                style: TextStyle(fontSize: 14, color: Color(0xFF666666)),
              ),
              Text(
                prescription.hospital,
                style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
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
                    Icon(Icons.medication, size: 16, color: Color(0xFF666666)),
                    SizedBox(width: 8),
                    Text(
                      '${prescription.items.length}种药品',
                      style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                    ),
                    Spacer(),
                    Text(
                      '¥${prescription.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  if (prescription.status == '待取药') ...[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _pickUpMedicine(prescription),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4CAF50),
                        ),
                        child: Text('去取药'),
                      ),
                    ),
                    SizedBox(width: 12),
                  ],
                  if (prescription.status == '已取药') ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _viewPrescriptionDetail(prescription),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Color(0xFF4CAF50)),
                        ),
                        child: Text('查看详情'),
                      ),
                    ),
                    SizedBox(width: 12),
                  ],
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _sharePrescription(prescription),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(0xFF1976D2)),
                      ),
                      child: Text('分享'),
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

  List<Prescription> _getFilteredPrescriptions() {
    if (_selectedFilter == '全部') {
      return _prescriptions;
    }
    return _prescriptions.where((p) => p.status == _selectedFilter).toList();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case '待取药':
        return Color(0xFFFF9800);
      case '已取药':
        return Color(0xFF4CAF50);
      case '已过期':
        return Color(0xFF9E9E9E);
      default:
        return Color(0xFF2196F3);
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('搜索处方'),
        content: TextField(
          decoration: InputDecoration(
            hintText: '请输入药品名称或医生姓名',
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

  void _showPrescriptionDetail(Prescription prescription) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('处方详情'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('处方单号：${prescription.id}'),
              Text('医生：${prescription.doctorName} ${prescription.doctorTitle}'),
              Text('医院：${prescription.hospital}'),
              Text(
                '开方日期：${DateFormat('yyyy-MM-dd').format(prescription.date)}',
              ),
              Text('状态：${prescription.status}'),
              SizedBox(height: 16),
              Text('药品清单：', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              ...prescription.items.map((item) {
                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${item.name} ${item.specification}'),
                      Text('数量：${item.quantity}${item.unit}'),
                      Text('用法：${item.usage}'),
                      Text('价格：¥${item.price.toStringAsFixed(2)}'),
                    ],
                  ),
                );
              }).toList(),
              SizedBox(height: 8),
              Text(
                '总金额：¥${prescription.totalAmount.toStringAsFixed(2)}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
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
              _sharePrescription(prescription);
            },
            child: Text('分享'),
          ),
        ],
      ),
    );
  }

  void _pickUpMedicine(Prescription prescription) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('取药确认'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('确认要取药吗？'),
            SizedBox(height: 16),
            Text('处方单号：${prescription.id}'),
            Text('总金额：¥${prescription.totalAmount.toStringAsFixed(2)}'),
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
              setState(() {
                prescription.status = '已取药';
              });
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('取药成功')));
            },
            child: Text('确认取药'),
          ),
        ],
      ),
    );
  }

  void _viewPrescriptionDetail(Prescription prescription) {
    _showPrescriptionDetail(prescription);
  }

  void _sharePrescription(Prescription prescription) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('处方分享功能开发中...')));
  }
}

class Prescription {
  final String id;
  final String doctorName;
  final String doctorTitle;
  final String hospital;
  final DateTime date;
  String status;
  final double totalAmount;
  final List<PrescriptionItem> items;

  Prescription({
    required this.id,
    required this.doctorName,
    required this.doctorTitle,
    required this.hospital,
    required this.date,
    required this.status,
    required this.totalAmount,
    required this.items,
  });
}

class PrescriptionItem {
  final String name;
  final String specification;
  final int quantity;
  final String unit;
  final double price;
  final String usage;

  PrescriptionItem({
    required this.name,
    required this.specification,
    required this.quantity,
    required this.unit,
    required this.price,
    required this.usage,
  });
}
