// import 'package:hive/hive.dart';
// import '../models/promo_model.dart';

// class LocalPromoDatabase {
//   static const String boxName = 'promo_offline';
  
//   Future<void> addPromoOffline(PromoModel promo) async {
//     final box = await Hive.openBox(boxName);
//     await box.add(promo.toJson());
//   }

//   Future<List<Map<String, dynamic>>> getPendingPromos() async {
//     final box = await Hive.openBox(boxName);
//     return box.values.map((e) => Map<String, dynamic>.from(e)).toList();
//   }

//   Future<void> removePromo(int key) async {
//     final box = await Hive.openBox(boxName);
//     await box.delete(key);
//   }
// }


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

  Future<void> clearAll() async {
    final box = await Hive.openBox(boxName);
    await box.clear();
    await box.close();
  }
}
