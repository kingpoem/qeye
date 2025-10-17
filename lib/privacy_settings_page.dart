import 'package:flutter/material.dart';

class PrivacySettingsPage extends StatefulWidget {
  @override
  _PrivacySettingsPageState createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  bool _dataCollection = true;
  bool _analytics = true;
  bool _crashReporting = true;
  bool _personalizedAds = false;
  bool _locationTracking = false;
  bool _cameraAccess = true;
  bool _photoAccess = true;
  bool _microphoneAccess = false;
  String _dataRetention = '1年';
  bool _twoFactorAuth = false;
  bool _biometricAuth = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('隐私设置'),
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
            // 数据收集与使用
            _buildSectionCard('数据收集与使用', [
              _buildSwitchTile(
                '数据收集',
                '允许收集使用数据以改善服务',
                _dataCollection,
                (value) => setState(() => _dataCollection = value),
              ),
              _buildSwitchTile(
                '分析数据',
                '收集应用使用情况分析数据',
                _analytics,
                (value) => setState(() => _analytics = value),
              ),
              _buildSwitchTile(
                '崩溃报告',
                '自动发送崩溃报告以帮助修复问题',
                _crashReporting,
                (value) => setState(() => _crashReporting = value),
              ),
              _buildSwitchTile(
                '个性化广告',
                '基于兴趣显示相关广告',
                _personalizedAds,
                (value) => setState(() => _personalizedAds = value),
              ),
            ]),

            SizedBox(height: 16),

            // 位置与权限
            _buildSectionCard('位置与权限', [
              _buildSwitchTile(
                '位置跟踪',
                '允许应用访问位置信息',
                _locationTracking,
                (value) => setState(() => _locationTracking = value),
              ),
              _buildSwitchTile(
                '相机权限',
                '允许访问相机进行拍照',
                _cameraAccess,
                (value) => setState(() => _cameraAccess = value),
              ),
              _buildSwitchTile(
                '相册权限',
                '允许访问相册选择图片',
                _photoAccess,
                (value) => setState(() => _photoAccess = value),
              ),
              _buildSwitchTile(
                '麦克风权限',
                '允许访问麦克风进行语音输入',
                _microphoneAccess,
                (value) => setState(() => _microphoneAccess = value),
              ),
            ]),

            SizedBox(height: 16),

            // 数据管理
            _buildSectionCard('数据管理', [
              _buildListTile(
                '数据保留期限',
                _dataRetention,
                Icons.schedule,
                () => _selectDataRetention(),
              ),
              _buildListTile(
                '导出数据',
                '下载您的个人数据',
                Icons.download,
                () => _exportData(),
              ),
              _buildListTile(
                '删除账户',
                '永久删除账户和所有数据',
                Icons.delete_forever,
                () => _deleteAccount(),
              ),
            ]),

            SizedBox(height: 16),

            // 安全设置
            _buildSectionCard('安全设置', [
              _buildSwitchTile(
                '双重验证',
                '登录时要求额外验证',
                _twoFactorAuth,
                (value) => setState(() => _twoFactorAuth = value),
              ),
              _buildSwitchTile(
                '生物识别',
                '使用指纹或面部识别登录',
                _biometricAuth,
                (value) => setState(() => _biometricAuth = value),
              ),
              _buildListTile(
                '修改密码',
                '更改登录密码',
                Icons.lock,
                () => _changePassword(),
              ),
              _buildListTile(
                '登录设备',
                '管理已登录的设备',
                Icons.devices,
                () => _manageDevices(),
              ),
            ]),

            SizedBox(height: 16),

            // 隐私政策
            _buildSectionCard('隐私政策', [
              _buildListTile(
                '隐私政策',
                '查看完整的隐私政策',
                Icons.privacy_tip,
                () => _viewPrivacyPolicy(),
              ),
              _buildListTile(
                '用户协议',
                '查看用户服务协议',
                Icons.description,
                () => _viewUserAgreement(),
              ),
              _buildListTile(
                'Cookie政策',
                '了解Cookie使用情况',
                Icons.cookie,
                () => _viewCookiePolicy(),
              ),
            ]),

            SizedBox(height: 24),

            // 重置设置按钮
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _resetSettings,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Color(0xFFFF4444)),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text('重置所有设置'),
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

  void _selectDataRetention() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('选择数据保留期限'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRetentionOption('6个月'),
            _buildRetentionOption('1年'),
            _buildRetentionOption('2年'),
            _buildRetentionOption('永久保留'),
          ],
        ),
      ),
    );
  }

  Widget _buildRetentionOption(String period) {
    return ListTile(
      title: Text(period),
      onTap: () {
        setState(() {
          _dataRetention = period;
        });
        Navigator.pop(context);
      },
    );
  }

  void _exportData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('导出数据'),
        content: Text('确定要导出您的个人数据吗？数据将以JSON格式下载。'),
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
              ).showSnackBar(SnackBar(content: Text('数据导出已开始，请稍后查看下载')));
            },
            child: Text('确定'),
          ),
        ],
      ),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('删除账户'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('确定要永久删除您的账户吗？'),
            SizedBox(height: 8),
            Text(
              '此操作不可恢复，所有数据将被永久删除。',
              style: TextStyle(color: Color(0xFFFF4444)),
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
              _confirmDeleteAccount();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFF4444)),
            child: Text('确定删除'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('最终确认'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('请输入"删除"以确认删除账户：'),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '请输入"删除"',
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
              ).showSnackBar(SnackBar(content: Text('账户删除请求已提交，将在7个工作日内处理')));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFF4444)),
            child: Text('确认删除'),
          ),
        ],
      ),
    );
  }

  void _changePassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('修改密码'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: '当前密码',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: '新密码',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: '确认新密码',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
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
              ).showSnackBar(SnackBar(content: Text('密码修改成功')));
            },
            child: Text('确定'),
          ),
        ],
      ),
    );
  }

  void _manageDevices() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('登录设备'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.phone_android),
              title: Text('当前设备'),
              subtitle: Text('iPhone 14 Pro'),
              trailing: Icon(Icons.check, color: Color(0xFF4CAF50)),
            ),
            ListTile(
              leading: Icon(Icons.computer),
              title: Text('MacBook Pro'),
              subtitle: Text('最后登录：2天前'),
              trailing: IconButton(
                icon: Icon(Icons.logout, color: Color(0xFFFF4444)),
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('设备已登出')));
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('关闭'),
          ),
        ],
      ),
    );
  }

  void _viewPrivacyPolicy() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('正在打开隐私政策...')));
  }

  void _viewUserAgreement() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('正在打开用户协议...')));
  }

  void _viewCookiePolicy() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('正在打开Cookie政策...')));
  }

  void _resetSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('重置设置'),
        content: Text('确定要将所有隐私设置重置为默认值吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _dataCollection = true;
                _analytics = true;
                _crashReporting = true;
                _personalizedAds = false;
                _locationTracking = false;
                _cameraAccess = true;
                _photoAccess = true;
                _microphoneAccess = false;
                _dataRetention = '1年';
                _twoFactorAuth = false;
                _biometricAuth = true;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('设置已重置为默认值')));
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
    ).showSnackBar(SnackBar(content: Text('隐私设置已保存')));
  }
}
