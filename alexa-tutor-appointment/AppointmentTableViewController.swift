//
//  AppointmentTableViewController.swift
//  alexa-tutor-appointment
//
//  Created by Mehmet Sahin on 4/20/19.
//  Copyright © 2019 Mehmet Sahin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AppointmentTableViewController: UITableViewController {
    
    let baseURL = "https://wnv9dbdah5.execute-api.us-east-1.amazonaws.com/dev/";
    var finalURL = ""
    var appointments = [TutorApp]()
    var showAppointments = [TutorApp]()
    
    var beginDateTextField = UITextField()
    var endDateTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        finalURL = "\(baseURL)notes"
        
        self.tableView.register(UINib(nibName: "CustomTutorCell", bundle: nil), forCellReuseIdentifier: "customTutorCell")
        configureTableView()
        
        getAppointmentData(url: finalURL)
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(tapGestureRecognizer:)))
//
//        view.addGestureRecognizer(tapGesture)
        
//        tableView.separatorStyle = .none
    }
    
//    @objc func viewTapped(tapGestureRecognizer: UITapGestureRecognizer) {
//        view.endEditing(true)
//    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return showAppointments.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customTutorCell", for: indexPath) as! CustomTutorCell
        
        
        cell.classCode.text = "Tutor for: \(showAppointments[indexPath.row].classCode)"
        cell.tutorName.text = showAppointments[indexPath.row].tutorName

        
        let days = showAppointments[indexPath.row].days.joined(separator: ", ")
        
        cell.availability.text = "Availability: \(showAppointments[indexPath.row].startTime)-\(showAppointments[indexPath.row].endTime) (\(days))"
        
        
        return cell
    }
    
    func getAppointmentData(url: String) {
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                let BTCJSON: JSON = JSON(response.result.value!)
//                print(BTCJSON)
                self.updateData(json: BTCJSON)
                self.sortData()
            }
            else {
                print("Error: \(String(describing: response.result.error))")
//                    self.bitcoinPriceLabel.text = "Connection Issue"
            }
        }
    }
    
    func sortData() {
        showAppointments = appointments.sorted { $0.startDate < $1.startDate }
        tableView.reloadData()
    }
    
    func updateData(json: JSON) {
        print(json.count)
        for appointment in json {
            var temp = TutorApp()
            if let classCode = appointment.1["classCode"].string {
                temp.classCode = classCode
            }
            if let tutorName = appointment.1["tutorName"].string {
                temp.tutorName = tutorName
            }
            if let startTime = appointment.1["startTime"].string {
                temp.startTime = startTime
            }
            if let endTime = appointment.1["endTime"].string {
                temp.endTime = endTime
            }
            if let days = appointment.1["days"].array {
                for day in days {
                    if let d = day.string {
                        temp.days.append(d)
                    }
                }
            }
            if let startDate = appointment.1["startDate"].string {
                temp.startDate = temp.formatter.date(from: startDate)!
            }
            if let endDate = appointment.1["endDate"].string {
                temp.endDate = temp.formatter.date(from: endDate)!
            }
            
//                print("Dates: ",temp.startDate, " " ,temp.endDate)

            appointments.append(temp)
            
        }
        tableView.reloadData()
    }
    
    func configureTableView() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 125.0
    }

    @IBAction func filterButtonPressed(_ sender: UIBarButtonItem) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        
        
        
        let alert = UIAlertController(title: "", message: "Filter by Date", preferredStyle: .alert)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let alertAction = UIAlertAction(title: "Filter", style: .default) {
            action in

            if let beginDate = self.beginDateTextField.text, let endDate = self.endDateTextField.text {
                let startDate = dateFormatter.date(from: beginDate)
                let eDate = dateFormatter.date(from: endDate)
                if let sdate = startDate, let date = eDate {
                    self.showAppointments = self.appointments.filter { $0.startDate >= sdate || $0.endDate <= date}
                    self.tableView.reloadData()

                }
            }
            
            print(self.beginDateTextField.text!)
        }
        
        
        
        alert.addTextField {
            alertTextField in
            alertTextField.placeholder = "Begining date"
            self.beginDateTextField = alertTextField
        }

        alert.addTextField {
            alertTextField in
            alertTextField.placeholder = "Ending date"
            self.endDateTextField = alertTextField
        }
//
        alert.addAction(alertAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        beginDateTextField.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
