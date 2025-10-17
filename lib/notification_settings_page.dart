import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  @override
  _NotificationSettingsPageState createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _smsNotifications = false;
  bool _appointmentReminders = true;
  bool _prescriptionReminders = true;
  bool _healthTips = true;
  bool _promotionalMessages = false;
  bool _systemUpdates = true;
  String _reminderTime = '09:00';
  String _frequency = '每日';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('通知设置'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _saveSettings,
            child: Text('保存', style: TextStyle(color: Color(0xFF1976D2))),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 通知总开关
            _buildSectionCard('通知总开关', [
              _buildSwitchTile(
                '推送通知',
                '接收应用推送通知',
                _pushNotifications,
                (value) => setState(() => _pushNotifications = value),
              ),
              _buildSwitchTile(
                '邮件通知',
                '接收邮件通知',
                _emailNotifications,
                (value) => setState(() => _emailNotifications = value),
              ),
              _buildSwitchTile(
                '短信通知',
                '接收短信通知',
                _smsNotifications,
                (value) => setState(() => _smsNotifications = value),
              ),
            ]),

            SizedBox(height: 16),

            // 提醒设置
            _buildSectionCard('提醒设置', [
              _buildSwitchTile(
                '预约提醒',
                '预约前30分钟提醒',
                _appointmentReminders,
                (value) => setState(() => _appointmentReminders = value),
              ),
              _buildSwitchTile(
                '处方提醒',
                '处方到期提醒',
                _prescriptionReminders,
                (value) => setState(() => _prescriptionReminders = value),
              ),
              _buildListTile(
                '提醒时间',
                _reminderTime,
                Icons.access_time,
                () => _selectReminderTime(),
              ),
              _buildListTile(
                '提醒频率',
                _frequency,
                Icons.repeat,
                () => _selectFrequency(),
              ),
            ]),

            SizedBox(height: 16),

            // 内容通知
            _buildSectionCard('内容通知', [
              _buildSwitchTile(
                '健康小贴士',
                '每日健康建议和护眼知识',
                _healthTips,
                (value) => setState(() => _healthTips = value),
              ),
              _buildSwitchTile(
                '促销信息',
                '优惠活动和产品推荐',
                _promotionalMessages,
                (value) => setState(() => _promotionalMessages = value),
              ),
              _buildSwitchTile(
                '系统更新',
                '应用更新和功能通知',
                _systemUpdates,
                (value) => setState(() => _systemUpdates = value),
              ),
            ]),

            SizedBox(height: 16),

            // 免打扰设置
            _buildSectionCard('免打扰设置', [
              _buildListTile(
                '免打扰时间',
                '22:00 - 08:00',
                Icons.nightlight_round,
                () => _setDoNotDisturb(),
              ),
              _buildListTile(
                '静音模式',
                '关闭所有通知声音',
                Icons.volume_off,
                () => _setSilentMode(),
              ),
            ]),

            SizedBox(height: 24),

            // 测试通知按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _testNotification,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1976D2),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text('测试通知'),
              ),
            ),

            SizedBox(height: 16),

            // 清除通知按钮
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _clearNotifications,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Color(0xFF666666)),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text('清除所有通知'),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
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
            SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Color(0xFF1976D2),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
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

  void _selectReminderTime() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime(2024, 1, 1, 9, 0)),
    ).then((time) {
      if (time != null) {
        setState(() {
          _reminderTime =
              '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
        });
      }
    });
  }

  void _selectFrequency() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('选择提醒频率'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFrequencyOption('每日'),
            _buildFrequencyOption('每周'),
            _buildFrequencyOption('每月'),
            _buildFrequencyOption('仅重要通知'),
          ],
        ),
      ),
    );
  }

  Widget _buildFrequencyOption(String frequency) {
    return ListTile(
      title: Text(frequency),
      onTap: () {
        setState(() {
          _frequency = frequency;
        });
        Navigator.pop(context);
      },
    );
  }

  void _setDoNotDisturb() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('免打扰时间设置'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('开始时间'),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: '22:00',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text('结束时间'),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: '08:00',
                border: OutlineInputBorder(),
              ),
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
              ).showSnackBar(SnackBar(content: Text('免打扰时间设置成功')));
            },
            child: Text('确定'),
          ),
        ],
      ),
    );
  }

  void _setSilentMode() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('静音模式'),
        content: Text('开启后将关闭所有通知声音，但保留振动提醒。'),
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
              ).showSnackBar(SnackBar(content: Text('静音模式已开启')));
            },
            child: Text('开启'),
          ),
        ],
      ),
    );
  }

  void _testNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('测试通知已发送'),
        action: SnackBarAction(
          label: '查看',
          onPressed: () {
            // 处理查看通知的逻辑
          },
        ),
      ),
    );
  }

  void _clearNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('清除通知'),
        content: Text('确定要清除所有通知吗？'),
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
              ).showSnackBar(SnackBar(content: Text('所有通知已清除')));
            },
            child: Text('确定'),
          ),
        ],
      ),
    );
  }

  void _saveSettings() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('通知设置已保存')));
  }
}
