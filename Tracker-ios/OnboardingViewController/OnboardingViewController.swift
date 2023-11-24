//
//  OnboardingViewController.swift
//  Tracker-ios
//
//  Created by Iurii on 15.11.23.
//

import UIKit

class OnboardingViewController: UIPageViewController {
    
    //MARK: - Layout variables
    
    private lazy var onboardingPages: [UIViewController] = {
        return [blueViewController, redViewController]
    }()
    
    private lazy var blueViewController: UIViewController = {
        let page = UIViewController()
        page.view.addBackground(image: "Onboarding1.png")
        
        return page
    }()
    
    private lazy var redViewController: UIViewController = {
        let page = UIViewController()
        page.view.addBackground(image: "Onboarding2.png")
        
        return page
    }()
    
    private lazy var blueLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("trackOnlyWhatYouWant", comment: "Track only what you want")
        label.textColor = .ypBlackDay
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var redLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString(
            "evenIfIt'sNotLitersOfWaterAndYoga",
            comment: "Even if it's not liters of water and yoga"
        )
        label.textColor = .ypBlackDay
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(
            NSLocalizedString("thisIsTechnology", comment: "This is technology!"),
            for: .normal
        )
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypWhiteDay, for: .normal)
        button.layer.cornerRadius = 16
        button.addTarget(
            self,
            action: #selector(didTapbutton),
            for: .touchUpInside
        )
        button.backgroundColor = .ypBlackDay
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = onboardingPages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .ypBlackDay
        pageControl.pageIndicatorTintColor = .ypGrey
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        return pageControl
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        addStartPage()
        addSubViews()
        applyConstraints()
    }
    
    // MARK: - IBAction
    
    @objc
    private func didTapbutton() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return
        }
        window.rootViewController = TabBarController()
    }
    
    // MARK: - Private Methods
    
    private func addStartPage() {
        if let first = onboardingPages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func addSubViews() {
        blueViewController.view.addSubview(blueLabel)
        redViewController.view.addSubview(redLabel)
        view.addSubview(pageControl)
        view.addSubview(button)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.heightAnchor.constraint(equalToConstant: 60),
            button.widthAnchor.constraint(equalToConstant: 335),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -24),
            
            blueLabel.leadingAnchor.constraint(equalTo: blueViewController.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            blueLabel.trailingAnchor.constraint(equalTo: blueViewController.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            blueLabel.centerXAnchor.constraint(equalTo: blueViewController.view.centerXAnchor),
            blueLabel.bottomAnchor.constraint(equalTo: blueViewController.view.safeAreaLayoutGuide.bottomAnchor, constant: -270),
            
            redLabel.leadingAnchor.constraint(equalTo: redViewController.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            redLabel.trailingAnchor.constraint(equalTo: redViewController.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            redLabel.centerXAnchor.constraint(equalTo: redViewController.view.centerXAnchor),
            redLabel.bottomAnchor.constraint(equalTo: redViewController.view.safeAreaLayoutGuide.bottomAnchor, constant: -270)
        ])
    }
}

// MARK: - UIPageViewControllerDataSource

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = onboardingPages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = (viewControllerIndex - 1 + onboardingPages.count) % onboardingPages.count
        
        return onboardingPages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = onboardingPages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = (viewControllerIndex + 1) % onboardingPages.count
        
        return onboardingPages[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate

extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = onboardingPages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}

