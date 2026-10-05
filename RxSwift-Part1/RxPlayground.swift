//
//  RxPlayground.swift
//  RxSwift-Part1
//
//  Created by Felix Anderson on 9/30/26.
//

import UIKit
import RxSwift
import Playgrounds

#Playground("Observables") {
    let justObservable = Observable.just(5)
    let doubleObservable: Observable = Observable.just(5.0)
    let stringObservbale: Observable = Observable.just("String")
    
    let ofObservable = Observable.of(1)
    let multiObservable = Observable.of(1, 2, 3, 4, 5)
    let arrayObservable = Observable.of([1, 2], [3, 4])
    
    let fromObservable = Observable.from(optional: [1, 2, 3, 4])
}

#Playground("Subsribers") {
    let multiObservable = Observable.of(1, 2, 3, 4, 5)
    
    multiObservable.subscribe { (event) in
//        print(event.element ?? event)
    }
    
    let rangeObserver = Observable.range(start: 1, count: 4)
    rangeObserver.subscribe(onNext: {
        print($0)
    }, onError: nil, onCompleted: {
        print("range is completed")
    }, onDisposed: nil)
    
    let emptyObserver = Observable<Void>.empty()
    emptyObserver.subscribe(onNext: {
        print($0)
    }, onError: nil, onCompleted: {
        print("empty is completed")
    }, onDisposed: nil)
    
    
    let neverObserver = Observable<Void>.never()
    neverObserver.subscribe(onNext: {
        print($0)
    }, onError: nil, onCompleted: {
        print("completed")
    }, onDisposed: nil)
    
    var toggle = false
    
    let factory = Observable.deferred { () -> Observable<Int> in
        toggle = !toggle
        return toggle ? Observable.of(1, 2, 3) : Observable.of(3, 4, 5)
    }
    
    for _ in 0...3 {
        toggle = !toggle
        if toggle {
            Observable.of(1, 2, 3)
                .subscribe { (event) in
                    print(event.element ?? event)
                }
        } else {
            Observable.of(3, 4, 5)
                .subscribe { (event) in
                    print(event.element ?? event)
                }
        }
    }
}

#Playground("Dispose") {
    let rangeObserver = Observable.range(start: 1, count: 4)
    let bag = DisposeBag()
    let subscription = rangeObserver.subscribe(
        onNext: {
            print($0)
        },
        onError: nil,
        onCompleted: {
            print("Range Completed")
        },
        onDisposed: {
            print("Range Disposed")
        }
    )
    
//    subscription.dispose()
    subscription.disposed(by: bag)
}
