# Quick Reference - UI Redesign

## Color Codes

```
Primary Color:      #6366F1 (Indigo)
Secondary Color:    #8B5CF6 (Purple)
Light Background:   #F5F7FA (Light Gray)
Dark Background:    #0F172A (Dark Blue)
Light Surface:      #FFFFFF (White)
Dark Surface:       #1E293B (Dark Slate)
```

## Common Widget Patterns

### Gradient Container
```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Theme.of(context).colorScheme.primary,
        Theme.of(context).colorScheme.secondary,
      ],
    ),
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  ),
  child: // Your widget here
)
```

### Rounded Card
```dart
Container(
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.surface,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  ),
  child: // Your widget here
)
```

### Form Field
```dart
Container(
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.surface,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  ),
  child: TextFormField(
    decoration: InputDecoration(
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      prefixIcon: Icon(Icons.email, color: Theme.of(context).colorScheme.primary),
      hintText: 'Enter email',
    ),
  ),
)
```

### Gradient Button
```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Theme.of(context).colorScheme.primary,
        Theme.of(context).colorScheme.secondary,
      ],
    ),
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  ),
  child: ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    child: const Text('Button', style: TextStyle(color: Colors.white)),
  ),
)
```

### Icon Container
```dart
Container(
  padding: const EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
    borderRadius: BorderRadius.circular(12),
  ),
  child: Icon(
    Icons.email,
    color: Theme.of(context).colorScheme.primary,
    size: 20,
  ),
)
```

### Glassmorphic Card
```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Theme.of(context).colorScheme.primary.withOpacity(0.8),
        Theme.of(context).colorScheme.secondary.withOpacity(0.6),
      ],
    ),
    borderRadius: BorderRadius.circular(30),
    boxShadow: [
      BoxShadow(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
        blurRadius: 20,
        offset: const Offset(0, 10),
      ),
    ],
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(30),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: // Your widget here
      ),
    ),
  ),
)
```

## Spacing Values

```dart
const SizedBox(height: 4),    // Extra small
const SizedBox(height: 8),    // Small
const SizedBox(height: 12),   // Medium-small
const SizedBox(height: 16),   // Medium
const SizedBox(height: 20),   // Large
const SizedBox(height: 24),   // Extra large
const SizedBox(height: 32),   // XXL
```

## Border Radius Values

```dart
BorderRadius.circular(8),     // Small buttons
BorderRadius.circular(12),    // Form fields, small cards
BorderRadius.circular(16),    // Cards, dialogs
BorderRadius.circular(20),    // Large containers
BorderRadius.circular(30),    // Main cards
```

## Shadow Patterns

### Subtle Shadow
```dart
BoxShadow(
  color: Colors.black.withOpacity(0.05),
  blurRadius: 8,
  offset: const Offset(0, 2),
)
```

### Medium Shadow
```dart
BoxShadow(
  color: Colors.black.withOpacity(0.08),
  blurRadius: 12,
  offset: const Offset(0, 4),
)
```

### Strong Shadow
```dart
BoxShadow(
  color: Colors.black.withOpacity(0.1),
  blurRadius: 20,
  offset: const Offset(0, 10),
)
```

## Typography Styles

### Header
```dart
TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.bold,
  color: Theme.of(context).colorScheme.primary,
)
```

### Subheader
```dart
TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: Theme.of(context).colorScheme.primary,
)
```

### Body
```dart
TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w400,
  color: Colors.grey[700],
)
```

### Label
```dart
TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w600,
  color: Theme.of(context).colorScheme.primary,
)
```

## Theme Configuration

```dart
MaterialApp(
  theme: ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFFF5F7FA),
    colorScheme: ColorScheme.light(
      primary: const Color(0xFF6366F1),
      secondary: const Color(0xFF8B5CF6),
      surface: Colors.white,
    ),
  ),
  darkTheme: ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: const Color(0xFF0F172A),
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFF6366F1),
      secondary: const Color(0xFF8B5CF6),
      surface: const Color(0xFF1E293B),
    ),
  ),
  themeMode: ThemeMode.system,
)
```

## Common Imports

```dart
import 'package:flutter/material.dart';
import 'dart:ui';  // For ImageFilter.blur
```

## Useful Tips

1. **Always use Theme.of(context).colorScheme** for colors
2. **Use consistent spacing** - stick to the spacing values
3. **Wrap gradients in Container** with transparent ElevatedButton
4. **Use BoxShadow** for depth, not elevation
5. **Keep border radius consistent** - use predefined values
6. **Test in both light and dark modes**
7. **Use icons for better UX** - add context to inputs
8. **Maintain visual hierarchy** - use size, weight, and color

## Files to Reference

- `Assi04_Weather_App/lib/main.dart` - Weather app implementation
- `quiz_3/lib/main.dart` - Quiz app theme
- `quiz_3/lib/screens/submission_list_screen.dart` - List UI
- `quiz_3/lib/screens/submission_form_screen.dart` - Form UI

## Quick Commands

```bash
# Check for errors
flutter analyze

# Format code
flutter format .

# Run app
flutter run

# Build release
flutter build apk
flutter build ios
flutter build web
```

## Resources

- [Flutter Material Design](https://material.io/design)
- [Flutter Widgets](https://flutter.dev/docs/development/ui/widgets)
- [Color Theory](https://material.io/design/color)
- [Glassmorphism](https://glassmorphism.com/)

---

**Last Updated**: May 9, 2026
**Version**: 1.0
**Status**: Complete ✨
