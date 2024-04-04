import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:social/features/domain/entities/replay/replay_entity.dart';
import 'package:social/injection_container.dart' as injection;
import '../../../../../../constants.dart';
import '../../../../../domain/use_cases/firebase_usecases/user/get_current_uid_usecase.dart';
import '../../../profile/widgets/profile_widget.dart';

class SingleReplayWidget extends StatefulWidget {
  const SingleReplayWidget(
      {super.key,
      required this.replay,
      this.onLongPressListener,
      this.onLikeClickListener});
  final ReplayEntity replay;
  final Function()? onLongPressListener;
  final VoidCallback? onLikeClickListener;
  @override
  State<SingleReplayWidget> createState() => _SingleReplayWidgetState();
}

class _SingleReplayWidgetState extends State<SingleReplayWidget> {
  String _currentUid = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    injection.serviceLocator<GetCurrentUIDUseCase>().callback().then((value) {
      setState(() {
        _currentUid = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onLongPress: widget.replay.creatorUID == _currentUid ? widget.onLongPressListener:null,
        child: Container(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 28,
                        height: 28,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: profileWidget(
                              imageUrl: "${widget.replay.userProfileUrl}"),
                        ),
                      ),
                      sizeHorizontal(5),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .45,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("${widget.replay.username}",
                                          style: const TextStyle(
                                              fontFamily: "Roboto",
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: black87)),
                                      Text(
                                          DateFormat.jm().format(widget
                                              .replay.createdAt!
                                              .toDate()),
                                          style: TextStyle(
                                              fontFamily: "Roboto",
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                              color: grey400)),
                                    ],
                                  ),
                                ],
                              ),

                              ///comment text
                              Text("${widget.replay.description}",
                                  style: const TextStyle(
                                      fontFamily: "Roboto",
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54)),
                              sizeVertical(10),
                            ]),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 28,
                    height: 30,
                    child: IconButton(
                        onPressed: widget.onLikeClickListener,
                        icon: Icon(
                          widget.replay.likes!.contains(_currentUid)
                              ? EvaIcons.heart
                              : EvaIcons.heartOutline,
                          color: widget.replay.likes!.contains(_currentUid)
                              ? Colors.red
                              : black87,
                          size: 16,
                        )),
                  )
                ])));
  }
}
