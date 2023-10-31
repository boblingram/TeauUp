import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:http_parser/http_parser.dart';

class APIService {
  late Dio _dio;

  //Moved DefaultHttpClientAdapter to IOclientadapter
  ApiService() {
    _dio = Dio();
    _dio.httpClientAdapter = IOHttpClientAdapter();
    /*(_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };*/
  }

  String? handleDioError(DioError err) {
    print("Error Type is ${err.type}");
    print("Error Message is ${err.message}");
    print("Real URL is ${err.response?.realUri}");
    try {
      print("Error Response is ${err.response}");
      String errMsg = err.response?.data["errors"]["message"];
      print("Error Msg $errMsg");
      return errMsg;
    } catch (e) {
      print("Error to Error Msg $e");
      //return "";
    }
  }

  Future<Response> uploadMediaDataServer(
    String url,
    String filePath,
    String extension,
  ) async {
    //var file = await MultipartFile.fromFile(filePath, contentType: MediaType("text", "plain"));
    //FormData temp = FormData.fromMap({"file": file});
    //print("Uploaded Data is ${temp.files}");
    File tempFile = File(filePath);
    print("Uploaded File URL $url");
    Options options = Options();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        options.contentType = 'image/jpeg';
        break;
      case 'png':
        options.contentType = 'image/png';
        break;
      case 'txt':
        options.contentType = 'text/plain';
        break;
      case 'pdf':
        options.contentType = 'application/pdf';
        break;
      case 'doc':
      case 'docx':
        options.contentType = 'application/msword';
        break;
      case 'csv':
        options.contentType = 'text/csv';
        break;
      case 'excel':
        options.contentType = 'application/vnd.ms-excel';
        break;
      case 'ppt':
      case 'pptx':
        options.contentType = 'application/vnd.ms-powerpoint';
        break;
      case 'mp3':
        options.contentType = "audio/mpeg";
        break;
      case 'mp4':
      case 'mov':
        options.contentType = 'video/mp4';
        break;
    }

    Response response = await Dio()
        .put(url, data: tempFile.readAsBytesSync(), options: options)
        .catchError((onError) {
      throw onError;
    });
    return response;
  }
}
