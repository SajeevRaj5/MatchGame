//
//  CardListViewControllerTests.swift
//  MatchGameTaskTests
//
//  Created by Sajeev Raj on 6/6/21.
//

import XCTest
@testable import MatchGameTask

class CardListViewControllerTests: XCTestCase {
    var viewController: CardListViewController!
    var presenter: MockCardListingPresenter!

    var data = [CardViewModel]()
    
    override func setUp() {
        viewController = CardRouter.createModule()
        presenter = MockCardListingPresenter()
        viewController?.presenter = presenter
        _ = viewController?.view
    }
    
    override func tearDown() {
        viewController = nil
        presenter = nil
    }
    
    func testCardListingViewControllerExists() {
        XCTAssertNotNil(viewController, "a CardListViewController instance should be creatable with Module ")
    }
    
    func testCollectionViewExists() {
        XCTAssertNotNil(viewController.cardsCollectionView, "collection view should be present")
    }
    
    func testCollectionViewCellHasReuseIdentifier() {
        viewController!.dataSource = CardService.getCards(pairCount: 8).map{ CardViewModel(frontImageName: $0.frontImageName) }
        
        let cell = viewController.collectionView(viewController.cardsCollectionView, cellForItemAt: IndexPath(row: 0, section: 0)) as? CardViewCell
        let actualReuseIdentifer = cell?.reuseIdentifier
        let expectedReuseIdentifier = CardViewCell.identifier
        XCTAssertEqual(actualReuseIdentifer, expectedReuseIdentifier)
    }
    
    func testEmptyView() {
        viewController!.dataSource = []
        XCTAssert(viewController!.cardsCollectionView.numberOfItems(inSection: 0) == 0, "CollectionView should have no rows")
    }
    
    func testDataDisplay() {
        viewController!.dataSource = CardService.getCards(pairCount: 8).map{ CardViewModel(frontImageName: $0.frontImageName) }
        XCTAssert(viewController!.cardsCollectionView.numberOfItems(inSection: 0) == viewController!.dataSource!.count, "Collection View should have no rows")
    }
    
    func testShouldConfigureGame() {
        viewController.viewDidLoad()
        XCTAssert(presenter.didCallConfigureGame, "Should call configure game")
    }
    
    func testStartNewGame() {
        
    }
}

extension CardListViewControllerTests {
    class MockCardListingPresenter : ViewToPresenterCardProtocol {
        var view: PresenterToViewCardProtocol?
        
        var didCallConfigureGame = false
                
        func setupNewGame() {
        }
        
        func handleSelectionOfCard(at index: Int) {
            
        }
        
        func restartGame() {
            
        }
        
        func startGameWith(time: Int) {
            
        }
        
        func configureGame() {
            didCallConfigureGame = true
        }
    }
}
