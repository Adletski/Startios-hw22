//
//  Presenter.swift
//  STARTIOSHW22
//
//  Created by Adlet Zhantassov on 03.06.2023.
//

import Foundation

protocol MainPresenterProtocol {
    init(view: MainViewProtocol, users: Users)
    func numberOfUsers() -> Int
    func getUser(indexPath: Int) -> User
    func appendUser(person: Person)
    func setUsers(persons: [Person])
    func removeUser(indexPath: Int)
}

class MainPresenter: MainPresenterProtocol {
    
    let view: MainViewProtocol
    var users: Users
    
    required init(view: MainViewProtocol, users: Users) {
        self.view = view
        self.users = users
    }
    
    func numberOfUsers() -> Int {
        return users.count
    }
    
    func getUser(indexPath: Int) -> User {
        return users[indexPath]
    }
    
    func appendUser(person: Person) {
        users.insert(User(name: person.name ?? "", surname: person.surname ?? ""), at: 0)
    }
    
    func setUsers(persons: [Person]) {
        for person in persons {
            users.append(User(name: person.name ?? "", surname: person.surname ?? ""))
        }
    }
    
    func removeUser(indexPath: Int) {
        users.remove(at: indexPath)
    }
    
}
