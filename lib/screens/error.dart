import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final String errorMessage;
  final Function onRetry;
  // final Function onReport;

  const ErrorScreen({
    super.key,
    required this.errorMessage,
    required this.onRetry,
    // required this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: errorWidget(errorMessage, onRetry)));
  }
}

Widget errorWidget(String errorMessage, Function onRetry) => Center(
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, size: 80, color: Colors.red),
        const SizedBox(height: 16),
        const Text(
          'Oops! Something went wrong',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(errorMessage, textAlign: TextAlign.center),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            onRetry();
          },
          child: const Text('Retry'),
        ),
        // const SizedBox(height: 16),
        // ElevatedButton(
        //   onPressed: () {
        //     onReport();
        //   },
        //   child: const Text('Report Error'),
        // ),
      ],
    ),
  ),
);
