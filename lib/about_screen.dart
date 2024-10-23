import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[800],
      appBar: AppBar(
        backgroundColor: Colors.yellowAccent,
        title: Text('About the Dictionary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About This Dictionary App',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                '''This dictionary app allows you to search for words in Persian and find their English translations. You can add your favorite words to the favorites list and easily access them later. The app is designed for simplicity and quick access to translations, making it easy for users to find and store words they use frequently.''',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'درباره این برنامه دیکشنری',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                '''این برنامه دیکشنری به شما امکان می‌دهد کلمات فارسی را جستجو کنید و ترجمه انگلیسی آن‌ها را پیدا کنید. شما می‌توانید کلمات مورد علاقه خود را به لیست علاقه‌مندی‌ها اضافه کنید و بعداً به راحتی به آن‌ها دسترسی داشته باشید. این برنامه به گونه‌ای طراحی شده است که استفاده آسان و سریع برای دسترسی به ترجمه‌ها باشد و کاربران بتوانند به سرعت کلماتی که بیشتر استفاده می‌کنند را پیدا کرده و ذخیره کنند.''',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'About This Dictionary App',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                '''This dictionary app allows you to search for words in Persian and find their English translations. You can add your favorite words to the favorites list and easily access them later. The app is designed for simplicity and quick access to translations, making it easy for users to find and store words they use frequently.''',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'درباره این برنامه دیکشنری',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                '''این برنامه دیکشنری به شما امکان می‌دهد کلمات فارسی را جستجو کنید و ترجمه انگلیسی آن‌ها را پیدا کنید. شما می‌توانید کلمات مورد علاقه خود را به لیست علاقه‌مندی‌ها اضافه کنید و بعداً به راحتی به آن‌ها دسترسی داشته باشید. این برنامه به گونه‌ای طراحی شده است که استفاده آسان و سریع برای دسترسی به ترجمه‌ها باشد و کاربران بتوانند به سرعت کلماتی که بیشتر استفاده می‌کنند را پیدا کرده و ذخیره کنند.''',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
