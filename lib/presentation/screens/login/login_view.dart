import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:water_drink_reminder/presentation/screens/home/home_page.dart';
import 'package:water_drink_reminder/presentation/screens/login/cubit/login_cubit.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  int _selectedLiters = 1000;
  int _selectedTime = 1;

  void updateSelectedLiters(Set<int> newSelection) {
    _selectedLiters = newSelection.first;
    setState(() {});
  }

  void updateSelectedTime(Set<int> newTimeValue) {
    _selectedTime = newTimeValue.first;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Text(
            'Water reminder',
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 24,
          ),
          Text(
            'How much do you want to drink?',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          SegmentedButton(segments: const [
            ButtonSegment(value: 1000, label: Text('1000 ml')),
            ButtonSegment(value: 1500, label: Text('1500 ml')),
            ButtonSegment(value: 2000, label: Text('2000 ml'))
          ], selected: <int>{
            _selectedLiters
          }, onSelectionChanged: updateSelectedLiters),
          const SizedBox(
            height: 24,
          ),
          Text(
            'Choose the frequency between drinks',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          SegmentedButton(segments: const [
            ButtonSegment(value: 1, label: Text('1 m')),
            ButtonSegment(value: 10, label: Text('10 m')),
            ButtonSegment(value: 30, label: Text('30 m')),
            ButtonSegment(value: 60, label: Text('1 h'))
          ], selected: <int>{
            _selectedTime
          }, onSelectionChanged: updateSelectedTime),
          const Spacer(),
          Center(
              child: Material(
                  child: Text(
            'Drink ${_selectedLiters.toInt() ~/ 10} milliliters of water every $_selectedTime minutes',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w500),
          ))),
          const SizedBox(
            height: 38,
          ),
          TextButton(
            onPressed: () async {
              final isGranted =
                  await context.read<LoginCubit>().requestPermission();
              if (isGranted) {
                context
                    .read<LoginCubit>()
                    .saveUser(_selectedLiters);
                context
                    .read<LoginCubit>()
                    .setupNotification(Duration(minutes: _selectedTime), 10);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Notification permission'),
                      content: const Text(
                          'To use the application, you need to turn on notifications. Do you want to change your settings?'),
                      actions: [
                        TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              context.read<LoginCubit>().openSystemSettings();
                              Navigator.pop(context);
                            }),
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    );
                  },
                );
              }
            },
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  color: Colors.green[600]),
              child: Text(
                'Start',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(fontSize: 20, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
