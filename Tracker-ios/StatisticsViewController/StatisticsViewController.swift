//
//  StatisticsViewController.swift
//  Tracker-ios
//
//  Created by Iurii on 09.10.23.
//


import UIKit

final class StatisticsViewController: UIViewController {
    
    private let trackerRecordStore = TrackerRecordStore.shared
    private var countCompleted: Int = 0
    
    //MARK: - Layout variables
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("statistics", comment: "Statistics")
        label.textColor = .ypBlackDay
        label.font = UIFont.boldSystemFont(ofSize: 34)
        
        return label
    }()
    
    private lazy var placeholderImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "NoPhotoStatistics.png"))
        
        return imageView
    }()
    
    private lazy var placeholderTitleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("thereIsNothingToAnalyzeYet", comment: "There is nothing to analyze yet")
        label.textColor = .ypBlackDay
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        
        return label
    }()
    
    private lazy var containerCompletedView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.backgroundColor = .clear
        
        return view
    }()
    
    private lazy var countCompletedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlackDay
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        
        return label
    }()
    
    private lazy var completedTitleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("trackersCompleted", comment: "Trackers completed")
        label.textAlignment = .left
        label.textColor = .ypBlackDay
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        addSubViews()
        applyConstraints()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadStatistic()
        reloadPlaceholder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerCompletedView.setGradientBorder()
    }
    
    // MARK: - Private Methods
    
    private func addSubViews() {
        view.addSubview(titleLabel)
        view.addSubview(placeholderImageView)
        view.addSubview(placeholderTitleLabel)
        view.addSubview(containerCompletedView)
        containerCompletedView.addSubview(countCompletedLabel)
        containerCompletedView.addSubview(completedTitleLabel)
        
        [titleLabel, placeholderImageView, placeholderTitleLabel, containerCompletedView, countCompletedLabel, completedTitleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            
            containerCompletedView.heightAnchor.constraint(equalToConstant: 90),
            containerCompletedView.widthAnchor.constraint(equalToConstant: 343),
            containerCompletedView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerCompletedView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 77),
            containerCompletedView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            countCompletedLabel.leadingAnchor.constraint(equalTo: containerCompletedView.leadingAnchor, constant: 12),
            countCompletedLabel.topAnchor.constraint(equalTo: containerCompletedView.topAnchor, constant: 12),
            countCompletedLabel.trailingAnchor.constraint(equalTo: containerCompletedView.trailingAnchor, constant: -12),
            
            completedTitleLabel.leadingAnchor.constraint(equalTo: countCompletedLabel.leadingAnchor),
            completedTitleLabel.trailingAnchor.constraint(equalTo: containerCompletedView.trailingAnchor),
            completedTitleLabel.bottomAnchor.constraint(equalTo: containerCompletedView.bottomAnchor, constant: -12),
            
            placeholderImageView.heightAnchor.constraint(equalToConstant: 80),
            placeholderImageView.widthAnchor.constraint(equalToConstant: 80),
            placeholderImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 246),
            placeholderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            placeholderTitleLabel.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 8),
            placeholderTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func reloadStatistic() {
        do {
            self.countCompleted = try trackerRecordStore.countCompletedTrackers()
            countCompletedLabel.text = String(countCompleted)
        } catch {
            print("Error counting completed trackers: \(error.localizedDescription)")
        }
    }
    
    private func reloadPlaceholder() {
        let isCompleted = countCompleted == 0
        placeholderImageView.isHidden = !isCompleted
        placeholderTitleLabel.isHidden = !isCompleted
        containerCompletedView.isHidden = isCompleted
    }
}
