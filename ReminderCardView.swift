//
//  ReminderCardView.swift
//  JnDay
//
//  Created by RebuildCode on 2025/5/1.
//

import SwiftUI

struct ReminderCardView: View {
    @State private var isSharePresented = false
    let card: ReminderCard
    var body: some View {
        ZStack {
            // 背景模糊图层
            Image(card.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width - 8)
                .blur(radius: 15)
                .opacity(0.6)
            
            VStack(alignment: .leading, spacing: 0) {
            // 顶部区域：标题、日期和进度环
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(card.title)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color(.label))
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(card.formattedDate)
                                .font(.system(size: 14))
                                .foregroundColor(Color(.label))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color.brandColor.opacity(0.3))
                                .cornerRadius(12)
                            Text("|")
                                .font(.system(size: 18))
                                .foregroundColor(Color(.label))
                            Text(card.convertedDate)
                                .font(.system(size: 14))
                                .foregroundColor(Color(.label))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color.brandColor.opacity(0.3))
                                .cornerRadius(12)
                        }
                    }
                }
                Spacer()
                ZStack {
                    // 进度环
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 8)
                        .frame(width: 46, height: 46)
                    // 进度环的进度
                    Circle()
                        .trim(from: 0, to: card.progress)
                        .stroke(Color.brandColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                        .frame(width: 46, height: 46)
                        .rotationEffect(.degrees(-90))
                        
                    // 进度百分比
                    Text("\(Int(card.progress * 100))%")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color(.label))
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            // 中间区域：图片
            Image(card.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 180)
                .clipped()
                .cornerRadius(15)
                .padding(.horizontal, 16)
                .padding(.top, 12)
                
            
            // 底部区域：倒计时、归类标签和操作按钮
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    // 倒计时
                    Text("还有\(card.daysLeft)天")
                        .font(.system(size: 22, weight: .black))
                        .foregroundColor(Color.pink)
                        .padding(.vertical, 6)
                    // 归类标签
                    Text(card.category)
                        .font(.system(size: 14))
                        .foregroundColor(Color.green)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.3))
                        .cornerRadius(12)
                }
                Spacer()
                HStack(spacing: 20) {
                    // 提醒按钮
                    Button(action: {}) {
                        Image(systemName: "bell")
                            .font(.system(size: 18,weight: .bold))
                            .foregroundColor(Color(.systemGray2))
                    }
                    // 分享按钮
                    Button(action: {
                        if let image = ViewRenderer.renderView(self, padding: 16, backgroundColor: UIColor.secondarySystemBackground) {
                            let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                               let window = windowScene.windows.first,
                               let rootVC = window.rootViewController {
                                activityVC.popoverPresentationController?.sourceView = rootVC.view
                                rootVC.present(activityVC, animated: true)
                            }
                        }
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 18,weight: .bold))
                            .foregroundColor(Color(.systemGray2))
                    }
                    // 更多按钮
                    Button(action: {}) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 18,weight: .bold))
                            .foregroundColor(Color(.systemGray2))
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(20)
        .shadow(color: Color(.label).opacity(0.08), radius: 10, x: 0, y: 2)
        .padding(.horizontal, 4)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
