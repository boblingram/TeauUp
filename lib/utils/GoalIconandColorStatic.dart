import 'app_Images.dart';
import 'app_colors.dart';

class GoalIconandColorStatic{

  static List<String> goalList = [
    "Wellness",
    "Yoga",
    "Study",
    "Cycling",
    "Running",
    "Walking",
    "Gym",
    "Introspection",
    "Sadhana",
    "Meditation",
    "Swimming",
    "Teamup",
    "Custom"
  ];

  static List<String> goalColorList = [
    AppColors.wellnessIconBG,
    AppColors.yogaIconBG,
    AppColors.studyIconBG,
    AppColors.cyclingIconBG,
    AppColors.runningIconBG,
    AppColors.walkingIconBG,
    AppColors.gymIconBG,
    AppColors.introspectionIconBG,
    AppColors.sadhanaIconBG,
    AppColors.meditationIconBG,
    AppColors.swimmingIconBG,
    AppColors.customIconBG,
    AppColors.teamupIconBG
  ];

  static String getColorName(String selectedGoal) {
    switch (selectedGoal) {
      case "Wellness":
        return AppColors.wellnessIconBG;
      case "Yoga":
        return AppColors.yogaIconBG;
      case "Study":
        return AppColors.studyIconBG;
      case "Cycling":
        return AppColors.cyclingIconBG;
      case "Running":
        return AppColors.runningIconBG;
      case "Walking":
        return AppColors.walkingIconBG;
      case "Gym":
        return AppColors.gymIconBG;
      case "Introspection":
        return AppColors.introspectionIconBG;
      case "Sadhana":
        return AppColors.sadhanaIconBG;
      case "Meditation":
        return AppColors.meditationIconBG;
      case "Swimming":
        return AppColors.swimmingIconBG;
      case "Teampup":
        return AppColors.teamupIconBG;
      default:
        return AppColors.customIconBG;
    }
  }

  static String getImageName(String elementAt) {
    switch (elementAt) {
      case "Wellness":
        return AppImages.wellnessIcon;
      case "Walking":
        return AppImages.walkingIcon;
      case "Yoga":
        return AppImages.yogaIcon;
      case "Study":
        return AppImages.studyIcon;
      case "Running":
        return AppImages.runningIcon;
      case "Gym":
        return AppImages.gymIcon;
      case "Introspection":
        return AppImages.introspectionIcon;
      case "Sadhana":
        return AppImages.sadhanaIcon;
      case "Meditation":
        return AppImages.meditationIcon;
      case "Swimming":
        return AppImages.swimmingIcon;
      case "Cycling":
        return AppImages.cyclingIcon;
      case "Teamup":
        return AppImages.teampIcon;
      default:
        return AppImages.addIcon;
    }
  }
}
