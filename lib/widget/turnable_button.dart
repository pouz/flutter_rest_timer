import 'package:flutter/material.dart';

class TurnableButton extends StatelessWidget {
  const TurnableButton({
    super.key,
    this.onPressed,
    this.style,
    this.disableBackgroundColor = Colors.grey,
    this.enable = true,
    this.padding = const EdgeInsets.all(8),
    required this.child,
  });

  final void Function()? onPressed;
  final ButtonStyle? style;
  final Color? disableBackgroundColor;
  final bool enable;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding!,
      child: IconButton(
        onPressed: onPressed,
        icon: child,
      ),
    );
  }
}
