import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/table_result.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 800,
      child: Column(
        children: const [
          Text('Rozgrywki Mundial 2022',
              style: TextStyle(
                  fontSize: 64,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 48),
          TableResult(),
        ],
      ),
    );
  }
}
