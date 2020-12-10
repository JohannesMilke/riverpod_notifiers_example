import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:riverpod_notifiers_example/widget/button_widget.dart';
import 'package:riverpod_notifiers_example/widget/text_widget.dart';

class CarNotifier extends ChangeNotifier {
  int _speed = 120;

  void increase() {
    _speed += 5;

    notifyListeners();
  }

  void hitBreak() {
    _speed = max(0, _speed - 30);

    notifyListeners();
  }

  // @override
  // void dispose() {}
}

final carProvider = ChangeNotifierProvider<CarNotifier>((ref) => CarNotifier());

class ChangeNotifierPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    final car = watch(carProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('ChangeNotifierProvider'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWidget('Speed: ${car._speed}'),
            const SizedBox(height: 8),
            buildButtons(context, car),
          ],
        ),
      ),
    );
  }

  Widget buildButtons(BuildContext context, CarNotifier car) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ButtonWidget(
            text: 'Increase +5',
            onClicked: context.read(carProvider).increase,
          ),
          // car.increase: not efficient
          // => button rebuilds everytime if car state changes
          const SizedBox(width: 12),
          ButtonWidget(
            text: 'Hit Brake -30',
            onClicked: context.read(carProvider).hitBreak,
          ),
        ],
      );
}
