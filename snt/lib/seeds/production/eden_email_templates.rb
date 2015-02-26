#yotel_email_templates.rb
module SeedEdenEmailTemplates
  # encoding: utf-8
  def create_eden_email_templates ( hotel = nil )
    
    theme = EmailTemplateTheme.find_or_create_by_name_and_code('Eden Resort & Suites', 'guestweb_eden')
    
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
			            <tr style="text-align:center;
			            vertical-align: middle;height:80px;background: none repeat scroll 0 0 #000;">
			            <td><img src="@hotellogo" alt="" style="border: 0px;outline: none;  padding: 18px 0 18px;" /></td>
			          </tr>
			        </table>
			        <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
			          <tr>
			            <td align="center" valign="top" bgcolor="#FFFFFF" style="background:#FFF;"><table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
			              <td align="center" valign="middle" style="font-family: Arial ,Helvetica, sans-serif; font-size:21px; color:#000000; text-align:center;padding: 32px 55px 34.5px;line-height: 1.5;" class="header-space"><b>Hi @first_name!&nbsp;&nbsp;</b>Your On-line check-in is ready. You will be able to pick up your key in the lobby. <span style="color:#D0BE51;">Upgrades are available!</span></td>
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
			                <td align="center" valign="top" bgcolor="#FFFFFF" style="background-color:#C3AB01;">
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
			              <tr style="text-align:center; background:#F7F5E8;">
			                <td style="font-family: Arial ,Helvetica, sans-serif;font-size:14px;color:#000;padding:17px 0;">Can\'t see the image above? <a  href="@url">Click here to open in webpage</a>
			                </td>
			              </tr>
			            </table></td>
			          </tr>
			        </table>
			        <!-- Text Part End--></td>
			      </tr>
			      <tr>
			        <td style="padding:33px 6% 7px; font-size:17px;">Thanks,</td>
			      </tr>
			      <tr>
			        <td style="padding:0px 6% 3px;color:#000;font-size:18px;">@hotel_brand Team </td>
			      </tr>
			      <tr>
			        <td style="padding:0px 6% 75px;font-size:16px;"><a style="color:#95A4FD;">@from_address</a></td>
			      </tr>
			      <tr style="margin-top:65px;">
			        <td align="center" valign="top" style="background:#F7F5E8; font-size:12px; color:#000; padding:29px 0% 80px;width:655px;"><!-- Footer Part Start-->
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
			              <td align="center" style="padding-bottom:70px;"><strong><a href="stayntouch.com/privacy" style="color:#000 !important; text-decoration:none !important;">Privacy Policy</a> | <a href="stayntouch.com/terms" style="color:#000 !important; text-decoration:none !important; ">Terms and Conditions</a></strong></td>
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
			                <tr style="text-align:center;
			                vertical-align: middle;height:80px;background: none repeat scroll 0 0 #000;">
			                <td><img src="@hotellogo" alt="" style="border: 0px;outline: none;  padding: 18px 0 18px;" /></td>
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
			                    <td align="center" valign="top" bgcolor="#FFFFFF" style="background-color:#C3AB01;">
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
			                  <tr style="text-align:center; background:#F7F5E8;">
			                    <td style="font-family: Arial,Helvetica, sans-serif;font-size:14px;color:#000;padding:17px 0;">Can\'t see the image above? <a  href="@url">Click here to open in webpage</a>
			                    </td>
			                  </tr>
			                </table></td>
			              </tr>
			            </table>
			            <!-- Text Part End--></td>
			          </tr>
			          <tr>
			            <td style="padding:33px 6% 7px; font-size:17px;font-family: Arial ,Helvetica, sans-serif;">Thanks,</td>
			          </tr>
			          <tr>
			            <td style="padding:0px 6% 3px;color:#000;font-size:18px;font-family: Arial ,Helvetica, sans-serif;">@hotel_brand Team </td>
			          </tr>
			          <tr>
			            <td style="padding:0px 6% 75px;font-size:16px;font-family: Arial ,Helvetica, sans-serif;"><a href="" style="color:#95a4fd;;">@from_address</a></td>
			          </tr>
			          <tr style="margin-top:65px;">
			            <td align="center" valign="top" style="background:#F7F5E8; font-size:12px; color:#000; padding:29px 0% 80px;width:655px;"><!-- Footer Part Start-->

			              <table width="625" border="0" align="center" cellpadding="5" cellspacing="0" class="main" style="font:normal Arial, Helvetica, sans-serif;">
			                <tr>
			                  <td align="center" style="padding-bottom:10px;color:#000;font-family: Arial ,Helvetica, sans-serif;" >You @guest_email are receiving this email as part of your @hotel_name reservation. </td>
			                </tr>
			                <tr>
			                  <td align="center" style="padding-bottom:30px;color:#000;font-family: Arial ,Helvetica, sans-serif;">This is an automated message from @hotel_name - @address</td>
			                </tr>
			                <tr>
			                  <td align="center" style="padding-bottom:10px;color:#000;font-family: Arial ,Helvetica, sans-serif;">&copy;2014 @hotel_brand | All Rights Reserved.</td>
			                </tr>
			                <tr>
			                  <td align="center" style="padding-bottom:10px;color:#000;font-family: Arial ,Helvetica, sans-serif;">@hotel_address</td>
			                </tr>
			                <tr>
			                  <td align="center" style="padding-bottom:70px;"><strong><a href="stayntouch.com/privacy" style="color:#000 !important; text-decoration:none !important;font-family: Arial ,Helvetica, sans-serif;">Privacy Policy</a> | <a href="stayntouch.com/terms" style="color:#000 !important; text-decoration:none !important;font-family: Arial ,Helvetica, sans-serif;">Terms and Conditions</a></strong></td>
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
			                <tr style="text-align:center;
			                vertical-align: middle;height:80px;background: none repeat scroll 0 0 #000;">
			                <td><img src="@hotellogo" alt="" style="border: 0px;outline: none;  padding: 18px 0 18px;" /></td>
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
			                    <td align="center" valign="top" bgcolor="#FFFFFF" style="background-color:#C3AB01;">
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
			                  <tr style="text-align:center; background:#F7F5E8;">
			                    <td style="font-family: Arial,Helvetica, sans-serif;font-size:14px;color:#000;padding:17px 0;">Can\'t see the image above? <a  href="@url">Click here to open in webpage</a>
			                    </td>
			                  </tr>
			                </table></td>
			              </tr>
			            </table>
			            <!-- Text Part End--></td>
			          </tr>
			          <tr>
			            <td style="padding:33px 6% 7px; font-size:17px;font-family: Arial ,Helvetica, sans-serif;">Thanks,</td>
			          </tr>
			          <tr>
			            <td style="padding:0px 6% 3px;color:#000;font-size:18px;font-family: Arial ,Helvetica, sans-serif;">@hotel_brand Team </td>
			          </tr>
			          <tr>
			            <td style="padding:0px 6% 75px;font-size:16px;font-family: Arial ,Helvetica, sans-serif;"><a href="" style="color:#95A4FD;">@from_address</a></td>
			          </tr>
			          <tr style="margin-top:65px;">
			            <td align="center" valign="top" style="background:#F7F5E8; font-size:12px; color:#000; padding:29px 0% 80px;width:655px;"><!-- Footer Part Start-->

			              <table width="625" border="0" align="center" cellpadding="5" cellspacing="0" class="main" style="font:normal Arial, Helvetica, sans-serif;">
			                <tr>
			                  <td align="center" style="padding-bottom:10px;color:#fff;font-family: Arial ,Helvetica, sans-serif;" >You @guest_email are receiving this email as part of your @hotel_name reservation. </td>
			                </tr>
			                <tr>
			                  <td align="center" style="padding-bottom:30px;color:#000;font-family: Arial ,Helvetica, sans-serif;">This is an automated message from @hotel_name - @address</td>
			                </tr>
			                <tr>
			                  <td align="center" style="padding-bottom:10px;color:#000;font-family: Arial ,Helvetica, sans-serif;">&copy;2014 @hotel_brand | All Rights Reserved.</td>
			                </tr>
			                <tr>
			                  <td align="center" style="padding-bottom:10px;color:#000;font-family: Arial ,Helvetica, sans-serif;">@hotel_address</td>
			                </tr>
			                <tr>
			                  <td align="center" style="padding-bottom:70px;"><strong><a href="stayntouch.com/privacy" style="color:#000 !important; text-decoration:none !important;font-family: Arial ,Helvetica, sans-serif;">Privacy Policy</a> | <a href="stayntouch.com/terms" style="color:#000 !important; text-decoration:none !important;font-family: Arial ,Helvetica, sans-serif;">Terms and Conditions</a></strong></td>
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

    key_delivery_email = EmailTemplate.where(title: 'Key Delivery Email Text', email_template_theme_id: theme.id).first
	key_delivery_email = EmailTemplate.create(
	    title: 'Key Delivery Email Text',
	    subject: 'From StayNTouch: Your API Key',
	    body:   '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
				<html xmlns="http://www.w3.org/1999/xhtml">
				<head>
				  <title>Mail QR Code</title>
				  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
				  <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0;" />
				  <style type="text/css">
				  body {
				    width: 100%;
				    margin: 0px;
				    padding: 0px;
				    background: #3b3b3b;
				    text-align: left;
				    }html {
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

				    /* ----------- responsivity ----------- */
				    @media only screen and (max-width: 620px){
				      .main {
				        width: 100% !important;
				        margin: 0px;
				        padding: 0px;
				      }

				      /*------ top header ------ */

				      .container{width: 100% !important;}
				      .container-middle{width: 100% !important;}
				      .mainContent{width: 100% !important;}

				      /*------ sections ---------*/
				      .section-item{width: 100% !important;}
				      .key{
				        height:auto !important;
				        max-width:104px !important;
				        width: 100% !important;
				      }

				      .emailImage{
				        height:auto !important;
				        max-width:239px !important;
				        width: 100% !important;
				      }

				    }

				    @media only screen and (max-width: 480px){
				      .main {
				        width: 100% !important;
				        margin: 0px;
				        padding: 0px;
				      }

				      .container{width: 100% !important;}
				      .container-middle{width: 100% !important;}
				      .mainContent{width: 100% !important;}

				      /*------ sections ---------*/
				      .section-item{width: 100% !important;}
				      .key{

				        height:auto !important;
				        max-width:64px !important;
				        width: 100% !important;
				      }
				      .emailImage{
				        height:auto !important;
				        max-width:239px !important;
				        width: 100% !important;
				      }

				    }

				    </style>
				  </head>

				  <body>
				    <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="main-bg" style="background:#fff; font-family: Helvetica, Arial, sans-serif">
				      <tr>
				        <td align="center" valign="top" style="padding:0px 0px 0px 0px;"><!--  Main Table Start-->

				          <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="container">
				            <tr>
				              <td align="center" valign="top"><!--  Header Part Start-->

				                <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="container">
				                  <tr>
				                    <td align="center" valign="middle" bgcolor="#000" style="background:#000; padding:33px 0px 30px 0px; margin:0px auto; text-align:center;"><img src="@hotellogo" width="233" height="67" alt="" /></td>
				                  </tr>
				                </table>
				                <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="container">
				                  <tr>
				                    <td align="center" valign="top" bgcolor="#FFFFFF" style="background:#FFF;"><table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="container">
				                      <tr>
				                        <td align="center" valign="middle" style="font-family:Helvetica, Arial, sans-serif; font-size:19px; color:#000000; text-align:center; padding-top:23px; padding-bottom:23px;" class="header-space"><strong>Hi @first_name !</strong> You are checked in. Your room is:</td>
				                      </tr>
				                    </table></td>
				                  </tr>
				                </table><!--  Header Part End-->

				                <!--  Text Part Start-->

				                <table border="0" align="center" cellpadding="0" cellspacing="0" >
				                  <tr>

				                    <!--  qrcode part Start-->
				                    <td align="center" valign="middle" style="background:#A99A6F; padding:27px 0px; border-bottom:1px solid #ffffff;">

				                      <table width="655" border="0" cellspacing="0" cellpadding="0">
				                        <tr>
				                          <td align="left" style="font-size: 24px; color:#ffffff; text-align:center; text-transform:uppercase;" width="55%" >room<br />
				                            <span style="font-size: 63px; text-align:center;">@room_number</span></td>
				                          </tr>
				                        </table>

				                      </td>
				                      <!--  qrcode part End-->

				                    </tr>
				                      </table>

				                      <!--  Text Part End--></td>
				                    </tr>
				                     <tr>
				                      <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="container">
				                  <tr>
				                    <td align="center" valign="top" bgcolor="#FFFFFF" style="background:#FFF;"><table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="container">
				                      <tr>
				                        <td align="center" style="padding:50px 10px 0px 150px;"><img src="@key_black" class="key" /></td>
				                      <td align="center" style="padding:50px 150px 0px 10px;font-size:19px;text-align:left;">Scan the QR code at the lobby kiosk to get your key:</td>
				                      </tr>
				                    </table>
				                     
				                    </tr>
				                    <tr>
				                     <td colspan="2" align="center" style="padding:5% 20%;"><img src="@image_path" alt="" class="emailImage"  style="width:250px;" /></td>
				                    </tr>
				                    <tr>
				                      <td style="padding:50px 6% 7px;">Thanks,</td>
				                    </tr>
				                    <tr>
				                      <td style="padding:0px  6% 1px;">Your @hotel_brand Team </td>
				                    </tr>
				                    <tr>
				                      <td style="padding:0px 6% 5px; color:#4868fe; font-size:12px;">@from_address</td>
				                    </tr>
				                    <tr>
				                      <td style="padding:0px 6% 60px; color:#4868fe; font-size:12px;">@hotel_phone</td>
				                    </tr>
				                    <tr>
				                      <td align="center" valign="top" style="background:#F7F5E8; font-size:12px; color:#000; padding:29px 0% 80px;"><!--  Footer Part Start-->

				                        <table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="container">
				                          <tr>
				                            <td align="center" style="padding-bottom:10px;" >You @guest_email are receiving this email as part of your @hotel_name reservation. </td>
				                          </tr>
				                          <tr>
				                            <td align="center" style="padding-bottom:30px;">This is an automated message from  @hotel_name  - @address</td>
				                          </tr>
				                          <tr>
				                            <td align="center"  style="padding-bottom:10px;">&copy;2014 @hotel_brand | All Rights Reserved.</td>
				                          </tr>
				                          <tr>
				                            <td align="center" style="padding-bottom:10px;">@hotel_address</td>
				                          </tr>
				                          <tr>
				                            <td align="center" style="padding-bottom:10px;"><strong><a href="http://stayntouch.com/privacy" style="color:#fff; text-decoration:none;">Privacy Policy</a> | <a href="http://stayntouch.com/terms" style="color:#fff; text-decoration:none;">Terms and Conditions</a></strong></td>
				                          </tr>
				                        </table>

				                        <!--  Footer Part End--></td>
				                      </tr>
				                    </table>

				                    <!--  Main Table End--></td>
				                  </tr>
				                </table>
				              </body>
				              </html>',
	    signature: '',
	    email_template_theme_id: theme.id
    ) if !key_delivery_email
  end
end