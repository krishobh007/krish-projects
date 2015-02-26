module SeedCarlyleEmailTemplates
  # encoding: utf-8
  def create_carlyle_email_templates(hotel = nil)
    
    theme = EmailTemplateTheme.find_or_create_by_name_and_code('Carlyle Suites', 'guestweb_carlyle')
    # ---------------------------  TEMPLATE FOR KEY DELIVERY EMAIL   --------------------------- #
    key_delivery_template = EmailTemplate.where(title: 'Key Delivery Email Text', email_template_theme_id: theme.id).first
    key_delivery_template = EmailTemplate.create(
      title: 'Key Delivery Email Text',
      subject: 'Welcome. Your room key',
      body: '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
                            <td align="center" valign="middle" bgcolor="#fff" style="background:#fff; padding:33px 0px 30px 0px; margin:0px auto; text-align:center;"><img src="@hotellogo" width="233" height="67" alt="" /></td>
                          </tr>
                        </table>
                        <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="container">
                          <tr>
                            <td align="center" valign="top" bgcolor="#FFFFFF" style="background:#FFF;"><table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="container">
                                <tr>
                                  <td align="center" valign="middle" style="font-family:Helvetica, Arial, sans-serif; font-size:22px; color:#000000; text-align:center; padding-top:23px; padding-bottom:23px;" class="header-space">Hello, @first_name.. Here is your key code:</td>
                                </tr>
                              </table></td>
                          </tr>
                        </table>

                        <!--  Header Part End-->

                        <!--  Text Part Start-->

                        <table border="0" align="center" cellpadding="0" cellspacing="0" >
                          <tr>

                            <!--  qrcode part Start-->
                            <td align="center" valign="middle" style="background:#59ade2; padding:27px 0px; border-bottom:1px solid #ffffff;">

                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td align="right" width="45%" ><img src="@key_icon" class="key" /></td>
                <td align="left" style="font-size: 1em; color:#ffffff; text-align:center; text-transform:uppercase; padding-right:25%; padding-left:5%; " width="55%" >room<br />
                                    <span style="font-size: 2.75em; text-align:center;">@room_number</span></td>
              </tr>
              <tr><td height="30"></td></tr>
              <tr>
                <td colspan="2" align="center" style="padding:0 20%;"><img src="@image_path" alt="" class="emailImage" /></td>
                </tr>
            </table>

                            </td>
                            <!--  qrcode part End-->

                          </tr>
                          <tr>
                            <td>

                            <table width="655" border="0" cellspacing="0" cellpadding="0" class="container">
                                <tr>
                                  <td align="center" valign="top" bgcolor="#FFFFFF" style="background:#e5f1fa;">

                                  <table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="container">
                                      <tr>
                                        <td style="padding-top:17px; padding-bottom:17px; text-align:center; font-size:15px; color:#000000; font-family:Helvetica, Arial, sans-serif; ">Can&#8217;t see the image above? <a href="@qr_link">Click here to open in webpage.</a></td>
                                      </tr>
                                    </table></td>
                                </tr>
                              </table></td>

                          </tr>
                          <tr>
                            <td align="left" valign="top"><!--  Text Start-->

                              <table width="600" border="0" align="center" cellpadding="0" cellspacing="0" style="font-family:Helvetica, Arial, sans-serif;" class="container">
                                <tr>
                                  <td width="30%" style="border-bottom:0.063em solid #dddddd; font-size:1.5em; color:#59ade2;padding-left: 0.188em;">Step 1:</td>
                                  <td style="padding:0.750em 1% 0.750em; border-bottom:1px solid #dddddd; font-size:16px; color:#231f20;padding-right: 0.188em;">Scan the QR code on this email at the kiosk located in the hotel lobby.</td>
                                </tr>
                                <tr>
                                  <td width="30%" style="border-bottom:0.063em solid #dddddd; font-size:1.5em; color:#59ade2;padding-left: 0.188em;">Step 2:</td>
                                  <td style="padding:0.750em 1% 0.750em; border-bottom:1px solid #dddddd; font-size:16px; color:#231f20;padding-right: 0.188em;">The kiosk will dispense your key(s).</td>
                                </tr>
                                <tr>
                                  <td width="30%" style="border-bottom:0.063em solid #dddddd; font-size:1.5em; color:#59ade2;padding-left: 0.188em;">Step 3:</td>
                                  <td style="padding:0.750em 1% 0.750em; border-bottom:1px solid #dddddd; font-size:16px; color:#231f20;padding-right: 0.188em;">Proceed to your room </td>
                                </tr>
                              </table>

                              <!--  Text End--></td>
                          </tr>
                        </table>

                        <!--  Text Part End--></td>
                    </tr>
                    <tr>
                      <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:left; font:normal 16px Arial, Helvetica, sans-serif; color:#3b3b3b; line-height:18px; padding:34px 6%;">Enjoy your stay! </td>
                    </tr>
                    <tr>
                      <td style="padding:0px 6% 7px;">Thanks,</td>
                    </tr>
                    <tr>
                      <td style="padding:0px  6% 1px; color:#fb8c33;">Your @hotel_brand Team </td>
                    </tr>
                    <tr>
                      <td style="padding:0px 6% 5px; color:#4868fe; font-size:12px;">@from_address</td>
                    </tr>
                    <tr>
                      <td style="padding:0px 6% 60px; color:#4868fe; font-size:12px;">@hotel_phone</td>
                    </tr>
                    <tr>
                      <td align="center" valign="top" style="background:#fb8c33; font-size:12px; color:#000; padding:29px 0% 80px;"><!--  Footer Part Start-->

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
    ) if !key_delivery_template

     # ---------------------------  TEMPLATE FOR CHECKOUT EMAIL   --------------------------- #
    checkout_email = EmailTemplate.where(title: 'CHECKOUT_EMAIL_TEXT', email_template_theme_id: theme.id).first
    checkout_email = EmailTemplate.create(
      title: 'CHECKOUT_EMAIL_TEXT',
      subject: 'Would you like to check out from your phone?',
      body: '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
              <td align="center" valign="middle" style="font-family:Helvetica, Arial, sans-serif; font-size:22px; color:#000000; text-align:center; padding-top:23px; padding-bottom:23px;" class="header-space">Hello @first_name @last_name!</td>
              </tr>
              <tr>
              <td align="center" valign="middle" style="font-family:Helvetica, Arial, sans-serif; font-size:22px; color:#000000; text-align:center; padding-top:23px; padding-bottom:23px;" class="header-space">Click below to check out of your room. You may opt for a Late Check-Out, depending on availability.</td>
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
              <td align="center" valign="top" bgcolor="#FFFFFF" style="background:#e5f1fa;">

              <table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
              <tr>
              <td style="padding-top:17px; padding-bottom:17px; text-align:center; font-size:15px; color:#000000; font-family:Helvetica, Arial, sans-serif; "><a href="@url">VIEW CHECK OUT OPTIONS</a></td>
              </tr>
              </table></td>
              </tr>
              </table></td>
              </tr>

              </table>

              <!-- Text Part End--></td>
              </tr>
              <tr>
              <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:left; font:normal 16px Arial, Helvetica, sans-serif; color:#3b3b3b; line-height:18px; padding:34px 6%;">Enjoy your stay! </td>
              </tr>
              <tr>
              <td style="padding:0px 6% 7px;">Thanks,</td>
              </tr>
              <tr>
              <td style="padding:0px 6% 3px; color:#fb8c33;">Your @hotel_brand Team </td>
              </tr>
              <tr>
              <td style="padding:0px 6% 3px; color:#4868fe; font-size:12px;">@from_address</td>
              </tr>
              <tr>
              <td style="padding:0px 6% 60px; color:#4868fe; font-size:12px;">@hotel_phone</td>
              </tr>
              <tr>
              <td align="center" valign="top" style="background:#fb8c33; font-size:12px; color:#ffcea9; padding:29px 0% 80px;"><!-- Footer Part Start-->

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
    
    # ---------------------------  TEMPLATE FOR LATE CHECKOUT EMAIL   --------------------------- #
    late_checkout_email =  EmailTemplate.where(title: 'LATE_CHECKOUT_EMAIL_TEXT', email_template_theme_id: theme.id).first
    late_checkout_email =  EmailTemplate.create(
      title: 'LATE_CHECKOUT_EMAIL_TEXT',
      subject: 'Would you like to stay a little longer?',
      body: '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
            <td align="center" valign="middle" style="font-family:Helvetica, Arial, sans-serif; font-size:22px; color:#000000; text-align:center; padding-top:23px; padding-bottom:23px;" class="header-space">Hello @first_name @last_name!</td>
            </tr>
            <tr>
            <td align="center" valign="middle" style="font-family:Helvetica, Arial, sans-serif; font-size:22px; color:#000000; text-align:center; padding-top:23px; padding-bottom:23px;" class="header-space">Click below to check out of your room. You may opt for a Late Check-Out, depending on availability.</td>
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
            <td align="center" valign="top" bgcolor="#FFFFFF" style="background:#e5f1fa;">

            <table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
            <tr>
            <td style="padding-top:17px; padding-bottom:17px; text-align:center; font-size:15px; color:#000000; font-family:Helvetica, Arial, sans-serif; "><a href="@url">VIEW CHECK OUT OPTIONS</a></td>
            </tr>
            </table></td>
            </tr>
            </table></td>
            </tr>

            </table>

            <!-- Text Part End--></td>
            </tr>
            <tr>
            <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:left; font:normal 16px Arial, Helvetica, sans-serif; color:#3b3b3b; line-height:18px; padding:34px 6%;">Enjoy your stay! </td>
            </tr>
            <tr>
            <td style="padding:0px 6% 7px;">Thanks,</td>
            </tr>
            <tr>
            <td style="padding:0px 6% 3px; color:#fb8c33;">Your @hotel_brand Team </td>
            </tr>
            <tr>
            <td style="padding:0px 6% 3px; color:#4868fe; font-size:12px;">@from_address</td>
            </tr>
            <tr>
            <td style="padding:0px 6% 60px; color:#4868fe; font-size:12px;">@hotel_phone</td>
            </tr>
            <tr>
            <td align="center" valign="top" style="background:#fb8c33; font-size:12px; color:#ffcea9; padding:29px 0% 80px;"><!-- Footer Part Start-->

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
    
     # ---------------------------  TEMPLATE FOR CHECKIN EMAIL   --------------------------- #
    checkin_email_template = EmailTemplate.where(title: 'CHECKIN_EMAIL_TEMPLATE', email_template_theme_id: theme.id).first
    checkin_email_template = EmailTemplate.create(
      title: 'CHECKIN_EMAIL_TEMPLATE',
      subject: 'Your room is ready for CHECK IN!',
      body: '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
                  <td align="center" valign="top" style="padding:0px 0px 0px 0px;"><!--  Main Table Start-->

                    <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                      <tr>
                        <td align="center" valign="top"><!--  Header Part Start-->

                          <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                            <tr>
                              <td align="center" valign="middle" bgcolor="#fff" style="background:#fff; padding:33px 0px 30px 0px; margin:0px auto; text-align:center;"><img src="@hotellogo" width="233" height="67" alt="" /></td>
                            </tr>
                          </table>
                          <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                            <tr>
                              <td align="center" valign="top" bgcolor="#FFFFFF" style="background:#FFF;"><table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                                  <tr>
                                    <td align="center" valign="middle" style="font-family:Helvetica, Arial, sans-serif; font-size:22px; color:#000000; text-align:center; padding-top:23px; padding-bottom:23px;" class="header-space">Hi @first_name @last_name!</td>
                                  </tr>
              <tr>
                                    <td align="center" valign="middle" style="font-family:Helvetica, Arial, sans-serif; font-size:22px; color:#000000; text-align:justify; padding-top:23px; padding-bottom:23px;" class="header-space">Welcome to the @hotel_name. You can checkin to your room as soon as you are ready right from your smartphone and collect the key from our room key dispenser located to the left of our front desk in the Lobby.</td>
                                  </tr>
                                </table></td>
                            </tr>
                          </table>

                          <!--  Header Part End-->

                          <!--  Text Part Start-->

                          <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                               <tr>

                              <!--  qrcode part Start-->
                              <td align="center" valign="top" style="background:#59ade2; padding:27px 0px; border-bottom:1px solid #ffffff;">

                              <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                                  <tr>

                                                         <td width="40%"  style="font-size: 4vmin; color:#ffffff; text-align:center; text-transform:uppercase; letter-spacing: 3vmin; ">room<br />
                                      <span style="font-size: 14vmin; letter-spacing:1vmin; text-align:center;">@room_number</span></td>

                                  </tr>
                                </table></td>
                              <!--  qrcode part End-->

                            </tr>
                            <tr>
                              <td>

                              <table width="655" border="0" cellspacing="0" cellpadding="0" class="main">
                                  <tr>
                                    <td align="center" valign="top" bgcolor="#FFFFFF" style="background:#e5f1fa;">

                                    <table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                                        <tr>
                                          <td style="padding-top:17px; padding-bottom:17px; text-align:center; font-size:15px; color:#000000; font-family:Helvetica, Arial, sans-serif; "><a href="@url">CLICK HERE TO CHECK IN NOW!</a></td>
                                        </tr>
                                      </table></td>
                                  </tr>
                                </table></td>
                            </tr>

                          </table>

                          <!--  Text Part End--></td>
                      </tr>
                      <tr>
                        <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:left; font:normal 16px Arial, Helvetica, sans-serif; color:#3b3b3b; line-height:18px; padding:34px 6%;">Enjoy your stay! </td>
                      </tr>
                      <tr>
                        <td style="padding:0px 6% 7px;">Thanks,</td>
                      </tr>
                      <tr>
                        <td style="padding:0px  6% 3px; color:#fb8c33;">Your @hotel_brand Team </td>
                      </tr>
                      <tr>
                        <td style="padding:0px 6% 3px; color:#4868fe; font-size:12px;">@from_address</td>
                        </tr>
                        <tr>
                        <td style="padding:0px 6% 60px; color:#4868fe; font-size:12px;">@hotel_phone</td>
                      </tr>
                      <tr>
                        <td align="center" valign="top" style="background:#fb8c33; font-size:12px; color:#ffcea9; padding:29px 0% 80px;"><!--  Footer Part Start-->

                          <table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
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
                              <td align="center" style="padding-bottom:10px;"><strong><a href="stayntouch.com/privacy" style="color:#ffcea9; text-decoration:none;">Privacy Policy</a> | <a href="stayntouch.com/terms" style="color:#ffcea9; text-decoration:none;">Terms and Conditions</a></strong></td>
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
    ) if !checkin_email_template
      
     
   
  end
end
