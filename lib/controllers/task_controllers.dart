import'package:get/get.dart';
import '../db/db_helper.dart';
import '../models/task.dart';

class TaskController extends GetxController{


  @override
  void onReady()
  {
    super.onReady();
  }

  Future<void> addTask({Task? task}){
    return null;
  }

  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async{
    return await DBhelper.insert(task);
  }

  void getTasks() async{
    List<Map<String,dynamic>> tasks = await DBhelper.query();
    taskList.assignAll(tasks.map((data)=> Task.fromJson(data)).toList());
  }
}