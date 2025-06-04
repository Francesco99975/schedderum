import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:schedderum/helpers/failure.dart';

class AsyncProviderReplacer<T> extends ConsumerWidget {
  final ProviderListenable<AsyncValue<Either<Failure, T>>> provider;
  final Widget Function(Failure) fallback;
  final Widget Function(T) render;

  const AsyncProviderReplacer({
    super.key,
    required this.provider,
    required this.fallback,
    required this.render,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);
    return state.when(
      data: (value) => value.match(fallback, render),
      error: (error, _) => fallback(Failure(message: error.toString())),
      loading: () => fallback(Failure(message: "Loading...")),
    );
  }
}
