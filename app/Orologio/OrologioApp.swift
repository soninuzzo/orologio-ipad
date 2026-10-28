import SwiftUI
import WebKit

/// Contenitore nativo per l'orologio web: niente barra di stato, niente
/// indicatore Home, schermo sempre acceso finché l'app è in primo piano.
@main
struct OrologioApp: App {
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            ClockView()
                .ignoresSafeArea()
                .statusBarHidden(true)
                .persistentSystemOverlays(.hidden)
                .background(Color(red: 11 / 255, green: 10 / 255, blue: 15 / 255))
        }
        .onChange(of: scenePhase) { phase in
            UIApplication.shared.isIdleTimerDisabled = (phase == .active)
        }
    }
}

/// Mostra index.html incluso nell'app, quindi funziona anche offline
/// (meteo e caratteri Google richiedono comunque la rete).
struct ClockView: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let web = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        let void = UIColor(red: 11 / 255, green: 10 / 255, blue: 15 / 255, alpha: 1)
        web.isOpaque = false
        web.backgroundColor = void
        web.scrollView.backgroundColor = void
        web.scrollView.isScrollEnabled = false
        web.scrollView.bounces = false
        web.scrollView.contentInsetAdjustmentBehavior = .never
        if let page = Bundle.main.url(forResource: "index", withExtension: "html") {
            web.loadFileURL(page, allowingReadAccessTo: page.deletingLastPathComponent())
        }
        return web
    }

    func updateUIView(_ web: WKWebView, context: Context) {}
}
