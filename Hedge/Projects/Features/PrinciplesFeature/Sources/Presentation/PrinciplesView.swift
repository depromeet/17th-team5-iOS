//
//  PrinciplesView.swift
//  PrinciplesFeature
//
//  Created by 이중엽 on 11/1/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignKit
import Core

import PrinciplesFeatureInterface
import PrinciplesDomainInterface

@ViewAction(for: PrinciplesFeature.self)
public struct PrinciplesView: View {
    
    @Bindable public var store: StoreOf<PrinciplesFeature>
    
    public init(store: StoreOf<PrinciplesFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            topSection
            
            ScrollView {
                VStack(spacing: 0) {
                    systemGroupSection
                    customGroupSection
                }
                .padding(.bottom, 32)
            }
            
            if store.state.selectedGroupId != nil {
                VStack(spacing: 12) {
                    if store.state.viewType == .management {
                        Text("한 템플릿당 최대 5개를 추가할 수 있어요")
                            .font(FontModel.body3Medium)
                            .foregroundStyle(Color.hedgeUI.textAssistive)
                    }
                    
                    bottomCTASection
                }
            }
        }
        .background(Color.hedgeUI.backgroundWhite)
        .onAppear {
            send(.onAppear)
        }
    }
    
    // MARK: - Top Section
    private var topSection: some View {
        HStack(alignment: .center) {
            Text("어떤 원칙 그룹으로 회고할까요?")
                .font(.body1Semibold)
                .foregroundStyle(Color.hedgeUI.grey900)
            
            Spacer()
            
            Button(action: {
                send(.closeButtonTapped)
            }) {
                Image.hedgeUI.closeBottomSheet
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 22)
        .padding(.bottom, 18)
    }
    
    // MARK: - Default Group Section
    private var systemGroupSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("기본")
                    .font(.label2Medium)
                    .foregroundStyle(Color.hedgeUI.textAlternative)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 4)
                
                Spacer()
            }
            
            // Principle Items
            VStack(spacing: 0) {
                ForEach(store.state.defaultPrincipleGroups, id: \.id) { group in
                    principleGroupItem(group: group)
                }
            }
        }
    }
    
    // MARK: - Custom Group Section
    private var customGroupSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("내가 만든")
                    .font(.label2Medium)
                    .foregroundStyle(Color.hedgeUI.textAlternative)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 4)
                
                Spacer()
            }
            
            if store.state.viewType == .management {
                addNewGroupButton
            }
            
            // Custom Principle Items
            VStack(spacing: 0) {
                ForEach(store.state.customPrincipleGroups, id: \.id) { group in
                    principleGroupItem(group: group)
                }
            }
        }
    }
    
    // MARK: - Principle Group Item
    private func principleGroupItem(group: PrincipleGroup) -> some View {
        VStack(spacing: 0) {
            let isSelected = store.state.isSelected(group.id)
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    _ = send(.groupTapped(group.id))
                }
            }) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.hedgeUI.neutralBgSecondary)
                            .frame(width: 32, height: 32)
                        
                        Text(extractEmoji(from: group.groupName))
                            .font(.body3Semibold)
                    }
                    
                    // Title
                    Text(group.groupName)
                        .font(isSelected ? .body3Semibold : .body3Medium)
                        .foregroundStyle(isSelected ? Color.hedgeUI.brandPrimary : Color.hedgeUI.textTitle)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Trailing Icon
                    Group {
                        if isSelected {
                            Image.hedgeUI.check
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(Color.hedgeUI.brandPrimary)
                        } else {
                            Image.hedgeUI.arrowRightThin
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                    }
                    .animation(.easeInOut(duration: 0.2), value: isSelected)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
            .buttonStyle(.plain)
            
            if let groupID = store.state.selectedGroupId, groupID == group.id {
                subPrinciplesView(principles: group.principles)
            }
        }
    }
    
    // MARK: - Helper
    private func extractEmoji(from text: String) -> String {
        // groupName에서 이모지 추출 (예: "🔥 이건 좀 지키자 제발" -> "🔥")
        let emojiScalarRanges = [
            0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
            0x1F1E0...0x1F1FF, // Regional indicators
            0x2600...0x26FF,   // Misc symbols
            0x2700...0x27BF,   // Dingbats
            0xFE00...0xFE0F,   // Variation Selectors
            0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
            0x1FA00...0x1FA6F  // Chess Symbols
        ]
        
        for scalar in text.unicodeScalars {
            if emojiScalarRanges.contains(where: { $0.contains(Int(scalar.value)) }) {
                return String(scalar)
            }
        }
        
        // 이모지가 없으면 기본 아이콘
        return "💡"
    }
    
    // MARK: - Sub Principles View
    private func subPrinciplesView(principles: [Principle]) -> some View {
        HStack(alignment: .top, spacing: 24) {
            // Vertical indicator
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.hedgeUI.neutralBgSecondary)
                .frame(width: 3)
            
            // Sub-principles list
            VStack(alignment: .leading, spacing: 12) {
                ForEach(Array(principles.enumerated()), id: \.element.id) { index, principle in
                    subPrincipleItem(number: "\(index + 1)", text: principle.principle)
                        .transition(.opacity.combined(with: .move(edge: .leading)))
                }
            }
        }
        .padding(.leading, 36)
        .padding(.trailing, 32)
        .padding(.bottom, 16)
    }
    
    // MARK: - Sub Principle Item
    private func subPrincipleItem(number: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text(number)
                .font(.body3Semibold)
                .foregroundStyle(Color.hedgeUI.brandPrimary)
                .frame(width: 12)
            
            Text(text)
                .font(.body3Regular)
                .foregroundStyle(Color.hedgeUI.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    // MARK: - Add New Group Button
    private var addNewGroupButton: some View {
        Button(action: {
            // TODO: 새로운 원칙 그룹 추가 액션
        }) {
            HStack(spacing: 12) {
                Image.hedgeUI.thumbnailAdd
                
                // Title
                Text("새로운 원칙 그룹 추가")
                    .font(.body3Medium)
                    .foregroundStyle(Color.hedgeUI.textTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Bottom CTA Section
    private var bottomCTASection: some View {
        HedgeActionButton(store.state.buttonTitle) {
            send(.confirmButtonTapped)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}
