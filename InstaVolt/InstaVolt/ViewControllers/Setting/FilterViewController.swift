//
//  FilterViewController.swift
//  InstaVolt
//
//  Created by PCQ177 on 09/06/20.
//  Copyright © 2020 PCQ111. All rights reserved.
//

import UIKit

class FilterViewController: BaseViewController {
    
    //MARK:- Outlets -
    @IBOutlet weak var tableViewCategory: UITableView!
    @IBOutlet weak var tableViewSubCategory: UITableView!
    @IBOutlet weak var buttonApply: UIButton!
    
    //MARK:- Variables -
    var selectedFilterCategory: FilterCategory?
    var selectedFilterIndex: Int = 0
    
    //MARK:- Lifecycle Methods -
    override func viewDidLoad() {
        super.viewDidLoad()
        if filterCategoryArray.count == 0 {
            self.callGetFilterAPI()
        } else {
            let _ = filterCategoryArray.map({$0.isSelected = false})
            filterCategoryArray[0].isSelected = true
            selectedFilterCategory = filterCategoryArray[0]
            tableViewCategory.reloadData()
            tableViewSubCategory.reloadData()
        }
        enableDisableApplyButton()
    }
    
    //MARK:- View Methods -
    private func prepareFilterView()
    {
        filterCategoryArray.append(FilterCategory.init(id: 1, name: "Distance", subCategoryArray: filterSubCategory?.data?.distance ?? []))
        filterCategoryArray.append(FilterCategory.init(id: 2, name: "Status", subCategoryArray: filterSubCategory?.data?.status ?? []))
        filterCategoryArray.append(FilterCategory.init(id: 3, name: "Amenities", subCategoryArray: filterSubCategory?.data?.amenities ?? []))
        filterCategoryArray.append(FilterCategory.init(id: 4, name: "Charging Power", subCategoryArray: filterSubCategory?.data?.power_types ?? []))
        filterCategoryArray.append(FilterCategory.init(id: 5, name: "Connectors", subCategoryArray: filterSubCategory?.data?.connector_types ?? []))
        filterCategoryArray.append(FilterCategory.init(id: 6, name: "Network", subCategoryArray: filterSubCategory?.data?.network ?? []))
        selectedFilterCategory = filterCategoryArray[0]
        filterCategoryArray[0].isSelected = true
        tableViewCategory.reloadData()
        tableViewSubCategory.reloadData()
    }
    
    //MARK:- Webservice Methods -
    private func callGetFilterAPI()
    {
        self.startLoading()
        SettingController.shared.getFilterOption(successCompletion: { (filterCategory) in
            self.stopLoading()
            filterSubCategory = filterCategory
            self.prepareFilterView()
        }) { (error, errorResponse) in
            self.stopLoading()
            self.showValidationMessage(withMessage: error.errorMessage)
        }
    }
    
    //MARK:- Action Methods -
    @IBAction func resetButton(_ sender: UIButton) {
        for filter in filterCategoryArray
        {
            for subCategory in filter.subCategoryName ?? []
            {
                subCategory.isSelected = false
            }
        }
        tableViewSubCategory.reloadData()
        tableViewCategory.reloadData()
        distance = [:]
        status = []
        amenities = []
        power_types = []
        connectors = []

        for viewController in self.navigationController?.viewControllers ?? []
        {
            if viewController.isKind(of: MapListViewController.self)
            {
                let vc = viewController as? MapListViewController
                vc?.isFromFilter = true
            }
            else if viewController.isKind(of: MapViewController.self)
            {
                let vc = viewController as? MapViewController
                vc?.isFromFilter = true
            }
        }

        isFilterApply = false
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func applyButton(_ sender: UIButton) {
        distance = [:]
        status = []
        amenities = []
        power_types = []
        connectors = []
        isFilterApply = true
        for distanceFilter in filterCategoryArray[0].subCategoryName ?? []
        {
            if distanceFilter.isSelected
            {
                distance[Key.start] = distanceFilter.from?.stringValue
                distance[Key.end] = distanceFilter.to?.stringValue
            }
        }
        for statusFilter in filterCategoryArray[1].subCategoryName ?? []
        {
            if statusFilter.isSelected
            {
                status.append(statusFilter.code?.stringValue ?? "")
            }
        }
        for amenitiesFilter in filterCategoryArray[2].subCategoryName ?? []
        {
            if amenitiesFilter.isSelected
            {
                amenities.append(amenitiesFilter.code?.stringValue ?? "")
            }
        }
        for chargingPowerFilter in filterCategoryArray[3].subCategoryName ?? []
        {
            if chargingPowerFilter.isSelected
            {
                power_types.append(chargingPowerFilter.code?.stringValue ?? "")
            }
        }
        for connectorFilter in filterCategoryArray[4].subCategoryName ?? []
            
        {
            if connectorFilter.isSelected
            {
                connectors.append(connectorFilter.code?.stringValue ?? "")
            }
        }
        for viewController in self.navigationController?.viewControllers ?? []
        {
            if viewController.isKind(of: MapListViewController.self)
            {
                let vc = viewController as? MapListViewController
                vc?.isFromFilter = true
            }
            else if viewController.isKind(of: MapViewController.self)
            {
                let vc = viewController as? MapViewController
                vc?.isFromFilter = true
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Custom Methods -
    func enableDisableApplyButton()
    {
        var shouldEnableFilterButton: Bool = false
        for filter in filterCategoryArray
        {
            for filterSubCategory in filter.subCategoryName ?? []
            {
                if filterSubCategory.isSelected
                {
                    shouldEnableFilterButton = true
                    self.buttonApply.isEnabled = true
                    self.buttonApply.alpha = 1.0
                }
            }
        }
        if !shouldEnableFilterButton
        {
            self.buttonApply.isEnabled = false
            self.buttonApply.alpha = 0.5
        }
    }
    
}
//MARK:- UITable View Delegate -
extension FilterViewController: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewCategory
        {
            return filterCategoryArray.count
        }
        else
        {
            return selectedFilterCategory?.subCategoryName?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tableViewCategory
        {
            let categoryCell = tableView.registerDeque(type: CategoryTableViewCell.self, indexPath: indexPath)
            categoryCell.filterCategory = filterCategoryArray[indexPath.row]
            return categoryCell
        }
        else
        {
            let subCategoryCell = tableView.registerDeque(type: SubCategoryTableViewCell.self, indexPath: indexPath)
            subCategoryCell.subCategory = selectedFilterCategory?.subCategoryName?[indexPath.row]
            return subCategoryCell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableViewCategory
        {
            let _ = filterCategoryArray.map({$0.isSelected = false})
            filterCategoryArray[indexPath.row].isSelected = true
            selectedFilterCategory = filterCategoryArray[indexPath.row]
            selectedFilterIndex = indexPath.row
            tableView.reloadData()
            tableViewSubCategory.reloadData()
        }
        else
        {
            if selectedFilterCategory?.id == 1 || selectedFilterCategory?.id == 4 {
                let selectedState = selectedFilterCategory?.subCategoryName?[indexPath.row].isSelected
                for filterCategory in selectedFilterCategory?.subCategoryName ?? []
                {
                    filterCategory.isSelected = false
                }
                filterCategoryArray[selectedFilterIndex].subCategoryName?[indexPath.row].isSelected = !(selectedState ?? false)
//                selectedFilterCategory?.subCategoryName?[indexPath.row].isSelected = !(selectedState ?? false)
            }
            else{
                filterCategoryArray[selectedFilterIndex].subCategoryName?[indexPath.row].isSelected = !(filterCategoryArray[selectedFilterIndex].subCategoryName?[indexPath.row].isSelected ?? false)
//                selectedFilterCategory?.subCategoryName?[indexPath.row].isSelected = !(selectedFilterCategory?.subCategoryName?[indexPath.row].isSelected ?? false)
            }
            
            tableView.reloadData()
            enableDisableApplyButton()
        }
    }
}
