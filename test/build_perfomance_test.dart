import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:take_it/src/di_module/base_di_module.dart';
import 'package:take_it/src/registrar/sync_registrar.dart';

import 'get_it_helpers/get_it_scope.dart';

void main() {
  group(
    'Build scope getIt performance test',
    () {
      testWidgets(
        'Default constructor',
        (widgetTester) async {
          Widget wrapWithDi(
            Widget widget,
            Widget Function(Widget) wrapper,
            int count,
          ) {
            var finalWidget = widget;

            for (var i = 0; i < count; i++) {
              finalWidget = wrapper(finalWidget);
            }

            return finalWidget;
          }

          final takeItDiScopeWidget = wrapWithDi(
            const SizedBox(),
            (widget) => DiScopeBuilder(
              createModule: () => _FakeDiModule(),
              builder: (_, __) => widget,
            ),
            1000,
          );

          final getItDiScopeWidget = wrapWithDi(
            const SizedBox(),
            (widget) => GetItDiScope(
              create: () => _FakeGetItInitializer(),
              builder: (_) => widget,
            ),
            1000,
          );

          Future<void> testWidget(Widget widget) async {
            final sw = Stopwatch();
            sw.start();

            await widgetTester.pumpWidget(widget);
            await widgetTester.pumpAndSettle();

            sw.stop();
            debugPrint('Elapsed: ${sw.elapsedMilliseconds} ms');
          }

          debugPrint('Warm up:');
          await testWidget(Container());
          debugPrint('TakeIt:');
          await testWidget(takeItDiScopeWidget);
          debugPrint('GetIt:');
          await testWidget(getItDiScopeWidget);
          debugPrint('TakeIt:');
          await testWidget(takeItDiScopeWidget);
          debugPrint('GetIt:');
          await testWidget(getItDiScopeWidget);
          debugPrint('TakeIt:');
          await testWidget(takeItDiScopeWidget);
        },
      );
    },
  );
}

class _FakeDiModule extends DiModule {
  @override
  void setup(SyncRegistrar it) {
    it
      ..registerFactory(() => SomeClass1())
      ..registerFactory(() => SomeClass2())
      ..registerFactory(() => SomeClass3())
      ..registerFactory(() => SomeClass4())
      ..registerFactory(() => SomeClass5())
      ..registerFactory(() => SomeClass6())
      ..registerFactory(() => SomeClass7())
      ..registerFactory(() => SomeClass8())
      ..registerFactory(() => SomeClass9())
      ..registerFactory(() => SomeClass10())
      ..registerFactory(() => SomeClass11())
      ..registerFactory(() => SomeClass12());
  }
}

class _FakeGetItInitializer implements GetItDiInitializer {
  @override
  void initialize(GetIt getIt) {
    getIt
      ..registerFactory(() => SomeClass1())
      ..registerFactory(() => SomeClass2())
      ..registerFactory(() => SomeClass3())
      ..registerFactory(() => SomeClass4())
      ..registerFactory(() => SomeClass5())
      ..registerFactory(() => SomeClass6())
      ..registerFactory(() => SomeClass7())
      ..registerFactory(() => SomeClass8())
      ..registerFactory(() => SomeClass9())
      ..registerFactory(() => SomeClass10())
      ..registerFactory(() => SomeClass11())
      ..registerFactory(() => SomeClass12());
  }
}

class SomeClass1 {}

class SomeClass2 {}

class SomeClass3 {}

class SomeClass4 {}

class SomeClass5 {}

class SomeClass6 {}

class SomeClass7 {}

class SomeClass8 {}

class SomeClass9 {}

class SomeClass10 {}

class SomeClass11 {}

class SomeClass12 {}
