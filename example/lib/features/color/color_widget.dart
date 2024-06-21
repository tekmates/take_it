import 'package:example/core/state_manager_builder.dart';
import 'package:example/features/color/color_state_manager.dart';
import 'package:flutter/material.dart';

class ColorWidget extends StatelessWidget {
  const ColorWidget(this.stateManager, {super.key});

  final ColorStateManager stateManager;

  @override
  Widget build(BuildContext context) {
    return StateManagerBuilder(
      stateManager: stateManager,
      builder: (context, value) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Ink(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Text("${stateManager.valueStorage.getName()}: $value"),
                  Spacer(),
                  IconButton(
                      isSelected: true,
                      onPressed: stateManager.minus,
                      icon: const Icon(Icons.remove)),
                  IconButton(
                      isSelected: true,
                      onPressed: stateManager.plus,
                      icon: const Icon(Icons.add)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
