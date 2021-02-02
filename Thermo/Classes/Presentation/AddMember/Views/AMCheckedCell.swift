//
//  AMCheckedCell.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 02.02.2021.
//

import UIKit

final class AMCheckedCell: UIView {
    lazy var titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Make constraints
private extension AMCheckedCell {
    func makeConstraints() {
        
    }
}

// MARK: Lazy initialization
private extension AMCheckedCell {
    
}
