
import 'package:flutter/material.dart';
import 'package:workcheckapp/models/promo_model.dart';
import 'package:workcheckapp/providers/promo_provider.dart';
import 'package:workcheckapp/services/db_local.dart';

// Future<void> syncPendingPromos(BuildContext context, PromoProvider provider, int outletId) async {
//   final db = LocalPromoDatabase();
//   final pending = await db.getPendingPromos();

//   for (var data in pending) {
//     final promo = PromoModel.fromJson(data);
//     try {
//       final response = await provider.createProductPromo(context, promo, outletId);
//       if (response != null && response.code == 200) {
//         await db.removePromo(data['key'] ?? 0); // hapus jika berhasil
//       }
//     } catch (e) {
//       debugPrint("Gagal sinkronisasi promo: $e");
//     }
//   }
// }