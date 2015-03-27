module ConstantList
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
module ModifiedList
  def value
  	list.value.map{|e| "#{e}_#{modifier.text_value}"}
  end
end
module Constant
	def value
		text_value
	end
end
module ListOfConstantOrModifiedList
  def value
    values = [elements[0].value]
    if elements.size > 1
      elements[1].elements.each do |element|
        values << element.elements[3].value
      end
    end
    values.flatten
  end
end