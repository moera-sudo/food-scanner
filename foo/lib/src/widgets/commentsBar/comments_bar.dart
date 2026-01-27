import 'package:flutter/material.dart';
import 'package:foo/src/models/comment.dart';
import 'package:foo/src/services/product_service.dart';
import 'package:foo/src/services/auth_service.dart';

class CommentsSection extends StatefulWidget {
  final List<Comment> comments;
  final int productId;
  final VoidCallback onCommentPosted;

  const CommentsSection({
    super.key,
    required this.comments,
    required this.productId,
    required this.onCommentPosted,
  });

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  final TextEditingController _controller = TextEditingController();
  final ProductService _service = ProductService();
  bool _isSending = false;

  Future<void> _sendComment() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    
    // Проверка авторизации
    if (!await AuthService.isAuthenticated()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Войдите, чтобы комментировать")));
      return;
    }

    setState(() => _isSending = true);
    final success = await _service.sendComment(widget.productId, text);
    setState(() => _isSending = false);

    if (success) {
      _controller.clear();
      FocusScope.of(context).unfocus(); // Скрыть клавиатуру
      widget.onCommentPosted(); // Обновить список
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ошибка отправки")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Комментарии (${widget.comments.length})", style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.comments.length,
          itemBuilder: (ctx, i) {
            final c = widget.comments[i];
            return Card(
              color: Theme.of(context).cardColor,
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(child: Text(c.username[0].toUpperCase())),
                title: Text(c.username, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(c.text),
                trailing: Text("${c.date.day}.${c.date.month}", style: const TextStyle(color: Colors.grey)),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: "Написать комментарий...",
            suffixIcon: _isSending 
              ? const Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator(strokeWidth: 2))
              : IconButton(icon: const Icon(Icons.send, color: Color(0xFFEF8235)), onPressed: _sendComment),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: Theme.of(context).cardColor,
          ),
        ),
      ],
    );
  }
}