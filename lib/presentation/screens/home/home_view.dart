import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:water_drink_reminder/presentation/screens/home/cubit/home_cubit.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, this.payload = ''});
  final String payload;

  @override
  State<HomeView> createState() => _MyHomeViewState();
}

class _MyHomeViewState extends State<HomeView> {
  @override
  void initState() {
    context.read<HomeCubit>().readData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Progress page'),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            itemBuilder: (contex) {
              return [
                PopupMenuItem<String>(
                  value: 'signOut',
                  child: const Text('Disable notification'),
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Do you really want to stop?'),
                          content: const Text(
                              'The whole process will have to start over.'),
                          actions: [
                            TextButton(
                                child: const Text('OK'),
                                onPressed: () async {
                                  await context.read<HomeCubit>().clearBox();
                                  await context
                                      .read<HomeCubit>()
                                      .disableNotification();
                                  Navigator.pop(contex);
                                  await Navigator.pushReplacementNamed(
                                      context, '/');
                                }),
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () async {
                                Navigator.pop(contex);
                              },
                            )
                          ],
                        );
                      },
                    );
                  },
                )
              ];
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                      widget.payload.isEmpty
                          ? 'When a notification comes, drink water.'
                          : widget.payload,
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center),
                  const SizedBox(
                    height: 12,
                  ),
                  BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) => InkWell(
                            borderRadius: BorderRadius.circular(80),
                            onTap: state is HomeLoaded &&
                                    state.user.drinkedValue <
                                        state.user.selectedLites
                                ? () {
                                    context
                                        .read<HomeCubit>()
                                        .saveUserProgress(state.user);
                                  }
                                : null,
                            child: SizedBox(
                                height: 160,
                                width: 160,
                                child: CircularProgressIndicator(
                                  strokeWidth: 10,
                                  value: state is HomeLoaded
                                      ? state.user.waterProgressValue
                                      : 0.0,
                                  backgroundColor: Colors.grey,
                                  color: Colors.green[600],
                                  strokeCap: StrokeCap.round,
                                )),
                          )),
                  const SizedBox(
                    height: 12,
                  ),
                  BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      return Text(
                          '${state is HomeLoaded ? state.user.drinkedValue : 0} / ${state is HomeLoaded ? state.user.selectedLites : 0} ml',
                          style: Theme.of(context).textTheme.titleLarge);
                    },
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Expanded(
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  return state is HomeLoaded
                      ? ListView.builder(
                          itemCount: state.user.drinkedTime.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(
                                '${state.user.selectedLites ~/ 10}ml drinked at',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              subtitle: Text(DateFormat.Hm()
                                  .format(state.user.drinkedTime[index])),
                            );
                          })
                      : const SizedBox();
                },
              ),
            ),
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                return state is HomeLoaded &&
                        state.user.drinkedValue >= state.user.selectedLites
                    ? TextButton(
                        onPressed: () async {
                          await context.read<HomeCubit>().clearBox();
                          await context.read<HomeCubit>().disableNotification();
                          await Navigator.pushReplacementNamed(context, '/');
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(26),
                              border: Border.all(
                                  color: Colors.green[600]!, width: 3)),
                          child: Text(
                            'I Did it!',
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(fontSize: 20),
                          ),
                        ),
                      )
                    : const SizedBox();
              },
            )
          ],
        ),
      ),
    );
  }
}
