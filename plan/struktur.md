# Detaillierte Projektstruktur

Dieses Dokument visualisiert die in `project.md` definierte Verzeichnisstruktur der Instakarm-App. Es dient als schnelle Referenz für Entwickler, um die Organisation von Core-Funktionalitäten und Features zu verstehen.

---

## Verzeichnisstruktur (`lib/`)

```
lib/
│
├── core/
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── color_schemes.dart
│   │   └── gradients.dart
│   │
│   ├── widgets/
│   │   └── shared_components.dart
│   │
│   ├── utils/
│   │   └── extensions/
│   │       └── context_extensions.dart
│   │
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   │
│   └── di/
│       ├── injector.dart
│       └── injection.config.dart
│
├── app_shell/
│   ├── app.dart
│   ├── app_router.dart
│   ├── bottom_navigation.dart
│   └── app_scaffold.dart
│
└── features/
    ├── feature_name/
    │   ├── data/
    │   │   ├── datasources/
    │   │   ├── models/
    │   │   └── repositories_impl/
    │   │
    │   ├── domain/
    │   │   ├── entities/
    │   │   ├── repositories/
    │   │   └── usecases/
    │   │
    │   └── presentation/
    │       ├── bloc/
    │       ├── pages/
    │       └── widgets/
    │
    └── ...
```

---

### Erläuterung der Hauptverzeichnisse:

- **`core/`**: Enthält App-übergreifende Logik, die von keinem spezifischen Feature abhängt.
  - `theme/`: Zentrales Design-System (Farben, Typografie, Themes).
  - `widgets/`: Geteilte, wiederverwendbare UI-Komponenten.
  - `utils/`: Hilfsfunktionen und Erweiterungen.
  - `errors/`: Definition von Exceptions und Failures für die Fehlerbehandlung.
  - `di/`: Dependency Injection Setup (`GetIt`).

- **`app_shell/`**: Definiert das Grundgerüst der App.
  - `app.dart`: Haupt-Widget der Anwendung.
  - `app_router.dart`: Konfiguration für `go_router`.
  - `app_scaffold.dart`: Globales Scaffold mit Navigation (z.B. BottomNavigationBar).

- **`features/`**: Beinhaltet alle eigenständigen Funktionsmodule der App.
  - Jedes Feature ist nach der **Clean Architecture** in `data`, `domain` und `presentation` unterteilt.
  - Diese Struktur fördert die Kapselung und Skalierbarkeit.
