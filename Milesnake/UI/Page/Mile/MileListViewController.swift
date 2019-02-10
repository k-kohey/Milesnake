//
//  MileListViewController.swift
//  Milesnake
//
//  Created by kawaguchi kohei on 2018/12/31.
//  Copyright © 2018年 kawaguchi kohei. All rights reserved.
//

import UIKit
import Then
import ReusableKit
import RealmSwift
import RxSwift
import Jelly

final class MileListViewController: BaseMileViewController {
    let mile: Mile
    var mileNotificationToken:NotificationToken? = nil

    private enum Reusable {
        static let mile = ReusableCell<MiletTableViewCell>()
        static let plus = ReusableView<PlusMiletTableViewCell>()
        static let section = ReusableView<SingleLineSectionView>()
    }


    init(mile: Mile) {
        self.mile = mile
        let service = MileService()
        super.init(dataSource: service.children(from: mile.id), service: service)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var editButton = UIBarButtonItem(title: "編集", style: .plain, target: self, action: #selector(didTappedEditButton))

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView: do {
            navigationItem.rightBarButtonItems?.append(editButton)
            tableView.separatorStyle = .none
            tableView.register(Reusable.mile)
            tableView.register(Reusable.plus)
            tableView.register(Reusable.section)
            view = tableView
        }
        setupRx: do {
            // todo: move to state in reactor, and transform
            tableView.rx
                .setDataSource(self)
                .disposed(by: disposeBag)

            tableView.rx
                .setDelegate(self)
                .disposed(by: disposeBag)
        }

        mileNotificationToken = service.mile(id: mile.id).observe { (changeset) in
            switch changeset {
            case .initial(let mile):
                self.title = mile.first?.what
            case .update(let mile, _, _, _):
                self.title = mile.first?.what
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }

    @objc private func didTappedEditButton() {
        let viewController = NewTargetViewController().then {
            $0.reactor = NewTargetReactor(parentMile: mile, context: .edit(mile))
        }
        show(modal: viewController)
    }

    deinit {
        mileNotificationToken?.invalidate()
    }
}

extension MileListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(Reusable.mile, for: indexPath)
        let mile = dataSource[indexPath.row]
        cell.configure(number: mile.count, title: mile.what, detail: mile.why, shouldShowLine: true)
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeue(Reusable.section)
        view?.text = ""
        return view
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = tableView.dequeue(Reusable.plus)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapSectionFooter(sender:)))
        view?.addGestureRecognizer(gesture)
        view?.tag = section
        return view
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    @objc private func tapSectionFooter(sender: Any) {
        let viewController = NewTargetViewController().then {
            $0.reactor = NewTargetReactor(parentMile: mile)
        }
        show(modal: viewController)
    }
}
