import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/common/show_response_dialog.dart';
import 'package:frontend/model/food.dart';
import 'package:frontend/model/inventory.dart';
import 'package:frontend/view_model/food_vm.dart';
import 'package:frontend/view_model/inventory_vm.dart';
import 'package:go_router/go_router.dart';

class RefrigeratorScreen extends StatefulWidget {
  const RefrigeratorScreen({super.key});

  @override
  State<RefrigeratorScreen> createState() => _RefrigeratorScreenState();
}

class _RefrigeratorScreenState extends State<RefrigeratorScreen> {
  bool isLoading = false;
  String? error;

  List<Inventory> inventory = [];
  List<Food> foods = [];

  FoodVM foodVM = FoodVM();
  InventoryVM inventoryVM = InventoryVM();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final result = await inventoryVM.getInventory(); // await은 여기서!
      setState(() {
        inventory = result;
      });
    } catch (e) {
      setState(() {
        log(e.toString());
        error = '데이터 로드 중 오류가 발생했습니다.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showAddInventoryDialog(Food food) {
    final TextEditingController quantityController =
        TextEditingController(text: '1');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('${food.name} 재고 추가'),
          content: TextField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: '수량',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                int quantity = int.tryParse(quantityController.text) ?? 0;
                int responseCode =
                    await inventoryVM.addInventory(food.foodId, quantity);
                if (responseCode == 200) {
                  showResponseDialog(context, responseCode, "재고 등록을 성공했습니다.");
                  Navigator.of(context).pop(); // Close dialog
                  await fetchData(); // Refresh inventory
                } else {
                  showResponseDialog(context, responseCode, null);
                }
              },
              child: const Text('추가'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 냉장고'),
        backgroundColor: Colors.green[700],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(error!))
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '음식등록',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('새 음식 등록하기'),
                        onPressed: () {
                          final nameController = TextEditingController();
                          final unitController = TextEditingController();
                          final caloriesController = TextEditingController();
                          final proteinController = TextEditingController();
                          final carbsController = TextEditingController();
                          final fatController = TextEditingController();
                          final allergensController = TextEditingController();

                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('새 음식 등록'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      TextField(
                                        controller: nameController,
                                        decoration: const InputDecoration(
                                            labelText: '음식 이름'),
                                      ),
                                      TextField(
                                        controller: unitController,
                                        decoration: const InputDecoration(
                                          labelText: '1회 제공량 (g 또는 ml 단위)',
                                          hintText: '예: 100',
                                        ),
                                        keyboardType: TextInputType.number,
                                      ),
                                      TextField(
                                        controller: caloriesController,
                                        decoration: const InputDecoration(
                                            labelText: '칼로리 (단위당)'),
                                        keyboardType: TextInputType.number,
                                      ),
                                      TextField(
                                        controller: proteinController,
                                        decoration: const InputDecoration(
                                            labelText: '단백질 (단위당)'),
                                        keyboardType: TextInputType.number,
                                      ),
                                      TextField(
                                        controller: carbsController,
                                        decoration: const InputDecoration(
                                            labelText: '탄수화물 (단위당)'),
                                        keyboardType: TextInputType.number,
                                      ),
                                      TextField(
                                        controller: fatController,
                                        decoration: const InputDecoration(
                                            labelText: '지방 (단위당)'),
                                        keyboardType: TextInputType.number,
                                      ),
                                      TextField(
                                        controller: allergensController,
                                        decoration: const InputDecoration(
                                            labelText: '알레르기 유발 물질'),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('취소'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      final name = nameController.text;
                                      final unit =
                                          int.tryParse(unitController.text) ??
                                              0;
                                      final calories = int.tryParse(
                                              caloriesController.text) ??
                                          0;
                                      final protein = int.tryParse(
                                              proteinController.text) ??
                                          0;
                                      final carbs =
                                          int.tryParse(carbsController.text) ??
                                              0;
                                      final fat =
                                          int.tryParse(fatController.text) ?? 0;
                                      final allergens =
                                          allergensController.text;
                                      final statusCode =
                                          await foodVM.createFood(
                                              name: name,
                                              unit: unit,
                                              caloriesPerUnit: calories,
                                              proteinPerUnit: protein,
                                              carbsPerUnit: carbs,
                                              fatPerUnit: fat,
                                              allergens: allergens);
                                      if (statusCode == 200) {
                                        showResponseDialog(
                                            context, 200, "음식 등록이 되었습니다.");
                                      } else if (statusCode == 422) {
                                        showResponseDialog(context, 422, null);
                                      } else {
                                        showResponseDialog(context, statusCode,
                                            "관리자에게 문의바랍니다.");
                                      }
                                    },
                                    child: const Text('등록'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        '현재 등록된 음식',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      FutureBuilder<List<Food>>(
                        future: foodVM.getFoods(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('음식 목록 불러오기 실패'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(child: Text('등록된 음식이 없습니다.'));
                          }

                          final foods = snapshot.data!;
                          return SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: foods.length,
                              itemBuilder: (context, index) {
                                final food = foods[index];
                                return Container(
                                  width: 200,
                                  margin: const EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                  ),
                                  child: ListTile(
                                    title: Text(food.name),
                                    subtitle: Text(
                                        '칼로리: ${food.caloriesPerUnit}kcal\n단백질: ${food.proteinPerUnit}g'),
                                    trailing: IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () =>
                                          _showAddInventoryDialog(food),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        '재고확인',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView.builder(
                          itemCount: inventory.length,
                          itemBuilder: (context, index) {
                            final item = inventory[index];
                            return ListTile(
                              title: Text(item.foodName ?? '이름 없음'),
                              trailing: Text('${item.quantity}개'),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
