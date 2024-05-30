import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_drink_reminder/domain/firebase_notification.dart';
import 'package:water_drink_reminder/presentation/screens/login/cubit/login_cubit.dart';
import 'package:water_drink_reminder/presentation/screens/login/login_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(fireBaseNotofication: context.read<FireBaseNotofication>()),
      child: const LoginView(),
    );
  }
}
