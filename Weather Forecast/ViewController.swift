//
//  ViewController.swift
//  Weather Forecast
//
//  Created by Francisco de la Pena on 2/17/15.
//  Copyright (c) 2015 ___QuixoteLabs___. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var urlString = NSString()
    
    let firstURLString = "http://www.weather-forecast.com/locations/"
    
    let locationURLString = ""
    
    let lastURLString = "/forecasts/latest"
    
    @IBOutlet var inputCityTextField: UITextField!

    @IBOutlet var displayForecastLabel: UILabel!
    
    @IBAction func searchButtonPressed(sender: UIButton) {
        
        var tempLocal = NSString(string: inputCityTextField.text.lowercaseString)
        
        var tempURLString = firstURLString + (tempLocal as String) + lastURLString
        
        urlString = NSString(string: tempURLString)
        
        println(urlString)
        
        inputCityTextField.text = ""
        
        var url = NSURL(string: urlString as String)
        
        var task: NSURLSessionDataTask = NSURLSession.sharedSession().dataTaskWithURL(url!){
            (data, response, error) in
            
            if error == nil {
                
                var content = NSString(data: data, encoding: NSUTF8StringEncoding)
                
                println(content)
                
                var range = content?.rangeOfString("<span class=\"phrase\">")
                
                println("location: \(range?.location)")
                println("length: \(range?.length)")
                
                var index = Int((range?.location)!) + Int((range?.length)!)

                //var tempSubStr = content?.substringFromIndex(index)
                
                var subStr = NSString(string: (content?.substringFromIndex(index))!)
                
                range = subStr.rangeOfString("</span>")
                println("location: \(range?.location)")
                println("length: \(range?.length)")
                
                var weatherForecast = subStr.substringToIndex(Int((range?.location)!))
                
                weatherForecast = weatherForecast.stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.displayForecastLabel.text = weatherForecast
                }
                
            } else {
                
                println(error)
                
            }
            

        }
        
        task.resume()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
    }

}

