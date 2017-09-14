//
//  ThemeViewController.swift
//  TaxApp
//
//  Created by Sergey Leskov on 8/13/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit
import DatePickerDialog

class ThemeViewController: BaseImageViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var fonUI: UIImageView!
    
    //==================================================
    // MARK: - General
    //==================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        configTheme()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = NSLocalizedString("Настройки темы", comment: "SettingViewController - navigationItem.title")
        configTheme()
        tableView.reloadData()
    }
    
    
    //==================================================
    // MARK: - func
    //==================================================
    func configTheme()  {
        fonUI.image = ThemeManager.shared.findImage(name: "themeFon", themeApp: ThemeManager.shared.currentTheme())
    }
    
    
    func changeTheme()  {
        navigationController?.navigationBar.barTintColor = ThemeManager.shared.mainColor()
        tableView.reloadData()
        configTheme()
    }
}



//==================================================
// MARK: - UITableViewDataSource, UITableViewDelegate
//==================================================

extension ThemeViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: UITableViewDataSource
    
    internal func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        switch row {
            
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ThemeTableViewCell
            cell.leftImageUI.image = ThemeManager.shared.findImage(name: "themeCup", themeApp: ThemeManager.shared.currentTheme())
            cell.nameUI.text = "Доброе утро"
            
            DateManager.minutesToHoursAndMinutesString(minutes: ThemeManager.shared.theme1Minutes) { (hours, minutes) in
                cell.hoursUI.text = hours
                cell.minutesUI.text = minutes
            }
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ThemeTableViewCell
            cell.leftImageUI.image = ThemeManager.shared.findImage(name: "themeSun", themeApp: ThemeManager.shared.currentTheme())
            cell.nameUI.text = "Рабочий день"
            DateManager.minutesToHoursAndMinutesString(minutes: ThemeManager.shared.theme2Minutes) { (hours, minutes) in
                cell.hoursUI.text = hours
                cell.minutesUI.text = minutes
            }
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ThemeTableViewCell
            cell.leftImageUI.image = ThemeManager.shared.findImage(name: "themeMoon", themeApp: ThemeManager.shared.currentTheme())
            cell.nameUI.text = "Ночь"
            DateManager.minutesToHoursAndMinutesString(minutes: ThemeManager.shared.theme3Minutes) { (hours, minutes) in
                cell.hoursUI.text = hours
                cell.minutesUI.text = minutes
            }
            
            return cell
            
            
        default:
            let cell = UITableViewCell()
            return cell
        }
        
    }
    
    //MARK: UITableViewDelegate
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = indexPath.row
        let startDay = Calendar.current.startOfDay(for: Date())
        
        switch row {
            
            
        case 0:
            let date = Calendar.current.date(byAdding: .minute, value: ThemeManager.shared.theme1Minutes, to: startDay )
            DatePickerDialog().show("Установить время",
                                    doneButtonTitle: "Применить",
                                    cancelButtonTitle: "Отмена",
                                    defaultDate:date!,
                                    minimumDate: nil,
                                    maximumDate: nil,
                                    datePickerMode: .time) { (tempDate) in
                                        if let dt = tempDate {
                                            let minutes =  Calendar.current.dateComponents([.minute], from: startDay, to: dt).minute
                                            ThemeManager.shared.theme1Minutes = minutes!
                                            self.changeTheme()
                                        }
            }
            
        case 1:
            let date = Calendar.current.date(byAdding: .minute, value: ThemeManager.shared.theme2Minutes, to: startDay )
            DatePickerDialog().show("Установить время",
                                    doneButtonTitle: "Применить",
                                    cancelButtonTitle: "Отмена",
                                    defaultDate:date!,
                                    minimumDate: nil,
                                    maximumDate: nil,
                                    datePickerMode: .time) { (tempDate) in
                                        if let dt = tempDate {
                                            let minutes =  Calendar.current.dateComponents([.minute], from: startDay, to: dt).minute
                                            ThemeManager.shared.theme2Minutes = minutes!
                                            self.changeTheme()
                                        }
            }
            
        case 2:
            let date = Calendar.current.date(byAdding: .minute, value: ThemeManager.shared.theme3Minutes, to: startDay )
            DatePickerDialog().show("Установить время",
                                    doneButtonTitle: "Применить",
                                    cancelButtonTitle: "Отмена",
                                    defaultDate:date!,
                                    minimumDate: nil,
                                    maximumDate: nil,
                                    datePickerMode: .time) { (tempDate) in
                                        if let dt = tempDate {
                                            let minutes =  Calendar.current.dateComponents([.minute], from: startDay, to: dt).minute
                                            ThemeManager.shared.theme3Minutes = minutes!
                                            self.changeTheme()
                                        }
            }
            
        default:
            return
        }
        
        
    }
}
