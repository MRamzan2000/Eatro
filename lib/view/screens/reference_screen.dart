import 'package:flutter/material.dart';

class ReferenceScreen extends StatefulWidget {
  const ReferenceScreen({super.key});

  @override
  State<ReferenceScreen> createState() => ReferenceScreenState();
}

class ReferenceScreenState extends State<ReferenceScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("ReferenceScreen"),
      ),
    );
  }
}
