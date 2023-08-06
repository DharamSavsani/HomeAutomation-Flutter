import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homeautomation_system/common/commons.dart';
import 'package:homeautomation_system/imports/const/assets_const.dart';
import 'package:homeautomation_system/imports/const/colors.dart';
import 'package:homeautomation_system/imports/const/fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// This whole page contain code about the component of the devices.
// The component contain three things.
// First thing is Image for devices which is just a static image.
// Second is simple text for device identitiy.
// Third is Switch for devices.

class TabViewComponent extends StatefulWidget {
  final Map? data;
  final String? room;
  final Function()? initOfAsyncData;
  const TabViewComponent(
      {super.key, this.data, this.room, this.initOfAsyncData});

  @override
  State<TabViewComponent> createState() => _TabViewComponentState();
}

class _TabViewComponentState extends State<TabViewComponent> {
  bool val = true;
  Map? data;
  List<Widget> devicesList = [];
  Map? newData;
  String? room;
  var pref;
  Function()? initOfAsyncData;

  @override
  void initState() {
    super.initState();
    () async {
      pref = await SharedPreferences.getInstance();
    }();
  }

  /// This function will return a Widget for Devices.
  /// It will take three thing as perameter.
  /// First is deviceName which will be String.
  /// Second is deviceState which will be Boolen.
  Widget getDeviceComponent(
      {required String deviceName, required bool deviceState}) {
    return Padding(
      padding: EdgeInsets.all(CommonFunctions.getWidth(context, 4)),
      child: Container(
        padding: EdgeInsets.all(CommonFunctions.getWidth(context, 4)),
        decoration: BoxDecoration(
          color: ColorPalat.skyBlue,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(
              Radius.circular(CommonFunctions.getWidth(context, 8))),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  deviceState ? AssetsConst.lightOn : AssetsConst.light,
                  height: CommonFunctions.getHeight(context, 5),
                ),
                GestureDetector(
                  //This code use to delete partcular device.
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Delete📛",
                                style: TextStyle(
                                    fontFamily: CommonFonts.josefinBold)),
                            content: const Text(
                                "Do you want to delete this device!!",
                                style: TextStyle(
                                    fontFamily: CommonFonts.josefinLight)),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cancle")),
                              ElevatedButton(
                                onPressed: () {
                                  newData = data;
                                  newData?.remove(deviceName);
                                  Navigator.of(context).pop();
                                  setState(() {});
                                  () async {
                                    await CommonFunctions.setDeviceState(
                                        id: pref.getString('_id'),
                                        room: room,
                                        val: newData);
                                    // After the all the update it will also update all the data for whole application.
                                    initOfAsyncData!();
                                  }();
                                  Fluttertoast.showToast(
                                      msg: "Device Deleted",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.TOP,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.redAccent,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                },
                                child: const Text(
                                  "Delete",
                                  style: TextStyle(
                                    fontFamily: CommonFonts.josefinBold,
                                  ),
                                ),
                              )
                            ],
                          );
                        });
                  },
                  child: const Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: CommonFunctions.getHeight(context, 1.5)),
            Text(
              deviceName,
              style: const TextStyle(
                  color: Colors.black, fontFamily: CommonFonts.josefinLight),
            ),
            SizedBox(height: CommonFunctions.getHeight(context, 1.5)),
            Switch(
                inactiveThumbColor: Colors.red,
                value: deviceState,
                onChanged: (val) {
                  setState(() {
                    // this will set deviceState to opposit of previous state.
                    data?[deviceName] = !deviceState;
                    // newData is use to update Data with new data.
                    newData = data;
                  });
                  try {
                    // This will invok after data update it will take some time.
                    () async {
                      await CommonFunctions.setDeviceState(
                          id: pref.getString('_id'), room: room, val: newData);
                    }();
                  } on Exception {
                    // if any problem ocur then it will show a simple SnakBar with error and button.
                    // Button click will stop App and exit app.
                    final snackBar = SnackBar(
                      content: const Text(
                          'Please check the Internet Or Restart App.'),
                      action: SnackBarAction(
                        label: 'Restart',
                        onPressed: () {
                          exit(0);
                        },
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    data == null ? data = widget.data : data = newData;
    room = widget.room;
    initOfAsyncData = widget.initOfAsyncData;
    //This code will cuas Problem in Devlopment not in real life impliment. To solw it we need to call API btu it will make it litel bit lengthy procees so I will go with this. It will repeat same component at each refresh.
    devicesList = [];
    setState(() {});
    data?.forEach((key, value) {
      devicesList.add(getDeviceComponent(deviceName: key, deviceState: value));
    });
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          var res;
          res = await CommonFunctions.getUserStatus(id: pref.getString('_id'));
          if (res.isNotEmpty) {
            data = res[room];
            newData = res[room];
            setState(() {});
          }
        },
        child: GridView.count(
          crossAxisCount: 2,
          children: devicesList,
        ),
      ),
    );
  }
}
