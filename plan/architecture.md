# 🧭 plan.md — Architektur- und Entwicklungsplan

## 1. 🎯 Ziel

Dieses Dokument beschreibt die technische Planung und Architektur der Flutter-App Instakarm.
Die App basiert auf einer **Feature-First Clean Architecture** mit **BloC** als State-Management.
Ziel ist eine klare, skalierbare und wartbare Struktur, die eine spätere Codegenerierung und einfache Erweiterbarkeit erlaubt.

---

## 2. 🧱 Architekturprinzipien

Die App folgt den Prinzipien der **Clean Architecture** in Kombination mit einer **Feature-basierten Struktur**:

| Layer | Zweck | Abhängigkeiten |
|-------|--------|----------------|
| **presentation** | UI, State Management (BloC), Routing | hängt nur von `domain` ab |
| **domain** | Business-Logik, Entities, Use-Cases, Repository-Interfaces | unabhängig |
| **data** | Datenquellen (API, Cache, lokale DB), Repository-Implementierung | hängt nur von `domain` ab |

Jedes Feature ist eigenständig und kapselt alle drei Layer.

---

## 3. 📂 Projektstruktur

Die detaillierte und visualisierte Projektstruktur ist im folgenden Dokument ausgelagert:
- **➡️ Details in: [struktur.md](./struktur.md)**


---

## 4. ⚙️ State Management — BloC

Jedes Feature enthält seinen eigenen BloC:

```
presentation/bloc/
├── feature_bloc.dart
├── feature_event.dart
└── feature_state.dart
```

### Prinzipien
- Die UI (Widgets) sendet Events an den BloC.
- Der BloC führt UseCases aus der Domain-Schicht aus.
- States werden reaktiv an die UI zurückgegeben.
- Keine Businesslogik in Widgets.

---

## 5. 🧩 Dependency Injection

Verwendung von **GetIt** (optional mit **Injectable**).
Alle Abhängigkeiten (z. B. UseCases, Repositories, DataSources, BloCs) werden in `core/di/injector.dart` registriert.

Beispielstruktur:
```
setupDependencies() {
  // register data sources
  // register repositories
  // register use cases
  // register blocs
}
```

---

## 6. 🧭 Navigation & AppShell

### AppShell
Die AppShell stellt die Grundstruktur der App bereit:
- Enthält das globale `Scaffold`
- Verwaltet `BottomNavigationBar`, `AppBar`, Hintergrundebenen
- Wird über `app.dart` initialisiert

### Routing
- Umsetzung über `go_router`
- Feature-Routen sind modular definiert
- Jede Route ist klar einem Feature zugeordnet

---

## 7. 🎨 Theme & Assets

### Theme
- Basierend auf Material 3 (`ThemeData.colorScheme`)
- Erweiterbar über `ThemeExtension` (z. B. für Gradients, CustomShadows)
- Schriftarten, Farben und Verläufe zentral verwaltet in `core/theme/`

### Assets
```
assets/
├── images/
│   ├── backgrounds/
│   ├── icons/
│   └── illustrations/
├── fonts/
└── svgs/
```
Einbindung über `pubspec.yaml`, Nutzung mit `flutter_gen`.

---

## 8. 🧪 Tests

| Testtyp | Ziel |
|----------|------|
| **Unit Tests** | UseCases, Repositories, BloCs |
| **Widget Tests** | UI-Komponenten und Rendering |
| **Integration Tests** | App-Flows, Navigation, Datenfluss |

```
test/
├── features/
│   ├── feature_name/
│   │   ├── domain/
│   │   ├── data/
│   │   └── presentation/
│
└── core/
```

---

## 9. 🏗️ Build & Codegenerierung

Standardisierte Build-Tools:

| Tool | Zweck |
|------|--------|
| `build_runner` | Codegenerierung |
| `freezed` | Immutable Klassen, Union States |
| `json_serializable` | (De-)Serialisierung |
| `injectable` | Dependency Injection Generator (optional) |

Build-Befehl:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 10. 🔁 Entwicklungsablauf

1. Neues Feature in `lib/features/` anlegen
2. Domain-Schicht (Entities, UseCases, Repositories) definieren
3. Data-Schicht implementieren (API, Cache, lokale DB)
4. Presentation-Schicht: BloC + UI
5. Dependencies in `injector.dart` registrieren
6. Route im `app_router.dart` hinzufügen
7. Tests erstellen
8. Code generieren (`build_runner`)
9. Review und Integration

---

## 11. 🌐 Erweiterungspotential

- Dynamisches Theming (Farbpaletten, Gradients)
- Hintergrundanimationen oder -ebenen mit Parallax
- Lokale Speicherung mit Hive oder Drift
- Offline-First Architektur
- KI-gestützte Feature-Erweiterungen (z. B. Vorschläge, Klassifizierung)
- Multiplattform-Optimierung (Web, Desktop, Mobile)

---

## 12. 📦 Ziel der Planung

Diese `plan.md` dient als Grundlage für:
- Architekturaufbau
- konsistente Code-Generierung
- klare Feature-Abgrenzung
- einfache Teamarbeit und Wartung
- spätere Erweiterung um automatisierte Tools oder KI-Unterstützung

---

> 📘 **Kurz gesagt:**
> Diese Struktur sorgt für **Klarheit, Testbarkeit und Skalierbarkeit**.
> Jedes Feature ist vollständig isoliert, aber nach denselben Regeln aufgebaut.
