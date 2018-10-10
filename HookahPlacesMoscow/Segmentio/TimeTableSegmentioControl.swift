//
//  TimeTableSegmentioControl.swift
//  HookahPlacesMoscow
//
//  Created by Евгений on 01/10/2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import Foundation
import Segmentio

class TimeTableSegmentioControl {
    
    let segmentioView: Segmentio!
    
    var index: Int!
    
    // Настройки индикатора выбранной кнопки
    var indicatorOptions: SegmentioIndicatorOptions {
        return SegmentioIndicatorOptions.init(
            type: .bottom,
            ratio: 1,
            height: 0,
            color: .clear
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
                titleFont: .systemFont(ofSize: 12),
                titleTextColor: .black
            ),
            // Выбранное состояние
            selectedState: SegmentioState(
                backgroundColor: .clear,
                titleFont: .systemFont(ofSize: 12),
                titleTextColor: .black
            ),
            // Нажатое состояние
            highlightedState: SegmentioState(
                backgroundColor: .clear,
                titleFont: .systemFont(ofSize: 12),
                titleTextColor: .black
            )
        )
    }
    
    // Все остальные настройки
    var options: SegmentioOptions {
        return SegmentioOptions(
            backgroundColor: .white,
            segmentPosition: .fixed(maxVisibleItems: 5),
            scrollEnabled: true,
            indicatorOptions: self.indicatorOptions,
            horizontalSeparatorOptions: self.horisontalSeparatorOptions,
            verticalSeparatorOptions: self.verticalSeparatorOptions,
            imageContentMode: .center,
            labelTextAlignment: .center,
            labelTextNumberOfLines: 3,
            segmentStates: self.states
        )
    }
    
    init(items: [SegmentioItem], view: UIView) {
        
        self.segmentioView = Segmentio(frame: CGRect(
            x: 0,
            y: 0,
            width: view.bounds.width,
            height: 80
        ))
        
        self.segmentioView.setup(
            content: items,
            style: .onlyLabel,
            options: self.options
        )
        
        view.addSubview(segmentioView)
    }
    
}
