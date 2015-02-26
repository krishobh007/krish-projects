#huntley_email_templates.rb
module SeedHuntleyEmailTemplates
  # encoding: utf-8
  def create_huntley_email_templates ( hotel = nil )
    
    theme = EmailTemplateTheme.find_or_create_by_name_and_code('Huntley Hotel', 'guestweb_huntley')

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
            <table  border="0" align="center" cellpadding="0" cellspacing="0" class="main-bg"  style="background:#fff; font-family: Helvetica, Arial, sans-serif">

              <td align="center" valign="top" style="padding:0px 0px 0px 0px;"><!-- Main Table Start-->
                <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                  <tr>
                    <td align="center" valign="top"><!-- Header Part Start-->
                      <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                        <tr style="text-align:center;
                        vertical-align: middle;height:80px;">
                        <td><img src="@hotellogo" alt="" style="border: 0px;outline: none;  padding: 18px 0 18px;" /></td>
                      </tr>
                    </table>
                    <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                      <tr>
                        <td align="center" valign="top" bgcolor="#FFFFFF" style="background:#FFF;"><table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                          <td align="center" valign="middle" style="font-family: Arial ,Helvetica, sans-serif; font-size:21px; color:#000000; text-align:center;padding: 32px 15px 34.5px;line-height: 1.5;" class="header-space"><b>Dear @title @first_name @last_name,&nbsp;&nbsp;</b>Your online Check-in is ready. You will be able to pick up your key in the lobby.</td>
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
                            <td align="center" valign="top" bgcolor="#FFFFFF" style="background-color:#74D3F3;">
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
                          <tr style="text-align:center; background:#F4F4F4;">
                            <td style="font-family: Arial ,Helvetica, sans-serif;font-size:14px;color:#000;padding:17px 0;">Can\'t see the image above? <a  href="@url">Click here to open in webpage</a>
                            </td>
                          </tr>
                        </table></td>
                      </tr>
                    </table>
                    <!-- Text Part End--></td>
                  </tr>
                  <tr>
                    <td style="padding:33px 6% 7px; font-size:17px;">Thank you,</td>
                  </tr>
                 <tr>
                                  <td style="padding:0px 6% 3px;font-size:18px;">@hotel_name</td>
                                </tr>
                                <tr>
                                  <td style="padding:0px 6% 90px;font-size:16px;"><a href="" style="color:#4C6AFE;">@from_address</a></td>
                                </tr>
                                <tr style="margin-top:65px;">
                                  <td align="center" valign="top" style="background:#F4F4F4; font-size:12px; color:#000; padding:29px 0% 80px;width:655px;"><!-- Footer Part Start-->

                                    <table width="625" border="0" align="center" cellpadding="5" cellspacing="0" class="main" style="font:normal Arial, Helvetica, sans-serif;">
                                      <tr>
                                        <td align="center" style="padding-bottom:10px;color:#000;" >You @guest_email are receiving this email as part of your @hotel_name reservation. </td>
                                      </tr>
                                      <tr>
                                        <td align="center" style="padding-bottom:30px;color:#000;">This is an automated message from @hotel_name - @address</td>
                                      </tr>
                                      <tr>
                                        <td align="center" style="padding-bottom:10px;color:#000">&copy;2014 @hotel_brand | All Rights Reserved.</td>
                                      </tr>
                                      <tr>
                                        <td align="center" style="padding-bottom:10px;color:#000;">@hotel_address</td>
                                      </tr>
                                      <tr>
                                        <td align="center" style="padding-bottom:70px;"><strong><a href="stayntouch.com/privacy" style="color:#000; text-decoration:none;">Privacy Policy</a> | <a href="stayntouch.com/terms" style="color:#000; text-decoration:none;">Terms and Conditions</a></strong></td>
                                      </tr>
                                    </table>

                                    <!-- Footer Part End--></td>
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
            }
            </style>
          </head>
          <body>
            <table  border="0" align="center" cellpadding="0" cellspacing="0" class="main-bg" style="background:#fff;">
              <td align="center" valign="top" style="padding:0px 0px 0px 0px;"><!-- Main Table Start-->
                <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                  <tr>
                    <td align="center" valign="top"><!-- Header Part Start-->
                      <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                        <tr style="text-align:center;
                        vertical-align: middle;height:80px;">
                        <td><img src="@hotellogo" alt="" style="border: 0px;outline: none;  padding: 18px 0 18px;" /></td>
                      </tr>
                    </table>
                    <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                        <tr>
                                <td align="center" valign="top" bgcolor="#FFFFFF" style="background:#FFF;"><table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                                  <td align="center" valign="middle" style="font-family: Arial ,Helvetica, sans-serif; font-size:21px; color:#000000; text-align:center;padding: 32px 15px 34.5px;line-height: 1.5;" class="header-space"><b>Dear @title @first_name @last_name,&nbsp;&nbsp;</b>Click below to check out of your room. You may opt for a Late Check-Out, depending on availability.</td>
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
                            <td align="center" valign="top" bgcolor="#FFFFFF" style="background-color:#74d3f3;">
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
                          <tr style="text-align:center; background:#F4F4F4;">
                            <td style="font-family: Arial,Helvetica, sans-serif;font-size:14px;color:#000;padding:17px 0;">Can\'t see the image above? <a  href="@url">Click here to open in webpage</a>
                            </td>
                          </tr>
                        </table></td>
                      </tr>
                    </table>
                    <!-- Text Part End--></td>
                  </tr>
                  <tr>
                    <td style="padding:33px 6% 7px; font-size:17px;font-family: Arial ,Helvetica, sans-serif;">Thank you,</td>
                  </tr>
                  <tr>
                    <td style="padding:0px 6% 3px;font-size:18px;font-family: Arial ,Helvetica, sans-serif;">@hotel_name</td>
                  </tr>
                  <tr>
                    <td style="padding:0px 6% 75px;font-size:16px;font-family: Arial ,Helvetica, sans-serif;"><a href="" style="color:#4C6AFE;">@from_address</a></td>
                  </tr>
                  <tr style="margin-top:65px;">
                              <td align="center" valign="top" style="background:#F4F4F4; font-size:12px; color:#000; padding:29px 0% 80px;width:655px;"><!-- Footer Part Start-->

                                <table width="625" border="0" align="center" cellpadding="5" cellspacing="0" class="main" style="font:normal Arial, Helvetica, sans-serif;">
                                  <tr>
                                    <td align="center" style="padding-bottom:10px;color:#000;" >You @guest_email are receiving this email as part of your @hotel_name reservation. </td>
                                  </tr>
                                  <tr>
                                    <td align="center" style="padding-bottom:30px;color:#000;">This is an automated message from @hotel_name - @address</td>
                                  </tr>
                                  <tr>
                                    <td align="center" style="padding-bottom:10px;color:#000">&copy;2014 @hotel_brand | All Rights Reserved.</td>
                                  </tr>
                                  <tr>
                                    <td align="center" style="padding-bottom:10px;color:#000;">@hotel_address</td>
                                  </tr>
                                  <tr>
                                    <td align="center" style="padding-bottom:70px;"><strong><a href="stayntouch.com/privacy" style="color:#000; text-decoration:none;">Privacy Policy</a> | <a href="stayntouch.com/terms" style="color:#000; text-decoration:none;">Terms and Conditions</a></strong></td>
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
    
    # ---------------- EMAIL TEMPLATE FOR LATE CHECKOUT EMAIL   ---------------- #

    late_checkout_email = EmailTemplate.where(title: 'LATE_CHECKOUT_EMAIL_TEXT', email_template_theme_id: theme.id).first
    late_checkout_email =  EmailTemplate.create(
    title: 'LATE_CHECKOUT_EMAIL_TEXT',
    subject: 'Would you like to stay a little longer?',
    body: ' <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
            }
            </style>
          </head>
          <body>
            <table  border="0" align="center" cellpadding="0" cellspacing="0" class="main-bg" style="background:#fff;">
              <td align="center" valign="top" style="padding:0px 0px 0px 0px;"><!-- Main Table Start-->
                <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                  <tr>
                    <td align="center" valign="top"><!-- Header Part Start-->
                      <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                        <tr style="text-align:center;
                        vertical-align: middle;height:80px;">
                        <td><img src="@hotellogo" alt="" style="border: 0px;outline: none;  padding: 18px 0 18px;" /></td>
                      </tr>
                    </table>
                    <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                        <tr>
                                <td align="center" valign="top" bgcolor="#FFFFFF" style="background:#FFF;"><table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                                  <td align="center" valign="middle" style="font-family: Arial ,Helvetica, sans-serif; font-size:21px; color:#000000; text-align:center;padding: 32px 15px 34.5px;line-height: 1.5;" class="header-space"><b>Dear @title @first_name @last_name,&nbsp;&nbsp;</b>Click below to check out of your room. You may opt for a Late Check-Out, depending on availability.</td>
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
                            <td align="center" valign="top" bgcolor="#FFFFFF" style="background-color:#74d3f3;">
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
                          <tr style="text-align:center; background:#F4F4F4;">
                            <td style="font-family: Arial,Helvetica, sans-serif;font-size:14px;color:#000;padding:17px 0;">Can\'t see the image above? <a  href="@url">Click here to open in webpage</a>
                            </td>
                          </tr>
                        </table></td>
                      </tr>
                    </table>
                    <!-- Text Part End--></td>
                  </tr>
                  <tr>
                    <td style="padding:33px 6% 7px; font-size:17px;font-family: Arial ,Helvetica, sans-serif;">Thank you,</td>
                  </tr>
                  <tr>
                    <td style="padding:0px 6% 3px;font-size:18px;font-family: Arial ,Helvetica, sans-serif;">@hotel_name</td>
                  </tr>
                  <tr>
                    <td style="padding:0px 6% 75px;font-size:16px;font-family: Arial ,Helvetica, sans-serif;"><a href="" style="color:#4C6AFE;">@from_address</a></td>
                  </tr>
                  <tr style="margin-top:65px;">
                              <td align="center" valign="top" style="background:#F4F4F4; font-size:12px; color:#000; padding:29px 0% 80px;width:655px;"><!-- Footer Part Start-->

                                <table width="625" border="0" align="center" cellpadding="5" cellspacing="0" class="main" style="font:normal Arial, Helvetica, sans-serif;">
                                  <tr>
                                    <td align="center" style="padding-bottom:10px;color:#000;" >You @guest_email are receiving this email as part of your @hotel_name reservation. </td>
                                  </tr>
                                  <tr>
                                    <td align="center" style="padding-bottom:30px;color:#000;">This is an automated message from @hotel_name - @address</td>
                                  </tr>
                                  <tr>
                                    <td align="center" style="padding-bottom:10px;color:#000">&copy;2014 @hotel_brand | All Rights Reserved.</td>
                                  </tr>
                                  <tr>
                                    <td align="center" style="padding-bottom:10px;color:#000;">@hotel_address</td>
                                  </tr>
                                  <tr>
                                    <td align="center" style="padding-bottom:70px;"><strong><a href="stayntouch.com/privacy" style="color:#000; text-decoration:none;">Privacy Policy</a> | <a href="stayntouch.com/terms" style="color:#000; text-decoration:none;">Terms and Conditions</a></strong></td>
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
    ) if !late_checkout_email
    
    # ---------------- EMAIL TEMPLATE FOR KEY DELIVERY EMAIL   ---------------- #

    key_delivery_email = EmailTemplate.where(title: 'Key Delivery Email Text', email_template_theme_id: theme.id).first
    key_delivery_email = EmailTemplate.create(
    title: 'Key Delivery Email Text',
    subject: 'Welcome. Your Room Key Details Are Enclosed.',
    body:   '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
              <table  border="0" align="center" cellpadding="0" cellspacing="0" class="main-bg">
                <td align="center" valign="top" style="padding:0px 0px 0px 0px;"><!-- Main Table Start-->
                  <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                    <tr>
                      <td align="center" valign="top"><!-- Header Part Start-->
                        <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                          <tr style="text-align:center;
                          vertical-align: middle;height:80px;">
                          <td><img src="@hotellogo" alt="" style="border: 0px;outline: none;  padding: 65px 0 23px;" /></td>
                        </tr>
                      </table>
                      <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                        <tr>
                          <td align="center" valign="top" bgcolor="#FFFFFF" style="background:#FFF;"><table width="625" border="0" align="center" cellpadding="0" cellspacing="0">
                            <td align="center" valign="middle" style="font-family:Arial,Helvetica, sans-serif; font-size:21px; color:#000000; text-align:center;padding: 32px 55px 42px;line-height: 1.5;" class="header-space"><b>Dear @title @first_name @last_name!&nbsp;&nbsp;</b>You are checked in. Your room is:</td>
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
                              <td align="center" valign="top" bgcolor="#FFFFFF" style="background-color:#74D3F3;">
                                <table width="625" border="0" align="center" cellpadding="0" cellspacing="0">
                                  <tr style="text-align:center;height:159%;padding-bottom:55px;">
                                    <td style="padding:30px 0;"><a href="@url" style="text-decoration: none !important;color: #fff;display:block;font-weight:lighter !important;font-family: arial;font-size:30px;letter-spacing: 16px;">ROOM
                                    </a>
                                    <span style="color: #fff;display:block;font-size:90px;line-height: 1;">
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
                              <span>@key_delivery_message</span> 
                            </td>
                          </tr>
                        </table>       
                      </td>
                    </tr>
                   <tr>
            <td style="padding:33px 6% 7px; font-size:17px;font-family: Arial ,Helvetica, sans-serif;">Thank you,</td>
              </tr>
              <tr>
                <td style="padding:0px 6% 3px;font-size:18px;font-family: Arial ,Helvetica, sans-serif;">@hotel_name</td>
              </tr>
              <tr>
                <td style="padding:0px 6% 75px;font-size:16px;font-family: Arial ,Helvetica, sans-serif;"><a href="" style="color:#4C6AFE;">@from_address</a></td>
              </tr>
              <tr style="margin-top:65px;">
                          <td align="center" valign="top" style="background:#F4F4F4; font-size:12px; color:#000; padding:29px 0% 80px;width:655px;"><!-- Footer Part Start-->
                            <table width="625" border="0" align="center" cellpadding="5" cellspacing="0" class="main" style="font:normal Arial, Helvetica, sans-serif;">
                              <tr>
                                <td align="center" style="padding-bottom:10px;color:#000;" >You @guest_email are receiving this email as part of your @hotel_name reservation. </td>
                              </tr>
                              <tr>
                                <td align="center" style="padding-bottom:30px;color:#000;">This is an automated message from @hotel_name - @address</td>
                              </tr>
                              <tr>
                                <td align="center" style="padding-bottom:10px;color:#000">&copy;2014 @hotel_brand | All Rights Reserved.</td>
                              </tr>
                              <tr>
                                <td align="center" style="padding-bottom:10px;color:#000;">@hotel_address</td>
                              </tr>
                              <tr>
                                <td align="center" style="padding-bottom:70px;"><strong><a href="stayntouch.com/privacy" style="color:#000; text-decoration:none;">Privacy Policy</a> | <a href="stayntouch.com/terms" style="color:#000; text-decoration:none;">Terms and Conditions</a></strong></td>
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
    ) if !key_delivery_email

  end
end