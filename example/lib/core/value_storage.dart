abstract interface class ValueStorage {
  int getValue();

  String getName();

  void saveValue(int value);
}

abstract class ValueStorageImpl implements ValueStorage {
  int _value = 0;

  @override
  int getValue() => _value;

  @override
  void saveValue(int value) {
    _value = value;
  }
}
