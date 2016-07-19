// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that looks up messages for specific locales by
// delegating to the appropriate library.

import 'dart:async';

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';
import 'package:intl/src/intl_helpers.dart';

import 'messages_sv.dart' as messages_sv;

//Map<String, Function> _deferredLibraries = {
//  'sv': () => messages_sv.loadLibrary(),
//};

MessageLookupByLibrary _findExact(localeName) {
  switch (localeName) {
    case 'sv':
      return messages_sv.messages;
    default:
      return null;
  }
}

/// User programs should call this before using [localeName] for messages.
initializeMessages(String localeName) {
  initializeInternalMessageLookup(() => new CompositeMessageLookup());
  //var lib = _deferredLibraries[Intl.canonicalizedLocale(localeName)];

  messageLookup.addLocale(localeName, _findGeneratedMessagesFor);

  //var load = lib == null ? new Future.value(false) : lib();
  //return load.then((_) =>
  //    messageLookup.addLocale(localeName, _findGeneratedMessagesFor));
}

MessageLookupByLibrary _findGeneratedMessagesFor(locale) {
  var actualLocale = Intl.verifiedLocale(locale, (x) => _findExact(x) != null,
      onFailure: (_) => null);
  if (actualLocale == null) return null;
  return _findExact(actualLocale);
}
