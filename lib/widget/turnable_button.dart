import 'package:flutter/material.dart';

class TurnableButton extends StatelessWidget {
  const TurnableButton({
    super.key,
    this.onPressed,
    this.style,
    this.disableBackgroundColor = Colors.grey,
    this.enable = true,
    this.child,
  });

  final void Function()? onPressed;
  final ButtonStyle? style;
  final Color? disableBackgroundColor;
  final bool enable;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: enable
          ? style
          : ElevatedButton.styleFrom().copyWith(
              backgroundColor:
                  MaterialStateProperty.all(disableBackgroundColor),
              elevation: MaterialStateProperty.all(0),
            ),
      child: child,
    );
  }
}
