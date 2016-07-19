import "dart:html";
import "dart:async";
import "package:intl/intl.dart";
import "package:converter/locale/messages_all.dart";

class TranslatedComponent {
  TranslatedComponent() {
    initializeMessages(Intl.systemLocale);
  }

  String text(String text, String name) {
    return Intl.message(text, name: name, args: [], desc: "");
  }
}
