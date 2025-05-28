import 'package:flutter/material.dart';

import '../../../widget/menu_container.dart';
import '../../../widget/menu_item.dart';

class PauseDialog extends StatefulWidget {
  const PauseDialog({
    super.key,
    required this.onRestart,
    required this.onSave,
    required this.onExit,
  });

  final Function()? onRestart;
  final Function()? onSave;
  final Function()? onExit;

  @override
  State<PauseDialog> createState() => _PauseDialogState();
}

class _PauseDialogState extends State<PauseDialog> {
  bool isSaveDialogVisible = false;

  @override
  Widget build(BuildContext context) {
    return MenuContainer(
      children: [
        MenuItem(title: 'RESTART', onPressed: widget.onRestart),
        MenuItem(title: 'SAVE', onPressed: widget.onSave),
        MenuItem(title: 'EXIT', onPressed: widget.onExit),
      ],
    );
  }
}
