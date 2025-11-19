/// Classe de base pour les exceptions personnalisées
///
/// Utilisée dans la couche data pour gérer les erreurs techniques.
/// Convertie en Failure dans la couche domaine.
abstract class AppException implements Exception {
  /// Message d'erreur descriptif
  final String message;

  /// Code d'erreur optionnel
  final String? code;

  const AppException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'AppException(message: $message, code: $code)';
}

/// Exception réseau (pas de connexion, timeout, etc.)
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'Erreur de connexion réseau',
    super.code,
  });
}

/// Exception serveur (500, 502, etc.)
class ServerException extends AppException {
  const ServerException({
    super.message = 'Erreur serveur',
    super.code,
  });
}

/// Exception cache (erreur de lecture/écriture local)
class CacheException extends AppException {
  const CacheException({
    super.message = 'Erreur de cache',
    super.code,
  });
}

/// Exception d'authentification
class AuthenticationException extends AppException {
  const AuthenticationException({
    super.message = 'Erreur d\'authentification',
    super.code,
  });
}

/// Exception de validation
class ValidationException extends AppException {
  const ValidationException({
    super.message = 'Erreur de validation',
    super.code,
  });
}

/// Exception de parsing
class ParsingException extends AppException {
  const ParsingException({
    super.message = 'Erreur de parsing des données',
    super.code,
  });
}

/// Exception pour ressource non trouvée (404)
class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'Ressource non trouvée',
    super.code,
  });
}

/// Exception pour permission refusée (403)
class PermissionException extends AppException {
  const PermissionException({
    super.message = 'Permission refusée',
    super.code,
  });
}

/// Exception pour requête invalide (400)
class BadRequestException extends AppException {
  const BadRequestException({
    super.message = 'Requête invalide',
    super.code,
  });
}

/// Exception pour timeout
class TimeoutException extends AppException {
  const TimeoutException({
    super.message = 'La requête a expiré',
    super.code,
  });
}

/// Exception inconnue
class UnknownException extends AppException {
  const UnknownException({
    super.message = 'Une erreur inconnue est survenue',
    super.code,
  });
}
