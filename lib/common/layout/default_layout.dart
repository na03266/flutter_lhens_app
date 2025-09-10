import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../drawer/view/drawer.dart';
import '../const/appColorPicker.dart';

class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Widget child;
  final String? title;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  const DefaultLayout({
    super.key,
    required this.child,
    this.backgroundColor,
    this.title,
    this.bottomNavigationBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    final isHome = location.startsWith('/home');

    // 홈 화면은 AppBar를 숨김, 그 외 페이지는 공통 AppBar 제목 사용
    final title = isHome ? null : _getAppBarTitle(location);

    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,

      appBar: renderAppBar(context, title, isHome),

      endDrawer: CustomDrawer(),
      body: child,
      // bottomNavigationBar: bottomNavigationBar,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedFontSize: 12.0,
        unselectedFontSize: 12.0,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: _getIndex(location),
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/risk');
              break;
            case 1:
              context.go('/chat');
              break;
            case 2:
              context.go('/home');
              break;
            case 3:
              context.go('/alarm');
              break;
            case 4:
              context.go('/menual');
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset("asset/image/menu/risk.png"),
            label: '위험신고',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("asset/image/menu/chat.png"),
            label: '커뮤니케이션',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("asset/image/menu/home.png"),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("asset/image/menu/alarm.png"),
            label: '알림',
          ),
          BottomNavigationBarItem(
            icon: Image.asset("asset/image/menu/manual.png"),
            label: '업무매뉴얼',
          ),
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }

  void openPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(title: const Text('Second page')),
            body: const Center(
              child: Text(
                'This is the Second page',
                style: TextStyle(fontSize: 24),
              ),
            ),
          );
        },
      ),
    );
  }

  AppBar? renderAppBar(BuildContext context, String? title, bool isHome) {
    // 타이틀이 빈 문자열이면 아예 텍스트 위젯도 안 넣기
    if (title == null) return null;

    return AppBar(
      backgroundColor: isHome ? AppColors.darkBlueColor : Colors.white,
      // 홈일 때 색상 변경
      foregroundColor: isHome ? Colors.white : Colors.black,
      // 글자색도 홈일 때 변경 가능
      elevation: 0.5,
      // 왼쪽: 뒤로가기 버튼 (뒤로갈 수 있을 때만)
      leading: Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            )
          : null,

      title: Text(
        title,
        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
      ),
      // 오른쪽: 햄버거 메뉴 버튼 → endDrawer 열기
      actions: [
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
          ),
        ),
      ],
    );
  }

  int _getIndex(String location) {
    if (location.startsWith('/risk')) return 0;
    if (location.startsWith('/chat')) return 1;
    if (location.startsWith('/home')) return 2;
    if (location.startsWith('/alarm')) return 3;
    if (location.startsWith('/menual')) return 4;
    return 2;
  }

  String _getAppBarTitle(String location) {
    if (location.startsWith('/risk')) return '위험신고';
    if (location.startsWith('/chat')) return '커뮤니케이션';
    if (location.startsWith('/home')) return '홈';
    if (location.startsWith('/alarm')) return '알림';
    if (location.startsWith('/menual')) return '업무매뉴얼';
    if (location.startsWith('/notice')) return '공지사항';
    return '';
  }
}
