module HitPoints
  def value
    [dice.text_value.to_i, min.text_value.to_i, extra.text_value.to_i, fixed.text_value.to_i]
  end
end
