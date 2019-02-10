//
//  NewTargetViewController.swift
//  Milesnake
//
//  Created by kawaguchi kohei on 2019/01/01.
//  Copyright © 2019年 kawaguchi kohei. All rights reserved.
//

import UIKit
import RxSwift
import ReactorKit

class NewTargetViewController: UIViewController, View {
    var disposeBag = DisposeBag()
    typealias Reactor = NewTargetReactor

    private let handleView = UIView().then {
        $0.backgroundColor = Color.black10
        $0.layer.cornerRadius = 3
    }

    private let titleLabel = UILabel().then {
        $0.font = TextStyle.make(weight: .bold, size: .big)
        $0.textColor = Color.textBlack
    }

    private let detailLabel = UILabel().then {
        $0.font = TextStyle.make(weight: .bold, size: .medium)
        $0.textColor = Color.black60
    }

    private let textView = UITextView().then {
        $0.backgroundColor = Color.black10
        $0.layer.cornerRadius = 20
        $0.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        $0.font = TextStyle.make(weight: .medium, size: .big)
        $0.textAlignment = .center
    }

    private let nextButton = UIButton().then {
        $0.backgroundColor = Color.pink
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 20
        $0.setTitle("次へ進む", for: .normal)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView: do {
            view.backgroundColor = .white
            view.setShadow(offset: CGSize(width: 0, height: -8))
            view.addSubview(handleView)
            view.addSubview(titleLabel)
            view.addSubview(detailLabel)
            view.addSubview(textView)
            view.addSubview(nextButton)

            nextButton.setShadow()
            titleLabel.text = "WHAT"
            detailLabel.text = "達成したい目標は何ですか??"
        }
        setupConstraints: do {
            handleView.snp.makeConstraints {
                $0.size.equalTo(CGSize(width: 150, height: 6))
                $0.centerX.equalToSuperview()
                $0.top.equalToSuperview().offset(18)
            }

            titleLabel.snp.makeConstraints {
                $0.top.equalTo(handleView.snp.bottom).offset(60)
                $0.centerX.equalToSuperview()
            }

            detailLabel.snp.makeConstraints {
                $0.top.equalTo(titleLabel.snp.bottom).offset(10)
                $0.centerX.equalToSuperview()
            }

            textView.snp.makeConstraints {
                $0.left.equalToSuperview().offset(16)
                $0.right.equalToSuperview().offset(-16)
                $0.top.equalTo(detailLabel.snp.bottom).offset(30)
                $0.height.equalTo(130)
            }

            nextButton.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().offset(-70)
                $0.size.equalTo(CGSize(width: 200, height: 50))
            }
        }

        // Do any additional setup after loading the view.
    }

    func bind(reactor: Reactor) {
        textView.rx
            .text
            .map { Reactor.Action.updateText($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        nextButton.rx
            .tap
            .map { Reactor.Action.nextPage }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        reactor.state
            .map { !$0.shouldShowButton }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] in
                self?.nextButton.feedIn(visible: $0)
            })
            .disposed(by: disposeBag)

        reactor.state
            .map { $0.editing }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                var titleText: String? = nil
                var detailText: String? = nil
                switch $0 {
                case .what:
                    titleText = "WHAT"
                    detailText = "達成したい目標は何ですか??"
                case .why:
                    titleText = "WHY"
                    detailText = "それはなぜやる必要がありますか?"
                    self.nextButton.setTitle("保存", for: .normal)
                    self.textView.text = nil
                case .done:
                    self.dismiss(animated: true)
                }
                self.titleLabel.text = titleText
                self.detailLabel.text = detailText
            })
            .disposed(by: disposeBag)

        textView.text = reactor.currentState.editingMile?.what
    }
}
