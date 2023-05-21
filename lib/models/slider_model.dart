class SliderModel {
  String? image;
  String? title;

  String? subTitle;

// images given
  SliderModel({this.image, this.title, this.subTitle});

  // setter for image
  void setTitle(String getTitle) {
    title = getTitle;
  }

// getter for image
  String? getTitle() {
    return title;
  }

  // setter for image
  void setSubTitle(String getSub) {
    subTitle = getSub;
  }

// getter for image
  String? getSubTitle() {
    return subTitle;
  }

// setter for image
  void setImage(String getImage) {
    image = getImage;
  }

// getter for image
  String? getImage() {
    return image;
  }
}
