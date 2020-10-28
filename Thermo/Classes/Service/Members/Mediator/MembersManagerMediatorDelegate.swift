//
//  MembersManagerMediatorDelegate.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 28.10.2020.
//

protocol MembersManagerMediatorDelegate: class {
    func membersManagerMediatorDidAdded(member: Member)
    func membersManagerMediatorDidRemoved(memberId: Int)
    func membersManagerMediatorDidSetCurrent(member: Member)
}
