import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';
class ArchivedTaskScreen extends StatelessWidget {
  const ArchivedTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)  {

    return BlocConsumer<AppCubit,TodoAppStates>(
      listener: (context, state){},
      builder: (context, state)
      {
        var cub = AppCubit.get(context).archivedTasks;
        return taskItemBuilder(cub);
      },
    );
  }

}
