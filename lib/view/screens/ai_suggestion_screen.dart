import 'package:flutter/material.dart';

class AiSuggestionScreen extends StatefulWidget {
  const AiSuggestionScreen({super.key});

  @override
  State<AiSuggestionScreen> createState() => AiSuggestionScreenState();
}

class AiSuggestionScreenState extends State<AiSuggestionScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("AiSuggestionScreen"),
      ),
    );
  }
}
