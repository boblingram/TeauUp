class Constants{
  //Http Link
  static String BASEURL = "https://l6ehkopu7fcq5lglpxspaw5yyu.appsync-api.us-west-2.amazonaws.com/graphql";
  static String HEADER_API_KEY = "x-api-key";
  //static String API_KEY = "da2-afrlccepgjc5xhkwsfqy3bfidm";
  static String API_KEY = "da2-l3lglx2ihbajlbdenx56njjzbu";
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}