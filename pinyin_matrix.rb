consonants = %i(b p m f d t n l g k h j q x zh ch sh r z c s)
consonants.unshift(:'')
vowels = %i(a o e -i er ai ei ao ou an en ang eng ong i ia ie iao iou ian in iang ing iong u ua uo uai uei uan uen uang ueng ü üe üan ün)
kanjis = {
  # nil: no existence
  # '' : no common kanji
  a: ['啊', nil, nil, nil],
  ba: ['八', '拔', '把', '爸'],
  pa: ['', '爬', nil, '怕'],
  ma: ['妈', '麻', '马', '骂'],
  fa: ['发', '罚', '法', ''],
  da: ['', '达', '打', '大'],
  ta: ['他', nil, '塔', '踏'],
  na: ['', '拿', '哪', '那'],
  la: ['拉', '', '', '辣'],
  ga: ['', '', '', ''],
  ka: ['咖', nil, '卡', nil],
  ha: ['哈', '', '', nil],
  zha: ['扎', '闸', '眨', '炸'],
  cha: ['插', '茶', '', '差'],
  sha: ['沙', '', '', ''],
  za: ['', '杂', '', nil],
  ca: ['擦', nil, '', nil],
  sa: ['', nil, '洒', ''],
# : ['', '', '', ''],
}

def pinyin(consonant, vowel)
  case consonant
  when :j, :q, :x
    case vowel[0]
    when 'i'
      "#{consonant}#{vowel}"
    when 'ü'
      "#{consonant}u#{vowel.to_s[1..-1]}"
    else
      nil
    end
  when :g, :k, :h, :zh, :ch, :sh, :r, :z, :c, :s
    p = case vowel
        when :a, :e,
             :ai, :ei, :ao, :ou, :an, :en, :ang, :eng, :ong,
             :u, :ua, :uo, :uai, :uan, :uen, :uang
          "#{consonant}#{vowel}"
        when :'-i'
          "#{consonant}i"
        when :uei
          "#{consonant}ui"
        when :uen
          "#{consonant}un"
        else
          ''
        end
    case p.intern
    when :'', :gi, :ki, :hi, :ra, :rai, :chei, :rei, :cei, :sei, :shong, :zua, :cua, :sua, :ruai, :zuai, :cuai, :suai, :ruang, :zuang, :cuang, :suang
      nil
    else
      p
    end
  else
    case vowel
    when :o
      case consonant
      when :d, :t, :n
        nil
      else
        "#{consonant}#{vowel}"
      end
    when :e
      case consonant
      when :b, :p, :f
        nil
      else
        "#{consonant}#{vowel}"
      end
    when :"-i"
      nil
    when :er
      if consonant == :''
        vowel
      else
        nil
      end
    when :ai, :ei, :ao, :ou, :an, :en, :ang, :eng, :ong
      p = "#{consonant}#{vowel}"
      case p.intern
      when :fai, :tei, :fao, :bou, :ten, :len, :bong, :pong, :mong, :fong
        nil
      else
        p
      end
    when :i, :ia, :ie, :iao, :iou, :ian, :in, :iang, :ing, :iong
      case consonant
      when :''
        case vowel.to_s[1]
        when 'a', 'e', 'o'
          "y#{vowel.to_s[1..-1]}"
        else
          "y#{vowel}"
        end
      else
        return nil if vowel == :iong
        vowel = :iu if vowel == :iou
        p = "#{consonant}#{vowel}"
        case p.intern
        when :fi, :bia, :pia, :mia, :fia, :tia, :nia, :fie, :fiao,
             :biu, :piu, :fiu, :tiu, :fian,
             :fin, :din, :tin,
             :biang, :piang, :miang, :fiang, :diang, :tiang, :fing
          nil
        else
          p
        end
      end
    when :u
      if consonant == :''
        'wu'
      else
        "#{consonant}#{vowel}"
      end
    when :ua, :uai, :uang, :ueng
      if consonant == :''
        "w#{vowel.to_s[1..-1]}"
      else
        nil
      end
    when :uo, :uei, :uan, :uen
      case consonant
      when :''
        "w#{vowel.to_s[1..-1]}"
      when :d, :t, :n, :l
        vowel = :ui if vowel == :uei
        vowel = :un if vowel == :uen
        p = "#{consonant}#{vowel}"
        case p.intern
        when :nui, :lui, :nun
          nil
        else
          p
        end
      else
        nil
      end
    when :ü, :üe
      case consonant
      when :''
        "yu#{vowel.to_s[1..-1]}"
      when :n, :l
        # keep ü
        "#{consonant}#{vowel}"
      end
    when :üan, :ün
      if consonant == :''
        "yu#{vowel.to_s[1..-1]}"
      else
        nil
      end
    else
      "#{consonant}#{vowel}"
    end
  end
end

htmls = []
htmls << '<table>'
htmls << '<tr>'
vowels.each do |v|
  htmls.concat(['<th>', v, '</th>'])
end
htmls << '</tr>'
consonants.each do |c|
  htmls << '<tr>'
  vowels.each do |v|
    htmls.concat(['<td>', pinyin(c, v), '</td>'])
  end
  htmls << '</tr>'
end
htmls << '</table>'

puts htmls.join("\n")
