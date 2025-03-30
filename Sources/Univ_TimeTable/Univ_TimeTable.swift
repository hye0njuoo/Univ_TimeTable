// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

public class Univ_TimeTable: UIView {

 // MARK: - private properties
    private let collectionView = UICollectionView()

    private let defaultMinTime: Int = 9
    private let defaultMaxTime: Int = 24
    private var lectureCells = [LectureCell]()

// MARK: - public properties
    public var minimumCourseStartTime: Int?



// MARK: - 외부에서 지정할 수 있는 속성

    //시작 일자를 조정할수 있는 속성입니다. 초기값은 월요일입니다.
    public var startDay = Day.monday {
        didSet {
        }
    }

    //시간표 스크롤를 조정할수 있는 속성입니다.
    public var scrollEnabled: Bool = true {
        didSet {
            collectionView.isScrollEnabled = scrollEnabled
        }
    }

    //시간표 태두리의 바탕선을 추가하는지에 대한 속성입니다.
    public var isFullBorder: Bool = true {
        didSet {
        }
    }

    //강의 셀의 크기를 설정하는 속성입니다.
    public var courseItemHeight : CGFloat = 60.0 {
        didSet {
        }
    }

    //시간표위의 요일을 나타내는 텍스트의 색상을 설정하는 속성입니다.
    public var weekDayTextColor = UIColor.black {
        didSet {
        }
    }

    public var courseItems = [Lecture]() {
        didSet {
        }
    }


    public var timeTableBackgroundColor = UIColor.clear {
        didSet {
            collectionView.backgroundColor = backgroundColor
        }
    }

    public var weekDayHeaderBackgroundColor = UIColor.clear {
        didSet {
        }
    }

    public var weekDayHeaderFontSize = CGFloat(10) {
        didSet {
        }
    }

    public var weekDayHeaderFontColor = UIColor.black {
        didSet {
        }
    }

    public var timeHeaderFontSize = CGFloat(10) {
        didSet {
        }
    }


    public var timeHeaderFontColor = UIColor.black {
        didSet {
        }
    }

    public var heightOfWeekDayHeader = CGFloat(28) {
        didSet {
        }
    }

    public var widthOfTimeHeader = CGFloat(32) {
        didSet {
        }
    }

    //구분선의 두깨를 설정합니다.
    public var borderWidth = CGFloat(1) {
        didSet {
        }
    }

    public var borderColor = UIColor.systemGray5{
        didSet {
        }
    }

    public var borderCornerRadius = CGFloat(0) {
        didSet {
        }
    }

    private var rectEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
        }
    }

    public var textEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) {
        didSet {
        }
    }

    public var courseItemTextSize = CGFloat(11) {
        didSet {
        }
    }

    public var classRoomNameFontSize = CGFloat(9) {
        didSet {
        }
    }

    public var courseTextAlignment = NSTextAlignment.center {
        didSet {
        }
    }

    public var courseItemMaxNameLength = 0 {
        didSet {
        }
    }

    public var daySymbols: [String] {
        var daySymbolText = [String]()

//        if let count = self.dataSource?.numberOfDays(in: self) {
//            for index in 0..<count {
//                let text = self.dataSource?.elliotable(elliotable: self, at: index) ?? Calendar.current.shortStandaloneWeekdaySymbols[index]
//                daySymbolText.append(text)
//            }
//        }
//
//        let startIndex = self.startDay.rawValue - 1
//        daySymbolText.rotate(shiftingToStart: startIndex)
        return daySymbolText
    }

    public var averageWidth: CGFloat {
        return (collectionView.frame.width - widthOfTimeHeader) / CGFloat(daySymbols.count)
    }


// MARK: - 외부에서 접근할 수 있는 enum


// MARK: - View



// MARK: - 메소드

}



