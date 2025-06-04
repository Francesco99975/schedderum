import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:schedderum/helpers/failure.dart';

class AsyncProviderOverwriter<T> extends StatelessWidget {
  final AsyncValue<Either<Failure, T>> state;
  final Widget loadingWidget;
  final Widget errorWidget;
  final Widget Function(T) render;

  const AsyncProviderOverwriter({
    super.key,
    required this.state,
    required this.loadingWidget,
    required this.errorWidget,
    required this.render,
  });

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      AsyncData(:final value) => value.match((_) => errorWidget, render),
      AsyncError() => errorWidget,
      _ => loadingWidget,
    };
  }
}
