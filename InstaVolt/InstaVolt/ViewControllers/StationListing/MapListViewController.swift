//
//  MapListViewViewController.swift
//  InstaVolt
//
//  Created by PCQ177 on 10/06/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapListViewController: BaseViewController {

    //MARK:- Outlets -
    @IBOutlet weak var searchView: UIView!
    @IBOutlet var tableFooterView: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tableViewStationListing: UITableView!
    @IBOutlet weak var tableAddressList: UITableView!
    @IBOutlet weak var labelNoStationFound: UILabel!
    @IBOutlet weak var buttonFilter: UIButton!
    
    //MARK:- Variables -
    var stationLocations: LocationResponse?
    var locations   : [Location] = []
    var limit: Int = 10
    var offset: Int = 0
    var isAPILoading: Bool = false
    private var locationManager = CLLocationManager()
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var searchLatitude: Double = 0.0
    var searchLongitude: Double = 0.0
    var isFromFilter: Bool = false
    var isFromSearch: Bool = false
    
    //MARK- Pull To Refresh -
    var refreshController: UIRefreshControl {
        let tempRefreshController = UIRefreshControl()
        tempRefreshController.attributedTitle = NSAttributedString(string: String.Title.pullToRefresh)
        tempRefreshController.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        return tempRefreshController
    }
    
    //create a completer
    lazy var searchCompleter: MKLocalSearchCompleter = {
        let sC = MKLocalSearchCompleter()
        //sC.region = mapView.region
        sC.delegate = self
        return sC
    }()

    private var places = [MKLocalSearchCompletion]()

    private var closeButton : UIButton = {
        let closeButton = UIButton(frame : CGRect(x : 0, y : 0, width : 30, height : 30))
           closeButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 0)
           closeButton.setImage(#imageLiteral(resourceName: "cross"), for : .normal)
           closeButton.addTarget(self, action : #selector(closeButton(_ : )), for : .touchUpInside)
           return closeButton
       }()
    
    //MARK:- LifeCycle Methods -
    override func viewDidLoad()
    {
        super.viewDidLoad()
        prepareMapListView()
        callGetStationLocationAPI()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        let translate = CGAffineTransform(translationX: Device.screenWidth, y: 0)
        searchView.transform =  translate
        searchView.isHidden  = false
        if isFromFilter
        {
            offset = 0
            locations.removeAll()
            callGetStationLocationAPI()
            buttonFilter.isSelected = isFilterApply
        }
        
        self.txtSearch.endEditing(true)
        self.tableAddressList.isHidden = true
        self.tableViewStationListing.isHidden = false
        self.view.backgroundColor = UIColor.white
    }
    
    //MARK:- Prepare View Methods -
    private func prepareMapListView()
    {
        tableViewStationListing.refreshControl = refreshController
      
        setUpSearchTextField()
        if CLLocationManager.locationServicesEnabled()
        {
            switch CLLocationManager.authorizationStatus()
            {
                case .notDetermined:
                locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
                locationManager.startUpdatingLocation()

                case .restricted, .denied:
                 print("restricted")
                
                case .authorizedAlways, .authorizedWhenInUse:
                locationManager.delegate = self
                locationManager.startUpdatingLocation()
                latitude = locationManager.location?.coordinate.latitude ?? 0.0
                longitude = locationManager.location?.coordinate.longitude ?? 0.0
                @unknown default:
                break
            }
        }
        tableViewStationListing.refreshControl = refreshController
    }
    
    @objc func textFieldDidChange(_ textField: UITextField)
    {
        //change searchCompleter depends on searchBar's text
        if !textField.text!.isEmpty
        {
            searchCompleter.queryFragment = textField.text!
            self.tableAddressList.isHidden = false
            self.tableViewStationListing.isHidden = true
            self.view.backgroundColor = UIColor.init(named: "NavbarColor")
        }
        else
        {
            self.tableAddressList.reloadData()
        }
    }
    
    //MARK:- View Methods -
    
    //MARK:- Webservice Methods -
    private func callGetStationLocationAPI(isFromPullToRefresh: Bool = false, shouldShowProgress: Bool = true, isFromSearch: Bool = false)
    {
        isAPILoading = true
        self.tableAddressList.isHidden = true

        if shouldShowProgress
        {
            self.startLoading()
        }
        
        var parameter: [String: Any] = [
            Key.limit : limit,
            Key.offset: offset,
            Key.isListView: true
        ]
        
        if (isFromSearch == true)
        {
            parameter[Key.searchLatitude] = searchLatitude
            parameter[Key.searchLongitude] = searchLongitude
        }
        else
        {
            if latitude != 0 || longitude != 0
            {
                parameter[Key.currentLatitude] = latitude
                parameter[Key.currentLongitude] = longitude
            }
            if !distance.isEmpty
            {
                parameter[Key.distance] = distance
            }
            if status.count != 0
            {
                parameter[Key.status] = status
            }
            if amenities.count != 0
            {
                parameter[Key.amenities] = amenities
            }
            if power_types.count != 0
            {
                parameter[Key.power_types] = power_types
            }
            if connectors.count != 0
            {
                parameter[Key.connectors] = connectors
            }
        }

        MapController.shared.getChargeStationsOnMap(parameters: parameter, successCompletion: { (locationResponse) in
            
            self.stopLoading()
            self.isAPILoading = false
            self.tableAddressList.isHidden = true
            self.tableViewStationListing.isHidden = false
            self.view.backgroundColor = UIColor.white
            
            self.stationLocations = locationResponse
            
            if isFromSearch && self.offset == 0
            {
                self.locations.removeAll()
            }
            
            if isFromPullToRefresh
            {
                self.locations.removeAll()
            }
            self.locations.append(contentsOf: self.stationLocations?.data?.rows ?? [])
            if self.locations.count == 0
            {
                self.labelNoStationFound.isHidden = false
                if (isFromSearch == true)
                {
                    self.labelNoStationFound.text = String.Title.noStationWithSearch
                }
                else
                {
                    self.labelNoStationFound.text = String.Title.noStationWithFilter
                }
            }
            else
            {
                self.labelNoStationFound.isHidden = true
            }

            self.tableViewStationListing.reloadData()
            self.tableViewStationListing.tableFooterView = nil
           self.tableViewStationListing.refreshControl?.endRefreshing()
        }) { (error, errorResponse) in
            self.stopLoading()
            self.showValidationMessage(withMessage: error.errorMessage,withActions: {
                self.tableViewStationListing.isHidden = false
                self.tableAddressList.isHidden = true
                self.view.backgroundColor = UIColor.white

            })
        }
//        let jsonData = (try? JSONSerialization.data(withJSONObject: JSONObjectLocation.LocationDetails))!
//        stationLocations = try? JSONDecoder().decode(LocationResponse.self, from: jsonData)
//        self.locations.append(contentsOf: stationLocations?.data?.rows ?? [])
//        self.tableViewStationListing.tableFooterView = nil
//        tableViewStationListing.reloadData()
    }
    
    //MARK:- Action Methods -
    @IBAction func menuButton(_ sender: UIButton)
    {
        let sideBar = self.sideMenuController as! MainSideBarViewController
        sideBar.showLeftViewAnimated()
    }
    
    @IBAction func mapButton(_ sender: UIButton)
    {
        moveToMapScreen()
    }
    
    @IBAction func searchButton(_ sender: UIButton)
    {
        txtSearch.text = ""
        //places.removeAll()
        self.tableAddressList.reloadData()
        searchView(isHide: false)
    }
    
    
    @IBAction func filterButton(_ sender: UIButton)
    {
        moveToFilterScreen()
    }
    
    @IBAction func closeButton(_ sender: UIButton)
    {
        searchView(isHide: true)
        self.tableAddressList.isHidden = true
        self.tableViewStationListing.isHidden = false
        self.view.backgroundColor = UIColor.white

    }
    
    //MARK:- Custom Methods -
    @objc func pullToRefresh()
    {
        offset = 0
        callGetStationLocationAPI(isFromPullToRefresh: true,shouldShowProgress: false,isFromSearch:self.isFromSearch)
    }
    
    private func setUpSearchTextField()
    {
        let container = UIView(frame : closeButton.frame)
        container.backgroundColor = .clear
        container.addSubview(closeButton)
        txtSearch.leftViewMode = .always
        txtSearch.leftView = container
        
        txtSearch.addTarget(self, action: #selector(MapListViewController.textFieldDidChange(_:)),
        for: .editingChanged)
        self.tableAddressList.isHidden = true
    }
}
//MARK:- UITableView Delegate & DataSource -
extension MapListViewController: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(tableView == tableAddressList)
        {
            if !txtSearch.text!.isEmpty
            {
                return places.count
            }
            else
            {
                return 0
            }
        }
        else
        {
            return locations.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if(tableView == tableAddressList)
        {
            let cell = self.tableAddressList.dequeueReusableCell(withIdentifier: "AddressListTableCell", for: indexPath) as! AddressListTableCell
            if !txtSearch.text!.isEmpty
            {
                cell.labelAddress.text = self.places[indexPath.row].title
            }
            return cell
        }
        else
        {
            let stationListingCell = tableView.registerDeque(type: StationListingTableViewCell.self, indexPath: indexPath)
            stationListingCell.selectionStyle = .none
            stationListingCell.locationDetail = locations[indexPath.row]
            return stationListingCell
        }
    }
    

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if indexPath.row == locations.count - 1  && !isAPILoading && locations.count < stationLocations?.data?.count?.intValue ?? 0
        {
            offset = locations.count
            tableView.tableFooterView = tableFooterView
            callGetStationLocationAPI(isFromPullToRefresh: false, shouldShowProgress: false)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(tableView == tableAddressList)
        {
            if !txtSearch.text!.isEmpty
            {
                let item = self.places[indexPath.row]
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = item.subtitle
                let search = MKLocalSearch(request: request)
                search.start { (response, error) in
                    
                    guard let response = response else {return}
                    guard let item = response.mapItems.first else {return}
                    
                    self.searchLatitude = item.placemark.coordinate.latitude
                    self.searchLongitude = item.placemark.coordinate.longitude
                    
                    self.tableAddressList.isHidden = true
                    self.offset = 0
                    self.isFromSearch = true
                    self.callGetStationLocationAPI(isFromPullToRefresh: false, shouldShowProgress: true, isFromSearch: true)
                    
                    
                    self.txtSearch.text = self.places[indexPath.row].title
                    //self.searchView(isHide: true)
                    self.txtSearch.endEditing(true)
                }
            }
        }
        else
        {
            moveToStationDetailScreen()
        }
    }
}

extension MapListViewController: MKLocalSearchCompleterDelegate
{
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter)
    {
        places = completer.results
        
        DispatchQueue.main.async{
            self.tableAddressList.reloadData()
        }
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error)
    {
        print(error.localizedDescription)
    }
}

//MARK:- Navigation Methods -
extension MapListViewController
{
    private func moveToFilterScreen()
    {
        if let filterScreen = R.storyboard.setting.filterViewController()
        {
            self.navigationController?.pushViewController(filterScreen, animated: true)
        }
    }
    
    private func moveToMapScreen()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func moveToStationDetailScreen()
    {
        if let stationDetail = R.storyboard.stationListing.stationDetailViewController()
        {
            self.navigationController?.pushViewController(stationDetail, animated: true)
        }
    }
}
//MARK:- Search TextField Method -
extension MapListViewController {
    private func searchView(isHide : Bool) {
        if isHide {
            UIView.animate(withDuration: 1.0 ,delay: 0.0, options: [.curveEaseInOut], animations: {
                self.searchView.transform = CGAffineTransform(translationX: Device.screenWidth, y: 0)
            }) { (status) in
            }
        } else {
            UIView.animate(withDuration: 1.0 ,delay: 0.0, options: [.curveEaseInOut], animations: {
                self.searchView.transform =  CGAffineTransform.identity
            }) { (status) in
            }
        }
    }
}
//MARK:- Text Field Extension -
extension MapListViewController: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
//        self.tableAddressList.isHidden = false
//        self.tableViewStationListing.isHidden = true
//        self.view.backgroundColor = UIColor.init(named: "NavbarColor")
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
            return true
    }
}
//MARK:- CLLocation Manager Delegate -
extension MapListViewController: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        latitude = locValue.latitude
        longitude = locValue.longitude
    }
}
