import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class DateTimeFormField extends StatelessWidget {
  final FormFieldSetter<DateTime> onSaved;
  final FormFieldSetter<DateTime> validator;

  final AutovalidateMode autoValidateMode;
  final InputDecoration decoration;
  final DateFormat formatter;
  final DateTime initialValue;
  final DateTime firstDate;
  final DateTime lastDate;
  final bool onlyDate;
  final bool onlyTime;
  final bool enabled;

  DateTimeFormField({
    @required DateTime initialValue,
    DateFormat formatter,
    DateTime firstDate,
    DateTime lastDate,
    this.decoration,
    this.validator,
    this.onSaved,
    this.autoValidateMode: AutovalidateMode.disabled,
    this.enabled: true,
    this.onlyDate: false,
    this.onlyTime: false,
  })  : assert(!onlyDate || !onlyTime),
        initialValue = initialValue ?? DateTime.now(),
        formatter = formatter ??
            (onlyDate
                ? DateFormat('EEE, MMM d, yyyy')
                : (onlyTime
                    ? DateFormat('h:mm a')
                    : DateFormat('EE, MMM d, yyyy h:mma'))),
        firstDate = firstDate ?? DateTime(1970),
        lastDate = lastDate ?? DateTime(2100);

  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      validator: validator,
      autovalidateMode: AutovalidateMode.always,
      initialValue: initialValue,
      onSaved: onSaved,
      enabled: enabled,
      builder: (FormFieldState state) {
        return InkWell(
          child: InputDecorator(
            decoration: decoration,
            child: Text(formatter.format(state.value)),
          ),
          onTap: () async {
            DateTime date;
            TimeOfDay time = TimeOfDay(hour: 0, minute: 0);
            if (onlyDate) {
              date = await showDatePicker(
                context: context,
                initialDate: state.value,
                firstDate: firstDate,
                lastDate: lastDate,
              );
              if (date != null) {
                state.didChange(date);
              }
            } else if (onlyTime) {
              time = await showTimePicker(
                context: context,
                initialEntryMode: TimePickerEntryMode.input,
                initialTime: TimeOfDay.fromDateTime(state.value),
              );
              if (time != null) {
                state.didChange(
                  DateTime(
                    initialValue.year,
                    initialValue.month,
                    initialValue.day,
                    time.hour,
                    time.minute,
                  ),
                );
              }
            } else {
              date = await showDatePicker(
                  context: context,
                  initialDate: state.value,
                  firstDate: firstDate,
                  lastDate: lastDate);
              if (date != null) {
                time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(state.value),
                );
                if (time != null) {
                  state.didChange(
                    DateTime(
                      date.year,
                      date.month,
                      date.day,
                      time.hour,
                      time.minute,
                    ),
                  );
                }
              }
            }
          },
        );
      },
    );
  }
}
