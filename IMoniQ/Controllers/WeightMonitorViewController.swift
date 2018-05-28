//
//  WeightMonitorViewController.swift
//  IMoniQ
//
//  Created by Jane on 15/5/18.
//  Copyright © 2018 Hyojin Lee. All rights reserved.
//

import UIKit
import Charts
import HealthKit


class WeightMonitorViewController: UIViewController, UITextFieldDelegate {
    

    @IBOutlet weak var weightInputBox: UITextField!
    @IBOutlet weak var weightChart: LineChartView!
    
    //var weights : [Double] = [] //weight datas are stored here
    var weight: userWeight = userWeight()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weightInputBox.delegate = self
        weightChart.xAxis.labelPosition = XAxis.LabelPosition.topInside
        weight.getUserWeightHistory()
        updateGraph()
    }
    
    // MARK: - Releasing the Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true);
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }

    // allows digit input only.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharaters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharaters.isSuperset(of: characterSet)
    }


    /// This is the button trigger
    @IBAction func enterButtonPressed(_ sender: UIButton!) {

        guard self.weightInputBox.text != nil && !(self.weightInputBox.text?.isEmpty)! else {
            self.shake(self.weightInputBox)
            self.perform(#selector(
                shake(_:)), with: nil, afterDelay: 0.2)
            self.prompt()
            return
        }

        let input  = Double(weightInputBox.text!) //gets input from the weightInputBox
        
        
        //weights.append(input!) // add weights input
        weight.updateUserWeightHistory(currentWeight: Float(input!))
        updateGraph()
        weightInputBox.text = "" // after submitting reset the box
    }

    func updateGraph(){
        //the array that used in line graph
        var lineChartEntry  = [ChartDataEntry]()

        //here is the for loop
        for i in userWeightHistory.count - 10..<userWeightHistory.count {
            if i < 0 {
                continue
            }
            let value = ChartDataEntry(x: Double(i), y: Double(userWeightHistory[i].weight)) //set the X and Y status in a data chart entry
            lineChartEntry.append(value)
        }

        //convert lineChartEntry to a LineChartDataSet
        let line1 = LineChartDataSet(values: lineChartEntry, label: "Weight")
        line1.colors = [NSUIColor.blue]
        //the object that will be added to the chart
        let data = LineChartData()
        data.addDataSet(line1) //Adds the line to the dataSet
        weightChart.data = data
        weightChart.chartDescription?.text = "Weight Monitor"
        weightChart.legend.enabled = false
        weightChart.xAxis.valueFormatter = IndexAxisValueFormatter(values:dates)
        weightChart.xAxis.granularity = 1
    }

     //Shake a control to draw the user's attention to the focus of
    @objc func shake(_ object: UIView) {

        UIView.animate(withDuration: 0.2, delay: 0, animations: {

            let rightTransform  = CGAffineTransform(translationX: 50, y: 0)
            object.transform = rightTransform

        }) { (_) in

            UIView.animate(withDuration: 0.2, animations: {
                object.transform = CGAffineTransform.identity
            })
        }
    }

     // Pop-up prompt window
    func prompt() {
        let sheet = UIAlertController.init(title: "Prompt Message", message: "Please enter your weight(number)", preferredStyle: UIAlertControllerStyle.actionSheet)
        sheet.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action: UIAlertAction) in

        }))
        self.present(sheet, animated: true, completion: nil)
    }


    // Pop-up prompt window with animation

    func promptWithAnimation() {

        let alert = UIView.init(frame: CGRect(x: 15, y: 180, width: self.view.frame.width - 30, height: self.view.frame.height / 4 * 3))
        let keyWindow = UIApplication.shared.keyWindow
        keyWindow?.addSubview(alert)
        alert.transform = CGAffineTransform(scaleX: 1.21, y: 1.21)
        alert.alpha = 0
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            alert.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            alert.alpha = 1.0
        }, completion: nil)
    }
    
    var dates: Array<String> = Array()
    func setDate() {
        var i = userWeightHistory.count - 10
        
        while i < userWeightHistory.count {
            if i > -1 {
                let calendar = Calendar.current
                let day = calendar.component(.day, from: userWeightHistory[i].date)
                let hour = calendar.component(.hour, from: userWeightHistory[i].date)
                let minute = calendar.component(.minute, from: userWeightHistory[i].date)
                let month = calendar.component(.month, from: userWeightHistory[i].date)
                
                let str = "\(day)/\(month)"
                dates.append(str)
            }
            i += 1
        }
    }
}

