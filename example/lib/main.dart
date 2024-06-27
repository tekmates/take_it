import 'package:example/di/blue_di_module.dart';
import 'package:example/di/core_di_module.dart';
import 'package:example/di/green_di_module.dart';
import 'package:example/di/pixel_di_module.dart';
import 'package:example/di/red_di_module.dart';
import 'package:example/features/color/color_widget.dart';
import 'package:example/features/pixel/pixel_widget.dart';
import 'package:flutter/material.dart';
import 'package:take_it/take_it.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DiScopeBuilder(
        createModule: () => CoreDiModule(),
        initializationPlaceholder: Center(child: CircularProgressIndicator()),
        builder: (context, scope) {
          return MaterialApp(
            title: 'take_it Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: const MyHomePage(),
          );
        });
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("take_it Demo"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Pixel settings",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            DiScopeBuilder(
              createModule: () => RedDiModule(),
              builder: (context, scope) => ColorWidget(scope.get()),
            ),
            DiScopeBuilder(
              createModule: () => GreenDiModule(),
              builder: (context, scope) => ColorWidget(scope.get()),
            ),
            DiScopeBuilder(
              createModule: () => BlueDiModule(),
              builder: (context, scope) => ColorWidget(scope.get()),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text("Pixel"),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: IntrinsicHeight(
                    child: DiScopeBuilder(
                        createModule: () => PixelDiModule(),
                        builder: (context, scope) {
                          return PixelWidget(
                            stateManager: scope.get(),
                          );
                        }),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Close"))
                  ],
                  actionsPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                );
              });
        },
      ),
    );
  }
}
