import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:time_table_maker_app/functions/functions.dart';
import 'package:time_table_maker_app/models/task.dart';
import 'package:time_table_maker_app/screens.dart/view.dart';
import 'package:time_table_maker_app/widgets/input_field_for_editscreen.dart';
import 'package:time_table_maker_app/widgets/button_for_editscreen.dart';

import '../controllers/task_controllers.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = '9:30 PM';
  int _selectedRemind = 5;
  List<int> remindList = [5, 10, 15, 20];
  String _selectedRepeat = 'None';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ADD TASK'),
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyInputField(
                  title: 'Subject',
                  hint: 'Enter Subject',
                  controller: _titleController,
                ),
                MyInputField(
                  title: 'Description',
                  hint: 'Enter Subject Description',
                  controller: _noteController,
                ),
                MyInputField(
                  title: 'Date',
                  hint: DateFormat.yMd().format(_selectedDate),
                  widget: IconButton(
                    onPressed: () {
                      _getDateFromUser(context);
                    },
                    icon: const Icon(
                      Icons.calendar_month,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: MyInputField(
                        title: 'Start Time',
                        hint: _startTime,
                        widget: IconButton(
                          onPressed: () {
                            _getTimeFromUser(isStartTime: true);
                          },
                          icon: const Icon(Icons.access_time),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: MyInputField(
                        title: 'End Time',
                        hint: _endTime,
                        widget: IconButton(
                          onPressed: () {
                            _getTimeFromUser(isStartTime: false);
                          },
                          icon: const Icon(Icons.access_time),
                        ),
                      ),
                    ),
                  ],
                ),
                MyInputField(
                  title: 'Remind',
                  hint: '$_selectedRemind minutes early',
                  widget: DropdownButton(
                    icon: const Icon(Icons.keyboard_arrow_down),
                    iconSize: 32,
                    elevation: 4,
                    style: subtitleStyle,
                    value: _selectedRemind,
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedRemind = newValue;
                        });
                      }
                    },
                    items: remindList.map<DropdownMenuItem<int>>(
                      (int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      },
                    ).toList(),
                  ),
                ),
                MyInputField(
                  title: 'Repeat',
                  hint: _selectedRepeat,
                  widget: DropdownButton(
                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                    iconSize: 32,
                    elevation: 4,
                    style: subtitleStyle,
                    value: _selectedRepeat,
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedRepeat = newValue;
                        });
                      }
                    },
                    items: repeatList.map<DropdownMenuItem<String>>(
                      (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        );
                      },
                    ).toList(),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Color',
                          style: titleStyle,
                        ),
                        const SizedBox(height: 8.0),
                        Wrap(
                          children: List<Widget>.generate(3, (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedColor = index;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: index == 0
                                      ? const Color.fromARGB(255, 11, 2, 136)
                                      : index == 1
                                          ? Colors.pink
                                          : Colors.yellow[300],
                                  child: _selectedColor == index
                                      ? const Icon(
                                          Icons.done,
                                          color: Colors.white,
                                        )
                                      : Container(),
                                ),
                              ),
                            );
                          }),
                        )
                      ],
                    ),
                    ButtonForEditScreen(
                      label: 'Create Task',
                      onTap: _validateData,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _validateData() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDb();
      Navigator.of(context).push(MaterialPageRoute(builder: (cxt){
        return ViewScreen();
       }
      )
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('All fields are required!'),
          backgroundColor: Colors.black,
          action: SnackBarAction(
            label: 'OK',
            onPressed: () {},
          ),
        ),
      );
    }
  }

  _addTaskToDb() async {
    int value = await _taskController.addTask(
      task: Task(
        note: _noteController.text,
        title: _titleController.text,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
        color: _selectedColor,
        isCompleted: 0,
      ),
    );
    print("My id is ""$value");
  }

  Future<void> _getDateFromUser(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2121),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
      print('Selected date: $_selectedDate');
    } else {
      print('No date selected');
    }
  }

  Future<void> _getTimeFromUser({required bool isStartTime}) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: TimeOfDay(
        hour: int.parse(_startTime.split(':')[0]),
        minute: int.parse(_startTime.split(':')[1].split(' ')[0]),
      ),
    );

    if (pickedTime != null) {
      final String formattedTime = pickedTime.format(context);
      if (isStartTime) {
        setState(() {
          _startTime = formattedTime;
        });
      } else {
        setState(() {
          _endTime = formattedTime;
        });
      }
    } else {
      print('Time Canceled');
    }
  }
}
