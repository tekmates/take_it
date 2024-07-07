import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

export 'package:get_it/get_it.dart';

class GetItDiScope extends StatefulWidget {
  const GetItDiScope({
    required this.create,
    required this.builder,
    super.key,
  });

  final GetItDiInitializer Function() create;
  final Widget Function(BuildContext) builder;

  @override
  State<GetItDiScope> createState() => _GetItDiScopeState();
}

class _GetItDiScopeState extends State<GetItDiScope> {
  @override
  void initState() {
    GetIt.instance.pushNewScope();
    final initializer = widget.create();
    initializer.initialize(GetIt.instance);
    super.initState();
  }

  @override
  void dispose() {
    GetIt.instance.popScope();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}

abstract interface class GetItDiInitializer {
  void initialize(GetIt getIt);
}
