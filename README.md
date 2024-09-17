# take_it

`take_it` is a **Scoped Service Locator** with **Constructor Injections** for Dart and Flutter. It helps you manage dependencies in your application in a clean, efficient, and testable manner.

## Overview

This is a lightweight dependency management library that combines the simplicity of the **Service Locator** pattern with the flexibility of **Inversion of Control (IoC)**. This hybrid approach allows you to efficiently manage your application's dependencies while maintaining clean and modular architecture.

### Key Features:

- 🛠️ **No Code Generation:** Unlike some dependency management solutions, take_it does not require code generation. It provides a straightforward API for dependency registration and retrieval, minimizing setup complexity and reducing build times.
- ❤️ **Familiar API:** take_it offers a syntax and API similar to get_it, making it easy for users familiar with get_it to adopt and integrate it into their projects. This ensures a smooth learning curve and compatibility with existing codebases.
- 🔐 **Scoped Service Locator & Modular Configuration:** Dependencies are encapsulated within specialized modules, preventing global access to services and providing better control over their lifecycle. Each module manages only the dependencies it needs, avoiding the clutter of a globally accessible service locator. This method simplifies testing, maintenance, and scalability, keeping your codebase organized and manageable.
- 🏗️ **Constructor Injections:** Instead of relying on the service locator throughout the codebase, take_it encourages injecting dependencies directly through constructors, promoting explicit and testable dependencies while still leveraging the ease of service registration.
- 🧪 **Clean and Testable Code:** By avoiding global dependency access and focusing on constructor-based injection, take_it makes it easy to mock dependencies and write unit tests, while also keeping the architecture transparent and maintainable.
- 🚀 **Performance Optimization:** The library’s design ensures minimal overhead and fast dependency resolution, validated by performance tests included within the package.

## Installation

Add `take_it` to your project's dependencies in `pubspec.yaml`:

```yaml
dependencies:
  take_it: ^1.0.0
```

## Getting started

Set up all required dependencies in your DiModule

```
import 'package:take_it/take_it.dart';

class ExampleDiModule extends DiModule {
  @override
  void setup(SyncRegistrar it) {
    it.registerFactory(() => ExampleBloc());
  }
}
```
Attach the scope to the context using the DiScopeBuilder and inject the dependency into the desired class via the constructor
```
  Widget build(BuildContext context) {
    return DiScopeBuilder(
      createModule: () => ExampleDiModule(),
      builder: (context, scope) => ExampleScreen(bloc: scope.get()),
    );
  }
```

## Usage

The scope has access to all objects registered higher in the hierarchy but cannot access objects registered in lower scopes. The hierarchy follows the structure defined by the DiScopeBuilder<DiModule> placement within the widget tree.
```
@override
void setup(SyncRegistrar it) {
  it.registerFactory(() => ClassB(a: get<ClassA>));
}
```

You can wait for asynchronous data in a module using DiModuleAsync
```
class ExampleDiModule extends DiModuleAsync {
  
  @override
  Future<void> setup(AsyncRegistrar it) async {
    await ...// here
    it.registerSingletonAsync(() async{
    await ... // or here
    return Example();
    } );
  }

}
```
and even display progress during initialization
```
    return DiScopeBuilder(
       initializationPlaceholder: CircularProgressIndicator(),
        createModule: ...,
        builder: ...,
    );
```

## License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.
