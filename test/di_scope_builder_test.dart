import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:take_it/src/di_module/base_di_module.dart';
import 'package:take_it/src/registrar/sync_registrar.dart';

int count = 0;

class MockModule extends DiModule {
  @override
  void setup(SyncRegistrar it) {
    it.registerFactory(() => get<int>().toString());
  }
}

class MockParentModule extends DiModule {
  @override
  void setup(SyncRegistrar it) {
    count++;
    final result = count;
    it.registerFactory(() => result);
  }
}

void main() {
  testWidgets('didChangeDependencies is called and module is reinitialized',
      (tester) async {
    final module = MockModule();
    final builderKey = GlobalKey();
    await module.init();

    Widget uut({Key? key}) => MaterialApp(
          key: key,
          home: DiScopeBuilder<MockParentModule>(
            createModule: () => MockParentModule(),
            builder: (context, scope) {
              return DiScopeBuilder<MockModule>(
                key: builderKey,
                createModule: () => module,
                builder: (context, module) {
                  return const Text('DiScopeBuilder Test');
                },
              );
            },
          ),
        );

    await tester.pumpWidget(uut());

    var context = tester.element(find.text('DiScopeBuilder Test'));
    var state =
        context.findAncestorStateOfType<DiScopeBuilderState<MockModule>>()!;

    expect(state.module, isNotNull);
    expect(state.module!.get<int>(), count);
    expect(state.module!.get<String>(), count.toString());
    expect(state.isInitialized, isTrue);

    // didChangeDependencies
    await tester.pumpWidget(uut(key: UniqueKey()));

    context = tester.element(find.text('DiScopeBuilder Test'));
    state = context.findAncestorStateOfType<DiScopeBuilderState<MockModule>>()!;

    expect(state.module, isNotNull);
    expect(state.module!.get<int>(), count);
    expect(state.module!.get<String>(), count.toString());
    expect(state.isInitialized, isTrue);
  });
}
