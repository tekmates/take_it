import 'package:example/core/state_manager.dart';
import 'package:example/features/pixel/value_storages.dart';
import 'package:flutter/material.dart';

class PixelStateManager extends StateManager<Color> {
  PixelStateManager({
    required RedValueStorage redValueStorage,
    required GreenValueStorage greenValueStorage,
    required BlueValueStorage blueValueStorage,
  }) : super(
          Color.fromRGBO(
            redValueStorage.getValue(),
            greenValueStorage.getValue(),
            blueValueStorage.getValue(),
            1,
          ),
        );
}
