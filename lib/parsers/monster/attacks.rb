module Attacks
  def value
    [first.value, second.value, third.value, fourth.value]
  end
end
module Attack
  def value
    [type.text_value, flavour.text_value, damage.text_value.to_i]
  end
end