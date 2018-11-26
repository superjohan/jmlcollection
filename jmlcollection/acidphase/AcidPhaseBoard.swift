//
//  Board.swift
//  demo
//
//  Created by Johan Halin on 19/11/2018.
//  Copyright © 2018 Dekadence. All rights reserved.
//

struct AcidPhaseBoard {
    let contents: [[Int]]
    
    private init(contents: [[Int]]) {
        var count = 0
        
        for row in contents {
            for value in row {
                if value > 0 {
                    count += 1
                }
            }
        }
        
        if count != 16 {
            fatalError("invalid amount of values: \(count). should be 16")
        }
        
        self.contents = contents
    }
    
    static func initialBoard() -> AcidPhaseBoard {
        return AcidPhaseBoard(contents:
            [
                [0, 0, 0, 0, 0, 0],
                [0, 1, 2, 3, 4, 0],
                [0, 5, 6, 7, 8, 0],
                [0, 9, 10,11,12,0],
                [0, 13,14,15,16,0],
                [0, 0, 0, 0, 0, 0]
                ]
        )
    }
    
    static func boardByMovingOnePosition(fromBoard board: AcidPhaseBoard) -> AcidPhaseBoard {
        var candidates = [(Int, Int)]()
        
        var contents = board.contents
        let maxRow = contents.count - 1
        let maxColumn = contents[0].count - 1
        
        for (row, rowContent) in contents.enumerated() {
            for (column, value) in rowContent.enumerated() {
                if value == 0 {
                    continue
                }
                
                // check above
                if row != 0 {
                    if contents[row - 1][column] == 0 {
                        candidates.append((row, column))
                        continue
                    }
                }
                
                // check below
                if row != maxRow {
                    if contents[row + 1][column] == 0 {
                        candidates.append((row, column))
                        continue
                    }
                }
                
                // check left
                if column != 0 {
                    if contents[row][column - 1] == 0 {
                        candidates.append((row, column))
                        continue
                    }
                }
                
                // check right
                if column != maxColumn {
                    if contents[row][column + 1] == 0 {
                        candidates.append((row, column))
                        continue
                    }
                }
            }
        }
        
        let candidateToMove = candidates[Int.random(in: 0..<candidates.count)]
        
        let row = candidateToMove.0
        let column = candidateToMove.1
        
        var possiblePositions = [(Int, Int)]()
        
        // i suppose this bit could be done during the first pass. whatever
        
        // check above
        if row != 0 && contents[row - 1][column] == 0 {
            possiblePositions.append((row - 1, column))
        }
        
        // check below
        if row != maxRow && contents[row + 1][column] == 0 {
            possiblePositions.append((row + 1, column))
        }
        
        // check left
        if column != 0 && contents[row][column - 1] == 0 {
            possiblePositions.append((row, column - 1))
        }
        
        // check right
        if column != maxRow && contents[row][column + 1] == 0 {
            possiblePositions.append((row, column + 1))
        }
        
        let newPosition = possiblePositions[Int.random(in: 0..<possiblePositions.count)]
        contents[newPosition.0][newPosition.1] = contents[row][column]
        contents[row][column] = 0
        
        return AcidPhaseBoard(contents: contents)
    }
}
