module SectorsHelper
  def sectors
    Sector.all.sort{|a,b| a.name <=> b.name}
  end

  def sub_industries(sector)
    sector.sub_industries.sort{|a,b| a.name <=> b.name}
  end
end