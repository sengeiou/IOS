//
//  StationListingTableViewCell.swift
//  InstaVolt
//
//  Created by PCQ177 on 10/06/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import UIKit

class StationListingTableViewCell: UITableViewCell {

    //MARK:- Outlets -
    
    @IBOutlet weak var collectionViewamenitiesImage: UICollectionView!
    @IBOutlet weak var labelDuration: UILabel!
    @IBOutlet weak var labelPostalCode: UILabel!
    @IBOutlet weak var labelStationAddress: UILabel!
    @IBOutlet weak var labelStationName: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var collectionVIewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    //MARK:- Variables -
    var locationDetail: Location? {
        didSet {
            labelStationName.text = locationDetail?.name?.stringValue
            labelStationAddress.text = locationDetail?.address?.stringValue
            labelPostalCode.text = locationDetail?.postal_code?.stringValue
            labelDuration.text = locationDetail?.distance?.stringValue
            if locationDetail?.facilities?.count == 0 || locationDetail?.facilities?.count == nil {
                collectionVIewHeight.constant = 0.0
                collectionViewamenitiesImage.reloadData()
                collectionViewBottomConstraint.constant = 0.0
            }
            else
            {
                collectionVIewHeight.constant = 20.0
                collectionViewamenitiesImage.reloadData()
                collectionViewBottomConstraint.constant = 17.5
            }
        }
    }
    
    //MARK:- LifeCycle Methods -
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
//MARK:- Collection View Delegate & DataSource -
extension StationListingTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locationDetail?.facilities?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let amenitiesCell = collectionView.registerDeque(type: AmenitiesImageCollectionViewCell.self, indexPath: indexPath)
        amenitiesCell.faility = locationDetail?.facilities?[indexPath.row]
        return amenitiesCell
    }
}
//MARK:- Collection View Delegate Flow Layout -
extension StationListingTableViewCell: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 20.0, height: 20.0)
    }
}
