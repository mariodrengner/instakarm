
# 📱 App Screens Übersicht

Diese Übersicht beschreibt alle benötigten Screens für die App sowie ein empfohlenes konsistentes Farbschema für das UI-Design in Figma.

---

## 📖 Detaillierte User Stories

Für eine detaillierte Ausarbeitung der einzelnen Screens, inklusive User Stories und spezifischen Anforderungen, siehe die Dokumente im folgenden Verzeichnis:
- **➡️ [Detaillierte Stories](./screens/)**

---

## 🔹 Hauptnavigation / Struktur

1. **Onboarding & Authentifizierung**
   - **Welcome Screen** – Intro mit Logo, App-Ziel und Start-Button
   - **Sign Up Screen** – Registrierung mit E-Mail / Social Login
   - **Login Screen** – Anmeldung für bestehende Nutzer
   - **Forgot Password Screen** – Passwort zurücksetzen

2. **Home & Dashboard**
   - **Home Screen** – Übersicht mit Fortschrittsanzeige, Missionen, Quick Actions
   - **Daily Missions Screen** – Liste aktueller Aufgaben mit Status
   - **Achievements Screen** – Übersicht der erreichten Ziele, Gamification-Badges
   - **Profile Screen** – Benutzerprofil, Statistiken, Einstellungen

3. **Gallery & Content**
   - **Gallery Overview** – Gitter-/Kartenansicht aller Einträge (z. B. Fotos, Inhalte)
   - **Gallery Detail Screen** – Vollansicht mit Beschreibung, Datum, Aktionen
   - **Add New Entry Screen** – Formular oder Kamera-Upload
   - **Edit Entry Screen** – Bearbeiten bestehender Einträge

4. **Social & Community**
   - **Feed Screen** – Öffentlicher oder Community-Feed (je nach App-Ziel)
   - **Comment Screen** – Kommentare und Reaktionen
   - **User Profile (Other)** – Ansicht anderer Profile

5. **Settings & Utility**
   - **Settings Screen** – App-Einstellungen, Theme, Datenschutz, Sprache
   - **Notifications Screen** – Push-Benachrichtigungen & Historie
   - **About Screen** – App-Version, rechtliche Hinweise

---

## 🎨 Farbschema

Ein **modernes, halbtransparentes „Glassmorphism“-Theme**, das auf Helligkeit, Tiefe und sanften Farbverläufen basiert.

| Zweck | Farbe | Beispiel |
|-------|--------|-----------|
| **Primärfarbe** | `#4F9DDE` | Sanftes, leicht bläuliches Cyan |
| **Sekundärfarbe** | `#A76DFF` | Leicht violetter Akzent für Buttons / Highlights |
| **Hintergrund (hell)** | `#F7F8FB` | Sehr helles Grau mit leichtem Blaustich |
| **Hintergrund (dunkel / Glas)** | `rgba(255, 255, 255, 0.15)` | Transparente Ebenen über Blur |
| **Text – primär** | `#FFFFFF` | Für dunkle Hintergründe |
| **Text – sekundär** | `#E0E0E0` | Für Labels oder weniger wichtige Infos |
| **Text – dunkel** | `#1A1A1A` | Für helle Hintergründe |
| **Akzentfarbe Erfolg** | `#5DD39E` | Positiv, Erfolg, Bestätigung |
| **Akzentfarbe Warnung** | `#FFC857` | Warnung, Hinweise |
| **Akzentfarbe Fehler** | `#F25F5C` | Fehler, negative Aktionen |

---

## 💡 Design Guidelines (für Figma)

- **GlassCard-Komponenten** als zentrale Designelemente (leicht transparent, Blur, abgerundete Ecken)
- **Soft Shadows** (`0 4px 24px rgba(0, 0, 0, 0.15)`) für Tiefe
- **Rounded Corners** (`24px` bei Cards, `50%` bei Avataren)
- **Icons:** Lucide oder Material Symbols Rounded
- **Font Pairing:**
  - Headings → `Poppins` (600–700)
  - Body → `Inter` oder `Roboto` (400–500)
- **Spacing:** 8pt Grid System
- **Animationsideen:** sanfte Parallax-Effekte, leichtes Schweben von Cards beim Scrollen

---

## 📋 Nächste Schritte für Figma

1. Styleguide und Farbsystem in Figma als „Design Tokens“ anlegen
2. Component Library erstellen (Buttons, Chips, Cards, Inputs, Navigation)
3. Screens gemäß obiger Liste anlegen und prototypisch verlinken
4. Optional: Light & Dark Theme Varianten vorbereiten
