import 'package:flutter/material.dart';
import 'package:foo/src/models/comment.dart'; // <-- ИМПОРТИРУЕМ ГЛОБАЛЬНУЮ МОДЕЛЬ

// ! Локальная модель Comment удалена отсюда

/// Отдельная карточка одного комментария
class CommentTile extends StatelessWidget {
  final Comment comment;

  const CommentTile({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      color: const Color(0xFF1C1C1C),
      shape: LinearBorder.top(),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Отображаем ID пользователя вместо имени
            Text("Автор #${comment.userId}",
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 4),
            Text(comment.text, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 6),
            Text(
              "${comment.date.toLocal()}".split(' ')[0],
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

/// Основной раздел комментариев
class CommentsSection extends StatelessWidget {
  final List<Comment> comments;

  const CommentsSection({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовок
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            "Комментарии",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        Divider(),

        // Список комментариев
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: comments.length,
          itemBuilder: (context, index) {
            return CommentTile(comment: comments[index]);
          },
        ),

        const SizedBox(height: 12),

        // Поле для добавления нового комментария
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Напишите комментарий...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  // TODO: тут будет отправка на бэкенд
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}