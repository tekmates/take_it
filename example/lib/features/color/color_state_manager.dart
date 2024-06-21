import 'package:example/core/state_manager.dart';
import 'package:example/core/value_storage.dart';
import 'package:example/features/color/decrementer.dart';
import 'package:example/features/color/incrementer.dart';

class ColorStateManager extends StateManager<int> {
  ColorStateManager({
    required this.decrementer,
    required this.incrementer,
    required this.valueStorage,
  }) : super(valueStorage.getValue());
  final ValueStorage valueStorage;
  final Incrementer incrementer;
  final Decrementer decrementer;
  
  
  void plus(){
    incrementer.increment();
    setState(valueStorage.getValue());
  }
  
  void minus(){
    decrementer.decrement();
    setState(valueStorage.getValue());
  }
  
  
}
