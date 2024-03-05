//
//  GameViewcontroller.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 12/02/2024.
//

import UIKit
import AVKit
import AVFoundation
import SDWebImage


class GameViewController: UIViewController {
    
    // MARK: - Properties
    
    private var teste123: CGFloat = 280

    private let viewModel: GameViewModel
    
    private lazy var pageTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Font.boldLargeTitleFont
        label.textColor = Color.blueishWhite
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GameCell.self, forCellReuseIdentifier: "gameCell")
        tableView.separatorColor = Color.darkBlue
        tableView.allowsSelection = false

        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private let headerView: GameHeaderView
    
    // MARK: - Inits
        
    init(game: Game) {
        self.viewModel = GameViewModel(game: game)
        self.headerView = GameHeaderView(image: game.background_image, snapshots: game.short_screenshots?.compactMap({$0.image}) ?? [], tags: game.tags?.filter { $0.language == "eng" }.compactMap { CommonObject(id: $0.id, name: $0.name)} ?? [])
        
        super.init(nibName: nil, bundle: nil)
        
        headerView.delegate = self

        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft(_:)))
        swipeLeftGesture.direction = .left
        headerView.addGestureRecognizer(swipeLeftGesture)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        pageTitle.text = viewModel.game.name
        
        setupUI()
        setNavigationActions()
    }
    // MARK: - Helpers
    private func setupUI() {
        
        view.backgroundColor = Color.darkBlue
        view.addSubview(pageTitle)
        view.addSubview(tableView)
        
        tableView.backgroundColor = Color.darkBlue
        
        
        NSLayoutConstraint.activate([
            pageTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            pageTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            pageTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func handleSwipeLeft(_ gesture: UISwipeGestureRecognizer) {
        headerView.updateImage()
        
        tableView.reloadData()

    }

    
    private func setNavigationActions() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward.circle.fill"), style: .plain,
                                                           target: self, action: #selector(willNavigateBack))
    }
    
    @objc
    func willNavigateBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
// MARK: - TableView delegate

extension GameViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return teste123
        }
    
}

// MARK: - TableView datasource


extension GameViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.gamePropertiesForm.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! GameCell
                
        cell.configure(form: viewModel.gamePropertiesForm[indexPath.row].0, with: viewModel.gamePropertiesForm[indexPath.row].1)
        
        return cell
    }
}


extension GameViewController: GameHeaderViewDelegate {
    func didShowMore(_ view: GameHeaderView, didShowMore: Bool) {
        teste123 = didShowMore ? 420 : 280
        tableView.reloadData()
    }
}
