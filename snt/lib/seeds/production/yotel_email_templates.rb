#yotel_email_templates.rb
module SeedYotelEmailTemplates
  # encoding: utf-8
  def create_yotel_email_templates ( hotel_yotel = nil )
    
    hotel_yotel = Hotel.find_by_code('YLH') unless hotel_yotel
    theme = EmailTemplateTheme.find_or_create_by_name_and_code('Yotel London Heathrow', 'guestweb_yotel')

    # ---------------- EMAIL TEMPLATE FOR RESERVATION CONFIRMATION EMAIL   ---------------- #
    email_confirmation_template = EmailTemplate.where(title: 'CONFIRMATION', email_template_theme_id: theme.id).first
    email_confirmation_template = EmailTemplate.create(
    	title: 'CONFIRMATION',
    	subject: 'Confirmation of your Reservation #@confirm_no at @hotel_name',
    	body: '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
				<html xmlns="http://www.w3.org/1999/xhtml">
				    <head>
				      <title>Email Confirmation Mail</title>
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
				          .header-image{
				            margin: 0 auto;
				            width: 100%;
				            max-width: 619px;
				            max-height:186px;
				              
				          }
				          a:hover {
				            color: #0433ff;
				            text-decoration: none;
				          }
				          a {
				            color: #0433ff;
				            text-decoration: underline !important;
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
				            .header-image{
				                max-width:100% !important;
				                height:auto;
				                display:block;
				              }
				          td[class=emailcolsplit]{
				            width:100%!important; 
				            float:left!important;
				            padding-left:0!important;
				            max-width:430px !important;
				            border: 0px !important;
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
				               td[class=emailcolsplit]{
				                    width:100%!important; 
				                    float:left!important;
				                    padding-left:0!important;
				                    max-width:430px !important;
				                    border: 0px !important;
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
				        <table class="main-bg" align="center" cellspacing="0" cellpadding="0" border="0" style="background:#fff; font-family: Helvetica, Arial, sans-serif">
				            <tbody>
								 <tr>
									<td valign="top" align="center">
										<img  class="header-image" src="@template_logo">
									</td>
								 </tr>

				                <tr>
				                  <td style="padding:0px 3% 7px; font-family: Arial;color:  #54216b;font-size: 15px;font-weight: 700;line-height:35px;">CONFIRMATION NUMBER:@confirm_no</td>
				                </tr>
				                <tr>
				                    <td style="padding:0px 3% 7px;">
				                        <table class="main" align="left" cellspacing="0" cellpadding="0" border="0" width="100%">
				                        <tbody>
				                            <tr>
				                                <td class="emailcolsplit" align="left" valign="top" style="width:55%;padding:0px 3% 7px 0px; border-right:6px solid #ebebeb;">
				                                    <table class="main" align="left" cellspacing="0" cellpadding="0" border="0" width="100%">
				                                        <tbody>
				                                           <tr>
				                                                <td style="font-family: Arial;color: #54216b;font-size: 15px;font-weight: 700;line-height:35px;" colspan="2">RESERVATION DETAILS</td>
				                                            </tr>
				                                            <tr style="font-family: Arial;color:  #4d4d4d;font-size: 11px;font-weight: 700;line-height: 21px;">
				                                                <td style="width:50%;">Guest Name</td>
				                                                <td style="width:50%;">@guest_name</td>
				                                            </tr>
				                                            <tr style="font-family: Arial;color:  #4d4d4d;font-size: 11px;font-weight: 700;line-height: 21px;">
				                                                <td style="width:50%;">Arrival Date & Time</td>
				                                                <td style="width:50%;">@arrival_date @arrival_time</td>
				                                            </tr>
				                                            <tr style="font-family: Arial;color:  #4d4d4d;font-size: 11px;font-weight: 700;line-height: 21px;">
				                                                <td style="width:50%;">Departure Date & Time</td>
				                                                <td style="width:50%;">@departure_date @departure_time</td>
				                                            </tr>
				                                            <tr style="font-family: Arial;color:  #4d4d4d;font-size: 11px;font-weight: 700;line-height: 21px;">
				                                                <td style="width:50%;">Duration</td>
				                                                <td style="width:50%;">@duration</td>
				                                            </tr>
				                                            <tr style="font-family: Arial;color:  #4d4d4d;font-size: 11px;font-weight: 700;line-height: 21px;">
				                                                <td style="width:50%;">Cabin Type</td>
				                                                <td style="width:50%;">@room_type_desc</td>
				                                            </tr>
				                                            <tr style="font-family: Arial;color:  #4d4d4d;font-size: 11px;font-weight: 700;line-height: 21px;">
				                                                <td style="width:50%;">Total Stay Amount</td>
				                                                <td style="width:50%;">@hotel_currency@total_stay_cost</td>
				                                            </tr>
				                                            <tr>
				                                                <td colspan="2" style="font-family: Arial; color: rgb(77, 77, 77); font-size: 11px; font-weight: 700; line-height: 16px; width: 292px; height: auto; padding-top: 15px;">Please note, the cost above does not include any credit card or telephone booking fees advised during the booking process. These will be detailed on your invoice at check out.
				                                                </td>
				                                            </tr>
				                                            <tr>
				                                                <td style="padding:0px 3% 7px 0px; font-family: Arial;color: #54216b;font-size: 15px;font-weight: 700;line-height:35px;" colspan="2">LOCATION AND CONTACT</td>
				                                            </tr>
				                                            <tr>
				                                                <td style="font-family: Arial;color:  #4d4d4d;font-size: 11px;font-weight: 700;line-height: 16px;width: 173px;height: auto;" colspan="2">@hotel_name<br>@street<br>@city, @state<br>@country, @zipcode
				                                                </td>
				                                            </tr>
				                                            <tr>
				                                                <td style="font-family: Arial;color:  #4d4d4d;font-size: 11px;font-weight: 700;line-height: 16px;width: 290px;height: auto;padding-top: 15px;" colspan="2">@custom_confirm_text
				                                                </td>
				                                            </tr>
				                                        </tbody>
				                                    </table>
				                                </td>
				                                
				                                <td  class="emailcolsplit" align="right" valign="top" style="width:45%;padding: 0px 0px 7px 3%;">
				                                    <table class="main" align="left" cellspacing="0" cellpadding="0" border="0" width="100%">
				                                        <tbody>
				                                            <tr>
				                                                <td colspan="2" style=" font-family: Arial;color:  #54216b;font-size: 15px;font-weight: 700;
				                                                           line-height:35px;">YOUR CABIN</td>
				                                            </tr>
				                                            <tr>
				                                                <td style="font-family: Arial;color:  #4d4d4d;font-size: 11px;font-weight: 700;line-height: 16px;width: 288px;height: auto;" colspan="2">KEY THINGS YOU MIGHT WANT TO KNOW ABOUT YOUR CABIN
				                                                    <ul style="padding-left: 20px;">
				                                                        <li>Food and drink is available 24hrs INCLUDING FREE tea and coffee from The Galley. Food is delivered to your cabin in 15 minutes or prebooked for delivery, including 2 fast breakfast options.</li>
				                                                        <li> Ensuite bathroom with monsoon rain shower and complimentary sage and seaweed all over body wash.
				                                                            </li>
				                                                        <li>Free WiFi internet access.</li>
				                                                        <li>Flat screen TV with over 50 channels and 24 radio stations.</li>
				                                                    </ul>
				                                                    To change or cancel your booking or any other enquiries about your stay call customer service on +44 207 100 1100 or e-mail customer@yotel.com.<br><br>For more detailed information about your stay go to our website.<br><br>ENJOY YOUR STAY!
				                                                    </td>
				                                                </tr>
				                                            </tbody>
				                                        </table>
				                                    </td>
				                                </tr>
				                            </tbody>
				                        </table>
				                    </td>
				                </tr>
      							<tr>
									<td valign="top" align="center">
										<img  class="header-image" src="@location_image">
									</td>
								</tr>
				            </tbody>
				        </table>
				    
				    </body>
				</html>',
    	signature: '',
    	email_template_theme_id: theme.id
    ) if !email_confirmation_template
    hotel_yotel.email_templates << email_confirmation_template if hotel_yotel.present?  && hotel_yotel.email_templates.where('hotel_email_templates.email_template_id = ?', email_confirmation_template.id).count == 0
    # ---------------- EMAIL TEMPLATE FOR CHECKOUT EMAIL   ---------------- #
    checkout_email = EmailTemplate.where(title: 'CHECKOUT_EMAIL_TEXT', email_template_theme_id: theme.id).first
    checkout_email = EmailTemplate.create(
    title: 'CHECKOUT_EMAIL_TEXT',
    subject: 'Would you like to check out from your phone?',
    body: '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
			<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
			  <title>Late Checkouts Email</title>
			  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
			  <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0;" />
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
			                      <td align="center" valign="middle" style="font-family:Arial,Helvetica, sans-serif; font-size:22px; color:#000000; text-align:center; padding-top:23px; padding-bottom:23px;" class="header-space">Hello @first_name @last_name!</td>
			                    </tr>
			                    <tr>
			                      <td align="center" valign="middle" style="font-family:Arial,Helvetica, sans-serif; font-size:22px; color:#000000; text-align:center; padding-top:23px; padding-bottom:23px;" class="header-space">Click below to check out of your cabin. You may opt for a Late Check-Out, depending on availability.</td>
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
			                            <td align="center" valign="top" bgcolor="#FFFFFF" style="background:#DECEE8;">

			                              <table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
			                                <tr>
			                                  <td style="padding-top:17px; padding-bottom:17px; text-align:center; font-size:20px; color:#000000; font-family:Helvetica, Arial, sans-serif; "><a style="color:#55266b;" href="@url">VIEW CHECK OUT OPTIONS</a></td>
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
			                      <td style="padding:0px 6% 3px; color:#55266b;">Your @hotel_brand Team </td>
			                    </tr>
			                    <tr>
			                      <td style="padding:0px 6% 3px; color:#4868fe; font-size:12px;"><a>@from_address</a></td>
			                    </tr>
			                    <tr>
			                      <td style="padding:0px 6% 60px; color:#4868fe; font-size:12px;">@hotel_phone</td>
			                    </tr>
			                    <tr>
			                      <td align="center" valign="top" style="background:#af9f3b; font-size:12px; color:#ffcea9; padding:29px 0% 80px;"><!-- Footer Part Start-->

			                        <table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
			                          <tr>
			                            <td align="center" style="padding-bottom:10px;" >You @guest_email are receiving this email as part of your @hotel_name reservation. </td>
			                          </tr>
			                          <tr>
			                            <td align="center" style="padding-bottom:30px;">This is an automated message from @hotel_name - @address</td>
			                          </tr>
			                          <tr>
			                            <td align="center" style="padding-bottom:10px;">&copy;2014 @hotel_brand | All Rights Reserved.</td>
			                          </tr>
			                          <tr>
			                            <td align="center" style="padding-bottom:10px;">@hotel_address</td>
			                          </tr>
			                          <tr>
			                            <td align="center" style="padding-bottom:10px;"><strong><a href="stayntouch.com/privacy" style="color:#ffcea9; text-decoration:none;">Privacy Policy</a> | <a href="stayntouch.com/terms" style="color:#ffcea9; text-decoration:none;">Terms and Conditions</a></strong></td>
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

    hotel_yotel.email_templates << checkout_email if hotel_yotel.present? && hotel_yotel.email_templates.where('hotel_email_templates.email_template_id = ?', checkout_email.id).count == 0
    
    # ---------------- EMAIL TEMPLATE FOR LATE CHECKOUT EMAIL   ---------------- #
    late_checkout_email = EmailTemplate.where(title: 'LATE_CHECKOUT_EMAIL_TEXT', email_template_theme_id: theme.id).first
    late_checkout_email =  EmailTemplate.create(
    title: 'LATE_CHECKOUT_EMAIL_TEXT',
    subject: 'Would you like to stay a little longer?',
    body: '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
			<html xmlns="http://www.w3.org/1999/xhtml">
			<head>
			  <title>Late Checkouts Email</title>
			  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
			  <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0;" />
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
			                      <td align="center" valign="middle" style="font-family:Arial,Helvetica, sans-serif; font-size:22px; color:#000000; text-align:center; padding-top:23px; padding-bottom:23px;" class="header-space">Hello @first_name @last_name!</td>
			                    </tr>
			                    <tr>
			                      <td align="center" valign="middle" style="font-family:Arial,Helvetica, sans-serif; font-size:22px; color:#000000; text-align:center; padding-top:23px; padding-bottom:23px;" class="header-space">Click below to check out of your cabin. You may opt for a Late Check-Out, depending on availability.</td>
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
			                            <td align="center" valign="top" bgcolor="#FFFFFF" style="background:#DECEE8;">

			                              <table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
			                                <tr>
			                                  <td style="padding-top:17px; padding-bottom:17px; text-align:center; font-size:20px; color:#000000; font-family:Helvetica, Arial, sans-serif; "><a style="color:#55266b;" href="@url">VIEW CHECK OUT OPTIONS</a></td>
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
			                      <td style="padding:0px 6% 3px; color:#55266b;">Your @hotel_brand Team </td>
			                    </tr>
			                    <tr>
			                      <td style="padding:0px 6% 3px; color:#4868fe; font-size:12px;"><a>@from_address</a></td>
			                    </tr>
			                    <tr>
			                      <td style="padding:0px 6% 60px; color:#4868fe; font-size:12px;">@hotel_phone</td>
			                    </tr>
			                    <tr>
			                      <td align="center" valign="top" style="background:#af9f3b; font-size:12px; color:#ffcea9; padding:29px 0% 80px;"><!-- Footer Part Start-->

			                        <table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
			                          <tr>
			                            <td align="center" style="padding-bottom:10px;" >You @guest_email are receiving this email as part of your @hotel_name reservation. </td>
			                          </tr>
			                          <tr>
			                            <td align="center" style="padding-bottom:30px;">This is an automated message from @hotel_name - @address</td>
			                          </tr>
			                          <tr>
			                            <td align="center" style="padding-bottom:10px;">&copy;2014 @hotel_brand | All Rights Reserved.</td>
			                          </tr>
			                          <tr>
			                            <td align="center" style="padding-bottom:10px;">@hotel_address</td>
			                          </tr>
			                          <tr>
			                            <td align="center" style="padding-bottom:10px;"><strong><a href="stayntouch.com/privacy" style="color:#ffcea9; text-decoration:none;">Privacy Policy</a> | <a href="stayntouch.com/terms" style="color:#ffcea9; text-decoration:none;">Terms and Conditions</a></strong></td>
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

    hotel_yotel.email_templates << late_checkout_email if hotel_yotel.present? && hotel_yotel.email_templates.where('hotel_email_templates.email_template_id = ?', late_checkout_email.id).count == 0

  end
end