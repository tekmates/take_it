part of 'di_module/base_di_module.dart';

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
  State<DiScopeBuilder<T>> createState() => DiScopeBuilderState<T>();
}

@visibleForTesting
class DiScopeBuilderState<T extends BaseDiModule>
    extends State<DiScopeBuilder<T>> {
  T? module;
  bool isInitialized = false;
  Key uniqueKey = UniqueKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isInitialized = false;
    module?.dispose();
    module = widget.createModule.call();
    module?._pushScope(
      () {
        if (mounted) {
          setState(() {
            isInitialized = true;
          });
        }
      },
      _ParentModuleProvider.of(context),
    );

    uniqueKey = UniqueKey();
    // module?.updateScope(_ParentModuleProvider.of(context));
  }

  @override
  void dispose() {
    module?._popScope();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final module = this.module;
    return isInitialized && module != null
        ? _ParentModuleProvider(
            key: uniqueKey,
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

class _ParentModuleProvider extends InheritedNotifier<BaseDiModule> {
  _ParentModuleProvider({
    required super.key,
    required this.module,
    required super.child,
  }) : super(notifier: module);

  final BaseDiModule module;

  static BaseDiModule? of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<_ParentModuleProvider>();
    return result?.notifier;
  }
}
