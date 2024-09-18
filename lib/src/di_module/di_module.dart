part of 'base_di_module.dart';

/// An abstract class that represents a synchronous DI module, extending the functionality
/// of [BaseDiModule] and implementing the [Scope] interface.
///
/// The module is responsible for setting up dependency registrations using a [SyncRegistrar],
/// which handles the registration of non-async factories and instances.
abstract class DiModule extends BaseDiModule implements Scope {
  /// Sets up the module by registering dependencies into the provided [SyncRegistrar].
  ///
  /// This method should be implemented by subclasses to define the dependency
  /// registration logic, which may include registering singletons, factories, or
  /// factory parameters that are used within the module's scope.
  ///
  /// - [it]: The [SyncRegistrar] used for registering dependencies synchronously.
  void setup(SyncRegistrar it);
}
