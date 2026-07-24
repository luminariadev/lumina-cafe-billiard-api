module Api
  module V1
    class ConfigsController < ApplicationController
      skip_before_action :authorize_request

      def index
        render json: {
          app_name: "Lumina Cafe Billiard",
          version: "1.0.0",
          billiard: {
            price_per_hour: 25_000,
            currency: "IDR",
            min_duration_hour: 1,
            max_duration_hour: 12
          },
          operating_hours: {
            open: "10:00",
            close: "23:00",
            timezone: "Asia/Jakarta"
          },
          payment: {
            methods: ["qris", "cash", "card"],
            qris_expiry_minutes: 10
          }
        }
      end
    end
  end
end
