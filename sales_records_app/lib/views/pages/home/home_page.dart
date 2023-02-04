// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sales_records_app/views/pages/myproducts/myProducts_page.dart';
import 'package:sales_records_app/views/shared/shared.dart';
import 'package:calendar_appbar/calendar_appbar.dart';

import 'widget/main_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _children = [
    const MainScreen(),
    const MyProductsPage(),
  ];

  int currentIndex = 0;

  void onTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  final _formKey = GlobalKey<FormState>();
  final inputQuantity = TextEditingController();
  final inputDate = TextEditingController();

  @override
  void dispose() {
    inputQuantity.dispose();
    inputDate.dispose();

    super.dispose();
  }

  final List<String> productItems = [
    'Bayam',
    'Wortel',
    'Semangka',
    'Anggur',
  ];

  String? inputProduct;

  @override
  void initState() {
    inputDate.text = ""; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: (currentIndex == 0)
          ? CalendarAppBar(
              padding: 0.0,
              backButton: false,
              accent: primaryColor,
              onDateChanged: (value) => print(value),
              firstDate: DateTime.now().subtract(const Duration(days: 140)),
              lastDate: DateTime.now(),
            )
          : null,
      backgroundColor: primaryColor,
      floatingActionButton: Visibility(
        visible: (currentIndex == 0) ? true : false,
        child: FloatingActionButton(
          backgroundColor: secondaryColor,
          onPressed: (() {
            awesomeDialogWidget(context).show();
          }),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.pending_actions),
            label: 'Transaction',
            tooltip: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Products',
            tooltip: "",
          ),
        ],
        currentIndex: currentIndex,
        selectedItemColor: Colors.green,
        onTap: onTapped,
      ),
      body: _children[currentIndex],
    );
  }

  AwesomeDialog awesomeDialogWidget(BuildContext context) {
    return AwesomeDialog(
      context: context,
      showCloseIcon: true,
      headerAnimationLoop: false,
      dialogType: DialogType.noHeader,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Text(
                "Add Transaction",
                style: blackTextStyle.copyWith(
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              DropdownButtonFormField2(
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                isExpanded: true,
                hint: const Text(
                  'Select Your Product',
                ),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black45,
                ),
                iconSize: 30,
                buttonHeight: 60,
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                items: productItems
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  inputProduct = value.toString();
                },
              ),
              // TextButton(
              //   onPressed: () {
              //     if (_formKey.currentState!.validate()) {
              //       _formKey.currentState!.save();
              //     }
              //   },
              //   child: const Text('Submit Button'),
              // ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: inputQuantity,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Quantity cannot be empty";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  labelText: 'Quantity',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                readOnly: true,
                controller: inputDate,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Date cannot be empty";
                  }
                  return null;
                },
                // controller: inputEmail,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  labelText: 'Enter Time',
                ),
                onTap: (() async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    initialTime: TimeOfDay.now(),
                    context: context,
                  );

                  if (pickedTime != null) {
                    print(pickedTime.format(context));
                    //output 10:51 PM

                    DateTime parsedTime = DateFormat.jm()
                        .parse(pickedTime.format(context).toString());
                    //converting to DateTime so that we can further format on different pattern.

                    print(parsedTime); //output 1970-01-01 22:53:00.000

                    String formattedTime =
                        DateFormat('HH:mm').format(parsedTime);

                    print(formattedTime); //output 14:59

                    //DateFormat() is from intl package, you can format the time on any pattern you need.

                    setState(() {
                      inputDate.text =
                          formattedTime; //set the value of text field.
                    });
                  } else {
                    print("Time is not selected");
                  }
                }),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
      btnOk: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.green),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: const BorderSide(color: Colors.green),
            ),
          ),
        ),
        onPressed: () {
          setState(() {});
          // Add Transaction
        },
        child: const Text(
          "Add",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
