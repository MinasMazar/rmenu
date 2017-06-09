
TrueClass.class_eval do
  def to_i
    1
  end
end

FalseClass.class_eval do
  def to_i
    0
  end
end

String.class_eval do
  def to_query_s
    gsub(/\s+/, "+")
  end
end
