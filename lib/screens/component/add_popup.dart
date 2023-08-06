import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../imports/import.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddPopUpWidget extends StatefulWidget {
  final List? rooms;
  final Function() initOfAsyncData;
  final Map? data;
  const AddPopUpWidget(
      {super.key, this.rooms, required this.initOfAsyncData, this.data});

  @override
  State<AddPopUpWidget> createState() => _AddPopUpWidgetState();
}

class _AddPopUpWidgetState extends State<AddPopUpWidget> {
  //To check current mode for room editing.
  String editingMode = "Add";
  //This function will come frome the main_page to fetch all the data frome server again.
  Function()? initOfAsyncData;
  //Controllers for the device name and room name.
  TextEditingController deviceNameController = TextEditingController();
  TextEditingController roomNameController = TextEditingController();
  // List of the rooms which will come from main_page. DropDown button uses this List.
  List? rooms;
  //Slected value of DropDown button will store in roomValue variable.
  late String? roomValue = rooms?[0];
  // These variables use to show error text to user.
  bool deviceNameCheck = false;
  bool roomNameCheck = false;
  // SharedPrefrences variable.
  var prefs;
  // This data Stores devices info.
  Map? data;

  @override
  void initState() {
    super.initState();
    () async {
      prefs = await SharedPreferences.getInstance();
    }();
  }

  Widget addDevicesFunction(List? rooms) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: CommonFunctions.getHeight(context, 5),
        ),
        const Text("Device's Name",
            style: TextStyle(fontFamily: CommonFonts.josefinBold)),
        SizedBox(
          height: CommonFunctions.getHeight(context, 1.5),
        ),
        TextFormField(
          controller: deviceNameController,
          onChanged: (val) {
            deviceNameCheck = false;
            setState(() {});
          },
          decoration: InputDecoration(
            errorText: deviceNameCheck ? "Please Enter the Device Name" : null,
            prefixIcon: const Icon(Icons.devices_other_outlined),
            hintText: "EX : Light",
            hintStyle: TextStyle(
              fontSize: CommonFunctions.getHeight(context, 1.5),
            ),
          ),
          style: TextStyle(
            fontFamily: CommonFonts.josefinLight,
            fontSize: CommonFunctions.getHeight(context, 2),
          ),
        ),
        SizedBox(
          height: CommonFunctions.getHeight(context, 3.5),
        ),
        const Text("Select Rooms For Device",
            style: TextStyle(fontFamily: CommonFonts.josefinBold)),
        SizedBox(
          height: CommonFunctions.getHeight(context, 1.5),
        ),
        SizedBox(
          width: double.infinity,
          child: DropdownButtonFormField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.meeting_room),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(50),
                ),
                borderSide: BorderSide(
                  color: Colors.black,
                ),
              ),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            isExpanded: true,
            icon: const Icon(
              Icons.arrow_drop_down_circle_sharp,
              color: Colors.black,
            ),
            style: const TextStyle(
              fontFamily: CommonFonts.josefinLight,
              color: Colors.black,
            ),
            value: roomValue,
            items: rooms?.map((dynamic items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items),
              );
            }).toList(),
            onChanged: (val) {
              //If user select any other option it will change the value of roomValue variable.
              setState(() {
                roomValue = val.toString();
              });
            },
          ),
        ),
        SizedBox(
          height: CommonFunctions.getHeight(context, 20),
          child: Container(
            margin: EdgeInsets.only(
              top: CommonFunctions.getHeight(context, 3),
            ),
            child: const Text(
              "Note : Do not Enter the name of devices same as already exist.",
              style: TextStyle(fontFamily: CommonFonts.josefinBold),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: TextButton(
            style: ButtonStyle(
              backgroundColor: const MaterialStatePropertyAll(Colors.black),
              minimumSize: MaterialStatePropertyAll(
                  Size(double.infinity, CommonFunctions.getHeight(context, 7))),
            ),
            onPressed: () {
              () async {
                //First check the value of device name id empty or not.
                String deviceName = deviceNameController.text;
                //If value is empty then show error text to user else move to next stape.
                if (deviceName.isEmpty) {
                  deviceNameCheck = true;
                  setState(() {});
                } else {
                  // First take every value of current devices and store into another variable.
                  Map val = data?[roomValue];
                  //Then add new device name as Key and value which will be false.
                  val[deviceName] = false;
                  setState(() {});
                  try {
                    //Then store it into server.
                    await CommonFunctions.addDevice(
                      id: await prefs.getString("_id"),
                      room: roomValue,
                      val: val,
                    );
                    //If nothing goes wrong then show Toast.
                    Fluttertoast.showToast(
                      msg:
                          "Device Added to $roomValue,This process may take some time.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  } on Exception {
                    //If Exception ocure then show error Toast.
                    Fluttertoast.showToast(
                      msg: "Error",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.TOP,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.redAccent,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                }
              }();
              Navigator.of(context).pop();
            },
            child: Text(
              "Add",
              style: TextStyle(fontSize: CommonFunctions.getHeight(context, 2)),
            ),
          ),
        ),
      ],
    );
  }

  Widget addRoomsFunction(List? rooms) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: CommonFunctions.getHeight(context, 2.5),
        ),
        ListTile(
          title: const Text(
            "Add Room",
            style: TextStyle(fontFamily: CommonFonts.josefinBold),
          ),
          contentPadding: EdgeInsets.symmetric(
              horizontal: CommonFunctions.getWidth(context, -5)),
          leading: Radio(
            activeColor: Colors.black,
            value: "Add",
            groupValue: editingMode.toString(),
            onChanged: (val) {
              setState(() {
                editingMode = val.toString();
              });
            },
          ),
        ),
        const Text("Room's Name",
            style: TextStyle(fontFamily: CommonFonts.josefinBold)),
        SizedBox(
          height: CommonFunctions.getHeight(context, 1.5),
        ),
        TextFormField(
          controller: roomNameController,
          onChanged: (val) {
            roomNameCheck = false;
            setState(() {});
          },
          decoration: InputDecoration(
            errorText: roomNameCheck ? "Entert the value" : null,
            prefixIcon: const Icon(Icons.meeting_room),
            enabled: editingMode == "Add" ? true : false,
            hintText: "EX : Kitchen",
            hintStyle: TextStyle(
              fontSize: CommonFunctions.getHeight(context, 1.5),
            ),
          ),
          style: TextStyle(
            fontFamily: CommonFonts.josefinLight,
            fontSize: CommonFunctions.getHeight(context, 2),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(
            vertical: CommonFunctions.getHeight(context, 2),
          ),
          child: const Text(
            "Note : Do not Enter the name of room same as already exist.",
            style: TextStyle(fontFamily: CommonFonts.josefinBold),
          ),
        ),
        ListTile(
          title: const Text(
            "Delete Rooms",
            style: TextStyle(fontFamily: CommonFonts.josefinBold),
          ),
          contentPadding: EdgeInsets.symmetric(
              horizontal: CommonFunctions.getWidth(context, -5)),
          leading: Radio(
            activeColor: Colors.black,
            value: "Delete",
            groupValue: editingMode.toString(),
            onChanged: (val) {
              setState(() {
                editingMode = val.toString();
              });
            },
          ),
        ),
        const Text(
          "Select Rooms For Delete",
          style: TextStyle(fontFamily: CommonFonts.josefinBold),
        ),
        SizedBox(
          height: CommonFunctions.getHeight(context, 1.5),
        ),
        SizedBox(
          width: double.infinity,
          child: DropdownButtonFormField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.meeting_room),
              focusedBorder: editingMode == 'Add'
                  ? const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    )
                  : const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
              enabledBorder: editingMode == 'Add'
                  ? const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    )
                  : const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            isExpanded: true,
            icon: const Icon(
              Icons.arrow_drop_down_circle_sharp,
              color: Colors.black,
            ),
            style: const TextStyle(
              fontFamily: CommonFonts.josefinLight,
              color: Colors.black,
            ),
            value: roomValue,
            items: rooms?.map((dynamic items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items),
              );
            }).toList(),
            onChanged: editingMode == 'Add'
                ? null
                : (val) {
                    roomValue = val.toString();
                    setState(() {});
                  },
          ),
        ),
        SizedBox(
          height: CommonFunctions.getHeight(context, 10),
        ),
        Align(
          alignment: Alignment.center,
          child: TextButton(
            style: ButtonStyle(
              backgroundColor: editingMode == "Add"
                  ? const MaterialStatePropertyAll(Colors.black)
                  : const MaterialStatePropertyAll(Colors.redAccent),
              foregroundColor: editingMode == "Add"
                  ? null
                  : const MaterialStatePropertyAll(Colors.black),
              minimumSize: MaterialStatePropertyAll(
                  Size(double.infinity, CommonFunctions.getHeight(context, 7))),
            ),
            //First Check the mode for editing.
            onPressed: editingMode == 'Add'
                ? () {
                    () async {
                      //First check the room Name is empty or not.
                      String roomName = roomNameController.text;
                      //If roomName is empty then show error text to user else go to next step.
                      if (roomName.isEmpty) {
                        roomNameCheck = true;
                        setState(() {});
                      } else {
                        try {
                          //This prosses is quite leangthy so First notifiying the user to wait.
                          Fluttertoast.showToast(
                            msg: "It will take Some time to add room.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          //this code will run after 2 seconds so data can be reupdate.
                          Future.delayed(const Duration(seconds: 2), () {
                            initOfAsyncData!();
                          });
                          //This code will add room.
                          await CommonFunctions.addRoom(
                            id: await prefs.getString('_id'),
                            room: roomName,
                            val: {},
                          );
                        } catch (e) {
                          //If any exception will occur then it will show an error toast.
                          Fluttertoast.showToast(
                            msg: "Error",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      }
                    }();
                    Navigator.of(context).pop();
                  }
                : () {
                    () async {
                      try {
                        //This prosses is quite leangthy so First notifiying the user to wait.
                        Fluttertoast.showToast(
                          msg: "It will take some time to delete whole Room",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        //this code will run after 2 seconds so data can be reupdate.
                        Future.delayed(const Duration(seconds: 2), () {
                          initOfAsyncData!();
                        });
                        //This code will delete room.
                        await CommonFunctions.deleteRoom(
                          id: await prefs.getString('_id'),
                          room: roomValue,
                        );
                      } catch (e) {
                        //If any exception will occur then it will show an error toast.
                        Fluttertoast.showToast(
                          msg: "Error",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    }();
                    Navigator.of(context).pop();
                  },
            child: Text(editingMode == 'Add' ? "Add" : "Delete"),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    initOfAsyncData = widget.initOfAsyncData;
    rooms = widget.rooms;
    rooms?.remove('Modes');
    data = widget.data;
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: SizedBox(
        height: CommonFunctions.getHeight(context, 70),
        width: CommonFunctions.getWidth(context, 100),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const TabBar(
                indicator: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                tabs: [
                  Tab(
                    text: "Add Devices",
                  ),
                  Tab(
                    text: "Add Rooms",
                  ),
                ],
              ),
              SizedBox(
                height: CommonFunctions.getHeight(context, 60),
                child: TabBarView(
                  children: [
                    Container(
                      child: addDevicesFunction(rooms),
                    ),
                    Container(
                      child: addRoomsFunction(rooms),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
