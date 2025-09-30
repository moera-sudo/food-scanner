import 'package:flutter/material.dart';
import 'package:foo/src/widgets/photoSearchBtn/glass_button.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(child: GlassButton(
        onPressed: () => print("Соси"),
        icon: Icons.image_search_rounded)
      ),
    );
  }
}