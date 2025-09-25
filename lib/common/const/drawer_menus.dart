import '../../drawer/notice/view/board_screen.dart';
import '../../chat/view/chat_screen.dart';
import '../../risk/view/risk_screen.dart';
import '../../menual/view/menual_screen.dart';

class DrawerMenuItem {
  final String label;
  final String routeName;

  const DrawerMenuItem(this.label, this.routeName);
}

class DrawerMenuGroup {
  final String title;
  final List<DrawerMenuItem> items;

  const DrawerMenuGroup(this.title, this.items);
}

final drawerMenuGroups = <DrawerMenuGroup>[
  DrawerMenuGroup('참여·신고', [
    DrawerMenuItem('설문조사', 'survey'),
    DrawerMenuItem('민원제안접수', 'civil'),
    DrawerMenuItem('위험신고', RiskScreen.routeName),
  ]),
  DrawerMenuGroup('소통', [
    DrawerMenuItem('커뮤니케이션', ChatScreen.routeName),
    DrawerMenuItem('공지사항', NoticeScreen.routeName),
  ]),
  DrawerMenuGroup('업무·자료', [
    DrawerMenuItem('급여명세서', 'salary'),
    DrawerMenuItem('업무매뉴얼', MenualScreen.routeName),
    DrawerMenuItem('교육행사정보', 'event'),
  ]),
];
