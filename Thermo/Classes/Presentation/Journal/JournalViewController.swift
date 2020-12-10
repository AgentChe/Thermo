//
//  JournalViewController.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

import UIKit
import RxSwift

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
        
        viewModel
            .sections()
            .drive(onNext: { [weak self] sections in
                self?.journalView.tableView.setup(sections: sections)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .currentMemberIsHuman()
            .drive(onNext: currentMemberIsHuman(_:))
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
                
                switch this.viewModel.hasActiveSubscription() {
                case true:
                    let vc = TreatmentsViewController.make()
                    self?.navigationController?.pushViewController(vc, animated: true)
                case false:
                    let vc = PaygateViewController.make()
                    self?.present(vc, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func currentMemberIsHuman(_ isHuman: Bool) {
        journalView.journalReportButton.isHidden = !isHuman
    }
}
