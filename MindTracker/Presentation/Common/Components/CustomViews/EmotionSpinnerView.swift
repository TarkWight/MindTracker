//
//  EmotionSpinnerView.swift
//  MindTracker
//
//  Created by Tark Wight on 28.04.2025.
//

import UIKit

final class EmotionSpinnerView: UIView {

    // MARK: - Sublayers

    private let trackLayer = CAShapeLayer()
    private let maskLayer = CAShapeLayer()
    private let gradientLayer = CAGradientLayer()
    private let segmentsLayer = CALayer()

    // MARK: - Button

    private let addButton = UIButton(type: .system)
    private let addButtonLabel = UILabel()

    // MARK: - State

    public var onTap: (() -> Void)?
    private var fullPath: UIBezierPath = .init()
    private var data: SpinnerData?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
        setupButtonAndLabel()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public API

    public func update(with spinnerData: SpinnerData) {
        self.data = spinnerData
        setNeedsLayout()
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let data_ = data else { return }

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = bounds.width / 2 - data_.lineWidth / 2
        fullPath = UIBezierPath(arcCenter: center,
                                radius: radius,
                                startAngle: data_.startAngle,
                                endAngle: data_.endAngle,
                                clockwise: true)

        trackLayer.frame = bounds
        trackLayer.path = fullPath.cgPath
        trackLayer.lineWidth = data_.lineWidth

        maskLayer.frame = bounds
        maskLayer.path = fullPath.cgPath
        maskLayer.lineWidth = data_.lineWidth
        maskLayer.lineCap = .round
        maskLayer.fillColor = UIColor.clear.cgColor
        maskLayer.strokeColor = AppColors.appWhite.cgColor
        maskLayer.strokeStart = 0
        maskLayer.strokeEnd = data_.spinnerFraction

        gradientLayer.frame = bounds
        gradientLayer.type = .conic
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.colors = data_.gradientColors.map { $0.cgColor }
        gradientLayer.locations = data_.gradientLocations as [NSNumber]
        gradientLayer.mask = maskLayer

        segmentsLayer.frame = bounds

        if data_.isLoading {
            segmentsLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
            gradientLayer.isHidden = false
            startAnimation(duration: data_.animationDuration)
        } else {
            gradientLayer.isHidden = true
            gradientLayer.removeAllAnimations()
            drawSegments(data_)
        }
    }

    // MARK: - Animation

    private func startAnimation(duration: CFTimeInterval) {
        gradientLayer.removeAnimation(forKey: "spin")
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = -2 * CGFloat.pi
        animation.toValue = 0
        animation.duration = duration
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        gradientLayer.add(animation, forKey: "spin")
    }

    // MARK: - Drawing

    private func drawSegments(_ data: SpinnerData) {
        segmentsLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        for segment in data.segments {
            let segmentLayer = CAShapeLayer()
            segmentLayer.path = fullPath.cgPath
            segmentLayer.strokeColor = segment.color.cgColor
            segmentLayer.fillColor = UIColor.clear.cgColor
            segmentLayer.lineWidth = data.lineWidth
            segmentLayer.lineCap = .round
            segmentLayer.strokeStart = segment.strokeStart
            segmentLayer.strokeEnd = segment.strokeEnd
            segmentsLayer.addSublayer(segmentLayer)
        }
    }

    // MARK: - Setup

    private func setupLayers() {
        trackLayer.strokeColor = AppColors.appGrayDark.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = .round
        layer.addSublayer(trackLayer)

        layer.addSublayer(gradientLayer)
        layer.addSublayer(segmentsLayer)
    }

    private func setupButtonAndLabel() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setImage(UIImage(named: "plusIcon"), for: .normal)
        addButton.tintColor = AppColors.appBlack
        addButton.backgroundColor = AppColors.appWhite
        addButton.layer.cornerRadius = Constants.size / 2
        addButton.clipsToBounds = true
        addButton.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        addSubview(addButton)

        addButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        addButtonLabel.text = LocalizedKey.journalAddNoteButton
        addButtonLabel.font = Typography.body
        addButtonLabel.textColor = AppColors.appWhite
        addButtonLabel.textAlignment = .center
        addSubview(addButtonLabel)

        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            addButton.widthAnchor.constraint(equalToConstant: Constants.size),
            addButton.heightAnchor.constraint(equalToConstant: Constants.size),
            addButtonLabel.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: Constants.labelOffset),
            addButtonLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    // MARK: - Actions

    @objc private func handleTap() {
        onTap?()
    }

    // MARK: - Constants

    private enum Constants {
        static let size: CGFloat = 64
        static let labelOffset: CGFloat = 8
    }
}
