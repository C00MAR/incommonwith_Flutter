import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'core/router.dart';
import 'presentation/viewmodels/auth_viewmodel.dart';
import 'presentation/viewmodels/catalog_viewmodel.dart';
import 'presentation/viewmodels/cart_viewmodel.dart';
import 'presentation/viewmodels/checkout_viewmodel.dart';

const firebaseOptions = FirebaseOptions(
  apiKey: 'AIzaSyDdSnD66BJbRxJmmysBIkwTY9z7WcSjxSI',
  appId: '1:83803930192:web:9feaf14d7659062294db55',
  messagingSenderId: '83803930192',
  projectId: 'incommonwith-flutter',
  authDomain: 'incommonwith-flutter.firebaseapp.com',
  storageBucket: 'incommonwith-flutter.firebasestorage.app',
  measurementId: 'G-HL0C5FB4SQ',
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseOptions);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AuthViewModel _authViewModel;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authViewModel = AuthViewModel();
    _router = createRouter(_authViewModel);
  }

  @override
  void dispose() {
    _authViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _authViewModel),
        ChangeNotifierProvider(create: (_) => CatalogViewModel()),
        ChangeNotifierProvider(create: (_) => CartViewModel()),
        ChangeNotifierProvider(create: (_) => CheckoutViewModel()),
      ],
      child: MaterialApp.router(
        title: 'InCommonWith',
        theme: ThemeData(fontFamily: 'Mier'),
        routerConfig: _router,
      ),
    );
  }
}
