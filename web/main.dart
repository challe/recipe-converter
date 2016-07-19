import 'dart:html';

import 'package:angular2/platform/browser.dart';
import 'package:http/browser_client.dart';
import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:angular2/platform/common.dart';
import "package:intl/intl_browser.dart";

import 'package:converter/app_component.dart';

BrowserClient HttpClientBackendServiceFactory() => new BrowserClient();

void main() {
  startApp() {
    bootstrap(AppComponent, const [
      ROUTER_PROVIDERS,
      const Provider(LocationStrategy, useClass: HashLocationStrategy),
      const Provider(BrowserClient,
        useFactory: HttpClientBackendServiceFactory, deps: const [])
    ]);
  }

  findSystemLocale().then((_) {
    startApp();
  });
}
