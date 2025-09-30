import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget{
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Внешний вид", 
              style: Theme.of(context).textTheme.headlineLarge),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.lightbulb_outline_sharp),
              title: Text("Тема"),
              subtitle: Text("Dark"),
              trailing: IconButton(
                  icon: Icon(Icons.arrow_forward_rounded),
                  onPressed: () {
                    Navigator.pushNamed(context, "");
                  })
            ),
            SizedBox(height: 10),
            Divider(),
            SizedBox(height: 10),
            Text(
              "Аккаунт",
              style: Theme.of(context).textTheme.headlineLarge),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.password),
              title: Text("Сменить пароль"),
              trailing: IconButton(
                  icon: Icon(Icons.arrow_forward_rounded),
                  onPressed: () {
                    Navigator.pushNamed(context, "");
                  })
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Выйти"),
              trailing: IconButton(
                  icon: Icon(Icons.arrow_forward_rounded),
                  onPressed: () {
                    Navigator.pushNamed(context, "");
                  })
            ),
          ],
        ),
      ),

    );
  }
}