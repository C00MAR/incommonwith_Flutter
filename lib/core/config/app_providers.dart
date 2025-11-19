import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../features/catalog/data/repositories/catalog_repository_impl.dart';
import '../../features/catalog/domain/repositories/catalog_repository.dart';
import '../../features/catalog/domain/usecases/get_products_usecase.dart';
import '../../features/catalog/domain/usecases/search_products_usecase.dart';
import '../../features/catalog/presentation/viewmodels/catalog_viewmodel.dart';
import '../constants/app_constants.dart';

/// Configuration des Providers de l'application
///
/// Centralise la configuration de l'injection de dépendances
/// avec Provider/MultiProvider.
class AppProviders {
  // Constructeur privé pour empêcher l'instanciation
  AppProviders._();

  /// Retourne la liste de tous les providers de l'application
  ///
  /// Organisés par couche (data, domain, presentation) et par feature.
  static List<SingleChildWidget> getProviders() {
    return [
      // ==========================================
      // COUCHE DATA - Repositories
      // ==========================================

      // HTTP Client (partagé entre tous les repositories)
      Provider<http.Client>(
        create: (_) => http.Client(),
        dispose: (_, client) => client.close(),
      ),

      // Catalog Repository
      ProxyProvider<http.Client, CatalogRepository>(
        update: (_, client, __) => CatalogRepositoryImpl(
          client: client,
          baseUrl: AppConstants.apiBaseUrl,
        ),
        dispose: (_, repository) {
          if (repository is CatalogRepositoryImpl) {
            repository.dispose();
          }
        },
      ),

      // TODO: Ajouter les autres repositories (Auth, Cart, Orders, etc.)

      // ==========================================
      // COUCHE DOMAIN - Use Cases
      // ==========================================

      // Catalog Use Cases
      ProxyProvider<CatalogRepository, GetProductsUseCase>(
        update: (_, repository, __) => GetProductsUseCase(repository),
      ),

      ProxyProvider<CatalogRepository, SearchProductsUseCase>(
        update: (_, repository, __) => SearchProductsUseCase(repository),
      ),

      // TODO: Ajouter les autres use cases

      // ==========================================
      // COUCHE PRESENTATION - ViewModels
      // ==========================================

      // Catalog ViewModel
      ChangeNotifierProxyProvider2<GetProductsUseCase, SearchProductsUseCase,
          CatalogViewModel>(
        create: (_) => CatalogViewModel(
          getProductsUseCase: GetProductsUseCase(
            CatalogRepositoryImpl(
              client: http.Client(),
              baseUrl: AppConstants.apiBaseUrl,
            ),
          ),
          searchProductsUseCase: SearchProductsUseCase(
            CatalogRepositoryImpl(
              client: http.Client(),
              baseUrl: AppConstants.apiBaseUrl,
            ),
          ),
        ),
        update: (_, getProductsUseCase, searchProductsUseCase, previous) =>
            previous ??
            CatalogViewModel(
              getProductsUseCase: getProductsUseCase,
              searchProductsUseCase: searchProductsUseCase,
            ),
      ),

      // TODO: Ajouter les autres ViewModels (Auth, Cart, Orders, etc.)
    ];
  }
}
