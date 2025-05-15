//
//  AddAnniversaryView.swift
//  JnDay2
//
//  Created by RebuildCode on 2025/5/2.
//

import SwiftUI
import PhotosUI

struct AddAnniversaryView: View {
    @StateObject private var themeManager = ThemeManager.shared
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var date = Date()
    @State private var type: AnniversaryType = .birthday
    @State private var isLunar = false
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    
    private var anniversary: Anniversary?
    
    init(anniversary: Anniversary? = nil) {
        self.anniversary = anniversary
        if let anniversary = anniversary {
            _title = State(initialValue: anniversary.title)
            _date = State(initialValue: anniversary.date)
            _type = State(initialValue: anniversary.type)
            _isLunar = State(initialValue: anniversary.isLunar)
            _selectedImageData = State(initialValue: anniversary.imageData)
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Button("取消") {
                    dismiss()
                }
                .tint(ThemeManager.shared.primaryColor)
                
                Spacer()
                
                Text(anniversary == nil ? "添加纪念日" : "编辑纪念日")
                    .font(.headline)
                    .foregroundColor(ThemeManager.shared.primaryColor)
                
                Spacer()
                
                Button("保存") {
                    if let existingAnniversary = anniversary {
                        existingAnniversary.title = title
                        existingAnniversary.date = date
                        existingAnniversary.imageData = selectedImageData
                        existingAnniversary.type = type
                        existingAnniversary.isLunar = isLunar
                    } else {
                        let newAnniversary = Anniversary(
                            title: title,
                            date: date,
                            imageData: selectedImageData,
                            type: type,
                            isLunar: isLunar
                        )
                        modelContext.insert(newAnniversary)
                    }
                    NotificationCenter.default.post(name: NSNotification.Name("RefreshHomeView"), object: nil)
                    dismiss()
                }
                .disabled(title.isEmpty)
                .tint(ThemeManager.shared.primaryColor)
            }
            .padding()
            
            Form {
                Section {
                    TextField("标题", text: $title)
                        .tint(ThemeManager.shared.primaryColor)
                    DatePicker("日期", selection: $date, displayedComponents: .date)
                        .tint(ThemeManager.shared.primaryColor)
                    
                    Picker("类型", selection: $type) {
                        Text(AnniversaryType.birthday.rawValue).tag(AnniversaryType.birthday)
                        .tint(ThemeManager.shared.primaryColor)
                        Text(AnniversaryType.anniversary.rawValue).tag(AnniversaryType.anniversary)
                        .tint(ThemeManager.shared.primaryColor)
                        Text(AnniversaryType.festival.rawValue).tag(AnniversaryType.festival)
                        .tint(ThemeManager.shared.primaryColor)
                    }
                    .tint(ThemeManager.shared.primaryColor)
                    
                    Toggle("农历", isOn: $isLunar)
                    .tint(ThemeManager.shared.primaryColor)
                }
                Section {
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images
                    ) {
                        if let selectedImageData,
                           let uiImage = UIImage(data: selectedImageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: 200)
                                .clipped()
                        } else {
                            Label("选择图片", systemImage: "photo")
                                .tint(ThemeManager.shared.primaryColor)
                        }
                    }
                }
            }
            .tint(ThemeManager.shared.primaryColor)
            .onChange(of: selectedItem) { oldValue, newValue in
                Task {
                    if let data = try? await newValue?.loadTransferable(type: Data.self) {
                        selectedImageData = data
                    }
                }
            }
        }
    }
}

#Preview {
    AddAnniversaryView()
        .modelContainer(for: Anniversary.self, inMemory: true)
}
