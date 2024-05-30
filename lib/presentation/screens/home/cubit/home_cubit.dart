import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:water_drink_reminder/core/constants.dart';
import 'package:water_drink_reminder/domain/entities/user.dart';
import 'package:water_drink_reminder/domain/firebase_notification.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._fCM) : super(HomeInitial());

  final FireBaseNotofication _fCM;
  final _box = Hive.openBox(userBox);

  Future<void> disableNotification() async {
    await _fCM.disableAllNotification();
  }

  Future<void> saveUserProgress(User user) async {
    final drinkedValue = user.drinkedValue += user.selectedLites ~/ 10;
    final waterProgressValue = user.waterProgressValue += 0.1;
    final drinkedTime = user.drinkedTime;
    drinkedTime.add(DateTime.now());

    user.copyWith(
        drinkedValue: drinkedValue,
        waterProgressValue: waterProgressValue,
        drinkedTime: drinkedTime);
    emit(HomeLoaded(user: user));
    (await _box).put(boxKey, user);
  }

  Future<void> readData() async {
    final user = (await _box).get(boxKey);
    emit(HomeLoaded(
        user: user ??
            User(
                waterProgressValue: 0.0,
                drinkedValue: 0,
                drinkedTime: [],
                selectedLites: 0)));
  }

  Future<void> dispose() async {
    (await _box).close();
  }

  Future<void> clearBox() async {
    (await _box).clear();
  }
}
