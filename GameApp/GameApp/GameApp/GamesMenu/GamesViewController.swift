//
//  GamesViewController.swift
//  GameApp
//
//  Created by Angélica Rodrigues on 04/02/2024.
//

import UIKit

class GamesViewController: UIViewController {
    // MARK: - Properties
    private var genre: Genre?
    private let id: Int

    private lazy var gamesDescriptionHeaderView: GamesDescriptionHeaderView = {
        let view = GamesDescriptionHeaderView()
        view.isUserInteractionEnabled = true
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let pageTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("games", comment: "")
        label.font = Font.extraLargeBoldTitleFont
        label.textColor = Color.blueishWhite
        return label
    }()
        
    private lazy var gamesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = Color.darkBlue
        collection.register(HomeScreenCell.self, forCellWithReuseIdentifier: "HomeCellIdentifier")
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()
    
    init(id: Int) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gamesCollectionView.delegate = self
        
        Task {
            do {
                let genre = GenresManager()
                let response = try await genre.fetchGenresById(self.id)
                self.genre = response
                let description = SharedHelpers().removeHtmlTagsAndDecodeEntities(from: response.description)
                
                gamesDescriptionHeaderView.setContent(with: description ?? "")
                gamesDescriptionHeaderView.isUserInteractionEnabled = true

            } catch {
                print("Error: \(error)")
            }
        }
        setupUI()
    }

    
    private func setupUI() {
        view.backgroundColor = Color.darkBlue

        view.addSubview(pageTitle)
        view.addSubview(gamesDescriptionHeaderView)
        view.addSubview(gamesCollectionView)
        

        NSLayoutConstraint.activate([
            pageTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            pageTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            pageTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            gamesDescriptionHeaderView.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: 8),
            gamesDescriptionHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            gamesDescriptionHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            gamesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            gamesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            gamesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gamesCollectionView.topAnchor.constraint(equalTo: gamesDescriptionHeaderView.bottomAnchor, constant: 8)
        ])
    }
}

extension GamesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCellIdentifier", for: indexPath) as? HomeScreenCell else {
            fatalError("Unable to dequeue HomeScreenCell")
        }
        
        // Configure the cell here
        
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

extension GamesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Handle item selection
    }
}

extension GamesViewController: GamesDescriptionHeaderViewDelegate {
    func didToggleShowMore(_ view: GamesDescriptionHeaderView) {
        gamesCollectionView.reloadData()
        gamesCollectionView.collectionViewLayout.invalidateLayout()
        gamesCollectionView.setContentOffset(CGPoint(x: 0, y: -gamesCollectionView.contentInset.top), animated: false)
        gamesCollectionView.reloadData()


    }
}

extension GamesDescriptionHeaderView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.size.width/2)-43, height: 400)
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerSize = calculateHeaderSize()
        //        return CGSize(width: collectionView.bounds.width, height: gamesDescriptionHeaderView.frame.size.height)

        return headerSize
        
//        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)

    }
}
