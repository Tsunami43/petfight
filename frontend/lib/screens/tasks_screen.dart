import 'package:flutter/material.dart';
import 'package:petfight/api/task_api.dart';
import 'package:petfight/constants.dart';
import 'package:petfight/models/custom_text.dart';
import 'package:petfight/models/task.dart';
import 'package:petfight/models/user.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskScreen extends StatelessWidget {

  const TaskScreen({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context, listen: false);
    
    return LayoutBuilder(
      builder: (context, constraints) {
        double topPadding = constraints.maxHeight * 0.2;
        double bottomPadding = constraints.maxHeight * 0.2;
        double leftPadding = constraints.maxWidth * 0.1;
        double rightPadding = constraints.maxWidth * 0.1;

        return Stack(
          children: [
            Image.asset(
              ImagesPath.taskBoard,
              fit: BoxFit.cover,
            ),
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(
                  top: topPadding,
                  bottom: bottomPadding,
                  left: leftPadding,
                  right: rightPadding,
                ),
                child: ListView.builder(
                  itemCount: user.tasks.length,
                  itemBuilder: (context, index) {
                    final task = user.tasks[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomTextRow(
                              partOne: task.name,
                              partTwo: task.rewardAsString,
                            ),
                          ),
                          const SizedBox(width: 8),
                          TaskButton(
                            task: task,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            
          ],
        );
      },
    );
  }
}

class TaskButton extends StatefulWidget {
  final Task task;

  const TaskButton({
    super.key,
    required this.task,
  });

  @override
  // ignore: library_private_types_in_public_api
  _TaskButtonState createState() => _TaskButtonState();
}

class _TaskButtonState extends State<TaskButton> {
  @override
  Widget build(BuildContext context) {

    return ElevatedButton(
      onPressed: _isButtonEnabled(widget.task.status) ? () => _onButtonPressed(widget.task) : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: _getButtonColor(widget.task.status),
        side: const BorderSide(color: Colors.black, width: 4),
      ),
      child: _buildButtonChild(widget.task.status),
    );
  }

  Color _getButtonColor(int taskStatus) {
    switch (taskStatus) {
      case 0:
        return const Color.fromARGB(255, 73, 73, 73).withOpacity(0.9);
      case 1:
        return const Color.fromARGB(255, 255, 255, 255).withOpacity(0.9);
      case 2:
        return const Color.fromARGB(255, 255, 255, 255);
      default:
        return const Color.fromARGB(255, 73, 73, 73);
    }
  }

  Widget _buildButtonChild(int taskStatus) {
    switch (taskStatus) {
      case 0:
        return CustomText(
          data: widget.task.textButton,
          fontSize: 16,
          color: Colors.white,
        );
      case 1:
        return const CustomText(
          data: 'Claim',
          fontSize: 16,
          color: Colors.red,
        );
      case 2:
        return const Icon(
          Icons.done_all_sharp,
          color: Colors.black,
        );
      default:
        return const Icon(
          Icons.done_all_sharp,
          color: Colors.white,
        );
    }
  }

  bool _isButtonEnabled(int taskStatus) {
    return taskStatus != 2;
  }

  void _onButtonPressed(Task task) async {
      switch (task.status) {
        case 0:
          setState(() {
          final url = task.url;
          if (url != null && url.isNotEmpty) {
            _launchInBrowser(strUrl: url);
            task.status = 1;
            }
          });
          break;
        case 1:
          InfoProvider infoProvider = Provider.of<InfoProvider>(context, listen: false);
          User user = Provider.of<User>(context, listen: false);

          infoProvider.setView(true);
          bool response = await postTask(token: user.jwtToken, taskKey: task.key);
          if (response) {
            user.updateBalance(coins: task.reward);
            infoProvider.setView(false);
            task.status = 2;
          }
          else {
            infoProvider.setMessage('Reload app');
          }
          break;
        case 2:
          break;
        default:
          break;
      }
  }

  Future<void> _launchInBrowser({required String strUrl}) async {
    final Uri url = Uri.parse(strUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $strUrl';
    }
  }
}
