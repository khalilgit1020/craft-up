import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:graduation/constants.dart';
import '../models/boarding_model.dart';
import 'auth/login_screen.dart';
import '../helpers/cache_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';




// to get latitude and longitude and store it in firebase

late Position cPosition;
LocationPermission? locationPermission;
checkIfLocationPermissionAllowedd() async {
  locationPermission = await Geolocator.requestPermission();

  if (locationPermission == LocationPermission.denied) {
    locationPermission = await Geolocator.requestPermission();
  }
}
getPositionn()async{

  cPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
}




class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardController = PageController();

  List<BoardingModel> boarding = [
    BoardingModel(
      image: 'assets/images/OnBoarding1.jpeg',
      title: 'مرحبا بك في تطبيق \nCraft Up',
      body: 'Body Screen 1',
    ),
    BoardingModel(
      image: 'assets/images/OnBoarding2.jpg',
      title: 'بإمكانك عقد اتفاقاتك العملية وإيجاد فرصة عمل تناسبك مهما كانت حرفتك',
      body: 'Body Screen 2',
    ),
    BoardingModel(
      image: 'assets/images/OnBoarding3.jpg',
      title: 'بإمكانك استخدام التطبيق بكل سهولة ودون تعقيدات',
      body: 'Body Screen 3',
    ),
  ];

  bool isLast = false;

  void submit(){
    CacheHelper.saveData(key: 'onBoarding', value: true).then((value){
      if(value){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CraftLoginScreen()),
        );
      }
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfLocationPermissionAllowedd();
    getPositionn();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: FadeIn(
            duration: const Duration(milliseconds: 500),
            child: Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      margin: const EdgeInsets.only(top: 100),
                      child: PageView.builder(
                        controller: boardController,
                        physics: const BouncingScrollPhysics(),
                        onPageChanged: (int index) {
                          if (index == boarding.length - 1) {
                            setState(() {
                              isLast = true;
                            });
                          } else {
                            setState(() {
                              isLast = false;
                            });
                          }
                        },
                        itemCount: boarding.length,
                        itemBuilder: (context, index) {
                          return buildBoardingItem(boarding[index]);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SmoothPageIndicator(
                      controller: boardController,
                      effect: ExpandingDotsEffect(
                        dotColor: Colors.grey,
                        activeDotColor: mainColor,
                        dotHeight: 10.0,
                        expansionFactor: 3.0,
                        dotWidth: 10.0,
                        spacing: 5,
                      ),
                      count: boarding.length,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8,vertical: 60),
                    width: MediaQuery.of(context).size.width / 1.5,
                    decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    height: 60,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_)=> const CraftLoginScreen()),
                        );
                      },
                      child:const Center(
                        child: Text(
                          'بدء الاستخدام',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        //  textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buildBoardingItem(BoardingModel model) => Container(
    width: double.infinity,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(model.image),
      )
    ),
    child: Padding(
      padding: const EdgeInsets.only(top: 180.0),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          model.title,
          style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 28,
              color: mainColor,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}
