import 'package:flutter/material.dart';
import 'package:take_it/src/di_module/base_di_module.dart';
import 'package:take_it/src/di_module/i_di_module.dart';
import 'package:take_it/src/registrar/initializer.dart';

/// Widget for initializing an instance
/// of [BaseDiModule].
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
  bool isInitializationLaunched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitializationLaunched) {
      isInitializationLaunched = true;
      module = widget.createModule.call();
      module.pushScope(
        () {
          if (mounted) {
            setState(() {
              isInitialized = true;
            });
          }
        },
        _ParentModuleProvider.of(context)?.module,
      );
    }
  }

  @override
  void dispose() {
    module.popScope();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isInitialized
        ? _ParentModuleProvider(
            module: module,

            /// [Builder] for providing correct context
            child: Builder(builder: (context) {
              return widget.builder.call(context, module);
            }),
          )
        : widget.initializationPlaceholder ?? const SizedBox.shrink();
  }
}

/// Signature of the widget builder
typedef ChildBuilder<T> = Widget Function(
    BuildContext context, IDiModule scope);

/// Signature of the create module function
typedef CreateModule<T> = T Function();

class _ParentModuleProvider extends InheritedWidget {
  _ParentModuleProvider({
    required this.module,
    required super.child,
  });

  final BaseDiModule module;

  static _ParentModuleProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_ParentModuleProvider>();
  }

  @override
  bool updateShouldNotify(_ParentModuleProvider oldWidget) {
    return false;
  }
}
