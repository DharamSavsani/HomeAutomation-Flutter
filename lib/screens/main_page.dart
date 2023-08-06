import 'dart:io';

import 'package:flutter/material.dart';
import 'package:homeautomation_system/imports/import.dart';
import 'package:homeautomation_system/screens/component/add_popup.dart';
import 'package:homeautomation_system/screens/component/tab_view_component.dart';
import 'package:homeautomation_system/screens/mode_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

// This page contains all the code for App bar and Tab Bar.
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // this vatiable conatain all the data which will recive frome server.
  late Map<String, dynamic> data;
  // SharedPrefrece variable.
  var pref;
  // This variable extreact from data by some caluculation.
  late List<String> rooms;
  // This list will be the Tabs for our Tab bar.
  List<Tab> roomsTab = [];
  // This List contains Object of TabViewComponent().
  List<Widget> roomsTabBarView = [];
  // uses for lodaing purpose.
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // It contains all async processes.
    initOfAsyncData();
  }

  void initOfAsyncData() async {
    roomsTab = [];
    roomsTabBarView = [];

    try {
      pref = await SharedPreferences.getInstance();
      // Fatching data fome the sever.
      data = await CommonFunctions.getUserStatus(id: pref.getString('_id'));
      rooms = data.keys.toList();
      rooms.add("Modes");
      // This loop parform calculation for rooms and roomsTabBarViwe.
      rooms.forEach((e) {
        roomsTab.add(Tab(text: e.toString()));
        e.toString() == 'Modes'
            ? roomsTabBarView.add(ModePage(
                data: data,
                rooms: rooms,
                initOfAsyncData: initOfAsyncData,
              ))
            : roomsTabBarView.add(
                TabViewComponent(
                  data: data[e.toString()],
                  room: e.toString(),
                  initOfAsyncData: initOfAsyncData,
                ),
              );
      });
      isLoading = false;
      setState(() {
        debugPrint("Done");
      });
    } on Exception {
      // if any problem ocur then it will show a simple SnakBar with error and button.
      // Button click will stop App and exit app.
      final snackBar = SnackBar(
        content: const Text('Please check the Internet Or Restart App.'),
        action: SnackBarAction(
          label: 'Restart',
          onPressed: () {
            exit(0);
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  String greeting() {
    // It will greet user at paticular time.
    int now = DateTime.now().hour;
    if (now < 12) {
      return "Good Morning 🌅";
    } else if (now > 12 && 18 > now) {
      return "Good AfterNoon 🍜";
    } else {
      return "Good Evening ☀️🌃";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: isLoading ? 1 : rooms.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Smart Home'.toUpperCase()),
            automaticallyImplyLeading: false,
            actions: [
              ElevatedButton.icon(
                onPressed: () {
                  () async {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString('_id', "");
                  }();
                  Navigator.popAndPushNamed(context, 'loginPage');
                },
                icon: const Icon(Icons.logout_rounded),
                label: const Text(
                  "Logout",
                  style: TextStyle(fontFamily: CommonFonts.josefinBold),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 39, 39, 39),
                  ),
                ),
              )
            ],
            bottom: PreferredSize(
              preferredSize:
                  Size(double.infinity, CommonFunctions.getHeight(context, 12)),
              child: Column(
                children: [
                  Container(
                    padding:
                        EdgeInsets.all(CommonFunctions.getWidth(context, 3)),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    width: double.infinity,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        greeting(),
                        style: TextStyle(
                            fontFamily: CommonFonts.josefinBold,
                            fontSize: CommonFunctions.getHeight(context, 2.3)),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    child: isLoading
                        ? const TabBar(
                            tabs: [Tab(text: "Loding...")],
                          )
                        : TabBar(
                            tabs: roomsTab,
                          ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: ColorPalat.skyBlue,
            foregroundColor: Colors.black,
            shape: const CircleBorder(),
            splashColor: Colors.amber,
            onPressed: isLoading
                ? null
                : () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: ColorPalat.backgroundColor,
                            content: AddPopUpWidget(
                                rooms: rooms,
                                data: data,
                                initOfAsyncData: initOfAsyncData),
                          );
                        });
                  },
            child: Icon(Icons.add, size: CommonFunctions.getHeight(context, 4)),
          ),
          body: isLoading
              ? const TabBarView(
                  children: [
                    Center(
                      child: Text(
                        "Loding...",
                        style: TextStyle(fontFamily: CommonFonts.josefinLight),
                      ),
                    ),
                  ],
                )
              : TabBarView(children: roomsTabBarView),
        ),
      ),
    );
  }
}
