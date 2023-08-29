import 'package:flutter/material.dart';
import 'package:teamup/utils/app_strings.dart';

import 'widgets/active_goal_widget.dart';

class ActiveGoalsPage extends StatelessWidget {
  const ActiveGoalsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppStrings.yourGoals, style: TextStyle(fontWeight: FontWeight.w400),),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: 10,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return ActiveGoalWidget(goalId: "",);
                }),
          ),
        ],
      ),
    );
  }
}
