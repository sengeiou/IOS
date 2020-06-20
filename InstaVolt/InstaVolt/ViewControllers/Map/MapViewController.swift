//
//  MapViewController.swift
//  InstaVolt
//
//  Created by PCQ111 on 15/05/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import UIKit
import AWSMobileClient
import MapKit
import CoreLocation

extension Location
{
    func getCLLocation() -> CLLocation
    {
        return CLLocation(latitude: latitude?.doubleValue ?? 0.0, longitude: longitude?.doubleValue ?? 0.0)
    }
}

class MapViewController: BaseViewController, MKMapViewDelegate, CLLocationManagerDelegate
{
    //MARK:- Outlets -
    @IBOutlet weak var buttonSideMenu: UIButton!
    @IBOutlet weak var buttonFilter: UIButton!
    @IBOutlet weak var buttonList: UIButton!
    @IBOutlet weak var buttonSearch: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var buttonCurrentLocation: UIButton!
    @IBOutlet weak var buttonSatelliteView: UIButton!
    @IBOutlet weak var buttonCurrentLocationBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tblAddressList: UITableView!
    @IBOutlet weak var LabelNoStationFound: UILabel!

    //MARK:- Variables -
    private var isSignedInDone : Bool = false
    private var locationManager = CLLocationManager()
    private var locationResponse: LocationResponse?
    private var arrLocationDetails: [Location]?
    private var drawer : MapDrawer?
    var isFromFilter: Bool = false
    var currentLocation : CLLocation?
    var searchLocation : CLLocation?

    
    private var closeButton : UIButton = {
        let closeButton = UIButton(frame : CGRect(x : 0, y : 0, width : 30, height : 30))
           closeButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 0)
           closeButton.setImage(#imageLiteral(resourceName: "cross"), for : .normal)
           closeButton.addTarget(self, action : #selector(closeButton(_ : )), for : .touchUpInside)
           return closeButton
       }()
    
    //create a completer
    lazy var searchCompleter: MKLocalSearchCompleter = {
        let sC = MKLocalSearchCompleter()
        //sC.region = mapView.region
        sC.delegate = self
        return sC
    }()

    private var places = [MKLocalSearchCompletion]()

    
    //MARK:- Life Cycle Methods -
    override func viewDidLoad()
    {
        super.viewDidLoad()
        checkSignInDoneOrNot()
        registerAnnotationViewClass()
        enableCurrentLocation()
        getStationAPICall()
        prepareView()
        setUpSearchTextField()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        let translate = CGAffineTransform(translationX: Device.screenWidth, y: 0)
        searchView.transform =  translate
        searchView.isHidden  = false
        if isFromFilter
        {
            getStationAPICall()
            buttonFilter.isSelected = isFilterApply
        }
    }
    
    //MARK:- Action Methods -
    @IBAction func switchMapModes(_ sender: Any)
    {
        if(mapView.mapType == MKMapType.standard)
        {
            mapView.mapType = MKMapType.satellite
            self.buttonSatelliteView.setImage(UIImage(named: "satelliteMap"), for: .normal)
        }
        else
        {
            mapView.mapType = MKMapType.standard
            self.buttonSatelliteView.setImage(UIImage(named: "standardMap"), for: .normal)
        }
    }
    
    @IBAction func currentLocation(_ sender: Any)
    {
         setReagion()
    }
    @IBAction func search(_ sender: Any)
    {
        txtSearch.text = ""
        places.removeAll()
        self.tblAddressList.reloadData()
        searchView(isHide: false)
    }
    
    @IBAction func list(_ sender: Any)
    {
        moveToStationListing()
    }
    
    @IBAction func filter(_ sender: Any)
    {
        moveToFilter()
    }
    
    @IBAction func closeButton(_ sender: UIButton)
    {
        //remove searched location annotation
        self.mapView.annotations.forEach { (annotation) in
            
            if let annotation = annotation as? SearchPointAnnotation
            {
                mapView.removeAnnotation(annotation)
            }
        }
        searchLocation = nil
        searchView(isHide: true)
        self.tblAddressList.isHidden = true
    }
    
    @IBAction func menuButton(_ sender: UIButton)
    {
        let sideBar = self.sideMenuController as! MainSideBarViewController
        sideBar.showLeftViewAnimated()
    }
    
    
    //MARK:- Custom Methods -
    private func setReagion()
    {
        currentLocation = locationManager.location
        if(currentLocation == nil)
        {
            currentLocation = CLLocation(latitude: 51.378272, longitude: -0.013854)
        }
        
        let location  = closestLocation(locations: arrLocationDetails!, closestToLocation: currentLocation!)


             if(location != nil)
             {
                let distanceInMeters = currentLocation!.distance(from: location!)

                let span = MKCoordinateSpan(latitudeDelta: 4 * abs((location?.coordinate.latitude)! - currentLocation!.coordinate.latitude),
                                            longitudeDelta: 4 * abs(location!.coordinate.longitude - currentLocation!.coordinate.longitude))

                let region = MKCoordinateRegion(center: currentLocation!.coordinate,
                                                 span: span)
//                if region.IsValid
//                {
                    self.mapView.setRegion(region, animated: true)
//                }
//                else
//                {
//                    self.mapView.setRegion(MKCoordinateRegion(center: currentLocation!.coordinate, latitudinalMeters: 10, longitudinalMeters: 10), animated: true)
//                }
             }
    }
    
    func closestLocation(locations: [Location], closestToLocation location: CLLocation) -> CLLocation?
    {
        if let closestLocation = locations.min(by: { location.distance(from: $0.getCLLocation()) < location.distance(from: $1.getCLLocation()) })
        {
            return closestLocation.getCLLocation()
        }
        else
        {
            var currentLocation = locationManager.location
            if(currentLocation == nil)
            {
                currentLocation = CLLocation(latitude: 51.378272, longitude: -0.013854)
            }
            return currentLocation
        }
    }
    
    private func setUpSearchTextField()
    {
        let container = UIView(frame : closeButton.frame)
        container.backgroundColor = .clear
        container.addSubview(closeButton)
        
        txtSearch.leftViewMode = .always
        txtSearch.leftView = container
    }
    
    func registerAnnotationViewClass()
    {
        mapView.register(IVAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(IVAnnotationClusterView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    func enableCurrentLocation()
    {
        if CLLocationManager.locationServicesEnabled()
        {
            switch CLLocationManager.authorizationStatus()
            {
                case .notDetermined:
                locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
                locationManager.startUpdatingLocation()
                mapView.showsUserLocation = true

                case .restricted, .denied:
                 print("restricted")
                
                case .authorizedAlways, .authorizedWhenInUse:
                locationManager.delegate = self
                locationManager.startUpdatingLocation()
                mapView.showsUserLocation = true

                @unknown default:
                break
            }
        }
        else
        {
            print("Location services are not enabled")
        }
    }
    
    func getStationAPICall()
    {
        var parameters: [String: Any] = [:]
        if !distance.isEmpty
         {
             parameters[Key.distance] = distance
         }
         if status.count != 0
         {
             parameters[Key.status] = status
         }
         if amenities.count != 0
         {
             parameters[Key.amenities] = amenities
         }
         if power_types.count != 0
         {
             parameters[Key.power_types] = power_types
         }
         if connectors.count != 0
         {
             parameters[Key.connectors] = connectors
         }
        if isFromFilter
        {
            var currentLocation = locationManager.location
            if(currentLocation == nil)
            {
                currentLocation = CLLocation(latitude: 51.378272, longitude: -0.013854)
            }
            parameters[Key.currentLatitude] = currentLocation?.coordinate.latitude
            parameters[Key.currentLongitude] = currentLocation?.coordinate.longitude
        }
        arrLocationDetails = locationResponse?.data?.rows
        debugPrint(parameters)
        
        //Call get Charge Stations On Map API
        MapController.shared.getChargeStationsOnMap(parameters: parameters, successCompletion: { (locationResponse) in
            self.stopLoading()
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.locationResponse = locationResponse
            
            if (self.locationResponse?.data) != nil
            {
                self.stopLoading()
                self.arrLocationDetails = locationResponse.data?.rows
                if locationResponse.data?.rows?.count == 0
                {
                    self.LabelNoStationFound.isHidden = false
                }
                else
                {
                    self.LabelNoStationFound.isHidden = true
                }
                
                self.arrLocationDetails?.forEach { (locationObject) in
                    self.mapView.addAnnotation(IVPointAnnotation(coordinate: CLLocationCoordinate2D(latitude: locationObject.latitude?.doubleValue ?? 0.0, longitude: locationObject.longitude?.doubleValue ?? 0.0), location: locationObject))
                }
                self.setReagion()
            }
        }) { (error, resError) in
            self.showAPIerror(error: error, resError: resError) {
                //                self.getStationAPICalltemp()
                self.showValidationMessage(withMessage: error.errorMessage)
            }
        }
        
        //        let jsonData = (try? JSONSerialization.data(withJSONObject: JSONObjectLocation.LocationDetails))!
        //
        //        locationResponse = try? JSONDecoder().decode(LocationResponse.self, from: jsonData)
        //
        //        arrLocationDetails = locationResponse?.data?.rows
        //
        //        arrLocationDetails?.forEach { (locationObject) in
        //            mapView.addAnnotation(IVPointAnnotation(coordinate: CLLocationCoordinate2D(latitude: locationObject.latitude?.doubleValue ?? 0.0, longitude: locationObject.longitude?.doubleValue ?? 0.0), location: locationObject))
        //        }
    }
    
    func prepareView()
    {
         drawer = UINib(nibName: "MapDrawer", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? MapDrawer
         drawer?.roundCorners(corners: [.topLeft, .topRight], radius: 25)
         drawer?.frame = CGRect(x: 0, y: self.view.bounds.height, width: self.view.bounds.width, height: MapDrawer.viewHeight)
        self.view.addSubview(drawer!)
        
        mapView.mapType = MKMapType.standard
        
        
        txtSearch.addTarget(self, action: #selector(MapViewController.textFieldDidChange(_:)),
        for: .editingChanged)
        self.tblAddressList.isHidden = true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField)
    {
        //change searchCompleter depends on searchBar's text
        if !textField.text!.isEmpty {
            self.tblAddressList.isHidden = false
            searchCompleter.queryFragment = textField.text!
        }
        else
        {
            self.tblAddressList.reloadData()
        }
    }
    
    func checkSignInDoneOrNot()
    {
        let showSignUp = UserDefault[Key.dontShowSignUpAlertForGuest] as? Bool ?? false
        if(showSignUp == false)//User has not pressed don't sign in popup
        {
            let userType = UserDefault[Key.userType] as? Int ?? 0
            if(userType == 1) //guest
            {
                if (isSignedInDone == false)
                {
                    self.showAlertForNotSignedInUser()
                }
                else //sign up done
                {
                    
                }
            }
        }
    }
    
    func showAlertForNotSignedInUser()
    {
        let actionDontShow = UIAlertAction(title: String.Title.doNotShowAgain, style: UIAlertAction.Style.default) { (_) in
            UserDefault[Key.dontShowSignUpAlertForGuest] = true
        }
        let actionMoveToSignUp = UIAlertAction(title: String.Title.yes, style: UIAlertAction.Style.default) { (_) in
            
            self.moveToLandingScreen()
        }
        self.showAlert(message: String.Title.wantToSignInOrUp, actions: [actionDontShow,actionMoveToSignUp])
    }
}


//MARK:- Text Field Extension -
extension MapViewController: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        //self.tblAddressList.isHidden = false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }
}

extension MapViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.tblAddressList.dequeueReusableCell(withIdentifier: "AddressListTableCell", for: indexPath) as! AddressListTableCell

        if !txtSearch.text!.isEmpty
        {
                    cell.labelAddress.text = self.places[indexPath.row].title
            //            + " " + searchResult.subtitle

        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
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
                
                
                //remove searched location annotation
                self.mapView.annotations.forEach { (annotation) in
                    
                    if let annotation = annotation as? SearchPointAnnotation
                    {
                        self.mapView.removeAnnotation(annotation)
                    }
                }
                
                self.searchLocation = CLLocation(latitude: item.placemark.coordinate.latitude, longitude: item.placemark.coordinate.longitude)
                self.mapView.addAnnotation(SearchPointAnnotation(coordinate: CLLocationCoordinate2D(latitude: item.placemark.coordinate.latitude , longitude: item.placemark.coordinate.longitude)))
                
                self.mapView.setCenter(item.placemark.coordinate, animated: true)
                self.tblAddressList.isHidden = true
                self.txtSearch.text = self.places[indexPath.row].title
                //self.searchView(isHide: true)
            }
        }

    }
}

extension MapViewController: MKLocalSearchCompleterDelegate
{
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter)
    {
        places = completer.results
        
        DispatchQueue.main.async{
            self.tblAddressList.reloadData() 
        }
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error)
    {
        print(error.localizedDescription)
    }
}

//MARK:- MapView Methods -
extension MapViewController
{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        
        if let annotation =  annotation as? SearchPointAnnotation
        {
             return SearchAnnotationView(annotation: annotation, reuseIdentifier: SearchAnnotationView.ReuseID)
        }
        
        
        guard let annotation = annotation as? IVPointAnnotation else { return nil }
        return IVAnnotationView(annotation: annotation, reuseIdentifier: IVAnnotationView.ReuseID)
    }
    
      func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
      {
          if let cluster = view as? IVAnnotationClusterView
          {
              if let mkClusterAnnotation = cluster.annotation as? MKClusterAnnotation
              {
                  self.mapView.showAnnotations(mkClusterAnnotation.memberAnnotations, animated: true)
              }
          }
          if let selectedAnnotationView = view as? IVAnnotationView
          {
              if let annotation = selectedAnnotationView.annotation as? IVPointAnnotation
              {
                drawer?.location = annotation.location
                drawer?.searchLatitude = searchLocation?.coordinate.latitude ?? 0.0
                drawer?.searchLongitude = searchLocation?.coordinate.longitude ?? 0.0
                UIView.animate(withDuration: 0.25) {
                    self.drawer?.frame = CGRect(x: 0, y: self.view.bounds.height - MapDrawer.viewHeight, width: self.view.bounds.width, height: MapDrawer.viewHeight)
                    
                    self.buttonCurrentLocationBottomConstraint.constant = MapDrawer.viewHeight
                }
                                   
                  if(annotation.color == .red)
                  {
                      view.image = UIImage(named: "redIconBig")
                  }
                  else
                  {
                      view.image = UIImage(named: "blackIconBig")
                  }
              }
          }
      }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView)
    {
        if let selectedAnnotationView = view as? IVAnnotationView
        {
            if let annotation = selectedAnnotationView.annotation as? IVPointAnnotation
            {
                if(annotation.color == .red)
                {
                    view.image = UIImage(named: "redIcon")
                }
                else
                {
                    view.image = UIImage(named: "blackIcon")
                }
                self.dismissPinDetails()
            }
        }
    }
    
    func dismissPinDetails()
    {
//        for subView in self.view.subviews
//        {
//            if let drawer = subView as? MapDrawer
//            {
                UIView.animate(withDuration: 0.10) {
                    self.drawer?.frame.origin.y = self.view.frame.height
                    
                    self.buttonCurrentLocationBottomConstraint.constant = 54
                }
//            }
//        }
    }
}

//MARK:- Location Manager Methods -
//extension MapViewController
//{
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
//    {
//        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
//
//        mapView.mapType = MKMapType.standard
//
//        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//        let region = MKCoordinateRegion(center: locValue, span: span)
//        mapView.setRegion(region, animated: true)
//    }
//}

//MARK:- Navigations Methods -
extension MapViewController
{
    func moveToLandingScreen()
    {
        if let landingScreen = R.storyboard.login.landingViewController()
        {
            navigationController?.pushViewController(landingScreen, animated: true)
        }
    }
    
    private func moveToLogin()
    {
        if let loginScreen = R.storyboard.login.loginViewController()
        {
            self.navigationController?.pushViewController(loginScreen, animated: true)
        }
    }
    
    private func moveToFilter()
    {
        if let filterScreen = R.storyboard.setting.filterViewController()
        {
            self.navigationController?.pushViewController(filterScreen, animated: true)
        }
    }
    
    private func moveToStationListing()
    {
        if let stationList = R.storyboard.stationListing.mapListViewViewController()
        {
            self.navigationController?.pushViewController(stationList, animated: true)
        }
    }
}


//MARK:- Search TextField Method -
extension MapViewController {
    private func searchView(isHide : Bool) {
        if isHide {
            self.view.endEditing(true)
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

extension MKCoordinateRegion
{
    var IsValid: Bool {
        get {
            let latitudeCenter = self.center.latitude
            let latitudeNorth = self.center.latitude + self.span.latitudeDelta/2
            let latitudeSouth = self.center.latitude - self.span.latitudeDelta/2

            let longitudeCenter = self.center.longitude
            let longitudeWest = self.center.longitude - self.span.longitudeDelta/2
            let longitudeEast = self.center.longitude + self.span.longitudeDelta/2

            let topLeft = CLLocationCoordinate2D(latitude: latitudeNorth, longitude: longitudeWest)
            let topCenter = CLLocationCoordinate2D(latitude: latitudeNorth, longitude: longitudeCenter)
            let topRight = CLLocationCoordinate2D(latitude: latitudeNorth, longitude: longitudeEast)

            let centerLeft = CLLocationCoordinate2D(latitude: latitudeCenter, longitude: longitudeWest)
            let centerCenter = CLLocationCoordinate2D(latitude: latitudeCenter, longitude: longitudeCenter)
            let centerRight = CLLocationCoordinate2D(latitude: latitudeCenter, longitude: longitudeEast)

            let bottomLeft = CLLocationCoordinate2D(latitude: latitudeSouth, longitude: longitudeWest)
            let bottomCenter = CLLocationCoordinate2D(latitude: latitudeSouth, longitude: longitudeCenter)
            let bottomRight = CLLocationCoordinate2D(latitude: latitudeSouth, longitude: longitudeEast)

            return  CLLocationCoordinate2DIsValid(topLeft) &&
                CLLocationCoordinate2DIsValid(topCenter) &&
                CLLocationCoordinate2DIsValid(topRight) &&
                CLLocationCoordinate2DIsValid(centerLeft) &&
                CLLocationCoordinate2DIsValid(centerCenter) &&
                CLLocationCoordinate2DIsValid(centerRight) &&
                CLLocationCoordinate2DIsValid(bottomLeft) &&
                CLLocationCoordinate2DIsValid(bottomCenter) &&
                CLLocationCoordinate2DIsValid(bottomRight) ?
                  true :
                  false
        }
    }
}
