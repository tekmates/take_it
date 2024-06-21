import 'dart:async';

import 'package:example/core/state_manager.dart';
import 'package:flutter/material.dart';

class StateManagerBuilder<T> extends StatefulWidget {
  const StateManagerBuilder({
    super.key,
    required this.stateManager,
    required this.builder,
  });

  final StateManager<T> stateManager;
  final StateBuilder<T> builder;

  @override
  State<StatefulWidget> createState() => _StateManagerBuilderState<T>();
}

class _StateManagerBuilderState<T> extends State<StateManagerBuilder<T>> {
  late StreamSubscription _streamSubscription;

  @override
  void initState() {
    super.initState();
    _streamSubscription = widget.stateManager.stateStream.listen((event) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.stateManager.state);
  }
}

typedef StateBuilder<T> = Widget Function(BuildContext context, T state);
