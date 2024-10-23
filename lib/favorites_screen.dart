import 'package:flutter/material.dart';
import 'database_helper.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  _loadFavorites() async {
    var favs = await _dbHelper.getFavorites();
    setState(() {
      _favorites = favs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreenAccent,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Favorites'),
      ),
      body: _favorites.isNotEmpty
          ? ListView.builder(
        itemCount: _favorites.length,
        itemBuilder: (context, index) {
          final favorite = _favorites[index];
          String persianWord = favorite['persion_word'];
          String englishWord = favorite['english_word'];

          return Card(
            color: Colors.blue[100], // رنگ آبی برای کارت‌ها
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity, // عرض کامل برای بخش سیاه‌رنگ
                  color: Colors.black, // قسمت سیاه‌رنگ در بالای کارت
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Word', // متن "Word" در بالای کارت
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                SizedBox(height: 10), // فاصله بین بخش "Word" و محتوای کارت
                Text(persianWord, style: TextStyle(fontSize: 18.0)), // لغت فارسی
                Divider(color: Colors.grey), // خط جداکننده بین لغت و معنا
                Text(englishWord, style: TextStyle(fontSize: 16.0)), // ترجمه انگلیسی
                Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.favorite, // نمایش قلب قرمز برای علاقه‌مندی‌ها
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          );
        },
      )
          : Center(child: Text('No favorites added')),
    );
  }
}
