
# 🧭 Onboarding Screen

### 🎯 **User Story**
Als **neuer Nutzer** möchte ich beim ersten App-Start in einem kurzen, unterhaltsamen Onboarding-Prozess das Prinzip der App verstehen, meine gewünschte Schwierigkeitsstufe wählen und einen (ggf. zufällig generierten) Namen festlegen, um anschließend personalisiert in den Hauptbereich der App zu starten.

---

## 🖼️ **Visual Flow (Slides Overview)**

| Slide | Inhalt | CTA-Buttons | Besonderheiten |
|-------|---------|--------------|----------------|
| 1 | Grundprinzip kurz erklärt | **Weiter**, **Überspringen und gleich loslegen** | ggf. illustrierte Animation oder Lottie |
| 2 | Auswahl der Schwierigkeitsstufe | **Weiter**, **Überspringen und gleich loslegen** | dynamische Inputs + ButtonGroup |
| 3 | Nameingabe / Zufallsname | **Jetzt starten** | humorvolle Randomnamen-Generator |

---

## 🧩 **Slide 1 – Einführung**
**Ziel:** Nutzer versteht sofort, worum es bei der App geht (Gamification, tägliche Mini-Challenges etc.)

**Inhalte:**
- Kurzer Text (1–2 Sätze): *„Jeden Tag kleine Aufgaben. Motivation, Spaß und Fortschritt in deinem Alltag.“*
- Illustration oder animiertes Icon (Figma-Frame mit Lottie optional)
- Light GlassCard für Text-Block
- CTA-Bereich am unteren Rand:
  - **Primär:** „Weiter“
  - **Sekundär:** „Überspringen und gleich loslegen“ (führt direkt zu Home mit Default-Setup)

**Tasks:**
- [ ] Layout: Centered Column mit max. 80% Höhe
- [ ] Animation FadeIn/FadeOut bei Slide-Wechsel
- [ ] CTA-Bar sticky am unteren Rand
- [ ] Übergang zu Slide 2 per Swipe oder Button

---

## 🧠 **Slide 2 – Schwierigkeitsauswahl**
**Ziel:** Nutzer definiert, wie viele Aufgaben & Kategorien pro Tag aktiv sein sollen.

**UI-Elemente:**
- Titel: *„Wie viel möchtest du dir vornehmen?“*
- Untertitel: *„Passe die Herausforderung an deinen Alltag an.“*
- 2 NumberInput-Felder (jeweils mit „+“ und „–“ Buttons):
  - **Kategorien:** max. 7
  - **Aufgaben pro Tag:** max. 7
- ButtonGroup (3 Optionen):
  - 🟢 *Einfach:* 1 Kategorie, 1 Aufgabe
  - 🟡 *Mittel:* 3 Kategorien, 3 Aufgaben *(default)*
  - 🔴 *Schwer:* 7 Kategorien, 7 Aufgaben
  *(Beim Wechsel werden die Eingabewerte automatisch angepasst.)*

**Tasks:**
- [ ] Stateful Widget mit synchronisierter NumberInput-Logik
- [ ] Logik im Riverpod Notifier anpassen, um die Werte zu aktualisieren
- [ ] Defaultwert: Mittel (3/3)
- [ ] Animation: sanfte Skalierung der gewählten ButtonGroup-Option
- [ ] CTA-Bereich wie Slide 1

---

## 🧍 **Slide 3 – Nameingabe / Zufallsname**
**Ziel:** Nutzer personalisiert seinen Account mit Spaßfaktor.

**Inhalte:**
- Titel: *„Wie sollen wir dich nennen?“*
- Textfeld mit:
  - Platzhalter: *„z. B. MutMacher3000“*
  - Defaultwert: automatisch generierter humorvoller Name (z. B. „Taskinator“, „Snack-King“, „Captain Fokus“)
- Optional: 🔁 Button „Neuer Vorschlag“ (regeneriert Zufallsnamen)
- Untertitel: *„Du kannst den Namen jederzeit ändern.“*
- CTA: **„Jetzt starten“**
  → Speichert Werte in `UserProfile` und navigiert zu HomeScreen.

**Tasks:**
- [ ] Zufallsnamen-Generator implementieren (Liste humorvoller Namen)
- [ ] TextInput mit Controller (füllt automatisch bei Start)
- [ ] Animation: TextInput fadeIn
- [ ] CTA ruft BloC-Event „UserSetupComplete“ auf
- [ ] Navigation zu `/home` mit Übergangsanimation (slideUp / fade)

---

## 💡 **Visuelle Hinweise für Figma**
- Slides im horizontalen Frame-Layout (`Frame → Auto Layout Horizontal`)
- Zwischenräume: 32 px
- CTA-Leiste am unteren Rand fixiert
- Farbverlauf-Hintergrund leicht transparent (Glassmorphism-Stil)
- Blur-Effekt (20–30px) für Overlays
- Sanfte Farbverläufe (z. B. linear #FFFFFF00 → #FFFFFF0D)
- Typografie:
  - Titel: `Display Medium`
  - Beschreibung: `Body Medium`
  - CTAs: `Label Large`

---

## 🎨 **Farbschema-Empfehlung**
| Zweck | Farbe | Beispiel |
|-------|--------|----------|
| Hintergrund | Dunkel verlaufend | `#0B0C10 → #1F2833` |
| Akzent | Türkis / Cyan | `#66FCF1` |
| Primär CTA | Hellblau | `#45A29E` |
| Sekundär CTA | Weiß mit 60 % Opazität | `#FFFFFF99` |
| Text | Weiß | `#FFFFFF` |
| Blur-Overlay | Weiß (8 % Opazität) | `#FFFFFF14` |
