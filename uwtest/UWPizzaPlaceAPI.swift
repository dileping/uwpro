//
//  UWPizzaPlaceAPI.swift
//  uwtest
//
//  Created by Daniel Leping on 9/25/15.
//  Copyright © 2015 Crossroad Labs, LTD. All rights reserved.
//

import Foundation
import CoreLocation
import QuadratTouch

extension CLLocation {
    func parameters() -> Parameters {
        let ll      = "\(self.coordinate.latitude),\(self.coordinate.longitude)"
        let llAcc   = "\(self.horizontalAccuracy)"
        let alt     = "\(self.altitude)"
        let altAcc  = "\(self.verticalAccuracy)"
        let parameters = [
            Parameter.ll:ll,
            Parameter.llAcc:llAcc,
            Parameter.alt:alt,
            Parameter.altAcc:altAcc
        ]
        return parameters
    }
}

typealias JSONParameters = [String: AnyObject]

class UWPizzaPlaceAPI : NSObject {
    var session:Session
    
    override init() {
        let client = Client(clientID:       "53MTCAWC3GDNSXIYXIGQHW5VG3YSIIHT4Z0NUQCYWB0IUJPV",
            clientSecret:   "53EUPVF40ZAKR3T0ICDUMIFPW1SVCDFSH5HQUPFZKHEZLOIQ",
            redirectURL:    "uwtest://foursquare")
        let configuration = Configuration(client:client)
        Session.setupSharedSessionWithConfiguration(configuration)
        self.session = Session.sharedSession()
        super.init()
    }
    
    typealias PizzaPlacesCallback = (lat: Double, lon: Double, pizzaPlaces:NSArray) -> Void
    @objc func pizzaPlaces(lat: Double, lon: Double, callback: PizzaPlacesCallback) {
        let location = CLLocation(latitude: lat, longitude: lon)
        var parameters = [Parameter.query:"Pizza"]
        parameters += location.parameters()
        let searchTask = session.venues.search(parameters) {
            (result) -> Void in
            if let response = result.response {
                let venues = response["venues"] as! [JSONParameters]?
                if (venues != nil) {
                    callback(lat: lat, lon: lon, pizzaPlaces: venues!)
                } else {
                    NSLog("No venues")
                }
            }
        }
        searchTask.start()
    }
};
