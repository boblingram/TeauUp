import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:teamup/controllers/RootController.dart';
import 'package:teamup/utils/app_strings.dart';
import 'package:teamup/views/HomeView.dart';
import '../../mixins/baseClass.dart';
import '../../models/slider_model.dart';
import '../../utils/app_colors.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> with BaseClass {
  List<SliderModel> slides = <SliderModel>[];
  int currentIndex = 0;
  late PageController _controller;
  final ValueNotifier<int> _pageNotifier = ValueNotifier<int>(0);

  final RootController rootController = Get.find();

  void moveToPreviousPage() {
    if (currentIndex > 0) {
      currentIndex = currentIndex - 1;
    }
    animatePage();
  }

  void moveToNextPage() {
    currentIndex = currentIndex + 1;

    animatePage();
  }

  void moveToCreateGoalPage() {
    rootController.navigateToCreateGoalPage();
  }

  void animatePage() {
    _controller.animateToPage(currentIndex,
        duration: const Duration(milliseconds: 500), curve: Curves.ease);
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
    slides = getSlides();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              SizedBox(
                height: Get.height * 0.7,
                child: PageView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: _controller,
                    onPageChanged: (value) {
                      setState(() {
                        currentIndex = value;
                        _pageNotifier.value = value;
                      });
                    },
                    itemCount: slides.length,
                    itemBuilder: (context, index) {
                      // contents of slider
                      return Slider(
                        image: slides[index].getImage()!,
                        title: slides[index].getTitle()!,
                        subTitle: slides[index].getSubTitle()!,
                      );
                    }),
              ),
              Center(
                child: CirclePageIndicator(
                  currentPageNotifier: _pageNotifier,
                  itemCount: slides.length,
                  selectedDotColor: AppColors.red,
                  dotColor: AppColors.darkGrey,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 50, left: 20, right: 20),
                child: InkWell(
                  onTap: () {},
                  child: currentIndex == 0
                      ? InkWell(
                          onTap: () {
                            moveToNextPage();
                          },
                          child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: AppColors.red,
                              borderRadius: BorderRadius.circular(
                                8,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                AppStrings.next,
                                style: GoogleFonts.poppins(
                                  color: AppColors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  moveToPreviousPage();
                                  setState(() {});
                                },
                                child: Container(
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    border: Border.all(color: AppColors.black),
                                    borderRadius: BorderRadius.circular(
                                      8,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      AppStrings.previous,
                                      style: GoogleFonts.poppins(
                                        color: AppColors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  if (currentIndex == 1) {
                                    moveToNextPage();
                                  } else {
                                    moveToCreateGoalPage();
                                  }
                                },
                                child: Container(
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: AppColors.red,
                                    borderRadius: BorderRadius.circular(
                                      8,
                                    ),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding:  EdgeInsets.symmetric(horizontal: 5.0),
                                      child: Text(
                                        currentIndex == 1
                                            ? AppStrings.next
                                            : AppStrings.letsStart,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          color: AppColors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.white,
        ),
      ),
    );
  }

  Widget buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 10 : 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: currentIndex == index ? AppColors.red : AppColors.blue,
      ),
    );
  }
}

class Slider extends StatelessWidget {
  final String image;
  final String title;

  final String subTitle;

  Slider({
    Key? key,
    required this.image,
    required this.title,
    required this.subTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        /*mainAxisAlignment: MainAxisAlignment.center,*/
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // image given in slider
          const SizedBox(height: 25),
          Align(
            alignment: Alignment.center,
            child: Lottie.asset(image, height: Get.height * 0.5),
          ),
          const SizedBox(height: 25),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
                color: AppColors.black, fontSize: 28, fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            subTitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
                color: AppColors.black, fontSize: 20, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}

List<SliderModel> getSlides() {
  List<SliderModel> slides = <SliderModel>[];
  SliderModel sliderModel = SliderModel();

  // 1
  sliderModel.setImage("assets/lottie_files/goal_achieved.json");
  sliderModel.setTitle(AppStrings.setGoals);
  sliderModel.setSubTitle(AppStrings.setGoalsDescription);
  slides.add(sliderModel);

  sliderModel = SliderModel();

  // 2
  sliderModel.setImage("assets/lottie_files/invite.json");
  sliderModel.setTitle(AppStrings.inviteFriends);
  sliderModel
      .setSubTitle(AppStrings.inviteFriendsDescription);
  slides.add(sliderModel);

  sliderModel = SliderModel();

  // 3
  sliderModel.setImage("assets/lottie_files/progress.json");
  sliderModel.setTitle(AppStrings.trackProgress);
  sliderModel.setSubTitle(
      AppStrings.trackProgressDescription);
  slides.add(sliderModel);

  sliderModel = SliderModel();
  return slides;
}
