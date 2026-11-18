import AppIntents
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "TriggerBridge") {
      TriggerBridge.shared.attach(messenger: registrar.messenger())
    }
  }
}

/// Ponte entre o App Intent "Registrar série" e o Flutter.
///
/// Cada execução do intent vira um ID (UUID) guardado em `pending`. O Flutter
/// é avisado ("triggerAvailable") e busca os IDs ("consumePendingTriggers"),
/// que são removidos ao serem lidos. No cold start, o Flutter busca os IDs
/// assim que sobe — nada se perde e nada é processado duas vezes.
final class TriggerBridge {
  static let shared = TriggerBridge()

  private var pending: [String] = []
  private var channel: FlutterMethodChannel?

  func attach(messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: "treino/trigger", binaryMessenger: messenger)
    channel.setMethodCallHandler { [weak self] call, result in
      guard let self = self else { return result(nil) }
      switch call.method {
      case "consumePendingTriggers":
        let items = self.pending
        self.pending.removeAll()
        result(items)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    self.channel = channel
  }

  func fire() {
    DispatchQueue.main.async {
      self.pending.append(UUID().uuidString)
      self.channel?.invokeMethod("triggerAvailable", arguments: nil)
    }
  }
}

@available(iOS 16.0, *)
struct RegisterSetIntent: AppIntent {
  static var title: LocalizedStringResource = "Registrar série"
  static var description = IntentDescription(
    "Abre a janela de registro da série atual do treino em andamento.")
  static var openAppWhenRun: Bool = true

  @MainActor
  func perform() async throws -> some IntentResult {
    TriggerBridge.shared.fire()
    return .result()
  }
}

@available(iOS 16.0, *)
struct TreinoShortcuts: AppShortcutsProvider {
  static var appShortcuts: [AppShortcut] {
    AppShortcut(
      intent: RegisterSetIntent(),
      phrases: [
        "Registrar série no \(.applicationName)",
        "\(.applicationName) registrar série",
      ],
      shortTitle: "Registrar série",
      systemImageName: "dumbbell"
    )
  }
}
