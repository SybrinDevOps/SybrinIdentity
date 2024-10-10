//
//  ScanPhaseList.swift
//  Sybrin.iOS.Identity
//
//  Created by Nico Celliers on 2020/10/02.
//  Copyright © 2020 Sybrin Systems. All rights reserved.
//

class ScanPhaseList<T>: CustomStringConvertible {
    
    // MARK: Private Properties
    private var Head: ScanPhase<T>?
    private var Tail: ScanPhase<T>?
    private weak var ActivePhase: ScanPhase<T>?
    
    // MARK: Initializers
    init() { }
    
    convenience init(phases: [ScanPhase<T>]) {
        self.init()
        
        for phase in phases {
            append(phase: phase)
        }
    }
    
    // MARK: Getters
    var activePhase: ScanPhase<T>? { return ActivePhase }
    var isEmpty: Bool { return Head == nil }
    var first: ScanPhase<T>? { return Head }
    var last: ScanPhase<T>? { return Tail }
    var count: Int {
        guard var phase = Head else { return 0 }
      
        var count = 1
        while let nextPhase = phase.NextPhase {
            phase = nextPhase
            count += 1
        }
        
        return count
    }
    var description: String {
        var text = "["
        var phase = Head
        
        while phase != nil {
            text += "\(phase!.name)"
            phase = phase!.NextPhase
            if phase != nil { text += ", " }
        }
        
        return text + "]"
    }
    
    // MARK: Operators
    subscript(index: Int) -> ScanPhase<T>? {
        return find(at: index)
    }
    
    // MARK: Add Methods
    func insert(phase: ScanPhase<T>, at index: Int) {
        let count = self.count
        guard index >= 0, index <= count else { return }
        
        if index == 0 {
            phase.NextPhase = Head
            Head?.PreviousPhase = phase
            Head = phase
        } else if index == count {
            append(phase: phase)
        } else {
            let previousPhaseFromIndex = find(at: index-1)
            let currentPhaseAtIndex = find(at: index)
            
            previousPhaseFromIndex?.NextPhase = phase
            phase.PreviousPhase = previousPhaseFromIndex
            phase.NextPhase = currentPhaseAtIndex
            currentPhaseAtIndex?.PreviousPhase = phase
        }
    }
    
    func append(phase: ScanPhase<T>) {
        if let tailNode = Tail {
            phase.PreviousPhase = tailNode
            tailNode.NextPhase = phase
        } else {
            Head = phase
        }
        
        Tail = phase
    }
    
    // MARK: Index Methods
    func find(at index: Int) -> ScanPhase<T>? {
        if index >= 0 {
            var phase = Head
            var i = 0
            while phase != nil {
                if i == index { return phase }
                i += 1
                phase = phase!.NextPhase
            }
        }
        return nil
    }
    
    func index(of phase: ScanPhase<T>) -> Int {
        var listPhase = Head
        var index = 0
        while listPhase != nil {
            if listPhase === phase { return index }
            index += 1
            listPhase = listPhase!.NextPhase
        }
        return -1
    }
    
    // MARK: Remove Methods
    func removeAll() {
        Head = nil
        Tail = nil
    }
    
    func remove(phase: ScanPhase<T>) -> ScanPhase<T> {
        let prev = phase.PreviousPhase
        let next = phase.NextPhase

        if let prev = prev {
            prev.NextPhase = next
        } else {
            Head = next
        }
        next?.PreviousPhase = prev

        if next == nil {
            Tail = prev
        }

        phase.PreviousPhase = nil
        phase.NextPhase = nil
        
        return phase
    }
    
    func remove(at index: Int) -> ScanPhase<T>? {
        if let phase = find(at: index) {
            return remove(phase: phase)
        } else {
            return nil
        }
    }
    
    // MARK: Pop Methods
    func next() -> ScanPhase<T>? {
        if ActivePhase == nil {
            ActivePhase = Head
            return ActivePhase
        }
        
        if let phase = ActivePhase, let nextPhase = phase.NextPhase {
            ActivePhase = nextPhase
            return ActivePhase
        } else {
            return nil
        }
    }
    
    func nextLoop() -> ScanPhase<T>? {
        if let phase = ActivePhase, let nextPhase = phase.NextPhase {
            ActivePhase = nextPhase
        } else {
            ActivePhase = Head
        }
        
        return ActivePhase
    }
    
    func previous() -> ScanPhase<T>? {
        if ActivePhase == nil {
            ActivePhase = Tail
            return ActivePhase
        }
        
        if let phase = ActivePhase, let previousPhase = phase.PreviousPhase {
            ActivePhase = previousPhase
            return ActivePhase
        } else {
            return nil
        }
    }
    
    func previousLoop() -> ScanPhase<T>? {
        if let phase = ActivePhase, let previousPhase = phase.PreviousPhase {
            ActivePhase = previousPhase
        } else {
            ActivePhase = Tail
        }
        
        return ActivePhase
    }
    
    func goTo(phase: ScanPhase<T>) -> ScanPhase<T>? {
        if index(of: phase) >= 0 {
            ActivePhase = phase
            return ActivePhase
        } else {
            return nil
        }
    }
    
    func goTo(index: Int) -> ScanPhase<T>? {
        if let phase = find(at: index) {
            ActivePhase = phase
            return ActivePhase
        } else {
            return nil
        }
    }
    
    // MARK: Manipulation Methods
    func forEach(_ body: (ScanPhase<T>) -> Void) {
        var phase = Head
        while phase != nil {
            body(phase!)
            phase = phase!.NextPhase
        }
    }
    
}
