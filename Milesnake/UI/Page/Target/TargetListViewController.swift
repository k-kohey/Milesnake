//
//  TargetListViewController.swift
//  Milesnake
//
//  Created by kawaguchi kohei on 2019/01/01.
//  Copyright © 2019年 kawaguchi kohei. All rights reserved.
//

import UIKit
import SnapKit
import ReusableKit
import RealmSwift
import RxSwift
import Jelly
import Navigation_stack

class TargetListViewController: BaseMileViewController {
    let addButton = UIButton().then {
        $0.setBackgroundImage(Asset.orangePlusCircle.image, for: .normal)
        $0.addTarget(self, action: #selector(addTarget(_:)), for: .touchUpInside)
        $0.setShadow(opacity: 0.3)
    }

    private enum Reusable {
        static let mile = ReusableCell<MiletTableViewCell>()
    }

    init() {
        let service = MileService()
        super.init(dataSource: service.root(), service: service)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView: do {
            title = "目標"
            view.backgroundColor = .white
            view.addSubview(tableView)
            view.addSubview(addButton)
            tableView.register(Reusable.mile)
            tableView.separatorStyle = .none
        }
        setupConstraint: do {
            tableView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }

            addButton.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().offset(-40)
                $0.size.equalTo(CGSize(width: 44, height: 44))
            }
        }
        setupRx: do {
            // todo: move to state in reactor, and transform
            tableView.rx
                .setDataSource(self)
                .disposed(by: disposeBag)
        }
    }

    @objc func addTarget(_ sender: UIButton) {
        let viewController = NewTargetViewController().then {
            $0.reactor = NewTargetReactor()
        }
        show(modal: viewController)
    }
}

extension TargetListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(Reusable.mile, for: indexPath)
        let mile = dataSource[indexPath.row]
        cell.configure(number: mile.count, title: mile.what, detail: mile.why, shouldShowLine: false)
        return cell
    }
}
