class OwsMessage
  # Initialize the message value and the action attributes hashes

  def initialize
    @value = {
      :attributes! => {}
    }

    @action_attributes = {}
  end

  # Get the message value
  def value
    @value
  end

  # Get the action attributes
  def action_attributes
    @action_attributes
  end

  def append_confirmation_number(confirm_no)
    @value['ConfirmationNumber'] = confirm_no
    @value[:attributes!]['ConfirmationNumber'] = { type: 'INTERNAL' }
  end

  def append_resv_name_id(resv_name_id)
    @value['ResvNameId'] = resv_name_id
    @value[:attributes!]['ResvNameId'] = { type: 'INTERNAL', source: 'OPERA' }
  end

  # Method to assign resv name id
  def append_reservation_request(hotel_id, resv_name_id)
    # Add attributes for unique id
    @value['ReservationRequest'] = {
      'HotelReference' => '',
      :attributes! => { 'HotelReference' => hotel_reference_hash(hotel_id) },
      'ReservationID' => {
        'c:UniqueID' => resv_name_id,
        :attributes! => { 'c:UniqueID' => { type: 'EXTERNAL', source: 'RESV_NAME_ID' } }
      }
    }
  end

  def append_resort_reference(hotel_id)
    @value['Resort'] = ''
    @value[:attributes!]['Resort'] = hotel_reference_hash(hotel_id)
  end

  # Appends the credit card information for bill #1 (for checkin and checkout)
  def append_credit_card_info(hotel, card_info)
    is_encrypted = !(card_info[:is_encrypted] == false)
    if card_info[:mli_token].present?
      credit_card_info = {
        'CreditCard' => {
          'c:cardHolderName' => card_info[:card_name],
          'c:expirationDate' => card_info[:card_expiry]
        }
      }

      if hotel.settings.is_pms_tokenized
        credit_card_info['CreditCard']['c:VaultedCardData'] = ''
        credit_card_info['CreditCard'][:attributes!] = {
          'c:VaultedCardData' => { vaultedCardID: card_info[:mli_token], lastFourDigits: card_info[:mli_token].last(4) } }
      else
        card_number = (is_encrypted == true) ? Mli.new(hotel).get_credit_card_number(card_info[:mli_token])[:data] : card_info[:card_number]
        
        credit_card_info['CreditCard']['c:cardNumber'] = card_number
        credit_card_info['CreditCard']['c:Track2'] = card_info[:et2] unless is_encrypted
      end

      if card_info[:et2] && card_info[:ksn] && card_info[:pan] && is_encrypted
        credit_card_info['CreditCard']['c:EncryptedSwipe'] = {
          'c:Track2' => card_info[:et2],
          'c:KeySerialNumber' => card_info[:ksn],
          'c:MaskedPAN' => card_info[:pan]
        }
      end
      
      card_type = ""
      if (card_info[:credit_card_type]) && card_info[:credit_card_type].is_a?(Ref::CreditCardType)
        card_type = card_info[:credit_card_type].value
      else
        card_type = card_info[:credit_card_type]
      end
      
      mapped_card_type =  ExternalMapping.map_value(hotel, card_type, Setting.mapping_types[:credit_card_type])
      
      credit_card_info[:attributes!] = { 'CreditCard' => { cardType: mapped_card_type } }

      @value['CreditCardInfo'] = credit_card_info
    end
  end

  # append internal resv_name_id
  def append_resv_name_id_internal(resv_name_id)
    @value['ResvNameId'] = resv_name_id
    @value[:attributes!]['ResvNameId'] = { type: 'INTERNAL' }
  end

  # append hotel code and chain code
  def append_hotel_reference(hotel_id)
    @value['HotelReference'] = ''
    @value[:attributes!]['HotelReference'] = hotel_reference_hash(hotel_id)
  end

  def append_guest_id(guest_id)
    @value['NameID'] = guest_id
    @value[:attributes!]['NameID'] = { type: 'INTERNAL' }
  end

  def append_address_id(external_id)
    @value['AddressID'] = external_id
    @value[:attributes!]['AddressID'] = { type: 'INTERNAL' }
  end

  def append_credit_card_id(external_id)
    @value['CreditCardID'] = external_id
    @value[:attributes!]['CreditCardID'] = { type: 'INTERNAL' }
  end

  def append_email_id(external_id)
    @value['EmailID'] = external_id
    @value[:attributes!]['EmailID'] = { type: 'INTERNAL' }
  end

  def append_guest_card_id(external_id)
    @value['GuestCardID'] = external_id
    @value[:attributes!]['GuestCardID'] = { type: 'INTERNAL' }
  end

  def append_phone_id(external_id)
    @value['PhoneID'] = external_id
    @value[:attributes!]['PhoneID'] = { type: 'INTERNAL' }
  end

  def append_address(address_type, primary, street1, street2, city, state, postal_code, country, external_id = nil)
    @value['NameAddress'] = {
      'c:AddressLine' => [street1, street2],
      'c:cityName' => city,
      'c:stateProv' => state,
      'c:postalCode' => postal_code,
      'c:countryCode' => country
    }
    @value[:attributes!]['NameAddress'] = { addressType: address_type, primary: primary }
    @value[:attributes!]['NameAddress'][:operaId] = external_id if external_id
  end

  def append_credit_card(hotel_id, card_type, primary, name, mli_token, expiry_date, et2, etb, ksn, pan, external_id = nil)
    hotel = Hotel.find(hotel_id)

    @value['NameCreditCard'] = {
      'c:cardCode' => card_type,
      'c:cardHolderName' => name,
      'c:expirationDate' => expiry_date
    }

    if hotel.settings.is_pms_tokenized
      @value['NameCreditCard']['c:VaultedCardData'] = ''
      @value['NameCreditCard'][:attributes!] = {
        'c:VaultedCardData' => { vaultedCardID: mli_token, lastFourDigits: mli_token.last(4) }
      }
    else
      card_number = Mli.new(hotel).get_credit_card_number(mli_token)[:data]
      @value['NameCreditCard']['c:cardNumber'] = card_number
    end

    if et2 && ksn && pan
      @value['NameCreditCard']['c:EncryptedSwipe'] = {
        'c:Track2' => et2,
        'c:KeySerialNumber' => ksn,
        'c:MaskedPAN' => pan
      }
    end

    @value[:attributes!]['NameCreditCard'] = { cardType: 'CREDIT', primary: primary }
    @value[:attributes!]['NameCreditCard'][:operaId] = external_id if external_id
  end

  def append_email(email_type, primary, email, external_id = nil)
    @value['NameEmail'] = email
    @value[:attributes!]['NameEmail'] = { emailType: email_type, primary: primary }
    @value[:attributes!]['NameEmail'][:operaId] = external_id if external_id
  end

  def append_guest_card(membership_class, membership_type, membership_number, membership_level, member_name, expiry_date, start_date, external_id = nil)
    @value['NameMembership'] = {
      'c:membershipType' => membership_type,
      'c:membershipNumber' => membership_number,
      'c:memberName' => member_name
    }

    @value['NameMembership']['c:membershipLevel'] = membership_level if membership_level
    @value['NameMembership']['c:effectiveDate'] = start_date if start_date
    @value['NameMembership']['c:expirationDate'] = expiry_date if expiry_date

    @value[:attributes!]['NameMembership'] = { membershipClass: membership_class }
    @value[:attributes!]['NameMembership'][:operaId] = external_id if external_id
  end

  def append_phone(phone_type, primary, phone_number, external_id = nil)
    @value['NamePhone'] = { 'c:PhoneNumber' => phone_number }
    @value[:attributes!]['NamePhone'] = { phoneType: phone_type, primary: primary, phoneRole: 'PHONE' }
    @value[:attributes!]['NamePhone'][:operaId] = external_id if external_id
  end

  def append_name(first_name, last_name)
    @value['PersonName'] = {
      # 'c:nameTitle' => title, # No longer sending title back to OWS whether it changes or not
      'c:firstName' => first_name,
      'c:lastName' => last_name
    }
  end

  def append_gender(gender)
    @value['Gender'] = gender
  end

  def append_birthday(birthday)
    @value['Birthdate'] = birthday
  end

  def append_language(language)
    @value['Language'] = language
  end

  def append_nationality(nationality)
    @value['nationality'] = nationality
  end

  def append_passport(passport_number, country, expiry_date)
    @value['Passport'] = ''
    @value[:attributes!]['Passport'] = {
      documentType: 'PASSPORT', documentNumber: passport_number, expirationDate: expiry_date, countryOfIssue: country }
  end

  def append_preference(hotel_id, preference_type, preference_value)
    hotel = Hotel.find(hotel_id)

    @value['Preference'] = ''
    @value[:attributes!]['Preference'] = {
      resortCode: hotel.settings.pms_hotel_code, preferenceType: preference_type, preferenceValue: preference_value }
  end

  # add room type to the attributes
  def append_room_type(hotel_id, room_type_code)
    @action_attributes['RoomType'] = room_type_code
  end

  # add room no to the attributes
  def append_room_no(hotel_id, room_no)
    @action_attributes['RoomNumber'] = room_no
  end

  # add room no to the attributes
  def append_room_no_tag(room_no)
    @value['RoomNumber'] = room_no
  end

  # add key information to checkin message
  def append_key_info(key_track, no_of_keys, key_encoder)
    @action_attributes['GetKeyTrack'] = key_track
    @action_attributes['Keys'] = no_of_keys
    @action_attributes['KeyEncoder'] = key_encoder
  end

  # add regitration card to the attributes
  def append_reg_card(print_reg_card)
    @action_attributes['PrintRegistration'] = print_reg_card
  end

  # add approval code to the attributes
  def append_approval_code(approval_code)
    @action_attributes['ApprovalCode'] = approval_code
  end

  # add kiosk call to the attributes
  def append_kiosk_info(kiosk_call)
    @action_attributes['KioskCall'] = kiosk_call
  end

  # Add the room number that was requested
  def append_room_no_requested(room_no)
    @value['RoomNoRequested'] = room_no
  end

  # Add the account(charge code for late checkout charge OWS call)
  def append_account_no(hotel_id, account_no)
    @action_attributes['Account'] = account_no
  end

  # add wake up call details
  def append_wake_up_call_details(wake_up_call_data)
    @value['WakeUpCallDetails'] = {
      'FromDate'   => wake_up_call_data[:start_date],
      'ToDate'     => wake_up_call_data[:end_date],
      'WakeupTime' => wake_up_call_data[:time]
    }
  end

  # append wake up call action like add, update, delete
  def append_action_type(action)
    @value['ActionType'] = action
  end

  def append_credit_card_for_payment(hotel_id, card_type, name, mli_token, expiration_date, card_number)
    hotel = Hotel.find(hotel_id)

    @value['CreditCardInfo'] = {
      'CreditCard' => {
        'c:cardHolderName' => name,
        'c:expirationDate' => expiration_date,
        :attributes! => {}
      },
      :attributes! => { 'CreditCard' => { cardType: card_type } }
    }

    if hotel.settings.is_pms_tokenized
      @value['CreditCardInfo']['CreditCard']['c:VaultedCardData'] = ''
      @value['CreditCardInfo']['CreditCard'][:attributes!] = {
        'c:VaultedCardData' => { vaultedCardID: mli_token, lastFourDigits: mli_token.last(4) }
      }
    else
      @value['CreditCardInfo']['CreditCard']['c:cardNumber'] = card_number
    end
  end

  def append_posting_reservation_request(hotel_id, resv_name_id, post_attributes)
    @value['Posting'] = {
      'ReservationRequestBase' => {
        'HotelReference' => '',
        :attributes! => { 'HotelReference' => hotel_reference_hash(hotel_id) },
        'ReservationID' => {
          'c:UniqueID' => resv_name_id,
          :attributes! => { 'c:UniqueID' => { type: 'EXTERNAL', source: 'RESV_NAME_ID' } }
        }
      }
    }
    @value[:attributes!]['Posting'] = {
      PostDate: post_attributes[:post_date],
      Charge: post_attributes[:charge],
      StationId: post_attributes[:station_id],
      FolioViewNo: post_attributes[:folio_view_no]
    }
  end

  def append_availability_attributes(hotel_id, start_date, end_date, room_type, rate_code, promotion_code)
    @action_attributes['summaryOnly'] = 'false'
    @value['AvailRequestSegment'] = {
      'StayDateRange' => {
        'hc:StartDate' => start_date,
        'hc:EndDate'   => end_date
      },
      'RatePlanCandidates' => {
        'RatePlanCandidate' => '',
        :attributes! => { 'RatePlanCandidate' => { ratePlanCode: rate_code } }
      },
      'RoomStayCandidates' => {
        'RoomStayCandidate' => '',
        :attributes! => { 'RoomStayCandidate' => { roomTypeCode: room_type } }
      },
      'HotelSearchCriteria' => {
        'Criterion' => {
          'HotelRef' => '',
          :attributes! => { 'HotelRef' => hotel_reference_hash(hotel_id) }
        }
      }
    }

    # Add the promotion code to the rate plan candidate attributes if we have one
    @value['AvailRequestSegment']['RatePlanCandidates'][:attributes!]['RatePlanCandidate'][:promotionCode] = promotion_code if promotion_code

    @value[:attributes!]['AvailRequestSegment'] = {
       availReqType: 'Room', numberOfRooms: '1', roomOccupancy: '1', totalNumberOfGuests: '1', numberOfChildren: '0' }
  end

  # Creates the message based on the changed attributes on a booking
  def append_changed_booking_attributes(hotel_id, confirm_no, changed_attributes, remote_checkout)
    fetch_booking_reservation_service = OwsReservationService.new(hotel_id, false)
    fetch_booking_message = OwsMessage.new
    fetch_booking_message.append_confirmation_number(confirm_no)
    fetch_booking_message.append_hotel_reference(hotel_id)
    fetch_booking_message.append_use_vault(hotel_id)

    hotel = Hotel.find(hotel_id)

    fetch_booking_reservation_service.fetch_booking fetch_booking_message, '//FetchBookingResponse', lambda { |operation_response|

      @value['HotelReservation'] = {
        'r:UniqueIDList' => {
          'c:UniqueID' => confirm_no,
          :attributes! => {
            'c:UniqueID' => { 'type' => 'INTERNAL' }
          }
        },
        'r:RoomStays' => {
          'hc:RoomStay' => {
            'hc:HotelReference' => '',
            :attributes! => {
              'hc:HotelReference' => hotel_reference_hash(hotel_id)
            }
          }
        }
      }
      # if remote checkout flag needs to be changed
      @value[:attributes!] = { 'HotelReservation' => { 'remoteCo' => true } } if remote_checkout

      room_stay_tag = @value['HotelReservation']['r:RoomStays']['hc:RoomStay']
      hotel_reservation_fb_tag = operation_response.xpath('HotelReservation')
      # assign no post and fixed rate flag
      if hotel_reservation_fb_tag.xpath('@noPost').present?
        in_hash = @value[:attributes!]['HotelReservation']
        @value[:attributes!]['HotelReservation'] = merge_hash(in_hash, 'noPost', hotel_reservation_fb_tag.xpath('@noPost').text)
      end
      if hotel_reservation_fb_tag.xpath('@printRate').present?
        in_hash = @value[:attributes!]['HotelReservation']
        @value[:attributes!]['HotelReservation'] = merge_hash(in_hash, 'printRate', hotel_reservation_fb_tag.xpath('@printRate').text)
      end
      # assign room stay tag for fetch booking
      room_stay_fb_tag = hotel_reservation_fb_tag.xpath('RoomStays/RoomStay[1]')
      # if time span needs to be changed
      if changed_attributes[:time_span]
        room_stay_tag['hc:TimeSpan'] = {
          'hc:StartDate' => changed_attributes[:time_span][:arrival_date],
          'hc:EndDate' => changed_attributes[:time_span][:dep_date]
        }
      else
        room_stay_tag['hc:TimeSpan'] = {
          'hc:StartDate' => room_stay_fb_tag.xpath('TimeSpan/StartDate').text,
          'hc:EndDate' => room_stay_fb_tag.xpath('TimeSpan/EndDate').text
        }
      end

      # If room type is changed
      if changed_attributes[:room_type_id]
        room_type = RoomType.find(changed_attributes[:room_type_id])
        old_room_type = changed_attributes[:old_room_type_id].present? ? RoomType.find(changed_attributes[:old_room_type_id]) :  room_type

        room_stay_tag['hc:RoomTypes'] = {
          'hc:RoomType' => '',
          :attributes! => {
            'hc:RoomType' => { 'roomTypeCode' => room_type.room_type, 'roomToChargeCode' => old_room_type.room_type }
          }
        }
      else

        room_type_fb_tag = room_stay_fb_tag.xpath('RoomTypes[1]/RoomType').first

        room_stay_tag['hc:RoomTypes'] = {
          'hc:RoomType' => '',
          :attributes! => {
            'hc:RoomType' => {
              'roomTypeCode' => room_type_fb_tag.xpath('@roomTypeCode').text,
              'roomToChargeCode' => room_type_fb_tag.xpath('@roomToChargeCode').text
            }
          }
        }

      end

      # If rate needs to be fixed rate especially for upsell, rate code is not changed
      if changed_attributes[:rate_amount]
        rate = Rate.find(changed_attributes[:rate_id]) if changed_attributes[:rate_id]

        room_stay_tag['hc:RoomRates'] = {
          'hc:RoomRate' => {
            :attributes! => { 'hc:RoomRate' => { 'ratePlanCode' => rate.andand.rate_code } },
            'hc:Rates' => {
              'hc:Rate' => {
                'hc:Base' => changed_attributes[:rate_amount]
              }
            }
          }
        }
      else
        room_stay_tag['hc:RoomRates'] = {

          'hc:RoomRate' => room_stay_fb_tag.xpath('RoomRates/RoomRate').map do |room_rate_tag|
            effective_date = room_rate_tag.xpath('Rates/Rate/@effectiveDate').text
            if effective_date.present?
              rate_hash = {
                'hc:Rates' => {
                  'hc:Rate' => {
                    'hc:Base' => room_rate_tag.xpath('Rates/Rate/Base').text
                  },
                  :attributes! => { 'hc:Rate' => {
                    'effectiveDate' => effective_date,
                    'rateChangeIndicator' => room_rate_tag.xpath('Rates/Rate/@rateChangeIndicator').text }
                  }
                }
              }
            else
              rate_hash = {
                'hc:Rates' => {
                  'hc:Rate' => {
                    'hc:Base' => room_rate_tag.xpath('Rates/Rate/Base').text
                  }
                }
              }
            end
          end,
          :attributes! => { 'hc:RoomRate' => {
            'roomTypeCode' => room_stay_fb_tag.xpath('RoomRates/RoomRate/@roomTypeCode').map { |attr| attr.text },
            'ratePlanCode' =>  room_stay_fb_tag.xpath('RoomRates/RoomRate/@ratePlanCode').map { |attr| attr.text } }
          }
        }
      end

      # If rate id is changed
      if changed_attributes[:rate_id]
        rate = Rate.find(changed_attributes[:rate_id])

        room_stay_tag['hc:RatePlans'] = {
          'hc:RatePlan' => '',
          :attributes! => {
            'hc:RatePlan' => { 'ratePlanCode' => rate.rate_code }
          }
        }
      else
        rate_plan_fb_tag = room_stay_fb_tag.xpath('RoomRates[1]/RoomRate').first

        room_stay_tag['hc:RatePlans'] = {
          'hc:RatePlan' => '',
          :attributes! => {
            'hc:RatePlan' => {
              'roomTypeCode' => rate_plan_fb_tag.xpath('@roomTypeCode').text,
              'ratePlanCode' => rate_plan_fb_tag.xpath('@ratePlanCode').text
            }
          }
        }
      end

      # If room no changed
      if changed_attributes[:room_no]
        room_stay_tag['hc:RoomTypes']['hc:RoomType']   = {
          'hc:RoomNumber' => changed_attributes[:room_no]
        }
      else
        room_type_fb_tag = room_stay_fb_tag.xpath('RoomTypes[1]/RoomType').first

        room_stay_tag['hc:RoomTypes']['hc:RoomType']   = {
          'hc:RoomNumber' => room_type_fb_tag.xpath('RoomNumber').text
        }
      end

      # If notes on reservation has changed or added then send append notes
      if changed_attributes[:notes]

        changed_attributes[:notes].each do |note|
          room_stay_tag['hc:Comments']['hc:Comment']['hc:Text'] << note
        end
      else
        if room_stay_fb_tag.xpath('Comments').present?
          room_stay_fb_tag.xpath('Comments/Comment').each do |comment_tag|
            room_stay_tag['hc:Comments'] = {
              'hc:Comment' => {
                'hc:Text' => comment_tag.xpath('Text').text
              }
            }
          end
        end
      end

      # If preferences information has changed or added then send preferences change
      if changed_attributes[:preferences]

        changed_attributes[:preferences].each do |preference|
          mapped_preference_type = ExternalMapping.map_value(hotel, preference[:preference_type], Setting.mapping_types[:preference_type])
          mapped_preference_value = ExternalMapping.map_value(hotel, preference[:preference_value], Setting.mapping_types[:preference_value])

          @value['HotelReservation']['r:Preferences'] = {
            'n:Preference' => '',
            :attributes! => {
              'n:Preference' => {
                'preferenceType' => mapped_preference_type,
                'otherPreferenceType' => 'RESERVATION',
                'preferenceValue' => mapped_preference_value
              }
            }
          }
        end
      else
        if hotel_reservation_fb_tag.xpath('Preferences').present?
          hotel_reservation_fb_tag.xpath('Preferences/Preference[@otherPreferenceType="RESERVATION"]').each do |preference_tag|
            @value['HotelReservation']['r:Preferences'] = {
              'n:Preference' => '',
              :attributes! => {
                'n:Preference' => {
                  'preferenceType' => preference_tag.xpath('@preferenceType').text,
                  'otherPreferenceType' => 'RESERVATION',
                  'preferenceValue' => preference_tag.xpath('@preferenceValue').text
                }
              }
            }
          end
        end
      end

      res_guest_tag = @value['HotelReservation']['ResGuests'] = {
        'ResGuest' => ''
      }

      # If membership information has changed or added on reservation then send membership change
      if changed_attributes[:memberships]
        changed_attributes[:memberships].each do |membership|
          mapped_membership_class = ExternalMapping.map_value(hotel, membership[:membership_class], Setting.mapping_types[:membership_class])
          mapped_membership_type = ExternalMapping.map_value(hotel, membership[:membership_type], Setting.mapping_types[:membership_type])
          #
          res_guest_tag['Profiles'] = {
            'Profile' => {
              'Memberships' => {
                'NameMembership' => {
                  'c:membershipType' => mapped_membership_type,
                  'c:membershipNumber' => membership[:membership_number],
                  'c:memberName' => membership[:member_name],
                  'c:membershipLevel' => membership[:membership_level],
                  'c:effectiveDate' => membership[:start_date],
                  'c:expirationDate' => membership[:expiry_date]
                },
                :attributes! => {
                  'NameMembership' => {
                    membershipClass: mapped_membership_class,
                    operaId: membership[:external_id],
                    usedInReservation: true
                  }
                }
              }
            }
          }
        end
      else
        hotel_reservation_fb_tag.xpath('ResGuests/ResGuest[1]/Profiles[1]/Profile[1]/Memberships[1]/NameMembership').each do |profile_tag|
          res_guest_tag['Profiles'] = {
            'Profile' => {
              'Memberships' => {
                'NameMembership' => {
                  'c:membershipType' => profile_tag.xpath('membershipType').text,
                  'c:membershipNumber' => profile_tag.xpath('membershipNumber').text,
                  'c:memberName' => profile_tag.xpath('memberName').text,
                  'c:membershipLevel' => profile_tag.xpath('membershipLevel').text,
                  'c:effectiveDate' => profile_tag.xpath('effectiveDate').text,
                  'c:expirationDate' => profile_tag.xpath('expirationDate').text
                },
                :attributes! => {
                  'NameMembership' => {
                    membershipClass: profile_tag.xpath('@membershipClass').text,
                    operaId: profile_tag.xpath('@operaId').text
                  }
                }
              }
            }
          }
        end
      end
      # Check for Specials
      if room_stay_fb_tag.xpath('SpecialRequests').present?
        room_stay_fb_tag.xpath('SpecialRequests/SpecialRequest').each do |special_tag|
          room_stay_tag['hc:SpecialRequests'] = {
            'hc:SpecialRequest' => '',
            :attributes! => { 'hc:SpecialRequest' => { requestCode: special_tag.xpath('@requestCode').text } }
          }
        end
      end
      # Add arrival to modify booking
      if hotel_reservation_fb_tag.xpath('ResGuests/ResGuest[1]/@arrivalTime').present?
        @value['HotelReservation']['ResGuests'][:attributes!] = { 'ResGuest' => {
          arrivalTime: hotel_reservation_fb_tag.xpath('ResGuests/ResGuest[1]/@arrivalTime').text }
        }
      end
    }
  end

  def append_lov_query(hotel_id, identifier)
    hotel = Hotel.find(hotel_id)

    @value['LovQuery2'] = {
      'LovIdentifier' => identifier,
      'LovQueryQualifier' => [hotel.settings.pms_channel_code, hotel.settings.pms_hotel_code],
      :attributes! => {
        'LovQueryQualifier' => { qualifierType: %w(HOST RESORT) }
      }
    }
  end

  def append_update_payment_attributes(hotel_id, external_id, card_info)
    hotel = Hotel.find(hotel_id)

    append_reservation_request(hotel_id, external_id)
     
    card_type = ""
    if (card_info[:credit_card_type]) && card_info[:credit_card_type].is_a?(Ref::CreditCardType)
      card_type = card_info[:credit_card_type].value
    else
      card_type = card_info[:credit_card_type]
    end
    
    mapped_card_type = ExternalMapping.map_value(hotel, card_type, Setting.mapping_types[:credit_card_type])
    
    @value[:attributes!]['MethodOfPayment'] = { 'FolioViewNo' => card_info[:bill_number] }
    @value['MethodOfPayment'] = {
      'CreditCard' => {
        'c:cardHolderName' => card_info[:card_name],
        'c:expirationDate' => card_info[:card_expiry]
      },
      :attributes! => { 'CreditCard' => { 'cardType' => mapped_card_type } }
    }

    if hotel.settings.is_pms_tokenized
      @value['MethodOfPayment']['CreditCard']['c:VaultedCardData'] = ''
      @value['MethodOfPayment']['CreditCard'][:attributes!] = {
        'c:VaultedCardData' => { vaultedCardID: card_info[:mli_token], lastFourDigits: card_info[:mli_token].last(4) }
      }
    else
      card_number = Mli.new(hotel).get_credit_card_number(card_info[:mli_token])[:data]
      @value['MethodOfPayment']['CreditCard']['c:cardNumber'] = card_number
    end

    if card_info[:et2] && card_info[:ksn] && card_info[:pan]
      @value['MethodOfPayment']['CreditCard']['c:EncryptedSwipe'] = {
        'c:Track2' => card_info[:et2],
        'c:KeySerialNumber' => card_info[:ksn],
        'c:MaskedPAN' => card_info[:pan]
      }
    end
  end

  # append comments/notes to reservation
  def append_comment_attributes(hotel_id, confirm_no, action_type, comments)
    append_hotel_reference(hotel_id)
    append_confirmation_number(confirm_no)

    @value['ActionType'] = action_type
    @value['RequestType'] = 'COMMENTS'
    @value['GuestRequests'] = {
      'hc:Comments' => {
        'hc:Comment' => comments.map do |eachComment|
          if eachComment[:description].present?
            comment_hash = { 'hc:Text' => eachComment[:description] }
          end
          if eachComment[:external_id].present?
            comment_hash['hc:CommentId'] = eachComment[:external_id]
          end

          comment_hash

        end,
        :attributes! => { 'hc:Comment' => { 'guestViewable' => false } }
      }
    }
  end

  # append alerts to reservation
  def append_alert_attributes(hotel_id, confirm_no, action_type, alert_area, alert_code, alert_desc)
    append_hotel_reference(hotel_id)
    append_confirmation_number(confirm_no)

    @value['ActionType'] = action_type
    @value['RequestType'] = 'ALERTS'
    @value['GuestRequests'] = {
      'hc:Alerts' => {
        'hc:ReservationAlerts' => {
          'hc:Code' => alert_code,
          'hc:Area' => alert_area,
          'hc:Description' => {
            'hc:Text' => alert_desc
          }
        },
        :attributes! => { 'hc:ReservationAlerts' => { screenNotification: true, displaySequence: 1 } }
      }
    }
  end

  #
  def append_posting_reservation_request_late_checkout(hotel_id, resv_name_id, post_attributes)
    @value['Posting'] = {
      'ReservationRequestBase' => {
        'HotelReference' => '',
        :attributes! => { 'HotelReference' => hotel_reference_hash(hotel_id) },
        'ReservationID' => {
          'c:UniqueID' => resv_name_id,
          :attributes! => { 'c:UniqueID' => { type: 'EXTERNAL', source: 'RESV_NAME_ID' } }
        }
      }
    }
    @value[:attributes!]['Posting'] = {
      PostDate: post_attributes[:posting_date],
      Charge: post_attributes[:charge],
      PostingTime: post_attributes[:posting_time],
      LongInfo: post_attributes[:long_info],
      FolioViewNo: post_attributes[:bill_no]
    }
  end

  # Add the email folio-For sending invoice emails
  def append_email_folio
    @action_attributes['EmailFolio'] = 1 # Should be 1, not true, according to Micros
    @action_attributes['overrideEmailPrivacy'] = true
  end

  def append_no_post(no_post)
    @action_attributes['NoPost'] = no_post
  end

  # Send request for start_date, end_date and guest_count & child_count
  def append_fetch_calendar_attributes(hotel_id, start_date, end_date)
    @value = {
      'wsdl:HotelReference' => '',
      :attributes! => { 'wsdl:HotelReference' => hotel_reference_hash(hotel_id) },
      'wsdl:StayDateRange' => {
        'hc:StartDate' => start_date,
        'hc:EndDate'   => end_date
      }
    }
  end

  def append_fetch_calendar_room_type_attribute(room_type, rate_plan_code)
    @value ['wsdl:RoomTypeCode'] = room_type if room_type
    @value ['wsdl:RatePlanCode'] = rate_plan_code if rate_plan_code
  end

  def append_fetch_calendar_guest_count(adult_count, child_count)
    adult_count = adult_count > 0 ? adult_count : 0
    child_count  = child_count > 0 ? child_count : 0

    @value ['GuestCount'] = {
      'hc:GuestCount' => ['', ''],
      :attributes! =>  {
        'hc:GuestCount' => { ageQualifyingCode: %w(ADULT CHILD), count: [adult_count , child_count] }
      }
    }
  end

  # Instruct the request to use a vaulted credit card (MLI token)
  def append_use_vault(hotel_id)
    hotel = Hotel.find(hotel_id)
    @action_attributes['canHandleVaultedCreditCard'] = hotel.settings.is_pms_tokenized
  end

  # HK staff Changing the room status from Dirty - Clean for a specific Room number
  def append_room_status(hotel_id, room_status, room_no)
    @value = {
      'wsdl:HotelReference' => '',
      :attributes! => { 'wsdl:HotelReference' => hotel_reference_hash(hotel_id) },
      'RoomNumber' => room_no,
      'RoomStatus' => room_status }
  end

  # HK staff Changing the room status from Dirty - Clean for a specific Room number
  def append_privacy_option(option_type, option_value)
    @value['Privacy'] = {
      'n:PrivacyOption' => '',
      :attributes! =>  {
        'n:PrivacyOption' => { OptionType: option_type, OptionValue: option_value }
      }
    }

    @value[:attributes!]['NameID'] = { type: 'INTERNAL' }
  end

  # FolioTransactionTransfer - Transfer charge from one one bill window to another
  def append_folio_transaction_transfer_attributes(options)
    @value['FromFolioViewNo'] = options[:from_bill]
    @value['ToFolioViewNo'] = options[:to_bill]
    @value['TransactionNo'] = options[:transaction_id]
  end

  def append_smartband_key_data(key_2_track)
    @value['KeyTrack'] = ''
    @value[:attributes!]['KeyTrack'] = { Key2Track: key_2_track }
  end

  def append_reservation_id(resv_name_id)
    @value['ReservationID'] = {
      'c:UniqueID' => resv_name_id,
      :attributes! => { 'c:UniqueID' => { type: 'EXTERNAL', source: 'RESV_NAME_ID' } }
    }
  end

  # Private methods

  private

  def hotel_reference_hash(hotel_id)
    hotel = Hotel.find(hotel_id)
    { hotelCode: hotel.settings.pms_hotel_code, chainCode: hotel.settings.pms_chain_code }
  end

  # Merge 2 hashes is hash is already existing else assign key value to hash and return
  def merge_hash(in_hash, in_key, in_value)
    if in_hash.present?
      out_hash = in_hash.merge!(in_key => in_value)
    else
      out_hash = { in_key => in_value }
    end
    out_hash
  end
end
