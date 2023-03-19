//
//  StepSliderView.swift
//  WeGoTripTestTask
//
//  Created by lr.habibullin on 17.03.2023.
//

import Foundation
import UIKit

final class StepSliderView: UIControl {
    
    // MARK: - Properties
    
    var thumbSize: CGFloat = 26 {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }
    
    var tickSize: CGFloat = 4 {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }
    
    var trackHeight: CGFloat = 1 {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsLayout()
        }
    }
    
    var thumbBackgroundColor: UIColor = .white {
        didSet {
            thumbView.backgroundColor = thumbBackgroundColor
        }
    }
    
    var thumbBorderColor: UIColor = .lightGray {
        didSet {
            thumbView.layer.borderColor = thumbBorderColor.cgColor
        }
    }
    
    var thumbBorderWidth: CGFloat = .zero {
        didSet {
            thumbView.layer.borderWidth = thumbBorderWidth
        }
    }
    
    var trackColor: UIColor = .lightGray {
        didSet {
            trackView.backgroundColor = trackColor
        }
    }
    
    var tickColor: UIColor = .lightGray {
        didSet {
            ticksViews.forEach { $0.backgroundColor = tickColor }
        }
    }
    
    var minimumValue: Int = .zero {
        didSet {
            validateValue()
            setNeedsLayout()
        }
    }
    
    var maximumValue: Int = 10 {
        didSet {
            validateValue()
            setNeedsLayout()
        }
    }
    
    var stepValue: Int = 1 {
        didSet {
            setNeedsLayout()
        }
    }
    
    var value: Int = .zero {
        didSet {
            if value == oldValue {
                return
            }
            validateValue()
            setNeedsLayout()
            sendActions(for: .valueChanged)
        }
    }
    
    private let trackView = UIView()
    private let thumbView = UIView()
    private var ticksViews = [UIView]()
    private lazy var gestureRecognizer = GestureRecognizer(target: self,
                                                           action: #selector(gestureRecognized(_:)))
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(trackView)
        addSubview(thumbView)
        
        addGestureRecognizer(gestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Overrides
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric,
                      height: max(thumbSize, trackHeight, tickSize))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        trackView.frame.size = CGSize(width: bounds.width - thumbSize,
                                      height: trackHeight)
        trackView.center = CGPoint(x: bounds.width / 2,
                                   y: bounds.height / 2)
        trackView.backgroundColor = trackColor
        
        let trackCircleCount = (maximumValue - minimumValue) / stepValue + 1
        
        while trackCircleCount != ticksViews.count {
            if trackCircleCount > ticksViews.count {
                let view = UIView()
                addSubview(view)
                ticksViews.append(view)
            } else if trackCircleCount < ticksViews.count {
                ticksViews.popLast()?.removeFromSuperview()
            }
        }
        
        let baseStart = thumbSize / 2
        let baseEnd = bounds.width - thumbSize / 2
        let increment = (baseEnd - baseStart) / CGFloat(ticksViews.count - 1)
        ticksViews.enumerated().forEach { index, view in
            view.frame.size = .init(width: tickSize, height: tickSize)
            view.center = .init(x: baseStart + increment * CGFloat(index),
                                y: bounds.height / 2)
            view.layer.cornerRadius = tickSize / 2
            view.backgroundColor = tickColor
        }
        
        thumbView.frame.size = CGSize(width: thumbSize,
                                      height: thumbSize)
        thumbView.center = CGPoint(x: baseStart + increment * CGFloat(value - minimumValue) / CGFloat(stepValue),
                                   y: bounds.height / 2)
        thumbView.layer.cornerRadius = thumbSize / 2
        thumbView.layer.borderWidth = thumbBorderWidth
        thumbView.backgroundColor = thumbBackgroundColor
        thumbView.dropShadow(shadowOffset: CGSize(width: .zero, height: 1))
        bringSubviewToFront(thumbView)
    }
    
    
    // MARK: - Private methods
    
    private func validateValue() {
        if value > maximumValue {
            value = maximumValue
        } else if value < minimumValue {
            value = minimumValue
        }
    }
    
    @objc private func gestureRecognized(_ sender: GestureRecognizer) {
        let x = sender.location(in: self).x
        let baseStart = thumbSize / 2
        let baseEnd = bounds.width - thumbSize / 2
        let increment = (baseEnd - baseStart) / CGFloat(ticksViews.count - 1)
        value = minimumValue + Int(round((x - baseStart) / increment)) * stepValue
    }
    
    
    // MARK: - GestureRecognizer
    
    fileprivate final class GestureRecognizer: UIGestureRecognizer {
        override func touchesBegan(_: Set<UITouch>, with _: UIEvent) {
            state = .began
        }
        
        override func touchesMoved(_: Set<UITouch>, with _: UIEvent) {
            state = .changed
        }
        
        override func touchesEnded(_: Set<UITouch>, with _: UIEvent) {
            state = .ended
        }
    }
    
}
