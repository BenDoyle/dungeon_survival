module MonsterFlags
  def value
    values = [elements[0].text_value]
    if elements.size > 1
      elements[1].elements.each do |element|
        values << element.elements[3].text_value
      end
    end
    values
  end
end