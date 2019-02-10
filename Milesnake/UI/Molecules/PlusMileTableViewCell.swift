//
//  MiletTableViewCell.swift
//  Milesnake
//
//  Created by kawaguchi kohei on 2018/12/31.
//  Copyright © 2018年 kawaguchi kohei. All rights reserved.
//

import UIKit

class PlusMiletTableViewCell: UITableViewHeaderFooterView {
    let verticalLineView = UIView().then {
        $0.backgroundColor = Color.black10
    }

    let titleLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = TextStyle.make(weight: .medium, size: .medium)
        $0.textColor = Color.black60
        $0.text = "達成するために必要なコトを追加する"
    }

    let plusImageView = UIImageView().then {
        $0.image = Asset.grayPlusCircle.image
        $0.contentMode = .scaleAspectFit
        $0.setShadow()
    }

    private struct Const {
        static let contentLayoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        static let mileSize = CGSize(width: 45, height: 45)
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        setupView: do {
            contentView.insetsLayoutMarginsFromSafeArea = false
            contentView.backgroundColor = .white
            contentView.layoutMargins = Const.contentLayoutMargins

            contentView.addSubview(verticalLineView)
            contentView.addSubview(plusImageView)
            contentView.addSubview(titleLabel)
        }

        setupConstraint: do {
            contentView.snp.makeConstraints {
                $0.edges.equalTo(contentView.layoutMargins)
            }

            plusImageView.snp.makeConstraints {
                $0.size.equalTo(Const.mileSize)
                $0.centerY.equalToSuperview()
                $0.left.equalTo(contentView.layoutMargins)
            }

            titleLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalTo(plusImageView.snp.right).offset(40)
            }

            verticalLineView.snp.remakeConstraints {
                $0.width.equalTo(2)
                $0.top.equalToSuperview()
                $0.bottom.equalTo(plusImageView.snp.centerY)
                $0.centerX.equalTo(plusImageView)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
