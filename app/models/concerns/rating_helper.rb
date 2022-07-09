module RatingHelper
  extend ActiveSupport::Concern

  def rating_rank(service)
    rating = service.rag

    rating_number = {
      vl: 1,
      l:  2,
      m:  3,
      h:  4,
      vh: 5
    }

    rating_number[rating.downcase.to_sym]
  end

  # compare rag rating (materiality) then within that compare alphabetically on process name
  def compare_rating(r_1, r_2)
    r_num_1 = rating_rank(r_1)
    r_num_2 = rating_rank(r_2)
    
    return r_1.production_process.name <=> r_2.production_process.name if r_num_1 == r_num_2
    return r_num_1 > r_num_2 ? -1 : 1
  end

  def unique_materialities_from_services(ecosystem_services)
    unfiltered_materialities = ecosystem_services.map(&:materialities).flatten(1)

    highest_rated_materialities = unfiltered_materialities.sort{|a,b| compare_rating(a, b)}.uniq(&:production_process)
  end
end
