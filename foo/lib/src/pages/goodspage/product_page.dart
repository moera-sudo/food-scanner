import 'package:flutter/material.dart';
import 'package:foo/src/widgets/RatingCards/nutri_score_card.dart';
import 'package:foo/src/widgets/RatingCards/rating_card.dart';
import 'package:foo/src/widgets/commentsBar/comments_bar.dart';

class ProductPage extends StatelessWidget{
  ProductPage({super.key});
  
  final product_info = [
    {"id": 1, "title": "Кофеварка", "desc":"Эта кофеварка позволяет готовить до 5 чашек кофе. Мощность 800 Вт, съёмный резервуар для воды, компактный дизайн.", "image": "https://www.timberk.ru/upload/resize_cache/webp/iblock/f58/e3rbcxpgxhxg9m0dklg8h1cu90qfia4b.webp"},
  ];
  final productComments = [
    Comment(
      author: "Иван",
      text: "Очень понравилась кофеварка!",
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Comment(
      author: "Мария",
      text: "Шумная, но кофе вкусный ☕",
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  // ! I will make here a response to backend
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              product_info[0]["image"] as String,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product_info[0]["title"] as String,
                    style: Theme.of(context).textTheme.headlineLarge),
                  SizedBox(height: 8,),
                  Text(
                    product_info[0]["desc"] as String,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),                  
                ],
              ),
              ),
              SizedBox(height: 15,),
              Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                // Выравниваем все дочерние элементы по левому краю
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ЗАГОЛОВОК
                  const Text(
                    "Nutrition Facts",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // РАЗДЕЛИТЕЛЬ
                  const Divider(color: Color(0xFF2E2E2E), thickness: 1),
                  const SizedBox(height: 8),

                  // ПЕРВЫЙ РЯД: Calories / Fat
                  Row(
                    children: [
                      // Expanded заставляет дочерний виджет занять всё доступное пространство
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Calories", style: TextStyle(color: Colors.grey)),
                            SizedBox(height: 4),
                            Text("52", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Fat", style: TextStyle(color: Colors.grey)),
                            SizedBox(height: 4),
                            Text("0.2g", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // РАЗДЕЛИТЕЛЬ
                  const Divider(color: Color(0xFF2E2E2E), thickness: 1),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Protein", style: TextStyle(color: Colors.grey)),
                            SizedBox(height: 4),
                            Text("0.3g", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Carbs", style: TextStyle(color: Colors.grey)),
                            SizedBox(height: 4),
                            Text("14g", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // РАЗДЕЛИТЕЛЬ
                  const Divider(color: Color(0xFF2E2E2E), thickness: 1),
                  const SizedBox(height: 8),

                  // ТРЕТИЙ РЯД: Sugar / Fiber
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Sugar", style: TextStyle(color: Colors.grey)),
                            SizedBox(height: 4),
                            Text("10g", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("Fiber", style: TextStyle(color: Colors.grey)),
                            SizedBox(height: 4),
                            Text("2.4g", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text("Рейтинг"),
                      SizedBox(height: 10,),
                      RatingCard(value: 7.5),
                      ]),
                  SizedBox(width: 60),
                  Column(
                    children: [
                      Text("Nutri-Score"),
                      SizedBox(height: 10,),
                      NutriScoreCard(grade: "A"),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            CommentsSection(comments: productComments),
            SizedBox(height: 10)
          ],
        ),
      )        
      


    );
  }
}