import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../mixins/baseClass.dart';

class CupertinoDatePickerBottomSheet with BaseClass {
  DateTime? selectedDate;

  void cupertinoDatePicker(
      BuildContext context, Function onDateSelected) async {
    return showCupertinoModalPopup(
      context: context,
      barrierDismissible: false,
      builder: (_) => Container(
        height: 350,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: CupertinoButton(
                  child: const Text('Done'),
                  onPressed: () {
                    if (selectedDate == null) {
                      showError(title: "Date", message: "Please select date");
                    } else {
                      onDateSelected(
                          DateFormat('yyyy-MM-dd').format(selectedDate!));
                    }
                  }),
            ),
            SizedBox(
              height: 250,
              child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  use24hFormat: false,
                  minuteInterval: 1,
                  initialDateTime: DateTime(1975, 1, 1),
                  onDateTimeChanged: (val) {
                    selectedDate = val;
                  }),
            ),

            // Close the modal
          ],
        ),
      ),
    );
  }
}
