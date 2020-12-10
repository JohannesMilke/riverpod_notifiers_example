import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:riverpod_notifiers_example/widget/button_widget.dart';
import 'package:riverpod_notifiers_example/widget/text_widget.dart';

class Car {
  final int speed;
  final int doors;

  const Car({
    this.speed = 120,
    this.doors = 4,
  });

  Car copy({
    int speed,
    int doors,
  }) =>
      Car(
        speed: speed ?? this.speed,
        doors: doors ?? this.doors,
      );
}

class CarNotifier extends StateNotifier<Car> {
  CarNotifier() : super(Car());

  void setDoors(int doors) {
    final newState = state.copy(doors: doors);
    state = newState;
  }

  void increaseSpeed() {
    final speed = state.speed + 5;
    final newState = state.copy(speed: speed);
    state = newState;
  }

  void hitBrake() {
    final speed = max(0, state.speed - 30);
    final newState = state.copy(speed: speed);
    state = newState;
  }

  // @override
  // void dispose() {}
}

final stateNotifierProvider =
    StateNotifierProvider<CarNotifier>((ref) => CarNotifier());

class StateNotifierPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    final car = watch(stateNotifierProvider.state);
    final speed = car.speed;
    final doors = car.doors;

    final carNotifier = watch(stateNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('StateNotifierProvider'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWidget('Speed: $speed'),
            const SizedBox(height: 8),
            TextWidget('Doors: $doors'),
            const SizedBox(height: 32),
            buildButtons(watch),
            const SizedBox(height: 32),
            Slider(
              value: car.doors.toDouble(),
              max: 5,
              onChanged: (value) => carNotifier.setDoors(value.toInt()),
            )
          ],
        ),
      ),
    );
  }

  Widget buildButtons(watch) {
    final carNotifier = watch(stateNotifierProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ButtonWidget(text: 'Increase +5', onClicked: carNotifier.increaseSpeed),
        const SizedBox(width: 12),
        ButtonWidget(text: 'Hit Brake -30', onClicked: carNotifier.hitBrake),
      ],
    );
  }
}
