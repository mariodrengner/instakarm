# InstaKarm ✨ – Kleine Taten, große Wirkung

InstaKarm ist eine moderne mobile App, die darauf ausgelegt ist, durch kleine, tägliche Aufgaben positive Gewohnheiten zu fördern und das persönliche Wohlbefinden zu steigern. Sie bricht das große Ziel der Selbstverbesserung in winzige, machbare Schritte herunter und macht den Fortschritt durch das Sammeln von "Karma-Punkten" spielerisch sichtbar.

---

## 🚀 Die User-Journey

1.  **Onboarding:** Ein schneller, unkomplizierter Einstieg, bei dem der Nutzer einen Namen wählt und den gewünschten Schwierigkeitsgrad festlegt.
2.  **Tägliche Aufgaben:** Auf dem Homescreen werden die Aufgaben für den Tag angezeigt.
3.  **Absolvieren & Sammeln:** Mit einem Klick wird eine Aufgabe als erledigt markiert, und der Karma-Punktestand erhöht sich.
4.  **Wachsen:** Der Nutzer sieht seinen Fortschritt und baut kontinuierlich positive Gewohnheiten auf.

---

## 🛠️ Tech Stack & Architektur

Um InstaKarm robust, wartbar und skalierbar zu machen, wurde eine moderne, an Clean Architecture angelehnte **Feature-First-Architektur** gewählt.

- **Framework:** **Flutter** – Für eine plattformübergreifende Entwicklung auf iOS, Android und Web.
- **State Management:** **Riverpod** – Für eine klare Trennung von UI und Geschäftslogik und sauberes Dependency Management.
- **Routing:** **GoRouter** – Für eine deklarative, zustandsbasierte Navigation.
- **Lokale Datenbank:** **Hive** – Eine extrem schnelle und leichtgewichtige NoSQL-Datenbank zur lokalen Speicherung von Nutzerprofilen und Aufgaben.

**➡️ Mehr Details im [Architekturplan](./plan/architecture.md).**

### Projektstruktur

```
lib/
├── app_shell/      # App-Grundgerüst (Routing, Haupt-Widget)
├── core/           # App-übergreifende Logik (Theme, Models, DI)
├── features/       # Einzelne Features/Module der App
│   ├── home/
│   ├── onboarding/
│   └── ...
└── shared/         # Wiederverwendbare Widgets
```

---

## 🏁 Getting Started

### Voraussetzungen

- Flutter SDK (aktuelle stabile Version)
- Ein Editor wie VS Code oder Android Studio

### Installation & Ausführung

1.  **Repository klonen:**
    ```bash
    git clone <repository-url>
    cd instakarm
    ```

2.  **Abhängigkeiten installieren:**
    ```bash
    flutter pub get
    ```

3.  **Code generieren (falls nötig):**
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

4.  **App starten:**
    ```bash
    flutter run
    ```

---

## 📂 Projektstruktur & Planung

Die gesamte Planung – von der Idee über das Design bis zur technischen Umsetzung – ist im Verzeichnis `/plan` dokumentiert. Der beste Einstiegspunkt ist die [PLAN.md](./plan/PLAN.md).