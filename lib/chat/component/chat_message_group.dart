import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/components/user_avatar.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'chat_message_bubble.dart';

class ChatMessageGroup extends StatelessWidget {
  final ChatMessageSide side;
  final String? userName;
  final List<Widget> messages;

  const ChatMessageGroup({
    super.key,
    required this.side,
    required this.messages,
    this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final isRight = side == ChatMessageSide.right;

    if (isRight) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 294.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (int i = 0; i < messages.length; i++) ...[
                  messages[i],
                  if (i != messages.length - 1) SizedBox(height: 12.h),
                ],
              ],
            ),
          ),
        ],
      );
    }

    // left
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const UserAvatar(size: 37, iconSize: 20),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (userName != null)
                Text(
                  userName!,
                  style: AppTextStyles.pm14.copyWith(color: AppColors.text),
                ),
              if (userName != null) SizedBox(height: 12.h),
              for (int i = 0; i < messages.length; i++) ...[
                messages[i],
                if (i != messages.length - 1) SizedBox(height: 12.h),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
