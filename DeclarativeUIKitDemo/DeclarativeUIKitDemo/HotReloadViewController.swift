//
//  HotReloadViewController.swift
//  DeclarativeUIKitDemo
//
//  Created by sakiyamaK on 2022/03/06.
//

import UIKit
import DeclarativeUIKit

extension Notification.Name {
    static let injection = Notification.Name("INJECTION_BUNDLE_NOTIFICATION")
}

extension NotificationCenter {
    func addInjectionObserver(_ observer: Any, selector: Selector, object: Any?) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: .injection, object: object)
    }
}

final class HotReloadViewController: UIViewController {
    
    override func loadView() {
        super.loadView()
        NotificationCenter.default.addInjectionObserver(self, selector: #selector(setupLayout), object: nil)
        setupLayout()
    }
}

@objc private extension HotReloadViewController {
    func setupLayout() {
        self.view.backgroundColor = .white
        self.declarative {
            UIButton("タップしてね")
                .backgroundColor(.red)
                .add(target: self, for: .touchUpInside, {
                    #selector(tapButton)
                })
                .zStack {
                    UIView().backgroundColor(.blue)
                        .isUserInteractionEnabled(false)
                        .size(width: 200, height: 200)
                        .center()
//                        .backgroundColor(.systemPink)
//                        .isUserInteractionEnabled(true)
                }
        }
    }
    
    func tapButton() {
        print("tap")
    }
}
