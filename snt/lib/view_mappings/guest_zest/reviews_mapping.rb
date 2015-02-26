class ViewMappings::GuestZest::ReviewsMapping
  def self.map_review_details(review)
    if review.present? && (review.review_ratings.count > 0)
      average_rating = review.review_ratings.average(:rating)
    else
      average_rating = ''
    end
    data = {
      'id' => review.present? ? (review.id.to_s) : '',
      'first_name' => review.user.guest_detail ? review.user.guest_detail.first_name : '',
      'last_name' => review.user.guest_detail ?   review.user.guest_detail.last_name : '',
      'job_title' =>  review.user.guest_detail.job_title ?  review.user.guest_detail.job_title : '',
      'works_at' => review.user.guest_detail.works_at ? review.user.guest_detail.works_at : '',
      'avatar' => review.user.guest_detail.avatar ? review.user.guest_detail.avatar.url(:thumb) : '',
      'review_description' => review.present? ? review.description : '',
      'review_title' => review.present? ? review.title : '',
      'average_rating' => ('%.1f' % average_rating).to_s,
      'created_at' => review.present? ? map_created_at_time(review.created_at) : '',
      'created_time' => review.created_at.strftime('%s').to_i

    }
    data
  end

  def self.map_management_responses(review_response)
    {
      'first_name' => review_response.primary_guest.first_name,
      'last_name' =>  review_response.primary_guest.last_name,
      'avatar' => review_response.primary_guest.avatar.url(:thumb),
      'job_title' => review_response.primary_guest.job_title ? review_response.primary_guest.job_title : '',
      'works_at' => review_response.primary_guest.works_at ? review_response.primary_guest.works_at : '',
      'response' => review_response.comment,
      'created_at' => map_created_at_time(review_response.created_at)
    }
  end

  def self.map_created_at_time(created_at)
    time_difference = ((Time.now.utc - created_at) / 60)
    if (time_difference).to_i < 60
      mins = ((time_difference) % 60).to_i
      mins =  (mins >= 10) ? mins.to_s : "0#{mins}"
      created_at = ":#{mins} ago"
   elsif Time.now.utc.to_date == created_at.to_date
      hours = ((Time.now.utc - created_at) / (60 * 60)).to_i
      mins = (((Time.now.utc - created_at) / (60)) % 60).to_i
      mins =  (mins >= 10) ? mins.to_s : "0#{mins}"
      created_at = "#{hours.to_s}:#{mins} ago"
   else
     created_at = "#{created_at.strftime("%B").upcase.first(3).to_s} #{created_at.strftime("%d").to_s}"
   end
    created_at
  end

  def self.map_hotel_review_categories(category)
    {
      'category_id' => category.id.to_s,
      'category_name' => category.value.to_s
     }
  end
end
