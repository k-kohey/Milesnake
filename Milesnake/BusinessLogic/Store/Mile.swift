//
//  Mile.swift
//  Milesnake
//
//  Created by kawaguchi kohei on 2019/01/01.
//  Copyright © 2019年 kawaguchi kohei. All rights reserved.
//

import Foundation
import RealmSwift
import RxRealm
import RxSwift

class Mile: Object {
    @objc dynamic var id: String = UUID.init().uuidString
    @objc dynamic var what: String?
    @objc dynamic var why: String?
    @objc dynamic var createdAt: Date?
    @objc dynamic var parentId: String?
    @objc dynamic var order: Int = 0
    var children = List<Mile>()
    
    var childrenId: String? {
        guard let parentId = parentId else { return nil }
        return parentId + "-children"
    }

    var count: Int {
        return children.count
    }
}

final class MileService {
    let realm: Realm

    init() {
        let config = Realm.Configuration(schemaVersion: 2)
        realm = try! Realm(configuration: config)
    }

    func mile(id: String) -> Results<Mile> {
        return realm.objects(Mile.self).filter("id == %@", id)
    }

    func save(_ mile: Mile) {
        try! realm.write {
            realm.add(mile)
        }
    }

    func update(change: () -> (Mile)) {
        try! realm.write {
            let mile = change()
            realm.add(mile)
        }
    }

    func exchange(from fromMile: Mile, to toMile: Mile) {
        try! realm.write {
            let temp = fromMile.order
            fromMile.order = toMile.order
            toMile.order = temp
        }
    }

    func delete(_ mile: Mile) {
        let id = mile.id
        try! realm.write {
            realm.delete(mile)
        }

        realm.objects(Mile.self)
            .filter("parentId == %@", id)
            .forEach { [weak self] in
                self?.delete($0)
            }
    }

    func append(from child: Mile, to parent: Mile) {
        try! realm.write {
            child.parentId = parent.id
            parent.children.append(child)
            realm.add(parent)
        }
    }

    func root() -> Results<Mile> {
         return realm.objects(Mile.self).filter("parentId == nil").sorted(byKeyPath: "order")
    }

    func children(from id: String) -> Results<Mile> {
        return realm.objects(Mile.self).filter("parentId == %@", id).sorted(byKeyPath: "order")
    }
}
