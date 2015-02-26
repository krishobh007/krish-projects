class ViewMappings::ReviewsSetupsMapping
  def self.map_reviews_setup(hotel)
    {
      is_guest_reviews_on: hotel.settings.is_guest_reviews_on,
      number_of_reviews: hotel.settings.reviews_per_page.to_s,
      rating_limit: hotel.settings.rating_for_auto_publish.to_i.to_s
    }
  end

  def self.map_reviews_setup_post_params(params)
    {
      is_guest_reviews_on: params['is_guest_reviews_on'],
      reviews_per_page: params['number_of_reviews'],
      rating_for_auto_publish: params['rating_limit']
    }
  end
end
