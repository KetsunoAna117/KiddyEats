//
//  IncompleteJsonParserTests.swift
//  KiddyEatsAppTests
//
//  Created by Arya Adyatma on 21/08/24.
//

import XCTest
@testable import KiddyEatsApp

class BabyMealJsonParserTests: XCTestCase {
    
    func testParseCompleteJson() {
        let jsonStr = """
        [
            {
                "name": "Banana Puree",
                "emoji": "🍌",
                "ingredients": ["1 ripe banana"],
                "allergens": [],
                "cookingSteps": "1. Peel and mash the banana.",
                "servingSize": 1,
                "estimatedCookingTimeMinutes": 5
            },
            {
                "name": "Apple Sauce",
                "emoji": "🍎",
                "ingredients": ["2 apples", "1/4 cup water"],
                "allergens": [],
                "cookingSteps": "1. Peel and chop apples. 2. Cook with water until soft. 3. Blend until smooth.",
                "servingSize": 2,
                "estimatedCookingTimeMinutes": 15
            }
        ]
        """
        
        let meals = BabyMeal.fromIncompleteJsonList(jsonStr: jsonStr)
        
        XCTAssertEqual(meals.count, 2)
        XCTAssertEqual(meals[0].name, "Banana Puree")
        XCTAssertEqual(meals[1].name, "Apple Sauce")
    }
    
    func testParseIncompleteJson() {
        let jsonStr = """
        [
            {
                "name": "Carrot Puree",
                "emoji": "🥕",
                "ingredients": ["2 carrots", "1/4 cup water"],
                "allergens": [],
                "cookingSteps": "1. Peel and chop carrots. 2. Steam until soft. 3. Blend with cooking water.",
                "servingSize": 2,
                "estimatedCookingTimeMinutes": 20
            },
            {
                "name": "Sweet Potato Mash",
                "emoji": "🍠",
                "ingredients": ["1 sweet potato
        """
        
        let meals = BabyMeal.fromIncompleteJsonList(jsonStr: jsonStr)
        
        XCTAssertEqual(meals.count, 1)
        XCTAssertEqual(meals[0].name, "Carrot Puree")
    }
    
    func testParseEmptyOrInvalidJson() {
        let emptyJson = "[]"
        let emptyMeals = BabyMeal.fromIncompleteJsonList(jsonStr: emptyJson)
        XCTAssertTrue(emptyMeals.isEmpty)
        
        let invalidJson = "This is not JSON"
        let invalidMeals = BabyMeal.fromIncompleteJsonList(jsonStr: invalidJson)
        XCTAssertTrue(invalidMeals.isEmpty)
    }
}
