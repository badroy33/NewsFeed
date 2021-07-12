//
//  FavoriteListViewController.swift
//  NewsFeed
//
//  Created by Maksym Levytskyi on 11.07.2021.
//

import UIKit
import CoreData

class FavoriteListViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    private var news: [News] = []
    private var filteredNews: [News] = []
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cell = UINib(nibName: NewsFeedCell.identifier, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: NewsFeedCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        view.backgroundColor = #colorLiteral(red: 0.4314969182, green: 0.865423739, blue: 0.9773069024, alpha: 1)
        getNews()
        initSearchController()
    }
    
    private func initSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search by title"
    }
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let searchText = searchBar.text!
        filterForSearch(searchText)
        
    }
    
    private func filterForSearch(_ seatchText: String) {
        filteredNews = news.filter({ news in
//            guard (news.title != nil) else { return fals
            return news.title!.lowercased().contains(seatchText.lowercased())
        })
        tableView.reloadData() 
    }
    
    private func getNews() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<News> = News.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            news = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredNews.count
        }
        return news.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedCell.identifier, for: indexPath) as! NewsFeedCell
        
        var singleNews: News
        if isFiltering {
            singleNews = self.filteredNews[indexPath.row]
        } else {
            singleNews = self.news[indexPath.row]
        }
        
        cell.configureWithCoreData(news: singleNews)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 267
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleNews = self.news[indexPath.row]
        guard let urlString = singleNews.url else { return }
        if let url = URL(string: urlString) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let webVC = storyboard.instantiateViewController(withIdentifier: WebViewController.identifier) as! WebViewController
            webVC.url = url
            webVC.sourceName = singleNews.sourceName
            webVC.modalPresentationStyle = .fullScreen
            
            present(webVC, animated: true, completion: nil)
        }
        
    }
}
