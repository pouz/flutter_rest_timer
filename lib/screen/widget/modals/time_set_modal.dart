import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimeSetModal extends StatelessWidget {
  const TimeSetModal({
    super.key,
    required this.onChangedWorkTime,
    required this.onChangedRestTime,
    required this.workController,
    required this.restController,
  });

  final void Function(String) onChangedWorkTime;
  final void Function(String) onChangedRestTime;
  final TextEditingController workController;
  final TextEditingController restController;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 100,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _pickNumber(
              title: 'Work',
              controller: workController,
              onChanged: onChangedWorkTime,
            ),
            const SizedBox(width: 20),
            _pickNumber(
              title: 'Rest',
              controller: restController,
              onChanged: onChangedRestTime,
            ),
          ],
        ),
      ),
    );
  }

  Widget _pickNumber({
    required String title,
    required void Function(String) onChanged,
    required TextEditingController controller,
  }) {
    return Material(
      child: Container(
        color: Colors.white,
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            TextField(
              controller: controller,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
