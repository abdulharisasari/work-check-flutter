


import 'package:hive_flutter/hive_flutter.dart';

class LocalOfflineDatabase<T> {
  final String boxName;
  final T Function(Map<String, dynamic> json) fromJson;
  final Map<String, dynamic> Function(T item) toJson;

  LocalOfflineDatabase({
    required this.boxName,
    required this.fromJson,
    required this.toJson,
  });

  Future<void> addItem(T item) async {
    final box = await Hive.openBox(boxName);
    await box.add(toJson(item));
  }

  Future<List<T>> getPendingItems() async {
    final box = await Hive.openBox(boxName);
    return box.values.map((e) => fromJson(Map<String, dynamic>.from(e))).toList();
  }

  Future<void> removeItem(int key) async {
    final box = await Hive.openBox(boxName);
    await box.delete(key);
  }

  Future<T?> getLatestItem() async {
    final items = await getPendingItems();
    if (items.isEmpty) return null;
    return items.last;
  }



  Future<void> clearAll() async {
    final box = await Hive.openBox(boxName);
    await box.clear();
    await box.close();
  }
}
