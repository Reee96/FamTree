import SwiftData

@Model
final class Person {
    var isYou: Bool
    var familyName: String?
    var givenName: String?
    // 新: フリガナ（姓・名を個別管理）
    var familyKana: String?
    var givenKana: String?
    // DEPRECATED: 旧フリガナ(姓名一括) — 互換のため残す
    var kana: String?
    var birthYear: Int?
    var note: String?

    init(isYou: Bool = false,
         familyName: String? = nil,
         givenName: String? = nil,
         familyKana: String? = nil,
         givenKana: String? = nil,
         kana: String? = nil, // 互換用
         birthYear: Int? = nil,
         note: String? = nil) {
        self.isYou = isYou
        self.familyName = familyName
        self.givenName = givenName
        self.familyKana = familyKana
        self.givenKana = givenKana
        self.kana = kana
        self.birthYear = birthYear
        self.note = note
    }
}
