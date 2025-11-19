import '../constants/app_constants.dart';

/// Utilitaires de validation pour les formulaires
///
/// Centralise toutes les fonctions de validation réutilisables
/// dans l'application.
class Validators {
  // Constructeur privé pour empêcher l'instanciation
  Validators._();

  /// Valide une adresse email
  ///
  /// Retourne null si l'email est valide, sinon un message d'erreur.
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'L\'email est requis';
    }

    if (!AppConstants.emailRegex.hasMatch(value)) {
      return 'Email invalide';
    }

    return null;
  }

  /// Valide un mot de passe
  ///
  /// Vérifie la longueur minimale et maximale.
  /// Retourne null si le mot de passe est valide, sinon un message d'erreur.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }

    if (value.length < AppConstants.minPasswordLength) {
      return 'Le mot de passe doit contenir au moins ${AppConstants.minPasswordLength} caractères';
    }

    if (value.length > AppConstants.maxPasswordLength) {
      return 'Le mot de passe ne peut pas dépasser ${AppConstants.maxPasswordLength} caractères';
    }

    return null;
  }

  /// Valide la confirmation du mot de passe
  ///
  /// [password] Le mot de passe original
  /// [confirmPassword] La confirmation du mot de passe
  ///
  /// Retourne null si les mots de passe correspondent, sinon un message d'erreur.
  static String? validatePasswordConfirmation(
    String? password,
    String? confirmPassword,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'La confirmation du mot de passe est requise';
    }

    if (password != confirmPassword) {
      return 'Les mots de passe ne correspondent pas';
    }

    return null;
  }

  /// Valide un nom (prénom, nom de famille, etc.)
  ///
  /// Vérifie la longueur minimale et maximale.
  /// Retourne null si le nom est valide, sinon un message d'erreur.
  static String? validateName(String? value, {String fieldName = 'Ce champ'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName est requis';
    }

    if (value.length < AppConstants.minNameLength) {
      return '$fieldName doit contenir au moins ${AppConstants.minNameLength} caractères';
    }

    if (value.length > AppConstants.maxNameLength) {
      return '$fieldName ne peut pas dépasser ${AppConstants.maxNameLength} caractères';
    }

    return null;
  }

  /// Valide un numéro de téléphone
  ///
  /// Retourne null si le numéro est valide, sinon un message d'erreur.
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le numéro de téléphone est requis';
    }

    if (!AppConstants.phoneRegex.hasMatch(value)) {
      return 'Numéro de téléphone invalide';
    }

    return null;
  }

  /// Valide un champ requis générique
  ///
  /// [value] La valeur à valider
  /// [fieldName] Le nom du champ pour le message d'erreur
  ///
  /// Retourne null si le champ n'est pas vide, sinon un message d'erreur.
  static String? validateRequired(String? value, {String fieldName = 'Ce champ'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName est requis';
    }
    return null;
  }

  /// Valide un montant (prix, total, etc.)
  ///
  /// Vérifie que la valeur est un nombre positif.
  /// Retourne null si le montant est valide, sinon un message d'erreur.
  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le montant est requis';
    }

    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Montant invalide';
    }

    if (amount < 0) {
      return 'Le montant ne peut pas être négatif';
    }

    return null;
  }

  /// Valide une quantité
  ///
  /// Vérifie que la valeur est un nombre entier positif.
  /// Retourne null si la quantité est valide, sinon un message d'erreur.
  static String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'La quantité est requise';
    }

    final quantity = int.tryParse(value);
    if (quantity == null) {
      return 'Quantité invalide';
    }

    if (quantity <= 0) {
      return 'La quantité doit être supérieure à 0';
    }

    return null;
  }

  /// Valide une longueur minimale
  ///
  /// [value] La valeur à valider
  /// [minLength] La longueur minimale requise
  /// [fieldName] Le nom du champ pour le message d'erreur
  ///
  /// Retourne null si la longueur est suffisante, sinon un message d'erreur.
  static String? validateMinLength(
    String? value,
    int minLength, {
    String fieldName = 'Ce champ',
  }) {
    if (value == null || value.isEmpty) {
      return '$fieldName est requis';
    }

    if (value.length < minLength) {
      return '$fieldName doit contenir au moins $minLength caractères';
    }

    return null;
  }

  /// Valide une longueur maximale
  ///
  /// [value] La valeur à valider
  /// [maxLength] La longueur maximale autorisée
  /// [fieldName] Le nom du champ pour le message d'erreur
  ///
  /// Retourne null si la longueur est acceptable, sinon un message d'erreur.
  static String? validateMaxLength(
    String? value,
    int maxLength, {
    String fieldName = 'Ce champ',
  }) {
    if (value != null && value.length > maxLength) {
      return '$fieldName ne peut pas dépasser $maxLength caractères';
    }

    return null;
  }
}
