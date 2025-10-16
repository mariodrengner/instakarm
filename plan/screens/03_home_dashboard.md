# 🏠 Home Dashboard Screen

## 🎯 Story
Als Nutzer möchte ich meine täglichen Aufgaben, Fortschritte und Belohnungen sehen.

## 🧠 Ziel
Ein fokussierter Überblick mit Gamification-Elementen (Level, Punkte, Fortschritt).

## 🧩 Tasks
- Header im body Bereich mit persönlicher Begrüßung (im Onboarding gewählter Name)
- Scrollbarer Bereich mit zufällig gewählten noch nicht erledigten Tagesaufgaben (Chips oder Cards) die untereinander in einer scrollbaren (nur wenn nötig) Liste angezeigt werden
- Tap auf Aufgabe öffnet die Detailansicht der Aufgabe in einem ModalBottomSheet
- Sobald, die Aufgabe erledigt ist, wird sie aus der Liste entfernt und die Punktzahl erhöht.
- Eine Statusleiste am unteren Bildschirmrand (BottomNavigationBar?) zeigt ähnlich wie beim Akkuladezustand an, wie weit das Karma-Level gefüllt ist.
- Sind alle Aufgaben des aktuellen Schwierigkeitsgrades erledigt, kann man über einen FloatingActionButton (unten mittig) weitere zufällig gewählte Aufgaben hinzufügen (möglichst aus anderen Kategorien)

## ✨ Besonderheiten
- Wenn nur eine Aufgabe übrig ist kann sie in der Detailansicht direkt innerhalb der Liste angezeigt werden, ohne dass sie im ModalBottomSheet geöffnet werden muss.

<!--## 🎨 Visuelle Hinweise
- Hintergrund: radialer Verlauf von #FF8C42 → #FFE29F (Opacity 0.2)
- GlassCard-Stil: Blur 16, Shadow 0.1
- Icons: Material Symbols Outline
- Farben: Primär #FF8C42, Sekundär #4ECDC4, Text #FFFFFFCC-->
