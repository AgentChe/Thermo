//
//  CalendarPickerViewController.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 10.02.2021.
//

import UIKit

final class CalendarPickerViewController: UIViewController {
    lazy var dimmedBackgroundView = makeDimmedBackgroundView()
    lazy var collectionView = makeCollectionView()
    
    lazy var headerView = CalendarPickerHeaderView(didTapLastMonthCompletionHandler: { [weak self] in
        guard let this = self else {
            return
        }
        
        this.baseDate = this.calendar.date(byAdding: .month,
                                           value: -1,
                                           to: this.baseDate) ?? this.baseDate
    }, didTapNextMonthCompletionHandler: { [weak self] in
        guard let this = self else {
            return
        }
        
        this.baseDate = this.calendar.date(byAdding: .month,
                                           value: 1,
                                           to: this.baseDate) ?? this.baseDate
    })

    private let selectedDate: Date
    
    private var baseDate: Date {
        didSet {
            days = generateDaysInMonth(for: baseDate)
            collectionView.reloadData()
            headerView.baseDate = baseDate
        }
    }

    private lazy var days = generateDaysInMonth(for: baseDate)

    private var numberOfWeeksInBaseDate: Int {
        calendar.range(of: .weekOfMonth, in: .month, for: baseDate)?.count ?? 0
    }

    private let selectedDateChanged: ((Date) -> Void)
    private let calendar = Calendar(identifier: .gregorian)

    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        return dateFormatter
    }()

    init(baseDate: Date, selectedDateChanged: @escaping ((Date) -> Void)) {
        self.selectedDate = baseDate
        self.baseDate = baseDate
        self.selectedDateChanged = selectedDateChanged

        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
        definesPresentationContext = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = UIColor.white

        view.addSubview(dimmedBackgroundView)
        view.addSubview(collectionView)
        view.addSubview(headerView)

        var constraints = [
            dimmedBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmedBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]

        constraints.append(contentsOf: [
            collectionView.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 10.scale),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])

        constraints.append(contentsOf: [
            headerView.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            headerView.bottomAnchor.constraint(equalTo: collectionView.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 85.scale)
        ])

        NSLayoutConstraint.activate(constraints)

        collectionView.register(CalendarDateCollectionViewCell.self,
                                forCellWithReuseIdentifier: String(describing: CalendarDateCollectionViewCell.self))

        collectionView.dataSource = self
        collectionView.delegate = self
        headerView.baseDate = baseDate
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.reloadData()
    }
}

// MARK: - Day Generation
private extension CalendarPickerViewController {
  // 1
  func monthMetadata(for baseDate: Date) throws -> MonthMetadata {
    // 2
    guard
      let numberOfDaysInMonth = calendar.range(
        of: .day,
        in: .month,
        for: baseDate)?.count,
      let firstDayOfMonth = calendar.date(
        from: calendar.dateComponents([.year, .month], from: baseDate))
      else {
        // 3
        throw CalendarDataError.metadataGeneration
    }

    // 4
    let firstDayWeekday = calendar.component(.weekday, from: firstDayOfMonth)

    // 5
    return MonthMetadata(
      numberOfDays: numberOfDaysInMonth,
      firstDay: firstDayOfMonth,
      firstDayWeekday: firstDayWeekday)
  }

  // 1
  func generateDaysInMonth(for baseDate: Date) -> [Day] {
    // 2
    guard let metadata = try? monthMetadata(for: baseDate) else {
      preconditionFailure("An error occurred when generating the metadata for \(baseDate)")
    }

    let numberOfDaysInMonth = metadata.numberOfDays
    let offsetInInitialRow = metadata.firstDayWeekday
    let firstDayOfMonth = metadata.firstDay

    // 3
    var days: [Day] = (1..<(numberOfDaysInMonth + offsetInInitialRow))
      .map { day in
        // 4
        let isWithinDisplayedMonth = day >= offsetInInitialRow
        // 5
        let dayOffset =
          isWithinDisplayedMonth ?
          day - offsetInInitialRow :
          -(offsetInInitialRow - day)

        // 6
        return generateDay(
          offsetBy: dayOffset,
          for: firstDayOfMonth,
          isWithinDisplayedMonth: isWithinDisplayedMonth)
      }

    days += generateStartOfNextMonth(using: firstDayOfMonth)

    return days
  }

  // 7
  func generateDay(
    offsetBy dayOffset: Int,
    for baseDate: Date,
    isWithinDisplayedMonth: Bool
  ) -> Day {
    let date = calendar.date(
      byAdding: .day,
      value: dayOffset,
      to: baseDate)
      ?? baseDate

    return Day(
      date: date,
      number: dateFormatter.string(from: date),
      isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
      isWithinDisplayedMonth: isWithinDisplayedMonth
    )
  }

  // 1
  func generateStartOfNextMonth(
    using firstDayOfDisplayedMonth: Date
    ) -> [Day] {
    // 2
    guard
      let lastDayInMonth = calendar.date(
        byAdding: DateComponents(month: 1, day: -1),
        to: firstDayOfDisplayedMonth)
      else {
        return []
    }

    // 3
    let additionalDays = 7 - calendar.component(.weekday, from: lastDayInMonth)
    guard additionalDays > 0 else {
      return []
    }

    // 4
    let days: [Day] = (1...additionalDays)
      .map {
        generateDay(
        offsetBy: $0,
        for: lastDayInMonth,
        isWithinDisplayedMonth: false)
      }

    return days
  }

  enum CalendarDataError: Error {
    case metadataGeneration
  }
}

// MARK: - UICollectionViewDataSource
extension CalendarPickerViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    days.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let day = days[indexPath.row]

    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: String(describing: CalendarDateCollectionViewCell.self),
      for: indexPath) as! CalendarDateCollectionViewCell

    cell.day = day
    return cell
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CalendarPickerViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    let day = days[indexPath.row]
    selectedDateChanged(day.date)
    dismiss(animated: true, completion: nil)
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let width = Int(collectionView.frame.width / 7)
    let height = Int(collectionView.frame.height) / numberOfWeeksInBaseDate
    return CGSize(width: width, height: height)
  }
}

// MARK: Lazy initialization
private extension CalendarPickerViewController {
    func makeDimmedBackgroundView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        return view
    }

    func makeCollectionView() -> UICollectionView  {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.layer.cornerRadius = 15.scale
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.isScrollEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        return view
    }
}
