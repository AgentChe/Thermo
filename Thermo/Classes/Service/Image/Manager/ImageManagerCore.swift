//
//  ImageManagerCore.swift
//  Thermo
//
//  Created by Andrey Chernyshev on 04.11.2020.
//

import RxSwift
import Kingfisher

final class ImageManagerCore {}

// MARK: API
extension ImageManagerCore {
    func store(image: UIImage, key: String, handler: ((Bool) -> Void)?) {
        ImageCache.default
            .store(image, forKey: key) { result in
                switch result.diskCacheResult {
                case .success:
                    handler?(true)
                case .failure:
                    handler?(false)
                }
            }
    }
    
    func retrieve(key: String, handler: @escaping ((UIImage?) -> Void)) {
        ImageCache.default
            .retrieveImage(forKey: key) { result in
                switch result {
                case .success(let cache):
                    guard let cgImage = cache.image?.cgImage else {
                        handler(nil)
                        return
                    }
                    
                    let image = UIImage(cgImage: cgImage)
                    handler(image)
                case .failure:
                    handler(nil)
                }
            }
    }
}

// MARK: API(Rx)
extension ImageManagerCore {
    func rxStore(image: UIImage, key: String) -> Completable {
        Completable
            .create { event in
                ImageCache.default
                    .store(image, forKey: key) { result in
                        switch result.diskCacheResult {
                        case .success:
                            event(.completed)
                        case .failure(let error):
                            event(.error(error))
                        }
                    }
                
                return Disposables.create()
            }
    }
    
    func rxRetrieve(key: String) -> Single<UIImage?> {
        Single<UIImage?>
            .create { event in
                ImageCache.default
                    .retrieveImage(forKey: key) { result in
                        switch result {
                        case .success(let cache):
                            guard let cgImage = cache.image?.cgImage else {
                                event(.success(nil))
                                return
                            }
                            
                            let image = UIImage(cgImage: cgImage)
                            event(.success(image))
                        case .failure(let error):
                            event(.failure(error))
                        }
                    }
                
                return Disposables.create()
            }
    }
}
