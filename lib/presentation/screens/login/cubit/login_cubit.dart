import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:water_drink_reminder/core/constants.dart';
import 'package:water_drink_reminder/domain/entities/user.dart';
import 'package:water_drink_reminder/domain/firebase_notification.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required FireBaseNotofication fireBaseNotofication}) : _fCM = fireBaseNotofication, super(LoginInitial());

   final FireBaseNotofication _fCM;
   final _box = Hive.openBox(userBox);

    void setupNotification(Duration duration, int count) {
    _fCM.scheduledNotification(duration, count);
  }

  Future<void> saveUser(int selectedLites) async {
    final user = User(
        waterProgressValue: 0.0,
        drinkedValue: 0,
        drinkedTime: [],
        selectedLites: selectedLites);
    (await _box).put(boxKey, user);
  }

  Future<bool> requestPermission() async {
    return await Permission.notification.isGranted;
  }

  Future<bool> openSystemSettings() async {
    return await openAppSettings();
  }
}
