import 'package:carrot_maket_sample/page/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class App extends StatefulWidget {
  const App({super.key});
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  //페이지 인덱스 변수
  late int _currentPageIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //페이지 인덱스 초기화
    _currentPageIndex = 0;
    // 프로그램 실행시 데이터를 입력 할당한다.
  }

  Widget _bodyWidget() {
    switch (_currentPageIndex) {
      case 0:
        return const Home();
      //break;
      case 1:
        Container(child: const Center(child: Text('동네생활'),),);
      case 2:
        Container();
      case 3:
        Container();
      case 4:
        Container();
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
      bottomNavigationBar: _bottomNavigationBarwidget(), //하단 메뉴
    );
  }

  //반복되는 버튼을 메소드로 만들어 간소화한다.
  BottomNavigationBarItem _bottomNavigationBarItem(
      String iconName, String label) {
    return BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: SvgPicture.asset(
            'assets/svg/${iconName}_off.svg',
            width: 24,
          ),
        ),
        activeIcon: Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: SvgPicture.asset(
            'assets/svg/${iconName}_on.svg',
            width: 24,
          ),
        ),
        label: label);
  }

  Widget _bottomNavigationBarwidget() {
    return BottomNavigationBar(
      //클릭을 하는 경우 에니메이션을 제거한다.
      type: BottomNavigationBarType.fixed,
      //선택시 변경되는 폰트 사이즈를 고정한다.
      selectedFontSize: 12,
      //선택된 아이콘의 레이블 색을 변경한다.
      selectedItemColor: Colors.red,
      onTap: (int index) {
        setState(() {
          //페이지 인데스에 현재 선택된 인댁스를 데입한다.
          _currentPageIndex = index;
        });
      },
      currentIndex: _currentPageIndex,
      items: [
        _bottomNavigationBarItem('home', '홈'),
        _bottomNavigationBarItem('notes', '동네생활'),
        _bottomNavigationBarItem('location', '내근처'),
        _bottomNavigationBarItem('chat', '채팅'),
        _bottomNavigationBarItem('user', '나의당근'),
      ],
    );
  }
}
