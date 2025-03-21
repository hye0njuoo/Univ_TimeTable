//
//  LectureCell.swift
//  Univ_TimeTable
//
//  Created by 성현주 on 3/20/25.
//

import Foundation
import UIKit

public class LectureCell: UICollectionViewCell {
    let textLabel = PaddingLabel()
    var borderLayer = CALayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        borderLayer.frame = self.bounds
        layer.addSublayer(borderLayer)

        textLabel.textAlignment = .right
        addSubview(textLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        textLabel.frame = bounds
    }

    override public func prepareForReuse() {
        super.prepareForReuse()
    }
}

class PaddingLabel: UILabel {
    private var padding: UIEdgeInsets = UIEdgeInsets.zero

    var topInset: CGFloat = 0.0
    var bottomInset: CGFloat = 0.0
    var leftInset: CGFloat = 0.0
    var rightInset: CGFloat = 0.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}
