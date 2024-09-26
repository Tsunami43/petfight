import 'package:flutter/material.dart';
import 'package:petfight/constants.dart';
import 'package:petfight/models/custom_text.dart';
import 'package:petfight/models/invite_link.dart';
import 'package:petfight/models/user.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({
    super.key,
  });

  Future<void> _launchInTelegram({required InviteLink inviteLink}) async {
    if (!await canLaunchUrl(inviteLink.toUri())) {
      throw 'Could not launch $inviteLink';
    }
    await launchUrl(inviteLink.toUri());
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context, listen: false);

    return LayoutBuilder(
      builder: (context, constraints) {
        double topPadding = constraints.maxHeight * 0.3;
        double bottomPadding = constraints.maxHeight * 0.2;
        double leftPadding = constraints.maxWidth * 0.1;
        double rightPadding = constraints.maxWidth * 0.1;

        return Stack(
          children: [
            Image.asset(
              ImagesPath.friendsBoard,
              fit: BoxFit.cover,
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 16,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Transform.rotate(
                  angle: 0.05,
                  child: ElevatedButton(
                    onPressed: () {
                      _launchInTelegram(inviteLink: user.inviteLink);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 73, 73, 73).withOpacity(0.9),
                      side: const BorderSide(color: Colors.black, width: 4),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      child: CustomText(
                        data: 'Invite friends',
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(
                  top: topPadding,
                  bottom: bottomPadding,
                  left: leftPadding,
                  right: rightPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      data: 'Count referrals: ${user.referrals.length}',
                      fontSize: 24.0,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                    const SizedBox(height: 5),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: user.referrals.length,
                        itemBuilder: (context, index) {
                          final referral = user.referrals[index];
                          return CustomTextRow(
                            partOne: '@${referral.username}',
                            partTwo: ' +${referral.claimedTokens}♛',
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
