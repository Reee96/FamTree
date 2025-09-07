import SwiftUI
import SwiftData

struct PersonFormView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var familyName = ""
    @State private var givenName = ""
    @State private var familyKana = ""
    @State private var givenKana  = ""
    @State private var birthYear = ""
    @State private var note = ""

    var body: some View {
        Form {
            Section("基本情報") {
                TextField("姓", text: $familyName)
                TextField("名", text: $givenName)
                TextField("フリガナ(姓)", text: $familyKana)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)

                TextField("フリガナ(名)", text: $givenKana)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                TextField("生年（例: 1988）", text: $birthYear).keyboardType(.numberPad)
            }
            Section("メモ") {
                ZStack(alignment: .topLeading) {
                    if note.isEmpty {
                        Text("任意メモ")
                            .foregroundStyle(.secondary)
                            .padding(.top, 8)
                    }
                    TextEditor(text: $note)
                        .frame(minHeight: 100)
                }
            }
            Section {
                Button {
                    let y = Int(birthYear)
                    let me = Person(isYou: true,
                                    familyName: familyName.isEmpty ? nil : familyName,
                                    givenName: givenName.isEmpty ? nil : givenName,
                                    familyKana: familyKana.isEmpty ? nil : familyKana,
                                    givenKana: givenKana.isEmpty ? nil : givenKana,
                                    birthYear: y,
                                    note: note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : note)
                    context.insert(me)
                    try? context.save()
                    dismiss()
                } label: {
                    Label("保存", systemImage: "checkmark.circle.fill")
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .navigationTitle("あなたの情報")
    }
}
