// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import UIKit

public protocol UnivTimeTableDelegate {
    func univTimeTable(univTimeTable: UnivTimeTable, didSelectCourse selectedCourse: Lecture)

    func univTimeTable(univTimeTable: UnivTimeTable, didLongSelectCourse longSelectedCourse : Lecture)
}

public protocol UnivTimeTableDataSource {
    func univTimeTable(univTimeTable: UnivTimeTable, at dayPerIndex: Int) -> String

    func numberOfDays(in univTimeTable: UnivTimeTable) -> Int

    func courseItems(in univTimeTable: UnivTimeTable) -> [Lecture]
}

public enum roundOption: Int {
    case none  = 0
    case left  = 1
    case right = 2
    case all   = 3
}

public class UnivTimeTable: UIView {
    private let controller     = UnivTimeTableController()
    private let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())

    public let defaultMinHour: Int = 9
    public let defaultMaxEnd : Int = 17

    //public var userDaySymbol: [String]?
    public var delegate: UnivTimeTableDelegate?
    public var dataSource: UnivTimeTableDataSource?

    private var courseCells = [LectureCell]()

    public var startDay = Day.monday {
        didSet {
            makeTimeTable()
        }
    }

    public var timeTableScrollEnabled: Bool = true {
        didSet {
            collectionView.isScrollEnabled = timeTableScrollEnabled
        }
    }

    public var isFullBorder: Bool = true {
        didSet {
            makeTimeTable()
        }
    }

    public var courseItemHeight : CGFloat = 60.0 {
        didSet {
            makeTimeTable()
        }
    }

    public var weekDayTextColor = UIColor.black {
        didSet {
            makeTimeTable()
        }
    }

    public var courseItems = [Lecture]() {
        didSet {
            makeTimeTable()
        }
    }

    public var roundCorner: roundOption = roundOption.none {
        didSet {
            makeTimeTable()
        }
    }

    public var elliotBackgroundColor = UIColor.clear {
        didSet {
            collectionView.backgroundColor = backgroundColor
        }
    }

    public var symbolBackgroundColor = UIColor.clear {
        didSet {
            makeTimeTable()
        }
    }

    public var symbolFontSize = CGFloat(10) {
        didSet {
            makeTimeTable()
        }
    }

    public var symbolTimeFontSize = CGFloat(10) {
        didSet {
            makeTimeTable()
        }
    }

    public var symbolFontColor = UIColor.black {
        didSet {
            makeTimeTable()
        }
    }

    public var symbolTimeFontColor = UIColor.black {
        didSet {
            makeTimeTable()
        }
    }

    public var heightOfDaySection = CGFloat(28) {
        didSet {
            makeTimeTable()
        }
    }

     public var widthOfTimeAxis = CGFloat(32) {
        didSet {
            makeTimeTable()
        }
    }

     public var borderWidth = CGFloat(0) {
        didSet {
            makeTimeTable()
        }
    }

     public var borderColor = UIColor.clear {
        didSet {
            makeTimeTable()
        }
    }

     public var borderCornerRadius = CGFloat(0) {
        didSet {
            self.makeTimeTable()
        }
    }

    private var rectEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            self.makeTimeTable()
        }
    }

     public var textEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
            self.makeTimeTable()
        }
    }

     public var courseItemTextSize = CGFloat(11) {
        didSet {
            self.makeTimeTable()
        }
    }

     public var roomNameFontSize = CGFloat(9) {
        didSet {
            self.makeTimeTable()
        }
    }

     public var courseTextAlignment = NSTextAlignment.center {
        didSet {
            self.makeTimeTable()
        }
    }

     public var courseItemMaxNameLength = 0 {
        didSet {
            self.makeTimeTable()
        }
    }

    public var daySymbols: [String] {
        var daySymbolText = [String]()

        if let count = self.dataSource?.numberOfDays(in: self) {
            for index in 0..<count {
                let text = self.dataSource?.univTimeTable(univTimeTable: self, at: index) ?? Calendar.current.shortStandaloneWeekdaySymbols[index]
                daySymbolText.append(text)
            }
        }

        let startIndex = self.startDay.rawValue - 1
        daySymbolText.rotate(shiftingToStart: startIndex)
        return daySymbolText
    }

    public var minimumCourseStartTime: Int?

    public var averageWidth: CGFloat {
        return (collectionView.frame.width - widthOfTimeAxis) / CGFloat(daySymbols.count)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    private func initialize() {
        controller.elliotable = self
        controller.collectionView = collectionView

        collectionView.dataSource = controller
        collectionView.delegate = controller
        collectionView.backgroundColor = backgroundColor

        addSubview(collectionView)
        makeTimeTable()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
        makeTimeTable()
    }

    private func makeTimeTable() {
        var minStartTimeHour: Int = 24
        var maxEndTimeHour: Int = 0

        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()

        for subview in collectionView.subviews {
            if !(subview is UICollectionViewCell) {
                subview.removeFromSuperview()
            }
        }

        for subview in subviews {
            if !(subview is UICollectionView) {
                subview.removeFromSuperview()
            }
        }
        // DataSource Delegate
        let courseItems = self.dataSource?.courseItems(in: self) ?? [Lecture]()

        if courseItems.count < 1 {
            minStartTimeHour = defaultMinHour
            maxEndTimeHour = defaultMaxEnd
        } else {
            // Calculate Min StartTime
            for (index, courseItem) in courseItems.enumerated() {
                let tempStartTimeHour = Int(courseItem.startTime.split(separator: ":")[0]) ?? 24
                let tempEndTimeHour   = Int(courseItem.endTime.split(separator: ":")[0]) ?? 00

                if index < 1 {
                    minStartTimeHour = tempStartTimeHour
                    maxEndTimeHour   = tempEndTimeHour
                } else {
                    if tempStartTimeHour < minStartTimeHour {
                        minStartTimeHour = tempStartTimeHour
                    }

                    if tempEndTimeHour > maxEndTimeHour {
                        maxEndTimeHour = tempEndTimeHour
                    }
                }
            }
            maxEndTimeHour += 1
        }
        minimumCourseStartTime = minStartTimeHour

        for (index, courseItem) in courseItems.enumerated() {
            let dayCount = dataSource?.numberOfDays(in: self) ?? 6
            let weekdayIndex = (courseItem.courseDay.rawValue - startDay.rawValue + dayCount) % dayCount

            let courseStartHour = Int(courseItem.startTime.split(separator: ":")[0]) ?? 09
            let courseStartMin  = Int(courseItem.startTime.split(separator: ":")[1]) ?? 00

            let courseEndHour = Int(courseItem.endTime.split(separator: ":")[0]) ?? 18
            let courseEndMin  = Int(courseItem.endTime.split(separator: ":")[1]) ?? 00
            let averageHeight = courseItemHeight

            // Cell X Position and Y Position
            let position_x = collectionView.bounds.minX + widthOfTimeAxis + averageWidth * CGFloat(weekdayIndex) + rectEdgeInsets.left

            // 요일 높이 + 평균 셀 높이 * 시간 차이 개수 + 분에 대한 추가 여백
            let position_y = collectionView.frame.minY + heightOfDaySection + averageHeight * CGFloat(courseStartHour - minStartTimeHour) +
                CGFloat((CGFloat(courseStartMin) / 60) * averageHeight) + rectEdgeInsets.top

            let width = averageWidth
            let height = averageHeight * CGFloat(courseEndHour - courseStartHour) +
                CGFloat((CGFloat(courseEndMin - courseStartMin) / 60) * averageHeight) - rectEdgeInsets.top - rectEdgeInsets.bottom

            // MARK: Elliotable Course Item Cell
            let view = UIView(frame: CGRect(x: position_x, y: position_y, width: width, height: height))
            view.backgroundColor = courseItem.backgroundColor

            switch(self.roundCorner) {
            case roundOption.none:
                view.layer.cornerRadius = 0
                break
            case roundOption.left:
                let path = UIBezierPath(roundedRect:view.bounds,
                                        byRoundingCorners:[.topLeft, .bottomRight],
                                        cornerRadii: CGSize(width: self.borderCornerRadius, height: self.borderCornerRadius))
                let maskLayer = CAShapeLayer()
                maskLayer.path = path.cgPath
                view.layer.mask = maskLayer
                break
            case roundOption.right:
                let path = UIBezierPath(roundedRect:view.bounds,
                                        byRoundingCorners:[.topRight, .bottomLeft],
                                        cornerRadii: CGSize(width: self.borderCornerRadius, height: self.borderCornerRadius))
                let maskLayer = CAShapeLayer()
                maskLayer.path = path.cgPath
                view.layer.mask = maskLayer
                break
            case roundOption.all:
                // To Support under iOS 11
                let path = UIBezierPath(roundedRect:view.bounds,
                                        byRoundingCorners:[.topRight, .topLeft, .bottomLeft, .bottomRight],
                                        cornerRadii: CGSize(width: self.borderCornerRadius, height: self.borderCornerRadius))
                let maskLayer = CAShapeLayer()
                maskLayer.path = path.cgPath
                view.layer.mask = maskLayer
                break
            }

            let label = PaddingLabel(frame: CGRect(x: textEdgeInsets.left, y: textEdgeInsets.top, width: view.frame.width - textEdgeInsets.right, height: view.frame.height - textEdgeInsets.top))
            var name = courseItem.name

            if courseItemMaxNameLength > 0 {
                name.truncate(courseItemMaxNameLength)
            }

            let attrStr = NSMutableAttributedString(string: name + "\n" + courseItem.classroom, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: roomNameFontSize)])
            attrStr.setAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: courseItemTextSize)], range: NSRange(0..<name.count))

            label.attributedText = attrStr
            label.textColor      = courseItem.textColor ?? UIColor.white
            label.numberOfLines  = 0
            label.tag            = index
            view.tag             = index

            if courseTextAlignment == .right {
                label.textAlignment = .right
            } else {
                label.textAlignment = courseTextAlignment
            }

            label.lineBreakMode = NSLineBreakMode.byWordWrapping
            label.sizeToFit()
            label.frame = CGRect(x: textEdgeInsets.left, y: textEdgeInsets.top, width: view.frame.width - textEdgeInsets.left - textEdgeInsets.right, height: label.bounds.height + 40)
            label.sizeToFit()
            label.frame = CGRect(x: textEdgeInsets.left, y: textEdgeInsets.top, width: view.frame.width - textEdgeInsets.left - textEdgeInsets.right, height: label.bounds.height)

            view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(lectureLongPressed)))
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(lectureTapped)))

            view.isUserInteractionEnabled = true
            view.addSubview(label)
            collectionView.addSubview(view)
        }
    }

    @objc func lectureLongPressed(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let course = courseItems[(sender.view!).tag]
            self.delegate?.univTimeTable(univTimeTable: self, didLongSelectCourse: course)
        }
    }

    @objc func lectureTapped(_ sender: UITapGestureRecognizer) {
        let course = courseItems[(sender.view!).tag]
        self.delegate?.univTimeTable(univTimeTable: self, didSelectCourse: course)
    }

    public func reloadData() {
        courseItems = self.dataSource?.courseItems(in: self) ?? [Lecture]()
    }
}

extension Array {
    func rotated(shiftingToStart middle: Index) -> Array {
        return Array(suffix(count - middle) + prefix(middle))
    }

    mutating func rotate(shiftingToStart middle: Index) {
        self = rotated(shiftingToStart: middle)
    }
}

extension String {
    func truncated(_ length: Int) -> String {
        let end = index(startIndex, offsetBy: length, limitedBy: endIndex) ?? endIndex
        return String(self[..<end])
    }

    mutating func truncate(_ length: Int) {
        self = truncated(length)
    }
}

extension UILabel {
    func textWidth() -> CGFloat {
        return UILabel.textWidth(label: self)
    }

    class func textWidth(label: UILabel) -> CGFloat {
        return textWidth(label: label, text: label.text!)
    }

    class func textWidth(label: UILabel, text: String) -> CGFloat {
        return textWidth(font: label.font, text: text)
    }

    class func textWidth(font: UIFont, text: String) -> CGFloat {
        let myText = text as NSString

        let rect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(labelSize.width)
    }
}
