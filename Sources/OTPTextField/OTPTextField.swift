//
//  Created by Jamal Alaayq on 2022-12-24.
//

import SwiftUI

public enum OTPLength: UInt8 {
    case four = 4, five = 5, six = 6, seven = 7, eight = 8
}

public struct OTPTextField: View {
    private var otpLength: OTPLength
    private var placeholder: Character
    private var onFinish: (String) -> Void
    private var selectionColor, nonSelectionColor: Color
    private var focusedOnAppear: Bool
    
    @State private var otp: String = ""
    @FocusState private var isKeyboardShown: Bool
    
    public init(
        otpLength: OTPLength = .six,
        placeholder: Character = " ",
        selectionColor: Color = .black,
        nonSelectionColor: Color = .gray,
        focusedOnAppear: Bool = false,
        onFinish: @escaping(String) -> Void
    ) {
        self.otpLength = otpLength
        self.placeholder = placeholder
        self.selectionColor = selectionColor
        self.nonSelectionColor = nonSelectionColor
        self.focusedOnAppear = focusedOnAppear
        self.onFinish = onFinish
    }
    
    public var body: some View {
        // MARK: Boxes
        HStack(spacing: .zero) {
            ForEach(0..<otpLength.rawValue, id: \.self) { tag in
                ZStack {
                    if otp.count > tag {
                        let index = otp.index(otp.startIndex, offsetBy: Int(tag))
                        Text(verbatim: String(otp[index]))
                            .fontWeight(.bold)
                    } else {
                        Text(verbatim: String(placeholder.isWhitespace ? " " : placeholder))
                            .fontWeight(.bold)
                    }
                }
                .padding()
                .background {
                    let selected = isKeyboardShown && otp.count == tag
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .stroke(selected ? selectionColor : nonSelectionColor, lineWidth: selected ? 0.8 : 0.5)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity)
        .fixedSize(horizontal: false, vertical: true)
        .onChange(of: otp) {
            if $0.count == Int(otpLength.rawValue) {
                isKeyboardShown = false
                onFinish(otp)
            }
        }
        .background {
            // MARK: Text Field
            TextField("", text: $otp.limit(Int(otpLength.rawValue)))
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .frame(width: 0.5, height: 0.5)
                .opacity(0.001)
                .blendMode(.screen)
                .focused($isKeyboardShown)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isKeyboardShown = true
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button {
                    isKeyboardShown = false
                } label: {
                    Image(systemName: "keyboard.chevron.compact.down")
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .onAppear { isKeyboardShown = focusedOnAppear }
    }
}

extension Binding where Value == String {
    func limit(_ length: Int) -> Self {
        if wrappedValue.count > length {
            DispatchQueue.main.async {
                wrappedValue = String(wrappedValue.prefix(length))
            }
        }
        return self
    }
}
