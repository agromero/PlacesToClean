//
//  ManagerPlaces.swift
//  PlacesToCleanTests
//
//  Created by AGUS ROMERO on 18/12/22.
//

import XCTest
@testable import PlacesToClean

final class ManagerPlacesTests: XCTestCase {

    var managerPlaces: ManagerPlaces!
    
    override func setUpWithError() throws {
        managerPlaces = ManagerPlaces.shared
    }

    override func tearDownWithError() throws {
        managerPlaces = nil
    }

    func testloadData() {
        // Comprovem que s'ha carregat la Base de Dades
        XCTAssertFalse(managerPlaces.places.count == 0)
    }
     
    func testloadData_title() {
        // Comprovem que el títol del primer element es "Hospital de Bellvitge"
        XCTAssertTrue((managerPlaces.places.first?.title ?? "").contains("Hospital de Bellvitge"))
    }
    
    func testLoadData_type_canno_be_more_than_9() {
        // Comprovem que no té un tipus amb valor 9
        XCTAssertFalse(managerPlaces.places.contains(where: {$0.type == 9 }))
    }
}
