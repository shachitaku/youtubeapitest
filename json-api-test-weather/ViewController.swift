//
//  ViewController.swift
//  json-api-test-weather
//
//  Created by staff on 2018/11/13.
//  Copyright © 2018 takumi-kimura. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var weatherImage : UIImageView!
    @IBOutlet var maxTemp : UILabel!
    @IBOutlet var minTemp : UILabel!
    @IBOutlet var placeName : UILabel!
    @IBOutlet var dateToday : UILabel!
    @IBOutlet var weatherDescription : UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let url = URL(string: "http://weather.livedoor.com/forecast/webservice/json/v1?city=011000")!
        //URLSessionTask:URLで特定されるリソースを実際に取得し、アプリにデータを返却したり、
        //リモートサーバからファイルのダウンロードやアップロードを行います。
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                //データを抽出
                print("data: \(String(describing: data))")
                print("response: \(String(describing: response))")
                print("error: \(String(describing: error))")
                
                //データをJSONにする
                let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                let location = json["location"] as? NSDictionary
                let city = location!["city"] as? String
                self.placeName.text = city
                
                
                //天気予報情報
                let forecasts = json["forecasts"] as? NSArray
                let today = forecasts![0] as? NSDictionary
                //日にち
                let date = today!["date"] as! String
                self.dateToday.text = date
                //気温
                //なんか天気の気温がNullのときあるから、そのとき用の対処を書きました。
                let temp = today!["temperature"] as? NSDictionary
                var tempMax = temp!["max"] as? String
                if tempMax == nil {
                    tempMax = "unknown"
                }
                self.maxTemp.text = tempMax
                var tempMin = temp!["min"] as? String
                if tempMin == nil
                {
                    tempMin = "unknown"
                }
                self.minTemp.text = tempMin
                //天気予報の文章
                let description = json["description"] as? NSDictionary
                let text = description!["text"] as? String
                self.weatherDescription.text = text
                //天気マーク
                let image = today!["image"] as? NSDictionary
                let imageString = image!["url"] as! String
                let imageURL = URL(string: imageString)
                let data = try? Data(contentsOf: imageURL!)
                self.weatherImage.image = UIImage(data: data!)
     
            }
            catch{
                print(error)
            }

            }
        task.resume()
        }
        
        
    }


