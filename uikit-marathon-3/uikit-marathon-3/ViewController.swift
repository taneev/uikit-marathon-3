//
//  ViewController.swift
//  uikit-marathon-3
//
//  Created by Timur Taneev on 07.03.2023.
//

import UIKit

class ViewController: UIViewController {
    let squareView = UIView()
    let slider = UISlider()
    
    // Отступы слева и справа
    let leftMargin: CGFloat = 20 // привязать к layoutMargins
    let rightMargin: CGFloat = 20
    
    // положение квадратной View относительно leftMargin, размер квадрата
    let squareX: CGFloat = 0
    let squareY: CGFloat = 150
    let squareSize: CGFloat = 70
    
    // положение слайдера относительно leftMargin
    let sliderX: CGFloat = 0
    let sliderY: CGFloat = 250
    let sliderHeight: CGFloat = 20
    
    // Максимальное масштабирование при трансформации
    let maxScalingFactor = 1.5
    
    // Максимальный угол поворота при трансформации
    let maxRotateAngle = .pi/2.0

    let duration = TimeInterval(0.3)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Создаем квадратную вью и добавляем ее на экран
        squareView.frame = CGRect(x: squareX+leftMargin, y: squareY, width: squareSize, height: squareSize)
        squareView.backgroundColor = .systemRed
        view.addSubview(squareView)
        
        // Создаем слайдер и добавляем его на экран
        slider.frame = CGRect(x: sliderX+leftMargin, y: sliderY, width: view.bounds.maxX - (rightMargin + leftMargin), height: sliderHeight)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderReleased), for: [.touchUpInside, .touchUpOutside])
        self.view.addSubview(slider)
    }

    private func getScaling(newValue sliderValue: CGFloat) -> CGAffineTransform {
        // Трансформация масштабирования: от 1 до 1.5
        let scaleX = 1 + (maxScalingFactor - 1) * sliderValue
        let scaleY = 1 + (maxScalingFactor - 1) * sliderValue
        return CGAffineTransform(scaleX: scaleX, y: scaleY)
    }
    
    private func getTranslate(newValue sliderValue: CGFloat) -> CGAffineTransform {
        // Трансформация переноса
        let translateX = (view.bounds.maxX - rightMargin - (squareX + leftMargin) - squareSize*maxScalingFactor) * sliderValue
        return CGAffineTransform(translationX: translateX, y: 0)
    }
    
    private func getRotate(newValue sliderValue: CGFloat) -> CGAffineTransform {
        // Трансформация поворота
        let rotateAngle = sliderValue * maxRotateAngle
        return CGAffineTransform(rotationAngle: rotateAngle)
    }
    
    private func animateSquare(newValue sliderValue: CGFloat, withDuration duration: TimeInterval) {
        
        let animator = UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration, delay:0, options: []) {
            self.squareView.transform = self.getScaling(newValue: sliderValue)
                .concatenating(self.getRotate(newValue: sliderValue))
                .concatenating(self.getTranslate(newValue: sliderValue))
        }
       animator.startAnimation()
    }
    
    @objc func sliderValueChanged() {
        animateSquare(newValue: CGFloat(slider.value), withDuration: 0)
    }
    
    @objc func sliderReleased() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration, delay:0, options: []) {
            self.slider.setValue(1, animated: true)
        }
        self.animateSquare(newValue: CGFloat(1), withDuration: duration)
    }
}
