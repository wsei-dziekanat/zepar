library zepar;

import 'dart:convert';

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';

class ClientData {
  final Uri baseUrl;
  final Map<String, String> headers;

  ClientData({
    required this.baseUrl,
    required this.headers,
  });
}

class ZeparClient {
  // Static variable to store the client configuration
  static ClientData? _clientData;

  /// Sets the client configuration to be used by the [get] method.
  /// The [baseUrl] is the base URL for all requests.
  ///
  /// An optional [headers] map can be provided to send additional HTTP headers
  /// with the request. An optional [cookies] map can be provided to include
  /// cookies in the request. If both [headers] and [cookies] are provided,
  /// the cookies will be added to the `Cookie` header in the [headers] map.
  static void setClientData({
    required Uri baseUrl,
    Map<String, String> headers = const {},
    Map<String, String> cookies = const {},
  }) {
    headers['Cookie'] = cookies.entries.map((entry) {
      return '${entry.key}=${entry.value}';
    }).join('; ');
    _clientData = ClientData(
      baseUrl: baseUrl,
      headers: headers,
    );
  }

  /// Sends a GET request to the specified [path] and returns the resulting
  /// HTML [Document].
  ///
  /// If the server returns a status code other than 200, an [Exception] will
  /// be thrown with the message "Failed to load [url]".
  static Future<Document> get(String path) async {
    if (_clientData == null) {
      throw Exception('Client data not set');
    }
    final url = _clientData!.baseUrl.resolve(path);
    final response = await Client().get(url, headers: _clientData!.headers);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final body = utf8.decode(response.bodyBytes);
      return parse(body);
    }
    throw Exception('Failed to load $url');
  }
}
