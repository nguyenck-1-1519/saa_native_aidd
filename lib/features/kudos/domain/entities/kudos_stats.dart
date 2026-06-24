/// Aggregate Kudos stats shown in the "ALL KUDOS" block on the Kudos screen.
class KudosStats {
  const KudosStats({
    required this.received,
    required this.sent,
    required this.heartsReceived,
    required this.secretBoxOpened,
    required this.secretBoxUnopened,
  });

  final int received;
  final int sent;
  final int heartsReceived;
  final int secretBoxOpened;
  final int secretBoxUnopened;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KudosStats &&
          other.received == received &&
          other.sent == sent &&
          other.heartsReceived == heartsReceived &&
          other.secretBoxOpened == secretBoxOpened &&
          other.secretBoxUnopened == secretBoxUnopened;

  @override
  int get hashCode => Object.hash(
      received, sent, heartsReceived, secretBoxOpened, secretBoxUnopened);
}
