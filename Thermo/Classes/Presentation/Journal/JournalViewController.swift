//
//  JournalViewController.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

import UIKit
import RxSwift
import RxCocoa

final class JournalViewController: UIViewController {
    weak var delegate: JournalViewControllerDelegate?
    
    var journalView = JournalView()
    
    private let viewModel = JournalViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        super.loadView()
        
        view = journalView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addActionsToMember()
        addActionsToReportButton()
        
        viewModel
            .memberImage()
            .drive(onNext: { [weak self] image in
                self?.journalView.imageView.image = image
            })
            .disposed(by: disposeBag)
        
        let sections = viewModel.sections()
            
        sections
            .drive(onNext: { [weak self] sections in
                self?.journalView.tableView.setup(sections: sections)
                self?.updateReportButtonTitle(sections: sections)
            })
            .disposed(by: disposeBag)
        
        sections
            .drive(onNext: emptyPlaceholder(sections:))
            .disposed(by: disposeBag)
            
        Driver
            .combineLatest(viewModel.currentMemberIsHuman(), sections)
            .drive(onNext: { [weak self] stub in
                let (currentMemberIsHuman, sections) = stub
                
                self?.currentMemberIsHuman(currentMemberIsHuman, sections: sections)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Make
extension JournalViewController {
    static func make() -> JournalViewController {
        JournalViewController()
    }
}

// MARK: Private
private extension JournalViewController {
    func addActionsToMember() {
        let tapGesture = UITapGestureRecognizer()
        journalView.imageView.isUserInteractionEnabled = true
        journalView.imageView.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.delegate?.journalViewControllerDidTappedMember()
            })
            .disposed(by: disposeBag)
    }
    
    func addActionsToReportButton() {
        let tapGesture = UITapGestureRecognizer()
        journalView.journalReportButton.isUserInteractionEnabled = true
        journalView.journalReportButton.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .flatMapLatest { [weak self] event -> Single<Bool> in
                guard let this = self else {
                    return .never()
                }
                
                return this.viewModel
                    .currentMemberHasSymptoms()
            }
            .subscribe(onNext: { [weak self] hasSymptoms in
                guard let this = self else {
                    return
                }
                
                guard hasSymptoms else {
                    let alert = UIAlertController(title: nil, message: "Journal.ReportAlert.Message".localized, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel))
                    
                    this.present(alert, animated: true)
                    
                    return
                }
                
                switch this.viewModel.needPaymentForAnalyze() {
                case false:
                    let vc = TreatmentsViewController.make()
                    self?.navigationController?.pushViewController(vc, animated: true)
                case true:
                    let vc = PaygateViewController.make()
                    self?.present(vc, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func currentMemberIsHuman(_ isHuman: Bool, sections: [JournalTableSection]) {
        journalView.journalReportButton.isHidden = !isHuman
        
        journalView.desclaimerView(hidden: !isHuman || sections.isEmpty)
    }
    
    func updateReportButtonTitle(sections: [JournalTableSection]) {
        let attrs = TextAttributes()
            .textColor(UIColor.white)
            .font(Fonts.Poppins.semiBold(size: 14.scale))
            .lineHeight(20.scale)
            .letterSpacing(0.2.scale)
            .textAlignment(.center)
        
        let text = sections.isEmpty ? "Journal.Report.Title1" : "Journal.Report.Title2"
        
        journalView
            .journalReportButton.titleLabel.attributedText = text.localized.attributed(with: attrs)
    }
    
    func emptyPlaceholder(sections: [JournalTableSection]) {
        let isEmpty = sections.isEmpty
        
        journalView.tableView.isHidden = isEmpty
        journalView.emptyLabel.isHidden = !isEmpty
    }
}
