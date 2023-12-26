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
  final bool myComment;
  final VoidCallback? onDeleteTap;

  const CommentCard({
    this.user,
    super.key,
    this.onTapSend,
    this.content,
    this.storyId,
    this.myComment = false,
    this.onDeleteTap,
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
      child: Stack(
        children: [
          Row(
            children: [
              SizedBox(
                child: widget.user!.profilePhoto != null
                    ? CircleAvatar(
                        radius: 36,
                        backgroundImage: NetworkImage(
                          widget.user!.profilePhoto!,
                        ),
                      )
                    : const CircleAvatar(
                        radius: 36,
                        backgroundImage: AssetImage(
                          'assets/images/profilePic.jpg',
                        ),
                      ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.user!.username != null)
                    Text('@${widget.user!.username!}'),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.60,
                        child: AppTextFormField(
                          maxLines: 2,
                          readOnly: widget.content != null ? true : false,
                          controller: controller,
                          hintText: 'Write your comment...',
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
          if (widget.myComment)
            Positioned(
              top: -16,
              right: -12,
              child: SizedBox(
                width: 60,
                height: 60,
                child: Center(
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          widget.onDeleteTap?.call();
                        },
                        icon: const Icon(
                          Icons.delete,
                          size: 20,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
