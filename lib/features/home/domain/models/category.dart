/// Represents the core categories within the app.
///
/// This enum provides a stable, type-safe identifier for each category.
enum Category {
  grounding, // Root
  creativity, // Sacral
  confidence, // Solar Plexus
  compassion, // Heart
  expression, // Throat
  intuition, // Third Eye
  awareness // Crown
}

/// Provides helper methods for the [Category] enum, primarily for localization.
extension CategoryLocalization on Category {
  /// Returns the key used to look up the display name in the localization files (.arb).
  String get localizationKey {
    switch (this) {
      case Category.grounding:
        return 'category_grounding';
      case Category.creativity:
        return 'category_creativity';
      case Category.confidence:
        return 'category_confidence';
      case Category.compassion:
        return 'category_compassion';
      case Category.expression:
        return 'category_expression';
      case Category.intuition:
        return 'category_intuition';
      case Category.awareness:
        return 'category_awareness';
    }
  }
}
