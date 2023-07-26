import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks/new_tasks_screen.dart';
import 'package:todo_app/shared/cubit/states.dart';


class AppCubit  extends Cubit<TodoAppStates>
{

  AppCubit():super(AppInitialState());

  int currentIndex = 0;
  bool  isBottomSheetShown  = false;
  IconData fabIcon = Icons.edit;
  List<Map> newTasks =[];
  List<Map> doneTasks =[];
  List<Map> archivedTasks =[];

  List<Widget>screens =
  [
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchivedTaskScreen(),
  ];
  List<String> title = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];



  static AppCubit get(context) => BlocProvider.of(context);


  void getIndex(index)
  {
    currentIndex= index ;
    emit(AppChangeBottomNavBarState());
  }

  Database ? database;


  void createDatabase()
  {
     openDatabase(
        'todo.db',
        version: 1,
        onCreate: (database , version)
        {
          print('database created ');
          database.execute('CREATE TABLE task (id INTEGER PRIMARY KEY ,title TEXT  ,date TEXT , time TEXT,status TEXT)'
          ).then((value)
          {
            print('table created');
          }).catchError((error)
          {
            print('error when creating database ${error.toString()}');
          });
        },
        onOpen: (database)
        {
          getDataFromDatabase(database);
          print('database opened ');
        }
    ).then((value)
     {
       database = value ;
       emit(AppCreateDatabaseState());
     });
  }

   insertDatabase(
      {
        required String title,
        required String date,
        required String time,
      })async
  {
     await database?.transaction((txn) async
    {
      txn.rawInsert(
          'INSERT INTO task (title,date,time,status )VALUES("$title","$date","$time","new")'
      ).then((value)
      {
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());

        getDataFromDatabase(database);
      }).catchError((error)
      {
        print('error when inserting a new record ${error.toString()}');
      });
    });
  }


  void getDataFromDatabase(database)
  {
    newTasks =[];
    doneTasks =[];
    archivedTasks =[];
    emit(AppGetDatabaseLoadingState());
      database!.rawQuery('SELECT * FROM task').then((value)
      {
        emit(AppGetDatabaseState());
        value.forEach((element)
        {
          if(element['status']=='new')
            newTasks.add(element);
          else if(element['status']=='done')
            doneTasks.add(element);
          else
            archivedTasks.add(element);

          print(element['status']);
        });
      });
  }


  void updateDatabase({
  required String status,
  required int id,
})
  {
     database?.rawUpdate(
        'UPDATE task SET status = ? WHERE id = ?', [status,id ]).then((value)
     {
       emit(AppUpdateDatabaseState());
       getDataFromDatabase(database);

     });
  }


  void deleteDatabase({
    required int id,
  })
  {
    database?.rawDelete('DELETE FROM task WHERE id = ?', [id]).then((value)
    {
      emit(AppDeleteDatabaseState());
      getDataFromDatabase(database);

    });
  }


  void changeBottomSheetIcon({
  required bool isBottomShown,
  required IconData icon,
})
  {
    isBottomSheetShown = isBottomShown ;
    fabIcon = icon;

    emit(AppChangeBottomSheetIconState());
  }


}