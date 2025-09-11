import '../../drawer/notice/view/board_screen.dart';
import '../../drawer/salary/view/salary_screen.dart';
import '../model/menu_model.dart';

final drawerMenus = [
  MenuModel(label: '급여명세서', route: SalaryScreen.routeName),
  MenuModel(label: '민원접수', route: '/civil'),
  MenuModel(label: '공지사항', route: NoticeScreen.routeName),
  MenuModel(label: '설문조사', route: '/survey'),
  MenuModel(label: '교육행사정보', route: '/event'),
  MenuModel(label: '위험신고', route: '/risk'),
  MenuModel(label: '업무매뉴얼', route: '/menual'),
];

