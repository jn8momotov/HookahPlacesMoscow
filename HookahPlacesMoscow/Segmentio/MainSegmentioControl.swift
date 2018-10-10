//
//  MainSegmentioControl.swift
//  HookahPlacesMoscow
//
//  Created by Евгений on 23.09.2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import Foundation
import Segmentio

class MainSegmentioControl {
    
    let segmentioView: Segmentio!
    
    var index: Int!
    
    // Настройки индикатора выбранной кнопки
    var indicatorOptions: SegmentioIndicatorOptions {
        return SegmentioIndicatorOptions.init(
            type: .bottom,
            ratio: 1,
            height: 5,
            color: .black
        )
    }
    
    var horisontalSeparatorOptions: SegmentioHorizontalSeparatorOptions {
        return SegmentioHorizontalSeparatorOptions.init(
            type: .bottom,
            height: 1,
            color: .clear
        )
    }
    
    var verticalSeparatorOptions: SegmentioVerticalSeparatorOptions {
        return SegmentioVerticalSeparatorOptions.init(
            ratio: 0.5,
            color: .clear
        )
    }
    
    // Настройки для каждого состояния кнопки
    var states: SegmentioStates {
        return SegmentioStates(
            // Обычное состояние
            defaultState: SegmentioState(
                backgroundColor: .clear,
                titleFont: .boldSystemFont(ofSize: 16),
                titleTextColor: .gray
            ),
            // Выбранное состояние
            selectedState: SegmentioState(
                backgroundColor: .clear,
                titleFont: .boldSystemFont(ofSize: 16),
                titleTextColor: .black
            ),
            // Нажатое состояние
            highlightedState: SegmentioState(
                backgroundColor: .clear,
                titleFont: .boldSystemFont(ofSize: 16),
                titleTextColor: .black
            )
        )
    }
    
    // Все остальные настройки
    var options: SegmentioOptions {
        return SegmentioOptions(
            backgroundColor: .white,
            segmentPosition: .fixed(maxVisibleItems: 2),
            scrollEnabled: false,
            indicatorOptions: self.indicatorOptions,
            horizontalSeparatorOptions: self.horisontalSeparatorOptions,
            verticalSeparatorOptions: self.verticalSeparatorOptions,
            imageContentMode: .center,
            labelTextAlignment: .center,
            labelTextNumberOfLines: 1,
            segmentStates: self.states
        )
    }
    
    init(items: [SegmentioItem], view: UIView, handler: @escaping SegmentioSelectionCallback) {
        
        self.segmentioView = Segmentio(frame: CGRect(
            x: 0,
            y: 0,
            width: view.bounds.width,
            height: 50
        ))
        
        self.segmentioView.setup(
            content: items,
            style: .onlyLabel,
            options: self.options
        )
        
        self.segmentioView.valueDidChange = handler
        view.addSubview(segmentioView)
    }
    
}
