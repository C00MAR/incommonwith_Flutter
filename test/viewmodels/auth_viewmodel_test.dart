import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:incommonwith_flutter/presentation/viewmodels/auth_viewmodel.dart';

// Générer les mocks avec : flutter pub run build_runner build
@GenerateMocks([FirebaseAuth, User, UserCredential])
import 'auth_viewmodel_test.mocks.dart';

void main() {
  late AuthViewModel viewModel;
  late MockFirebaseAuth mockAuth;
  late MockUser mockUser;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    mockUser = MockUser();

    // Mock authStateChanges to return an empty stream
    when(mockAuth.authStateChanges()).thenAnswer((_) => Stream.value(null));

    viewModel = AuthViewModel(auth: mockAuth);
  });

  group('AuthViewModel Tests', () {
    test('signInWithEmail devrait authentifier utilisateur valide', () async {
      // Arrange
      final mockCredential = MockUserCredential();
      when(mockAuth.signInWithEmailAndPassword(
        email: 'test@test.com',
        password: 'password123',
      )).thenAnswer((_) async => mockCredential);
      when(mockCredential.user).thenReturn(mockUser);
      when(mockUser.email).thenReturn('test@test.com');
      when(mockAuth.currentUser).thenReturn(mockUser);

      // Act
      await viewModel.signInWithEmail('test@test.com', 'password123');

      // Assert
      expect(viewModel.errorMessage, isEmpty);
      expect(viewModel.hasError, isFalse);
      verify(mockAuth.signInWithEmailAndPassword(
        email: 'test@test.com',
        password: 'password123',
      )).called(1);
    });

    test('signInWithEmail devrait échouer avec mauvais password', () async {
      // Arrange
      when(mockAuth.currentUser).thenReturn(null);
      when(mockAuth.signInWithEmailAndPassword(
        email: 'test@test.com',
        password: 'wrongpassword',
      )).thenThrow(FirebaseAuthException(code: 'wrong-password'));

      // Act
      await viewModel.signInWithEmail('test@test.com', 'wrongpassword');

      // Assert
      expect(viewModel.hasError, isTrue);
      expect(viewModel.errorMessage, contains('Mot de passe incorrect'));
      expect(viewModel.currentUser, isNull);
    });

    test('registerWithEmail devrait créer un nouveau compte', () async {
      // Arrange
      final mockCredential = MockUserCredential();
      when(mockAuth.createUserWithEmailAndPassword(
        email: 'new@test.com',
        password: 'password123',
      )).thenAnswer((_) async => mockCredential);
      when(mockCredential.user).thenReturn(mockUser);
      when(mockAuth.currentUser).thenReturn(mockUser);

      // Act
      await viewModel.registerWithEmail('new@test.com', 'password123');

      // Assert
      expect(viewModel.errorMessage, isEmpty);
      expect(viewModel.hasError, isFalse);
      verify(mockAuth.createUserWithEmailAndPassword(
        email: 'new@test.com',
        password: 'password123',
      )).called(1);
    });
  });
}
