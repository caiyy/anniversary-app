//
//  Components.swift
//  JnDay2
//
//  Created by RebuildCode on 2025/5/2.
//

import SwiftUI

struct SearchBar: View {
    @StateObject private var themeManager = ThemeManager.shared
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(ThemeManager.shared.secondaryColor)
            
            TextField("搜索纪念日...", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(ThemeManager.shared.secondaryColor)
                }
            }
        }
        .padding(8)
        .background(ThemeManager.shared.secondaryColor.opacity(0.1))
        .cornerRadius(10)
    }
}

struct FilterButton: View {
    @StateObject private var themeManager = ThemeManager.shared
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? ThemeManager.shared.primaryColor : ThemeManager.shared.secondaryColor.opacity(0.1))
                .foregroundColor(isSelected ? .white : ThemeManager.shared.primaryColor)
                .cornerRadius(20)
        }
    }
}

struct CircularProgressView: View {
    @StateObject private var themeManager = ThemeManager.shared
    let daysUntil: Int
    
    private var progress: Double {
        // 计算进度：剩余天数除以一年的天数
        let yearDays = 365.0
        return 1.0 - (Double(daysUntil) / yearDays)
    }
    
    private var percentage: Int {
        // 将进度转换为百分比
        Int(progress * 100)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(ThemeManager.shared.primaryColor.opacity(0.2), lineWidth: 4)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(ThemeManager.shared.primaryColor, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .rotationEffect(.degrees(-90))
            
            // 显示百分比
            Text("\(percentage)%")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(ThemeManager.shared.primaryColor)
        }
    }
}

struct AnniversaryCard: View {
    @StateObject private var themeManager = ThemeManager.shared
    let anniversary: Anniversary
    @Environment(\.modelContext) private var modelContext
    @State private var showingActionSheet = false
    @State private var showingEditSheet = false
    
    // 生成祝福语
    private func generateGreeting() -> String {
        let name = anniversary.title
        let isToday = daysUntil == 0
        let daysText = isToday ? "今天" : "还有\(daysUntil)天"
        
        switch anniversary.type {
        case .birthday:
            return isToday ? 
                "\(name)生日快乐！🎂\n今天是你的生日，愿你开心每一天！" :
                "\(name)的生日即将到来！🎂\n\(daysText)就是你的生日了\n让我们一起期待这个特别的日子！"
        case .anniversary:
            return isToday ?
                "纪念日快乐！💝\n今天是\(name)，愿这一天充满美好的回忆！" :
                "\(name)即将到来！💝\n\(daysText)就是这个特别的日子了\n让我们一起期待！"
        case .festival:
            return isToday ?
                "\(name)快乐！🎉\n今天是\(name)，祝你节日愉快！" :
                "\(name)即将到来！🎉\n\(daysText)就是\(name)了\n让我们一起期待这个欢乐的日子！"
        }
    }
    
    // 生成分享图片
    private func generateShareImage() -> UIImage? {
        guard let imageData = anniversary.imageData,
              let originalImage = UIImage(data: imageData) else { return nil }
        
        // 使用原始图片尺寸，但限制最大尺寸
        let maxWidth: CGFloat = 1080 // 最大宽度
        let maxHeight: CGFloat = 1080 // 最大高度
        
        let originalAspectRatio = originalImage.size.width / originalImage.size.height
        var targetSize: CGSize
        
        if originalImage.size.width > maxWidth || originalImage.size.height > maxHeight {
            if originalAspectRatio > 1 {
                targetSize = CGSize(width: maxWidth, height: maxWidth / originalAspectRatio)
            } else {
                targetSize = CGSize(width: maxHeight * originalAspectRatio, height: maxHeight)
            }
        } else {
            targetSize = originalImage.size
        }
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = 2.0 // 使用2倍缩放以确保清晰度
        format.opaque = false
        
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        
        let shareImage = renderer.image { context in
            // 绘制原始图片
            originalImage.draw(in: CGRect(origin: .zero, size: targetSize))
            
            // 添加渐变遮罩以提高文字可读性
            let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                    colors: [UIColor.black.withAlphaComponent(0.1).cgColor,
                                            UIColor.black.withAlphaComponent(0.6).cgColor] as CFArray,
                                    locations: [0, 1])
            
            // 渐变覆盖整个图片
            let gradientStart: CGFloat = 0
            let gradientEnd = targetSize.height
            
            context.cgContext.drawLinearGradient(gradient!,
                                                start: CGPoint(x: 0, y: gradientStart),
                                                end: CGPoint(x: 0, y: gradientEnd),
                                                options: [])
            
            // 生成祝福语
            let greeting = generateGreeting()
            
            // 配置文本样式
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            paragraphStyle.lineSpacing = targetSize.height * 0.02 // 根据图片高度调整行间距
            
            // 根据图片尺寸调整字体大小
            let fontSize = min(targetSize.width, targetSize.height) * 0.06
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: fontSize, weight: .bold),
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraphStyle,
                .strokeColor: UIColor.black,
                .strokeWidth: -2.0
            ]
            
            // 计算文本大小
            let textSize = greeting.size(withAttributes: attributes)
            let textRect = CGRect(
                x: (targetSize.width - textSize.width) / 2,
                y: targetSize.height * 0.75 - textSize.height / 2, // 将文本位置调整到渐变区域的中心
                width: textSize.width,
                height: textSize.height
            )
            
            // 绘制文本
            greeting.draw(in: textRect, withAttributes: attributes)
        }
        
        return shareImage
    }
    
    var daysUntil: Int {
        return anniversary.daysUntilNextAnniversary
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            if let imageData = anniversary.imageData,
               let uiImage = UIImage(data: imageData) {
                GeometryReader { geometry in
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .blur(radius: 15)
                        .opacity(0.5)
                        .clipped()
                }
            }
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(anniversary.title)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(ThemeManager.shared.primaryColor)
                        HStack{
                            Text("\(DateConverter._isLunar(isLunar: anniversary.isLunar, Tbox: 0, date: anniversary.date,_anniversary: anniversary))")
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundColor(Color.white)
                                .background(ThemeManager.shared.primaryColor)
                                .cornerRadius(8)
                                //DateConverter.solarToLunar(date: anniversary.date) : anniversary.date.formatted(date:.long, time:.omitted)
                            Text("\(DateConverter._isLunar(isLunar: anniversary.isLunar, Tbox: 1, date: anniversary.date,_anniversary: anniversary))")
                            // Text(anniversary.isLunar ? "农历":"公历")
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundColor(Color.white)
                                .background(ThemeManager.shared.primaryColor)
                                .cornerRadius(8)
                        }

                    }
                    
                    Spacer()
                    
                    CircularProgressView(daysUntil: daysUntil)
                        .frame(width: 50, height: 50)
                        
                }
                .padding(.bottom, 8)
                
                if let imageData = anniversary.imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(15)
                }
                Text("还有\(daysUntil)天")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(ThemeManager.shared.primaryColor)
            
                HStack(spacing: 30) {
                    
                    Text(anniversary.type.rawValue)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(ThemeManager.shared.primaryColor.opacity(0.6))
                        .cornerRadius(12)
                        .foregroundColor(Color.white)
                    Spacer()
                    
                    Button(action: {
                        if let shareImage = generateShareImage() {
                            let activityVC = UIActivityViewController(
                                activityItems: [shareImage],
                                applicationActivities: nil
                            )
                            
                            // 获取当前的UIWindow场景
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                               let window = windowScene.windows.first,
                               let rootVC = window.rootViewController {
                                // 在iPad上设置弹出位置
                                if let popoverController = activityVC.popoverPresentationController {
                                    popoverController.sourceView = window
                                    popoverController.sourceRect = CGRect(x: window.bounds.midX,
                                                                         y: window.bounds.midY,
                                                                         width: 0,
                                                                         height: 0)
                                }
                                rootVC.present(activityVC, animated: true)
                            }
                        }
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 20))
                            .foregroundColor(ThemeManager.shared.primaryColor)
                            .contentShape(Rectangle())
                    }
                    
                    Button(action: {
                        withAnimation {
                            showingActionSheet = true
                        }
                        print("点击了更多按钮")
                    }) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 20))
                            .foregroundColor(ThemeManager.shared.primaryColor)
                            .contentShape(Rectangle())
                    }
                }
            }
            .padding(16)
        }
        .frame(maxWidth: .infinity)
        .background(ThemeManager.shared.secondaryColor.opacity(0.1))
        .cornerRadius(20)
        .shadow(color: ThemeManager.shared.secondaryColor.opacity(0.1), radius: 10, x: 0, y: 2)
        .sheet(isPresented: $showingEditSheet) {
            AddAnniversaryView(anniversary: anniversary)
        }
        .confirmationDialog("选择操作", isPresented: $showingActionSheet, titleVisibility: .visible) {
            Button("编辑") {
                withAnimation {
                    showingEditSheet = true
                    showingActionSheet = false
                }
            }
            Button("删除", role: .destructive) {
                withAnimation {
                    modelContext.delete(anniversary)
                    showingActionSheet = false
                }
            }
            Button("取消", role: .cancel) {
                withAnimation {
                    showingActionSheet = false
                }
            }
        }
    }
}
