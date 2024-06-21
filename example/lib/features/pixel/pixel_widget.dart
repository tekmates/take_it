import 'package:example/core/state_manager_builder.dart';
import 'package:example/features/pixel/pixel_state_manager.dart';
import 'package:flutter/material.dart';

class PixelWidget extends StatelessWidget {
  const PixelWidget({
    super.key,
    required this.stateManager,
  });

  final PixelStateManager stateManager;

  @override
  Widget build(BuildContext context) {
    return StateManagerBuilder(
        stateManager: stateManager,
        builder: (context, color) {
          return Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                color: color,
              ),
            ),
          );
        });
  }
}
