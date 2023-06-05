//
//  ViewController.swift
//  STARTIOSHW22
//
//  Created by Adlet Zhantassov on 02.06.2023.
//

import UIKit
import SnapKit
import CoreData

protocol MainViewProtocol {
    
}

class MainViewController: UIViewController, MainViewProtocol {
    
    var presenter: MainPresenterProtocol!
    
    //MARK: - UI Elements
    
    let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let userTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Print your name here..."
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .systemGray5
        tf.setLeftPaddingPoints(10)
        tf.setRightPaddingPoints(10)
        return tf
    }()
    
    let pressButton: UIButton = {
        let button = UIButton()
        button.setTitle("Press", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0, green: 0.4780646563, blue: 0.9985368848, alpha: 1)
        button.layer.cornerRadius = 15
        button.addTarget(nil, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        
        do {
            let persons = try context.fetch(fetchRequest)
            presenter.setUsers(persons: persons)
            tableView.reloadData()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
    }
    
    @objc
    func buttonPressed() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Person", in: context) else { return }

        let object = Person(entity: entity, insertInto: context)
        if userTextField.text != "" {
            object.name = userTextField.text
            do {
                try context.save()
                presenter.appendUser(person: object)
                self.tableView.reloadData()
                userTextField.text = ""
                userTextField.placeholder = "Print your name here..."
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("usertextfield empty")
        }
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfUsers()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let user = presenter.getUser(indexPath: indexPath.row)
        cell.textLabel?.text = user.fio
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.removeUser(indexPath: indexPath.row)
            tableView.reloadData()
        }
    }
    
}

extension MainViewController {
    
    func setupViews() {
        navigationItem.backButtonTitle = ""
        view.backgroundColor = .systemGray5
        navigationItem.title = "Users"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(topView)
        view.addSubview(userTextField)
        view.addSubview(pressButton)
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        topView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.height.equalTo(250)
        }
        userTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalTo(view.snp.leading).offset(20)
            $0.trailing.equalTo(view.snp.trailing).offset(-20)
            $0.height.equalTo(40)
        }
        
        pressButton.snp.makeConstraints {
            $0.top.equalTo(userTextField.snp.bottom).offset(10)
            $0.leading.equalTo(view.snp.leading).offset(20)
            $0.trailing.equalTo(view.snp.trailing).offset(-20)
            $0.height.equalTo(40)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(view.snp.bottom)
        }
    }
    
}
