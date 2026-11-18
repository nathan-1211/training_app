import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../session/presentation/session_controller.dart';
import '../domain/trigger_queue.dart';

/// `treino://registrar`
bool isRegisterLink(Uri uri) =>
    uri.scheme == 'treino' &&
    (uri.host == 'registrar' || uri.path.replaceAll('/', '') == 'registrar');

/// Fontes de gatilho abstraídas para teste.
abstract class TriggerSources {
  Stream<Uri> get linkStream;
  Future<Uri?> initialLink();

  /// IDs de execuções do App Intent ainda não consumidas.
  Future<List<String>> consumeIntentTriggers();

  /// Chamado pelo lado nativo quando há um App Intent novo.
  void setIntentListener(void Function() onAvailable);
}

class PlatformTriggerSources implements TriggerSources {
  final _appLinks = AppLinks();
  static const _channel = MethodChannel('treino/trigger');

  @override
  Stream<Uri> get linkStream => _appLinks.uriLinkStream;

  @override
  Future<Uri?> initialLink() => _appLinks.getInitialLink();

  @override
  Future<List<String>> consumeIntentTriggers() async {
    try {
      return await _channel.invokeListMethod<String>(
            'consumePendingTriggers',
          ) ??
          const [];
    } on MissingPluginException {
      return const [];
    }
  }

  @override
  void setIntentListener(void Function() onAvailable) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'triggerAvailable') onAvailable();
    });
  }
}

/// Liga as fontes de gatilho (link inicial, stream de links, App Intent) à
/// fila. A fila só libera o processamento depois que a sessão foi
/// reidratada do banco — cobre o cold start.
class TriggerService {
  TriggerService(this.container, this.sources);

  final ProviderContainer container;
  final TriggerSources sources;
  StreamSubscription<Uri>? _sub;

  late final TriggerQueue queue = TriggerQueue(
    onProcess: (_) => container
        .read(sessionControllerProvider.notifier)
        .onRegisterTrigger(external: true),
  );

  DateTime get _now => container.read(clockProvider)();

  void _onLink(Uri uri, TriggerSource source) {
    if (!isRegisterLink(uri)) return;
    queue.enqueue(
      TriggerEvent(source: source, uri: uri.toString(), receivedAt: _now),
    );
  }

  Future<void> _drainIntents() async {
    for (final id in await sources.consumeIntentTriggers()) {
      queue.enqueue(
        TriggerEvent(source: TriggerSource.appIntent, id: id, receivedAt: _now),
      );
    }
  }

  Future<void> start() async {
    // 1) Stream primeiro, para não perder nada (cenários a e b).
    _sub = sources.linkStream.listen(
      (uri) => _onLink(uri, TriggerSource.linkStream),
    );
    // 2) App Intent (push do nativo + pull do que chegou antes).
    sources.setIntentListener(() => unawaited(_drainIntents()));
    // 3) Link que abriu o app (cenário c, cold start).
    try {
      final initial = await sources.initialLink();
      if (initial != null) _onLink(initial, TriggerSource.initialLink);
    } catch (_) {}
    await _drainIntents();
    // 4) Só processa depois que a sessão foi carregada do banco.
    await container.read(sessionControllerProvider.future);
    await queue.markReady();
  }

  Future<void> dispose() async => _sub?.cancel();
}
