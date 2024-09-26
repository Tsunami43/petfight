class InviteLink {
  late Uri url;

  InviteLink({
    required int telegramId,
  }) {
    final String urlShare = 'https://t.me/petfight_bot?start=$telegramId';
    const String text = 'Play with me, become a cryptoexchange NFT and get a token airdrop!\n\n💸  1000♛ Coins as a first-time gift';
    url = Uri.parse(
      'https://t.me/share/url?url=${Uri.encodeComponent(urlShare)}&text=${Uri.encodeComponent(text)}',
    );
  }
 @override
  String toString() => url.toString();

  Uri toUri() => url;
}