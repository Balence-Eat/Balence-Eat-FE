import 'dart:developer';

import 'package:frontend/model/inventory.dart';
import 'package:frontend/service/inventory_service.dart';

class InventoryVM {
  Future<List<Inventory>> getInventory() async {
    final inventory = await InventoryService.getInventory();
    log('재고 조회 완료 !');
    log('재고 응답 : $inventory');
    return inventory;
  }

  Future<int> addInventory(int foodId, int quantity) async {
    final responseCode = await InventoryService.addInventory(foodId, quantity);
    log('재고 등록 응답 코드: $responseCode');
    return responseCode;
  }
}
