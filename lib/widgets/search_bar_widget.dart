import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSubmitted;
  final VoidCallback onLocationPressed;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onSubmitted,
    required this.onLocationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter city name...',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.grey),
            ),
            style: const TextStyle(color: Colors.black),
            onSubmitted: (value) {
              onSubmitted(value);
              controller.clear();
            },
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: onLocationPressed,
          icon: const Icon(Icons.my_location, color: Colors.black),
          tooltip: 'Use current location',
        ),
      ],
    );
  }
}
