//
//  AirportsViewController.swift
//  Airports
//
//  Created by Никита on 04/10/2020.
//  Copyright © 2020 Nikita. All rights reserved.
//

import UIKit

struct Airport: Codable {
    
    var cityName: String {
        return cityRus ?? cityEng ?? ""
    }
    
    var iata: String{
        return iataCode ?? ""
    }
    
    var isao: String{
        return iataCode ?? ""
    }
    
    
    var countryName: String {
        return countryRus ?? countryEng ?? ""
    }
    
    var iataCode: String?
    var icaoCode: String?
    var nameRus: String?
    var nameEng: String?
    var cityRus: String?
    var cityEng: String?
    var countryRus: String?
    var countryEng: String?
    var isoCode: String?
    var latitude: Double
    var longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case iataCode   = "iata_code"
        case icaoCode   = "icao_code"
        case nameRus    = "name_rus"
        case nameEng    = "name_eng"
        case cityRus    = "city_rus"
        case cityEng    = "city_eng"
        case countryRus = "country_rus"
        case countryEng = "country_eng"
        case isoCode    = "iso_code"
        case latitude
        case longitude
    }
}

protocol AirportsDelegate: class {
    func setAirport(airport: Airport)
}



class AirportsViewController: UIViewController {
    private var airports: [Airport] = []
    private var reservedAirports: [Airport] = []
    weak var delegate: AirportsDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
        tableView.reloadData()
    }
    
    @IBAction func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    private func prepare() {
        guard
            let file = Bundle.main.url(forResource: "airports", withExtension: "json") else {
                return
        }
        
        do {
            let data = try Data(contentsOf: file)
            let airports = try JSONDecoder().decode([Airport].self, from: data)
            self.airports = airports
            self.reservedAirports = airports
        }
        catch {
            print(error.localizedDescription)
        }
    }
}


extension AirportsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return airports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AirportCell
        let airport = airports[indexPath.row]
        let text = airport.cityName + " | " + airport.countryName
        cell.titleLabel.text = text
        
        return cell
    }
    
    
}
extension AirportsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let airport = airports[indexPath.row]
        self.delegate?.setAirport(airport: airport)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

extension AirportsViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            airports = reservedAirports
        }else{
            airports = reservedAirports.filter({airport -> Bool in
                let text = searchText.lowercased()
                return airport.cityName.lowercased().contains(text) ||
                    airport.iata.lowercased().hasPrefix(text) ||
                    airport.isao.lowercased().hasPrefix(text)
            })
        }
        tableView.reloadData()
    }
}
