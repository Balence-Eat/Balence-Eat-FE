import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/common/show_response_dialog.dart';
import 'package:frontend/model/food.dart';
import 'package:frontend/model/inventory.dart';
import 'package:frontend/view_model/inventory_vm.dart';
import 'package:frontend/view_model/meal_vm.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

class AddMealScreen extends StatefulWidget {
  const AddMealScreen({super.key});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  String selectedMeal = '아침';
  List<Inventory> selectedFoods = [];

  final TextEditingController hourController = TextEditingController();
  final TextEditingController minuteController = TextEditingController();

  // 음식별 수량 저장: foodId -> TextEditingController
  final Map<int, TextEditingController> quantityControllers = {};

  MealVM mealViewModel = MealVM();
  InventoryVM inventoryVM = InventoryVM();

  int totalCalories = 0;
  int totalCarbs = 0;
  int totalProtein = 0;
  int totalFat = 0;

  @override
  void dispose() {
    hourController.dispose();
    minuteController.dispose();
    for (final controller in quantityControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateQuantityControllers() {
    // 선택된 음식에 대해 컨트롤러 생성 및 초기값 1 세팅
    for (var food in selectedFoods) {
      if (!quantityControllers.containsKey(food.foodId)) {
        quantityControllers[food.foodId] = TextEditingController(text: '1');
      }
    }
    // 선택에서 빠진 음식 컨트롤러는 dispose 후 삭제
    final keysToRemove = quantityControllers.keys
        .where((key) => !selectedFoods.any((f) => f.foodId == key))
        .toList();
    for (var key in keysToRemove) {
      quantityControllers[key]?.dispose();
      quantityControllers.remove(key);
    }
  }

  Widget buildAddMealButton(String label) {
    final isSelected = selectedMeal == label;
    log('Selected meal: $selectedMeal, Button label: $label');
    return Expanded(
      child: OutlinedButton(
        onPressed: () => setState(() => selectedMeal = label),
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? const Color(0xFFE6F1D8) : Colors.white,
          side: const BorderSide(color: Colors.green),
        ),
        child: Text(label,
            style: TextStyle(
              color: Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Inventory>>(
      future: inventoryVM.getInventory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('오류 발생: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('재고가 없습니다.'));
        }

        final foodList = snapshot.data!;
        _updateQuantityControllers();

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green[50],
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.green[700],
              onPressed: () {
                context.pop();
              },
            ),
            title: Text(
              '식단 추가',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Colors.green[700],
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Row(
                  children: [
                    buildAddMealButton('아침'),
                    const SizedBox(width: 8),
                    buildAddMealButton('점심'),
                    const SizedBox(width: 8),
                    buildAddMealButton('저녁'),
                  ],
                ),
                const SizedBox(height: 24),
                MultiSelectDialogField<Inventory>(
                  items: foodList
                      .map((food) =>
                          MultiSelectItem<Inventory>(food, food.foodName))
                      .toList(),
                  title: const Text(
                    "음식 선택",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  buttonText: const Text("음식 선택"),
                  listType: MultiSelectListType.CHIP,
                  onConfirm: (values) {
                    setState(() {
                      selectedFoods = values;
                    });
                  },
                  initialValue: selectedFoods,
                ),
                const SizedBox(height: 24),
                const Text(
                  '선택한 음식',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Column(
                  children: selectedFoods.map((food) {
                    final controller = quantityControllers[food.foodId]!;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(child: Text(food.foodName)),
                          SizedBox(
                            width: 80,
                            child: TextField(
                              controller: controller,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: '수량',
                                isDense: true,
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                              ),
                              onChanged: (value) {
                                int q = int.tryParse(value) ?? 1;
                                if (q < 1) q = 1;
                                setState(() {
                                  controller.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset: controller.text.length));
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                const Text(
                  '시간',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) {
                      setState(() {
                        hourController.text =
                            picked.hour.toString().padLeft(2, '0');
                        minuteController.text =
                            picked.minute.toString().padLeft(2, '0');
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 50,
                          child: Center(
                            child: TextField(
                              controller: hourController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(hintText: '시'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text('시 :'),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 60,
                          child: Center(
                            child: TextField(
                              controller: minuteController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(hintText: '분'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('분  '),
                        const Icon(Icons.access_time),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Card(
                //   elevation: 2,
                //   child: Padding(
                //     padding: const EdgeInsets.all(12),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         const Text(
                //           "총 영양 성분",
                //           style: TextStyle(
                //               fontSize: 17, fontWeight: FontWeight.bold),
                //         ),
                //         const SizedBox(height: 8),
                //         Text("칼로리: $totalCalories kcal",
                //             style: TextStyle(
                //                 fontSize: 16,
                //                 fontWeight: FontWeight.bold,
                //                 color: Colors.grey[700])),
                //         Text("탄수화물: $totalCarbs g",
                //             style: const TextStyle(fontSize: 16)),
                //         Text("단백질: $totalProtein g",
                //             style: const TextStyle(fontSize: 16)),
                //         Text("지방: $totalFat g",
                //             style: const TextStyle(fontSize: 16)),
                //       ],
                //     ),
                //   ),
                // ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (selectedFoods.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('오류'),
                          content: const Text('음식을 선택해주세요.'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('확인'),
                            )
                          ],
                        ),
                      );
                      return;
                    }
                    final hour = int.tryParse(hourController.text) ?? 0;
                    final minute = int.tryParse(minuteController.text) ?? 0;
                    final mealDateTime = DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                      hour,
                      minute,
                    );

                    List<Map<String, dynamic>> items = selectedFoods
                        .map((food) => {
                              'food_id': food.foodId,
                              'quantity': int.tryParse(
                                      quantityControllers[food.foodId]?.text ??
                                          '1') ??
                                  1,
                            })
                        .toList();
                    log('Selected meal: $selectedMeal');
                    final responseCode = await mealViewModel.createMeal(
                      selectedMeal,
                      mealDateTime,
                      items,
                    );

                    if (responseCode == 200) {
                      showResponseDialog(context, 200, "모든 식단이 성공적으로 추가되었습니다.");
                    } else {
                      showResponseDialog(
                          context, responseCode, "식단 추가 중 오류가 발생했습니다.");
                    }
                  },
                  icon: const Icon(Icons.edit_note),
                  label: const Text('식단 등록하기'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA4D18D),
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
