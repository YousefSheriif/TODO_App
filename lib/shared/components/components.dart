import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget defaultButton({
  Color? color = Colors.blue ,
  double height = 45.0,
  double width = 250.0,
  double radius = 30.0,
  bool isUpper = false,
  required String text,
  required Function,
  Color? textColor = Colors.white ,
  double textSize = 22.0 ,
})
{
  return Center(
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: color,
      ),
      child: MaterialButton(
        onPressed: Function,
        child: Text(
          isUpper?text.toUpperCase():text,
          style: TextStyle(
            color: textColor,
            fontSize: textSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );

}




Widget defaultTextFormField({
  required TextEditingController? controller,
  required TextInputType keyboardType ,
  required String ? labelText ,
  required IconData ?prefixIcon,
  void Function(String val)? onSubmit,
  void Function(String value)? onchange,
  void Function()? onTab,
  void Function()? suffixOnPressed,
  required String ? validatorString ,
  IconData ?suffixIcon,
  bool isPassword  = false ,
  Color? color = Colors.grey ,
})
{
  return TextFormField(
    controller: controller,
    keyboardType:keyboardType ,
    onChanged: onchange,
    onFieldSubmitted: onSubmit,
    onTap: onTab,
    validator: (val)
    {
      if (val!.isEmpty)
      {
        return validatorString;
      }
      return null;
    },
    obscureText: isPassword ,
    decoration: InputDecoration(

      prefixIcon: Icon(prefixIcon,),
      prefixIconConstraints:BoxConstraints(minWidth: 50.0 ),
      suffixIcon:
      IconButton(
        icon: Icon(suffixIcon,color:color,),
        onPressed: suffixOnPressed,
      ),
      labelText: labelText,
      border: OutlineInputBorder(),
    ),
  ) ;
}


Widget taskItem(Map model,context)
{
  return Dismissible(
    key:Key(model['id'].toString()),
    onDismissed: (direction)
    {
      AppCubit.get(context).deleteDatabase(id: model['id']);
    },
    child:Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 33.0,
            child: Text(
              '${model['time']}',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.blue[900],
          ),
          SizedBox(width: 15.0,),
          Expanded(
            child:Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model['title']}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${model['date']}',
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            color: Colors.green,
              iconSize: 35.0,
              onPressed:()
              {
                AppCubit.get(context).updateDatabase(status: 'done',  id: model['id']);
              },
              icon: Icon(Icons.check_box_sharp)),
          SizedBox(width: 7.5,),
          IconButton(
              color: Colors.black54,
              iconSize: 35.0,
              onPressed:()
              {
                AppCubit.get(context).updateDatabase(status: 'archived',  id: model['id']);

              },
              icon: Icon(Icons.archive)),

        ],
      ),
    ),
  );
}



Widget taskItemBuilder(List<Map>cub)
{
  return ConditionalBuilder(
    condition:cub.length>0 ,
    builder:(context) => ListView.separated(
      itemBuilder: (context , index) =>taskItem(cub[index],context),
      separatorBuilder: (context,index)=>Padding(
        padding: const EdgeInsetsDirectional.only(start: 20.0),
        child: Container(
          width: double.infinity,
          height: 1.0,
          color: Colors.grey,
        ),
      ),
      itemCount: cub.length,
    ) ,
    fallback:(context) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              size: 125.0,
              color: Colors.grey[400],
            ),
            SizedBox(height: 20.0,),
            Text(
              'No Tasks yet Pleaze Add Some Tasks First',
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    ),
  ) ;
}