//
//  LoggerSelectionController.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.11.2020.
//

import UIKit
import RxSwift

final class LoggerSelectionController: UIViewController {
    enum Style {
        case symptoms, medicines
    }
    
    var mainView = LoggerSelectionControllerView()
    
    private let style: Style
    private let models: [LoggerSelectionViewItem]
    private let didSelect: ((LoggerSelectionViewItem) -> Void)
    private let didUnselect: ((LoggerSelectionViewItem) -> Void)
    
    private let disposeBag = DisposeBag()
    
    private lazy var tableElements = [LSTableElement]()
    
    private init(style: Style,
                 models: [LoggerSelectionViewItem],
                 didSelect: @escaping ((LoggerSelectionViewItem) -> Void),
                 didUnselect: @escaping ((LoggerSelectionViewItem) -> Void)) {
        self.style = style
        self.models = models
        self.didSelect = didSelect
        self.didUnselect = didUnselect
        
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        addKeyboardHandler()
        addFilter()
    }
}

// MARK: Make
extension LoggerSelectionController {
    static func make(style: Style,
                     models: [LoggerSelectionViewItem],
                     didSelect: @escaping ((LoggerSelectionViewItem) -> Void),
                     didUnselect: @escaping ((LoggerSelectionViewItem) -> Void)) -> LoggerSelectionController {
        LoggerSelectionController(style: style, models: models, didSelect: didSelect, didUnselect: didUnselect)
    }
}

// MARK; UITableViewDataSource
extension LoggerSelectionController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableElements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableElements[indexPath.row] {
        case .title(let title):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LSTableTitleCell.self)) as! LSTableTitleCell
            cell.setup(title: title)
            return cell
        case .item(let item):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LSTableCheckCell.self)) as! LSTableCheckCell
            cell.setup(item: item)
            return cell
        }
    }
}

// MARK; UITableViewDelegate
extension LoggerSelectionController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableElements[indexPath.row] {
        case .item(let model):
            model.isSelected = !model.isSelected
            
            mainView.tableView.reloadRows(at: [indexPath], with: .automatic)
            
            if model.isSelected {
                didSelect(model)
            } else {
                didUnselect(model)
            }
        case .title:
            break
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        mainView.endEditing(true)
    }
}

// MARK: Make
private extension LoggerSelectionController {
    func configure() {
        let attrs = TextAttributes()
            .lineHeight(20.scale)
            .font(Fonts.Poppins.regular(size: 15.scale))
        
        switch style {
        case .symptoms:
            mainView.searchView.leftIconLabel.attributedText = "📝".attributed(with: attrs)
        case .medicines:
            mainView.searchView.leftIconLabel.attributedText = "💊".attributed(with: attrs)
        }
        
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
    }
    
    func addKeyboardHandler() {
        mainView.rx
            .keyboardHeight
            .subscribe(onNext: { [weak self] keyboardHeight in
                self?.mainView.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
            })
            .disposed(by: disposeBag)
    }
    
    func addFilter() {
        mainView
            .searchView
            .textField.rx
            .text
            .debounce(RxTimeInterval.microseconds(500), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] text in
                self?.setupContent(filter: text ?? "")
            })
            .disposed(by: disposeBag)
    }
    
    func setupContent(filter: String = "") {
        let title: String
        switch style {
        case .medicines:
            title = "TemperatureLogger.Feeling.Medicines.Title".localized
        case .symptoms:
            title = "TemperatureLogger.Feeling.Symptoms.Title".localized
        }
        
        let items = models
            .filter {
                if filter.isEmpty {
                    return true
                }
                
                return $0.name.lowercased().range(of: filter.lowercased()) != nil
            }
            .map { LSTableElement.item($0) }
        
        tableElements = [.title(title)] + items
        
        mainView.tableView.reloadData()
    }
}
