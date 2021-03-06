module Faalis
  module RouteHelpers

    # routes to be added to dashboard
    def in_dashboard
      namespace Faalis::Engine.dashboard_namespace do
        yield
      end
    end

    # Allow localized scope
    def localized_scope
      langs = ::I18n.available_locales.join('|')
      scope '(:locale)', locale: Regexp.new(langs) do
        yield
      end
    end

    # This method allow user to define his routes in api
    # namespace
    def api_routes(version: :v1)
      # TODO: Add a dynamic solution for formats
      namespace :api, defaults: { format: :json } do
        namespace version do
          # Call user given block to define user routes
          # inside this namespace
          yield if block_given?
        end
      end

      scope 'module'.to_sym => 'faalis' do
        #dashboard = Faalis::Engine.dashboard_namespace
        #get "#{dashboard}/auth/groups/new", to: "#{dashboard}/groups#new"
        get 'auth/profile/edit', to: "profile#edit"
        post 'auth/profile/edit', to: "profile#update"
      end

      # TODO: Add a dynamic solution for formats
      namespace :api, defaults: { format: :json } do
        namespace version do
          get 'permissions',      to: 'permissions#index'
          get 'permissions/user', to: 'permissions#user_permissions'
          resources :groups,      except: [:new]
          resources :users,       except: [:new]
          resource :profile,      except: [:new, :destroy]

          get 'logs', to: 'logs#index'
        end
      end
    end
  end


  class Routes

    class << self

      attr_accessor :engine

      def faalis(&block)
        Faalis::Engine.routes.draw(&block)
      end

      def plugin(&block)
        self.engine.routes.draw(&block)
      end

      def draw(engine, &block)
        self.engine = engine

        raise ArgumentError.new 'block is needed' unless block_given?

        self.class_eval(&block)
      end

      def localized_scop(router: Rails.application.routes)
        puts '[Warning]: This method is depricated please just use "localized_scope" in your router.'
        langs = ::I18n.available_locales.join('|')
        router.scope '(:locale)', locale: Regexp.new(langs)
      end

      # This class method will add `Faalis` routes to host application
      # Router
      def define_api_routes(routes: Rails.application.routes,
        version: :v1)
        puts '[Warning]: This method is depricated. Please use "api_routes" directly in your router.'
        routes.draw do
          # TODO: Add a dynamic solution for formats
          namespace :api, defaults: { format: :json } do
            namespace version do
              # Call user given block to define user routes
              # inside this namespace
              yield self if block_given?

            end
          end

          scope 'module'.to_sym => 'faalis' do
            # TODO: Add a dynamic solution for formats
            namespace :api, defaults: { format: :json } do
              namespace version do
                get 'permissions',      to: 'permissions#index'
                get 'permissions/user', to: 'permissions#user_permissions'
                resources :groups,      except: [:new]
                resources :users,       except: [:new]
                resource :profile,      except: [:new, :destroy]

                get 'logs', to: 'logs#index'
              end

            end
          end
        end
      end
    end
  end
end
