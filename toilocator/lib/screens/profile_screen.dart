import 'package:flutter/material.dart';
import '../palette.dart';
import '../widgets/side_drawer_button.dart';
import './home_map_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Container(width: 100, child: HomeMapScreen.buildDrawer(context)),
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Builder(builder: (context) {
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Palette.beige[500],
                  // image: DecorationImage(
                  //     image: NetworkImage(
                  //         "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.theguardian.com%2Flifeandstyle%2F2019%2Fnov%2F08%2Fexperience-hide-the-pain-harold-face-became-meme-turned-it-into-career&psig=AOvVaw3xRZQ75mtTZuFLknTsTZCQ&ust=1648968747866000&source=images&cd=vfe&ved=0CAsQjRxqFwoTCNiZ47Xl9PYCFQAAAAAdAAAAABAD"),
                  //     fit: BoxFit.cover),
                ),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  child: Stack(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                              icon: Icon(Icons.menu_rounded)),
                          Text('Profile',
                              style: Theme.of(context).textTheme.headline2),
                          SizedBox(width: 40),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment(0.0, 2.5),
                      child: CircleAvatar(
                        radius: 65,
                        backgroundColor: Colors.black,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://i.pinimg.com/originals/c0/c2/16/c0c216b3743c6cb9fd67ab7df6b2c330.jpg'),
                          radius: 60,
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Text(
                "Abdul Bari",
                style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 15,
              ),
              Text('Age', style: Theme.of(context).textTheme.headline2),
              SizedBox(height: 10),
              Text('69',
                  style: Theme.of(context).textTheme.subtitle1?.merge(
                      TextStyle(color: Color.fromARGB(255, 95, 95, 95)))),
              SizedBox(height: 30),
              Text('Gender', style: Theme.of(context).textTheme.headline2),
              SizedBox(height: 10),
              Text('Female',
                  style: Theme.of(context).textTheme.subtitle1?.merge(
                      TextStyle(color: Color.fromARGB(255, 95, 95, 95)))),
              SizedBox(height: 30),
              Text('Email', style: Theme.of(context).textTheme.headline2),
              SizedBox(height: 10),
              Text('ilovedick42069@scatmail.com',
                  style: Theme.of(context).textTheme.subtitle1?.merge(
                      TextStyle(color: Color.fromARGB(255, 95, 95, 95))),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ],
          );
        }),
      ),
    );
  }
}
