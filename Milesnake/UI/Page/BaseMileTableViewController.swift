//
//  BaseMileTableViewController.swift
//  Milesnake
//
//  Created by kawaguchi kohei on 2019/01/10.
//  Copyright © 2019年 kawaguchi kohei. All rights reserved.
//

import UIKit
import SnapKit
import ReusableKit
import RealmSwift
import RxSwift
import Jelly
import Navigation_stack

class BaseMileViewController: UIViewController {
    var notificationToken: NotificationToken? = nil
    var dataSource: Results<Mile>
    var disposeBag = DisposeBag()
    var tableView = UITableView()
    var service: MileService

    lazy var animator: Animator = {
        let interactionConfiguration = InteractionConfiguration(presentingViewController: self, completionThreshold: 0.5, dragMode: .canvas, mode: .dismiss)
        let uiConfiguration = PresentationUIConfiguration(cornerRadius: 30, backgroundStyle: .dimmed(alpha: 0.5), isTapBackgroundToDismissEnabled: true, corners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        let size = PresentationSize(width: .fullscreen, height: .custom(value: UIScreen.main.bounds.height * 0.9))
        let alignment = PresentationAlignment(vertical: .bottom, horizontal: .center)
        let presentation = CoverPresentation(directionShow: .bottom, directionDismiss: .bottom, uiConfiguration: uiConfiguration, size: size, alignment: alignment, interactionConfiguration: interactionConfiguration)
        return Animator(presentation: presentation)
    }()

    init(dataSource: Results<Mile>, service: MileService) {
        self.dataSource = dataSource
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
        if editing {
            editButtonItem.title = "完了!"
        } else {
            editButtonItem.title = "管理"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        editButtonItem.title = "管理"
        navigationItem.rightBarButtonItems = [editButtonItem]
        navigationController?.interactivePopGestureRecognizer?.delegate = self

        notificationToken = dataSource.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }

        tableView.rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let mile = self?.dataSource[indexPath.row] else { return }
                let vc = MileListViewController(mile: mile)
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)

        tableView.rx
            .itemDeleted
            .debug("itemdeleted")
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.service.delete(self.dataSource[$0.row])
            })
            .disposed(by: disposeBag)

        tableView.rx
            .itemMoved
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let from = $0.0.row
                let to = $0.1.row

                self.service.exchange(from: self.dataSource[from], to: self.dataSource[to])
            })
            .disposed(by: disposeBag)
    }

    func show(modal viewController: UIViewController) {
        animator.prepare(presentedViewController: viewController)
        present(viewController, animated: true, completion: nil)
    }

    deinit {
        notificationToken?.invalidate()
    }
}

extension BaseMileViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {

        if navigationController?.viewControllers.count ?? 0 < 4 {
            return true
        }

        if let navigationController = self.navigationController as? NavigationStack {
            navigationController.showControllers()
        }

        return false
    }
}
