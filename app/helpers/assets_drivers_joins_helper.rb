module AssetsDriversJoinsHelper

  def compare_service(a,b, joins = nil)
    order = "RAG"
    imp_sort = joins.nil? ? 0 : order.index(joins.find_by(ecosystem_service: a).importance) <=> order.index(joins.find_by(ecosystem_service: b).importance)
    
    return a.name <=> b.name if imp_sort == 0
    return imp_sort
  end

  def compare_driver(a,b, joins)
    order = "RAG"
    influence_order =  order.index(joins.find_by(driver: a).influence) <=> order.index(joins.find_by(driver: b).influence)
    return a.name <=> b.name if influence_order == 0
    return influence_order

  end
  
end
