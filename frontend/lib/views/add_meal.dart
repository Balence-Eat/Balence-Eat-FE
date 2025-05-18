import 'package:flutter/material.dart';
import 'package:frontend/common/error_dialog.dart';
import 'package:frontend/common/success_dialog.dart';
import 'package:frontend/model/meal.dart';
import 'package:frontend/model/meal_food.dart';
import 'package:frontend/view_model/meal_view_model.dart';

class AddMealScreen extends StatefulWidget {
  const AddMealScreen({super.key});

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  String selectedMeal = '아침';
  final TextEditingController foodController = TextEditingController();
  final TextEditingController hourController = TextEditingController();
  final TextEditingController minuteController = TextEditingController();
  final TextEditingController kcalController = TextEditingController();
  final TextEditingController carbController = TextEditingController();
  final TextEditingController proteinController = TextEditingController();

  MealViewModel mealViewModel = MealViewModel();

  @override
  void dispose() {
    foodController.dispose();
    hourController.dispose();
    minuteController.dispose();
    kcalController.dispose();
    carbController.dispose();
    proteinController.dispose();
    super.dispose();
  }

  Widget buildAddMealButton(String label) {
    final isSelected = selectedMeal == label;
    return Expanded(
      child: OutlinedButton(
        onPressed: () => setState(() => selectedMeal = label),
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? Color(0xFFE6F1D8) : Colors.white,
          side: BorderSide(color: Colors.green),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('식단 추가',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.green[150],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            const SizedBox(height: 16),
            // Row(
            //   children: [
            //     Container(
            //       width: 80,
            //       height: 80,
            //       decoration: BoxDecoration(
            //         border: Border.all(color: Colors.green),
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //       child: const Icon(Icons.add_a_photo, size: 32),
            //     ),
            //     const SizedBox(width: 8),
            //   ],
            // ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: foodController,
                    decoration: const InputDecoration(labelText: '먹은 음식'),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.search),
              ],
            ),
            const SizedBox(height: 16),
            const Text('시간'),
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
                    const Text(':'),
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
                    const Icon(Icons.access_time),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: kcalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '칼로리 (kcal)'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: carbController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '탄수화물 (g)'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: proteinController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: '단백질 (g)'),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () async {
                final DateTime mealDateTime = DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  int.parse(hourController.text),
                  int.parse(minuteController.text),
                );

                final meal = Meal(
                  userId: 0, // or omit if managed by backend
                  mealId: 0, // placeholder
                  mealType: selectedMeal,
                  date: mealDateTime,
                  foods: [
                    MealFood(
                      id: 0,
                      title: foodController.text,
                      quantity: 1,
                      calories: int.tryParse(kcalController.text) ?? 0,
                      carbs: int.tryParse(carbController.text) ?? 0,
                      protein: int.tryParse(proteinController.text) ?? 0,
                      fat: 0,
                    ),
                  ],
                );
                final success = await mealViewModel.createMeal(meal);
                if (success) {
                  SuccessDialog.show(
                    context,
                    title: '식단 추가 성공',
                    content: '식단이 성공적으로 추가되었습니다.',
                  );
                  Navigator.of(context).pop();
                } else {
                  ErrorDialog.show(
                    context,
                    title: '식단 추가 실패',
                    content: '식단 추가에 실패했습니다. 다시 시도하세요.',
                  );
                }
              },
              icon: const Icon(Icons.edit_note),
              label: const Text('식단 추가하기'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA4D18D),
                minimumSize: const Size.fromHeight(48),
              ),
            )
          ],
        ),
      ),
    );
  }
}
