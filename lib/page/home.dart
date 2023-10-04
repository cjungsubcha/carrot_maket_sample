import 'package:carrot_maket_sample/repository/contents_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String currentLocation;
  ContentsRepository? contentsRepository;
  final Map<String, String> locationTypeToString = {
    'ara': '아라동',
    'ora': '오라동',
    'donam': '도남동'
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentLocation = 'ara';
    contentsRepository = ContentsRepository();
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          //print('click');
        },
        child: PopupMenuButton<String>(
          //팝업이 나타나는 위치를 변경한다. 현재 무슨 동인지 가리는 것을 방지하기 위해 벼경한다.
          offset: const Offset(0, 26),
          //팝업에 라운드를 넣어서 브드럽게 한다.
          shape: ShapeBorder.lerp(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              1),
          onSelected: (String where) {
            print(where);
            setState(() {
              currentLocation = where;
            });
          },
          itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem(value: 'ara', child: Text('아라동')),
              const PopupMenuItem(value: 'ora', child: Text('오라동')),
              const PopupMenuItem(value: 'donam', child: Text('도남동')),
            ];
          },
          child: Row(
            children: [
              Text(locationTypeToString[currentLocation] ?? ''),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
      elevation: 0,
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.tune)),
        IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              'assets/svg/bell.svg',
              width: 20,
            )),
      ],
    );
  }

  //숫자 금액을 받아서 문자열 ,를 찍어 보여준다.
  final oCcy = NumberFormat("#,###", "ko_KR");
  String calcStringToWon(String priceString) {
    return "${oCcy.format(int.parse(priceString))} 원";
  }

  _loadContents() {
    return contentsRepository?.loadContentsFromLocation(currentLocation);
  }

  _makeDataList(List<Map<String, String>> datas) {
    //List<Map<String, String>> datas = snapshot.data;
    //사용시 요소 중간을 디자인 할수 있다.
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: Image.asset(
                  datas[index]["image"].toString(),
                  width: 100,
                  height: 100,
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(datas[index]["title"].toString(),
                          style: const TextStyle(fontSize: 14),
                          //택스트가 줄을 넘어가면 ... 처리를 한다.
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        datas[index]["location"].toString(),
                        style: TextStyle(
                            fontSize: 12, color: Colors.black.withOpacity(0.5)),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        calcStringToWon(datas[index]["price"].toString()),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SvgPicture.asset(
                            'assets/svg/heart_off.svg',
                            width: 12,
                            height: 12,
                          ),
                          const SizedBox(width: 3),
                          Text(datas[index]["likes"].toString()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      itemCount: 20,
      //컨테이너와 컨테이너 중간에 라인을 긋는 디자인을 할 수 있다.
      separatorBuilder: (BuildContext context, int index) {
        return Container(
          height: 1,
          color: Colors.black.withOpacity(0.3),
        );
      },
    );
  }

  Widget _bodyWidget() {
    return FutureBuilder<List<Map<String, String>>>(
      future: _loadContents(),
      builder: (BuildContext context,
          AsyncSnapshot<List<Map<String, String>>> snapshot) {
        // 데이터 불러오는 중 데이터 오류 잡기 및 진행상태 보이기
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        //snapshot에 데이터 오류가 있을 경우
        if (snapshot.hasError) {
          return const Center(child: Text('데이터 오류'));
        }

        //snapshot에 데이터가 있을 경우
        if (snapshot.hasData) {
          return _makeDataList(snapshot.data ?? []);
        }

        return const Center(
          child: Text('데이터 없음'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(), //해더
      body: _bodyWidget(), //몸통
    );
  }
}
