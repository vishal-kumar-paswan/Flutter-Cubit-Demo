## Flutter Internet Connectivity Checker using Flutter Cubit

### How Cubit works?

Unlike a BLoC where we need to add a event everytime to emit a state, a Cubit can emit infinite number of states without adding any event. Here a function triggers behind the scenes to emit a state.

<img src="https://imgur.com/0CcP5vQ.png" height=300>

### Demonstration

#### Step 0

Create a empty Flutter project and add the `flutter_bloc` and `connectivity_plus` package from [pub.dev](https://pub.dev/). Next inside the `lib` folder create a folder named `cubits` which will contain all the cubit files. Inside th folder create two files - `internet_state.dart` and `internet_cubit.dart`.

#### Step 1

Define a State class inside the `internet_state.dart` along with the data members.

```
abstract class InternetState{}

class InternetInitialState extends InternetState {}

class InternetGainedState extends InternetState {}

class InternetLostState extends InternetState {}
```

In some cases you may not have any data members inside your class. In such cases, you can also use `enums` instead of defining empty classes.

```
enum InternetState { initial, lost, gained }
```

#### Step 2

Now inside the `internet_cubit.dart`, we will be creating a class that will be extending the `Cubit`. Alike `Bloc`, `Cubit` is also a generic class and you must specify the type parameters - a `Cubit` only takes one parameter, i.e. the `State`.

```
class InternetCubit extends Cubit<InternetState> {}
```

Next we will be calling the `InternetCubit` constructor and also initialsing the super class, i.e. `Cubit` with the initial state.

```
InternetCubit() : super(InternetState.initial) {}
```

We will be creating a instance of `Connectivity` inside the class and a `StreamSubscription` to listen to the changes in the connectivity.

```
final Connectivity _connectivity = Connectivity();
StreamSubscription? _connectivitySubscription;
```

Now inside the constructor, we will be listening to the changes and emit the states accoring to that.

```
InternetCubit() : super(InternetState.initial) {
_connectivitySubscription =
    _connectivity.onConnectivityChanged.listen((result) {
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
    emit(InternetState.gained);
    } else {
    emit(InternetState.lost);
    }
});
}
```

As we have used the `StreamSubscription`, it is also important to close it in order to avoid memory leak.

```
@override
Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
}
```

#### Step 3

Now wrap the `MaterialApp` with the `BlocProvider` and in the `create` parameter, pass the instance of the `Cubit` class we created before.

```
BlocProvider(
    create: (context) => InternetCubit(),
    child: const MaterialApp(
    home: HomePage(),
    ),
);
```

#### Step 4

Just like `Bloc`, wrap the widgets where you want to manage the states with `BlocBuilder`, `BlocListener` or `BlocConsumer` and replace the `Event` classes with the `Cubit` ones.

```
BlocConsumer<InternetCubit, InternetState>(
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
)
```
