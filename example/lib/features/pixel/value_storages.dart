import 'package:example/core/value_storage.dart';

class RedValueStorage extends ValueStorageImpl {
  @override
  String getName() => "Red";
}

class GreenValueStorage extends ValueStorageImpl {
  @override
  String getName() => "Green";
}

class BlueValueStorage extends ValueStorageImpl {
  @override
  String getName() => "Blue";
}
