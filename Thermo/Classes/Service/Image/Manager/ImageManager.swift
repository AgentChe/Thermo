//
//  ImageManager.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 04.11.2020.
//

import RxSwift

protocol ImageManager: class {
    // MARK: API
    func store(image: UIImage, key: String, handler: ((Bool) -> Void)?)
    func retrieve(key: String, handler: @escaping ((UIImage?) -> Void))
    
    // MARK: API(Rx)
    func rxStore(image: UIImage, key: String) -> Completable
    func rxRetrieve(key: String) -> Single<UIImage?>
}
