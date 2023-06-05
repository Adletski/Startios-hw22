//
//  ModuleBuilder.swift
//  STARTIOSHW22
//
//  Created by Adlet Zhantassov on 04.06.2023.
//

import UIKit

protocol Builder {
    static func createMainModule() -> UIViewController
}

class ModuleBuilder: Builder {
    
    static func createMainModule() -> UIViewController {
        let model = [User(name: "adlet", surname: "zh"),User(name: "bek", surname: "ad"),User(name: "komil", surname: "asd")]
        let view = MainViewController()
        let presenter = MainPresenter(view: view, users: model)
        view.presenter = presenter
        return view
    }
    
}
