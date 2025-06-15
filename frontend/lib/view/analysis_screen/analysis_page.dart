import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:frontend/common/bottom_navigation_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/service/token_storage.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  DateTime selectedDate = DateTime.now();
  String? _recommendationText;
  bool _isLoadingRecommendation = false;

  @override
  void initState() {
    super.initState();
    _fetchRecommendation();
  }

  Future<void> _fetchRecommendation() async {
  setState(() {
    _isLoadingRecommendation = true;
  });

  try {
    final token = await TokenStorage.load(); // 🔐 토큰 불러오기
    if (token == null) {
      setState(() {
        _recommendationText = '로그인이 필요합니다 (토큰 없음)';
      });
      return;
    }

    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/ai-diet'),
      headers: {
        'Authorization': 'Bearer $token', // ✅ 인증 헤더 추가
        'Content-Type': 'application/json',
      },
    ).timeout(const Duration(seconds: 20));

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      setState(() {
        _recommendationText = data['recommendation'];
      });
    } else {
      setState(() {
        _recommendationText = '추천을 불러오지 못했습니다 (${response.statusCode})';
      });
    }
  } catch (e) {
    setState(() {
      _recommendationText = '에러 발생: $e';
    });
  } finally {
    setState(() {
      _isLoadingRecommendation = false;
    });
  }
}

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFB8E986),
              onPrimary: Colors.black,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Color(0xFF66BB6A)),
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

  String _formattedDate(DateTime date) {
    final today = DateTime.now();
    final isToday = date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;

    return isToday
        ? '${date.year}년 ${date.month}월 ${date.day}일 (오늘)'
        : '${date.year}년 ${date.month}월 ${date.day}일';
  }

  @override
  Widget build(BuildContext context) {
    const limeGreen = Color(0xFFB9F73E);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[50],
        elevation: 0,
        title: Text(
          '식단 분석',
          style: TextStyle(
            color: Colors.green[700],
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.green[700]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.chevron_left),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _selectDate,
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        _formattedDate(selectedDate),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.chevron_right),
              ],
            ),
            const SizedBox(height: 24),
            _buildBarChart(),
            const SizedBox(height: 16),
            const Text("목표 섭취 칼로리 : 2,400kcal",
                style: TextStyle(fontSize: 16)),
            const Text("총 섭취 칼로리 : 1,100kcal",
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 24),
            const Text("AI 식단 추천 🌱",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (_isLoadingRecommendation)
              const CircularProgressIndicator()
            else if (_recommendationText != null)
              Text(
                _recommendationText!,
                style: const TextStyle(fontSize: 16),
              )
            else
              const Text('추천을 불러오지 못했습니다.'),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(currentIndex: 1),
    );
  }

  Widget _buildBarChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [
                    BarChartRodData(toY: 50, color: Colors.redAccent),
                  ]),
                  BarChartGroupData(x: 1, barRods: [
                    BarChartRodData(toY: 20, color: Colors.orange),
                  ]),
                  BarChartGroupData(x: 2, barRods: [
                    BarChartRodData(toY: 30, color: Colors.green),
                  ]),
                ],
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        switch (value.toInt()) {
                          case 0:
                            return const Text("탄수화물");
                          case 1:
                            return const Text("단백질");
                          case 2:
                            return const Text("지방");
                          default:
                            return const Text("");
                        }
                      },
                    ),
                  ),
                  leftTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
          const SizedBox(height: 16)
        ],
      ),
    );
  }
}