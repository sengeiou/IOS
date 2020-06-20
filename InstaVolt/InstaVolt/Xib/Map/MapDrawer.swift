//
//  MapDrawer.swift
//  InstaVolt
//
//  Created by PCQ111 on 14/06/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import UIKit
import SDWebImage
import SafariServices

class MapDrawer: UIView
{
    //MARK:- Outlets -
    @IBOutlet weak var imageStation: UIImageView!
    @IBOutlet weak var imageStationNotAvailable: UIImageView!
    @IBOutlet weak var imageAvailableStation: UIImageView!
    @IBOutlet weak var imageInUseStation: UIImageView!
    @IBOutlet weak var viewStationUnavailable: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var labelNameAndPostalCode: UILabel!
    @IBOutlet weak var labelMaxChargerPowerAndUnit: UILabel!
    @IBOutlet weak var labelPower: UILabel!
    @IBOutlet weak var labelAvailableChargePoint: UILabel!
    @IBOutlet weak var labelInUseChargePoint: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buttonCharge: UIButton!
    @IBOutlet weak var buttonDirections: UIButton!
    
    //MARK:- Variables -
    var arrayFacilities = [Facilities]()
    var arrayStationImages = [Charge_location_images]()
    static let shadowHeight: CGFloat = 10.0
    static let viewHeight: CGFloat = 269.0 + shadowHeight
    let reuseIdentifier = "FacilitiesCollectionCell"
    var searchLatitude: Double = 0.0
    var searchLongitude: Double = 0.0
    
    var location : Location!
    {
        didSet
        {
            self.arrayFacilities.removeAll()
            self.arrayFacilities.append(contentsOf:
                location.facilities ?? [])
            
            self.arrayStationImages.removeAll()
            self.arrayStationImages.append(contentsOf:
                location.charge_location_images ?? [])
            
            setCollectionView()
            setName()
            
            self.imageStation.sd_setImage(with: URL(string: arrayStationImages[0].url?.stringValue ?? ""), placeholderImage: UIImage(), options: [], context: nil)
        }
    }
    
    //MARK:- Life cycle Methods -
    override func awakeFromNib()
    {
        super.awakeFromNib()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1)
        {
            self.addShadow(location: .top)
        }
    }
    
    //MARK:- Action Methods -
    @IBAction func chargeButton(_ sender: UIButton) {
        if let stationDetail = R.storyboard.stationListing.stationDetailViewController()
        {
            self.viewContainingController()?.navigationController?.pushViewController(stationDetail, animated: true)
        }
    }
    
    @IBAction func directionButton(_ sender: UIButton)
    {
        if (UIApplication.shared.canOpenURL(URL(string:"http://maps.apple.com")!)) {
            if searchLatitude != 0 && searchLongitude != 0
            {
                UIApplication.shared.open(URL(string:
                    "http://maps.apple.com/?saddr=\(searchLatitude),\(searchLongitude)&daddr=\(location.latitude?.doubleValue ?? 0.0),\(location.longitude?.doubleValue ?? 0.0)dirflg=d")!)
            }
            else
            {
                UIApplication.shared.open(URL(string:
                    "http://maps.apple.com/?daddr=\(location.latitude?.doubleValue ?? 0.0),\(location.longitude?.doubleValue ?? 0.0)dirflg=d")!)
            }
        }
            else if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)
            {
                if searchLatitude != 0 && searchLongitude != 0
                {
                    UIApplication.shared.open(URL(string: "comgooglemaps://?saddr\(searchLatitude),\(searchLongitude)=&daddr=\(location.latitude?.doubleValue ?? 0.0),\(location.longitude?.doubleValue ?? 0.0)&directionsmode=driving")!, options: [:], completionHandler: nil)
                }
                else
                {
                    UIApplication.shared.open(URL(string: "comgooglemaps://?saddr=&daddr=\(location.latitude?.doubleValue ?? 0.0),\(location.longitude?.doubleValue ?? 0.0)&directionsmode=driving")!, options: [:], completionHandler: nil)
                }
            }
            else
            {
                if searchLatitude != 0 && searchLongitude != 0
                {
                    let svc = SFSafariViewController(url: URL(string: "http://maps.google.com/maps?q=\(searchLatitude)\(searchLongitude)loc:\(location.latitude?.doubleValue ?? 0.0)\(location.latitude?.doubleValue ?? 0.0)")!)
                    self.viewContainingController()?.present(svc, animated: true, completion: nil)
                }
                else
                {
                    let svc = SFSafariViewController(url: URL(string: "http://maps.google.com/maps?q=loc:\(location.latitude?.doubleValue ?? 0.0)\(location.latitude?.doubleValue ?? 0.0)")!)
                    self.viewContainingController()?.present(svc, animated: true, completion: nil)
                }
            }
        //}
    }
    
    //MARK:- Custom Methods -
    func setName()
    {
        if(location?.available_stations == 0 && location?.in_use_stations == 0)
        {
            let myString = (location.name?.stringValue ?? "") + " " + (location?.postal_code?.stringValue ?? "")
            let myAttribute = [NSAttributedString.Key.foregroundColor: UIColor.colorWithRGB(red: 64.0, green: 64.0, blue: 64.0, alpha: 1.0)]
            labelNameAndPostalCode.attributedText = NSAttributedString(string: myString, attributes: myAttribute)
            
            
            
            labelPower.text = (self.location.max_charging_power?.stringValue ?? "")
            labelMaxChargerPowerAndUnit.text = " kw " +  (location?.max_charging_power_unit?.stringValue ?? "")
            labelPower.textColor = UIColor.colorWithRGB(red: 76.0, green: 76.0, blue: 76.0, alpha: 1.0)
            labelMaxChargerPowerAndUnit.textColor = UIColor.colorWithRGB(red: 76.0, green: 76.0, blue: 76.0, alpha: 1.0)
            
            
            buttonCharge.isHidden = true
            buttonDirections.isHidden = true
            
            imageStation.alpha = 0.5
            imageStationNotAvailable.isHidden = false
            
            viewStationUnavailable.isHidden = false
            stackView.isHidden = true
            
            imageInUseStation.isHidden = true
            labelInUseChargePoint.isHidden = true
        }
        else
        {
            let firstAttributedString = NSMutableAttributedString(string: (location.name?.stringValue ?? "") + " ")
            let attributedFormat = [NSAttributedString.Key.foregroundColor: UIColor(red: 0.717, green: 0.196, blue: 0.177, alpha: 1.0)]
            firstAttributedString.append(NSAttributedString(string: (location?.postal_code?.stringValue ?? ""), attributes: attributedFormat as [NSAttributedString.Key : Any]))
            labelNameAndPostalCode.attributedText = firstAttributedString
            
            labelPower.text = (self.location.max_charging_power?.stringValue ?? "")
            labelPower.textColor = UIColor(red: 0.717, green: 0.196, blue: 0.177, alpha: 1.0)
            labelMaxChargerPowerAndUnit.text = " kw " + (location?.max_charging_power_unit?.stringValue ?? "")
            labelMaxChargerPowerAndUnit.textColor = UIColor.black
            
            buttonCharge.isHidden = false
            buttonDirections.isHidden = false
            
            imageStation.alpha = 1.0
            imageStationNotAvailable.isHidden = true
            
            viewStationUnavailable.isHidden = true
            stackView.isHidden = false
            
            labelAvailableChargePoint.text = (location?.available_stations?.stringValue ?? "-") + " Available"
            
            imageInUseStation.isHidden = false
            labelInUseChargePoint.isHidden = false
            labelInUseChargePoint.text = (location?.in_use_stations?.stringValue ?? "-") + " In Use"
        }
    }
    
    func setCollectionView()
    {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.reloadData()
    }
}

//MARK:- Collection View Delegate & Data Source -
extension MapDrawer: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
     {
         return self.arrayFacilities.count
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
     {
         let cell : FacilitiesCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FacilitiesCollectionCell
         
         if(location?.available_stations == 0 && location?.in_use_stations == 0)
         {
             cell.imagefacilities.alpha = 0.5
         }
         else
         {
             cell.imagefacilities.alpha = 1.0
         }
         
         cell.imagefacilities.sd_setImage(with: URL(string: self.arrayFacilities[indexPath.item].image?.stringValue ?? ""), placeholderImage: UIImage(), options: [], context: nil)
         return cell
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
     {
         return CGSize(width: 24, height: 24)
     }
}
