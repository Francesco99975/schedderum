import 'package:flutter/material.dart';

class EmptyListMessage extends StatelessWidget {
  final String message;
  final IconData iconData;

  const EmptyListMessage({
    super.key,
    required this.message,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
