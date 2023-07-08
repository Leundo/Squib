# Squib

A Swift-language layer over SQLite3 with `decorator` interfaces.

```swift
struct Article: Explosive, Hashable {
	@Columnable("id", constraint: [.primaryKey, .autoIncrement])
	var id: Int = 0

    @Columnable("title", constraint: [.notNull])
    var title: String = ""

    @Columnable("publishedDate")
    var publishedDate: Date = Date()

    @Columnable("author")
    var author: String? = nil

    @Columnable("readers")
    @AESEncryptable
    @JSONDataCodable
    var readers: [String] = []

    @Columnable("content")
    var content: Data

    init() {}
    static let tableInfo: TableInfo = TableInfo(name: "article", connection: "acquired", constraints: [.unique(names: ["title", "author"])])
}
```

