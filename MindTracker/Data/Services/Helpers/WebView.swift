//
//  WebView.swift
//  MindTracker
//
//  Created by Tark Wight on 22.05.2025.
//

import UIKit
import WebKit

final class AppleSignInWebViewController: UIViewController {
    private let webView = WKWebView()
    private let dismissAfter: TimeInterval
    private let onComplete: () -> Void

    init(dismissAfter: TimeInterval = 4.0, onComplete: @escaping () -> Void) {
        self.dismissAfter = dismissAfter
        self.onComplete = onComplete
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false

        webView.accessibilityIdentifier = WebViewAccessibility.webView

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        if let url = URL(string: "https://www.google.com") {
            webView.load(URLRequest(url: url))
        }

        Task {
            try? await Task.sleep(nanoseconds: UInt64(dismissAfter * 1_000_000_000))
            await MainActor.run {
                self.dismiss(animated: true) {
                    self.onComplete()
                }
            }
        }
    }
}

private enum WebViewAccessibility {
    static let webView = "auth_web_view"
}
