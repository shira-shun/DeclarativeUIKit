//
//  File.swift
//  
//
//  Created by sakiyamaK on 2022/02/13.
//

import UIKit
import DeclarativeUIKit

final class Simple2ViewController: UIViewController {
    
    private weak var button: UIButton!
    private weak var tapLabel: UILabel!
    private weak var overlapView: UIView!
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = .white
                                
        let Header = { (title: String) -> UIView in
            UIStackView.vertical {
                UILabel(title)
                    .textColor(.black)
                    .textAlignment(.center)
                    .numberOfLines(0)
                    .font(UIFont.systemFont(ofSize: 30))
                UIView.spacer().height(10)
                UIView.divider()
            }
        }
        
        self.declarative {
            UIStackView.vertical {
                Header("その他のViewの設定")
                UIScrollView.vertical {
                    UIStackView.vertical {
                        UIImageView(UIImage.init(systemName: "square.and.arrow.up"))
                            .contentMode(.scaleAspectFit)
                            .height(200)
                        
                        UIButton("button")
                            .titleColor(.brown)
                            .addControlAction(target: self, for: .touchUpInside) {
                                #selector(self.tapButton)
                            }
                            .assign(to: &self.button)
                        
                        UITextField()
                            .placeholder(NSAttributedString(string: "プレースホルダー", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black]))
                            .borderStyle(.line)
                            .keyboardType(.alphabet)
                            .delegate(self)
                        
                        UILabel(assign: &self.tapLabel)
                            .text("タップジェスチャーのあるラベル")
                            .textAlignment(.center)
                            .isUserInteractionEnabled(true)
                            .numberOfLines(1)
                            .addGestureRecognizer {
                                UITapGestureRecognizer(target: self) {
                                    #selector(self.tapLabel(_:))
                                }
                            }
                    }
                    .spacing(40)
                    .padding(insets: .init(horizontal: 10))
                }
                .refreshControl {
                    UIRefreshControl()
                        .addControlAction(target: self, for: .valueChanged) {
                            #selector(refresh)
                        }
                }
            }
            .spacing(20)
        }
                
        //セーフエリアを無視したレイアウトをさらに上に追加
        self.declarative(safeAreas: .init(all: false), reset: false) {
            UIView.spacer()
                .backgroundColor(.black.withAlphaComponent(0.3))
                .assign(to: &overlapView)
                .isHidden(true)
                
        }
    }
}

@objc extension Simple2ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("テキストフィールドのデリゲートだね")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

@objc private extension Simple2ViewController {
    func tapLabel(_ sender: UIGestureRecognizer) {
        print("ラベルをタップしたね")
        if tapLabel == sender.view {
            print(self.tapLabel.text ?? "")
        }
    }
    
    func tapButton(_ sender: UIButton) {
        print("ボタンをタップしたね")
        if button == sender {
            print(self.button.titleLabel?.text ?? "")
        }
        self.overlapView.isHidden.toggle()
    }
    
    func refresh(_ sender: UIRefreshControl) {
        print("リフレッシュするよ")
        if sender.isRefreshing {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                sender.endRefreshing()
            }
        }
    }
}
