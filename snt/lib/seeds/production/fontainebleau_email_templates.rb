#fontainebleau_email_templates.rb
module SeedFontainebleauEmailTemplates
  # encoding: utf-8
  def create_fontainebleau_email_templates ( fontainebleau = nil )
    fontainebleau = Hotel.find_by_code('FBMB') unless fontainebleau
    theme = EmailTemplateTheme.find_or_create_by_name_and_code('Fontainebleau', 'guestweb_fontainebleau')
    # ---------------------------  TEMPLATE FOR PRE CHECKIN EMAIL   --------------------------- #
    pre_checkin_email = EmailTemplate.where( title: 'PRE_CHECKIN_EMAIL_TEXT', email_template_theme_id: theme.id).first
    pre_checkin_email = EmailTemplate.create(
	    title: 'PRE_CHECKIN_EMAIL_TEXT',
	    subject: 'Subject',
	    body: '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	            <html xmlns="http://www.w3.org/1999/xhtml">
	            <head>
	              <title>Pre Check-in Email</title>
	              <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	              <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0;" />
	              <meta name="format-detection" content="telephone=no">
	              <link href=\'http://fonts.googleapis.com/css?family=Source+Sans+Pro:300\' rel=\'stylesheet\' type=\'text/css\'>
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
	              @media only screen and (min-width:479px) {
	                .chek-in-message-mobile{
	                  display:none !important;
	                }
	                .padding-30{
	                  padding-left: 30px;
	                  padding-right: 30px;
	                }

	                .padding-40{
	                  padding-left: 40px;
	                  padding-right: 40px;
	                }
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
	                .chek-in-message{
	                  display:none !important;
	                }

	              }
	              </style>
	            </head>

	            <body>
	              <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="main-bg" style="background:#fff; font-family: Helvetica, Arial, sans-serif">
	                <tr>
	                  <td align="center" valign="top" style="padding:0px 0px 0px 0px;"><!-- Main Table Start-->

	                    <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
	                      <tr>
	                        <td align="center" valign="top"><!-- Header Part Start-->

	                          <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
	                            <tr>
	                              <td align="center" valign="middle" bgcolor="#fff" style="background:#fff; padding:33px 0px 30px 0px; margin:0px auto; text-align:center;"><img src="@hotellogo" width="233" height="67" alt="" /></td>
	                            </tr>
	                          </table>
	                          <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
	                            <tr>
	                              <td align="center" valign="top" bgcolor="#FFFFFF" style="background:#FFF;"><table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">

	                                <tr>
	                                  <td align="center" valign="middle" style="font-family:\'Arial\',Helvetica, sans-serif;  color:#000000; text-align:center;font-size:15px;padding-left:30px;padding-right:30px;"  class="header-space padding-30"><p style="text-align: left;
	                                    margin-bottom: 0px; color:#000000;font-weight:bold;">Dear @first_name @last_name,</p>
	                                    <p style="text-align: justify;margin-top: 7px;line-height:1.5em;">@pre_checkin_email_body</p>
	                                  </td>
	                                  </tr>
	                                </table></td>
	                              </tr>
	                            </table>

	                            <!-- Header Part End-->

	                            <!-- Text Part Start-->

	                            <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main" style="margin-top:5px;">
	                              <tr>
	                              </tr>
	                              <tr>
	                                <td>
	                                  <table width="655" border="0" cellspacing="0" cellpadding="0" class="main">
	                                    <tr>
	                                      <td align="center" valign="top" bgcolor="#FFFFFF" style="background:#2EAEEF;">
	                                          <table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
	                                            <tr>
	                                              <td style="padding-top:55px; padding-bottom:55px; text-align:center; font-size:46px; color:#2EAEEF; font-family: \'Source Sans Pro\', sans-serif;margin-top:5px;font-weight:light;"><a href="@url" style="color:#fff;text-decoration:none !important;font-weight: 300;">Begin Pre Check-in </a></td>
	                                            </tr>
	                                          </table>
	                                      </td>
	                                    </tr>
	                                  </table></td>
	                                </tr>
	                              </table>
	                              <table>
	                                <tr>
	                                  <td style="font-family:\'Arial\',Helvetica, sans-serif;font-size:14px;padding-top: 15px;color:#000;">Can\'t see the image above? <a style="color:#1539ff;" href="@url">Click here to open in webpage</a>
	                                  </td>
	                                </tr>
	                              </table>
	                              <table>
	                                <tr>
	                                  <td style="font-family:\'Arial\',Helvetica, sans-serif;font-size:15px;padding-top: 35px;color:#000;line-height:1.5em;padding-left:30px;padding-right:30px;" class="padding-30">
	                                    @pre_checkin_email_bottom_body
	                                  </td>
	                                </tr>
	                              </table>


	                              <!-- Text Part End--></td
	                            </tr>
	                            <tr>
	                              <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:left; font:normal 15px Arial, Helvetica, sans-serif; font-weight:400; color:#000; line-height:18px;padding:40px 30px;font-weight:bold;" class="padding-30"><p>Kind regards,</p>
	                                <p>@hotel_brand</p></td>
	                              </tr>
	                              <tr>
	                                <td align="center" valign="top" style="background:#7a7a7a; font-size:12px; color:#fff; padding:29px 0% 80px;"><!-- Footer Part Start-->
	                                  <table width="625" border="0" align="center" cellpadding="5" cellspacing="0" class="main">
	                                    <tr>
	                                      <td align="center" style="padding-bottom:10px;color:#fff; text-decoration:none;">You @guest_email are receiving this email as part of your @hotel_name reservation. </td>
	                                    </tr>
	                                    <tr>
	                                      <td align="center" style="padding-bottom:30px;color:#fff; text-decoration:none;">This is an automated message from @hotel_name - @address</td>
	                                    </tr>
	                                    <tr>
	                                      <td align="center" style="padding-bottom:10px;color:#fff;">&copy;2014 @hotel_brand | All Rights Reserved.</td>
	                                    </tr>
	                                    <tr>
	                                      <td align="center" style="padding-bottom:10px;color:#fff;">@hotel_address</td>
	                                    </tr>
	                                    <tr>
	                                      <td align="center" style="padding-bottom:10px;color:#fff;"><strong><a href="stayntouch.com/privacy" style="color:#fff; text-decoration:none;">Privacy Policy</a> | <a href="stayntouch.com/terms" style="color:#fff; text-decoration:none;">Terms and Conditions</a></strong></td>
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
    ) if !pre_checkin_email

    fontainebleau.email_templates << pre_checkin_email if fontainebleau.present?  && fontainebleau.email_templates.where('hotel_email_templates.email_template_id = ?', pre_checkin_email.id).count == 0
    
    # ---------------------------------- TEMPLATE FOR CHECKOUT EMAIL ---------------------------------- #
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
			  <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="main-bg" style="background:#fff; font-family: Helvetica, Arial, sans-serif">
			    <tr>
			      <td align="center" valign="top" style="padding:0px 0px 0px 0px;"><!-- Main Table Start-->

			        <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
			          <tr>
			            <td align="center" valign="top"><!-- Header Part Start-->

			              <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
			                <tr>
			                  <td align="center" valign="middle" bgcolor="#fff" style="background:#fff; padding:33px 0px 30px 0px; margin:0px auto; text-align:center;"><img src="@hotellogo" width="233" height="67" alt="" /></td>
			                </tr>
			              </table>
			              <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
			                <tr>
			                  <td align="center" valign="top" bgcolor="#FFFFFF" style="background:#FFF;"><table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">

			                    <tr>
			                      <td align="center" valign="middle" style="font-family:\'Arial\',Helvetica, sans-serif; font-size:16px; color:#000000; text-align:center; padding-top:23px; padding-bottom:23px;" class="header-space"> <b>Dear @first_name @last_name, </b>Click below to check-out of your Room. You may opt for a late check-out, depending on availability.</td>
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
			                        <td align="center" valign="top" bgcolor="#FFFFFF" style="background:#2EAEEF;">

			                          <table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
			                            <tr>
			                              <td style="padding-top:40px; padding-bottom:40px; text-align:center; font-size:26px; color:#2EAEEF; font-family: \'Source Sans Pro\', sans-serif;font-weight:300; "><a style="color:#fff;text-decoration:none !important;" href="@url">View Check-out options</a></td>
			                            </tr>
			                          </table></td>
			                        </tr>
			                      </table></td>
			                    </tr>
			                  </table>
			                  <!-- Text Part End--></td>
			                </tr>
			                <tr>
			                  <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:left; font:normal 15px Arial, Helvetica, sans-serif; font-weight:400; color:#3b3b3b; line-height:18px; padding:30px 6% 34px;"><b>Enjoy your stay!</b></td>
			                </tr>
			                <tr>
			                  <td style="padding:0px 6% 7px; font-size:13px;">Thanks,</td>
			                </tr>
			                <tr>
			                  <td style="padding:0px 6% 3px; color:#000;">Your @hotel_brand Team </td>
			                </tr>
			                <tr>
			                  <td style="padding:0px 6% 3px; color:#4868fe; font-size:12px;"><a>@from_address</a></td>
			                </tr>
			                <tr>
			                  <td style="padding:0px 6% 60px; color:#4868fe; font-size:12px;">@hotel_phone</td>
			                </tr>
			                <tr>
			                  <td align="center" valign="top" style="background:#7a7a7a; font-size:12px; color:#fff; padding:29px 0% 80px;"><!-- Footer Part Start-->
			                    <table width="625" border="0" align="center" cellpadding="5" cellspacing="0" class="main" style="font:normal Arial, Helvetica, sans-serif;">
			                      <tr>
			                        <td align="center" style="padding-bottom:10px;color:#fff;" >You @guest_email are receiving this email as part of your @hotel_name reservation. </td>
			                      </tr>
			                      <tr>
			                        <td align="center" style="padding-bottom:30px;color:#fff;">This is an automated message from @hotel_name - @address</td>
			                      </tr>
			                      <tr>
			                        <td align="center" style="padding-bottom:10px;color:#fff;">&copy;2014 @hotel_brand | All Rights Reserved.</td>
			                      </tr>
			                      <tr>
			                        <td align="center" style="padding-bottom:10px;color:#fff;">@hotel_address</td>
			                      </tr>
			                      <tr>
			                        <td align="center" style="padding-bottom:10px;"><strong><a href="stayntouch.com/privacy" style="color:#fff; text-decoration:none;">Privacy Policy</a> | <a href="stayntouch.com/terms" style="color:#fff; text-decoration:none;">Terms and Conditions</a></strong>
			                        </td>
			                      </tr>
			                    </table>
			                    <!-- Footer Part End-->
			                  </td>
			                </tr>
			              </table>
			              <!-- Main Table End-->
			            </td>
			          </tr>
			        </table>
			      </body>
			      </html>',
			    signature: '',
			    email_template_theme_id: theme.id
    ) if !checkout_email

    fontainebleau.email_templates << checkout_email if fontainebleau.present?  && fontainebleau.email_templates.where('hotel_email_templates.email_template_id = ?', checkout_email.id).count == 0
     
    # ---------------------------------- TEMPLATE FOR LATE CHECKOUT EMAIL ---------------------------------- #
    late_checkout_email =  EmailTemplate.where(title: 'LATE_CHECKOUT_EMAIL_TEXT', email_template_theme_id: theme.id).first
    late_checkout_email =  EmailTemplate.create(
	    title: 'LATE_CHECKOUT_EMAIL_TEXT',
	    subject: 'Would you like to stay a little longer?',
	    body: '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
			<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
			  <title> Late Check-out Email</title>
			  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
			  <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0;" />
			  <link href=\'http://fonts.googleapis.com/css?family=Source+Sans+Pro:300\' rel=\'stylesheet\' type=\'text/css\'>
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
			  <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="main-bg" style="background:#fff; font-family: Helvetica, Arial, sans-serif">
			    <tr>
			      <td align="center" valign="top" style="padding:0px 0px 0px 0px;"><!-- Main Table Start-->

			        <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
			          <tr>
			            <td align="center" valign="top"><!-- Header Part Start-->

			              <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
			                <tr>
			                  <td align="center" valign="middle" bgcolor="#fff" style="background:#fff; padding:33px 0px 30px 0px; margin:0px auto; text-align:center;"><img src="@hotellogo" width="233" height="67" alt="" /></td>
			                </tr>
			              </table>
			              <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
			                <tr>
			                  <td align="center" valign="top" bgcolor="#FFFFFF" style="background:#FFF;"><table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">

			                    <tr>
			                      <td align="center" valign="middle" style="font-family:\'Arial\',Helvetica, sans-serif; font-size:16px; color:#000000; text-align:center; padding-top:23px; padding-bottom:23px;" class="header-space"> <b>Dear @first_name @last_name, </b>Click below to check-out of your Room. You may opt for a late check-out, depending on availability.</td>
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
			                        <td align="center" valign="top" bgcolor="#FFFFFF" style="background:#2EAEEF;">

			                          <table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
			                            <tr>
			                              <td style="padding-top:40px; padding-bottom:40px; text-align:center; font-size:26px; color:#2EAEEF; font-family: \'Source Sans Pro\', sans-serif;font-weight:300; "><a style="color:#fff;text-decoration:none !important;" href="@url">View Check-out options</a></td>
			                            </tr>
			                          </table></td>
			                        </tr>
			                      </table></td>
			                    </tr>
			                  </table>
			                  <!-- Text Part End--></td>
			                </tr>
			                <tr>
			                  <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:left; font:normal 15px Arial, Helvetica, sans-serif; font-weight:400; color:#3b3b3b; line-height:18px; padding:30px 6% 34px;"><b>Enjoy your stay!</b></td>
			                </tr>
			                <tr>
			                  <td style="padding:0px 6% 7px; font-size:13px;">Thanks,</td>
			                </tr>
			                <tr>
			                  <td style="padding:0px 6% 3px; color:#000;">Your @hotel_brand Team </td>
			                </tr>
			                <tr>
			                  <td style="padding:0px 6% 3px; color:#4868fe; font-size:12px;"><a>@from_address</a></td>
			                </tr>
			                <tr>
			                  <td style="padding:0px 6% 60px; color:#4868fe; font-size:12px;">@hotel_phone</td>
			                </tr>
			                <tr>
			                  <td align="center" valign="top" style="background:#7a7a7a; font-size:12px; color:#fff; padding:29px 0% 80px;"><!-- Footer Part Start-->
			                    <table width="625" border="0" align="center" cellpadding="5" cellspacing="0" class="main" style="font:normal Arial, Helvetica, sans-serif;">
			                      <tr>
			                        <td align="center" style="padding-bottom:10px;color:#fff;" >You @guest_email are receiving this email as part of your @hotel_name reservation. </td>
			                      </tr>
			                      <tr>
			                        <td align="center" style="padding-bottom:30px;color:#fff;">This is an automated message from @hotel_name - @address</td>
			                      </tr>
			                      <tr>
			                        <td align="center" style="padding-bottom:10px;color:#fff;">&copy;2014 @hotel_brand | All Rights Reserved.</td>
			                      </tr>
			                      <tr>
			                        <td align="center" style="padding-bottom:10px;color:#fff;">@hotel_address</td>
			                      </tr>
			                      <tr>
			                        <td align="center" style="padding-bottom:10px;"><strong><a href="stayntouch.com/privacy" style="color:#fff; text-decoration:none;">Privacy Policy</a> | <a href="stayntouch.com/terms" style="color:#fff; text-decoration:none;">Terms and Conditions</a></strong>
			                        </td>
			                      </tr>
			                    </table>
			                    <!-- Footer Part End-->
			                  </td>
			                </tr>
			              </table>
			              <!-- Main Table End-->
			            </td>
			          </tr>
			        </table>
			      </body>
			      </html>',
			    signature: '',
			    email_template_theme_id: theme.id
    ) if !late_checkout_email

    fontainebleau.email_templates << late_checkout_email if fontainebleau.present?  && fontainebleau.email_templates.where('hotel_email_templates.email_template_id = ?', late_checkout_email.id).count == 0
   
  end
end