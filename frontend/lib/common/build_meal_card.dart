import 'package:flutter/material.dart';

Widget buildMealCard(
  String title,
  String? menu,
  String? time,
  String? kcal, {
  String? image,
  String? placeholder,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green.shade100),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
          ],
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                image: image != null
                    ? DecorationImage(
                        image: AssetImage(image), fit: BoxFit.cover)
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (menu != null && time != null && kcal != null) ...[
                    Text(menu,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(time,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey)),
                  ] else if (placeholder != null) ...[
                    Text(placeholder,
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black54)),
                  ]
                ],
              ),
            ),
            if (kcal != null)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text(kcal, style: const TextStyle(fontSize: 16)),
              ),
          ],
        ),
      ),
    ],
  );
}
