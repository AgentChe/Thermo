//
//  ComboBox.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 23.11.2020.
//

import UIKit
import RxSwift
import RxCocoa

class LoggerSelectionViewItem {
    let id: Int
    let name: String
    var isSelected: Bool
    
    init(id: Int, name: String, isSelected: Bool = false) {
        self.id = id
        self.name = name
        self.isSelected = isSelected
    }
}

final class LoggerSelectionView: UIView {
    enum Style {
        case payment, cell
    }
    
    var style = Style.payment {
        didSet {
            updateStyle()
        }
    }
    
    var didRemoveTagView: ((TagView) -> Void)?
    
    lazy var titleLabel = makeTitleLabel()
    lazy var fieldBackgroundView = makeFieldBackgroundView()
    lazy var leftIconLabel = makeLeftIconLabel()
    lazy var rightIconView = makeRightIconView()
    lazy var premiumLabel = makePremiumLabel()
    lazy var tagsView = makeTagsView()
    lazy var tagsPlaceholderLabel = makeTagsPlaceholderLabel()
    
    var models = [LoggerSelectionViewItem]()
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        updateStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        var result = 21.scale + 14.scale

        var cell = fieldBackgroundView.frame.height
        if cell < 48.scale {
            cell = 48.scale
        }
        result += cell

        return CGSize(width: 327.scale, height: result)
    }
}

// MARK: API
extension LoggerSelectionView {
    func set(selected: [LoggerSelectionViewItem]) {
        tagsView.removeAllTags()
        
        let list = selected.map(makeTagView(tag:))
        tagsView.addTagViews(list)
    }
    
    func updateVisibility() {
        let selectedModels = models.filter { $0.isSelected }
        
        premiumLabel.isHidden = style != .payment
        tagsPlaceholderLabel.isHidden = style == .payment || !selectedModels.isEmpty
        tagsView.isHidden = style == .payment || selectedModels.isEmpty
    }
    
    func addTagView(model: LoggerSelectionViewItem) {
        let view = makeTagView(tag: model)
        tagsView.addTagView(view)
    }
}

// MARK: Private
private extension LoggerSelectionView {
    func updateStyle() {
        updateVisibility()
        
        switch style {
        case .payment:
            rightIconView.image = UIImage(named: "TemperatureLogger.Feeiling.Lock")
        case .cell:
            rightIconView.image = UIImage(named: "TemperatureLogger.Feeiling.Arrow")
        }
    }

    func makeTagView(tag: LoggerSelectionViewItem) -> TagView {
        let view = TagView(model: TagViewModel(id: tag.id, name: tag.name))
        view.textColor = UIColor(integralRed: 105, green: 121, blue: 248)
        view.selectedTextColor = UIColor(integralRed: 105, green: 121, blue: 248)
        view.tagBackgroundColor = UIColor(integralRed: 229, green: 231, blue: 250)
        view.selectedBackgroundColor = UIColor(integralRed: 229, green: 231, blue: 250)
        view.cornerRadius = 4.scale
        view.paddingX = 8.scale
        view.paddingY = 6.scale
        view.textFont = Fonts.Poppins.regular(size: 11.scale)
        view.removeIconLineWidth = 2.scale
        view.removeButtonIconSize = 8.scale
        view.removeIconLineColor = UIColor(integralRed: 105, green: 121, blue: 248)
        view.isSelected = true
        view.enableRemoveButton = true
        view.addTarget(self, action: #selector(remove(tagView:)), for: .touchUpInside)
        return view
    }
    
    @objc
    func remove(tagView: UIButton) {
        guard let sender = tagView as? TagView else {
            return
        }
        
        didRemoveTagView?(sender)
    }
}

// MARK: Make constraints
private extension LoggerSelectionView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            fieldBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.scale),
            fieldBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.scale),
            fieldBackgroundView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14.scale),
            fieldBackgroundView.heightAnchor.constraint(greaterThanOrEqualToConstant: 48.scale)
        ])
        
        NSLayoutConstraint.activate([
            leftIconLabel.leadingAnchor.constraint(equalTo: fieldBackgroundView.leadingAnchor, constant: 16.scale),
            leftIconLabel.centerYAnchor.constraint(equalTo: fieldBackgroundView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            rightIconView.trailingAnchor.constraint(equalTo: fieldBackgroundView.trailingAnchor, constant: -16.scale),
            rightIconView.centerYAnchor.constraint(equalTo: fieldBackgroundView.centerYAnchor),
            rightIconView.widthAnchor.constraint(equalToConstant: 16.scale),
            rightIconView.heightAnchor.constraint(equalToConstant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            premiumLabel.leadingAnchor.constraint(equalTo: fieldBackgroundView.leadingAnchor, constant: 43.scale),
            premiumLabel.trailingAnchor.constraint(equalTo: fieldBackgroundView.trailingAnchor, constant: -43.scale),
            premiumLabel.centerYAnchor.constraint(equalTo: fieldBackgroundView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tagsPlaceholderLabel.leadingAnchor.constraint(equalTo: fieldBackgroundView.leadingAnchor, constant: 43.scale),
            tagsPlaceholderLabel.trailingAnchor.constraint(equalTo: fieldBackgroundView.trailingAnchor, constant: -43.scale),
            tagsPlaceholderLabel.centerYAnchor.constraint(equalTo: fieldBackgroundView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tagsView.leadingAnchor.constraint(equalTo: fieldBackgroundView.leadingAnchor, constant: 43.scale),
            tagsView.trailingAnchor.constraint(equalTo: fieldBackgroundView.trailingAnchor, constant: -43.scale),
            tagsView.topAnchor.constraint(equalTo: fieldBackgroundView.topAnchor, constant: 12.scale),
            tagsView.bottomAnchor.constraint(equalTo: fieldBackgroundView.bottomAnchor, constant: -12.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension LoggerSelectionView {
    func makeTitleLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeFieldBackgroundView() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 6.scale
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLeftIconLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        fieldBackgroundView.addSubview(view)
        return view
    }
    
    func makeRightIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        fieldBackgroundView.addSubview(view)
        return view
    }
    
    func makePremiumLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 161, green: 111, blue: 216))
            .font(Fonts.Poppins.bold(size: 18.scale))
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "ComboBox.Premium".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        fieldBackgroundView.addSubview(view)
        return view
    }
    
    func makeTagsView() -> TagListView {
        let view = TagListView()
        view.backgroundColor = UIColor.clear
        view.marginX = 8.scale
        view.marginY = 8.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        fieldBackgroundView.addSubview(view)
        return view
    }
    
    func makeTagsPlaceholderLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(UIColor(integralRed: 208, green: 201, blue: 214))
            .font(Fonts.Poppins.regular(size: 15.scale))
        
        let view = UILabel()
        view.attributedText = "ComboBox.TagsPlaceholder".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        fieldBackgroundView.addSubview(view)
        return view
    }
}
