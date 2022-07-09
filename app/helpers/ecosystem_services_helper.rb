module EcosystemServicesHelper


# compare keys of ad based on firstly, max_influence and failing that alphabetically  
  def compare_assets_drivers(a, b, ad)
    order = "RAG"
    influence_order =  order.index(max_influence(ad[a])) <=> order.index(max_influence(ad[b]))

    return  a<=> b if influence_order == 0
    return influence_order
  end

  # returns the maximum influnce in the given array of assets_drivers_joins
  def max_influence(a)
    seenA = false
    a.each{|x|
      return 'R' if x.influence == 'R'
      seenA = true if x.influence == 'A'
    }
    return 'A' if seenA 
    return 'G'
  end  
end
