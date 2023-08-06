import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homeautomation_system/imports/import.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModePage extends StatefulWidget {
  final Map<String, dynamic> data;
  final List rooms;
  final Function() initOfAsyncData;
  const ModePage(
      {super.key,
      required this.data,
      required this.rooms,
      required this.initOfAsyncData});

  @override
  State<ModePage> createState() => _ModePageState();
}

class _ModePageState extends State<ModePage> {
  Map<String, dynamic>? data;
  List? rooms;
  Function()? initOfAsyncData;
  @override
  Widget build(BuildContext context) {
    data = widget.data;
    rooms = widget.rooms;
    initOfAsyncData = widget.initOfAsyncData;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: CommonFunctions.getHeight(context, 5),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: CommonFunctions.getWidth(context, 5),
            ),
            child: Container(
              height: CommonFunctions.getHeight(context, 25),
              // width: CommonFunctions.getWidth(context, 90),
              decoration: BoxDecoration(
                color: ColorPalat.skyBlue,
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    CommonFunctions.getWidth(context, 5),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: CommonFunctions.getHeight(context, 2),
                      ),
                      Text(
                        "Exit Mode",
                        style: TextStyle(
                          fontFamily: CommonFonts.josefinBold,
                          fontSize: CommonFunctions.getHeight(context, 2.5),
                        ),
                      ),
                      Lottie.asset(
                        AssetsConst.exitMode,
                        width: CommonFunctions.getWidth(context, 40),
                        height: CommonFunctions.getHeight(context, 20),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(
                            CommonFunctions.getWidth(context, 2),
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              rooms!.remove("Modes");
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              rooms!.forEach((e) async {
                                data![e.toString()]
                                    .updateAll((key, value) => value = false);
                                await CommonFunctions.setDeviceState(
                                  id: await prefs.getString('_id'),
                                  room: e.toString(),
                                  val: data![e.toString()],
                                );
                              });
                              Fluttertoast.showToast(
                                msg: "Exit mode is on!!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.TOP,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            },
                            style: ButtonStyle(
                              padding: MaterialStatePropertyAll(
                                EdgeInsets.all(
                                  CommonFunctions.getHeight(context, 2),
                                ),
                              ),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.black),
                              shape: const MaterialStatePropertyAll(
                                CircleBorder(),
                              ),
                            ),
                            child: const Icon(Icons.power_off_rounded),
                          ),
                        ),
                        SizedBox(
                          height: CommonFunctions.getHeight(context, 4),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            "This mode will shut down all the appliances or devices of the Home.",
                            softWrap: true,
                            style: TextStyle(
                              fontFamily: CommonFonts.josefinLight,
                              fontSize: CommonFunctions.getHeight(context, 2),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
