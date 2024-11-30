.PHONY: install bundle_local remove_local

install:
	 @for dir in $$(find . -maxdepth 2 -type f \( -name Gemfile -o -name gems.rb \) -exec dirname {} \; | sort -u); do \
		if [ -d "$$dir" ]; then \
		 echo "Installing gems in $$dir"; \
		 cd $$dir && bundle check || bundle install && cd -; \
		fi; \
	 done

bundle_local:
	 bundle config set --local local.cells                           ./cells
	 bundle config set --local local.cells-erb                       ./cells-erb
	 bundle config set --local local.cells-haml                      ./cells-haml
	 bundle config set --local local.cells-hamlit                    ./cells-hamlit
	 bundle config set --local local.cells-rails                     ./cells-rails
	 bundle config set --local local.cells-slim                      ./cells-slim
	 bundle config set --local local.cells-template                  ./cells-template
	 bundle config set --local local.reform                          ./reform
	 bundle config set --local local.reform-rails                    ./reform-rails
	 bundle config set --local local.representable                   ./representable
	 bundle config set --local local.roar                            ./roar
	 bundle config set --local local.roar-jsonapi                    ./roar-jsonapi
	 bundle config set --local local.rspec-cells                     ./rspec-cells
	 bundle config set --local local.trailblazer                     ./trailblazer
	 bundle config set --local local.trailblazer-activity            ./trailblazer-activity
	 bundle config set --local local.trailblazer-activity-dsl-linear ./trailblazer-activity-dsl-linear
	 bundle config set --local local.trailblazer-cells               ./trailblazer-cells
	 bundle config set --local local.trailblazer-context             ./trailblazer-context
	 bundle config set --local local.trailblazer-developer           ./trailblazer-developer
	 bundle config set --local local.trailblazer-endpoint            ./trailblazer-endpoint
	 bundle config set --local local.trailblazer-finder              ./trailblazer-finder
	 bundle config set --local local.trailblazer-generator           ./trailblazer-generator
	 bundle config set --local local.trailblazer-loader              ./trailblazer-loader
	 bundle config set --local local.trailblazer-macro               ./trailblazer-macro
	 bundle config set --local local.trailblazer-macro-contract      ./trailblazer-macro-contract
	 bundle config set --local local.trailblazer-operation           ./trailblazer-operation
	 bundle config set --local local.trailblazer-rails               ./trailblazer-rails
	 bundle config set --local local.trailblazer-test                ./trailblazer-test

remove_local:
	 bundle config unset --local local.cells
	 bundle config unset --local local.cells-erb
	 bundle config unset --local local.cells-haml
	 bundle config unset --local local.cells-hamlit
	 bundle config unset --local local.cells-rails
	 bundle config unset --local local.cells-slim
	 bundle config unset --local local.cells-template
	 bundle config unset --local local.reform
	 bundle config unset --local local.reform-rails
	 bundle config unset --local local.representable
	 bundle config unset --local local.roar
	 bundle config unset --local local.roar-jsonapi
	 bundle config unset --local local.rspec-cells
	 bundle config unset --local local.trailblazer
	 bundle config unset --local local.trailblazer-activity
	 bundle config unset --local local.trailblazer-activity-dsl-linear
	 bundle config unset --local local.trailblazer-cells
	 bundle config unset --local local.trailblazer-context
	 bundle config unset --local local.trailblazer-developer
	 bundle config unset --local local.trailblazer-endpoint
	 bundle config unset --local local.trailblazer-finder
	 bundle config unset --local local.trailblazer-generator
	 bundle config unset --local local.trailblazer-loader
	 bundle config unset --local local.trailblazer-macro
	 bundle config unset --local local.trailblazer-macro-contract
	 bundle config unset --local local.trailblazer-operation
	 bundle config unset --local local.trailblazer-rails
	 bundle config unset --local local.trailblazer-test
