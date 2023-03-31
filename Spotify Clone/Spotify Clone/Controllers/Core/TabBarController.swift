//
//  TabBarViewController.swift
//  Spotify Clone
//
//  Created by Jackson Matheus on 28/03/23.
//

import UIKit

class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabs()
        
    }
    
    func configureTabs(){
        let homeVC = HomeViewController()
        homeVC.title = "Home"
        
        let libraryVC = LibraryViewController()
        libraryVC.title = "Library"
        
        
        let searchVC = SearchResultsViewController()
        searchVC.title = "Search"
        
        
        homeVC.navigationItem.largeTitleDisplayMode = .always
        libraryVC.navigationItem.largeTitleDisplayMode = .always
        searchVC.navigationItem.largeTitleDisplayMode = .always
        
        
        
        let nav1 = UINavigationController(rootViewController: homeVC)
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        nav1.navigationBar.prefersLargeTitles = true
        nav1.navigationBar.tintColor = .label
        
        let nav2 = UINavigationController(rootViewController: searchVC)
        nav2.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 2)
        nav2.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.tintColor = .label
        
        let nav3 = UINavigationController(rootViewController: libraryVC)
        nav3.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "music.note.list"), tag: 3)
        nav3.navigationBar.prefersLargeTitles = true
        nav3.navigationBar.tintColor = .label
        setViewControllers([nav1, nav2, nav3], animated: true)
        
    }
    
}
