# Instakarm ✨

Eine moderne Achtsamkeits-App, die hilft, durch kleine, tägliche Aufgaben innere Balance zu finden.

---

## 🚀 Status

**In Planung.** Die Konzeptions- und Architekturphase ist abgeschlossen. Der nächste Schritt ist die Implementierung der Basis-Architektur und der ersten Features.

## 🎯 Vision

Instakarm ist ein digitaler Begleiter für den Alltag, der Achtsamkeit und persönliche Balance fördert – ohne spirituelle Überforderung. Die App bietet täglich sieben kleine, sinnvolle Aufgaben, die auf Prinzipien der Ausgeglichenheit basieren (subtil inspiriert von Chakra-Lehren), aber in einfacher, alltagstauglicher Sprache formuliert sind.

Das Ziel ist eine ästhetische, ruhige und motivierende Nutzererfahrung, die auf sanfter Gamification und personalisierter Unterstützung basiert.

**➡️ Mehr Details in der [Vision & Idee](./plan/idee.md).**

---

## 🛠️ Tech Stack & Architektur

Das Projekt basiert auf einer sauberen, skalierbaren Architektur, um eine hohe Code-Qualität und Wartbarkeit zu gewährleisten.

- **Framework:** Flutter
- **Architektur:** Feature-First Clean Architecture
- **State Management:** BLoC
- **Navigation:** `go_router`
- **Dependency Injection:** `GetIt`
- **Code-Generierung:** `build_runner` (für `freezed`, `json_serializable` etc.)

**➡️ Mehr Details im [Architekturplan](./plan/architecture.md).**

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

Die detaillierte Verzeichnisstruktur ist hier visualisiert: **[Struktur-Dokument](./plan/struktur.md)**.
