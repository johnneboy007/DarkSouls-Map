import 'package:flutter/material.dart';
import '../../variables/index.dart';

class NewAppbar extends StatelessWidget with PreferredSizeWidget {
  const NewAppbar({
    super.key,
    required this.title,
  });

  final Widget? title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      backgroundColor: eldenColors.shade500,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}