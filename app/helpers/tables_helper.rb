# coding: utf-8
module TablesHelper
  def map_na_to_empty_string(array)
    array.map{|value| (value === "NA" || value === "N/A") ? "" : value}
  end

  def criteria_for_table(criteria)
    criteria.map { |criterion| 
      filtered_criterion = criterion.attributes.except("id", "table_id", "table_title", "created_at", "updated_at", "example", "use_case")
      map_na_to_empty_string(filtered_criterion.values)
    }
  end

  def methodology_table(table_id)
    filtered_methodology_criteria = MethodologyCriterium.where(table_id: table_id)
    headers = I18n.t('methodology.table_headers')
    table = {
      id:       table_id,
      title:    filtered_methodology_criteria[0][:table_title],
      headers:  headers,
    }

    table.merge!({ rows: criteria_for_table(filtered_methodology_criteria) })
  end

  def methodology_colgroup
    %{
      <colgroup><col span="2" class="">
        <col class="table-col--red">
        <col class="table-col--amber">
        <col class="table-col--green">
      </colgroup>
    }
  end

  def add_white_bg_styling(table_str)
    empty_cell_regex = /<td([^>]*)><\/td>/

    table_str.gsub(empty_cell_regex, '<td class="bg--white" \1></td>')
  end

  def html_methodology_table(table)
    add_white_bg_styling(hash_to_htmltable(table[:headers], table[:rows], 'methodology-page__table', methodology_colgroup))
  end

  def html_row(row)
    "<tr>#{row}</tr>"
  end

  def html_header_cell(entry)
    "<th>#{entry}</th>"
  end

  def html_cell(entry, span=1)
    "<td rowspan=\"#{span}\">#{entry}</td>"
  end

  def html_headers(headers)
    html_row(headers.map{|header| html_header_cell(header)}.join)
  end

  def html_rows(rows, is_rails_array)
    html_rows = ''
    rows.each do |row|
      row = row.attributes.values if is_rails_array
      html_rows += html_row(row.map{|entry| html_cell(entry)}.join)
    end

    return html_rows
  end

  def html_table_start(table_class='', colgroup='')
    %{
      <div class=\"container--scroll-x\">
        <table class=\"table--min-width #{table_class}\" border=\"1\">
          #{colgroup}
          <tbody>
    }
  end

  def html_table_end
    "</tbody></table></div>"
  end
  
  def hash_to_htmltable(headers, rows, table_class='', colgroup='', is_rails_array=false)
    html = html_table_start(table_class, colgroup)
    html += html_headers(headers)
    html += html_rows(rows, is_rails_array)
    html += html_table_end
  end
end

