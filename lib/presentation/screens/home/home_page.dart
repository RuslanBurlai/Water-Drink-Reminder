import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_drink_reminder/domain/firebase_notification.dart';
import 'package:water_drink_reminder/presentation/screens/home/cubit/home_cubit.dart';
import 'package:water_drink_reminder/presentation/screens/home/home_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, this.payload = ''});
  final String payload;

  @override
  Widget build(BuildContext context) {
    final fbn = FireBaseNotofication();
    return BlocProvider(create: (_) => HomeCubit(fbn),
    child: HomeView(payload: payload));
  }
}