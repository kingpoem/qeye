import 'package:flutter/material.dart';

class MyFavoritesPage extends StatefulWidget {
  @override
  _MyFavoritesPageState createState() => _MyFavoritesPageState();
}

class _MyFavoritesPageState extends State<MyFavoritesPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = '全部';
  final List<String> _filters = ['全部', '专家', '文章', '视频'];

  final List<FavoriteItem> _favorites = [
    FavoriteItem(
      id: 'F001',
      type: '专家',
      title: '李医生 - 白内障专家',
      subtitle: '北京同仁医院 · 主任医师',
      description: '15年临床经验，擅长白内障手术',
      imageUrl: 'assets/images/doctor1.jpg',
      date: DateTime.now().subtract(Duration(days: 2)),
    ),
    FavoriteItem(
      id: 'F002',
      type: '文章',
      title: '如何预防近视？护眼小贴士',
      subtitle: '健康科普 · 阅读量 1.2万',
      description: '详细介绍预防近视的方法和护眼技巧',
      imageUrl: 'assets/images/article1.jpg',
      date: DateTime.now().subtract(Duration(days: 5)),
    ),
    FavoriteItem(
      id: 'F003',
      type: '视频',
      title: '眼部按摩操教学',
      subtitle: '健康视频 · 时长 5分钟',
      description: '专业的眼部按摩操，缓解眼疲劳',
      imageUrl: 'assets/images/video1.jpg',
      date: DateTime.now().subtract(Duration(days: 7)),
    ),
    FavoriteItem(
      id: 'F004',
      type: '专家',
      title: '王医生 - 青光眼专家',
      subtitle: '上海眼耳鼻喉科医院 · 副主任医师',
      description: '12年临床经验，擅长青光眼治疗',
      imageUrl: 'assets/images/doctor2.jpg',
      date: DateTime.now().subtract(Duration(days: 10)),
    ),
    FavoriteItem(
      id: 'F005',
      type: '文章',
      title: '干眼症的自我诊断与治疗',
      subtitle: '疾病科普 · 阅读量 8.5千',
      description: '干眼症的常见症状和治疗方法',
      imageUrl: 'assets/images/article2.jpg',
      date: DateTime.now().subtract(Duration(days: 15)),
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
        title: Text('我的收藏'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: _showSearchDialog),
          IconButton(icon: Icon(Icons.more_vert), onPressed: _showMoreOptions),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Color(0xFF1976D2),
          unselectedLabelColor: Color(0xFF666666),
          indicatorColor: Color(0xFF1976D2),
          tabs: [
            Tab(text: '全部'),
            Tab(text: '专家'),
            Tab(text: '内容'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllFavorites(),
          _buildExpertFavorites(),
          _buildContentFavorites(),
        ],
      ),
    );
  }

  Widget _buildAllFavorites() {
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
        // 收藏列表
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: _getFilteredFavorites().length,
            itemBuilder: (context, index) {
              return _buildFavoriteCard(_getFilteredFavorites()[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildExpertFavorites() {
    final expertFavorites = _favorites.where((f) => f.type == '专家').toList();
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: expertFavorites.length,
      itemBuilder: (context, index) {
        return _buildExpertCard(expertFavorites[index]);
      },
    );
  }

  Widget _buildContentFavorites() {
    final contentFavorites = _favorites.where((f) => f.type != '专家').toList();
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: contentFavorites.length,
      itemBuilder: (context, index) {
        return _buildContentCard(contentFavorites[index]);
      },
    );
  }

  Widget _buildFavoriteCard(FavoriteItem item) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _viewFavorite(item),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getTypeIcon(item.type),
                  size: 40,
                  color: Color(0xFF1976D2),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getTypeColor(item.type),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item.type,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () => _removeFavorite(item),
                          child: Icon(
                            Icons.favorite,
                            color: Color(0xFFE91E63),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                    ),
                    SizedBox(height: 4),
                    Text(
                      item.description,
                      style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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

  Widget _buildExpertCard(FavoriteItem item) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _viewFavorite(item),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Color(0xFFE3F2FD),
                child: Text(
                  item.title[0],
                  style: TextStyle(
                    color: Color(0xFF1976D2),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
                    ),
                    SizedBox(height: 4),
                    Text(
                      item.description,
                      style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () => _removeFavorite(item),
                    child: Icon(
                      Icons.favorite,
                      color: Color(0xFFE91E63),
                      size: 20,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '咨询',
                    style: TextStyle(fontSize: 10, color: Color(0xFF1976D2)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentCard(FavoriteItem item) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _viewFavorite(item),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getTypeColor(item.type),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.type,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () => _removeFavorite(item),
                    child: Icon(
                      Icons.favorite,
                      color: Color(0xFFE91E63),
                      size: 20,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                item.title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                item.subtitle,
                style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
              ),
              SizedBox(height: 8),
              Text(
                item.description,
                style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<FavoriteItem> _getFilteredFavorites() {
    if (_selectedFilter == '全部') {
      return _favorites;
    }
    return _favorites.where((f) => f.type == _selectedFilter).toList();
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case '专家':
        return Icons.person;
      case '文章':
        return Icons.article;
      case '视频':
        return Icons.play_circle;
      default:
        return Icons.favorite;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case '专家':
        return Color(0xFF1976D2);
      case '文章':
        return Color(0xFF4CAF50);
      case '视频':
        return Color(0xFFFF9800);
      default:
        return Color(0xFF9E9E9E);
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('搜索收藏'),
        content: TextField(
          decoration: InputDecoration(
            hintText: '请输入关键词',
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

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.sort),
              title: Text('排序'),
              onTap: () {
                Navigator.pop(context);
                _showSortOptions();
              },
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('分享收藏'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('分享功能开发中...')));
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('清空收藏'),
              onTap: () {
                Navigator.pop(context);
                _clearAllFavorites();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSortOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('排序方式'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('按时间排序'),
              onTap: () {
                Navigator.pop(context);
                // 实现排序逻辑
              },
            ),
            ListTile(
              title: Text('按类型排序'),
              onTap: () {
                Navigator.pop(context);
                // 实现排序逻辑
              },
            ),
            ListTile(
              title: Text('按标题排序'),
              onTap: () {
                Navigator.pop(context);
                // 实现排序逻辑
              },
            ),
          ],
        ),
      ),
    );
  }

  void _viewFavorite(FavoriteItem item) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('正在打开${item.title}...')));
  }

  void _removeFavorite(FavoriteItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('取消收藏'),
        content: Text('确定要取消收藏"${item.title}"吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _favorites.remove(item);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('已取消收藏')));
            },
            child: Text('确定'),
          ),
        ],
      ),
    );
  }

  void _clearAllFavorites() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('清空收藏'),
        content: Text('确定要清空所有收藏吗？此操作不可恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _favorites.clear();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('已清空所有收藏')));
            },
            child: Text('确定'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class FavoriteItem {
  final String id;
  final String type;
  final String title;
  final String subtitle;
  final String description;
  final String imageUrl;
  final DateTime date;

  FavoriteItem({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imageUrl,
    required this.date,
  });
}
