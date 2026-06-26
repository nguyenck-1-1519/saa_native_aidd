import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/kudo_recipient.dart';

const Color _kBorder = Color(0xFF998C5F);
const Color _kTextDark = Color(0xFF00101A);
const Color _kTextGray = Color(0xFF999999);

/// Renders a compact list of [KudoRecipient] suggestions below the search field.
///
/// Shows a loading indicator, an empty-state message, or up to 5 result rows.
/// Tapping a row fires [onSelect] with the chosen recipient.
///
/// Designed to sit directly below [WriteKudoSearchField] inside a Column.
class WriteKudoRecipientSuggestions extends StatelessWidget {
  const WriteKudoRecipientSuggestions({
    super.key,
    required this.suggestionsAsync,
    this.onSelect,
  });

  final AsyncValue<List<KudoRecipient>> suggestionsAsync;
  final ValueChanged<KudoRecipient>? onSelect;

  static const int _maxVisible = 5;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _kBorder, width: 0.5),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(3.574),
        ),
      ),
      constraints: const BoxConstraints(maxHeight: 200),
      child: suggestionsAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(12),
          child: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        error: (_, __) => const Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Không tải được kết quả.',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 12,
              color: _kTextGray,
            ),
          ),
        ),
        data: (results) {
          if (results.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'Không tìm thấy kết quả.',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12,
                  color: _kTextGray,
                ),
              ),
            );
          }
          final visible = results.take(_maxVisible).toList();
          return ListView.separated(
            shrinkWrap: true,
            itemCount: visible.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 1, color: Color(0xFFE0E0E0)),
            itemBuilder: (_, i) {
              final r = visible[i];
              return InkWell(
                onTap: () => onSelect?.call(r),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        r.name,
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: _kTextDark,
                        ),
                      ),
                      if (r.role != null && r.role!.isNotEmpty)
                        Text(
                          r.role!,
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 11,
                            color: _kTextGray,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
