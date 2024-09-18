part of 'di_module/base_di_module.dart';

/// A widget for initializing an instance of [BaseDiModule] and managing its lifecycle.
///
/// [DiScopeBuilder] is responsible for creating and managing a [BaseDiModule] instance
/// within the widget tree. It supports both synchronous and asynchronous modules and provides
/// the module to its children via the [ChildBuilder].
///
/// It automatically handles scope management, including initializing, updating, and disposing
/// the module as needed. This ensures that the correct DI scope is available throughout the
/// widget tree.
///
/// - [createModule]: A factory function used to create an instance of the module.
/// - [builder]: A callback that builds the widget tree using the context and the provided module.
/// - [initializationPlaceholder]: A widget that is shown while the module is initializing (e.g., for async modules).
///
/// [initializationPlaceholder] is used specifically when dealing with asynchronous modules.
class DiScopeBuilder<T extends BaseDiModule> extends StatefulWidget {
  const DiScopeBuilder({
    required this.createModule,
    this.initializationPlaceholder,
    required this.builder,
    super.key,
  });

  /// A function that creates the DI module instance of type [T].
  final CreateModule<T> createModule;

  /// A builder function that takes the current [BuildContext] and the provided [Scope] (the module) to build the UI.
  final ChildBuilder builder;

  /// A widget to display while the module is being initialized, typically for asynchronous modules.
  final Widget? initializationPlaceholder;

  @override
  State<DiScopeBuilder<T>> createState() => DiScopeBuilderState<T>();
}

/// State class for [DiScopeBuilder], responsible for managing the module's lifecycle.
@visibleForTesting
class DiScopeBuilderState<T extends BaseDiModule>
    extends State<DiScopeBuilder<T>> {
  T? module;
  bool isInitialized = false;
  Key uniqueKey = UniqueKey();

  /// Initializes or updates the module when dependencies change.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newModule = widget.createModule.call();

    if (module == newModule || (newModule._isInitialized && module == null)) {
      isInitialized = true;
      module = newModule;
      module?._updateScope(_ParentModuleProvider.of(context));
    } else {
      isInitialized = false;
      module?.dispose();
      module = newModule;
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
    }
  }

  /// Disposes the module and removes its scope when the widget is disposed.
  @override
  void dispose() {
    module?._popScope();
    super.dispose();
  }

  /// Builds the widget tree with the module once it is initialized, or shows the initialization placeholder if not.
  @override
  Widget build(BuildContext context) {
    final module = this.module;
    return isInitialized && module != null
        ? _ParentModuleProvider(
      key: uniqueKey,
      module: module,

      /// [Builder] for providing the correct context.
      child: Builder(builder: (context) {
        return widget.builder.call(context, module);
      }),
    )
        : widget.initializationPlaceholder ?? const SizedBox.shrink();
  }
}

/// Signature for the widget builder function used by [DiScopeBuilder].
///
/// This function receives the [BuildContext] and the current [Scope] (module)
/// and returns a widget that uses the module.
typedef ChildBuilder<T> = Widget Function(
    BuildContext context, Scope scope);

/// Signature for the function used to create a [BaseDiModule] instance.
typedef CreateModule<T> = T Function();

/// Provides the parent [BaseDiModule] to the widget tree via [InheritedNotifier].
///
/// This is used internally by [DiScopeBuilder] to propagate the current DI module down
/// the widget tree, ensuring that the module is available to child widgets.
class _ParentModuleProvider extends InheritedNotifier<BaseDiModule> {
  _ParentModuleProvider({
    required super.key,
    required this.module,
    required super.child,
  }) : super(notifier: module);

  /// The current [BaseDiModule] being provided to the widget tree.
  final BaseDiModule module;

  /// Retrieves the current [BaseDiModule] from the widget tree.
  ///
  /// This method looks up the widget tree for an instance of [_ParentModuleProvider] and returns
  /// the module that it is providing. Returns `null` if no module is found.
  static BaseDiModule? of(BuildContext context) {
    final result =
    context.dependOnInheritedWidgetOfExactType<_ParentModuleProvider>();
    return result?.notifier;
  }
}
