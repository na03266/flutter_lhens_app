import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/components/user_avatar.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:lhens_app/gen/assets.gen.dart';
import 'package:lhens_app/user/model/user_model.dart';
import 'chat_message_bubble.dart';

class ChatMessageGroup extends StatelessWidget {
  final ChatMessageSide side;
  final UserModel? user;
  final List<Widget> messages;

  const ChatMessageGroup({
    super.key,
    required this.side,
    required this.messages,
    this.user,
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
        UserAvatar(size: 37, iconSize: 2, icon: pickIcon(user)),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (user != null)
                Text(
                  user!.mbLevel >= 10
                      ? user!.mbName
                      : "(${user?.mb5}) ${user?.mbName}",
                  style: AppTextStyles.pm14.copyWith(color: AppColors.text),
                ),
              if (user != null) SizedBox(height: 12.h),
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

  AssetGenImage? pickIcon(UserModel? user) {
    if (user == null) {
      return null;
    }
    final reg = user.registerNum;

    if (reg.isEmpty) {
      return null; // 혹은 기본 아이콘
    }

    final firstDigit = int.tryParse(reg[0]);
    if (firstDigit == null) {
      return null; // 숫자로 시작 안 하면 처리
    }

    final isEvenStart = firstDigit.isEven;

    // 짝수로 시작하는 경우(여자) 아이콘
    if (isEvenStart) {
      switch (user.mb5) {
        case '경비':
          return Assets.chat.securityCharacter;
        case '급식관리':
          return Assets.chat.foodServiceCharacter;
        case '시설관리':
          return Assets.chat.facilityCharacter;
        case '안내':
          return Assets.chat.guideFCharacter;
        case '안전관리':
          return Assets.chat.safetyManagerCharacter;
        case '청소':
          return Assets.chat.cleaningFCharacter;
        case '취사':
          return Assets.chat.cookFCharacter;
        default:
          return Assets.chat.officeCharacter;
      }
    } else {
      switch (user.mb5) {
        case '경비':
          return Assets.chat.securityCharacter;
        case '급식관리':
          return Assets.chat.foodServiceCharacter;
        case '시설관리':
          return Assets.chat.facilityCharacter;
        case '안내':
          return Assets.chat.guideMCharacter;
        case '안전관리':
          return Assets.chat.safetyManagerCharacter;
        case '청소':
          return Assets.chat.cleaningMCharacter;
        case '취사':
          return Assets.chat.cookMCharacter;
        default:
          return Assets.chat.officeCharacter;
      }
    }
  }

  bool startsWithEven(String registerNum) {
    if (registerNum.isEmpty) return false;

    // 첫 글자
    final firstChar = registerNum[0];

    // 숫자로 변환
    final firstDigit = int.tryParse(firstChar);
    if (firstDigit == null) return false;

    // 짝수인지 체크
    return firstDigit.isEven; // 또는 (firstDigit % 2 == 0)
  }
}
