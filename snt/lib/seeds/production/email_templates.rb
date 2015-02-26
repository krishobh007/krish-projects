module SeedEmailTemplates
  # encoding: utf-8
  def create_email_templates
    email_template2 = EmailTemplate.create(
    title: 'Hotel Admin Invitation Email Text',
    subject: 'From StayNTouch: Welcome to Rover. Please activate your user account.',
    body: '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Mail SNT To Hotel</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0;" />
<style type="text/css">
body {
  width: 100%;
  margin: 0px;
  padding: 0px;
  background: #fff;
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

table {
  border-collapse: collapse;
  mso-table-lspace: 0pt;
  mso-table-rspace: 0pt;
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
                <td valign="middle" bgcolor="#fff" style="background:#fff; padding:29px 3% 21px 0px; margin:0px auto;"><img src="@snt_logo"  alt="StayNTouch" /></td>
              </tr>
            </table>
            <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
              <tr>
                <td align="center" valign="top" bgcolor="#f7f7f7" style="background:#f7f7f7;"><table width="590" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                    <tr>
                      <td align="center" valign="middle" style="font-family:Helvetica, Arial, sans-serif; text-transform:uppercase;  font-size:18px; color:#565656; text-align:center; padding-top:24px; padding-bottom:20px;" class="header-space">@hotel_name</td>
                    </tr>
                  </table></td>
              </tr>
            </table>
            </td>
            <!--  Header Part End-->
          </tr>
        <tr>
          <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:left; font:normal 22px Arial, Helvetica, sans-serif; color:#231f20; line-height:18px; padding:44px 5% 24px;">Dear <span style=" text-transform: capitalize;">@first_name</span>, </td>
        </tr>
        <tr>
          <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:left; font:normal 16px Arial, Helvetica, sans-serif; color:#231f20; line-height:22px; padding:0px 5% 19px;"> Welcome to StayNTouch! You have been setup as the administrator of your hotel. Please click on below link to sign in and start configuring your StayNTouch application.  </td>
        </tr>
        <tr>
                <td align="center" valign="top" bgcolor="#fff" >
                <table width="590" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                    <tr>
                      <td align="center" valign="middle" style="font-family:Helvetica, Arial, sans-serif;font-size:18px; color:#565656; text-align:center; padding-top:30px; padding-bottom:30px; background:#e5f1fa;" class="header-space"><a href="@url">Click Here to Activate Your Account</a></td>
                    </tr>
                  </table></td>
              </tr>
        <tr>
          <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:left; font:normal 16px Arial, Helvetica, sans-serif; color:#231f20; line-height:22px; padding:24px 5% 24px;">Let us know if you have any questions and thank you for using StayNTouch!</td>
        </tr>
        <tr>
          <td style="padding:0px  5% 1px; color:#fb8c33;">Your StaynTouch Team!</td>
        </tr>
        <tr>
          <td style="padding:0px 5% 72px; color:#4868fe; font-size:12px;"><a href="#">@from_address</a></td>
        </tr>
        <tr>
          <td align="center" valign="top" style="background:#fb8c33; font-size:12px; color:#ffcea9; padding:29px 0% 80px;"><!--  Footer Part Start-->

            <table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
              <tr>
                <td align="center" style="padding-bottom:10px;" >You @user_email are receiving this email as part of your StayNTouch Inc. Relationship.  </td>
              </tr>
              <tr>
                <td align="center" style="padding-bottom:30px;">This is an automated message from StayNTouch, Inc.  - <a href="mailto" style="color:#ffcea9; text-decoration:none;">@address</a></td>
              </tr>
              <tr>
                <td align="center"  style="padding-bottom:10px;">&copy; 2014 StaynTouch, Inc. | All Rights Reserved.</td>
              </tr>
              <tr>
                <td align="center" style="padding-bottom:10px;">StayNTouch, Inc. - 8120 Woodmont Avenue, Suite 440, Bethesda, MD 20814, USA</td>
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
    signature: ''
    )

user_unlock_email_template = EmailTemplate.create(
    title: 'Unlock a User Email Text',
    subject: 'From StayNTouch: Welcome to Rover. Your account is unlocked.',
    body: '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Mail SNT To Hotel</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0;" />
<style type="text/css">
body {
  width: 100%;
  margin: 0px;
  padding: 0px;
  background: #fff;
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

table {
  border-collapse: collapse;
  mso-table-lspace: 0pt;
  mso-table-rspace: 0pt;
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
                <td valign="middle" bgcolor="#fff" style="background:#fff; padding:29px 3% 21px 0px; margin:0px auto;"><img src="@snt_logo"  alt="StayNTouch" /></td>
              </tr>
            </table>
            <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
              <tr>
                <td align="center" valign="top" bgcolor="#f7f7f7" style="background:#f7f7f7;"><table width="590" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                    <tr>
                      <td align="center" valign="middle" style="font-family:Helvetica, Arial, sans-serif; text-transform:uppercase;  font-size:18px; color:#565656; text-align:center; padding-top:24px; padding-bottom:20px;" class="header-space">@hotel_name</td>
                    </tr>
                  </table></td>
              </tr>
            </table>
            </td>
            <!--  Header Part End-->
          </tr>
        <tr>
          <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:left; font:normal 22px Arial, Helvetica, sans-serif; color:#231f20; line-height:18px; padding:44px 5% 24px;">Dear <span style=" text-transform: capitalize;">@first_name</span>, </td>
        </tr>
        <tr>
          <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:left; font:normal 16px Arial, Helvetica, sans-serif; color:#231f20; line-height:22px; padding:0px 5% 19px;"> This is your temporary password : <b> @password </b> . Click the link below to set your password. </td>
        </tr>
        <tr>
                <td align="center" valign="top" bgcolor="#fff" >
                <table width="590" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                    <tr>
                      <td align="center" valign="middle" style="font-family:Helvetica, Arial, sans-serif;font-size:18px; color:#565656; text-align:center; padding-top:30px; padding-bottom:30px; background:#e5f1fa;" class="header-space"><a href="@url">Click Here to Unlock Your Account</a></td>
                    </tr>
                  </table></td>
              </tr>
        <tr>
          <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:left; font:normal 16px Arial, Helvetica, sans-serif; color:#231f20; line-height:22px; padding:24px 5% 24px;">Let us know if you have any questions and thank you for using StayNTouch!</td>
        </tr>
        <tr>
          <td style="padding:0px  5% 1px; color:#fb8c33;">Your StaynTouch Team!</td>
        </tr>
        <tr>
          <td style="padding:0px 5% 72px; color:#4868fe; font-size:12px;"><a href="#">@from_address</a></td>
        </tr>
        <tr>
          <td align="center" valign="top" style="background:#fb8c33; font-size:12px; color:#ffcea9; padding:29px 0% 80px;"><!--  Footer Part Start-->

            <table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
              <tr>
                <td align="center" style="padding-bottom:10px;" >You @user_email are receiving this email as part of your StayNTouch Inc. Relationship.  </td>
              </tr>
              <tr>
                <td align="center" style="padding-bottom:30px;">This is an automated message from StayNTouch, Inc.  - <a href="mailto" style="color:#ffcea9; text-decoration:none;">@address</a></td>
              </tr>
              <tr>
                <td align="center"  style="padding-bottom:10px;">&copy; 2014 StaynTouch, Inc. | All Rights Reserved.</td>
              </tr>
              <tr>
                <td align="center" style="padding-bottom:10px;">StayNTouch, Inc. - 8120 Woodmont Avenue, Suite 440, Bethesda, MD 20814, USA</td>
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
    signature: ''
    )

    emailtemplate3 = EmailTemplate.create(
    title: 'API Key Text',
    subject: 'From StayNTouch: Your API Key',
    body: '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Mail SNT To Hotel</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0;" />
<style type="text/css">
body {
  width: 100%;
  margin: 0px;
  padding: 0px;
  background: #fff;
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

table {
  border-collapse: collapse;
  mso-table-lspace: 0pt;
  mso-table-rspace: 0pt;
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
                <td valign="middle" bgcolor="#fff" style="background:#fff; padding:29px 3% 21px 0px; margin:0px auto; "><img src="@snt_logo" alt="" /></td>
              </tr>
            </table>
            </td>
            <!--  Header Part End-->
          </tr>
        <tr>
          <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:left; font:normal 22px Arial, Helvetica, sans-serif; color:#231f20; line-height:18px; padding:44px 5% 24px;">Dear <span style=" text-transform: capitalize;">@first_name</span>, </td>
        </tr>
        <tr>
          <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:left; font:normal 16px Arial, Helvetica, sans-serif; color:#231f20; line-height:22px; padding:0px 5% 19px;"> Welcome to StayNTouch! Thank you for registering! Your API Key details follows:</td>
        </tr>
        <tr>
                <td align="center" valign="top" bgcolor="#fff" >
                <table width="590" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                    <tr>
                      <td align="center" valign="middle" style="font-family:Helvetica, Arial, sans-serif;font-size:18px; color:#565656; text-align:center; padding-top:30px; padding-bottom:30px; background:#e5f1fa;" class="header-space">Key : @api_key <br />
Expiry : @api_key_expiry </td>
                    </tr>
                  </table></td>
              </tr>

        <tr>
          <td style="padding:0px  5% 1px; color:#fb8c33;">Your StaynTouch Team!</td>
        </tr>
        <tr>
          <td style="padding:0px 5% 72px; color:#4868fe; font-size:12px;"><a href="#">@from_address</a></td>
        </tr>
        <tr>
          <td align="center" valign="top" style="background:#fb8c33; font-size:12px; color:#ffcea9; padding:29px 0% 80px;"><!--  Footer Part Start-->

            <table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
              <tr>
                <td align="center" style="padding-bottom:10px;" >You @user_email are receiving this email as part of your StayNTouch Inc. Relationship.  </td>
              </tr>
              <tr>
                <td align="center" style="padding-bottom:30px;">This is an automated message from StayNTouch, Inc.  - <a href="mailto" style="color:#ffcea9; text-decoration:none;">@address</a></td>
              </tr>
              <tr>
                <td align="center"  style="padding-bottom:10px;">&copy; 2014 StaynTouch, Inc. | All Rights Reserved.</td>
              </tr>
              <tr>
                <td align="center" style="padding-bottom:10px;">StayNTouch, Inc. - 8120 Woodmont Avenue, Suite 440, Bethesda, MD 20814, USA</td>
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
    signature: ''
    )

    emailtemplate4 = EmailTemplate.create(
    title: 'Activation Email Text',
    subject: 'From StayNTouch: Your account has been activated',
    body: '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Mail SNT To Hotel</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0;" />
<style type="text/css">
body {
  width: 100%;
  margin: 0px;
  padding: 0px;
  background: #fff;
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

table {
  border-collapse: collapse;
  mso-table-lspace: 0pt;
  mso-table-rspace: 0pt;
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
                <td valign="middle" bgcolor="#fff" style="background:#fff; padding:29px 3% 21px 0px; margin:0px auto;"><img src="@snt_logo"  alt="StayNTouch" /></td>
              </tr>
            </table>
            <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
              <tr>
                <td align="center" valign="top" bgcolor="#f7f7f7" style="background:#f7f7f7;"><table width="590" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                    <tr>
                      <td align="center" valign="middle" style="font-family:Helvetica, Arial, sans-serif; text-transform:uppercase;  font-size:18px; color:#565656; text-align:center; padding-top:24px; padding-bottom:20px;" class="header-space">@hotel_name</td>
                    </tr>
                  </table></td>
              </tr>
            </table>
            </td>
            <!--  Header Part End-->
          </tr>
        <tr>
          <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:left; font:normal 22px Arial, Helvetica, sans-serif; color:#231f20; line-height:18px; padding:44px 5% 24px;">Dear <span style=" text-transform: capitalize;">@first_name</span>, </td>
        </tr>
        <tr>
          <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:left; font:normal 16px Arial, Helvetica, sans-serif; color:#231f20; line-height:22px; padding:0px 5% 19px;"> Welcome to Rover! Your account has now been activated.</td>
        </tr>

        <tr>
          <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:left; font:normal 16px Arial, Helvetica, sans-serif; color:#231f20; line-height:22px; padding:0px 5% 24px;">Enjoy your new Rover account.</td>
        </tr>
        <tr>
          <td style="padding:0px  5% 1px; color:#fb8c33;">Your StaynTouch Team!</td>
        </tr>
        <tr>
          <td style="padding:0px 5% 72px; color:#4868fe; font-size:12px;"><a href="#">@from_address</a></td>
        </tr>
        <tr>
          <td align="center" valign="top" style="background:#fb8c33; font-size:12px; color:#ffcea9; padding:29px 0% 80px;"><!--  Footer Part Start-->

            <table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
              <tr>
                <td align="center" style="padding-bottom:10px;" >You @user_email are receiving this email as part of your StayNTouch Inc. Relationship.  </td>
              </tr>
              <tr>
                <td align="center" style="padding-bottom:30px;">This is an automated message from StayNTouch, Inc.  - <a href="mailto" style="color:#ffcea9; text-decoration:none;">@address</a></td>
              </tr>
              <tr>
                <td align="center"  style="padding-bottom:10px;">&copy; 2014 StaynTouch, Inc. | All Rights Reserved.</td>
              </tr>
              <tr>
                <td align="center" style="padding-bottom:10px;">StayNTouch, Inc. - 8120 Woodmont Avenue, Suite 440, Bethesda, MD 20814, USA</td>
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
    signature: ''
    )

    email_template5 = EmailTemplate.create(
    title: 'User Invitation Email Text',
    subject: 'From StayNTouch: Welcome to Rover. Please activate your user account.',
    body: '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Mail SNT To Hotel</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0;" />
<style type="text/css">
body {
  width: 100%;
  margin: 0px;
  padding: 0px;
  background: #fff;
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

table {
  border-collapse: collapse;
  mso-table-lspace: 0pt;
  mso-table-rspace: 0pt;
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
                <td valign="middle" bgcolor="#fff" style="background:#fff; padding:29px 3% 21px 0px; margin:0px auto; "><img src="@snt_logo" alt="" /></td>
              </tr>
            </table>
            <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
              <tr>
                <td align="center" valign="top" bgcolor="#f7f7f7" style="background:#f7f7f7;"><table width="590" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                    <tr>
                      <td align="center" valign="middle" style="font-family:Helvetica, Arial, sans-serif; text-transform:uppercase;  font-size:18px; color:#565656; text-align:center; padding-top:24px; padding-bottom:20px;" class="header-space">@hotel_name</td>
                    </tr>
                  </table></td>
              </tr>
            </table>
            </td>
            <!--  Header Part End-->
          </tr>
        <tr>
          <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:left; font:normal 22px Arial, Helvetica, sans-serif; color:#231f20; line-height:18px; padding:44px 5% 24px;">Dear <span style=" text-transform: capitalize;">@first_name</span>, </td>
        </tr>
        <tr>
          <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:left; font:normal 16px Arial, Helvetica, sans-serif; color:#231f20; line-height:22px; padding:0px 5% 19px;"> Welcome to StayNTouch! You have been setup as a user for your hotel in Rover. Please click on below link to sign in and start using your StayNTouch application. When prompted please update your password!  </td>
        </tr>
        <tr>
                <td align="center" valign="top" bgcolor="#fff" >
                <table width="590" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                    <tr>
                      <td align="center" valign="middle" style="font-family:Helvetica, Arial, sans-serif;font-size:18px; color:#565656; text-align:center; padding-top:30px; padding-bottom:30px; background:#e5f1fa;" class="header-space"><a href="@url">Click Here to Activate Your Account</a></td>
                    </tr>
                  </table></td>
              </tr>
        <tr>
          <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:left; font:normal 16px Arial, Helvetica, sans-serif; color:#231f20; line-height:22px; padding:24px 5% 24px;">If you have any questions or concerns, please contact your System Administrator</td>
        </tr>
        <tr>
          <td style="padding:0px  5% 1px; color:#fb8c33;">Your StaynTouch Team!</td>
        </tr>
        <tr>
          <td style="padding:0px 5% 72px; color:#4868fe; font-size:12px;"><a href="#">@from_address</a></td>
        </tr>
        <tr>
          <td align="center" valign="top" style="background:#fb8c33; font-size:12px; color:#ffcea9; padding:29px 0% 80px;"><!--  Footer Part Start-->

            <table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
              <tr>
                <td align="center" style="padding-bottom:10px;" >You @user_email are receiving this email as part of your StayNTouch Inc. Relationship.  </td>
              </tr>
              <tr>
                <td align="center" style="padding-bottom:30px;">This is an automated message from StayNTouch, Inc.  - <a href="mailto" style="color:#ffcea9; text-decoration:none;">@address</a></td>
              </tr>
              <tr>
                <td align="center"  style="padding-bottom:10px;">&copy; 2014 StaynTouch, Inc. | All Rights Reserved.</td>
              </tr>
              <tr>
                <td align="center" style="padding-bottom:10px;">StayNTouch, Inc. - 8120 Woodmont Avenue, Suite 440, Bethesda, MD 20814, USA</td>
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
    signature: ''
    )

    staff_success_checkout = EmailTemplate.create(
    title: 'STAFF_SUCCESS_CHECKOUT_ALERT_EMAIL',
    subject: "Guest @full_name has successfully Checked Out of Room '@room_number'",
    body: '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Mail SNT To Hotel</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0;" />
<style type="text/css">
body {
  width: 100%;
  margin: 0px;
  padding: 0px;
  background: #fff;
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

table {
  border-collapse: collapse;
  mso-table-lspace: 0pt;
  mso-table-rspace: 0pt;
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
                <td align="center" valign="middle" bgcolor="#fff" style="background:#fff; padding:29px 3% 21px 0px; margin:0px auto;"><img src="@snt_logo"  alt="StayNTouch"  width="233" height="67"/></td>
              </tr>
            </table>
            <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
              <tr>
                <td align="center" valign="top" bgcolor="#f7f7f7" style="background:#f7f7f7;"><table width="590" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                    <tr>
                      <td align="center" valign="middle" style="font-family:Helvetica, Arial, sans-serif; text-transform:uppercase;  font-size:18px; color:#565656; text-align:center; padding-top:24px; padding-bottom:20px;" class="header-space">@hotel_name</td>
                    </tr>
                  </table></td>
              </tr>
            </table>
            </td>
            <!--  Header Part End-->
          </tr>

        <tr>
          <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:justify; font:normal 16px Arial, Helvetica, sans-serif; color:#231f20; line-height:22px; padding:20px 5% 19px;"> Guest @full_name staying from @arrival_date to @departure_date has successfully Checked Out of Room @room_number using Web Check Out. </td>
        </tr>

        <tr>
          <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:left; font:normal 16px Arial, Helvetica, sans-serif; color:#231f20; line-height:22px; padding:24px 5% 24px;">Thank You!</td>
        </tr>
        <tr>
          <td style="padding:0px  5% 1px; color:#fb8c33;">Your StaynTouch Team!</td>
        </tr>
        <tr>
          <td style="padding:0px 5% 72px; color:#4868fe; font-size:12px;"><a href="#">@from_address</a></td>
        </tr>
        <tr>
          <td align="center" valign="top" style="background:#fb8c33; font-size:12px; color:#ffcea9; padding:29px 0% 80px;"><!--  Footer Part Start-->

            <table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
              <tr>
                <td align="center" style="padding-bottom:10px;" >You @staff_email  are receiving this email as part of your StayNTouch Inc. Relationship.  </td>
              </tr>
              <tr>
                <td align="center" style="padding-bottom:30px;">This is an automated message from StayNTouch, Inc.  - <a href="mailto" style="color:#ffcea9; text-decoration:none;">@address</a></td>
              </tr>
              <tr>
                <td align="center"  style="padding-bottom:10px;">&copy; 2014 StaynTouch, Inc. | All Rights Reserved.</td>
              </tr>
              <tr>
                <td align="center" style="padding-bottom:10px;">StayNTouch, Inc. - 8120 Woodmont Avenue, Suite 440, Bethesda, MD 20814, USA</td>
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
    signature: ''
    )

    staff_success_late_checkout = EmailTemplate.create(
      title: 'STAFF_SUCCESS_LATE_CHECKOUT_ALERT_EMAIL',
      subject: "Guest @full_name in room '@room_number' has successfully selected a @late_checkout_time PM late check out",
      body: '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Mail SNT To Hotel</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0;" />
<style type="text/css">
body {
  width: 100%;
  margin: 0px;
  padding: 0px;
  background: #fff;
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


table {
  border-collapse: collapse;
  mso-table-lspace: 0pt;
  mso-table-rspace: 0pt;
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
                <td align="center" valign="middle" bgcolor="#fff" style="background:#fff; padding:29px 3% 21px 0px; margin:0px auto;"><img src="@snt_logo"  alt="StayNTouch"  width="233" height="67"/></td>
              </tr>
            </table>
            <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
              <tr>
                <td align="center" valign="top" bgcolor="#f7f7f7" style="background:#f7f7f7;"><table width="590" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                    <tr>
                      <td align="center" valign="middle" style="font-family:Helvetica, Arial, sans-serif; text-transform:uppercase;  font-size:18px; color:#565656; text-align:center; padding-top:24px; padding-bottom:20px;" class="header-space">@hotel_name</td>
                    </tr>
                  </table></td>
              </tr>
            </table>
            </td>
            <!--  Header Part End-->
          </tr>

        <tr>
          <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:justify; font:normal 16px Arial, Helvetica, sans-serif; color:#231f20; line-height:22px; padding:20px 5% 19px;"> Guest @full_name staying from @arrival_date to @departure_date has successfully  selected late check out for Room @room_number until @late_checkout_time PM at @late_checkout_amount. </td>
        </tr>

        <tr>
          <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:left; font:normal 16px Arial, Helvetica, sans-serif; color:#231f20; line-height:22px; padding:24px 5% 24px;">Thank You!</td>
        </tr>
        <tr>
          <td style="padding:0px  5% 1px; color:#fb8c33;">Your StaynTouch Team!</td>
        </tr>
        <tr>
          <td style="padding:0px 5% 72px; color:#4868fe; font-size:12px;"><a href="#">@from_address</a></td>
        </tr>
        <tr>
          <td align="center" valign="top" style="background:#fb8c33; font-size:12px; color:#ffcea9; padding:29px 0% 80px;"><!--  Footer Part Start-->

            <table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
              <tr>
                <td align="center" style="padding-bottom:10px;" >You @staff_email  are receiving this email as part of your StayNTouch Inc. Relationship.  </td>
              </tr>
              <tr>
                <td align="center" style="padding-bottom:30px;">This is an automated message from StayNTouch, Inc.  - <a href="mailto" style="color:#ffcea9; text-decoration:none;">@address</a></td>
              </tr>
              <tr>
                <td align="center"  style="padding-bottom:10px;">&copy; 2014 StaynTouch, Inc. | All Rights Reserved.</td>
              </tr>
              <tr>
                <td align="center" style="padding-bottom:10px;">StayNTouch, Inc. - 8120 Woodmont Avenue, Suite 440, Bethesda, MD 20814, USA</td>
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
      signature: ''
    )

    staff_failure_checkout = EmailTemplate.create(
          title: 'STAFF_FAILURE_CHECKOUT_ALERT_EMAIL',
          subject: "Error Checking Out Guest @full_name out of Room '@room_number' via Web Checkout",
          body: '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml">
    <head>
    <title>Mail SNT To Hotel</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0;" />
    <style type="text/css">
    body {
      width: 100%;
      margin: 0px;
      padding: 0px;
      background: #fff;
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


    table {
      border-collapse: collapse;
      mso-table-lspace: 0pt;
      mso-table-rspace: 0pt;
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
                    <td align="center" valign="middle" bgcolor="#fff" style="background:#fff; padding:29px 3% 21px 0px; margin:0px auto;"><img src="@snt_logo"  alt="StayNTouch"  width="233" height="67"/></td>
                  </tr>
                </table>
                <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                  <tr>
                    <td align="center" valign="top" bgcolor="#f7f7f7" style="background:#f7f7f7;"><table width="590" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                        <tr>
                          <td align="center" valign="middle" style="font-family:Helvetica, Arial, sans-serif; text-transform:uppercase;  font-size:18px; color:#565656; text-align:center; padding-top:24px; padding-bottom:20px;" class="header-space">@hotel_name</td>
                        </tr>
                      </table></td>
                  </tr>
                </table>
                </td>
                <!--  Header Part End-->
              </tr>

            <tr>
              <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:justify; font:normal 16px Arial, Helvetica, sans-serif; color:#231f20; line-height:22px; padding:20px 5% 19px;"> Guest @full_name staying from @arrival_date to @departure_date has been unsuccessful in checking out of Room  @room_number using Web Check Out  due to the following error: </td>
            </tr>

             <tr>
              <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:justify; font:normal 16px Arial, Helvetica, sans-serif; color:#231f20; line-height:22px; padding:20px 5% 19px;">@error_description </td>
            </tr>


            <tr>
              <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:left; font:normal 16px Arial, Helvetica, sans-serif; color:#231f20; line-height:22px; padding:24px 5% 24px;">Thank You!</td>
            </tr>
            <tr>
              <td style="padding:0px  5% 1px; color:#fb8c33;">Your StaynTouch Team!</td>
            </tr>
            <tr>
              <td style="padding:0px 5% 72px; color:#4868fe; font-size:12px;"><a href="#">@from_address</a></td>
            </tr>
            <tr>
              <td align="center" valign="top" style="background:#fb8c33; font-size:12px; color:#ffcea9; padding:29px 0% 80px;"><!--  Footer Part Start-->

                <table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                  <tr>
                    <td align="center" style="padding-bottom:10px;" >You @staff_email  are receiving this email as part of your StayNTouch Inc. Relationship.  </td>
                  </tr>
                  <tr>
                    <td align="center" style="padding-bottom:30px;">This is an automated message from StayNTouch, Inc.  - <a href="mailto" style="color:#ffcea9; text-decoration:none;">@address</a></td>
                  </tr>
                  <tr>
                    <td align="center"  style="padding-bottom:10px;">&copy; 2014 StaynTouch, Inc. | All Rights Reserved.</td>
                  </tr>
                  <tr>
                    <td align="center" style="padding-bottom:10px;">StayNTouch, Inc. - 8120 Woodmont Avenue, Suite 440, Bethesda, MD 20814, USA</td>
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
          signature: ''
        )

    staff_failure_late_checkout = EmailTemplate.create(
       title: 'STAFF_FAILURE_LATE_CHECKOUT_ALERT_EMAIL',
       subject: "Error Late Checking Out attempt Guest @full_name out of Room '@room_number' via Web Checkout",
       body: '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
 <html xmlns="http://www.w3.org/1999/xhtml">
 <head>
 <title>Mail SNT To Hotel</title>
 <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
 <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0;" />
 <style type="text/css">
 body {
   width: 100%;
   margin: 0px;
   padding: 0px;
   background: #fff;
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


 table {
   border-collapse: collapse;
   mso-table-lspace: 0pt;
   mso-table-rspace: 0pt;
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
                 <td align="center" valign="middle" bgcolor="#fff" style="background:#fff; padding:29px 3% 21px 0px; margin:0px auto;"><img src="@snt_logo"  alt="StayNTouch"  width="233" height="67"/></td>
               </tr>
             </table>
             <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
               <tr>
                 <td align="center" valign="top" bgcolor="#f7f7f7" style="background:#f7f7f7;"><table width="590" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                     <tr>
                       <td align="center" valign="middle" style="font-family:Helvetica, Arial, sans-serif; text-transform:uppercase;  font-size:18px; color:#565656; text-align:center; padding-top:24px; padding-bottom:20px;" class="header-space">@hotel_name</td>
                     </tr>
                   </table></td>
               </tr>
             </table>
             </td>
             <!--  Header Part End-->
           </tr>

         <tr>
           <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:justify; font:normal 16px Arial, Helvetica, sans-serif; color:#231f20; line-height:22px; padding:20px 5% 19px;"> Guest @full_name staying from @arrival_date to @departure_date has been unsuccessful in attempting a late check out of Room  @room_number using Web Check Out  due to the following error: </td>
         </tr>

          <tr>
           <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:justify; font:normal 16px Arial, Helvetica, sans-serif; color:#231f20; line-height:22px; padding:20px 5% 19px;">@error_description </td>
         </tr>


         <tr>
           <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:left; font:normal 16px Arial, Helvetica, sans-serif; color:#231f20; line-height:22px; padding:24px 5% 24px;">Thank You!</td>
         </tr>
         <tr>
           <td style="padding:0px  5% 1px; color:#fb8c33;">Your StaynTouch Team!</td>
         </tr>
         <tr>
           <td style="padding:0px 5% 72px; color:#4868fe; font-size:12px;"><a href="#">@from_address</a></td>
         </tr>
         <tr>
           <td align="center" valign="top" style="background:#fb8c33; font-size:12px; color:#ffcea9; padding:29px 0% 80px;"><!--  Footer Part Start-->

             <table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
               <tr>
                 <td align="center" style="padding-bottom:10px;" >You @staff_email  are receiving this email as part of your StayNTouch Inc. Relationship.  </td>
               </tr>
               <tr>
                 <td align="center" style="padding-bottom:30px;">This is an automated message from StayNTouch, Inc.  - <a href="mailto" style="color:#ffcea9; text-decoration:none;">@address</a></td>
               </tr>
               <tr>
                 <td align="center"  style="padding-bottom:10px;">&copy; 2014 StaynTouch, Inc. | All Rights Reserved.</td>
               </tr>
               <tr>
                 <td align="center" style="padding-bottom:10px;">StayNTouch, Inc. - 8120 Woodmont Avenue, Suite 440, Bethesda, MD 20814, USA</td>
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
       signature: ''
     )

    staff_success_checkin = EmailTemplate.create(
        title: 'STAFF_SUCCESS_CHECKIN_ALERT_EMAIL',
        subject: "Guest @full_name has successfully Checked In Room Number '@room_number'",
        body: '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
  <html xmlns="http://www.w3.org/1999/xhtml">
  <head>
  <title>Mail SNT To Hotel</title>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0;" />
  <style type="text/css">
  body {
    width: 100%;
    margin: 0px;
    padding: 0px;
    background: #fff;
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


  table {
    border-collapse: collapse;
    mso-table-lspace: 0pt;
    mso-table-rspace: 0pt;
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
                  <td align="center" valign="middle" bgcolor="#fff" style="background:#fff; padding:29px 3% 21px 0px; margin:0px auto;"><img src="@snt_logo"  alt="StayNTouch"  width="233" height="67"/></td>
                </tr>
              </table>
              <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                <tr>
                  <td align="center" valign="top" bgcolor="#f7f7f7" style="background:#f7f7f7;"><table width="590" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                      <tr>
                        <td align="center" valign="middle" style="font-family:Helvetica, Arial, sans-serif; text-transform:uppercase;  font-size:18px; color:#565656; text-align:center; padding-top:24px; padding-bottom:20px;" class="header-space">@hotel_name</td>
                      </tr>
                    </table></td>
                </tr>
              </table>
              </td>
              <!--  Header Part End-->
            </tr>

          <tr>
            <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:justify; font:normal 16px Arial, Helvetica, sans-serif; color:#231f20; line-height:22px; padding:20px 5% 19px;"> Guest @full_name staying from @arrival_date to @departure_date has successfully Checked In Room Number @room_number using Web Check In. </td>
          </tr>

           <tr>
            <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:left; font:normal 16px Arial, Helvetica, sans-serif; color:#231f20; line-height:18px; padding:10px 5% 15px; background:#e5f1fa;">Assigned room number :  <span style=" text-transform: capitalize;">@room_number</span> </td>
          </tr>
           <tr>
            <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:left; font:normal 16px Arial, Helvetica, sans-serif; color:#231f20; line-height:18px; padding:10px 5% 15px; background:#e5f1fa;">Reservation Number :  <span>@confirmation_number</span> </td>
          </tr>

           <tr>
            <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:left; font:normal 16px Arial, Helvetica, sans-serif; color:#231f20; line-height:18px; padding:10px 5% 15px; background:#e5f1fa;">Upgrade :  <span style=" text-transform: capitalize;">@upgrade_option</span> </td>
          </tr>
           <tr>
            <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:left; font:normal 16px Arial, Helvetica, sans-serif; color:#231f20; line-height:18px; padding:10px 5% 15px; background:#e5f1fa;">@upgrade_description</td>
          </tr>
          <tr>
            <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:left; font:normal 16px Arial, Helvetica, sans-serif; color:#231f20; line-height:22px; padding:24px 5% 24px;">Thank You!</td>
          </tr>
          <tr>
            <td style="padding:0px  5% 1px; color:#fb8c33;">Your StaynTouch Team!</td>
          </tr>
          <tr>
            <td style="padding:0px 5% 72px; color:#4868fe; font-size:12px;"><a href="#">@from_address</a></td>
          </tr>
          <tr>
            <td align="center" valign="top" style="background:#fb8c33; font-size:12px; color:#ffcea9; padding:29px 0% 80px;"><!--  Footer Part Start-->

              <table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                <tr>
                  <td align="center" style="padding-bottom:10px;" >You @staff_email  are receiving this email as part of your StayNTouch Inc. Relationship.  </td>
                </tr>
                <tr>
                  <td align="center" style="padding-bottom:30px;">This is an automated message from StayNTouch, Inc.  - <a href="mailto" style="color:#ffcea9; text-decoration:none;">@address</a></td>
                </tr>
                <tr>
                  <td align="center"  style="padding-bottom:10px;">&copy; 2014 StaynTouch, Inc. | All Rights Reserved.</td>
                </tr>
                <tr>
                  <td align="center" style="padding-bottom:10px;">StayNTouch, Inc. - 8120 Woodmont Avenue, Suite 440, Bethesda, MD 20814, USA</td>
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
        signature: ''
      )

    staff_checkin_failure_alert = EmailTemplate.create(
          title: 'STAFF_FAILURE_CHECKIN_ALERT_EMAIL',
          subject: "Error Checking In Guest @full_name into Room '@room_number' via Web Check In",
          body: '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml">
    <head>
    <title>Mail SNT To Hotel</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0;" />
    <style type="text/css">
    body {
      width: 100%;
      margin: 0px;
      padding: 0px;
      background: #fff;
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


    table {
      border-collapse: collapse;
      mso-table-lspace: 0pt;
      mso-table-rspace: 0pt;
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
                    <td align="center" valign="middle" bgcolor="#fff" style="background:#fff; padding:29px 3% 21px 0px; margin:0px auto;"><img src="@snt_logo"  alt="StayNTouch"  width="233" height="67"/></td>
                  </tr>
                </table>
                <table width="655" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                  <tr>
                    <td align="center" valign="top" bgcolor="#f7f7f7" style="background:#f7f7f7;"><table width="590" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                        <tr>
                          <td align="center" valign="middle" style="font-family:Helvetica, Arial, sans-serif; text-transform:uppercase;  font-size:18px; color:#565656; text-align:center; padding-top:24px; padding-bottom:20px;" class="header-space">@hotel_name</td>
                        </tr>
                      </table></td>
                  </tr>
                </table>
                </td>
                <!--  Header Part End-->
              </tr>

            <tr>
              <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:justify; font:normal 16px Arial, Helvetica, sans-serif; color:#231f20; line-height:22px; padding:20px 5% 19px;"> Guest @full_name staying from @arrival_date to @departure_date has been UNSUCCESSFUL in checking into Room @room_number using Web Check In due to the following errors, </td>
            </tr>
             <tr>
              <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:left; font:normal 16px Arial, Helvetica, sans-serif; color:#231f20; line-height:18px; padding:20px 5% 24px; background:#e5f1fa;">@error_description</td>
            </tr>
             <tr>
              <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:left; font:normal 16px Arial, Helvetica, sans-serif; color:#231f20; line-height:18px; padding:20px 5% 24px; background:#e5f1fa;">Reservation Number :  <span>@confirmation_number</span> </td>
            </tr>
              <tr>
              <td align="center" valign="top" bgcolor="#ffffff" style="background:#ffffff; text-align:left; font:normal 16px Arial, Helvetica, sans-serif; color:#231f20; line-height:22px; padding:24px 5% 24px;">Thank You!</td>
            </tr>
            <tr>
              <td style="padding:0px  5% 1px; color:#fb8c33;">Your StaynTouch Team!</td>
            </tr>
            <tr>
              <td style="padding:0px 5% 72px; color:#4868fe; font-size:12px;"><a href="#">@from_address</a></td>
            </tr>
            <tr>
              <td align="center" valign="top" style="background:#fb8c33; font-size:12px; color:#ffcea9; padding:29px 0% 80px;"><!--  Footer Part Start-->

                <table width="625" border="0" align="center" cellpadding="0" cellspacing="0" class="main">
                  <tr>
                    <td align="center" style="padding-bottom:10px;" >You @staff_email are receiving this email as part of your StayNTouch Inc. Relationship.  </td>
                  </tr>
                  <tr>
                    <td align="center" style="padding-bottom:30px;">This is an automated message from StayNTouch, Inc.  - <a href="mailto" style="color:#ffcea9; text-decoration:none;">@address</a></td>
                  </tr>
                  <tr>
                    <td align="center"  style="padding-bottom:10px;">&copy; 2014 StaynTouch, Inc. | All Rights Reserved.</td>
                  </tr>
                  <tr>
                    <td align="center" style="padding-bottom:10px;">StayNTouch, Inc. - 8120 Woodmont Avenue, Suite 440, Bethesda, MD 20814, USA</td>
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
          signature: ''
        )
   end
end
