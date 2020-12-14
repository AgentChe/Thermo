//
//  JournalViewControllerDelegate.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 29.10.2020.
//

protocol JournalViewControllerDelegate: class {
    func journalViewControllerDidTappedMember()
    func journalViewControllerDidLogRecord()
}

extension JournalViewControllerDelegate {
    func journalViewControllerDidTappedMember() {}
    func journalViewControllerDidLogRecord() {}
}
