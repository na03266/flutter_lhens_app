import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lhens_app/common/components/buttons/app_button.dart';
import 'package:lhens_app/common/theme/app_colors.dart';
import 'package:lhens_app/common/theme/app_text_styles.dart';
import 'package:go_router/go_router.dart';
import 'package:lhens_app/user/view/user_picker_screen.dart';
import 'package:lhens_app/user/model/user_pick_result.dart';

class ChatSettingsDrawer extends StatelessWidget {
  final String groupName;
  final int participantCount;
  final List<String> participants;
  final VoidCallback? onInvite;
  final VoidCallback? onLeave;

  const ChatSettingsDrawer({
    super.key,
    this.groupName = 'LH E&S 기획팀',
    this.participantCount = 5,
    this.participants = const [
      '홍길동 대리 | 경영지원팀',
      '홍길동 대리 | 경영지원팀',
      '홍길동 대리 | 경영지원팀',
      '홍길동 대리 | 경영지원팀',
      '홍길동 대리 | 경영지원팀',
    ],
    this.onInvite,
    this.onLeave,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Drawer(
      backgroundColor: AppColors.white,
      shape: const ContinuousRectangleBorder(),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _HeaderRow(title: groupName),
            Expanded(
              child: ListView(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
                children: [
                  // 참여자 + 초대하기
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: AppColors.border, width: 1),
                        bottom: BorderSide(color: AppColors.border, width: 1),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('참여자', style: AppTextStyles.pb14.copyWith(color: AppColors.text)),
                            SizedBox(width: 2.w),
                            Text('$participantCount', style: AppTextStyles.pb14.copyWith(color: AppColors.secondary)),
                            Text('명', style: AppTextStyles.pb14.copyWith(color: AppColors.text)),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        AppButton(
                          text: '초대하기',
                          type: AppButtonType.outlined,
                          onTap: onInvite ?? () async {
                            final res = await GoRouter.of(context)
                                .pushNamed<UserPickResult>(UserPickerScreen.routeName);
                            if (res != null && res.members.isNotEmpty) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${res.members.length}명을 초대했습니다.'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              }
                            }
                          },
                          height: 48.h,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.h),

                  // 참여자 리스트
                  ...participants.map((p) => _ParticipantTile(nameAndDept: p)).toList(),

                  SizedBox(height: 12.h),

                  // 채팅방 나가기
                  InkWell(
                    onTap: onLeave ?? () {},
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('채팅방 나가기', style: AppTextStyles.pb14.copyWith(color: AppColors.text)),
                          SizedBox(width: 4.w),
                          const Icon(Icons.exit_to_app, size: 20, color: AppColors.text),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: bottomInset),
          ],
        ),
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  final String title;
  const _HeaderRow({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58.h,
      padding: EdgeInsets.only(top: 14.h, left: 24.w, right: 12.w, bottom: 12.h),
      decoration: const BoxDecoration(color: AppColors.white),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.psb18.copyWith(color: AppColors.text),
            ),
          ),
          // 두 개의 아이콘 자리 (디자인 참고용, 동작은 없음)
          _SquareIcon(child: const Icon(Icons.search, size: 20, color: AppColors.text)),
          SizedBox(width: 4.w),
          _SquareIcon(child: Transform.rotate(angle: -0.79, child: const Icon(Icons.send, size: 18, color: AppColors.text))),
        ],
      ),
    );
  }
}

class _SquareIcon extends StatelessWidget {
  final Widget child;
  const _SquareIcon({required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32.w,
      height: 32.w,
      child: Center(child: child),
    );
  }
}

class _ParticipantTile extends StatelessWidget {
  final String nameAndDept;
  const _ParticipantTile({required this.nameAndDept});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
      child: Text(
        nameAndDept,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.pm15.copyWith(color: AppColors.text),
      ),
    );
  }
}
