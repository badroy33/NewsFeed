//
//  FilterViewController.swift
//  NewsFeed
//
//  Created by Maksym Levytskyi on 11.07.2021.
//

import UIKit

class FilterViewController: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    
    let elementPicker = UIPickerView()
    
    let networkService = NetworkService()
    
    let sourcesUrl = "https://newsapi.org/v2/top-headlines/sources?apiKey=41321592d29a4950a37ca299bb94f6d6"
    
    var id: [String] = []
    var titles: [String] = []
    
    var categoryId = ["","&category=business", "&category=entertainment", "&category=general", "&category=health", "&category=science", "&category=sports", "&category=technology"]
    var categoryTitle = ["All categories","Business", "Entertainment", "General", "Health", "Science", "Sports", "Technology"]
    
    var countriesId = ["country=au", "country=be", "country=br", "country=ca", "country=cz", "country=de", "country=it", "country=pl", "country=pt", "country=se", "country=ua", "country=us"]
    var countriesTitles = ["Australia", "Belgium", "Brazil", "Canada", "Czech Republic", "Germany", "Italy", "Poland", "Portugal", "Sweeden", "Ukraine", "USA"]
    
    var sourcesId: [String] = []
    var sourcesTitles: [String] = []
    
    
    var selectedCountry = "country=us"
    var selectedCategory = ""
    var selectedSource: String = ""
    
    var selectedCountryTitle = "country=us"
    var selectedCategoryTitle = ""
    var selectedSourceTitle = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        elementPicker.delegate = self
        textField.inputView = elementPicker
        textField.tintColor = .clear
        
        networkService.getSources(urlString: sourcesUrl) { result in
            switch result{
            case .success(let sources):
                sources.map({ source in
                    self.sourcesId.append("sources=\(source.id)")
                    self.sourcesTitles.append(source.name)
                })
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        segmentedControl.selectedSegmentIndex = 0
        if segmentedControl.selectedSegmentIndex == 0 {
            self.id = countriesId
            self.titles = countriesTitles
        }
        
        searchButton.layer.cornerRadius = searchButton.frame.width / 2
        searchButton.clipsToBounds = true
    }
    
    @IBAction func selectSegment(_ sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            self.id = countriesId
            self.titles = countriesTitles
            self.elementPicker.reloadAllComponents()
            self.textField.text = ""
            self.textField.placeholder = "Select a country"
            self.textField.text = selectedCountryTitle
        case 1:
            self.id = categoryId
            self.titles = categoryTitle
            self.elementPicker.reloadAllComponents()
            self.textField.text = ""
            self.textField.placeholder = "Select a category"
            self.textField.text = selectedCategoryTitle
            self.reloadInputViews()
        case 2:
            self.id = sourcesId
            self.titles = sourcesTitles
            self.elementPicker.reloadAllComponents()
            self.textField.text = ""
            self.textField.placeholder = "Select source"
            self.textField.text = selectedSourceTitle
        default:
            print("Error")
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let urlString = "https://newsapi.org/v2/top-headlines?\(selectedCountry)\(selectedCategory)\(selectedSource)&apiKey=41321592d29a4950a37ca299bb94f6d6"
        print(urlString)
        
        let navigationVC = segue.destination as! UINavigationController
        navigationVC.modalPresentationStyle = .fullScreen
        let newsFeedVC = navigationVC.topViewController as! NewsFeedViewController
        newsFeedVC.url = urlString
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

//MARK: - UIPickerViewDelegate, UIPickerViewDataSource 

extension FilterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return id.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return titles[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            self.selectedCountry = id[row]
            self.selectedCountryTitle = titles[row]
            self.countryLabel.text = "Country: \(selectedCountryTitle)"
            self.selectedSource = ""
            self.selectedSourceTitle = ""
            self.sourceLabel.text = "Source: \(selectedSourceTitle)"
        case 1:
            self.selectedCategory = id[row]
            self.selectedCategoryTitle = titles[row]
            if self.selectedCountry == "" {
                self.selectedCountry = "country=us"
                self.selectedCountryTitle = "USA"
                self.countryLabel.text = "Country: \(selectedCountryTitle)"
            }
            self.categoryLabel.text = "Category: \(selectedCategoryTitle)"
            self.selectedSource = ""
            self.selectedSourceTitle = ""
            self.sourceLabel.text = "Source: \(selectedSourceTitle)"
        case 2:
            self.selectedSource = id[row]
            self.selectedSourceTitle = titles[row]
            self.sourceLabel.text = "Source: \(selectedSourceTitle)"
            self.textField.text = titles[row]
            self.selectedCategory = ""
            self.selectedCategoryTitle = ""
            self.categoryLabel.text = "Category: \(selectedCategoryTitle)"
            self.selectedCountry = ""
            self.selectedCountryTitle = ""
            self.countryLabel.text = "Country: \(selectedCountryTitle)"
            
        default:
            print("error")
        }
        let titleOfSelectedElement = titles[row]
        textField.text = titleOfSelectedElement
    }
}
