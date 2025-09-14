require "ostruct"

class BooksSearch
  DEFAULT_PER_PAGE = 20

  def initialize(
    relation: Book.all,
    q: nil, from_on: nil, to_on: nil,
    min_amount: nil, max_amount: nil,
    sort: nil, page: 1, per: DEFAULT_PER_PAGE
  )
    @relation   = relation
    @q          = q.to_s.strip
    @from_on    = from_on.presence
    @to_on      = to_on.presence
    @min_amount = min_amount.presence
    @max_amount = max_amount.presence
    @sort       = sort.presence
    @page       = [ page.to_i, 1 ].max
    @per        = [ per.to_i, 1 ].max
  end

  def call
    scope = @relation.left_joins(:author) # 著者名検索のため

    # 期間フィルタ（published_on）
    if @from_on || @to_on
      from = (@from_on || Date.new(1900, 1, 1)).to_date
      to   = (@to_on   || Date.new(9999, 1, 1)).to_date
      scope = scope.where(published_on: from..to)
    end

    # 在庫数（amount）レンジ
    if @min_amount || @max_amount
      min = (@min_amount || -1_000_000).to_i
      max = (@max_amount ||  1_000_000).to_i
      scope = scope.where(amount: min..max)
    end

    # キーワード（タイトル / 著者名）: 複数語AND
    if @q.present?
      words = @q.split(/\s+/)
      words.each do |w|
        like = "%#{sanitize_like(w)}%"
        scope = scope.where(
          "books.title LIKE :w ESCAPE '\\' OR COALESCE(authors.name, '') LIKE :w ESCAPE '\\'",
          w: like
        )
      end
    end

    # 並び順
    scope = case @sort
    when "new"      then scope.order(Arel.sql("COALESCE(books.published_on, DATE(books.created_at)) DESC"), created_at: :desc)
    when "title"    then scope.order("books.title COLLATE NOCASE ASC")
    when "author"   then scope.order("authors.name COLLATE NOCASE ASC NULLS LAST")
    when "amount"   then scope.order(amount: :desc, created_at: :desc)
    else                 scope.order(Arel.sql("COALESCE(books.published_on, DATE(books.created_at)) DESC"), created_at: :desc)
    end

    total = scope.count
    items = scope.limit(@per).offset((@page - 1) * @per)

    OpenStruct.new(records: items, total:, page: @page, per: @per)
  end

  private

  # SQLite LIKE のエスケープ（% と _ と \）
  def sanitize_like(str)
    str.gsub("\\", "\\\\").gsub("%", "\\%").gsub("_", "\\_")
  end
end
