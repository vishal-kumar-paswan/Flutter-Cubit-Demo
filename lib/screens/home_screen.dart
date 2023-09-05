import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_tutorial/cubits/internet_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: BlocConsumer<InternetCubit, InternetState>(
        listener: (context, state) {
          if (state == InternetState.gained) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Connected'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state == InternetState.lost) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Not Connected'),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state == InternetState.gained) {
            return const Text('Connected!');
          } else if (state == InternetState.lost) {
            return const Text('Not Connected!');
          } else {
            return const Text('Loading');
          }
        },
      )),
    );
  }
}
