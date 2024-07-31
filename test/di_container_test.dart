import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:take_it/src/di_container/di_container.dart';

void main() {
  group('DiContainer', () {
    late DiContainer container;

    setUp(() {
      container = DiContainer();
    });

    test('registerFactory should register a factory', () {
      container.registerFactory<TestClass>(() => TestClass(22));
      expect(container.isRegistered<TestClass>(), isTrue);
      final instance = container.get<TestClass>();
      expect(instance.value, 22);
    });

    test('get should retrieve an instance created by a factory', () {
      container.registerFactory<TestClass>(() => TestClass());
      final instance = container.get<TestClass>();
      expect(instance, isA<TestClass>());
    });

    test('registerFactoryParam should register a factory with parameters', () {
      container
          .registerFactoryParam<TestClass, int>((param) => TestClass(param));
      expect(container.isRegistered<TestClass>(), isTrue);
    });

    test('get should retrieve an instance created by a factory with parameters',
        () {
      container
          .registerFactoryParam<TestClass, int>((param) => TestClass(param));
      final instance = container.get<TestClass>(param: 42);
      expect(instance, isA<TestClass>());
      expect(instance.value, 42);
    });

    test('registerSingleton should register a singleton', () {
      final instance = TestClass();
      container.registerSingleton<TestClass>(instance);
      expect(container.isRegistered<TestClass>(), isTrue);
      expect(container.get<TestClass>(), same(instance));
    });

    test('registerLazySingleton should register a lazy singleton', () {
      container.registerLazySingleton<TestClass>(() => TestClass());
      expect(container.isRegistered<TestClass>(), isTrue);
      final instance1 = container.get<TestClass>();
      final instance2 = container.get<TestClass>();
      expect(instance1, same(instance2));
    });

    test('get should throw an exception if service not found', () {
      expect(() => container.get<NonExistentClass>(), throwsException);
    });

    test('registerSingletonAsync should register an async singleton', () async {
      container.registerSingletonAsync<TestClass>(() async => TestClass());
      expect(container.isRegistered<TestClass>(), isTrue);
      await container.allReady();
      final instance = container.get<TestClass>();
      expect(instance, isA<TestClass>());
    });
  });
}

class TestClass extends Equatable{
  TestClass([this.value]);

  final int? value;

  @override
  List<Object?> get props => [value];
}

class NonExistentClass {}
