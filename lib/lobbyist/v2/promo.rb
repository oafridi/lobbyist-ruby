module Lobbyist
  module V2

    class Promo < Lobbyist::V2::Base

      attr_accessor :promo_id, :account_level_id, :account_class, :promo_code
      attr_accessor :promo_description, :is_current, :is_visible, :setup_fee
      attr_accessor :monthly_fee, :first_month_fee, :split_activation_fee, :days_available

    end

  end
end