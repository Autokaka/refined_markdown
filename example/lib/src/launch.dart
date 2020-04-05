import 'package:url_launcher/url_launcher.dart';

class Launch {
  static Launch _instance;
  static Launch getInstance() => _instance ??= Launch();

  Future<Null> url(String url) async {
    if (!await canLaunch(url)) return;
    await launch(url);
  }
}
