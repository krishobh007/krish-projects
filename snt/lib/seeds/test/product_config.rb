module SeedTestProductConfig
  def create_test_product_config
    hotel = Hotel.find_by_code('DOZERQA')
    chain = hotel.hotel_chain

    ################ HOTEL SETTINGS #################

    # PMS SETTINGS
    hotel.settings.pms_access_url ||= 'http://operaserver.stayntouch.com:8000/OWS_WS_51'
    hotel.settings.pms_channel_code ||= 'SNT'
    hotel.settings.pms_user_name ||= 'OEDS$OWS'
    hotel.settings.pms_user_pwd ||= hotel.hotel_chain.encrypt_pswd('$$$OEDS$OWS$$')
    hotel.settings.pms_hotel_code ||= 'DOZERQA'
    hotel.settings.pms_chain_code ||= 'CHA'

    hotel.settings.is_pms_tokenized = true if hotel.settings.is_pms_tokenized.nil?
    hotel.settings.use_kiosk_entity_id_for_fetch_booking = false if hotel.settings.use_kiosk_entity_id_for_fetch_booking.nil?
    hotel.settings.use_snt_entity_id_for_checkin_checkout = false if hotel.settings.use_snt_entity_id_for_checkin_checkout.nil?

    # KEY SETTINGS
    hotel.settings.key_access_url ||= 'winserver.stayntouch.com'
    hotel.settings.key_access_port ||= '4001'

    # MLI SETTINGS
    hotel.settings.mli_hotel_code ||= 'DOZERQA'
    hotel.settings.mli_chain_code ||= 'CHA'
    hotel.settings.mli_pem_certificate ||= "Bag Attributes\n    localKeyID: 32 C7 75 94 7D 97 3D 2C 88 73 2B 06 84 2D B4 43 5B F1 39 16 \n    friendlyName: Secure MerchantLink Certificate\nsubject=/C=US/ST=MD/L=Silver Spring/O=CHA/OU=DOZERQA/CN=www.stayntouch.com\nissuer=/emailAddress=edresner@merchantlink.com/C=US/O=MerchantLink LLC/OU=MerchantLink Security/CN=MerchantLink UAT Certificate Authority\n-----BEGIN CERTIFICATE-----\nMIIFrzCCBJegAwIBAgIRANTar9fao6v3OitZRSb24wcwDQYJKoZIhvcNAQEFBQAw\ngaMxKDAmBgkqhkiG9w0BCQEWGWVkcmVzbmVyQG1lcmNoYW50bGluay5jb20xCzAJ\nBgNVBAYTAlVTMRkwFwYDVQQKExBNZXJjaGFudExpbmsgTExDMR4wHAYDVQQLExVN\nZXJjaGFudExpbmsgU2VjdXJpdHkxLzAtBgNVBAMTJk1lcmNoYW50TGluayBVQVQg\nQ2VydGlmaWNhdGUgQXV0aG9yaXR5MB4XDTE0MDEwNjE5MTU0NloXDTE5MTIwODE4\nMDM0OVowbzELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAk1EMRYwFAYDVQQHEw1TaWx2\nZXIgU3ByaW5nMQwwCgYDVQQKEwNDSEExEDAOBgNVBAsTB0RPWkVSUUExGzAZBgNV\nBAMTEnd3dy5zdGF5bnRvdWNoLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC\nAQoCggEBALubO7XsIDe4BqChh/ni0IVe4tY9rW6t7rAO5eHkJBtOtC8auqGwR+Ah\nNCthK4Cb4RkOUBdTiyUR3RlZgYYAF7vdX4t5jrnwdWOHPsNgyTCsbxO+pyK/8BA+\nM66/3+I9+z3iOpGJfXXpKTUeSA4cmXLJJ/754O3mfTEKdrv6XpQEps7XBChOsvhX\n6Hq0PPOr1IHdkWJk3A4vPYBCna1eLxDMAhEeVB/AmrrDITcAY6pDj33GNQmM8ptc\n7yyd41Q1iOvY2RKNk4xOLp0OyaxXtuv4kDzBAeZNE0WNti9/inj3qXzb/LvUGTpy\nh45LdMTS2vHGCY+B3+5BPsxxND/llyECAwEAAaOCAg8wggILMB8GA1UdIwQYMBaA\nFCJ62oOtFuJgfcCCF3afwSy83UHAMBMGA1UdJQQMMAoGCCsGAQUFBwMCMA4GA1Ud\nDwEB/wQEAwIE8DAkBgNVHREEHTAbgRlub2NzdGFmZkBtZXJjaGFudGxpbmsuY29t\nMIG9BgNVHR8EgbUwgbIwga+ggayggamkgaYwgaMxKDAmBgkqhkiG9w0BCQEWGWVk\ncmVzbmVyQG1lcmNoYW50bGluay5jb20xCzAJBgNVBAYTAlVTMRkwFwYDVQQKExBN\nZXJjaGFudExpbmsgTExDMR4wHAYDVQQLExVNZXJjaGFudExpbmsgU2VjdXJpdHkx\nLzAtBgNVBAMTJk1lcmNoYW50TGluayBVQVQgQ2VydGlmaWNhdGUgQXV0aG9yaXR5\nMIG9BgNVHS4EgbUwgbIwga+ggayggamkgaYwgaMxKDAmBgkqhkiG9w0BCQEWGWVk\ncmVzbmVyQG1lcmNoYW50bGluay5jb20xCzAJBgNVBAYTAlVTMRkwFwYDVQQKExBN\nZXJjaGFudExpbmsgTExDMR4wHAYDVQQLExVNZXJjaGFudExpbmsgU2VjdXJpdHkx\nLzAtBgNVBAMTJk1lcmNoYW50TGluayBVQVQgQ2VydGlmaWNhdGUgQXV0aG9yaXR5\nMB0GA1UdDgQWBBSfB1zn1uy/woqH/AteY78YylFxhjANBgkqhkiG9w0BAQUFAAOC\nAQEAY3aykALZgtT9Zy3fJ2wiVXuhtRrueU+h+vVAy0ZPbvx+pkcCCvcZ9ESIoFYn\nlBbWg5NVaawZnf6dfc62bsfyVgiBPUrBF7Bkyt2Ihp8qG3fUNg1eFg0u/8X6nSAN\n0gOufoEhpZT5i0NuQVVlYwYUa/l0RxqXoKwC9g5yxAPcyXIj/ECGvRX7YKGJcYfw\nm187Bca66K4MgKq4GW6gqoWONzpFyiLTzw4TBKun7ehj1XeJl65+5ParVRsoJeBO\nWJsBiKN3C24NhzTZ4d4hJyo3vwRAkcZ+RSCvfFKZbzrdsWcdbMkX2D3u4cEkUanD\nM2TAzoSe1iYhJBdixjVibW1z3A==\n-----END CERTIFICATE-----\nBag Attributes: <No Attributes>\nsubject=/emailAddress=edresner@merchantlink.com/C=US/O=MerchantLink LLC/OU=MerchantLink Security/CN=MerchantLink UAT Certificate Authority\nissuer=/emailAddress=edresner@merchantlink.com/C=US/O=MerchantLink LLC/OU=MerchantLink Security/CN=MerchantLink UAT Certificate Authority\n-----BEGIN CERTIFICATE-----\nMIIENTCCAx2gAwIBAgIQdoy3f7WNqjc/p0PYU5paQjANBgkqhkiG9w0BAQUFADCB\nozEoMCYGCSqGSIb3DQEJARYZZWRyZXNuZXJAbWVyY2hhbnRsaW5rLmNvbTELMAkG\nA1UEBhMCVVMxGTAXBgNVBAoTEE1lcmNoYW50TGluayBMTEMxHjAcBgNVBAsTFU1l\ncmNoYW50TGluayBTZWN1cml0eTEvMC0GA1UEAxMmTWVyY2hhbnRMaW5rIFVBVCBD\nZXJ0aWZpY2F0ZSBBdXRob3JpdHkwHhcNMDkxMjA5MTgwMzQ5WhcNMTkxMjA5MTgw\nMzQ5WjCBozEoMCYGCSqGSIb3DQEJARYZZWRyZXNuZXJAbWVyY2hhbnRsaW5rLmNv\nbTELMAkGA1UEBhMCVVMxGTAXBgNVBAoTEE1lcmNoYW50TGluayBMTEMxHjAcBgNV\nBAsTFU1lcmNoYW50TGluayBTZWN1cml0eTEvMC0GA1UEAxMmTWVyY2hhbnRMaW5r\nIFVBVCBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkwggEiMA0GCSqGSIb3DQEBAQUAA4IB\nDwAwggEKAoIBAQCkZ8T5SQksPrwjI212XNysVmLQMShouxyWSWnunnFADYqepvS4\n9zwpNIsQD/iM1OzDwMYMJn0e4j1vHvb1/tqt1ZlCTQhlShoOOcjZSByL6ViBD0Js\nGLENR2W7RBpdyoUIgKmKyzAbpPbogLh7n0gBEt03l5tttR29QhhVdBWeIzRPzWSc\n3FpKPswjGGJ6fgsklkeOlUvLSEizclrAjCSstbGUItU5ScYKZvVMsDI37UCrTxA+\nutfQTeWeObHn7a6iHHClTYTu3aeQKH5b9de1eyYaJnCLAXD+u6EfmS7siqfNwBCB\nfsvoTtlJ3opTqk4YF2ZBrigHo7Io0AyqpsnBAgMBAAGjYzBhMA4GA1UdDwEB/wQE\nAwIBhjAPBgNVHRMECDAGAQH/AgEAMB0GA1UdDgQWBBQietqDrRbiYH3Aghd2n8Es\nvN1BwDAfBgNVHSMEGDAWgBQietqDrRbiYH3Aghd2n8EsvN1BwDANBgkqhkiG9w0B\nAQUFAAOCAQEAaBvsVK9NzXigYXw1rqwSjvkdOuXwwX7+jj+O8bbSxqBLQS4eJAFN\n6OH/LDZWF/kmIKeIY2YyR+xis0weZ/bPhy7fJkmNtMfjhCl9Z2kJaSP2FQnOdKD4\njeEgMKrCxepId96uHjWHuo+957keY12v0uTBb2xtIWEgRdqboenleH3XZBZOdPIB\nBrJnHWPj6rOEIPBKSZeBisYyCSiBzRpfFtt4rejkLXl4jKh8a9bZAuyhSMo8yzhQ\nuDNDEjsSSKBx9NyvR9qXOs6501TuZe5pLKghQ6U2D9PRvM+B15bRtMNf1CYqm251\n8D+zoq2s0hqGZqJKm0N0WRZPJzcxhSPtDQ==\n-----END CERTIFICATE-----\nBag Attributes\n    localKeyID: 32 C7 75 94 7D 97 3D 2C 88 73 2B 06 84 2D B4 43 5B F1 39 16 \n    friendlyName: Secure MerchantLink Certificate\nKey Attributes: <No Attributes>\n-----BEGIN ENCRYPTED PRIVATE KEY-----\nMIIFDjBABgkqhkiG9w0BBQ0wMzAbBgkqhkiG9w0BBQwwDgQINtOtUubDtAoCAggA\nMBQGCCqGSIb3DQMHBAjmctHO401XeQSCBMi7sD7ELIYPkZn9CBfgCwiCQw67sTti\nvenwKaSfw1evdzIOEmQE5QAD5VeqKlysMncHdFs5NOXVwin0iB9qswmtktSMpf1a\niTGSolJGn4ux+WUbOU4DDhd2C4kF89GqFfxWTQ3hTLrDIUGCqp0D3Kw4BJGJSafH\nop9X7jfbGi9a4Yzm72+T0L2URWKlPs2YyMM5artResX+O7og6VKDiHwHrHku9pi6\nHErSY2wuH9zsKzoRFLkx4Q6tEqfH4PnT8S3MGs2bfnyHrdt0tnA0NvzOtBuBxgvU\nR+ITTZF+iRnL3X0WJzX6JvGQYtahtU3TYiKRwvu4fRztK39GFRE3bRCZBfMW4Gkf\npgW80Yh/RY8fbi4gc8+qRxNok0PdM5itUdoWrkAveGz2UUdlAUnqrOudKl/isHDO\nOogi4pdlESw977qzy79zPVZ151XEjU5My//7+ZrIip2DW0tG7zT7ZaH1qQmyv5GF\ncY06zKO1P318LRXCDXZNuofVIQCoLGMkgB/Uc7p/TtGDloDQOgu7JZIm96MOQmdC\nVwnhtHSSWxQHp3efsm3Yt+JbY6d1U9B0qyaxgtQiQc7TzHjiH04kFslWsK37GLqE\n6Ufqf61e9R43w0MN/yuGHhj9OtCO9i4twqTwaA3oIn/+j6DsTGgKqbSgRoqA/isA\nuNMjQ8FM7Ufl5GxHCRw0/cN4k2wWuzeVUfF51rmIKSMh8IbtIuxqXTOEcAgqsgkS\nRedlvoas+3XRapBFGfiEtWmtZhuP9rZV2ucKwcUQ5W/aCimghNj5z7LP0yPDynBO\nnvl9KvamRGKEdCbgSF7a34gWUGp7uvEYPZJvg5CMQv0RBCITixF6DzDW0sB4m1XJ\nsyd1vTjD+UXa6UdwzHYBMhSMGPoFDUjDU+P29VGYGAX/N1YC91azsnAvHmsw4ZGr\nXSdw4P2Bg+Sp8umJ9nu5MWTh4YKJcDrfRdoFcSOyshhAm6NqcJTOaiUSA15V1B/l\nUHWthVlMTJK5JZQTEVMRjeExMAdt8CabGd6AiKHslOu/lKQUm3CojAq1rZFQEj/N\nYkLOtIP6TARyC0tzio70mCTFjOJhkCYrC8h7RnH3Q5mNi0SgjKUjSQtFQLPliKQ0\n57Ui64iWN4aBZq5JCczumBClGyunve+4sbP1tL8atjVkOTvzrjb3mUHPw2fBl/Uz\nCqiwDEA/1kdpLdfghMsrwLOFyQ7VUHP38/A431mNsHAeUNaKzu+0BelSeEL8CA9b\nvfuSt6PFhavzdc2tQTww329Rz79PUECLjsC7srTv2nLmLPp6J4o+yUFsI2cF+5eL\nWQ+dnWKww82TKsXGA0W/9KFhGWJvzx/lhbRdWOeIJ2rDjr7eY2FB7YewPb8mJk9+\nJBXKlZivmPyGUAHDlY/YnyUBE+SWJyXBljhU5ytAiP1pLK5Oo1JrmKWen8XrDvCj\nKgEV5oJtZH9qVSdpxA1Dz8b9VsHRiY2/QyWsro6gAd342CD0vL40lTkbzqvdohJh\ncEoUTASM3Crl3b7IaO4XQZ/rWuVgOz6I4WrhyL4GFcxoATrmBBpQlbgwI/kRwcxI\njmVoULX4m57Cwnhr0AA8UtG4ZoMoAjcRWssrRCl1rFOMShHZb+1RynY53aVuUf2d\nzK0=\n-----END ENCRYPTED PRIVATE KEY-----\n"
    hotel.settings.mli_merchant_id ||= "TESTSTAYNTOUCH01"
    hotel.settings.mli_api_key ||= hotel.hotel_chain.encrypt_pswd("ff6459ff66637840db0c16799eaa8a00")
    hotel.settings.mli_site_code ||= "ETEST"
    # CHECKIN SETTINGS
    hotel.settings.checkin_require_cc_for_email = true if hotel.settings.checkin_require_cc_for_email.nil?

    # CHECKOUT SETTINGS
    hotel.settings.checkout_email_alert_time ||= Time.parse('08:00')
    hotel.settings.checkout_require_cc_for_email = true if hotel.settings.checkout_require_cc_for_email.nil?
    hotel.settings.include_cash_reservations = true if hotel.settings.include_cash_reservations.nil?

    # ROOM KEY DELIVERY
    hotel.settings.room_key_delivery_for_rover_check_in ||= 'qr_code_tablet'
    hotel.settings.room_key_delivery_for_guestzest_check_in ||= 'smartphone'
    hotel.settings.require_signature_at ||= Setting.signature_display[:checkin]

    # LATE CHECKOUT SETTINGS
    hotel.settings.late_checkout_is_on = true if hotel.settings.late_checkout_is_on.nil?
    hotel.settings.late_checkout_is_pre_assigned_rooms_excluded = true if hotel.settings.late_checkout_is_pre_assigned_rooms_excluded.nil?
    hotel.settings.late_checkout_num_allowed ||= 200
    hotel.settings.late_checkout_upsell_alert_time ||= Time.parse('08:00')

    # UPSELL SETTINGS
    hotel.settings.upsell_is_on = true if hotel.settings.upsell_is_on.nil?
    hotel.settings.upsell_is_one_night_only = true if hotel.settings.upsell_is_one_night_only.nil?
    hotel.settings.upsell_is_force = true if hotel.settings.upsell_is_force.nil?
    hotel.settings.upsell_total_target_amount ||= 1000
    hotel.settings.upsell_total_target_rooms ||= 200

    # STAFF_CHECKIN_ALERT_SETTINGS

    hotel.settings.web_checkin_staff_alert_enabled = true
    hotel.settings.web_checkin_staff_alert_to = Setting.alert_staff_options[:ALL]

    # RESERVATION SETTINGS
    hotel.settings.use_markets = false if  hotel.settings.use_markets.nil?
    hotel.settings.use_sources = false if  hotel.settings.use_sources.nil?
    hotel.settings.use_origins = false if  hotel.settings.use_origins.nil?
    hotel.settings.use_recommended_rate_display ||= true

    # ICARE SETTINGS
    hotel.settings.icare_url ||= 'https://eval2.myicard.net:9443/ws/services/StoredValueService'
    hotel.settings.icare_username ||= 'SNT_0001'
    hotel.settings.icare_password ||= 'micros'
    hotel.settings.icare_account_preamble ||= '9963'
    hotel.settings.icare_account_length ||= 16
    hotel.settings.icare_save_customer_info ||= true if hotel.settings.icare_save_customer_info.nil?

    ################ CHAIN SETTINGS #################

    # SFTP SETTINGS
    chain.settings.sftp_location ||= 'dev-tools.stayntouch.com'
    chain.settings.sftp_port ||= '22'
    chain.settings.sftp_user ||= 'pmsftp'
    chain.settings.sftp_password ||= chain.encrypt_pswd('PmsFtp!2013')
    chain.settings.sftp_respath ||= '/home/pmsftp/reservations'

    chain.settings.privacy_policy ||= Setting.privacy_policy

    chain.settings.theme ||= 'guestweb'

    # CREDIT CARD SETTINGS
    hotel.settings.is_allow_manual_cc_entry = Setting.defaults[:is_allow_manual_cc] if hotel.settings.is_allow_manual_cc_entry.nil?
    # KIOSK PRINTER SETTIGNS (Keeping the template in hotel settings for doing POC as part of CICO-11666)

    hotel.settings.checkin_bill_template = "\x1b\x1d\x61\x0 $bill_date_time$ \n\x1b\x1d\x61\x1\x1B\x1C\x70" + "$logo_index$" + "\x0\n\x1b\x1d\x61\x0YOUR CABIN NUMBER IS\n\n\x6\x9\x1b\x69\x1\x1$room_number$ \n\n" +
                                           "\x1b\x69\x0\x0" + "Date of departure : $departure_date$ \nOur standard check out is $normal_checkout_time$\n\n" +
                                           "YOTEL is 100% non-smoking, including all of our public spaces.\nThere is a fee of $250 if you chose to smoke, an expensive cigarette!\n\n" +
                                           "Complimentary coffe and muffins on FOUR between 7am and 10am\n(10.30 weekends).  Complimentary tea/coffee/purified water/ice\nin the Galley on your floor (24/7).\n\n" +
                                           "Our concierge team on FOUR can assist you with many services\nincluding theater tickets, sightseeing tours, transportation to \nand from local airports, restaurant reservations, florists, and more.\n\n" +
                                           "\x1b\x69\x1\x1NOW TAKE THE ELEVATORS TO \"FOUR\"\n\x1b\x69\x0\x0\x1b\x64\x02\x7" 

    hotel.settings.bill_logo_index = "\x1"
  end
end
