import 'package:flutter_test/flutter_test.dart';
import 'package:zepar/zepar.dart';

void main() {
  test('get H1 from example.com', () async {
    final document = await ZeparClient.get('https://example.com');
    expect(document.querySelector('h1')?.text, 'Example Domain');
  });

  test('throw exception when non-200 status code', () async {
    expect(
      () async => await ZeparClient.get('https://example.com/404'),
      throwsException,
    );
  });
}
