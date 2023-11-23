import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimeSetModal extends StatelessWidget {
  const TimeSetModal({
    super.key,
    required this.workController,
    required this.restController,
    required this.onTapOK,
  });

  final TextEditingController workController;
  final TextEditingController restController;
  final void Function(String, String) onTapOK;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 200,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _pickNumber(
                  title: 'Work',
                  controller: workController,
                ),
                const SizedBox(width: 20),
                _pickNumber(
                  title: 'Rest',
                  controller: restController,
                ),
              ],
            ),
            const SizedBox(height: 20),
            _okCancelButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _okCancelButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            onTapOK(
              workController.value.text,
              restController.value.text,
            );
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
        const SizedBox(width: 30),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Widget _pickNumber({
    required String title,
    required TextEditingController controller,
  }) {
    return Material(
      child: Container(
        color: Colors.white,
        width: 50,
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
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 2,
              decoration: const InputDecoration(
                counterText: '',
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
