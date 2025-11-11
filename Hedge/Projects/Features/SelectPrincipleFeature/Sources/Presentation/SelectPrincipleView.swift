import SwiftUI
import UIKit
import ComposableArchitecture
import DesignKit

import Core
import SelectPrincipleFeatureInterface

@ViewAction(for: SelectPrincipleFeature.self)
public struct SelectPrincipleView: View {
    @Bindable public var store: StoreOf<SelectPrincipleFeature>
    
    public init(store: StoreOf<SelectPrincipleFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            navigationBar
            
            mainContent
            
            Spacer()
            
            helperText
            
            primaryButton
        }
        .background(Color.hedgeUI.backgroundWhite)
        .onAppear {
            send(.onAppear)
        }
    }
    
    // MARK: - Navigation
    private var navigationBar: some View {
        HedgeNavigationBar(title: store.state.groupTitle, buttonText: "", onLeftButtonTap:  {
            send(.closeTapped)
        })
    }
    
    // MARK: - Main Content
    private var mainContent: some View {
        VStack(alignment: .leading, spacing: 28) {
            VStack(alignment: .leading, spacing: 8) {
                Text("어떤 조언을\n원칙으로 추가해볼까요?")
                    .font(FontModel.h1Semibold)
                    .foregroundStyle(Color.hedgeUI.textTitle)
            }
            
            VStack(spacing: 0) {
                ForEach(store.state.principles) { principle in
                    principleRow(principle)
                    
                    if principle.id != store.state.principles.last?.id {
                        Divider()
                            .foregroundStyle(Color.hedgeUI.neutralBgSecondary)
                            .padding(.leading, 52)
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.hedgeUI.backgroundWhite)
                    .shadow(color: Color.black.opacity(0.05), radius: 18, x: 0, y: 6)
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 32)
    }
    
    // MARK: - Principle Row
    private func principleRow(_ principle: SelectPrincipleFeature.PrincipleItem) -> some View {
        let isSelected = store.state.selectedPrincipleIds.contains(principle.id)
        return Button {
            send(.principleTapped(principle.id))
        } label: {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "checkmark.circle")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(isSelected ? Color.hedgeUI.brandPrimary : Color.hedgeUI.neutralBgSecondary)
                    .padding(.top, 2)
                
                Text(principle.detail)
                    .font(FontModel.body2Semibold)
                    .foregroundStyle(Color.hedgeUI.textTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .background(Color.clear)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Helper
    private var helperText: some View {
        Text(store.state.helperText)
            .font(FontModel.caption1Medium)
            .foregroundStyle(Color.hedgeUI.textAssistive)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 12)
    }
    
    // MARK: - Button
    private var primaryButton: some View {
        
        HedgeBottomCTAButton()
            .bg(.transparent)
            .style(
                .oneButton(
                    title: "원칙 추가하기",
                    onTapped: {
                        send(.primaryButtonTapped)
                    }
                )
            )
            .state(store.state.isPrimaryEnabled ? .active : .disabled)
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
    }
}
