import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';
class NewTaskScreen extends StatelessWidget
{
  const NewTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {

    return BlocConsumer<AppCubit,TodoAppStates>(
      listener: (context, state){},
      builder: (context, state)
      {
        var cub = AppCubit.get(context).newTasks;
        return taskItemBuilder(cub);
      },
    );
  }
}
