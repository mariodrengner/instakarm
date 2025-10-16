# Warum speichert Hive Daten binär?

Hive verwendet ein binäres Format anstelle von textbasierten Formaten wie JSON, um **maximale Geschwindigkeit und Speichereffizienz** zu erreichen.

### 1. Geschwindigkeit
- **Kein Parsen nötig:** Anstatt Text (JSON) langsam zu analysieren, liest die App die Binärdaten direkt in Dart-Objekte ein. Dieser Prozess ist deutlich schneller.
- **`TypeAdapter`:** Der mit `build_runner` generierte `TypeAdapter` agiert als hochoptimierter "Übersetzer" zwischen dem Dart-Objekt und seiner binären Repräsentation.

### 2. Effizienz
- **Geringerer Speicherplatz:** Das Binärformat ist wesentlich kompakter als JSON. Feld-IDs (z.B. `@HiveField(0)`) ersetzen lange Text-Schlüssel (`"userName"`) und sparen so bei jedem Eintrag Speicherplatz.
- **Typsicherheit:** Das Format ist exakt auf die Dart-Klasse zugeschnitten, was Fehler bei der Datenkonvertierung verhindert.

**Kurz gesagt: Hive opfert menschliche Lesbarkeit für eine deutlich höhere Performance auf dem Gerät.**
