# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

pin "@kurkle/color", to: "@kurkle--color.js" # @0.3.4
pin "date-fns" # @4.1.0

pin "chartkick", to: "chartkick.js"
pin "Chart.bundle", to: "Chart.bundle.js"
