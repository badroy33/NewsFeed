//
//  NewsFeedCell.swift
//  NewsFeed
//
//  Created by Maksym Levytskyi on 09.07.2021.
//

import UIKit

protocol NewsFeedCellDelegate {
    func favButtonTapped(tag: Int)
}

class NewsFeedCell: UITableViewCell {
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var sourceNameLabel: UILabel!
    @IBOutlet weak var addToFavButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var newsImageView: WebImageView!
    @IBOutlet weak var favButton: UIButton!
    
    static let identifier = String(describing: NewsFeedCell.self)
    
    var delegate: NewsFeedCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        cardView.layer.cornerRadius = 10
        cardView.clipsToBounds = true
        newsImageView?.layer.cornerRadius = 10
        newsImageView.clipsToBounds = true
        
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    func configure(news: NewsModel) {
        self.sourceNameLabel.text = news.source.name
        self.titleLabel.text = news.title
        self.descriptionLabel.text = news.description
        self.dataLabel.text = self.dateFormat(dateString: news.publishedAt)
        self.authorLabel.text = news.author
        
        if let url = news.urlToImage {
            self.newsImageView.set(urlString: url)
            self.newsImageView.contentMode = .scaleAspectFill
        }
    }
    
    func configureWithCoreData(news: News) {
        self.favButton.isHidden = true
        self.sourceNameLabel.text = news.sourceName
        self.titleLabel.text = news.title
        self.descriptionLabel.text = news.newsDescription
        self.dataLabel.text = news.publishedAt
        self.authorLabel.text = news.author
        
        if let url = news.urlToImage {
            self.newsImageView.set(urlString: url)
            self.newsImageView.contentMode = .scaleAspectFill
        }
    }
    
    func dateFormat (dateString: String?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") 
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        guard let dateString = dateString, let date = dateFormatter.date(from: dateString) else {
            print("Can't convert string to date")
            return "today"}
        dateFormatter.dateFormat = "YY/MM/dd"
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
    
    @IBAction func favButtonTapped(_ sender: UIButton) {
        favButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
        favButton.isEnabled = false
        delegate?.favButtonTapped(tag: sender.tag)
    }
    
}
