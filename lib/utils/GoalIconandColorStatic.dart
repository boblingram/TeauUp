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
    AppColors.customIconBG
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
      case "Cycling":
      default:
        return AppImages.cyclingIcon;
    }
  }
}
