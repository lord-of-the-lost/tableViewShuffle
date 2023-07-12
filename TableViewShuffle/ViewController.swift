//
//  ViewController.swift
//  TableViewShuffle
//
//  Created by Николай Игнатов on 12.07.2023.
//

import UIKit

final class ViewController: UIViewController {
    
    private var cellList: [CellModel] = (1...30).map { number in
        return CellModel(text: String(number), isSelected: false)
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.allowsMultipleSelection = true
        tableView.layer.cornerRadius = 10
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        lazy var shuffleButton = UIBarButtonItem(title: "Shuffle",
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(shuffleButtonTapped))
        navigationController?.navigationBar.barTintColor = .systemGray6
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.title = "Task 4"
        navigationItem.rightBarButtonItem = shuffleButton
        view.backgroundColor = .systemGray6
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func shuffleButtonTapped() {
        var newIndexes = Array(0..<cellList.count)
        newIndexes.shuffle()
        
        tableView.beginUpdates()
        
        for (index, _) in cellList.enumerated() {
            let indexPath = IndexPath(row: index, section: 0)
            let newIndex = newIndexes[index]
            let newIndexPath = IndexPath(row: newIndex, section: 0)
            tableView.moveRow(at: indexPath, to: newIndexPath)
        }
        
        tableView.endUpdates()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = cellList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = item.text
        cell.accessoryType = item.isSelected ? .checkmark : .none
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        cellList[indexPath.row].isSelected.toggle()
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        if let selectedCell = tableView.cellForRow(at: indexPath) {
            selectedCell.accessoryType = cellList[indexPath.row].isSelected ? .checkmark : .none
        }
        
        if indexPath.row > 0 && cellList[indexPath.row].isSelected {
            tableView.beginUpdates()
            
            let firstIndexPath = IndexPath(row: 0, section: 0)
            tableView.moveRow(at: indexPath, to: firstIndexPath)
            
            cellList.insert(cellList.remove(at: indexPath.row), at: 0)
            
            tableView.endUpdates()
        }
    }
}
