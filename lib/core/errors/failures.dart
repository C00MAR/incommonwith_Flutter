/// Classe de base pour représenter les échecs (failures)
///
/// Utilisée pour gérer les erreurs de manière typée dans la couche domaine.
/// Préférer les failures aux exceptions pour un meilleur contrôle du flux.
abstract class Failure {
  /// Message d'erreur descriptif
  final String message;

  /// Code d'erreur optionnel
  final String? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'Failure(message: $message, code: $code)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Failure && other.message == message && other.code == code;
  }

  @override
  int get hashCode => message.hashCode ^ code.hashCode;
}

/// Échec lié au réseau
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'Erreur de connexion réseau',
    super.code,
  });
}

/// Échec lié au serveur
class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'Erreur serveur',
    super.code,
  });
}

/// Échec lié au cache/stockage local
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Erreur de cache',
    super.code,
  });
}

/// Échec d'authentification
class AuthenticationFailure extends Failure {
  const AuthenticationFailure({
    super.message = 'Erreur d\'authentification',
    super.code,
  });
}

/// Échec de validation
class ValidationFailure extends Failure {
  const ValidationFailure({
    super.message = 'Erreur de validation',
    super.code,
  });
}

/// Échec de parsing/sérialisation
class ParsingFailure extends Failure {
  const ParsingFailure({
    super.message = 'Erreur de parsing des données',
    super.code,
  });
}

/// Échec pour ressource non trouvée
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'Ressource non trouvée',
    super.code,
  });
}

/// Échec pour permission refusée
class PermissionFailure extends Failure {
  const PermissionFailure({
    super.message = 'Permission refusée',
    super.code,
  });
}

/// Échec inconnu ou non catégorisé
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'Une erreur inconnue est survenue',
    super.code,
  });
}
