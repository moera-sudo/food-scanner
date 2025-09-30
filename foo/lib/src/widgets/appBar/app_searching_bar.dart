import 'package:flutter/material.dart';
import 'package:foo/src/routes/app_routes.dart';

class AppSearchingBar extends StatelessWidget implements PreferredSizeWidget{
  final TextEditingController controller;
  final ValueChanged<String>? onSubmitted;

  const AppSearchingBar({
    super.key,
    required this.controller,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextField(
                onSubmitted: onSubmitted,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Поиск..',
                  prefixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  filled: true,
                  fillColor: Colors.grey.withValues(alpha: 0.15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none
                ),
              ),
            ),
          ),
          ),
          SizedBox(width: 8),

          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.profile);
            },
            icon: Icon(Icons.account_circle_outlined))
        ],
      ),
    centerTitle: true,
  );
    
  }
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);  
}
