import 'dart:async';
import 'package:app_links/app_links.dart';

class DeepLinkData {
  final String? transactionId;
  final String? status;
  final String? orderCode;
  final String? paymentMethod;

  DeepLinkData({
    this.transactionId,
    this.status,
    this.orderCode,
    this.paymentMethod,
  });

  factory DeepLinkData.fromUri(Uri uri) {
    return DeepLinkData(
      transactionId: uri.queryParameters['transactionId'],
      status: uri.queryParameters['status'],
      orderCode: uri.queryParameters['orderCode'],
      paymentMethod: uri.queryParameters['paymentMethod'],
    );
  }
}

class DeepLinkService {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  Future<Uri?> getInitialLink() => _appLinks.getInitialLink();

  Stream<Uri> get uriStream => _appLinks.uriLinkStream;

  Future<void> init(void Function(Uri uri) onLink) async {
    final initial = await getInitialLink();
    if (initial != null) onLink(initial);

    _sub = uriStream.listen(onLink);
  }

  void dispose() {
    _sub?.cancel();
  }

  static String toGoRouterLocation(Uri uri) {
    final route = '/${uri.host}${uri.path}';

    return route +
        (uri.hasQuery ? '?${uri.query}' : '');
  }
}