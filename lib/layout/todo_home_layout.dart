import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_app/modules/new_tasks/new_tasks_screen.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/components/constant.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget
{

  var scaffoldKey= GlobalKey<ScaffoldState>();
  var formKey= GlobalKey<FormState>();
  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,TodoAppStates>(
        listener: (context, state)
        {
          if(state is AppInsertDatabaseState){
            Navigator.pop(context);
          }

        },
        builder: ( context, state)
        {
          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.blue[900],
              title: Text(cubit.title[cubit.currentIndex]),
            ),
            body:ConditionalBuilder(
              condition:state is! AppGetDatabaseLoadingState ,
              builder: (context)
              {
                return cubit.screens[cubit.currentIndex];
              },
              fallback: (context)
              {
                return Center(child: CircularProgressIndicator());
              },
            ),
            floatingActionButton: FloatingActionButton(
              elevation: 25.0,
              backgroundColor: Colors.blue[900],
              onPressed: ()
              {
                if(cubit.isBottomSheetShown )
                {
                  if(formKey.currentState!.validate())
                  {
                    cubit.insertDatabase(
                        title: titleController.text,
                        date: dateController.text,
                        time: timeController.text
                    ).then((value)
                    {
                      titleController.text= '';
                      dateController.text= '';
                      timeController.text= '';

                    });

                  }
                }else
                {
                  scaffoldKey.currentState?.showBottomSheet(
                        (context)=> Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaultTextFormField(
                              controller: titleController,
                              keyboardType: TextInputType.text,
                              labelText: 'Task Title',
                              prefixIcon: Icons.title,
                              validatorString: 'Title must not be empty',
                            ),
                            SizedBox(height: 20.0,),
                            defaultTextFormField(
                              onTab: ()
                              {
                                showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((value)
                                {
                                  timeController.text= value!.format(context);
                                  // print(value.format(context));
                                });
                              },
                              controller: timeController,
                              keyboardType: TextInputType.datetime,
                              labelText: 'Task Time',
                              prefixIcon: Icons.watch_later_outlined,
                              validatorString: 'Time must not be empty',
                            ),
                            SizedBox(height: 20.0,),
                            defaultTextFormField(
                                controller: dateController,
                                keyboardType: TextInputType.text,
                                labelText: 'Task Date',
                                prefixIcon: Icons.calendar_month_outlined,
                                validatorString: 'Date must not be empty',
                                onTab: ()
                                {
                                  showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now() ,
                                    lastDate: DateTime.parse('2050-10-10'),
                                  ).then((value)
                                  {
                                    dateController.text = DateFormat.yMMMd().format(value!);
                                    print(DateFormat.yMMMd().format(value));
                                  });

                                }
                            ),
                          ],
                        ),
                      ),
                    ),
                    elevation: 30.0,
                  ).closed.then((value)
                  {
                    cubit.changeBottomSheetIcon(isBottomShown: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetIcon(isBottomShown: true, icon: Icons.add);

                }

              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              fixedColor: Colors.blue[900],
              currentIndex: cubit.currentIndex,
              type: BottomNavigationBarType.fixed,
              onTap: (index)
              {
                cubit.getIndex(index);

              },
              items: [
                BottomNavigationBarItem(
                  backgroundColor: Colors.blue[900],
                  icon: Icon(Icons.menu),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline_sharp),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

}
