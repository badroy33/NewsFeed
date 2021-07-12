//
//  NewsFeedViewController.swift
//  NewsFeed
//
//  Created by Maksym Levytskyi on 09.07.2021.
//

import UIKit
import CoreData

class NewsFeedViewController: UITableViewController {
    
    var news: [NewsModel] = []
    var totalSizes: CGFloat!
    
    var newsRefreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return control
    }()
    
    let networkService = NetworkService()
    var url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=41321592d29a4950a37ca299bb94f6d6"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cell = UINib(nibName: NewsFeedCell.identifier, bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: NewsFeedCell.identifier)
        tableView.refreshControl = newsRefreshControl
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        
        networkService.makeRequest(urlString: url) { result in
            switch result {
            case .success(let news):
                self.news = news
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        view.backgroundColor = #colorLiteral(red: 0.6941176471, green: 0.6941176471, blue: 1, alpha: 1)
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        networkService.makeRequest(urlString: url) { result in
            switch result {
            case .success(let news):
                self.news = news
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        sender.endRefreshing()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed(NewsFeedCell.identifier, owner: self, options: nil)?[0] as! NewsFeedCell
//        let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedCell.identifier, for: indexPath) as! NewsFeedCell
        let singleNews = self.news[indexPath.row]
        
        cell.configure(news: singleNews)
        cell.delegate = self
        cell.favButton.tag = indexPath.row
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 267
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleNews = self.news[indexPath.row]
        if let url = URL(string: singleNews.url) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let webVC = storyboard.instantiateViewController(withIdentifier: WebViewController.identifier) as! WebViewController
            webVC.url = url
            webVC.sourceName = singleNews.source.name
            webVC.modalPresentationStyle = .fullScreen
            
            present(webVC, animated: true, completion: nil)
        }
        
    }
}



//MARK: -  NewsFeedCellDelegate

extension NewsFeedViewController: NewsFeedCellDelegate {
    func favButtonTapped(tag: Int) {
        let indexPath = IndexPath(row: tag, section: 0)
        let singleNews = self.news[indexPath.row]
        saveNews(singleNews: singleNews)
    }
    
    func saveNews(singleNews: NewsModel) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "News", in: context) else {
            print("Can't get entity")
            return
        }
        
        let newsObject = News(entity: entity, insertInto: context)
        newsObject.sourceName = singleNews.source.name
        newsObject.author = singleNews.author
        newsObject.title = singleNews.title
        newsObject.newsDescription = singleNews.description
        newsObject.urlToImage = singleNews.urlToImage
        newsObject.publishedAt = self.dateFormat(dateString: singleNews.publishedAt)
        newsObject.date = self.fromStringToDate(dateString: singleNews.publishedAt)
        newsObject.url = singleNews.url
        
        do {
            try context.save()
        } catch let error as NSError{
            print(error.localizedDescription)
        }
    }
    
    func dateFormat(dateString: String?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        guard let dateString = dateString, let date = dateFormatter.date(from: dateString) else {
            print("Can't convert string to date")
            return "today"}
        dateFormatter.dateFormat = "YY/MM/dd"
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
    
    func fromStringToDate(dateString: String?) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        guard let dateString = dateString, let date = dateFormatter.date(from: dateString) else {
            print("Can't convert string to date")
            return Date()
        }
        return date
    }
    
}

