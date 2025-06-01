import 'package:flutter/material.dart';
import 'package:frontend/common/bottom_navigation_bar.dart';
import 'package:frontend/common/build_meal_card.dart';
import 'package:frontend/model/meal.dart';
import 'package:frontend/view_model/meal_vm.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();
  MealVM mealVM = MealVM();

  Future<List<Meal>?> _fetchMealWithDate(DateTime date) async {
    List<Meal> meals = await mealVM.fetchMealDate(date);
    if (meals.isEmpty) {
      return [];
    }
    return meals;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFFB8E986),
              onPrimary: Colors.black,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF66BB6A),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Widget mealCardOrPlaceholder(Meal? meal, String type) {
    if (meal == null || meal.mealFoods == null || meal.mealFoods!.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '$type 식사는 등록된 식단이 없습니다.',
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    final timeStr = "${meal.datetime.hour}시 ${meal.datetime.minute}분";
    return buildMealCard(
      type,
      meal.mealFoods,
      timeStr,
    );
  }

  @override
  Widget build(BuildContext context) {
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
          '식단 기록',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.green[700],
          ),
        ),
      ),
      body: FutureBuilder<List<Meal>?>(
        future: _fetchMealWithDate(selectedDate),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('식단을 불러오는 중 오류가 발생했습니다.'));
          }

          final meals = snapshot.data!;
          Meal? breakfast;
          try {
            breakfast = meals.firstWhere(
              (m) => m.mealType.toString().contains('아침'),
            );
          } catch (e) {
            breakfast = null;
          }

          Meal? lunch;
          try {
            lunch = meals.firstWhere(
              (m) => m.mealType.toString().contains('점심'),
            );
          } catch (e) {
            lunch = null;
          }

          Meal? dinner;
          try {
            final dinnerList = meals
                .where(
                  (m) => m.mealType.toString().toLowerCase().contains('저녁'),
                )
                .toList();
            dinner = dinnerList.isNotEmpty ? dinnerList.first : null;
          } catch (e) {
            dinner = null;
          }

          final selectedMeals =
              [breakfast, lunch, dinner].whereType<Meal>().toList();

          double totalCalories = selectedMeals.fold(
              0, (sum, meal) => sum + (meal.totalCalories ?? 0));
          double totalProtein = selectedMeals.fold(
              0, (sum, meal) => sum + (meal.totalProtein ?? 0));
          double totalCarbs = selectedMeals.fold(
              0, (sum, meal) => sum + (meal.totalCarbs ?? 0));
          double totalFat =
              selectedMeals.fold(0, (sum, meal) => sum + (meal.totalFat ?? 0));

          return Column(
            children: [
              Container(
                color: const Color(0xFFE6F1D8),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDate =
                              selectedDate.subtract(const Duration(days: 1));
                        });
                      },
                      child: const Icon(Icons.chevron_left),
                    ),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Row(
                        children: [
                          Text(
                            selectedDate.year == DateTime.now().year &&
                                    selectedDate.month ==
                                        DateTime.now().month &&
                                    selectedDate.day == DateTime.now().day
                                ? '${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일 (오늘)'
                                : '${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.green[700],
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.calendar_today,
                              size: 18, color: Colors.green[700]),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (selectedDate.isBefore(DateTime(DateTime.now().year,
                            DateTime.now().month, DateTime.now().day))) {
                          setState(() {
                            selectedDate =
                                selectedDate.add(const Duration(days: 1));
                          });
                        }
                      },
                      child: Icon(
                        Icons.chevron_right,
                        color: selectedDate.isBefore(DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day))
                            ? Colors.black
                            : Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    mealCardOrPlaceholder(breakfast, '아침'),
                    const SizedBox(height: 16),
                    mealCardOrPlaceholder(lunch, '점심'),
                    const SizedBox(height: 16),
                    mealCardOrPlaceholder(dinner, '저녁'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('총 섭취 영양성분',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('칼로리',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[700])),
                                  Text(
                                      '${totalCalories.toStringAsFixed(1)} kcal',
                                      style: const TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('단백질',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[700])),
                                  Text('${totalProtein.toStringAsFixed(1)} g',
                                      style: const TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('탄수화물',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[700])),
                                  Text('${totalCarbs.toStringAsFixed(1)} g',
                                      style: const TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('지방',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[700])),
                                  Text('${totalFat.toStringAsFixed(1)} g',
                                      style: const TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA4D18D),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 14),
                  ),
                  icon: const Icon(Icons.edit_note),
                  label: const Text('식단 추가하기',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  onPressed: () {
                    context.push('/add-meal');
                  },
                ),
              )
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: 0,
      ),
    );
  }
}
