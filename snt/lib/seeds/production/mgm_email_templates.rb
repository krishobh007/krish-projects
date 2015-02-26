#yotel_email_templates.rb
module SeedMGMEmailTemplates
  # encoding: utf-8
  def create_mgm_email_templates ( hotel_mgm = nil )
    
    hotel_mgm = Hotel.find_by_code("MGM") unless hotel_mgm
    theme = EmailTemplateTheme.find_or_create_by_name_and_code('MGM', 'guestweb_mgm')

    # ---------------- EMAIL TEMPLATE FOR RESERVATION CONFIRMATION EMAIL   ---------------- #
    email_confirmation_template = EmailTemplate.where(title: 'CHECKIN_EMAIL_TEMPLATE', email_template_theme_id: theme.id).first
    email_confirmation_template = EmailTemplate.create(
    	title: 'CHECKIN_EMAIL_TEMPLATE',
    	subject: 'Your room is ready for CHECK IN!',
    	body: '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
            <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
              <title>Check-In Email</title>
              <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
              <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0;" />
              <link href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:300" rel="stylesheet" type="text/css">
              <style type="text/css">
              body {
                width: 100%;
                margin: 0px;
                padding: 0px;
                background: #3b3b3b;
                text-align: left;
              }
              html {
                width: 100%;
              }
              img {
                border: 0px;
                text-decoration: none;
                outline: none;
              }
              a:hover {
                color: #0433ff;
                text-decoration: none;
              }
              a {
                color: #0433ff;
                text-decoration: underline !important;
              }
              .ReadMsgBody {
                width: 100%;
                background-color: #ffffff;
              }
              .ExternalClass {
                width: 100%;
                background-color: #ffffff;
              }
              table {
                border-collapse: collapse;
                mso-table-lspace: 0pt;
                mso-table-rspace: 0pt;
              }
              img[class=imageScale] {
              }
              .main-bg {
                background: #fff;
              }
              table[class=social] {
                text-align: right;
              }

              .header-space {
                padding: 0px 20px 0px 20px;
              }

              @media only screen and (max-width:640px) {
                body {
                  width: auto!important;
                }
                .main {
                  width: 640px !important;
                  margin: 0px;
                  padding: 0px;
                }
                .two-left {
                  width: 440px !important;
                  text-align: center!important;
                }
                .two-left-inner {
                  width: 376px !important;
                  text-align: center!important;
                }
                .header-space {
                  padding: 30px 0px 30px 0px;
                }
              }

              @media only screen and (max-width:479px) {
                body {
                  width: auto!important;
                }
                .main {
                  width: 280px !important;
                  margin: 0px;
                  padding: 0px;
                }
                .two-left {
                  width: 280px !important;
                  text-align: center!important;
                }
                .two-left-inner {
                  width: 216px !important;
                  text-align: center!important;
                }
                .space1 {
                  padding: 35px 0px 35px 0px;
                }
                table[class=social] {
                  width: 100%;
                  text-align: center;
                  margin-top: 20px;
                }
                table[class=contact] {
                  width: 100%;
                  text-align: center;
                  font: 12px;
                }
                .contact-space {
                  padding: 15px 0px 15px 0px;
                }
                .header-space {
                  padding: 30px 0px 30px 0px;
                }
              }
              </style>
            </head> <body>
            <table  border="0" align="center" cellpadding="0" cellspacing="0" class="main-bg" style="background:#fff; font-family: Helvetica, Arial, sans-serif">

              <td align="center" valign="top" style="padding:0px 0px 0px 0px;"><!-- Main Table Start-->
                <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                  <tr>
                    <td align="center" valign="top"><!-- Header Part Start-->
                      <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                        <tr background= "@mgm_bg" style="text-align:center;
                        vertical-align: middle;height:80px;">
                        <td><img src="@hotellogo" alt="" style="border: 0px;outline: none;  padding: 18px 0 16px;max-height:95px;" /></td>
                      </tr>
                    </table>
                    <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                      <tr>
                        <td align="center" valign="top" bgcolor="#FFFFFF" style="background:#FFF;"><table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                          <td align="center" valign="middle" style="font-family: Arial ,Helvetica, sans-serif; font-size:21px; color:#000000; text-align:center;padding: 32px 55px 34.5px;line-height: 1.5;" class="header-space"><b>Hi @first_name!&nbsp;&nbsp;</b>Your online check-in is ready. You will be able to pick up your key in the lobby. <span style="color:#fea022;">Upgrades are available!</span></td>
                        </tr>
                      </table></td>
                    </tr>
                  </table>
                  <!-- Header Part End-->
                  <!-- Text Part Start-->
                  <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                    <tr>
                    </tr>
                    <tr>
                      <td>
                        <table width="655" border="0" cellspacing="0" cellpadding="0" class="main">
                          <tr>
                            <td align="center" valign="top" bgcolor="#FFFFFF" style="background-color:#8d692f;">
                              <table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                                <tr style="text-align:center;font-size:42px;height:159%;padding-bottom:55px;">
                                  <td style="padding:72px 0 52px;"><a href="@url" style="text-decoration: none !important;color: #fff;display:block;font-weight:lighter !important;font-family: Source Sans Pro, sans-serif;">Check-in now
                                  </a>
                                  <br/>
                                  <span style="">
                                    <img src="@checkin_icon" alt="" style="border: 0px;outline: none;" />
                                  </span>
                                </td>
                              </tr>  
                            </table></td>
                          </tr>
                          <tr style="text-align:center; background:#e7f1fb;">
                            <td style="font-family: Arial ,Helvetica, sans-serif;font-size:14px;color:#000;padding:17px 0;">Can\'t see the image above? <a  href="@url">Click here to open in webpage</a>
                            </td>
                          </tr>
                        </table></td>
                      </tr>
                    </table>
                    <!-- Text Part End--></td>
                  </tr>
                  <tr>
                    <td style="padding:33px 6% 7px; font-size:17px;">Thank you and welcome,</td>
                  </tr>
                  <tr>
                    <td style="padding:0px 6% 3px;color:#af9a7b;font-size:18px;">@hotel_brand Team </td>
                  </tr>
                  <tr>
                    <td style="padding:0px 6% 75px;font-size:16px;"><a style="color:#8a99ff;">@from_address</a></td>
                  </tr>
                  <tr style="margin-top:65px;">
                    <td align="center" valign="top" style="background:#000; font-size:12px; color:#fff; padding:29px 0% 80px;width:655px;"><!-- Footer Part Start-->
                      <table width="625" border="0" align="center" cellpadding="5" cellspacing="0" class="main" style="font:normal Arial, Helvetica, sans-serif;">
                        <tr>
                          <td align="center" style="padding-bottom:10px;color:#fff;" >You @guest_email are receiving this email as part of your @hotel_name reservation. </td>
                        </tr>
                        <tr>
                          <td align="center" style="padding-bottom:30px;color:#fff;">This is an automated message from @hotel_name - @address</td>
                        </tr>
                        <tr>
                          <td align="center" style="padding-bottom:10px;color:#fff">&copy;2014 @hotel_brand | All Rights Reserved.</td>
                        </tr>
                        <tr>
                          <td align="center" style="padding-bottom:10px;color:#fff;">@hotel_address</td>
                        </tr>
                        <tr>
                          <td align="center" style="padding-bottom:70px;"><strong><a href="stayntouch.com/privacy" style="color:#fff !important; text-decoration:none !important;">Privacy Policy</a> | <a href="stayntouch.com/terms" style="color:#fff !important; text-decoration:none !important; ">Terms and Conditions</a></strong></td>
                        </tr>
                      </table>
                      <!-- Footer Part End--></td>
                    </tr>
                  </table>
                  <!-- Main Table End--></td>
                </tr>
              </table>
            </body>
            </html>',
    	signature: '',
      email_template_theme_id: theme.id
    ) if !email_confirmation_template

    hotel_mgm.email_templates << email_confirmation_template if hotel_mgm.present?  && hotel_mgm.email_templates.where('hotel_email_templates.email_template_id = ?', email_confirmation_template.id).count == 0
    


    # ---------------- EMAIL TEMPLATE FOR CHECKOUT EMAIL   ---------------- #
    checkout_email = EmailTemplate.where(title: 'CHECKOUT_EMAIL_TEXT', email_template_theme_id: theme.id).first
    checkout_email = EmailTemplate.create(
      title: 'CHECKOUT_EMAIL_TEXT',
      subject: 'Would you like to check out from your phone?',
      body: '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
            <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
              <title>Check-out Email</title>
              <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
              <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0;" />
              <link href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:300" rel="stylesheet" type="text/css">
              <style type="text/css">

              body {
                width: 100%;
                margin: 0px;
                padding: 0px;
                background: #3b3b3b;
                text-align: left;
              }
              html {
                width: 100%;
              }
              img {
                border: 0px;
                text-decoration: none;
                outline: none;
              }
              a:hover {
                color: #0433ff;
                text-decoration: none;
              }
              a {
                color: #0433ff;
                text-decoration: underline !important;
              }
              .ReadMsgBody {
                width: 100%;
                background-color: #ffffff;
              }
              .ExternalClass {
                width: 100%;
                background-color: #ffffff;
              }
              table {
                border-collapse: collapse;
                mso-table-lspace: 0pt;
                mso-table-rspace: 0pt;
              }
              img[class=imageScale] {
              }
              .main-bg {
                background: #fff;
              }
              table[class=social] {
                text-align: right;
              }

              .header-space {
                padding: 0px 20px 0px 20px;
              }

              @media only screen and (max-width:640px) {

                body {
                  width: 100%;
                  margin: 0px;
                  padding: 0px;
                  background: #3b3b3b;
                  text-align: left;
                }
                html {
                  width: 100%;
                }
                img {
                  border: 0px;
                  text-decoration: none;
                  outline: none;
                }
                a:hover {
                  color: #0433ff;
                  text-decoration: none;
                }
                a {
                  color: #0433ff;
                  text-decoration: underline !important;
                }
                .ReadMsgBody {
                  width: 100%;
                  background-color: #ffffff;
                }
                .ExternalClass {
                  width: 100%;
                  background-color: #ffffff;
                }
                table {
                  border-collapse: collapse;
                  mso-table-lspace: 0pt;
                  mso-table-rspace: 0pt;
                }
                img[class=imageScale] {
                }
                .main-bg {
                  background: #fff;
                }
                table[class=social] {
                  text-align: right;
                }

                .header-space {
                  padding: 0px 20px 0px 20px;
                }

                @media only screen and (max-width:640px) {
                  body {
                    width: auto!important;
                  }
                  .main {
                    width: 640px !important;
                    margin: 0px;
                    padding: 0px;
                  }
                  .two-left {
                    width: 440px !important;
                    text-align: center!important;
                  }
                  .two-left-inner {
                    width: 376px !important;
                    text-align: center!important;
                  }
                  .header-space {
                    padding: 30px 0px 30px 0px;
                  }
                }

                @media only screen and (max-width:479px) {
                  body {
                    width: auto!important;
                  }
                  .main {
                    width: 280px !important;
                    margin: 0px;
                    padding: 0px;
                  }
                  .two-left {
                    width: 280px !important;
                    text-align: center!important;
                  }
                  .two-left-inner {
                    width: 216px !important;
                    text-align: center!important;
                  }
                  .space1 {
                    padding: 35px 0px 35px 0px;
                  }
                  table[class=social] {
                    width: 100%;
                    text-align: center;
                    margin-top: 20px;
                  }
                  table[class=contact] {
                    width: 100%;
                    text-align: center;
                    font: 12px;
                  }
                  .contact-space {
                    padding: 15px 0px 15px 0px;
                  }
                  .header-space {
                    padding: 30px 0px 30px 0px;
                  }
                }
                </style>
              </head>
              <body>
                <table  border="0" align="center" cellpadding="0" cellspacing="0" class="main-bg" style="background:#fff; ">
                  <td align="center" valign="top" style="padding:0px 0px 0px 0px;"><!-- Main Table Start-->
                    <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                      <tr>
                        <td align="center" valign="top"><!-- Header Part Start-->
                          <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                            <tr background= "@mgm_bg" style="text-align:center;
                            vertical-align: middle;height:80px;">
                            <td><img src="@hotellogo" alt="" style="border: 0px;outline: none;  padding: 18px 0 16px;max-height:95px;" /></td>
                          </tr>
                        </table>
                        <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                          <tr>
                            <td align="center" valign="top" bgcolor="#FFFFFF" style="background:#FFF;"><table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                              <td align="center" valign="middle" style="font-family: Arial ,Helvetica, sans-serif; font-size:21px; color:#000000; text-align:center;padding: 32px 55px 34.5px;line-height: 1.5;" class="header-space"><b>Hi @first_name!&nbsp;&nbsp;</b>Click below to check out of your room. You may opt for a Late Check-Out, depending on availability.</td>
                            </tr>
                          </table></td>
                        </tr>
                      </table><!-- Header Part End-->
                      <!-- Text Part Start-->

                      <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                        <tr>
                        </tr>
                        <tr>
                          <td>
                            <table width="655" border="0" cellspacing="0" cellpadding="0" class="main">
                              <tr>
                                <td align="center" valign="top" bgcolor="#FFFFFF" style="background-color:#8d692f;">
                                  <table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                                    <tr style="text-align:center;font-size:42px;height:159%;padding-bottom:55px;">
                                      <td style="padding:72px 0 52px;"><a href="@url" style="text-decoration: none !important;color: #fff;display:block;font-weight:lighter !important;font-family: Source Sans Pro, sans-serif;">View Check-out options.
                                      </a>
                                      <br/>
                                      <span style="">
                                        <img src="@checkout_icon" alt="" style="border: 0px;outline: none;" />
                                        <img src="@latecheckout_icon" alt="" style="border: 0px;outline: none;" /> 
                                      </span>
                                    </td>
                                  </tr>  
                                </table></td>
                              </tr>
                              <tr style="text-align:center; background:#e7f1fb;">
                                <td style="font-family: Arial,Helvetica, sans-serif;font-size:14px;color:#000;padding:17px 0;">Can\'t see the image above? <a  href="@url">Click here to open in webpage</a>
                                </td>
                              </tr>
                            </table></td>
                          </tr>
                        </table>
                        <!-- Text Part End--></td>
                      </tr>
                      <tr>
                        <td style="padding:33px 6% 7px; font-size:17px;font-family: Arial ,Helvetica, sans-serif;">Thank you for staying with us,</td>
                      </tr>
                      <tr>
                        <td style="padding:0px 6% 3px;color:#af9a7b;font-size:18px;font-family: Arial ,Helvetica, sans-serif;">@hotel_brand Team </td>
                      </tr>
                      <tr>
                        <td style="padding:0px 6% 75px;font-size:16px;font-family: Arial ,Helvetica, sans-serif;"><a href="" style="color:#8a99ff">@from_address</a></td>
                      </tr>
                      <tr style="margin-top:65px;">
                        <td align="center" valign="top" style="background:#000; font-size:12px; color:#fff; padding:29px 0% 80px;width:655px;"><!-- Footer Part Start-->

                          <table width="625" border="0" align="center" cellpadding="5" cellspacing="0" class="main" style="font:normal Arial, Helvetica, sans-serif;">
                            <tr>
                              <td align="center" style="padding-bottom:10px;color:#fff;font-family: Arial ,Helvetica, sans-serif;" >You @guest_email are receiving this email as part of your @hotel_name reservation. </td>
                            </tr>
                            <tr>
                              <td align="center" style="padding-bottom:30px;color:#fff;font-family: Arial ,Helvetica, sans-serif;">This is an automated message from @hotel_name - @address</td>
                            </tr>
                            <tr>
                              <td align="center" style="padding-bottom:10px;color:#fff;font-family: Arial ,Helvetica, sans-serif;">&copy;2014 @hotel_brand | All Rights Reserved.</td>
                            </tr>
                            <tr>
                              <td align="center" style="padding-bottom:10px;color:#fff;font-family: Arial ,Helvetica, sans-serif;">@hotel_address</td>
                            </tr>
                            <tr>
                              <td align="center" style="padding-bottom:70px;"><strong><a href="stayntouch.com/privacy" style="color:#fff !important; text-decoration:none !important;font-family: Arial ,Helvetica, sans-serif;">Privacy Policy</a> | <a href="stayntouch.com/terms" style="color:#fff !important; text-decoration:none !important;font-family: Arial ,Helvetica, sans-serif;">Terms and Conditions</a></strong></td>
                            </tr>
                          </table>

                          <!-- Footer Part End--></td>
                        </tr>
                      </table>

                    <!-- Main Table End--></td>
                  </tr>
                </table>
              </body>
              </html>',
  		signature: '',
      email_template_theme_id: theme.id
    ) if !checkout_email

    hotel_mgm.email_templates << checkout_email if hotel_mgm.present?  && hotel_mgm.email_templates.where('hotel_email_templates.email_template_id = ?', checkout_email.id).count == 0
        
    # ---------------- EMAIL TEMPLATE FOR LATE CHECKOUT EMAIL   ---------------- #
    late_checkout_email =  EmailTemplate.where(title: 'LATE_CHECKOUT_EMAIL_TEXT', email_template_theme_id: theme.id).first
    late_checkout_email =  EmailTemplate.create(
      title: 'LATE_CHECKOUT_EMAIL_TEXT',
      subject: 'Would you like to stay a little longer?',
      body: '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
          <html xmlns="http://www.w3.org/1999/xhtml">
          <head>
            <title>Late Check-out Email</title>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
            <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0;" />
            <link href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:300" rel="stylesheet" type="text/css">
            <style type="text/css">

            body {
              width: 100%;
              margin: 0px;
              padding: 0px;
              background: #3b3b3b;
              text-align: left;
            }
            html {
              width: 100%;
            }
            img {
              border: 0px;
              text-decoration: none;
              outline: none;
            }
            a:hover {
              color: #0433ff;
              text-decoration: none;
            }
            a {
              color: #0433ff;
              text-decoration: underline !important;
            }
            .ReadMsgBody {
              width: 100%;
              background-color: #ffffff;
            }
            .ExternalClass {
              width: 100%;
              background-color: #ffffff;
            }
            table {
              border-collapse: collapse;
              mso-table-lspace: 0pt;
              mso-table-rspace: 0pt;
            }
            img[class=imageScale] {
            }
            .main-bg {
              background: #fff;
            }
            table[class=social] {
              text-align: right;
            }

            .header-space {
              padding: 0px 20px 0px 20px;
            }

            @media only screen and (max-width:640px) {
              body {
                width: 100%;
                margin: 0px;
                padding: 0px;
                background: #3b3b3b;
                text-align: left;
              }
              html {
                width: 100%;
              }
              img {
                border: 0px;
                text-decoration: none;
                outline: none;
              }
              a:hover {
                color: #0433ff;
                text-decoration: none;
              }
              a {
                color: #0433ff;
                text-decoration: underline !important;
              }
              .ReadMsgBody {
                width: 100%;
                background-color: #ffffff;
              }
              .ExternalClass {
                width: 100%;
                background-color: #ffffff;
              }
              table {
                border-collapse: collapse;
                mso-table-lspace: 0pt;
                mso-table-rspace: 0pt;
              }
              img[class=imageScale] {
              }
              .main-bg {
                background: #fff;
              }
              table[class=social] {
                text-align: right;
              }

              .header-space {
                padding: 0px 20px 0px 20px;
              }

              @media only screen and (max-width:640px) {
                body {
                  width: auto!important;
                }
                .main {
                  width: 640px !important;
                  margin: 0px;
                  padding: 0px;
                }
                .two-left {
                  width: 440px !important;
                  text-align: center!important;
                }
                .two-left-inner {
                  width: 376px !important;
                  text-align: center!important;
                }
                .header-space {
                  padding: 30px 0px 30px 0px;
                }
              }

              @media only screen and (max-width:479px) {
                body {
                  width: auto!important;
                }
                .main {
                  width: 280px !important;
                  margin: 0px;
                  padding: 0px;
                }
                .two-left {
                  width: 280px !important;
                  text-align: center!important;
                }
                .two-left-inner {
                  width: 216px !important;
                  text-align: center!important;
                }
                .space1 {
                  padding: 35px 0px 35px 0px;
                }
                table[class=social] {
                  width: 100%;
                  text-align: center;
                  margin-top: 20px;
                }
                table[class=contact] {
                  width: 100%;
                  text-align: center;
                  font: 12px;
                }
                .contact-space {
                  padding: 15px 0px 15px 0px;
                }
                .header-space {
                  padding: 30px 0px 30px 0px;
                }
              }
              </style>
            </head>
            <body>
              <table  border="0" align="center" cellpadding="0" cellspacing="0" class="main-bg" style="background:#fff; ">
                <td align="center" valign="top" style="padding:0px 0px 0px 0px;"><!-- Main Table Start-->
                  <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                    <tr>
                      <td align="center" valign="top"><!-- Header Part Start-->
                        <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                          <tr background= "@mgm_bg" style="text-align:center;
                          vertical-align: middle;height:80px;">
                          <td><img src="@hotellogo" alt="" style="border: 0px;outline: none;  padding: 18px 0 16px;max-height:95px;" /></td>
                        </tr>
                      </table>
                      <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                        <tr>
                          <td align="center" valign="top" bgcolor="#FFFFFF" style="background:#FFF;"><table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                            <td align="center" valign="middle" style="font-family: Arial ,Helvetica, sans-serif; font-size:21px; color:#000000; text-align:center;padding: 32px 55px 34.5px;line-height: 1.5;" class="header-space"><b>Hi @first_name!&nbsp;&nbsp;</b>Click below to check out of your room. You may opt for a Late Check-Out, depending on availability.</td>
                          </tr>
                        </table></td>
                      </tr>
                    </table><!-- Header Part End-->
                    <!-- Text Part Start-->

                    <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                      <tr>
                      </tr>
                      <tr>
                        <td>
                          <table width="655" border="0" cellspacing="0" cellpadding="0" class="main">
                            <tr>
                              <td align="center" valign="top" bgcolor="#FFFFFF" style="background-color:#8d692f;">
                                <table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                                  <tr style="text-align:center;font-size:42px;height:159%;padding-bottom:55px;">
                                    <td style="padding:72px 0 52px;"><a href="@url" style="text-decoration: none !important;color: #fff;display:block;font-weight:lighter !important;font-family: Source Sans Pro, sans-serif;">View Check-out options.
                                    </a>
                                    <br/>
                                    <span style="">
                                      <img src="@checkout_icon" alt="" style="border: 0px;outline: none;" />
                                      <img src="@latecheckout_icon" alt="" style="border: 0px;outline: none;" /> 
                                    </span>
                                  </td>
                                </tr>  
                              </table></td>
                            </tr>
                            <tr style="text-align:center; background:#e7f1fb;">
                              <td style="font-family: Arial,Helvetica, sans-serif;font-size:14px;color:#000;padding:17px 0;">Can\'t see the image above? <a  href="@url">Click here to open in webpage</a>
                              </td>
                            </tr>
                          </table></td>
                        </tr>
                      </table>
                      <!-- Text Part End--></td>
                    </tr>
                    <tr>
                      <td style="padding:33px 6% 7px; font-size:17px;font-family: Arial ,Helvetica, sans-serif;">Thank you for staying with us,</td>
                    </tr>
                    <tr>
                      <td style="padding:0px 6% 3px;color:#af9a7b;font-size:18px;font-family: Arial ,Helvetica, sans-serif;">@hotel_brand Team </td>
                    </tr>
                    <tr>
                      <td style="padding:0px 6% 75px;font-size:16px;font-family: Arial ,Helvetica, sans-serif;"><a href="" style="color:#8a99ff">@from_address</a></td>
                    </tr>
                    <tr style="margin-top:65px;">
                      <td align="center" valign="top" style="background:#000; font-size:12px; color:#fff; padding:29px 0% 80px;width:655px;"><!-- Footer Part Start-->

                        <table width="625" border="0" align="center" cellpadding="5" cellspacing="0" class="main" style="font:normal Arial, Helvetica, sans-serif;">
                          <tr>
                            <td align="center" style="padding-bottom:10px;color:#fff;font-family: Arial ,Helvetica, sans-serif;" >You @guest_email are receiving this email as part of your @hotel_name reservation. </td>
                          </tr>
                          <tr>
                            <td align="center" style="padding-bottom:30px;color:#fff;font-family: Arial ,Helvetica, sans-serif;">This is an automated message from @hotel_name - @address</td>
                          </tr>
                          <tr>
                            <td align="center" style="padding-bottom:10px;color:#fff;font-family: Arial ,Helvetica, sans-serif;">&copy;2014 @hotel_brand | All Rights Reserved.</td>
                          </tr>
                          <tr>
                            <td align="center" style="padding-bottom:10px;color:#fff;font-family: Arial ,Helvetica, sans-serif;">@hotel_address</td>
                          </tr>
                          <tr>
                            <td align="center" style="padding-bottom:70px;"><strong><a href="stayntouch.com/privacy" style="color:#fff !important; text-decoration:none !important;font-family: Arial ,Helvetica, sans-serif;">Privacy Policy</a> | <a href="stayntouch.com/terms" style="color:#fff !important; text-decoration:none !important;font-family: Arial ,Helvetica, sans-serif;">Terms and Conditions</a></strong></td>
                          </tr>
                        </table>

                        <!-- Footer Part End--></td>
                      </tr>
                    </table>

                    <!-- Main Table End--></td>
                  </tr>
                </table>
              </body>
              </html>',
  		signature: ''
		) if !late_checkout_email
        
    hotel_mgm.email_templates << late_checkout_email if hotel_mgm.present?  && hotel_mgm.email_templates.where('hotel_email_templates.email_template_id = ?', late_checkout_email.id).count == 0
    
    # ---------------- EMAIL TEMPLATE FOR KEY DELIVERY EMAIL   ---------------- #
    key_delivery_email = EmailTemplate.where(title: 'Key Delivery Email Text', email_template_theme_id: theme.id).first
    key_delivery_email = EmailTemplate.create(
      title: 'Key Delivery Email Text',
      subject: 'Welcome. Your Room Key Details Are Enclosed!',
      body: '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
            <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
              <title>Mail Key Delivery</title>
              <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
              <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0;" />
              <link href="http://fonts.googleapis.com/css?family=Source+Sans+Pro:300" rel="stylesheet" type="text/css">
              <style type="text/css">

              body {
                width: 100%;
                margin: 0px;
                padding: 0px;
                background: #3b3b3b;
                text-align: left;
              }
              html {
                width: 100%;
              }
              img {
                border: 0px;
                text-decoration: none;
                outline: none;
              }
              a:hover {
                color: #0433ff;
                text-decoration: none;
              }
              a {
                color: #0433ff;
                text-decoration: underline !important;
              }
              .ReadMsgBody {
                width: 100%;
                background-color: #ffffff;
              }
              .ExternalClass {
                width: 100%;
                background-color: #ffffff;
              }
              table {
                border-collapse: collapse;
                mso-table-lspace: 0pt;
                mso-table-rspace: 0pt;
              }
              img[class=imageScale] {
              }
              .main-bg {
                background: #fff;
              }
              table[class=social] {
                text-align: right;
              }

              .header-space {
                padding: 0px 20px 0px 20px;
              }

              @media only screen and (max-width:640px) {
                body {
                  width: auto!important;
                }
                .main {
                  width: 640px !important;
                  margin: 0px;
                  padding: 0px;
                }
                .two-left {
                  width: 440px !important;
                  text-align: center!important;
                }
                .two-left-inner {
                  width: 376px !important;
                  text-align: center!important;
                }
                .header-space {
                  padding: 30px 0px 30px 0px;
                }
              }

              @media only screen and (max-width:479px) {
                body {
                  width: auto!important;
                }
                .main {
                  width: 280px !important;
                  margin: 0px;
                  padding: 0px;
                }
                .two-left {
                  width: 280px !important;
                  text-align: center!important;
                }
                .two-left-inner {
                  width: 216px !important;
                  text-align: center!important;
                }
                .space1 {
                  padding: 35px 0px 35px 0px;
                }
                table[class=social] {
                  width: 100%;
                  text-align: center;
                  margin-top: 20px;
                }
                table[class=contact] {
                  width: 100%;
                  text-align: center;
                  font: 12px;
                }
                .contact-space {
                  padding: 15px 0px 15px 0px;
                }
                .header-space {
                  padding: 30px 0px 30px 0px;
                }
              }
              </style>
            </head>
            <body>
              <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main-bg" style="background:#fff; ">
                <tr>
                  <td align="center" valign="top" style="padding:0px 0px 0px 0px;"><!-- Main Table Start-->
                    <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                      <tr>
                        <td align="center" valign="top"><!-- Header Part Start-->
                          <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                            <tr background= "@mgm_bg" style="text-align:center;
                            vertical-align: middle;height:80px;">
                            <td><img src="@hotellogo" alt="" style="border: 0px;outline: none;  padding: 18px 0 16px;max-height:95px;" /></td>
                          </tr>
                        </table>
                        <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                          <tr>
                            <td align="center" valign="top" bgcolor="#FFFFFF" style="background:#FFF;"><table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                              <td align="center" valign="middle" style="font-family: Arial ,Helvetica, sans-serif; font-size:21px; color:#000000; text-align:center;padding: 32px 55px 34.5px;line-height: 1.5;" class="header-space"><b>Hi @first_name @last_name,&nbsp;&nbsp;</b>You are checked in. Your room is:</td>
                            </tr>
                          </table></td>
                        </tr>
                      </table><!-- Header Part End-->
                      <!-- Text Part Start-->

                      <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                        <tr>
                        </tr>
                        <tr>
                          <td>

                            <table width="655" border="0" cellspacing="0" cellpadding="0" class="main">
                              <tr>
                                <td align="center" valign="top" bgcolor="#FFFFFF" style="background-color:#8d692f;">

                                  <table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">

                                    <tr style="text-align:center;height:159%;padding-bottom:55px;">
                                      <td style="padding:30px 0;"><a href="@url" style="text-decoration: none !important;color: #fff;display:block;font-weight:lighter !important;font-family: arial;font-size:30px;letter-spacing: 16px;">ROOM
                                      </a>
                                      <span style="color: #fff;display:block;font-size:90px;line-height: 1;font-family: Source Sans Pro,sans-serif;">
                                        @room_number
                                      </span> 
                                    </td>
                                  </tr>  
                                </table></td>
                              </tr>
                            </table></td>
                          </tr>

                        </table>

                        <!-- Text Part End--></td>
                      </tr>
                      <tr>
                        <td style="text-align:justify;font-family:Arial,Helvetica, sans-serif;font-size:14px; font-size:17px;padding:20px 23% 7px;">

                          <table>
                            <tr>
                              <td>
                                <img src="@key_black" alt=""/>
                              </td>
                              <td style="padding-left:20px;">
                                <span>Please go to the @key_delivery_message at the Front Desk For your key.</span> 
                              </td>
                            </tr>
                          </table>       

                        </td>
                      </tr>
                      <tr>
                        <td style="padding:33px 6% 7px; font-size:17px;font-family: Arial ,Helvetica, sans-serif;">Thanks,</td>
                      </tr>
                      <tr>
                        <td style="padding:0px 6% 3px;color:#af9a7b;font-size:18px;font-family: Arial ,Helvetica, sans-serif;">@hotel_brand Team </td>
                      </tr>
                      <tr>
                        <td style="padding:0px 6% 75px;font-size:16px;font-family: Arial ,Helvetica, sans-serif;"><a href="" style="color:#8a99ff">@from_address</a></td>
                      </tr>
                      <tr style="margin-top:65px;">
                        <td align="center" valign="top" style="background:#000; font-size:12px; color:#fff; padding:29px 0% 80px;width:655px;"><!-- Footer Part Start-->

                          <table width="625" border="0" align="center" cellpadding="5" cellspacing="0" class="main" style="font:normal Arial, Helvetica, sans-serif;">
                            <tr>
                              <td align="center" style="padding-bottom:10px;color:#fff;font-family: Arial ,Helvetica, sans-serif;" >You @guest_email are receiving this email as part of your @hotel_name reservation. </td>
                            </tr>
                            <tr>
                              <td align="center" style="padding-bottom:30px;color:#fff;font-family: Arial ,Helvetica, sans-serif;">This is an automated message from @hotel_name - @address</td>
                            </tr>
                            <tr>
                              <td align="center" style="padding-bottom:10px;color:#fff;font-family: Arial ,Helvetica, sans-serif;">&copy;2014 @hotel_brand | All Rights Reserved.</td>
                            </tr>
                            <tr>
                              <td align="center" style="padding-bottom:10px;color:#fff;font-family: Arial ,Helvetica, sans-serif;">@hotel_address</td>
                            </tr>
                            <tr>
                              <td align="center" style="padding-bottom:70px;"><strong><a href="stayntouch.com/privacy" style="color:#fff !important; text-decoration:none !important;font-family: Arial ,Helvetica, sans-serif;">Privacy Policy</a> | <a href="stayntouch.com/terms" style="color:#fff !important; text-decoration:none !important;font-family: Arial ,Helvetica, sans-serif;">Terms and Conditions</a></strong></td>
                            </tr>
                          </table>

                          <!-- Footer Part End--></td>
                        </tr>
                      </table>

                      <!-- Main Table End--></td>
                    </tr>
                  </table>


                  <!-- Main Table End--></td>
                </tr>
              </table>
            </body>
            </html>',
		  signature: '',
      email_template_theme_id: theme.id
    ) if !key_delivery_email
    
    hotel_mgm.email_templates << key_delivery_email if hotel_mgm.present?  && hotel_mgm.email_templates.where('hotel_email_templates.email_template_id = ?', key_delivery_email.id).count == 0
    
  end
end