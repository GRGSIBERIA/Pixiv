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
  sql = 'select illust_id from tags_array_table where tagid = ? limit 20'
  db.execute(sql, [tag]) do |rows|
    illusts << rows[0].to_i
  end
  illusts  # return イラストIDの配列
end

def GetPageByTagID(db, tagid)
  illusts_by_tag = GetIllustsByTagID(db, tagid)   # タグIDを利用してタグのあるイラストを検索
    
  # 1ページ分のイラスト情報
  illust_tags = Array.new
  for illust in illusts_by_tag do
    illust_tags << GetTagsByIllustID(illust)
  end
  illust_tags
end

def SearchAlivePairs(db, tags)
  # 生き残る組み合わせをタグごとに探索する
  pairs_array = Array.new
  for tagid in tags do
    page = GetPageByTagID(tagid)
    first = tags.clone  # 初期状態からどんどん除外していく
    for fcnt in 0..first.length-1 do
      for illust in page do
        want_to_lost = illust.index(first[fcnt])
        if want_to_lost == nil then # 見つからない場合は削除
          first[fcnt] = -1
        end
      end
      first.delete(-1)  # 見つからなかった奴は消す
    end
    pairs_array << first.clone  # cloneして戻す
  end
  pairs_array
end

def GetCountFromTag(db, tagid)
  # イラストに含まれるタグの件数を取得する
  sql = 'select count(tagid) from tags_array_table where tagid = ?;'
  count = 0
  db.execute(sql, [tagid]) do |rows|
    count = rows[0].to_i
  end
  count
end

def ArrangeNonDuplicationPairs(pairs)
  # 重複なしの1次元配列に整理する
  non_duplication_array = Array.new
  for i in 0..pairs.length-1 do
    if pairs[i].length > 1 then
      if non_duplication_array.index(paris[i][j]) == nil
        non_duplication_array << pairs[i][j]
      end
    end
  end
  non_duplication_array
end

def MakeHashToCountNonDuplicationPairs(db, paris)
  # タグIDをキーにしてそれぞれの検索件数を出す
  non_duplication_array = ArrangeNonDuplicationPairs(pairs)
  counting_hash = Hsah.new
  non_duplication_array.each do |n|
    counting_hash[n] ||= GetCountFromTag(db, n)
  end
  counting_hash.sort {|(k1,v1),(k2,v2)| v2 <=> v1}
end

def Clastering(db, illust_id)
  tags = GetTagsByIllustID(db, illust_id)
  pairs = SearchAlivePairs(db, tags)
  
  # 存在している組み合わせの中で検索ヒット数を比較し、
  # 多い方が作品、少ない方がキャラとして区別する
  counted_tags = MakeHashToCountNonDuplicationPairs(db, pairs)
end

db = Pixiv::Database::DB.new

db.close