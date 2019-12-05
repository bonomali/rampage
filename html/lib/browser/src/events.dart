// Copyright (c) 2019 the Rampage Project Authors.
// Please see the AUTHORS file for details. All rights reserved.
// Use of this source code is governed by a zlib license that can be found in
// the LICENSE file.

import 'dart:async';

import 'package:rampage_browser_interop/browser_interop.dart' as interop;
import 'package:rampage_html/browser/html.dart';
import 'package:rampage_html/browser/src/js_wrapper.dart';
import 'package:rampage_html/html.dart';

import 'js_wrapper.dart';

//-----------------------------------------------------------
// Event
//-----------------------------------------------------------

/// Browser implementation of [Event].
class EventImpl<T extends interop.Event> extends JsWrapper<T> implements Event {
  /// Create an instance of [EventImpl] from the [jsObject].
  EventImpl.fromJsObject(T jsObject) : super.fromJsObject(jsObject);

  @override
  String get type => jsObject.type;

  @override
  EventTarget get target => safeEventTargetFromJsObject(jsObject.target);

  @override
  EventTarget get currentTarget =>
      safeEventTargetFromJsObject(jsObject.currentTarget);

  @override
  bool get bubbles => jsObject.bubbles;

  @override
  bool get cancelable => jsObject.cancelable;

  @override
  bool get composed => jsObject.composed;

  @override
  void preventDefault() {
    jsObject.preventDefault();
  }

  @override
  void stopImmediatePropagation() {
    jsObject.stopImmediatePropagation();
  }

  @override
  void stopPropagation() {
    jsObject.stopPropagation();
  }
}

//-----------------------------------------------------------
// CustomEvent
//-----------------------------------------------------------

/// Browser implementation of [CustomEvent].
class CustomEventImpl extends EventImpl<interop.CustomEvent>
    implements CustomEvent {
  /// Creates an instance of [CustomEventImpl].
  factory CustomEventImpl(
    String type, {
    bool bubbles = false,
    bool cancelable = false,
    bool composed = false,
    dynamic detail,
  }) =>
      CustomEventImpl.fromJsObject(interop.CustomEvent(
        type,
        interop.CustomEventInit(
          bubbles: bubbles,
          cancelable: cancelable,
          composed: composed,
          detail: detail,
        ),
      ));

  /// Creates an instance of [CustomEventImpl] from the [jsObject].
  CustomEventImpl.fromJsObject(interop.CustomEvent jsObject)
      : super.fromJsObject(jsObject);

  @override
  dynamic get detail => jsObject.detail;
}

//-----------------------------------------------------------
// EventTarget
//-----------------------------------------------------------

/// Browser implementation of [EventTarget].
class EventTargetImpl<T extends interop.EventTarget> extends JsWrapper<T>
    implements EventTarget {
  /// Creates an instance of [EventTargetImpl] from the [jsObject].
  EventTargetImpl.fromJsObject(T jsObject) : super.fromJsObject(jsObject);

  @override
  final Map<String, Stream<Event>> on = <String, Stream<Event>>{};

  @override
  bool dispatchEvent(Event event) =>
      jsObject.dispatchEvent((event as EventImpl).jsObject);
}

//-----------------------------------------------------------
// Utility
//-----------------------------------------------------------

/// Creates an instance of [T] from the [jsObject].
T eventTargetFromJsObject<T extends EventTarget>(interop.EventTarget jsObject) {
  if (jsObject is interop.Element) {
    return elementFromJsObject(jsObject) as T;
  }

  assert(false, 'Unknown event target');
  return null;
}

/// Creates an instance of [T] from the [jsObject].
///
/// This function should be used when its unclear if the [jsObject] has already
/// has already been wrapped.
T safeEventTargetFromJsObject<T extends EventTarget>(
        interop.EventTarget jsObject) =>
    jsObject.dartObject as T ?? eventTargetFromJsObject(jsObject);
