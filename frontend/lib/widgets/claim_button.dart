import 'dart:async';
import 'package:flutter/material.dart';
import 'package:petfight/api/claim_api.dart';
import 'package:petfight/constants.dart';
import 'package:petfight/models/custom_text.dart';
import 'package:petfight/models/user.dart';
import 'package:provider/provider.dart';

class ClaimButtonWithTimer extends StatefulWidget {
  const ClaimButtonWithTimer({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ClaimButtonWithTimerState createState() => _ClaimButtonWithTimerState();
}

class _ClaimButtonWithTimerState extends State<ClaimButtonWithTimer> {
  Timer? _timer;
  Duration _remainingTime = const Duration(seconds: 28800); // 8 hours in seconds

  @override
  void initState() {
    super.initState();
    _initClaimedState();
  }

  void _initClaimedState() {
    User user = Provider.of<User>(context, listen: false);
    if (user.claimed.canClaimAgain()) {
      int secondsPassed = user.claimed.calculateDurationInSeconds();
      if (secondsPassed < 28800) {
        _remainingTime = Duration(seconds: 28800 - secondsPassed);
        _startTimer();
      }
    }
  }


  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime -= const Duration(seconds: 1);
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  void _claimTokens(User user) async {
    InfoProvider infoProvider = Provider.of<InfoProvider>(context, listen: false);

    infoProvider.setView(true);
    bool response = await postClaimed(token: Provider.of<User>(context, listen: false).jwtToken);
    if (response) {
      user.updateBalance(coins: 100);
      user.claimed.timestamp = DateTime.now();
      infoProvider.setView(false);
      if (mounted) {
        setState(() {
          _remainingTime = const Duration(seconds: 28800); // Сброс времени до следующего клейма
          _startTimer(); // Перезапуск таймера после клейма
        });
      }
    }
    else {
      infoProvider.setMessage('Reload app');
    }
    
  }


  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
        color: user.claimed.canClaimAgain()
            ? const Color.fromARGB(255, 73, 73, 73).withOpacity(0.9)
            : const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(25.0),
        border: Border.all(
          color: Colors.black,
          width: 3.0,
        ),
      ),
      child: user.claimed.canClaimAgain()
          ? ElevatedButton(
              onPressed: null,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: CustomText(
                  data: _formatTime(_remainingTime),
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            )
          : ElevatedButton(
              onPressed: () => _claimTokens(user),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Consumer<User>(
                  builder: (context, user, child) {
                    return CustomText(
                      data: user.claimed.canClaimAgain() ? "Wait" : "Claim ♛",
                      color: user.claimed.canClaimAgain() ? Colors.white : Colors.red,
                      fontSize: 24,
                    );
                  },
                ),
              ),
            ),
    );
  }

  String _formatTime(Duration duration) {
    String hours = (duration.inHours).toString().padLeft(2, '0');
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }
}
