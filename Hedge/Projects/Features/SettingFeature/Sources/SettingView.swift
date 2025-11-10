//
//  SettingView.swift
//  SettingFeature
//
//  Created by Junyoung on 11/10/25.
//  Copyright © 2025 HedgeCompany. All rights reserved.
//

import SwiftUI

import DesignKit

public struct SettingView: View {
    @Environment(\.openURL) private var openURL
    
    private let viewModel: SettingViewModel
    
    public init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            backButtonView
            termsView
            accountView
            Spacer()
        }
        .padding(.horizontal, 20)
        .background(Color.hedgeUI.neutralBgSecondary)
    }
}

extension SettingView {
    private var backButtonView: some View {
        HStack(alignment: .center) {
            Button {
                viewModel.popToPrev()
            } label: {
                HedgeUI.arrowLeftThick
                    .resizable()
                    .frame(width: 24, height: 24)
                    .tint(HedgeUI.textPrimary)
            }
            
            Spacer()
        }
        .frame(height: 46)
    }
    
    private var termsView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("약관 및 정책")
                .font(.body2Semibold)
                .tint(.hedgeUI.textPrimary)
            
            VStack(alignment: .leading, spacing: 16) {
                Button {
                    openURL(URL(string: "https://www.notion.so/2a0219cc9c34801eba01ea91797dfa0f?source=copy_link")!)
                } label: {
                    HStack {
                        Text("서비스 이용약관")
                            .font(.body3Medium)
                            .tint(.hedgeUI.textSecondary)
                        Spacer()
                        
                        Image.hedgeUI.arrowRightThin
                            .resizable()
                            .frame(width: 24, height: 24)
                            .tint(.hedgeUI.textAssistive)
                    }
                }
                Button {
                    openURL(URL(string: "https://www.notion.so/2a0219cc9c3480b591ebee5e6cef6d1e?source=copy_link")!)
                } label: {
                    HStack {
                        Text("개인정보 처리방침")
                            .font(.body3Medium)
                            .tint(.hedgeUI.textSecondary)
                        
                        Spacer()
                        
                        Image.hedgeUI.arrowRightThin
                            .resizable()
                            .frame(width: 24, height: 24)
                            .tint(.hedgeUI.textAssistive)
                    }
                }
                
                Button {
                    openURL(URL(string: "https://www.notion.so/2a0219cc9c34800faf14f50bef7e8c1f?source=copy_link")!)
                } label: {
                    HStack {
                        Text("마케팅 활용 및 정보 수신")
                            .font(.body3Medium)
                            .tint(.hedgeUI.textSecondary)
                        
                        Spacer()
                        
                        Image.hedgeUI.arrowRightThin
                            .resizable()
                            .frame(width: 24, height: 24)
                            .tint(.hedgeUI.textAssistive)
                    }
                }
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .background(Color.hedgeUI.backgroundWhite)
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
    
    private var accountView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("계정 설정")
                .font(.body2Semibold)
                .tint(.hedgeUI.textPrimary)
            
            VStack(alignment: .leading, spacing: 16) {
                Button {
                    viewModel.logOutTapped()
                } label: {
                    HStack {
                        Text("로그아웃")
                            .font(.body3Medium)
                            .tint(.hedgeUI.textSecondary)
                        Spacer()
                        
                        Image.hedgeUI.arrowRightThin
                            .resizable()
                            .frame(width: 24, height: 24)
                            .tint(.hedgeUI.textAssistive)
                    }
                }
                Button {
                    viewModel.withdrawTapped()
                } label: {
                    HStack {
                        Text("회원탈퇴")
                            .font(.body3Medium)
                            .tint(.hedgeUI.textSecondary)
                        
                        Spacer()
                        
                        Image.hedgeUI.arrowRightThin
                            .resizable()
                            .frame(width: 24, height: 24)
                            .tint(.hedgeUI.textAssistive)
                    }
                }
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .background(Color.hedgeUI.backgroundWhite)
        .clipShape(RoundedRectangle(cornerRadius: 22))
    }
}
