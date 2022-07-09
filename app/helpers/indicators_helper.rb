module IndicatorsHelper
  def indicator_rating_class_from_join(join, join_type)
    indicator_rating_class(
      rating_from_join(join, join_type),
      join_type
    )
  end

  def indicator_rating_class(rating, join_type = nil)
    base_class = "indicator--#{rating_type(rating)}"

    unless join_type.nil?
      base_class += " indicator--#{join_shape(join_type)}"
    end

    "#{base_class} #{base_class}--#{I18n.locale}"
  end

  def rating_type(rating)
    case de_rag_rating(rating)
    when 'VH'
      'v-high'
    when 'H'
      'high'
    when 'M'
      'medium'
    when 'L'
      'low'
    when 'VL'
      'v-low'
    else
      'unknown'
    end
  end

  def de_rag_rating(rating)
    case rating
    when 'R'
      'H'
    when 'A'
      'M'
    when 'G'
      'L'
    else
      rating
    end
  end

  def join_shape(join_type)
    case join_type
    when 'materiality'
      'circle'
    when 'importance'
      'triangle'
    when 'influence'
      'square'
    else
      'circle'
    end
  end

  def indicator_trio_class
    "indicator-trio indicator-trio--#{I18n.locale}"
  end

  def indicator_rating_text(join, join_type)
    rating = rating_from_join(join, join_type).downcase

    case join_type
    when 'materiality'
      t("ratings.materiality_rating.#{rating}")
    when 'importance'
      t("ratings.importance.#{rating}")
    else
      t("ratings.materiality_rating.#{rating}")
    end
  end

  def rating_from_join(join, join_type)
    case join_type
    when 'influence'
      rating = join.influence
    when 'importance'
      rating = join.importance
    else
      rating = join.rag
    end

    de_rag_rating(rating)
  end
end