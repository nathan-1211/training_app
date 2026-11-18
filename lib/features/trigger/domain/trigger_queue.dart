import 'dart:async';

enum TriggerSource { initialLink, linkStream, appIntent, button }

class TriggerEvent {
  TriggerEvent({
    required this.source,
    required this.receivedAt,
    this.uri,
    this.id,
  });

  final TriggerSource source;
  final DateTime receivedAt;
  final String? uri;

  /// ID único (o App Intent nativo gera um UUID por execução).
  final String? id;

  bool get isLink =>
      source == TriggerSource.initialLink || source == TriggerSource.linkStream;

  @override
  String toString() => 'TriggerEvent($source, $uri, $id)';
}

/// Fila de gatilhos externos.
///
/// - Antes de [markReady] (cold start: banco/Riverpod ainda carregando),
///   os gatilhos ficam enfileirados.
/// - Gatilhos pendentes são agrupados: abrir a janela de registro é uma ação
///   única, então N gatilhos acumulados viram 1 processamento.
/// - O mesmo gatilho nunca é processado duas vezes: o link inicial e o mesmo
///   link reenviado pelo stream (o plugin do iOS faz isso) dentro de
///   [dedupeWindow] contam como um só; eventos com o mesmo [TriggerEvent.id]
///   também.
/// - O processamento é serial.
class TriggerQueue {
  TriggerQueue({
    required this.onProcess,
    this.dedupeWindow = const Duration(seconds: 3),
  });

  final Future<void> Function(TriggerEvent event) onProcess;
  final Duration dedupeWindow;

  bool _ready = false;
  TriggerEvent? _pending;
  final Set<String> _seenIds = {};
  final List<TriggerEvent> _acceptedLinks = [];
  Future<void> _chain = Future.value();
  int _processedCount = 0;

  bool get isReady => _ready;
  bool get hasPending => _pending != null;
  int get processedCount => _processedCount;

  /// Retorna true se o evento foi aceito (não era duplicado).
  bool enqueue(TriggerEvent event) {
    if (_isDuplicate(event)) return false;
    if (event.id != null) _seenIds.add(event.id!);
    if (event.isLink) {
      _acceptedLinks.add(event);
      _acceptedLinks.removeWhere(
        (e) =>
            event.receivedAt.difference(e.receivedAt).abs() > dedupeWindow * 4,
      );
    }
    if (!_ready) {
      _pending ??= event; // agrupa pendentes
      return true;
    }
    _schedule(event);
    return true;
  }

  bool _isDuplicate(TriggerEvent event) {
    if (event.id != null && _seenIds.contains(event.id)) return true;
    if (event.isLink) {
      for (final prev in _acceptedLinks) {
        final sameUri = prev.uri == event.uri;
        final otherChannel = prev.source != event.source;
        final close =
            event.receivedAt.difference(prev.receivedAt).abs() <= dedupeWindow;
        if (sameUri && otherChannel && close) return true;
      }
    }
    return false;
  }

  /// Chame quando a sessão já foi carregada do banco.
  /// Processa (uma vez) o gatilho que estava enfileirado.
  Future<void> markReady() {
    if (_ready) return _chain;
    _ready = true;
    final p = _pending;
    _pending = null;
    if (p != null) _schedule(p);
    return _chain;
  }

  void _schedule(TriggerEvent event) {
    _chain = _chain.then((_) async {
      _processedCount++;
      try {
        await onProcess(event);
      } catch (_) {
        // Um gatilho com erro não pode travar a fila.
      }
    });
  }

  /// Aguarda o processamento em andamento (útil em testes).
  Future<void> get idle => _chain;
}
