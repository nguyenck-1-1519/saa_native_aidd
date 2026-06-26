part of 'profile_kudos_card.dart';

// ---------------------------------------------------------------------------
// B.3 — Sender → arrow → Recipient
// ---------------------------------------------------------------------------

class _SenderRecipientRow extends StatelessWidget {
  const _SenderRecipientRow({required this.kudo});

  final ProfileKudoView kudo;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: _PersonColumn(
            name: kudo.senderName,
            avatarUrl: kudo.senderAvatarUrl,
            heroTag: kudo.senderHeroTag,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Icon(Icons.arrow_forward, size: 16, color: Color(0xFFFFEA9E)),
        ),
        Expanded(
          child: _PersonColumn(
            name: kudo.recipientName,
            avatarUrl: kudo.recipientAvatarUrl,
            heroTag: kudo.recipientHeroTag,
          ),
        ),
      ],
    );
  }
}

class _PersonColumn extends StatelessWidget {
  const _PersonColumn({
    required this.name,
    required this.avatarUrl,
    required this.heroTag,
  });

  final String name;
  final String? avatarUrl;
  final String? heroTag;

  static const Color _nameDark = Color(0xFF00101A);
  static const Color _avatarPlaceholder = Color(0xFFEEEEEE);
  static const double _avatarSize = 24;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: _avatarSize,
          height: _avatarSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _avatarPlaceholder,
            border: Border.all(color: Colors.white, width: 0.865),
            image: (avatarUrl != null && avatarUrl!.isNotEmpty)
                ? DecorationImage(image: NetworkImage(avatarUrl!), fit: BoxFit.cover)
                : null,
          ),
          child: (avatarUrl == null || avatarUrl!.isEmpty)
              ? const Icon(Icons.person, size: 14, color: Colors.white54)
              : null,
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: _nameDark,
            height: 16 / 10,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        if (heroTag != null && heroTag!.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            heroTag!,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 8,
              fontWeight: FontWeight.w400,
              color: _nameDark,
              height: 10 / 8,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ],
    );
  }
}
