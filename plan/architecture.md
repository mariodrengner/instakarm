# 🧭 plan.md — Architektur- und Entwicklungsplan

## 1. 🎯 Ziel

Dieses Dokument beschreibt die technische Planung und Architektur der Flutter-App Instakarm.
Die App basiert auf einer **Feature-First Clean Architecture** mit **Riverpod** als State-Management- und Dependency-Injection-Lösung.
Ziel ist eine klare, skalierbare und wartbare Struktur.

---

## 2. 🧱 Architekturprinzipien

Die App folgt den Prinzipien der **Clean Architecture** in Kombination mit einer **Feature-basierten Struktur**:

| Layer | Zweck | Abhängigkeiten |
|-------|--------|----------------|
| **presentation** | UI, State Management (Riverpod Notifiers), Routing | hängt nur von `domain` ab |
| **domain** | Business-Logik, Entities, Repository-Interfaces | unabhängig |
| **data** | Datenquellen (API, Cache, lokale DB), Repository-Implementierung | hängt nur von `domain` ab |

Jedes Feature ist eigenständig und kapselt alle drei Layer.

---

## 3. 📂 Projektstruktur

Die detaillierte und visualisierte Projektstruktur ist im folgenden Dokument ausgelagert:
- **➡️ Details in: [struktur.md](./struktur.md)**


---

## 4. ⚙️ State Management & Dependency Injection — Riverpod

Die App nutzt **Riverpod** als einheitliche Lösung für State Management und Dependency Injection.

### State Management
- Jeder View mit komplexer Logik hat einen eigenen `AsyncNotifier`.
- Der Notifier kapselt die Geschäftslogik und gibt einen `State` (z.B. `AsyncValue<MyState>`) aus.
- Die UI (Widgets) "hört" auf den Provider und wird bei Zustandsänderungen reaktiv neu aufgebaut.
- Keine Businesslogik in Widgets.

### Dependency Injection
- Riverpod's `Provider` und `FutureProvider` werden genutzt, um Abhängigkeiten wie Repositories und DataSources bereitzustellen.
- Abhängigkeiten werden bei Bedarf erstellt und können einfach in Tests durch Overrides ersetzt werden.
- Es ist kein separates DI-Framework wie `GetIt` notwendig.

---

## 5. 🧭 Navigation & AppShell

### AppShell
Die AppShell stellt die Grundstruktur der App bereit:
- Enthält das globale `Scaffold`
- Verwaltet `BottomNavigationBar`, `AppBar`, Hintergrundebenen
- Wird über `app.dart` initialisiert

### Routing
- Umsetzung über `go_router`
- Feature-Routen sind modular definiert
- Jede Route ist klar einem Feature zugeordnet
- Reaktive Umleitungen basierend auf dem App-Zustand (z.B. Onboarding-Status) werden über einen `RouterNotifier` gesteuert.

---

## 6. 🎨 Theme & Assets

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
Einbindung über `pubspec.yaml`.

---

## 7. 🧪 Tests

| Testtyp | Ziel |
|----------|------|
| **Unit Tests** | Repositories, Notifier-Logik |
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

## 8. 🏗️ Build & Codegenerierung

Standardisierte Build-Tools:

| Tool | Zweck |
|------|--------|
| `build_runner` | Codegenerierung |
| `riverpod_generator` | Generierung von Providern |
| `json_serializable` | (De-)Serialisierung |
| `hive_generator` | Generierung von Hive TypeAdaptern |

Build-Befehl:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 9. 🔁 Entwicklungsablauf

1. Neues Feature in `lib/features/` anlegen
2. Domain-Schicht (Entities, Repositories) definieren
3. Data-Schicht implementieren (z.B. Hive-Repository)
4. Presentation-Schicht: Notifier + UI
5. Provider erstellen (idealerweise mit `riverpod_generator`)
6. Route im `app_router.dart` hinzufügen
7. Tests erstellen
8. Code generieren (`build_runner`)
9. Review und Integration

---

## 10. 🌐 Erweiterungspotential

- Dynamisches Theming (Farbpaletten, Gradients)
- Hintergrundanimationen oder -ebenen mit Parallax
- Offline-First Architektur
- KI-gestützte Feature-Erweiterungen (z. B. Vorschläge, Klassifizierung)
- Multiplattform-Optimierung (Web, Desktop, Mobile)

---

## 11. 📦 Ziel der Planung

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
