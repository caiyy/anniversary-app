//
//  BackgroundView.swift
//  JnDay2
//
//  Created by RebuildCode on 2025/5/2.
//

import SwiftUI

struct BackgroundView: View {
    @StateObject private var themeManager = ThemeManager.shared
    
    // 动画状态
    @State private var waveAnimation = 0.0
    @State private var bubbleAnimation = 0.0
    @State private var bubblePositions: [CGPoint] = []
    @State private var bubbleSizes: [CGFloat] = []
    @State private var bubbleOpacities: [Double] = []
    @State private var floatingElements: [FloatingElement] = []
    
    // 初始化气泡位置和大小
    init() {
        // 创建更多气泡，增加视觉丰富度
        let positions = (0..<18).map { _ in
            CGPoint(
                x: CGFloat.random(in: 0...1),
                y: CGFloat.random(in: 0...1)
            )
        }
        let sizes = (0..<18).map { _ in
            CGFloat.random(in: 25...90)
        }
        let opacities = (0..<18).map { _ in
            Double.random(in: 0.05...0.25)
        }
        _bubblePositions = State(initialValue: positions)
        _bubbleSizes = State(initialValue: sizes)
        _bubbleOpacities = State(initialValue: opacities)
        
        // 创建漂浮元素
        let elements = (0..<6).map { _ in
            FloatingElement(
                position: CGPoint(x: CGFloat.random(in: 0...1), y: CGFloat.random(in: 0...1)),
                size: CGFloat.random(in: 40...120),
                rotation: Double.random(in: 0...360),
                shape: Int.random(in: 0...2)
            )
        }
        _floatingElements = State(initialValue: elements)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 柔和渐变背景 - 使用多色渐变增加层次感和温暖感
                LinearGradient(
                    gradient: Gradient(colors: [
                        themeManager.primaryColor.opacity(0.1),
                        Color.white.opacity(0.95),
                        themeManager.secondaryColor.opacity(0.08),
                        themeManager.primaryColor.opacity(0.05)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                // 添加轻微纹理效果增加深度感
                ZStack {
                    ForEach(0..<3) { i in
                        Rectangle()
                            .fill(
                                themeManager.primaryColor.opacity(0.01 + Double(i) * 0.005)
                            )
                            .rotationEffect(.degrees(Double(i) * 30))
                            .blendMode(.overlay)
                    }
                }
                .opacity(0.3)
                
                // 装饰性漂浮元素 - 增加视觉趣味性和优雅感
                ForEach(0..<floatingElements.count, id: \.self) { index in
                    FloatingElementView(element: $floatingElements[index], primaryColor: themeManager.primaryColor)
                        .position(
                            x: floatingElements[index].position.x * geometry.size.width,
                            y: floatingElements[index].position.y * geometry.size.height
                        )
                        .rotationEffect(.degrees(floatingElements[index].rotation + bubbleAnimation * 15))
                        .scaleEffect(1.0 + sin(bubbleAnimation * 0.8 + Double(index)) * 0.05)
                        .opacity(0.7 + sin(bubbleAnimation + Double(index) * 0.5) * 0.3)
                        .animation(Animation.easeInOut(duration: Double.random(in: 10...18)).repeatForever(autoreverses: true), value: bubbleAnimation)
                }
                
                // 装饰性气泡 - 增加数量和变化
                ForEach(0..<bubblePositions.count, id: \.self) { index in
                    Circle()
                        .fill(
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    themeManager.primaryColor.opacity(bubbleOpacities[index] * 1.2),
                                    themeManager.primaryColor.opacity(bubbleOpacities[index] * 0.3)
                                ]),
                                center: .center,
                                startRadius: 0,
                                endRadius: bubbleSizes[index] / 2
                            )
                        )
                        .frame(width: bubbleSizes[index] * (1 + sin(bubbleAnimation + Double(index)) * 0.1), 
                               height: bubbleSizes[index] * (1 + sin(bubbleAnimation + Double(index)) * 0.1))
                        .position(
                            x: (bubblePositions[index].x + sin(bubbleAnimation * 0.5 + Double(index)) * 0.02) * geometry.size.width,
                            y: (bubblePositions[index].y + cos(bubbleAnimation * 0.5 + Double(index)) * 0.02) * geometry.size.height
                        )
                        .blur(radius: 12)
                }
                
                // 前景波浪效果
                WaveShape(amplitude: 12, frequency: 0.5, phase: waveAnimation)
                    .fill(themeManager.primaryColor.opacity(0.06))
                    .frame(height: geometry.size.height)
                    .offset(y: geometry.size.height * 0.45)
                    .blur(radius: 8)
                
                // 第二层波浪，增加层次感
                WaveShape(amplitude: 8, frequency: 0.7, phase: -waveAnimation * 0.8)
                    .fill(themeManager.primaryColor.opacity(0.04))
                    .frame(height: geometry.size.height)
                    .offset(y: geometry.size.height * 0.6)
                    .blur(radius: 10)
            }
            .onAppear {
                // 启动波浪动画 - 更流畅优雅的动画效果
                withAnimation(
                    Animation
                        .easeInOut(duration: 15) // 更长的动画周期，更加柔和
                        .repeatForever(autoreverses: false)
                ) {
                    waveAnimation = 2 * .pi
                }
                
                // 启动气泡动画 - 独立的动画循环，更加温和
                withAnimation(
                    Animation
                        .easeInOut(duration: 10) // 更长的动画周期
                        .repeatForever(autoreverses: true)
                        .delay(0.5) // 添加延迟，使动画更加自然
                ) {
                    bubbleAnimation = 1.0
                }
                
                // 随机更新漂浮元素位置
                let timer = Timer.scheduledTimer(withTimeInterval: 15, repeats: true) { _ in
                    withAnimation(Animation.easeInOut(duration: 10)) {
                        for i in 0..<floatingElements.count {
                            floatingElements[i].position = CGPoint(
                                x: CGFloat.random(in: 0.1...0.9),
                                y: CGFloat.random(in: 0.1...0.9)
                            )
                        }
                    }
                }
                timer.fire()
            }
        }
        .ignoresSafeArea()
    }
}

// 波浪形状 - 优化波浪效果
struct WaveShape: Shape {
    var amplitude: CGFloat    // 波浪振幅
    var frequency: CGFloat    // 波浪频率
    var phase: Double         // 波浪相位
    
    var animatableData: Double {
        get { phase }
        set { phase = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath()
        
        // 移动到起始点
        path.move(to: CGPoint(x: 0, y: rect.height))
        
        // 绘制波浪形状 - 使用更平滑的曲线
        let width = rect.width
        let height = rect.height
        let midHeight = height / 2
        
        // 使用更小的步长获得更平滑的曲线
        for x in stride(from: 0, through: width, by: 0.5) {
            let relativeX = x / width
            // 使用复合正弦波创造更自然的波浪
            let waveY = sin(relativeX * frequency * .pi * 2 + phase) * amplitude + 
                        sin(relativeX * frequency * .pi * 1.5 + phase * 1.1) * amplitude * 0.3
            let y = midHeight + waveY
            
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        // 完成路径
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.close()
        
        return Path(path.cgPath)
    }
}

// 漂浮元素数据模型
struct FloatingElement {
    var position: CGPoint
    var size: CGFloat
    var rotation: Double
    var shape: Int // 0: 圆形, 1: 方形, 2: 三角形
}

// 漂浮元素视图
struct FloatingElementView: View {
    @Binding var element: FloatingElement
    var primaryColor: Color
    
    var body: some View {
        Group {
            switch element.shape {
            case 0:
                Circle()
                    .stroke(primaryColor.opacity(0.2), lineWidth: 1.5)
                    .frame(width: element.size, height: element.size)
                    .blur(radius: 2)
            case 1:
                RoundedRectangle(cornerRadius: 8)
                    .stroke(primaryColor.opacity(0.15), lineWidth: 1.5)
                    .frame(width: element.size * 0.8, height: element.size * 0.8)
                    .blur(radius: 2)
            case 2:
                Triangle()
                    .stroke(primaryColor.opacity(0.18), lineWidth: 1.5)
                    .frame(width: element.size * 0.7, height: element.size * 0.7)
                    .blur(radius: 2)
            default:
                Circle()
                    .stroke(primaryColor.opacity(0.2), lineWidth: 1.5)
                    .frame(width: element.size, height: element.size)
                    .blur(radius: 2)
            }
        }
    }
}

// 三角形形状
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    BackgroundView()
}