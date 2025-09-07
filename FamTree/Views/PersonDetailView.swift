import SwiftUI

struct PersonDetailView: View {
    @State var person: Person

    var body: some View {
        List {
            Section("基本情報") {
                KeyValueRow(key: "氏名", value: formatName(person))

                if (person.familyKana?.isEmpty == false) || (person.givenKana?.isEmpty == false) {
                    KeyValueRow(key: "フリガナ(姓)", value: person.familyKana)
                    KeyValueRow(key: "フリガナ(名)", value: person.givenKana)
                } else {
                    // 互換: 旧一括フリガナがある場合のみ表示
                    KeyValueRow(key: "フリガナ", value: person.kana)
                }
                KeyValueRow(key: "生年", value: person.birthYear.map(String.init))
            }
            Section("メモ") {
                Text(person.note ?? "—")
            }
        }
        .navigationTitle("あなた")
    }
}

struct KeyValueRow: View {
    let key: String
    let value: String?
    var body: some View {
        HStack {
            Text(key)
            Spacer()
            Text(value?.isEmpty == false ? value! : "—")
                .foregroundStyle(.secondary)
        }
    }
}
