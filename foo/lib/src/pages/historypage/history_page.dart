import 'package:flutter/material.dart';
import 'package:foo/src/routes/app_routes.dart';



class HistoryPage extends StatefulWidget{
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();

}

class _HistoryPageState extends State<HistoryPage>{

  //! There will be a response to backend here 
  final items = [
    {"id": 1, "title": "Кофеварка", "image": "https://www.timberk.ru/upload/resize_cache/webp/iblock/f58/e3rbcxpgxhxg9m0dklg8h1cu90qfia4b.webp"},
    {"id": 2, "title": "Кофеварка", "image": "https://www.timberk.ru/upload/resize_cache/webp/iblock/f58/e3rbcxpgxhxg9m0dklg8h1cu90qfia4b.webp"},
    {"id": 3, "title": "Кофеварка", "image": "https://www.timberk.ru/upload/resize_cache/webp/iblock/f58/e3rbcxpgxhxg9m0dklg8h1cu90qfia4b.webp"},
    {"id": 4, "title": "Кофеварка", "image": "https://www.timberk.ru/upload/resize_cache/webp/iblock/f58/e3rbcxpgxhxg9m0dklg8h1cu90qfia4b.webp"},
    {"id": 5, "title": "Кофеварка", "image": "https://www.timberk.ru/upload/resize_cache/webp/iblock/f58/e3rbcxpgxhxg9m0dklg8h1cu90qfia4b.webp"},

  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index){
          final item = items[index];

          return Card(
            margin: EdgeInsets.all(0),
            color: Color(0xFF1C1C1C),
            shape: Border(
              bottom: BorderSide(color: Color(0xFF2E2E2E), width: 0.7)
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(10),
              leading: Image.network(item["image"] as String), //TODO ОБЯЗАТЕЛЬНО ВСТАВИТЬ СЮДА БУДУЩУЮ МОДЕЛЬ PRODUCT 
              title: Text(item['title'] as String), //TODO <- и сюда
              trailing: IconButton(
                  icon: Icon(Icons.arrow_forward_rounded),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.product, arguments: item['id']);
                  })
            ),
          );
        },
      ),
    );
  } 
}

