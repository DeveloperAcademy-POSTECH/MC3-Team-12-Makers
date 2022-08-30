//
//  PushNotificationManager.swift
//  Gajeongtongsin
//
//  Created by DaeSeong on 2022/08/30.
//

import Foundation

class PushNotificationManager {
    // MARK: - Funcs
    
    static func sendPushNotification(to token: String, title: String, body: String) {
        let server_key = "AAAA5kketBY:APA91bFTRQS-iaBsQ8Kjubs56kFeGtTRa72LIQy1RgvCDaHcYyZeSwlhd-MqJTcDac5G5NagU0i9xqTfa4_KvOB8eIb0vro_byGAqoe2Jkf_nnlwYsb_hH-7gf1qVCHUVORCiY16KvkC"
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token,
                                           "notification" : ["title" : title, "body" : body],
                                           "data" : ["user" : "test_id"]
        ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(server_key)", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
