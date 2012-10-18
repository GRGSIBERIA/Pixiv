=begin
クラスタリングのテスト  
=end
require './pixiv/database/db.rb'

def GetTagsByIllustID(db, illust_id)
  # イラストIDに対応したタグを抽出する
  tags = Array.new
  sql = 'select tagid from tags_array_table where illust_id = ? limit 10'
  db.execute(sql, [illust_id]) do |rows|
    tags << rows[0].to_i
  end
  tags  # return タグIDの配列
end

def GetIllustsByTagID(db, tagid)
  # タグからイラストを検索する
  illusts = Array.new
  sql = 'select illust_id from tags_array_table where tagid = ? limit 10'
  db.execute(sql, [tagid]) do |rows|
    illusts << rows[0].to_i
  end
  illusts  # return イラストIDの配列
end

def GetTagName(db, tagid)
  sql = 'select name from tag_table where tagid = ? limit 1'
  db.execute(sql, [tagid]) do |rows|
    return rows[0]
  end
  nil
end

# タグIDの配列からカウントを引き出す tagidsはArray
def GetCountByTagIDs(db, tagids)
  sql = 'select tagid, count from tag_table where tagid = ? '
  if tagids.length < 1 then return nil; end
  
  for i in 1..tagids.length-1 do
    sql += 'or tagid = ? '
  end
  sql += 'limit ' + tagids.length.to_s
  
  result = Hash.new
  db.execute(sql, tagids) do |rows|
    result[rows[0].to_i] = rows[1].to_i
  end
  result
end

def GetTagsNames(db, tagids)
  args = Array.new
  sql = 'select * from tag_table where tagid = ? '
  args << tagids[0]
  for i in 1..tagids.length-1
    sql += 'or tagid = ? '
    args << tagids[i]
  end
  sql += 'limit ?'
  args << tagids.length
  
  result = Hash.new
  db.execute(sql, args) do |rows|
    result[rows[0].to_i] = rows[1]
  end
  result  # Integer => String
end

def GetPageByTagID(db, tagid)
  illusts_by_tag = GetIllustsByTagID(db, tagid)   # タグIDを利用してタグのあるイラストを検索
    
  # 1ページ分のイラスト情報
  illust_tags = Array.new
  for illust in illusts_by_tag do
    illust_tags << GetTagsByIllustID(db, illust)
  end
  illust_tags
end

# タグの出現回数を調べる
def AppearCountFromTag(page)
  tags_count_array = Hash.new
  illust_count = page.length
  for tags in page do
    for tag in tags do
      tags_count_array[tag] ||= 0
      tags_count_array[tag] += 1
    end
  end
  tags_count_array
end

# ある出現率以下のタグをすべて除外する
def ExcludeCountingRatioOrLess(tags_count_array, illust_count)
  pair = Array.new
  illust_diff = 1.0 / illust_count  # ページ内のイラスト比率のタネ
  tags_count_array.each{|k,v| 
    if (v * illust_diff).to_f > 0.8 then
      pair << k
    end
  }
  # タグが1個以下の場合はnilを返すようにする
  if pair.length <= 1 then return nil; end
  pair
end

def SearchAlivePairs(db, tags)
  # 生き残る組み合わせをタグごとに探索する
  pairs_array = Array.new
  for tagid in tags do
    page = GetPageByTagID(db, tagid)
    
    # タグの出現回数を調べる
    tags_count_array = AppearCountFromTag(page)
    
    # ページ内のイラスト数とタグのカウントが一致したら生き残り
    illust_count = page.length
    pair = ExcludeCountingRatioOrLess(tags_count_array, illust_count)
    if pair != nil then # ペアが作れなかったのは追加しない
      pairs_array << pair
    end
  end
  pairs_array
end

def ArrangeNonDuplicationPairs(pairs)
  # 重複なしの1次元配列に整理する
  non_duplication_array = Array.new
  for pair in pairs do
    for item in pair do
      if item != nil then
        non_duplication_array << item
      end
    end
  end
  non_duplication_array
end

def ExtractPairs(db, pairs)
  extract_data = Hash.new
  buffer_array = Array.new
  for pair in pairs do
    # 要素数が２以上ある＝ペアができているので追加
    if pair.length > 1 then
      for e in pair do
        ind = buffer_array.index(e)
        if ind == nil then  # 重複は無視したい
          buffer_array << e
        end
      end
    end
  end
  buffer_array
  #GetTagsNames(db, buffer_array)
end

# タグの種別を調べる
def DecisionTypeFromTag(db, tagids)
  count_hash = GetCountByTagIDs(db, tagids)
  
  # カウントを正規化して、ある一定値以下は除外する
  result_array = Array.new
  max = count_hash.max{|a,b| a[1] <=> b[1]}[1]
  count_norm = 1.0 / max.to_f
  count_hash.each{|id, count| 
    if (count.to_f * count_norm) > 0.001 then
      result_array << id
    end
    }
  result_array
  
  # TODO ちゃんと判別処理まで書く
end

def Clastering(db, illust_id)
  tags = GetTagsByIllustID(db, illust_id)
  pairs = SearchAlivePairs(db, tags)
  
  for p in pairs do
    for t in p do
      puts GetTagName(db, t)
    end
    puts "---"
  end
  
  # 存在している組み合わせの中で検索ヒット数を比較し、
  # 多い方が作品、少ない方がキャラとして区別する
  aliving_tags = ExtractPairs(db, pairs)
  id = DecisionTypeFromTag(db, aliving_tags)
  GetTagsNames(db, id)
end

db = Pixiv::Database::DB.new
tags = Clastering(db.db, 1918421)

puts "result-----"
tags.each{|k,v| puts v.to_s}
db.close