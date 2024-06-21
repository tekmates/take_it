import 'package:flutter/material.dart';
import 'package:take_it/src/di_module/base_di_module.dart';
import 'package:take_it/src/di_module/global_scope_di_module.dart';
import 'package:take_it/src/di_module/local_scope_di_module.dart';
import 'package:take_it/src/registrar/initializer.dart';

import 'di_module/di_module.dart';

/// Widget for initializing an instance
/// of [LocalScopeDiModule] or [GlobalScopeDiModule].
/// [initializationPlaceholder] need for [Initializer.async]
class DiScopeBuilder<T extends BaseDiModule> extends StatefulWidget {
  const DiScopeBuilder({
    required this.builder,
    required this.createModule,
    this.initializationPlaceholder,
    super.key,
  });

  final ChildBuilder builder;

  final Widget? initializationPlaceholder;

  final CreateModule<T> createModule;

  @override
  State<DiScopeBuilder<T>> createState() => _DiScopeBuilderState<T>();
}

class _DiScopeBuilderState<T extends BaseDiModule>
    extends State<DiScopeBuilder<T>> {
  late final T module;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    module = widget.createModule.call();
    module.pushScope(() {
      if (mounted) {
        setState(() {
          isInitialized = true;
        });
      }
    });
  }

  @override
  void dispose() {
    module.popScope();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isInitialized
        ? widget.builder.call(context, module)
        : widget.initializationPlaceholder ?? const SizedBox.shrink();
  }
}

/// Signature of the widget builder
typedef ChildBuilder<T> = Widget Function(BuildContext context, DiModule scope);

/// Signature of the create module function
typedef CreateModule<T> = T Function();
