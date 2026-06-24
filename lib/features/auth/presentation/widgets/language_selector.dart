import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/locale_controller.dart';
import '../../../../core/theme/app_typography.dart';

/// Flag emoji + display code per supported language.
const Map<String, ({String flag, String code})> _languages = {
  'vi': (flag: '🇻🇳', code: 'VN'),
  'en': (flag: '🇬🇧', code: 'EN'),
  'ja': (flag: '🇯🇵', code: 'JA'),
};

/// Top-right language selector. Opens a dropdown of VN/EN/JA (FUN_001/002),
/// updates flag+code on select (FUN_003) and re-renders all localized text via
/// the [localeControllerProvider] (FUN_004). Choice is persisted.
class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider);
    final current = _languages[locale.languageCode] ?? _languages['vi']!;

    return PopupMenuButton<Locale>(
      tooltip: 'Language',
      position: PopupMenuPosition.under,
      onSelected: (l) =>
          ref.read(localeControllerProvider.notifier).setLocale(l),
      itemBuilder: (context) => [
        for (final entry in _languages.entries)
          PopupMenuItem<Locale>(
            value: Locale(entry.key),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(entry.value.flag, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Text(entry.value.code),
              ],
            ),
          ),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(current.flag, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 6),
          Text(current.code, style: AppTypography.languageCode),
          const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 20),
        ],
      ),
    );
  }
}
