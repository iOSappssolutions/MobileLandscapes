//
//  ViewController.swift
//  MobileLandscapes
//
//  Created by Miroslav Djukic on 18/12/2019.
//  Copyright © 2019 Miroslav Djukic. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    
    private let landscapeCellID = "LandscapeCellID"
    private let titleString = "Landscape Photos"
    private let startStopButton = UIButton()
    private var isUpdatingLocation = false
    private var locationManager = LocationManager()
    private var backgroundTask: UIBackgroundTaskIdentifier?
    
    private var landscapePhotoURLS = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        landscapePhotoURLS = LandscapePhotos.retrieveLandscapePhotoURL()
        registerCells()
        setup()
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         
    }
    
    
    private func registerCells() {
        tableView.register(LandscapeCell.self, forCellReuseIdentifier: landscapeCellID)
    }
    
    private func setup() {
        let app = UIApplication.shared
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillEnterForeground(notification:)), name: UIApplication.willEnterForegroundNotification, object: app)
        locationManager.authorizeLocationService()
        setNavigationBar()
        tableView.separatorStyle = .none
        tableView.rowHeight = 300
        startStopButton.setTitleColor(isUpdatingLocation ? .red : .label, for: .normal)
        startStopButton.setTitle(C.start, for: .normal)
        startStopButton.addTarget(self, action: #selector(startStop), for: .touchUpInside)
    }
    
    @objc func applicationWillEnterForeground(notification: NSNotification) {
        self.tableView.reloadData()
    }
    
    private func setNavigationBar() {
        let rightBarItem = UIBarButtonItem(customView: startStopButton)
        self.navigationItem.rightBarButtonItem = rightBarItem
        self.navigationController?.navigationBar.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.title = titleString
    }
    
    @objc private func startStop() {
        isUpdatingLocation = !isUpdatingLocation
        setStartStopButton(isUpdatingLocation: isUpdatingLocation)
        if(isUpdatingLocation) {
            locationManager.locationUpdatedCallback = { [weak self] lat, lon in
                self?.searchPhotos(lat: lat, lon: lon)
            }
            let success = locationManager.startUpdatingLocation()
            if(!success) {
                handleNotAuthorizedState()
            }
        } else {
            locationManager.stopUpdatingLocation()
        }
    }
  
    private func setStartStopButton(isUpdatingLocation: Bool) {
        startStopButton.setTitle(isUpdatingLocation ? C.stop : C.start, for: .normal)
        startStopButton.setTitleColor(isUpdatingLocation ? .red : .label, for: .normal)
    }
    
    private func handleNotAuthorizedState() {
        isUpdatingLocation = false
        setStartStopButton(isUpdatingLocation: isUpdatingLocation)
        let alert = UIAlertController(title: "", message: "Mobile Landscapes heavily relies on location services, in order to provide you nice record of landscapes please allow Mobile Landscapes to access location services and tap start again <3", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {  (alert: UIAlertAction!) in
          if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    private func searchPhotos(lat: Double, lon: Double) {
        let photoSearchRequest = PhotoSearchRequest()
        let group  = DispatchGroup()
        group.enter()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.beginBackgroundUpdateTask()
            photoSearchRequest.searchPhotos(lat: String(lat), lon: String(lon)) { [weak self] photoUrl, error in
                if let photoUrl = photoUrl , let myself = self, !(myself.landscapePhotoURLS.contains(photoUrl)) {
                    myself.landscapePhotoURLS.insert(photoUrl, at: 0)
                    DispatchQueue.main.async {
                        NSLog("saving image to core data and reload if not in background")
                        LandscapePhotos.saveLandscapePhotoURL(photoUrl)
                        if UIApplication.shared.applicationState != UIApplication.State.background {
                            myself.tableView.reloadData()
                        }
                        group.leave()
                    }
                } else {
                    NSLog("error = %@", error.debugDescription)
                    group.leave()
                }
            }
            group.wait()
            self?.endBackgroundUpdateTask()
        }
    }
    
    private func beginBackgroundUpdateTask(){
        self.backgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: ({ [weak self] in
            guard let myself = self else { return }
            myself.endBackgroundUpdateTask()
        }))
    }

    private func endBackgroundUpdateTask() {
        if let backgroundTask = backgroundTask {
            UIApplication.shared.endBackgroundTask(backgroundTask)
        }
    }
  
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
      // #warning Incomplete implementation, return the number of sections
      return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // #warning Incomplete implementation, return the number of rows
        return landscapePhotoURLS.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: landscapeCellID, for: indexPath)
        
        if let landscapeCell = cell as? LandscapeCell {
            landscapeCell.setCell(imageUrl: landscapePhotoURLS[indexPath.row], row: indexPath.row)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let detailVC = LandmarkPhotoDetail(imageUrl: landscapePhotoURLS[indexPath.row])
        self.modifyPushAnimation()
        self.navigationController?.pushViewController(detailVC, animated: false)
    }
    
    private func modifyPushAnimation() {
        let transition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.navigationController?.view.layer.add(transition, forKey: nil)
    }
    
}

