# Demo Project — Flutter MVC Boilerplate with GetX

A production-ready Flutter boilerplate using the MVC pattern with GetX for state management, routing, and dependency injection. Designed for fast client project delivery.

## Features

- MVC architecture with GetX
- SharedPreferences-based local storage
- HTTP client with token injection, error parsing, and connectivity checks
- Global loading overlay (prevents duplicate overlays)
- Centralized form validation (BaseValidator)
- Inline pagination pattern (no generic base list controller)
- Light/dark theme switching (persisted)
- Localization: English & Arabic (persisted, RTL-ready)
- Auth middleware route guard
- Environment configuration (Dev / Staging / Prod)

## Folder Structure

```
lib/
  main.dart                                    # App entry point
  app/
    routes/
      app_routes.dart                          # Named route constants
      app_pages.dart                           # GetPage list with bindings
      auth_middleware.dart                      # Token-check route guard
    core/
      config/
        environment.dart                       # Dev/Staging/Prod base URLs
      network/
        api_endpoints.dart                     # Endpoint path constants
        api_exception.dart                     # Typed API exception
        api_response.dart                      # Generic response wrapper
        connectivity_service.dart              # Network connectivity check
        base_api_service.dart                  # Central HTTP client (singleton)
      storage/
        storage_keys.dart                      # SharedPreferences key constants
        storage_service.dart                   # Typed SharedPreferences wrapper
      utils/
        logger.dart                            # Dev-mode logger
        responsive.dart                        # Mobile/tablet helper
      constants/
        app_constants.dart                     # App-wide constants
      theme/
        app_colors.dart                        # Color palette
        app_theme.dart                         # Light/dark ThemeData
        theme_controller.dart                  # Theme switching (persisted)
      localization/
        app_translations.dart                  # GetX Translations map
        localization_controller.dart           # Language switching (persisted)
        languages/
          en_us.dart                           # English strings
          ar_sa.dart                           # Arabic strings
      global/
        loading_controller.dart                # Global loading state
        loading_overlay.dart                   # Overlay widget (AbsorbPointer)
        global_bindings.dart                   # Permanent controller init
      error/
        error_handler.dart                     # Snackbar/dialog error display
      base/
        base_controller.dart                   # Abstract base with apiCall<T>()
      validation/
        base_validator.dart                    # Form validation methods
    shared/
      widgets/
        error_widget.dart                      # Full-screen error
        no_internet_widget.dart                # No internet screen
        loading_widget.dart                    # Centered spinner
        empty_widget.dart                      # Empty state
    features/
      login/
        model/
          login_request.dart                   # Login request DTO
          login_response.dart                  # Login response DTO
        controller/
          login_controller.dart                # Login logic
        binding/
          login_binding.dart                   # GetX binding
        view/
          login_page.dart                      # Login UI (StatelessWidget)
      user_list/
        model/
          user_model.dart                      # User data model
        controller/
          user_list_controller.dart            # Paginated list (inline)
        binding/
          user_list_binding.dart               # GetX binding
        view/
          user_list_page.dart                  # List UI (StatelessWidget)
          widgets/
            user_tile.dart                     # User list item
```

## Getting Started

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Analyze for issues
flutter analyze
```

## Dependencies

| Package | Purpose |
|---------|---------|
| `get` | State management, routing, DI, snackbars, translations |
| `http` | HTTP client |
| `shared_preferences` | Persistent key-value local storage |
| `connectivity_plus` | Internet connectivity check |

## Usage Examples

### Controllers — `apiCall<T>()` Wrapper

Every feature controller extends `BaseController`, which provides `apiCall<T>()` to eliminate boilerplate try/catch/loading/error handling:

```dart
class LoginController extends BaseController {
  Future<void> login() async {
    final result = await apiCall<LoginResponse>(
      () async {
        final data = await _api.post(ApiEndpoints.login, body: request.toJson());
        return LoginResponse.fromJson(data);
      },
      showOverlay: true,  // shows global loading overlay
    );

    if (result != null) {
      await _storage.saveToken(result.token);
      Get.offAllNamed(AppRoutes.userList);
    }
  }
}
```

Options: `showLoading` (local), `showOverlay` (global), `handleError`, `onError` callback.

### SharedPreferences — StorageService

Initialized async in `main()`, then used as a synchronous singleton:

```dart
// In main.dart
await StorageService.init();

// Anywhere in the app
final storage = StorageService();
await storage.saveToken('abc123');
String? token = storage.getToken();
await storage.removeToken();
bool isDark = storage.getThemeMode();
await storage.saveThemeMode(true);
String? lang = storage.getLanguageCode();
await storage.saveLanguageCode('ar_SA');
bool loggedIn = storage.isLoggedIn;
```

### Loading Overlay

Global overlay controlled from any controller via `LoadingController`:

```dart
// The overlay wraps the entire app in main.dart builder:
builder: (context, child) => LoadingOverlay(child: child ?? const SizedBox.shrink()),

// From any controller — use showOverlay: true in apiCall()
await apiCall<Data>(() => fetchData(), showOverlay: true);

// Or manually:
Get.find<LoadingController>().show();
Get.find<LoadingController>().hide();
```

The overlay uses `AbsorbPointer` to block all interaction while loading. Only one overlay instance exists app-wide, preventing duplicates.

### BaseValidator — Form Validation

Centralized static validators for use in any form:

```dart
TextFormField(
  validator: BaseValidator.validateEmail,       // null or error string
),
TextFormField(
  validator: BaseValidator.validatePassword,
),
TextFormField(
  validator: (v) => BaseValidator.validateRequired(v, 'Username'),
),
TextFormField(
  validator: BaseValidator.validatePhone,
),
TextFormField(
  validator: (v) => BaseValidator.validateMinLength(v, 3, 'Name'),
),
TextFormField(
  validator: (v) => BaseValidator.validateMatch(v, passwordController.text, 'Passwords'),
),
```

### Pagination — Inline Pattern

Controllers manage their own RxList and pagination state directly (no generic base class):

```dart
class UserListController extends BaseController {
  final users = <UserModel>[].obs;
  int _currentPage = 1;
  final hasMore = true.obs;
  final isLoadingMore = false.obs;

  Future<void> loadUsers() async {
    _currentPage = 1;
    hasMore.value = true;
    users.clear();
    final result = await apiCall<List<UserModel>>(() => _fetchPage(_currentPage));
    if (result != null) {
      users.addAll(result);
      hasMore.value = result.length >= AppConstants.paginationLimit;
      _currentPage++;
    }
  }

  Future<void> loadMoreUsers() async {
    if (!hasMore.value || isLoadingMore.value) return;
    isLoadingMore.value = true;
    final result = await apiCall<List<UserModel>>(
      () => _fetchPage(_currentPage),
      showLoading: false,
    );
    if (result != null) {
      users.addAll(result);
      hasMore.value = result.length >= AppConstants.paginationLimit;
      _currentPage++;
    }
    isLoadingMore.value = false;
  }
}
```

### Routing

Define route constants and register pages:

```dart
// app_routes.dart
class AppRoutes {
  static const String login = '/login';
  static const String userList = '/user-list';
}

// app_pages.dart
static final pages = <GetPage>[
  GetPage(
    name: AppRoutes.login,
    page: () => const LoginPage(),
    binding: LoginBinding(),
  ),
  GetPage(
    name: AppRoutes.userList,
    page: () => const UserListPage(),
    binding: UserListBinding(),
    middlewares: [AuthMiddleware()],  // requires token
  ),
];

// Navigate
Get.toNamed(AppRoutes.userList);
Get.offAllNamed(AppRoutes.login);
```

### Theming

Toggle and persist theme from any screen:

```dart
final themeController = Get.find<ThemeController>();
themeController.toggleTheme();       // switches light <-> dark
themeController.isDarkMode;          // current state
```

### Localization

Toggle and persist language from any screen:

```dart
final locController = Get.find<LocalizationController>();
locController.toggleLocale();                    // EN <-> AR
locController.changeLocale('ar', 'SA');          // explicit
'login'.tr;                                      // translated string
```

Add a new language:
1. Create `lib/app/core/localization/languages/xx_yy.dart`
2. Add the map to `app_translations.dart`

### Environment Configuration

```dart
// In main.dart — switch environment
EnvironmentConfig.init(Environment.dev);
EnvironmentConfig.init(Environment.staging);
EnvironmentConfig.init(Environment.prod);

// Update URLs in environment.dart
```

## Important Notes

- **Obx only** — all reactive UI updates use `Obx(() => ...)`, never `GetBuilder` or `GetView`
- **No GetView** — all pages are `StatelessWidget` with `Get.put(Controller())` in `build()`
- **No generic base list controller** — pagination is handled inline per controller with `RxList`, `currentPage`, `hasMore`, `isLoadingMore`
- **Services are singletons** — `BaseApiService`, `StorageService`, `ConnectivityService` use factory constructors
- **ErrorHandler is static** — fire-and-forget side effects, no reactive state
- **LoadingOverlay** wraps the entire app — any controller can trigger it via `apiCall(showOverlay: true)` or directly via `LoadingController`

## Recommended Workflow

1. **Create a new feature folder** under `lib/app/features/your_feature/`
2. **Add model** — request/response DTOs with `fromJson` / `toJson`
3. **Add controller** — extend `BaseController`, use `apiCall<T>()` for API calls
4. **Add binding** — register controller with `Get.lazyPut`
5. **Add view** — `StatelessWidget` with `Get.put(Controller())` and `Obx()` for reactive UI
6. **Register route** — add constant in `app_routes.dart`, add `GetPage` in `app_pages.dart`
7. **Add API endpoints** — register paths in `api_endpoints.dart`
8. **Add translations** — add keys to `en_us.dart` and `ar_sa.dart`

## References

- [GetX Documentation](https://pub.dev/packages/get)
- [SharedPreferences](https://pub.dev/packages/shared_preferences)
- [HTTP Package](https://pub.dev/packages/http)
- [Connectivity Plus](https://pub.dev/packages/connectivity_plus)
- [Flutter Official Docs](https://docs.flutter.dev/)
