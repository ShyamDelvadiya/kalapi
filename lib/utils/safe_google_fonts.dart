import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Helper that attempts to use GoogleFonts but falls back to a plain
/// TextStyle when fonts or the asset manifest can't be read at runtime.
class SafeGoogleFonts {
  static bool _available = true;

  /// Call this early (before heavy UI usage) to verify asset manifest is readable.
  static Future<void> ensureAvailable() async {
    // No-op: we avoid reading AssetManifest at startup. Availability is
    // discovered lazily when fonts are first requested.
  }

  static TextStyle outfit({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    if (!_available) {
      return TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );
    }

    try {
      return GoogleFonts.outfit(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );
    } catch (e) {
      // Mark unavailable to avoid repeated exceptions
      _available = false;
      return TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );
    }
  }

  static TextStyle mulish({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    if (!_available) {
      return TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );
    }

    try {
      return GoogleFonts.mulish(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );
    } catch (e) {
      _available = false;
      return TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );
    }
  }
}
