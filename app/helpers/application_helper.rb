# frozen_string_literal: true

CMS_PAGES_EXCLUDED_FROM_NAV = %w[Legal Landing\ Page Security].freeze

# @see https://polyfill.io/v3/url-builder
POLYFILL_DEPENDENCIES = %w[
  Array.from
  Array.isArray
  Array.of
  Array.prototype.entries
  Array.prototype.every
  Array.prototype.fill
  Array.prototype.filter
  Array.prototype.find
  Array.prototype.findIndex
  Array.prototype.forEach
  Array.prototype.includes
  Array.prototype.indexOf
  Array.prototype.keys
  Array.prototype.map
  Array.prototype.reduce
  Array.prototype.some
  Array.prototype.values
  console
  console.error
  console.log
  document
  document.head
  document.querySelector
  Element
  Element.prototype.classList
  Element.prototype.closest
  Element.prototype.scrollIntoView
  Function.prototype.bind
  Intl.NumberFormat
  JSON
  localStorage
  location.origin
  Map
  Number.isNaN
  Number.parseFloat
  Number.parseInt
  Object.assign
  Object.defineProperty
  Object.entries
  Object.freeze
  Object.is
  Object.keys
  Object.values
  Promise
  Promise.prototype.finally
  RegExp.prototype.flags
  Set
  String.prototype.codePointAt
  String.prototype.endsWith
  String.prototype.includes
  String.prototype.repeat
  String.prototype.startsWith
  URL
  URLSearchParams
].freeze

module ApplicationHelper
  include IndicatorsHelper

  def polyfill_url
    query_string = { features: POLYFILL_DEPENDENCIES.join(','), version: '3.52.1' }

    "https://polyfill.io/v3/polyfill.min.js?#{query_string.to_query}"
  end

  def navigation
    structure = [
      {
        id: 'dashboard',
        label: t('navigation.dashboard'),
        url: authenticated_root_path,
        is_hidden_page: false,
        children: nil,
        display_mode: :signed_in
      },
      {
        id: 'portfolios',
        label: t('navigation.portfolios'),
        url: portfolios_path,
        is_hidden_page: false,
        children: nil,
        display_mode: :signed_in
      },
      *format_pages_to_hash(cms_pages_for_nav)
    ]

    generate_navigation(structure, user_signed_in?).to_json
  end

  def cms_pages_for_nav
    @cms_site.pages.root.children.published.order(:position)
      .reject { |page| CMS_PAGES_EXCLUDED_FROM_NAV.include?(page.label) }
  end

  def generate_navigation(pages, authenticated)
    pages.each_with_object([]) do |page, collection|
      if page.key?(:children) && !page[:children].nil?
        page[:children] = generate_navigation(page[:children], authenticated)
      end
      if page.key?(:display_mode)
        if authenticated && page[:display_mode] == :signed_in ||
           !authenticated && page[:display_mode] != :signed_in
          collection << page
        end
      else
        collection << page
      end
    end
  end

  def page_label
    page_name = request.path.split('/').last

    @cms_page ? "page--cms #{@cms_page.label.downcase.gsub(' ', '-')}" : "page--#{page_name}"
  end

  def format_pages_to_hash(pages)
    return if pages.empty?

    pages.map do |page|
      format_page_to_hash(page)
    end
  end

  def translated_page_label(page)
    translated_page = page.translations.find_by(locale: I18n.locale)
    translated_page.nil? ? cms_fragment_content('nav_label', page) : cms_fragment_content('nav_label', translated_page)
  end

  def format_page_to_hash(page)
    # Renders a nested json of the pages in the cms
    # Pages marked with hidden still show but aren't clickable
    {
      id: page.id,
      label: translated_page_label(page),
      url: page.full_path,
      is_hidden_page: false,
      children: format_pages_to_hash(page.children.published.order(:position))
    }
  end

  def cards
    cards = [
      {
        id: 'services',
        title: t('common.e_services'),
        image: image_url('hero/Services-Hero.jpg')
      },
      {
        id: 'assets',
        title: t('common.assets'),
        image: image_url('hero/Assets-Hero.jpg')
      },
      {
        id: 'drivers',
        title: t('common.drivers'),
        image: image_url('hero/Drivers-Hero.jpg')
      },
      {
        id: 'impact_drivers',
        title: t('common.impact_drivers'),
        image: image_url('hero/ImpactDrivers-Hero.jpg')
      }
    ]

    cards.each do |card|
      card.merge!({
                    link: "/data-and-methodology/#{card[:id].gsub('_', '-')}",
                    content: cms_fragment_content("#{card[:id]}_content")
                  })
    end

    cards.to_json
  end

  def bemify(block_name, modifier = nil)
    return block_name.to_s if modifier.nil?

    "#{block_name} #{block_name}--#{modifier}"
  end

  def class_with_modifier(class_name, locals)
    locals[:class_modifier].present? ? "#{class_name}--#{locals[:class_modifier]}" : class_name
  end

  def asset_name_short(asset_name)
    case asset_name
    when 'Atmosphere'
      'Atmosphere'
    when 'Habitats'
      'Habitats'
    when 'Land geomorphology'
      'Land'
    when 'Minerals'
      'Minerals'
    when 'Ocean geomorphology'
      'Ocean'
    when 'Soils and sediments'
      'Soil'
    when 'Species'
      'Species'
    when 'Water'
      'Water'
    end
  end

  def asset_icon_path(asset_name, hero = false)
    name = asset_name_short(asset_name)

    return "icons/asset-icons/#{name}-Hero.svg" if hero

    "icons/asset-icons/#{name}.svg"
  end

  def asset_header_class(asset_name)
    "bg-asset-color--#{asset_name_short(asset_name).downcase}"
  end

  def description_for(item, default = 'Description unavailable')
    item[:description].presence || default
  end

  def hero_image(page_name = nil)
    return "hero/#{camel_case_name(@cms_page.label)}-Hero.jpg" if @cms_page

    return "hero/FP_#{camel_case_name(page_name)}.jpg" if page_name

    ''
  end

  def camel_case_name(name)
    name.split(' ').map { |name| name.capitalize }.join
  end

  def footer_image
    'footer/Footer.jpg'
  end

  def style_background_image(filename)
    return '' if filename.nil?

    style = ''

    if asset_exists?(filename)
      url = image_url(filename)
      style = 'style="background-image: url(' + url + ');"'.html_safe
    end

    style
  end

  def asset_exists?(path)
    if Rails.env.staging? || Rails.env.production?
      Rails.application.assets_manifest.assets[path].present?
    else
      Rails.application.assets.resolve(path).present?
    end
  end

  def translated_url(language_id)
    url_for(params.clone.permit!.merge(locale: language_id, only_path: true ))
  end

  def limit_characters(str, max_length)
    return str if str.length < max_length

    cropped_str = str.slice(0...max_length)

    cropped_str.slice!(-1) while cropped_str[-1] != ' ' && cropped_str.length > 0

    cropped_str.length > 0 ? cropped_str.slice(0...-1) + '...' : ''
  end

  # filler for Devise method of same name
  def resource_name
    :user
  end

  # filler for Devise method of same name
  def resource
    @user ||= User.new
  end

  # filler for Devise method of same name
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
