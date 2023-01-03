library zepar;

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';

class ZeparClient {
  /// Sends a GET request to the specified [url] and returns the resulting
  /// HTML [Document].
  ///
  /// An optional [headers] map can be provided to send additional HTTP headers
  /// with the request. An optional [cookies] map can be provided to include
  /// cookies in the request. If both [headers] and [cookies] are provided,
  /// the cookies will be added to the `Cookie` header in the [headers] map.
  ///
  /// If the server returns a status code other than 200, an [Exception] will
  /// be thrown with the message "Failed to load [url]".
  static Future<Document> get(
    String url, {
    Map<String, String>? headers,
    Map<String, String>? cookies,
  }) async {
    final uri = Uri.parse(url);
    if (cookies != null) {
      headers ??= {};
      headers['Cookie'] =
          cookies.entries.map((e) => '${e.key}=${e.value}').join('; ');
    }
    final response = await Client().get(uri, headers: headers);
    if (response.statusCode == 200) {
      return parse(response.body);
    } else {
      throw Exception('Failed to load $url');
    }
  }
}
