//
//  CucumberishInitializer.swift
//  WeatherCucumberUITests
//
//  Created by Kenneth Poon on 5/3/18.
//  Copyright © 2018 Kenneth Poon. All rights reserved.
//

import XCTest
import Foundation
import Cucumberish

class CucumberishInitializer: NSObject {
    @objc class func setupCucumberish(){        
        before({ _ in
            XCUIApplication().launch()
        })
        
        Given("I am on Weather Search Screen") { (args, userInfo) -> Void in            self.waitForElementToAppear(XCUIApplication().otherElements["WeatherSearchView"])            
        }
        
        When("^I search for \"([^\\\"]*)\"$") { (args, userInfo) -> Void in
            let searchBar = XCUIApplication().otherElements["SearchField"] 
            searchBar.tap()            
            let text = (args?[0])!
            searchBar.typeText(text)
        }
        
        Then("^I should see \"([^\\\"]*)\" in results$") { (args, userInfo) -> Void in
            let text = (args?[0])!
            self.waitForElementToAppear(XCUIApplication().cells.staticTexts[text])
        }

        When("^I tap \"([^\\\"]*)\" in results$") { (args, userInfo) -> Void in
            let text = (args?[0])!
            XCUIApplication().cells.staticTexts[text].tap()
        }
        
        Then("^I should be on Weather Detail Screen$") { (args, userInfo) -> Void in            self.waitForElementToAppear(XCUIApplication().otherElements["WeatherDetailView"])
        }

        Then("^I should see \"([^\\\"]*)\" in Detail Screen$") { (args, userInfo) -> Void in
            let text = (args?[0])!
            self.waitForElementToAppear(XCUIApplication().staticTexts[text])
        }        

        Then("^I should see Empty State on results$") { (args, userInfo) -> Void in
            self.waitForElementToAppear(XCUIApplication().otherElements["EmptyStateView"])
        }
        
        Then("^I should see Default State on results$") { (args, userInfo) -> Void in
            self.waitForElementToAppear(XCUIApplication().otherElements["DefaultStateView"])
        }       

        When("^I clear search bar$") { (args, userInfo) -> Void in
            let searchBar = XCUIApplication().otherElements["SearchField"] 
            searchBar.tap()
            searchBar.buttons.element(boundBy: 0).tap()
        }       
        
        
        let bundle = Bundle(for: CucumberishInitializer.self)
        Cucumberish.executeFeatures(inDirectory: "Features", from: bundle, includeTags: self.getTags(), excludeTags: nil)

    }
    
    class func waitForElementToAppear(_ element: XCUIElement){
        let result = element.waitForExistence(timeout: 5)
        guard result else {
            XCTFail("Element does not appear")
            return
        }
    }
    
    fileprivate class func getTags() -> [String]? {
        var itemsTags: [String]? = nil        
        for i in ProcessInfo.processInfo.arguments {
            if i.hasPrefix("-Tags:") {
                let newItems = i.replacingOccurrences(of: "-Tags:", with: "")
                itemsTags = newItems.components(separatedBy: ",")
            }
        }
        return itemsTags
    }
    
}
