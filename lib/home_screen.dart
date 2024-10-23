import 'package:flutter/material.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';
import 'about_screen.dart';
import 'share_screen.dart';
import 'splash_screen.dart';
import 'database_helper.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController _searchController =
      TextEditingController(); // کنترلر برای جستجوی کلمات
  DatabaseHelper _dbHelper = DatabaseHelper.instance; // دسترسی به دیتابیس
  List<Map<String, dynamic>> _searchResults = []; // لیست نتایج جستجو
  List<int> _favoriteIds = []; // آیدی کلمات موجود در علاقه‌مندی‌ها

  // متد جستجو در دیتابیس بر اساس ورودی کاربر
  _searchWord(String query) async {
    if (query.isNotEmpty) {
      var results = await _dbHelper.searchWord(query);
      setState(() {
        _searchResults = results;
      });
      _loadFavoriteIds(); // به‌روزرسانی علاقه‌مندی‌ها پس از جستجو
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  // بارگذاری آیدی‌های علاقه‌مندی‌ها
  _loadFavoriteIds() async {
    List<Map<String, dynamic>> favorites = await _dbHelper.getFavorites();
    setState(() {
      _favoriteIds = favorites.map((fav) => fav['id'] as int).toList();
    });
  }

  // افزودن یا حذف لغات از علاقه‌مندی‌ها و نمایش پیام SnackBar
  _toggleFavorite(int wordId) async {
    bool isFavorite = await _dbHelper.isFavorite(wordId);
    if (isFavorite) {
      await _dbHelper.removeFromFavorites(wordId); // حذف از علاقه‌مندی‌ها
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Removed from favorites!')),
      );
    } else {
      await _dbHelper.addToFavorites(wordId); // افزودن به علاقه‌مندی‌ها
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added to favorites!')),
      );
    }
    _loadFavoriteIds(); // به‌روزرسانی لیست علاقه‌مندی‌ها
  }

  @override
  void initState() {
    super.initState();
    _loadFavoriteIds(); // بارگذاری علاقه‌مندی‌ها در ابتدای اجرا
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.blueAccent,
        appBar: AppBar(
          backgroundColor: Colors.blue[100],
          title: Text('Dictionary'),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                _searchWord(_searchController.text); // شروع جستجو
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: Container(
            color: Colors.black, // تغییر رنگ Drawer به سیاه
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text('Elyas', style: TextStyle(fontSize: 20)),
                  accountEmail: Text('07960000000'),
                  currentAccountPicture: CircleAvatar(
                    child: Text('E', style: TextStyle(fontSize: 45)),
                  ),
                  decoration: BoxDecoration(
                    gradient:
                        LinearGradient(colors: [Colors.blue, Colors.black]),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.favorite, color: Colors.white),
                  title:
                      Text('Favorites', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FavoritesScreen()));
                  },
                ),
                Divider(color: Colors.white), // خط جداکننده بین دکمه‌ها
                ListTile(
                  leading: Icon(Icons.info, color: Colors.white),
                  title: Text('About', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AboutScreen()));
                  },
                ),
                Divider(color: Colors.white), // خط جداکننده بین دکمه‌ها
                ListTile(
                  leading: Icon(Icons.settings, color: Colors.white),
                  title:
                      Text('Settings', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsScreen()));
                  },
                ),
                Divider(color: Colors.white), // خط جداکننده بین دکمه‌ها
                ListTile(
                  leading: Icon(Icons.share, color: Colors.white),
                  title: Text('Share', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ShareScreen()));
                  },
                ),
                Divider(color: Colors.white), // خط جداکننده بین دکمه‌ها
                ListTile(
                  leading: Icon(Icons.exit_to_app, color: Colors.white),
                  title: Text('Exit', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SplashScreen()));
                  },
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onChanged: (text) {
                  _searchWord(text); // جستجوی لغت هنگام تغییر متن
                },
                decoration: InputDecoration(
                  hintText: 'Search word...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: _searchResults.isNotEmpty
                  ? ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final result = _searchResults[index];
                        int wordId = result['id'];
                        String? persianWord = result['persion_word'];
                        String? englishWord = result['english_word'];

                        bool isFavorite = _favoriteIds.contains(wordId);

                        return Card(
                          color: Color.fromARGB(255, 222, 236, 21), // رنگ برای کارت‌ها
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double
                                    .infinity, // عرض کامل برای بخش سیاه‌رنگ
                                color:
                                    Colors.black, // قسمت سیاه‌رنگ در بالای کارت
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Word', // متن "Word" در بالای کارت
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                              SizedBox(
                                  height:
                                      10), // فاصله بین بخش "Word" و محتوای کارت
                              Text(persianWord ?? '',
                                  style:
                                      TextStyle(fontSize: 18.0)), // لغت فارسی
                              Divider(
                                  color: Colors
                                      .grey), // خط جداکننده بین لغت و معنا
                              Text(englishWord ?? '',
                                  style: TextStyle(
                                      fontSize: 16.0)), // ترجمه انگلیسی
                              Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                  icon: Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isFavorite ? Colors.red : null,
                                  ),
                                  onPressed: () {
                                    _toggleFavorite(
                                        wordId); // افزودن/حذف از علاقه‌مندی‌ها
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Center(child: Text('No results found')),
            ),
          ],
        ),
      ),
    );
  }
}
