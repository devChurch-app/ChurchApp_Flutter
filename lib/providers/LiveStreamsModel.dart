import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import '../utils/ApiUrl.dart';
import '../models/LiveStreams.dart';

class LiveStreamsModel with ChangeNotifier {
  //List<Comments> _items = [];
  bool isError = false;
  bool isLoading = false;
  List<LiveStreams> livestreams;

  LiveStreamsModel() {
    loadItems();
  }

  loadItems() {
    isLoading = true;
    notifyListeners();
    fetchItems();
  }

  Future<void> fetchItems() async {
    try {
      /*final response = await http.post(ApiUrl.LIVESTREAMS,
          body: jsonEncode({
            "data": {"version": "v2"}
          }));
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        isLoading = false;
        isError = false;
        livestreams = await compute(parseLiveStreams, response.body);
        print("livestreams" + livestreams.toString());
        notifyListeners();
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        setFetchError();
      }*/

      final dio = Dio();
      // Adding an interceptor to enable caching.
      dio.interceptors.add(
        DioCacheManager(
          CacheConfig(baseUrl: ApiUrl.LIVESTREAMS),
        ).interceptor,
      );

      final response = await dio.post(
        ApiUrl.LIVESTREAMS,
        data: jsonEncode({
          "data": {"version": "v2"}
        }),
        options: buildCacheOptions(
          Duration(days: 3),
          maxStale: Duration(days: 7),
          options: (Options(contentType: 'application/json')),
        ),
      );

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        dynamic res = jsonDecode(response.data);
        livestreams = parseLiveStreams(res);
        isLoading = false;
        isError = false;
        notifyListeners();
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        setFetchError();
      }
    } catch (exception) {
      // I get no exception here
      print(exception);
      setFetchError();
    }
  }

  static List<LiveStreams> parseLiveStreams(dynamic res) {
    //final res = jsonDecode(responseBody);
    final parsed = res["livestreams"].cast<Map<String, dynamic>>();
    return parsed
        .map<LiveStreams>((json) => LiveStreams.fromJson(json))
        .toList();
  }

  setFetchError() {
    isError = true;
    isLoading = false;
    notifyListeners();
  }
}
