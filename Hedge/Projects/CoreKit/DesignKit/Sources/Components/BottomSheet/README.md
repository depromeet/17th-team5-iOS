# HedgeBottomSheet

커스텀 바텀시트 Modifier 구현

## 파일 구조

```
BottomSheet/
├── HedgeBottomSheet.swift          # 핵심 컴포넌트 (enum, 내부 View)
├── HedgeBottomSheetModifier.swift  # ViewModifier 로직
└── HedgeBottomSheet+View.swift     # View Extension (편의 메서드)
```

## 주요 기능

1. ✅ **백그라운드 딤** - 0.4 opacity 딤 처리
2. ✅ **유연한 높이** - 화면 비율 또는 고정 높이 지원
3. ✅ **스크롤 지원** - 컨텐츠가 높이를 넘으면 자동 스크롤
4. ✅ **드래그 제스처** - 핸들로 높이 조절 (아래 방향만)
5. ✅ **자동 닫힘** - 100pt 이상 드래그 시 dismiss

## 사용법

### 1. 기본 사용 (화면 비율)

```swift
struct MyView: View {
    @State private var showSheet = false
    
    var body: some View {
        VStack {
            Button("바텀시트 열기") {
                showSheet = true
            }
        }
        .hedgeBottomSheet(isPresented: $showSheet, ratio: 0.5) {
            VStack {
                Text("바텀시트 컨텐츠")
                // ... 더 많은 컨텐츠
            }
            .padding()
        }
    }
}
```

### 2. 고정 높이

```swift
.hedgeBottomSheet(isPresented: $showSheet, fixedHeight: 300) {
    Text("300pt 고정 높이")
}
```

### 3. 상세 설정

```swift
.hedgeBottomSheet(
    isPresented: $showSheet, 
    height: .ratio(0.7)  // 또는 .fixed(400)
) {
    ScrollView {  // 내부에서 추가 스크롤 가능
        VStack {
            // 복잡한 컨텐츠
        }
    }
}
```

## 인터랙션

- **드래그 핸들**: 상단 회색 바를 드래그하여 조절
- **배경 탭**: 딤 처리된 배경을 탭하면 닫힘
- **스와이프 다운**: 100pt 이상 아래로 드래그하면 자동 닫힘
- **스크롤**: 컨텐츠가 높이를 넘으면 내부 스크롤 활성화

## Architecture

```
View Extension (.hedgeBottomSheet)
        ↓
HedgeBottomSheetModifier (핵심 로직)
        ↓
    ├── BottomSheetDimBackground (딤 처리)
    └── BottomSheetContainer (시트 컨테이너)
            ├── BottomSheetHandle (드래그 핸들)
            └── ScrollView (컨텐츠)
```

## 커스터마이징 가능 항목

Modifier 내부 상수를 변경하여 커스터마이징:

- `minDismissOffset`: 자동 닫힘 거리 (기본 100pt)
- `handleHeight`: 핸들 영역 높이 (기본 24pt)
- `cornerRadius`: 모서리 둥글기 (기본 20pt)
- 배경 딤 opacity (기본 0.4)
- 스프링 애니메이션 파라미터

