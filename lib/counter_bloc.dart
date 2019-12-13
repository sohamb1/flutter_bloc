import 'dart:async';

import 'package:flutter_bloc/counter_event.dart';

class CounterBloc {
  int _counter = 0;

  // private. Its kind of a box which holds one for input and another for output.
  final _counterStateController = StreamController<int>();

  // private. inputs come here as it goes to Sink.
  StreamSink<int> get _inCounter => _counterStateController.sink;

  // public. As inputs come to sink, automatically outpput comes out of Stream
  Stream<int> get counter => _counterStateController.stream;
  // why public? we want out widgets to listen to only output Stream controller.


  final _counterEventController = StreamController<CounterEvent>();
  // Out UI will send events to this sink
  Sink<CounterEvent> get counterEventSink => _counterEventController.sink;

  CounterBloc() {
    // Whenever there is a new event, map it to a new state
    // Suppose increment event comes, it will be output through this stream and
    // we can listen to it and map it to subsequent map this event to new state.
    _counterEventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState (CounterEvent event) {
    if (event is IncrementEvent)
      _counter++;
    else
      _counter--;

    // add the new counter value to Sink of _counterStateController which will
    // then output its stream
    _inCounter.add(_counter);
  }

  // Note: Out UI will get exposed to only two properties
  // 1. counter Stream to output numbers
  // 2. counterEventSink which inputs events

  void dispose() {
    // dispose will close our Stream controllers otherwise we will get memory leaks
    _counterEventController.close();
    _counterStateController.close();
  }
}