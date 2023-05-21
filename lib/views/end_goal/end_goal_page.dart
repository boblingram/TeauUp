import 'package:flutter/material.dart';

import 'widgets/end_goal_widget.dart';

class EndGoalPage extends StatelessWidget {
  const EndGoalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return const EndGoalWidget();
          }),
    );
  }
}
