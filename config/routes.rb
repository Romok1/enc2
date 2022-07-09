# frozen_string_literal: true

def agriculture_dashboard_routes
  get 'validate-agriculture-dashboard', to: 'biodiversity_goals/agriculture_dashboard#validate', as: 'validate_agriculture_dashboard'
  # @TODO: namespace validate-agriculture-dashboard under agriculture-dashboard
  scope 'agriculture-dashboard' do
    root to: 'biodiversity_goals/agriculture_dashboard#index', as: 'agriculture_dashboard'
    post 'create_pdf', to: 'biodiversity_goals/agriculture_dashboard#create_pdf'
    get 'fetch_pdf/:job_id', to: 'biodiversity_goals/agriculture_dashboard#fetch_pdf'
    get 'overview', to: 'biodiversity_goals/agriculture_dashboard#overview'
    get 'csv-template', to: 'biodiversity_goals/agriculture_dashboard#csv_template'
    post 'upload-csv', to: 'biodiversity_goals/agriculture_dashboard#upload_csv', as: 'upload_agriculture_csv'
  end
end

def alignment_options_routes
  get 'alignment_options/dropdown_values', to: 'alignment_options#dropdown_filters', as: 'alignment_options_dropdown_filters'
  get 'alignment_options/fetch', to: 'alignment_options#fetch_options', as: 'alignment_options_fetch'
end

def assets_routes
  resources :assets, only: %i[index show] do
    resources :drivers, only: [:show], controller: 'assets_drivers_joins'
  end
end

def biodiversity_goals_routes
  scope 'biodiversity-goals' do
    root to: 'biodiversity_goals#index', as: 'biodiversity_goals'
    agriculture_dashboard_routes
    mining_dashboard_routes
  end
end

def companies_routes
  resources :companies, only: %i[index show]
  get 'companies_autocomplete', to: 'companies#autocomplete', as: 'companies_autocomplete'
end

def contact_routes
  post :contact, to: 'contact#submission'
end

def countries_routes
  resources :countries, only: %i[index]
  get 'countries/agriculture_countries', to: 'countries#agriculture_countries', as: 'agriculture_countries'
end

def devise_routes
  devise_for :users, controllers: {
    confirmations: 'confirmations',
    passwords: 'passwords',
    registrations: 'registrations',
    sessions: 'sessions',
    unlocks: 'unlocks'
  }

  devise_scope :user do
    get 'users/confirmation', to: 'registrations#confirmation', as: 'registration_confirmation'
  end
end

def drivers_routes
  resources :drivers, only: %i[index show]
end

def ecosystem_services_routes
  resources :ecosystem_services, only: %i[index show] do
    resources :assets, only: [:show], controller: 'ecosystem_services_assets_joins'
  end
end

def impact_drivers_routes
  resources :impact_drivers, only: %i[show index]
end

def map_routes
  scope :map do
    root to: 'map#index', as: 'map'
    get 'assets', to: 'map#assets'
    get 'dependencies', to: 'map#dependencies'
    get 'drivers', to: 'map#drivers'
    get 'hotspots', to: 'map#hotspots'
    get 'impacts', to: 'map#impacts'
  end
end

def mining_dashboard_routes
  scope 'mining-dashboard' do
    root to: 'biodiversity_goals/mining_dashboard#index', as: 'mining_dashboard'
    get 'overview', to: 'biodiversity_goals/mining_dashboard#overview'
    post 'create_pdf', to: 'biodiversity_goals/mining_dashboard#create_pdf'
    get 'fetch_pdf/:job_id', to: 'biodiversity_goals/mining_dashboard#fetch_pdf'
    get 'csv-template', to: 'biodiversity_goals/mining_dashboard#csv_template'
    post 'upload-csv', to: 'biodiversity_goals/mining_dashboard#upload_csv', as: 'upload_mining_csv'
  end
  # @TODO: namespace validate-mining-dashboard under mining-dashboard
  get 'validate-mining-dashboard', to: 'biodiversity_goals/mining_dashboard#validate', as: 'validate_mining_dashboard'
  # @TODO: namespace mines-present under mining-dashboard
  get 'mines-present', to: 'biodiversity_goals/mining_dashboard#mines_present', as: 'mines_present'
end

def natural_capital_routes
  get 'natural-capital', to: 'natural_capital#index', as: 'natural_capital'
  natural_capital_dashboard_routes
end

def natural_capital_dashboard_routes
  scope 'natural-capital-dashboard' do
    root to: 'natural_capital_dashboard#index', as: 'natural_capital_dashboard'
    get 'data', to: 'natural_capital_dashboard#data'
    get 'flows', to: 'natural_capital_dashboard#flows_data'
  end
end

def organisation_types_routes
  resources :organisation_types, only: %i[index]
end

def portfolios_routes
  resources :portfolios, only: %i[index show create update destroy]
end

def production_processes_routes
  get 'natural-capital-filter', to: 'production_processes#natural_capital_filter'
  resources :production_processes, only: %i[index show] do
    resources :ecosystem_services, only: [:show], controller: 'materialities'
    resources :impact_drivers, only: [:show], controller: 'impacts'
  end
end

def sectors_routes
  resources :sectors, only: %i[index show]
end

def sub_industries_routes
  resources :sub_industries, only: [:index]
end

def tools_routes
  scope :tools do
    root to: 'tools#index', as: :authenticated_root
    biodiversity_goals_routes
    natural_capital_routes
  end
end

def users_routes
  get :my_identity, to: 'users#my_identity', as: 'my_identity'
end

def z__comfy_routes
  comfy_route :cms_admin, path: 'admin'
  comfy_route :cms, path: '/'
end

Rails.application.routes.draw do
  root to: redirect('/en')

  scope '(:locale)', locale: /en|es|rt/ do
    alignment_options_routes
    assets_routes
    companies_routes
    contact_routes
    countries_routes
    devise_routes
    drivers_routes
    ecosystem_services_routes
    impact_drivers_routes
    map_routes
    organisation_types_routes
    portfolios_routes
    production_processes_routes
    sectors_routes
    sub_industries_routes
    tools_routes
    users_routes
    z__comfy_routes # MUST BE LAST
  end
end
