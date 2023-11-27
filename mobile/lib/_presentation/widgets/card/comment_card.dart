import 'package:flutter/material.dart';
import 'package:swe/_core/widgets/base_widgets.dart';
import 'package:swe/_domain/auth/model/user.dart';
import 'package:swe/_domain/story/model/comment_model.dart';
import 'package:swe/_domain/story/model/postComment_model.dart';
import 'package:swe/_presentation/widgets/textformfield/app_text_form_field.dart';

class CommentCard extends StatefulWidget {
  final Function(PostCommentModel model)? onTapSend;
  final User? user;
  final String? content;
  final int? storyId;
  const CommentCard({
    this.user,
    super.key,
    this.onTapSend,
    this.content,
    this.storyId,
  });

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  late TextEditingController controller;

  @override
  void initState() {
    if (widget.content != null) {
      controller = TextEditingController(text: widget.content);
    } else {
      controller = TextEditingController();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    controller.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      elevation: 6,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 4,
        ),
        child: buildContent(context),
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    return Card(
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(
            child: Center(
              child: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/images/profilePic.jpg'),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('@${widget.user!.username!}'),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.60,
                    child: Expanded(
                      child: AppTextFormField(
                        maxLines: 2,
                        readOnly: widget.content != null ? true : false,
                        controller: controller,
                        hintText: 'Write your comment...',
                      ),
                    ),
                  ),
                  if (widget.onTapSend != null)
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        final comment = PostCommentModel(
                          commentText: controller.text,
                          storyId: widget.storyId,
                        );
                        controller.clear();
                        widget.onTapSend?.call(comment);
                      },
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
