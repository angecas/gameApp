//
//  GamesViewController.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 04/02/2024.
//

import UIKit

class GamesViewController: UIViewController {
    
    // MARK: - Properties
    private let id: Int
    private var viewModel: GamesviewModel
    private var tags: [Tags2]?
    private var toggleSearch: Bool = false
    private var pageTitletopAnchor: NSLayoutConstraint? = nil
    private var titleHorizontalStack: UIStackView = UIStackView()
    
    private let freeSearch: UITextFieldView =  UITextFieldView(placeholder: NSLocalizedString("Search...", comment: ""), isSearch: true)
    
    private lazy var gamesDescriptionHeaderView: GamesDescriptionHeaderView = {
        let view = GamesDescriptionHeaderView()
        view.delegate = self
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var pageTitle: UILabel = {
        let label = UILabel()
        label.font = Font.boldLargeTitleFont
        label.textColor = Color.blueishWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    private lazy var gamesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 50
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 100, height: 150)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)

        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = Color.darkBlue
        collection.register(GamesCell.self, forCellWithReuseIdentifier: "CellIdentifier")
        return collection
    }()
    
    private lazy var filtersImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "line.3.horizontal.decrease.circle.fill")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Color.blueishWhite
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var searchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass.circle.fill")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = Color.blueishWhite
        imageView.contentMode = .scaleAspectFit
        let searchGesture = UITapGestureRecognizer(target: self, action: #selector(searchTap))
        imageView.addGestureRecognizer(searchGesture)

        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return refreshControl
    }()

    
    // MARK: - Inits
    
    init(id: Int, tags: [Tags2]?) {
        self.id = id
        self.tags = tags
        self.viewModel = GamesviewModel(id: id)
        super.init(nibName: nil, bundle: nil)
        
        if tags == nil {
            viewModel.fetchTags()
        }
        
        self.hidesBottomBarWhenPushed = true
        
        self.freeSearch.delegate2 = self
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesBottomBarWhenPushed = true
//        LoadingManager.shared.showLoading()
        
        gamesCollectionView.delegate = self
        gamesCollectionView.dataSource = self
        gamesCollectionView.refreshControl = refreshControl
        viewModel.fetchDetail()
        viewModel.fetchData(freeSearch: "", preciseSearch: false)
        setupUI()
        setNavigationActions()
    }

//    }
    // MARK: - Helpers
    private func setupUI() {
        gamesCollectionView.reloadData()

        view.backgroundColor = Color.darkBlue
//        view.addSubview(freeSearch)
//        view.addSubview(pageTitle)
        view.addSubview(gamesDescriptionHeaderView)
        view.addSubview(gamesCollectionView)
        
        titleHorizontalStack = UIStackView(arrangedSubviews: [pageTitle, filtersImageView, searchImageView])
        titleHorizontalStack.axis = .horizontal
        
        titleHorizontalStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleHorizontalStack)

        pageTitletopAnchor =             titleHorizontalStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)

        freeSearch.isHidden = true
        NSLayoutConstraint.activate([
//            freeSearch.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
//            freeSearch.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            freeSearch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            freeSearch.heightAnchor.constraint(equalToConstant: 50),

            pageTitletopAnchor!,
//            titleHorizontalStack.topAnchor.constraint(equalTo: freeSearch.bottomAnchor, constant: 16),
            titleHorizontalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleHorizontalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleHorizontalStack.heightAnchor.constraint(equalToConstant: 40),
            
            filtersImageView.widthAnchor.constraint(equalToConstant: 24),
            filtersImageView.heightAnchor.constraint(equalToConstant: 24),
            
            searchImageView.widthAnchor.constraint(equalToConstant: 24),
            searchImageView.heightAnchor.constraint(equalToConstant: 24),

            gamesDescriptionHeaderView.topAnchor.constraint(equalTo: titleHorizontalStack.bottomAnchor, constant: 16),
            gamesDescriptionHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            gamesDescriptionHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            gamesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            gamesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            gamesCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            gamesCollectionView.topAnchor.constraint(equalTo: gamesDescriptionHeaderView.bottomAnchor, constant: 8)
        ])
    }
    
    @objc private func handleRefresh(_ sender: UIRefreshControl) {
        refreshControl.endRefreshing()
        viewModel.fetchData(freeSearch: "", preciseSearch: false)
        gamesCollectionView.reloadData()
    }
    @objc private func searchTap() {
        toggleSearch.toggle()
        freeSearch.isHidden = !toggleSearch
        
        if toggleSearch == true {
            view.addSubview(freeSearch)
            
            self.view.removeConstraint(pageTitletopAnchor!)
            
            pageTitletopAnchor = titleHorizontalStack.topAnchor.constraint(equalTo: freeSearch.bottomAnchor, constant: 16)

            
            NSLayoutConstraint.activate([
                freeSearch.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                freeSearch.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                freeSearch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                freeSearch.heightAnchor.constraint(equalToConstant: 50),
                pageTitletopAnchor!
            ])

        } else {
            freeSearch.removeFromSuperview()
            self.view.removeConstraint(pageTitletopAnchor!)

            pageTitletopAnchor =             titleHorizontalStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16)
            pageTitletopAnchor?.isActive = true
        }

        
    }

    @objc
    func willNavigateBack() {
        self.navigationController?.popToRootViewController(animated: true)
        UserDefaultsHelper.removeSelectedGenre()
    }

    private func setNavigationActions() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward.circle.fill"), style: .plain,
                                                           target: self, action: #selector(willNavigateBack))

    }
}
// MARK: - CollectionView DataSource
extension GamesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.games?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellIdentifier", for: indexPath) as? GamesCell else {
            fatalError("Failed to dequeue a cell of type CustomImageCell")
        }

        if let games = viewModel.games {
            if indexPath.row < games.count {
                let game = games[indexPath.row]
                cell.configure(game: game)
            } else {
                print("Index out of range: \(indexPath.row), Genre Count: \(games.count)")
            }
        }
        return cell
    }

    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: "\(ResultReusableView.self)",
                                                                         for: indexPath) as! ResultReusableView
            header.configureWithView(gamesDescriptionHeaderView)
            return header
        }
        return UICollectionReusableView()
    }

}

// MARK: - CollectionView Delegate

extension GamesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? GamesCell {
            
            if let games = viewModel.games {
                if indexPath.row < games.count {
                    let game = games[indexPath.row]
                    let viewController = GameViewController(game: game)
                    self.navigationController?.pushViewController(viewController, animated: true)
                }
                
                //            cell.showCellDetails()
            }
        }
    }
}

// MARK: - GamesDescriptionHeaderView Delegate

extension GamesViewController: GamesDescriptionHeaderViewDelegate {
    func didTapPillCell(_ view: GamesDescriptionHeaderView, selectedObj: CommonObject) {
        
        viewModel.games = []
        viewModel.fetchData(freeSearch: "", preciseSearch: false, tags: selectedObj.id)
    }
    
    func didToggleShowMore(_ view: GamesDescriptionHeaderView) {
        gamesCollectionView.collectionViewLayout.invalidateLayout()
        gamesCollectionView.setContentOffset(CGPoint(x: 0, y: -gamesCollectionView.contentInset.top), animated: false)
        gamesCollectionView.reloadData()
    }
}
// MARK: - CollectionViewFlowLayout Delegate

extension GamesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastItem = indexPath.item
        let totalItems = collectionView.numberOfItems(inSection: 0)

        if lastItem == totalItems - 1 {
            self.viewModel.currentPage += 1
            self.viewModel.fetchMoreData(lastItem: lastItem, freeSearch: "", preciseSearch: false, totalItems: totalItems)
        }
    }
}


extension GamesViewController: GamesviewModelDelegate {
    func didFetchTags(_ model: GamesviewModel) {
        self.tags = viewModel.tags
        
        if let tagsList = tags?.compactMap({CommonObject(id: $0.id, name: $0.name)}) {
            gamesDescriptionHeaderView.setTags(pillStringsList: tagsList)
        }
    }
    
    func didFetchData(_ model: GamesviewModel) {
        self.gamesCollectionView.reloadData()
    }
    
    func didFetchDetail(_ model: GamesviewModel, genre: Genre) {
        self.pageTitle.text = genre.name
        let description = SharedHelpers().removeHtmlTagsAndDecodeEntities(from: genre.description)
        
        gamesDescriptionHeaderView.setContent(with: description ?? "")
                
        if let tagsList = tags?.compactMap({CommonObject(id: $0.id, name: $0.name)}) {
            gamesDescriptionHeaderView.setTags(pillStringsList: tagsList)
        }
        
        gamesDescriptionHeaderView.isUserInteractionEnabled = true
    }
}

extension GamesViewController: UITextFieldViewDelegate {
    func didTapRightView(_ view: UITextFieldView) {
        
        viewModel.games = []
        
        viewModel.fetchData(freeSearch: freeSearch.text ?? "", preciseSearch: true)
    }
}
