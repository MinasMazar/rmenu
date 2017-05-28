
String.class_eval do
  def to_query_s
    gsub(/\s+/, "+")
  end
end
