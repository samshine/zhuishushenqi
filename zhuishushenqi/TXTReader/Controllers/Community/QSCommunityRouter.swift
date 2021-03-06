//
//  QSCommunityRouter.swift
//  zhuishushenqi
//
//  Created caonongyun on 2017/4/24.
//  Copyright © 2017年 QS. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class QSCommunityRouter: QSCommunityWireframeProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule(model:BookDetail) -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = QSCommunityViewController(nibName: nil, bundle: nil)
        let interactor = QSCommunityInteractor()
        let router = QSCommunityRouter()
        let presenter = QSCommunityPresenter(interface: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        
        interactor.model = model
        
        return view
    }
    
    func presentDetail(detail: BookComment) {
        viewController?.navigationController?.pushViewController(QSBookCommentRouter.createModule(model: detail), animated: true)
    }
    
}
