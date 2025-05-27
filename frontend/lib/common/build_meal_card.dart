import 'package:flutter/material.dart';
import 'package:frontend/model/meal_food.dart';

Widget buildMealCard(
  String mealType,
  List<dynamic>? foods,
  String? time,
  String? calorie, {
  String? placeholder,
}) {
  final bool isEmpty = foods == null || foods.isEmpty;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        mealType,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 6),
      Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: isEmpty
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      placeholder ?? '오늘의 $mealType 식사를 기록하세요',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(width: 60),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 음식 리스트를 쉼표로 구분하여 나열
                        Text(
                          foods.map((food) {
                            if (food is Map && food.containsKey('foodName')) {
                              return food['foodName'];
                            } else if (food is MealFood) {
                              return food.foodName ?? '이름 없음';
                            }
                            return food.toString();
                          }).join(', '),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (time != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (calorie != null)
                    Text(
                      calorie,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.green,
                      ),
                    ),
                  if (calorie == null) const SizedBox(width: 60),
                ],
              ),
      ),
    ],
  );
}
