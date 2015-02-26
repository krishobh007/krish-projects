angular.module('admin').run(['$templateCache', function($templateCache) {
  'use strict';

  $templateCache.put('/assets/partials/AnalyticSetup/adAnalyticSetup.html',
    "<div id=\"wrapper\" class=\"content current\" ng-click=\"clearErrorMessage()\" >\n" +
    "\t<header class=\"content-title float\">\n" +
    "\t\t<h2 translate>ANALYTIC_SETUP_HEADER</h2>\n" +
    "\t\t<a ng-click =\"goBackToPreviousState()\" class=\"action back\" translate>BACK</a>\n" +
    "\t</header>\n" +
    "\t<section class=\"content-scroll\">\n" +
    "\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t<div ng-include=\"'/assets/partials/common/notification_success_message.html'\"></div> \n" +
    "\t<form class=\"form float\" >\t\n" +
    "\t    <fieldset class=\"holder left\" ng-show=\"!isHotelAdmin\">\n" +
    "\t\t\t\n" +
    "\t\t\n" +
    "\t    \t<ad-textbox value=\"data.product_cross_customer.tracker_guest_web\"  name = \"zest-web\" id = \"zest-web\" label = \"{{'ZEST_WEB_LABEL' | translate}}\" placeholder = \"{{'PLACEHOLDER_TRACKING_ID' | translate }}\" styleclass=\"full-width\" ></ad-textbox>\n" +
    "\t\t\t\n" +
    "\t\t\t<ad-textbox value=\"data.product_cross_customer.tracker_zest_ios\"  name = \"zest-ios\" id = \"zest-ios\" label = \"{{'ZEST_IOS_LABEL' | translate}}\" placeholder = \"{{'PLACEHOLDER_TRACKING_ID' | translate }}\"  readonly=\"{{readOnly}}\" styleclass=\"full-width\"></ad-textbox>\n" +
    "\n" +
    "\t\t\t<ad-textbox label=\"{{'ZEST_ANDROID_LABEL' | translate}}\" value=\"data.product_cross_customer.tracker_zest_android\"  placeholder=\"{{'PLACEHOLDER_TRACKING_ID' | translate }}\" name=\"zest-android\" id=\"zest-android\" styleclass=\"full-width\"></ad-textbox>\t\t\n" +
    "\t\t\t\n" +
    "\t\t</fieldset>\t\n" +
    "\t\t<fieldset class=\"holder left\" ng-show=\"isHotelAdmin\">\n" +
    "\t\t\t<div class=\"form-title full-width\">\n" +
    "\t\t\t\t\t\t<h3><span translate>SNT_TRACKERS_TITLE</span> </h3>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\n" +
    "\t    \t<ad-textbox value=\"data.product_customer.tracker_guest_web\"  name = \"zest-web\" id = \"zest-web\" label = \"{{'ZEST_WEB_LABEL' | translate}}\" placeholder = \"{{'PLACEHOLDER_TRACKING_ID' | translate }}\"  styleclass=\"full-width\"></ad-textbox>\n" +
    "\t\t\t\n" +
    "\t\t\t<ad-textbox value=\"data.product_customer.tracker_zest_ios\"  name = \"zest-ios\" id = \"zest-ios\" label = \"{{'ZEST_IOS_LABEL' | translate}}\" placeholder = \"{{'PLACEHOLDER_TRACKING_ID' | translate }}\"  readonly=\"{{readOnly}}\" styleclass=\"full-width\"></ad-textbox>\n" +
    "\n" +
    "\t\t\t<ad-textbox label=\"{{'ZEST_ANDROID_LABEL' | translate}}\" value=\"data.product_customer.tracker_zest_android\"   placeholder=\"{{'PLACEHOLDER_TRACKING_ID' | translate }}\" name=\"zest-android\" id=\"zest-android\" styleclass=\"full-width\"></ad-textbox>\t\t\n" +
    "\t\t\t\n" +
    "\t\t</fieldset>\n" +
    "\t\t\n" +
    "\t\t<fieldset class=\"holder right\" ng-show=\"isHotelAdmin\">\n" +
    "\t\t\t<div class=\"form-title full-width\">\n" +
    "\t\t\t\t\t\t<h3><span translate>HOTEL_TRACKERS_TITLE</span> </h3>\n" +
    "\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t    <ad-dropdown label-in-drop-down=\"{{'SELECT_SERVICE' | translate}}\" list=\"data.available_trackers\" selected-id='data.product_customer_proprietary.selected_tracker' selbox-class=\"placeholder\" div-class=\"full-width\" label=\"{{'ANALYTIC_SERVICE_LABEL' | translate}}\"></ad-dropdown>\n" +
    "\t\t\t\n" +
    "\t\t\t<ad-textbox value=\"data.product_customer_proprietary.tracker_guest_web\"  name = \"zest-web\" id = \"zest-web\" label = \"{{'ZEST_WEB_LABEL' | translate}}\" placeholder = \"{{'PLACEHOLDER_TRACKING_ID' | translate }}\"  styleclass=\"full-width\"></ad-textbox>\n" +
    "\t\t\t\n" +
    "\t\t\t<ad-textbox value=\"data.product_customer_proprietary.tracker_zest_ios\"  name = \"zest-ios\" id = \"zest-ios\" label = \"{{'ZEST_IOS_LABEL' | translate}}\" placeholder = \"{{'PLACEHOLDER_TRACKING_ID' | translate }}\"  readonly=\"{{readOnly}}\" styleclass=\"full-width\"></ad-textbox>\n" +
    "\n" +
    "\t\t\t<ad-textbox label=\"{{'ZEST_ANDROID_LABEL' | translate}}\" value=\"data.product_customer_proprietary.tracker_zest_android\"  placeholder=\"{{'PLACEHOLDER_TRACKING_ID' | translate }}\" name=\"zest-android\" id=\"zest-android\" styleclass=\"full-width\"></ad-textbox>\t\t\t\n" +
    "\t\t\t\n" +
    "\t\t</fieldset>\t\t\n" +
    "\n" +
    "\t\t<div class=\"actions float\">\n" +
    "\t\t\t<button type=\"button\" id=\"cancel\" class=\"button blank add-data-inline\" ng-click=\"goBackToPreviousState()\" translate>\n" +
    "\t\t\t\tCANCEL\n" +
    "\t\t\t</button>\n" +
    "\t\t\t<button type=\"button\" like-type=\"common\" id=\"update\" class=\"button  ng-binding green\" ng-click=\"saveAnalyticSetup()\" translate>\n" +
    "\t\t\t\tSAVE_CHANGES\n" +
    "\t\t\t</button>\n" +
    "\t\t</div>\n" +
    "\n" +
    "\t</form>\n" +
    "\t</section>\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/EmailBlackList/adAddBlackListedEmail.html',
    "<div class=\"data-holder\">\n" +
    "\t<form room_type_id=\"1\" id=\"edit-room-type\" class=\"form inline-form float\">\n" +
    "\t\t<div class=\"form-title\">\n" +
    "\t\t\t\n" +
    "\t\t\t<h3 ><span translate>ADD</span> </h3>\n" +
    "\t\t\t\n" +
    "\t\t</div>\n" +
    "\t\t<div class = \"holder left\">\n" +
    "\t\t     <ad-textbox styleclass=\"full-width actions_margin_top\" value=\"emailData.email\" name = \"email\" id = \"email\" label = \"{{ 'EMAIL_LABEL' | translate }}\" placeholder = \"{{ 'EMAIL_PLACEHOLDER' | translate }}\" required=\"yes\" ></ad-textbox>\n" +
    "\t\t</div>\n" +
    "\t\t\n" +
    "\t\t<div class=\"actions float\">\n" +
    "\t\t\t<button type=\"button\" id=\"cancel\" class=\"button blank add-data-inline\" ng-click=\"clickCancel()\" translate>\n" +
    "\t\t\t\tCANCEL\n" +
    "\t\t\t</button>\n" +
    "\t\t\t<button type=\"button\" like-type=\"common\" id=\"update\" class=\"button  ng-binding green\" ng-click=\"saveEmail()\" translate>\n" +
    "\t\t\t\tSAVE_CHANGES\n" +
    "\t\t\t</button>\n" +
    "\t\t</div>\n" +
    "\t</form>\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/EmailBlackList/adEmailBlackList.html',
    "<section class=\"content current\" >\t\n" +
    "\t<div data-view=\"HotelRoomTypesView\">\n" +
    "\t\t<header class=\"content-title float\">\n" +
    "\t\t\t<h2 translate> EMAIL_BLACKLIST_HEADER </h2>\n" +
    "\t\t\t<span class=\"count\"> ({{emailList.length}}) </span>\n" +
    "\t\t\t<a id=\"import-rooms\" class=\"action add\" ng-click=\"addNewClicked()\"  translate>ADD_NEW</a>\n" +
    "\t\t</header>\n" +
    "\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t<span class=\"grid\" ng-show=\"isAddMode\" ng-include=\"getTemplateUrl()\"></span>\n" +
    "\n" +
    "            <span class=\"count-show\">Show</span>\n" +
    "\t\t\t<div class=\"select table-count rates-table-count\">\n" +
    "\t\t\t\t<select ng-model=\"displyCount\"\tng-options=\"opt for opt in displayCountList\"></select>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<span class=\"count-entries\">entries</span>\n" +
    "\t\t\t\t\n" +
    "\t\t\t<div class=\"entry table-search\">\n" +
    "\t\t\t\t<span class=\"search-text\">Search</span>\n" +
    "\t\t\t\t<span class=\"icons icon-search\" name=\"submit\" type=\"submit\"></span>\n" +
    "\t\t\t\t<input placeholder=\"\" autocomplete=\"off\" type=\"text\" ad-delay-textbox ng-model=\"searchTerm\" delay=\"1000\" function-to-fire=\"searchEntered\" />\n" +
    "\t\t    </div>\n" +
    "\n" +
    "\t\t\t<table id=\"brands\" class=\"grid\" ng-table=\"tableParams\" template-pagination=\"nil\">\n" +
    "\t\t\t\t<thead>\n" +
    "\t\t\t\t\t<tr>\n" +
    "\t\t\t\t\t\t \n" +
    "\t                     <th colspan=\"4\" class=\"sortable\" ng-class=\"{\n" +
    "\t                       'sort-asc': tableParams.isSortBy('email', 'asc'),\n" +
    "\t                       'sort-desc': tableParams.isSortBy('email', 'desc')\n" +
    "\t                       }\"\n" +
    "\t                       ng-click=\"tableParams.sorting({'email' : tableParams.isSortBy('email', 'asc') ? 'desc' : 'asc'})\" rowspan=\"2\">\n" +
    "\t                       <div><i class=\"glyphicon glyphicon-user\"></i> <span translate>EMAIL_LABEL</span></div>\n" +
    "\t                     </th>                 \n" +
    "\n" +
    "\t           \n" +
    "\t                </tr>\n" +
    "\t            </thead>\n" +
    "\t\t\t\t<tbody>\n" +
    "\t\t\t\t\t<tr ng-repeat=\"email in $data\" > \n" +
    "\t\t\t\t\t\t<td  colspan=\"2\" class=\"text-left\"  >\n" +
    "\t\t\t\t\t\t\t<a  class=\"edit-data-inline\" >{{email.email}} </a>\n" +
    "\t\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td colspan=\"2\" header-class=\" width-10\"  class=\"text-left\"  >\n" +
    "\t\t\t\t\t\t\t<span ng-click=\"deleteEmail($index)\" class=\"icons icon-delete large-icon floor_delete\">&nbsp;</span>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t\n" +
    "\t\t\t\t\t</tr>\n" +
    "\t\t\t\t</tbody>\n" +
    "                <tfoot>\n" +
    "                \t<td colspan=\"4\">\n" +
    "                \t\t<div class = \"pager\">\n" +
    "\t\t\t\t        <span ng-show=\"totalCount>0\">Showing {{startCount}} to {{endCount}} of {{totalCount}} items</span>\n" +
    "\t\t\t\t        <span ng-show=\"totalCount==0\">Showing 0 items</span>\n" +
    "\t\t\t\t        <ul class=\"ng-cloak\">\n" +
    "\t              \t        <li ng-repeat=\"page in pages\"\n" +
    "\t\t                    ng-class=\"{'previous': page.type == 'prev', 'next': page.type == 'next'}\"\n" +
    "\t\t                    ng-show=\"page.type == 'prev' || page.type == 'next'\" ng-switch=\"page.type\">\n" +
    "\t\n" +
    "\t\t                      <a ng-switch-when=\"prev\" ng-click=\"params.page(1)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">First</a>\n" +
    "\t\t                      <a ng-switch-when=\"prev\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">Previous</a>\n" +
    "\t\t                      <a ng-switch-when=\"prev\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">{{page.number}}</a>\n" +
    "\t\t                \n" +
    "\t\t                      <a ng-switch-when=\"next\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">{{page.number}}</a>\n" +
    "\t\t                      <a ng-switch-when=\"next\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">Next</a>\n" +
    "\t\t                      <a ng-switch-when=\"next\" ng-click=\"params.page(totalPage)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">Last</a>\n" +
    "\t\t          \t        </li>\n" +
    "\t                    </ul>\n" +
    "\t                    </div>\n" +
    "                \t</td>\n" +
    "                </tfoot>\n" +
    "                \n" +
    "\n" +
    "\t\t\t</table>\n" +
    "\t\t</section>\n" +
    "\t\t<!--Custom pagination footer goes here-->\n" +
    "\t\t<script type=\"text/ng-template\" id=\"custom/pager\">\n" +
    "\t\t\t<div class = \"pager\">\n" +
    "\t\t\t\t<span ng-show=\"totalCount>0\">Showing {{startCount}} to {{endCount}} of {{totalCount}} items</span>\n" +
    "\t\t\t\t<span ng-show=\"totalCount==0\">Showing 0 items</span>\n" +
    "\t\t\t\t<ul class=\"ng-cloak\">\n" +
    "\t              \t<li ng-repeat=\"page in pages\"\n" +
    "\t\t                ng-class=\"{'previous': page.type == 'prev', 'next': page.type == 'next'}\"\n" +
    "\t\t                ng-show=\"page.type == 'prev' || page.type == 'next'\" ng-switch=\"page.type\">\n" +
    "\t\n" +
    "\t\t                <a ng-switch-when=\"prev\" ng-click=\"params.page(1)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">First</a>\n" +
    "\t\t                <a ng-switch-when=\"prev\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">Previous</a>\n" +
    "\t\t                <a ng-switch-when=\"prev\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">{{page.number}}</a>\n" +
    "\t\t                \n" +
    "\t\t                <a ng-switch-when=\"next\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">{{page.number}}</a>\n" +
    "\t\t                <a ng-switch-when=\"next\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">Next</a>\n" +
    "\t\t                <a ng-switch-when=\"next\" ng-click=\"params.page(totalPage)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">Last</a>\n" +
    "\t\t          \t</li>\n" +
    "\t            </ul>\n" +
    "\t        </div>\n" +
    "\t\t</script>\n" +
    "\t\t<!--end-->\n" +
    "\t</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/Likes/adHotelLikes.html',
    "<section id=\"replacing-div-first\" class=\"content current\" ng-click=\"clearErrorMessage()\"><div data-view=\"GuestCardLikesView\"  class=\"inline-edit\">\n" +
    "\t<header class=\"content-title float\">\n" +
    "\t\t<h2 translate>\n" +
    "\t\t\tLIKES\n" +
    "\t\t</h2>\n" +
    "\t\t<span class=\"count\">\n" +
    "\t\t\t({{likeList.likes.length}})\n" +
    "\t\t</span>\n" +
    "\t\t<a id=\"add-new-button\" class=\"action add\" ng-click=\"addNew()\" translate>ADD_NEW</a>\n" +
    "\t</header>\n" +
    "\t<section class=\"content-scroll\">\n" +
    "\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t<div id=\"new-form-holder\" ng-show=\"isAddmode\" ng-include=\"getTemplateUrl()\">\n" +
    "\t\t</div>\n" +
    "\t\t<table id=\"likes\" class=\"grid\" >\n" +
    "\t\t\t<tbody>\n" +
    "\t\t\t\t<tr  ng-repeat=\"like in  likeList.likes\">\n" +
    "\t\t\t\t\t<td ng-click=\"editSelected($index,like.id,like.name,like.is_system_defined)\" ng-hide=\"currentClickedElement == $index && isEditmode\">\n" +
    "\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t<a ng-show=\"{{like.is_system_defined !== 'true'}}\">{{like.name}} </a>\n" +
    "\t\t\t\t\t\t<span class=\"bold\" ng-show=\"{{like.is_system_defined === 'true'}}\">{{like.name}} </span>\n" +
    "\t\t\t\t\t\t<em ng-show=\"{{like.is_system_defined === 'true'}}\" translate>SYSTEM_DEFINED</em>\n" +
    "\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t\t<td class=\"activate\" ng-hide=\"currentClickedElement == $index && isEditmode\">\n" +
    "\t\t\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t\t\t<label></label>\n" +
    "\t\t\t\t\t\t\t<div  class=\"switch-button single\" ng-class=\"{ on :like.is_active === 'true' }\">\n" +
    "\t\t\t\t\t\t\t\t<input type=\"checkbox\"  name=\"upsell-rooms\" id=\"upsell-rooms\" ng-click=\"switchClicked($index)\">\n" +
    "\t\t\t\t\t\t\t\t<span class=\"switch-icon\"></span>\n" +
    "\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t<td colspan=\"2\" ng-include=\"getTemplateUrl(like.name)\" ng-show=\"currentClickedElement == $index && isEditmode\">\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t</tr>\n" +
    "\t\t\t</tbody>\n" +
    "\t\t</table>\n" +
    "\t</section>\n" +
    "</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/Likes/adNewLike.html',
    "<div style=\"display: block;\" id=\"add-new\" class=\"edit-data\">\n" +
    "\t<div class=\"data-holder\">\n" +
    "\t\t<form id=\"add-like\" class=\"form inline-form float\">\n" +
    "\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t<h3>\n" +
    "\t\t\t\t\t<span>{{likeTitle}}</span>\n" +
    "\t\t\t\t\t{{likeSubtitle}}\n" +
    "\t\t\t\t</h3>\n" +
    "\t\t\t\t<em class=\"status\">\n" +
    "\t\t\t\t\t{{'MANDATORY_FIELDS_MESSAGE1' | translate}}\n" +
    "\t\t\t\t\t<strong>*</strong>\n" +
    "\t\t\t\t\t{{'MANDATORY_FIELDS_MESSAGE2' | translate}}\n" +
    "\n" +
    "\t\t\t\t</em>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<fieldset class=\"holder left float\">\n" +
    "\n" +
    "\t\t\t\t<ad-textbox value=\"likeData.name\"   label = \"{{'NAME' | translate}}\" placeholder = \"{{'CATEGORY_NAME_PLACEHOLDER' | translate}}\" required = \"yes\" styleclass=\"full-width\"></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t<!-- Checkbox -->\n" +
    "\t\t\t\t<div class=\"entry full-width radio-check\">\n" +
    "\t\t\t\t\t<label class=\"checkbox\">\n" +
    "\t\t\t\t\t\t<span class=\"icon-form icon-checkbox\" ng-class=\"{ checked : likeData.show_on_room_setup === 'true' }\"></span>\n" +
    "\t\t\t\t\t\t<label translate>ROOM_ASSIGMENT_SETUP_MSG</label>\n" +
    "\t\t\t\t\t\t<input type=\"checkbox\" ng-click=\"likeData.show_on_room_setup =(likeData.show_on_room_setup === 'true')? 'fasle':'true'\">\n" +
    "\n" +
    "\t\t\t\t\t</label>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t\t<label>\n" +
    "\t\t\t\t\t\t{{'TYPE' | translate}}\n" +
    "\t\t\t\t\t\t<strong>*</strong>\n" +
    "\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t<div class=\"boxes\">\n" +
    "\t\t\t\t\t\t<label class=\"radio\" ng-class=\"{checked:likeData.type == 'textbox'}\">\n" +
    "\t\t\t\t\t\t\t<span class=\"icon-form icon-radio \" ng-class=\"{checked:likeData.type == 'textbox'}\"></span>\n" +
    "\t\t\t\t\t\t\t<input type=\"radio\" ng-model=\"likeData.type\" value=\"textbox\" class=\"change-data\" checked='checked'>\n" +
    "\t\t\t\t\t\t\t{{'TEXT_VALUE' | translate}}\n" +
    "\t\t\t\t\t\t\t<span>({{'TEXTBOX' | translate}})</span>\n" +
    "\t\t\t\t\t\t</label>\n" +
    "\n" +
    "\t\t\t\t\t\t<label class=\"radio\" ng-class=\"{checked:likeData.type == 'radio'}\">\n" +
    "\t\t\t\t\t\t\t<span class=\"icon-form icon-radio \" ng-class=\"{checked:likeData.type == 'radio'}\"></span>\n" +
    "\t\t\t\t\t\t\t<input type=\"radio\" ng-model=\"likeData.type\" value=\"radio\" class=\"change-data\" >\n" +
    "\t\t\t\t\t\t\t{{'ONE_SELECTION_TWO_OPTIONS_TEXT' | translate}}\n" +
    "\t\t\t\t\t\t\t<span>({{'RADIO_BTN_LIST' | translate}})</span>\n" +
    "\t\t\t\t\t\t</label>\n" +
    "\n" +
    "\t\t\t\t\t\t<label class=\"radio\" ng-class=\"{checked:likeData.type == 'dropdown'}\">\n" +
    "\t\t\t\t\t\t\t<span class=\"icon-form icon-radio \" ng-class=\"{checked:likeData.type == 'dropdown'}\"></span>\n" +
    "\t\t\t\t\t\t\t<input type=\"radio\" ng-model=\"likeData.type\" value=\"dropdown\" class=\"change-data\" >\n" +
    "\t\t\t\t\t\t\t{{'ONE_SELECTION_MULTIPLE_OPTIONS_TEXT' | translate}}\n" +
    "\t\t\t\t\t\t\t<span>({{'SELECTBOX' | translate}})</span>\n" +
    "\t\t\t\t\t\t</label>\n" +
    "\n" +
    "\n" +
    "\t\t\t\t\t\t<label class=\"radio\" ng-class=\"{checked:likeData.type == 'checkbox'}\">\n" +
    "\t\t\t\t\t\t\t<span class=\"icon-form icon-radio \" ng-class=\"{checked:likeData.type == 'checkbox'}\"></span>\n" +
    "\t\t\t\t\t\t\t<input type=\"radio\" ng-model=\"likeData.type\" value=\"checkbox\" class=\"change-data\" >\n" +
    "\t\t\t\t\t\t\t{{'MULTIPLE_OPTIONS_MULTIPLE_SELECTION_TEXT' | translate}}\n" +
    "\t\t\t\t\t\t\t<span>({{'CHECKBOX_LIST' | translate}})</span>\n" +
    "\t\t\t\t\t\t</label>\n" +
    "\n" +
    "\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</fieldset>\n" +
    "\n" +
    "\t\t\t<fieldset class=\"holder right float\">\n" +
    "\t\t\t\t<!-- Radio data type -->\n" +
    "\t\t\t\t<div id=\"entry-radio\" class=\"data-type\" ng-show=\"showRadio\">\n" +
    "\t\t\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t\t \t<label for=\"radio-option1\">\n" +
    "\t\t\t\t\t\t\t{{'OPTIONS' |translate}}\n" +
    "\t\t\t\t\t\t\t<strong>*</strong>\n" +
    "\t\t\t\t\t\t</label>\n" +
    "\t\t\t\t\n" +
    "\t\t\t\t\t\t<ad-textbox value=\"likeData.options[0].name\"    placeholder = \"First option\"  ></ad-textbox>\n" +
    "\t\t\t\t\t\t<ad-textbox value=\"likeData.options[1].name\"    placeholder = \"Second option\" ></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t\t<!-- Select data type -->\n" +
    "\t\t\t\t<div id=\"entry-select\" class=\"data-type\" ng-show=\"showDropDown\">\n" +
    "\t\t\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t\t\t<label for=\"select-option1\">\n" +
    "\t\t\t\t\t\t\t{{'OPTIONS' |translate}}\n" +
    "\t\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t\t<div class=\"entry\" ng-repeat=\"option in likeData.options\">\n" +
    "\t\t\t\t\t\t\t<input type=\"text\"  placeholder=\"Add new option\" name=\"radio-option\" ng-focus=\"onFocus($index)\" ng-blur=\"onBlur($index)\" ng-change=\"textChanged($index)\" data-type=\"dropdown\" class=\"add-new-option\"\n" +
    "\t\t\t\t\t\t\tng-model=\"option.name\" >\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t\t<!-- Checkbox data type -->\n" +
    "\t\t\t\t<div id=\"entry-checkbox\" class=\"data-type\" ng-show=\"showCheckbox\">\n" +
    "\t\t\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t\t\t<label for=\"select-option1\">\n" +
    "\t\t\t\t\t\t\t{{'OPTIONS' |translate}}\n" +
    "\t\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t\t<div class=\"entry\" ng-repeat=\"option in likeData.options\">\n" +
    "\t\t\t\t\t\t\t<input type=\"text\"  placeholder=\"Add new option\" name=\"radio-option\" ng-focus=\"onFocus($index)\" ng-blur=\"onBlur($index)\" ng-change=\"textChanged($index)\" data-type=\"dropdown\" class=\"add-new-option\"\n" +
    "\t\t\t\t\t\t\tng-model=\"option.name\" >\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</fieldset>\n" +
    "\n" +
    "\n" +
    "\t\t\t<div class=\"actions float\">\n" +
    "\t\t\t\t<button type=\"button\" ng-click=\"cancelCliked()\" class=\"button blank add-data-inline\" translate>CANCEL</button>\n" +
    "\t\t\t\t<button type=\"button\" like-type=\"common\" ng-click=\"addSaveCliked()\" class=\"button green add-data-inline\" translate>SAVE_CHANGES</button>\n" +
    "\t\t\t</div>\n" +
    "\t\t</form>\n" +
    "\t</div>\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/Likes/adNewsPaperEdit.html',
    "<div class=\"data-holder move50\">\n" +
    "\t<!-- Edit Like -->\n" +
    "\t<form like_id=\"5\" id=\"edit-like\" class=\"form inline-form float\">\n" +
    "\t\t<div class=\"form-title\">\n" +
    "\t\t\t<h3>\n" +
    "\t\t\t\t<span translate>EDIT</span>\n" +
    "\t\t\t\t{{'NEWSPAPER' | translate}}\n" +
    "\t\t\t</h3>\n" +
    "\t\t</div>\n" +
    "\t\t<div class=\"entry full-width float\">\n" +
    "\t\t\t<label translate>OPTIONS</label>\n" +
    "\t\t\t<div id=\"newspaper-options\" class=\"boxes\">\t\t\n" +
    "\t\t\t\t<label class=\"checkbox inline\" ng-repeat=\"option in likeData.news_papers\">\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t\t<ad-checkboxgrp delete-action=\"checkBoxDeleteClicked($index,option.id)\" toggle=\"checkBoxClicked($index)\" label=\"{{option.name}}\" is-checked=\"option.is_checked\" option-id=\"option.id\"></ad-checkboxgrp>\n" +
    "\t\t\t\t</label>\n" +
    "\n" +
    "\t\t\t\t<label class=\"inline\" ng-show=\"showNewsPaperOption\"> \n" +
    "\t\t\t\t\t<input  ng-model=\"likeData.newfeature\"/>\n" +
    "\t\t\t\t</label> \n" +
    "\n" +
    "\t\t\t\t<label data-type=\"newspaper\" class=\"add-new-checkbox inline\"  ng-click=\"showNewNewsPaperOption()\">\n" +
    "\t\t\t\t\t<span class=\"icons icon-add\" ></span>\n" +
    "\t\t\t\t\t{{'ADD_NEW_OPTION' | translate}}\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t</label>\n" +
    "\t\t\t\t\n" +
    "\n" +
    "\t\t\t\t\n" +
    "\n" +
    "\t\t\t</div>\n" +
    "\t\t</div>\n" +
    "\t\t<div class=\"actions float\">\n" +
    "\t\t\t<button type=\"button\"  ng-click=\"cancelCliked()\" class=\"button blank edit-data-inline\" translate>CANCEL</button>\n" +
    "\t\t\t<button type=\"button\" like-type=\"newspaper\" ng-click=\"customLikeSave()\" class=\"button green edit-data-inline\" translate>SAVE_CHANGES</button>\n" +
    "\t\t</div>\n" +
    "\t</form>\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/Likes/adRoomFeatureEdit.html',
    "<div class=\"data-holder move50\">\n" +
    "\t<!-- Edit Like -->\n" +
    "\t<form like_id=\"1\" id=\"edit-like\" class=\"form inline-form float\">\n" +
    "\t\t<div class=\"form-title\">\n" +
    "\t\t\t<h3>\n" +
    "\t\t\t\t<span translate>EDIT</span>\n" +
    "\t\t\t\t{{'ROOM_FEATURE' | translate}}\n" +
    "\t\t\t</h3>\n" +
    "\t\t</div>\n" +
    "\t\t<div class=\"entry full-width float\">\n" +
    "\t\t\t<label translate>OPTIONS</label>\n" +
    "\t\t\t<div id=\"newspaper-options\" class=\"boxes\">\n" +
    "\n" +
    "\t\t\t\t<label class=\"checkbox inline\" ng-repeat=\"option in likeData.news_papers\">\n" +
    "\t\t\t\t\t<ad-checkboxgrp delete-action=\"checkBoxDeleteClicked($index,option.id)\" toggle=\"checkBoxClicked($index)\" label=\"{{option.name}}\" is-checked=\"option.is_checked\" option-id=\"option.id\"></ad-checkboxgrp>\n" +
    "\t\t\t\t</label>\n" +
    "\n" +
    "\t\t\t\t<label class=\"inline\" ng-show=\"showNewRoomOption\"> \n" +
    "\t\t\t\t\t<input  ng-model=\"likeData.newfeature\"/>\n" +
    "\t\t\t\t</label> \n" +
    "\n" +
    "\t\t\t\t<label data-type=\"newspaper\" class=\"add-new-checkbox inline\" ng-click=\"shownewInputRoomOption()\">\n" +
    "\t\t\t\t\t<span class=\"icons icon-add\"></span>\n" +
    "\t\t\t\t\t{{'ADD_NEW_OPTION' | translate}}\n" +
    "\t\t\t\t</label> \n" +
    "\t\t\t</div>\n" +
    "\t\t</div>\n" +
    "\t\t<div class=\"actions float\">\n" +
    "\t\t\t<button type=\"button\"  ng-click=\"cancelCliked()\" class=\"button blank edit-data-inline\" translate>CANCEL</button>\n" +
    "\t\t\t<button type=\"button\" like-type=\"newspaper\" ng-click=\"customLikeSave()\" class=\"button green edit-data-inline\" translate>SAVE_CHANGES</button>\n" +
    "\t\t</div>\n" +
    "\t</form>\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/Likes/adRoomTypeEdit.html',
    "\n" +
    "<div class=\"data-holder move50\">\n" +
    "\t<!-- Edit Like -->\n" +
    "\t<form class=\"form inline-form float\" id=\"edit-like\" like_id=\"6\">\n" +
    "\t\t<div class=\"form-title\">\n" +
    "\t\t\t<h3>\n" +
    "\t\t\t\t<span translate>EDIT</span>\n" +
    "\t\t\t\t{{'ROOM_TYPE' | translate}}\n" +
    "\t\t\t</h3>\n" +
    "\t\t</div>\n" +
    "\n" +
    "\n" +
    "\t\t<div class=\"entry full-width float\">\n" +
    "\t\t\t<label translate>OPTIONS</label>\n" +
    "\t\t\t<div class=\"boxes\" id=\"newspaper-options\">\n" +
    "\n" +
    "\n" +
    "\n" +
    "\t\t\t\t<label class=\"checkbox inline\" ng-repeat=\"option in likeData.news_papers\">\n" +
    "\t\t\t\t\t<ad-checkboxgrp delete-action=\"checkBoxDeleteClicked($index,option.id)\" toggle=\"checkBoxClicked($index)\" label=\"{{option.name}}\" is-checked=\"option.is_checked\" option-id=\"option.id\"></ad-checkboxgrp>\n" +
    "\t\t\t\t</label>\n" +
    "\n" +
    "\t\t\t\t<label class=\"inline\" ng-show=\"showNewRoomOption\"> \n" +
    "\t\t\t\t\t<input  ng-model=\"likeData.newfeature\"/>\n" +
    "\t\t\t\t</label> \n" +
    "\t\t\t\t<label data-type=\"newspaper\" class=\"add-new-checkbox inline\" ng-click=\"shownewInputRoomOption()\">\n" +
    "\t\t\t\t\t<span class=\"icons icon-add\"></span>\n" +
    "\t\t\t\t\t{{'ADD_NEW_OPTION' | translate}}\n" +
    "\t\t\t\t</label> \n" +
    "\n" +
    "\n" +
    "\t\t\t</div>\n" +
    "\t\t</div>\n" +
    "\t\t<div class=\"actions float\">\n" +
    "\t\t\t<button type=\"button\" ng-click=\"cancelCliked()\" class=\"button blank add-data-inline\" translate>CANCEL</button>\n" +
    "\t\t\t<button type=\"button\" id=\"update\" class=\"button green add-data-inline\" ng-click=\"customLikeSave()\"translate>SAVE_CHANGES</button>\n" +
    "\t\t</div>\n" +
    "\t</form>\n" +
    "</div>\n"
  );


  $templateCache.put('/assets/partials/UserRoles/adUserRoles.html',
    "<section id=\"replacing-div-first\" class=\"content current\" ng-click=\"clearErrorMessage()\"><div data-view=\"GuestCardLikesView\">\n" +
    "\t<header class=\"content-title float\">\n" +
    "\t\t<h2>\n" +
    "\t\t\t{{'USER_ROLES' | translate}}\n" +
    "\t\t</h2>\n" +
    "\t\t<!-- Disable for now  -->\n" +
    "\t\t<!-- <a id=\"add-new-button\" class=\"action add\" ng-click=\"toggleAddMode()\">Add new</a> -->\n" +
    "\t</header>\n" +
    "\t<section class=\"content-scroll\">\n" +
    "\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\n" +
    "\n" +
    "\t\t<!-- TO DO:Add mode is partially done for now -->\n" +
    "\n" +
    "\t\t<!-- <div class=\"data-holder grid\" ng-show=\"addMode\">\n" +
    "\t\t\t<form room_type_id=\"1\" id=\"edit-room-type\" class=\"form inline-form float\">\n" +
    "\t\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t\t<h3><span>Add</span> {{'USER_ROLES' | translate}} </h3>\n" +
    "\t\t\t\t\t<em class=\"status\"> Fields marked with <strong>*</strong> are mandatory! </em>\n" +
    "\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t<fieldset class=\"holder left float\"> \n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t\t<ad-textbox value=\"newUserRole\" label = \"User Role\" placeholder = \"Enter User role\" required = \"yes\" ></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t</fieldset>\n" +
    "\t\t\t\t<fieldset class=\"holder right float\">\n" +
    "\n" +
    "\t\t\t\t\t<ad-dropdown div-class='' label=\"Role Dashboard\" label-in-drop-down=\"{{'SELECT_DASHBOARD'|translate}}\" sel-class='placeholder'  list='dashboard_types'selected-Id='selecetedDashboardId'></ad-dropdown>\n" +
    "\t\t\t\t</fieldset> \n" +
    "\n" +
    "\t\t\t\t<div class=\"actions float\">\n" +
    "\t\t\t\t\t<button type=\"button\" id=\"cancel\" class=\"button blank add-data-inline\" ng-click=\"cancelClick()\">\n" +
    "\t\t\t\t\t\t{{'USER_ROLES' | translate}}\n" +
    "\t\t\t\t\t</button>\n" +
    "\t\t\t\t\t<button type=\"button\" like-type=\"common\" id=\"update\" class=\"button green add-data-inline\" ng-click=\"saveUserRole()\">\n" +
    "\t\t\t\t\t\t{{'USER_ROLES' | translate}}\n" +
    "\t\t\t\t\t</button>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</form>\n" +
    "\t\t</div> -->\n" +
    "\t\t\n" +
    "\n" +
    "\t\t<table class=\"grid\" id=\"likes\">\n" +
    "\t\t\t<thead>\n" +
    "\t\t\t\t<th>\n" +
    "\t\t\t\t\t{{'USER_ROLES' | translate}}\n" +
    "\t\t\t\t</th>\n" +
    "\t\t\t\t<th>\n" +
    "\t\t\t\t\t{{'ROLE_DASHBOARD' | translate}}\n" +
    "\t\t\t\t</th>\n" +
    "\t\t\t</thead>\n" +
    "\t\t\t<tbody>\n" +
    "\t\t\t\t<tr ng-repeat=\"role in rolesList\" style=\"padding:50px;\">\n" +
    "\t\t\t\t\t<td>\n" +
    "\t\t\t\t\t\t{{role.name}}\n" +
    "\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t<td>\n" +
    "\t\t \t\t   \t<div class=\"entry\">\n" +
    "\t                <div class=\"select\">\n" +
    "\t                    <select class=\"placeholder\" ng-model=\"role.dashboard_id\" ng-options=\"dashboard.id as dashboard.description for dashboard in dashboard_types\" ng-change=\"changeDashBoard(role.value,role.dashboard_id)\">\n" +
    "\t                        <option value=\"\" disabled>{{'SELECT_DASHBOARD'|translate}}</option>\n" +
    "\t                    </select>\n" +
    "\t                </div>\n" +
    "\t                </div>\n" +
    "\t\t\t\t\t</td>\n" +
    "\t\t\t\t</tr>\n" +
    "\t\t\t</tbody>\n" +
    "\n" +
    "\t\t</table>\n" +
    "\t</section>\n" +
    "</section>\n"
  );


  $templateCache.put('/assets/partials/accountReceivables/adAccountReceivables.html',
    "\n" +
    "<section class=\"content current \" ng-click=\"clearErrorMessage()\">\n" +
    "\t\n" +
    "\t\t<header class=\"content-title float\">\n" +
    "\t\t\t<h2 class=\"ng-scope\" translate>ACCOUNTS_RECEIVABLES_TITLE</h2>\n" +
    "\t\t\t<a id=\"go_back\" class=\"action back ng-scope\" ng-click=\"goBackToPreviousState()\" data-type=\"load-details\" translate>BACK</a>\n" +
    "\t\t</header>\n" +
    "\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"  ></div>\n" +
    "\t\t\t<form class=\"form float ng-pristine ng-valid ng-valid-required\" method=\"post\" name=\"edit-guest-review\" style=\"overflow-y:auto;\">\n" +
    "\t\t\t\t<fieldset class=\"holder column\">\t\n" +
    "\t\t\t\t\t<div class=\"entry full-width\" is-checked=\"data.ar_number_settings.is_auto_assign_ar_numbers\" div-class=\"full-width\" label=\"Accounts Receivables\">\n" +
    "\t\t\t\t\t\t<label class=\"ng-binding\" for=\"\" ng-hide=\"label.length ==0\" translate>ACCOUNTS_RECEIVABLES_STATUS_LABEL</label>\n" +
    "\t\t\t\t\t\t<div class=\"switch-button single\" ng-class=\"{'on': data.ar_number_settings.is_auto_assign_ar_numbers}\">\n" +
    "\t\t\t\t\t\t<input class=\"ng-pristine ng-valid\" type=\"checkbox\" ng-model=\"data.ar_number_settings.is_auto_assign_ar_numbers\" >\n" +
    "\t\t\t\t\t\t<span class=\"switch-icon\"></span>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</fieldset>\n" +
    "\t\t\t\t<div class=\"actions float\">\n" +
    "\t\t\t\t\t<button id=\"cancel\" class=\"button blank add-data-inline ng-scope\" ng-click=\"goBackToPreviousState()\" type=\"button\" translate>CANCEL</button>\n" +
    "\t\t\t\t\t<button id=\"save\" class=\"button green ng-scope\" translate=\"\" ng-click=\"saveAccountReceivableStatus()\" type=\"button\" translate>SAVE_CHANGES</button>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</form>\n" +
    "\t</section>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/adApp.html',
    "<div ng-show=\"hasLoader\" id=\"loading\"><div id=\"loading-spinner\" ></div></div> \t\n" +
    "<div class=\"container\" ng-class=\"{'menu-open': isMenuOpen()}\" >\n" +
    "\t<div ng-include=\"'/assets/partials/dashboard/adBanner.html'\"></div>\n" +
    "\t<div ng-include=\"'/assets/partials/dashboard/adHeader.html'\"></div>\n" +
    "\t<!-- Hotel Admin content -->\n" +
    "\n" +
    "\t<div id=\"content\" class=\"tabs float\"  role=\"main\" data-tabs=\"dashboard-tabs\">\t\n" +
    "\n" +
    "\t   <!-- Dashboard tabs navigation -->\n" +
    "\t   <div id=\"tabs-menu\" ng-iscroll=\"tabs_menu\"  ng-iscroll-delay=\"500\">\n" +
    "\t   \t\n" +
    "\t\t   <ul style=\"width: 100%;\">\n" +
    "\t\t      <li ng-repeat=\"menu in data.menus\" ng-class=\"{'ui-state-default ui-corner-top ui-tabs-active ui-state-active': $index==selectedIndex}\"><a ui-sref='admin.dashboard({menu:$index})'>{{menu.menu_name}}</a></li>\n" +
    "\t\t   </ul>\n" +
    "\t\t</div>\n" +
    "\t\t<span ng-click=\"closeDrawer()\"><div ui-view></div></span>\n" +
    "\t</div>\n" +
    "\n" +
    "</div>\n" +
    "\n" +
    "<!--  Left nav bar - Drawer -->\n" +
    "<div ng-include=\"'/assets/partials/dashboard/adLeftNavbar.html'\"></div>\n" +
    "\n" +
    "\n"
  );


  $templateCache.put('/assets/partials/billingGroups/adBillingGroupDetails.html',
    "<div class=\"data-holder\">\n" +
    "\t<form room_type_id=\"1\" id=\"edit-room-type\" class=\"form inline-form float\">\n" +
    "\t\t<div class=\"form-title\">\n" +
    "\t\t\t<h3 ng-show=\"!isAddMode\"><span translate>EDIT</span> {{billingGroupData.title}} </h3>\n" +
    "\t\t\t<h3 ng-show=\"isAddMode\"><span translate>ADD</span> </h3>\n" +
    "\t\t\t\n" +
    "\t\t</div>\n" +
    "\t\t\n" +
    "\t\t<ad-textbox styleclass=\"full-width actions_margin_top\" value=\"billingGroupData.name\" name = \"billing-group-name\" id = \"billing-group-name\" label = \"{{ 'BILLING_GROUP_NAME' | translate }}\" placeholder = \"{{ 'BILLING_GROUP_NAME_PLACEHOLDER' | translate }}\" ></ad-textbox>\n" +
    "\t\t<div class=\"entry full-width actions_margin_top\">\n" +
    "\t\t\t\t\t<div id=\"available-charge-codes\" class=\"boxes col2\">\n" +
    "\t\t\t\t\t\t<ad-checkbox ng-repeat=\"chargeCode in billingGroupData.available_charge_codes\" is-checked=\"isChecked(chargeCode.id)\" label=\"{{chargeCode.charge_code +' - ' + chargeCode.description}}\" parent-label-class=\"room-likes\" span-class=\"checkbox-background\" ng-click=\"selectChargeCode($index)\"></ad-checkbox>\n" +
    "\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\n" +
    "\t\t<div class=\"actions float\">\n" +
    "\t\t\t<button type=\"button\" id=\"cancel\" class=\"button blank add-data-inline\" ng-click=\"clickCancel()\" translate>\n" +
    "\t\t\t\tCANCEL\n" +
    "\t\t\t</button>\n" +
    "\t\t\t<button type=\"button\" like-type=\"common\" id=\"update\" class=\"button  ng-binding green\" ng-click=\"saveBillingGroup()\" translate>\n" +
    "\t\t\t\tSAVE_CHANGES\n" +
    "\t\t\t</button>\n" +
    "\t\t</div>\n" +
    "\t</form>\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/billingGroups/adBillingGroupList.html',
    "<section class=\"content current\" ng-click='clearErrorMessage()'>\t\n" +
    "\t<div data-view=\"HotelRoomTypesView\">\n" +
    "\t\t<header class=\"content-title float\">\n" +
    "\t\t\t<h2 translate> BILLING_GROUPS </h2>\n" +
    "\t\t\t<span class=\"count\"> ({{billingGroupList.length}}) </span>\n" +
    "\t\t\t<a id=\"import-rooms\" class=\"action add\" ng-click=\"addBillingGroup()\"  translate>ADD_NEW</a>\n" +
    "\t\t</header>\n" +
    "\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t<div id=\"new-form-holder\"></div>\n" +
    "\t\t\t<span class=\"grid\" ng-show=\"isAddMode\" ng-include=\"getTemplateUrl(-1)\"></span>\n" +
    "\t\t\t<table id=\"brands\" class=\"grid\" ng-table=\"tableParams\" template-pagination=\"nil\">\n" +
    "\t\t\t\t\n" +
    "\t\t\t\t<tbody>\n" +
    "\t\t\t\t\t<tr ng-repeat=\"billingGroup in billingGroupList\" > \n" +
    "\t\t\t\t\t\t<td  colspan=\"2\" class=\"text-left\" ng-hide=\"currentClickedElement == $index\" >\n" +
    "\t\t\t\t\t\t\t<a  class=\"edit-data-inline\" ng-click=\"editBillingGroup($index, billingGroup.id)\">{{billingGroup.name}} </a>\n" +
    "\t\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td colspan=\"1\" header-class=\" width-10\"  class=\"text-left\" ng-hide=\"currentClickedElement == $index\" >\n" +
    "\t\t\t\t\t\t\t<span ng-click=\"deleteBillingGroup($index)\" class=\"icons icon-delete large-icon floor_delete\">&nbsp;</span>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t<td colspan=\"3\" ng-include=\"getTemplateUrl($index)\" ng-show=\"currentClickedElement == $index\"></td>\n" +
    "\t\t\t\t\t</tr>\n" +
    "\t\t\t\t</tbody>\n" +
    "\t\t\t</table>\n" +
    "\t\t</section>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/brands/adBrandForm.html',
    "<div style=\"display: block;border-bottom:none\" id=\"add-new\" class=\"edit-data\">\n" +
    "\t<div class=\"data-holder\">\n" +
    "\t\t<!-- Edit Brands -->\n" +
    "\t\t<form name=\"edit-brand\" method=\"post\" id=\"edit-brand-details\" data-brand-id=\"2\" class=\"form inline-form float\">\n" +
    "\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t<h3><span ng-show=\"isAddmode\"> Add </span><span ng-show=\"isEditmode\"> Edit </span> {{formTitle}} </h3>\n" +
    "\t\t\t\t<em class=\"status\"> Fields marked with <strong>*</strong> are mandatory! </em>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<fieldset class=\"holder left float\">\n" +
    "\t\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t\t<label for=\"hotel-chain\"> Hotel Chain <strong>*</strong> </label>\n" +
    "\t\t\t\t\t<div class=\"select\">\n" +
    "\t\t\t\t\t\t<select name=\"hotel-chain\" id=\"hotel-chain\" class=\"placeholder\" ng-model=\"brandDetails.hotel_chain_id\">\n" +
    "\t\t\t\t\t\t\t<option value=''>Hotel Chain</option>\n" +
    "\t\t\t\t\t\t\t<option value=\"{{chain.value}}\" ng-repeat=\"chain in brandDetails.chains\" ng-selected=\"brandDetails.hotel_chain_id == chain.value\"> {{chain.name}} </option>\n" +
    "\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t\t<ad-textbox value=\"brandDetails.name\" name = \"brand-name\" id = \"brand-name\" label = \"Name\" placeholder = \"Enter brand name\" required = \"yes\" styleclass=\"full-width\" ></ad-textbox>\n" +
    "\t\t\t</fieldset>\n" +
    "\t\t\t<div class=\"actions float\">\n" +
    "\t\t\t\t<button type=\"button\" id=\"cancel\" class=\"button blank edit-data-inline\" ng-click=\"cancelClicked()\">\n" +
    "\t\t\t\t\tCancel\n" +
    "\t\t\t\t</button>\n" +
    "\t\t\t\t<button type=\"button\" id=\"update\" class=\"button green edit-data-inline\" ng-click=\"saveClicked()\">\n" +
    "\t\t\t\t\tSave changes\n" +
    "\t\t\t\t</button>\n" +
    "\t\t\t</div>\n" +
    "\t\t</form>\n" +
    "\t</div>\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/brands/adBrandList.html',
    "<section class=\"content current\" ng-click=\"clearErrorMessage()\">\n" +
    "\t<div data-view=\"HotelBrandsView\">\n" +
    "\t\t<header class=\"content-title float\">\n" +
    "\t\t\t<h2> Brands </h2>\n" +
    "\t\t\t<span class=\"count\">({{data.length}})</span>\n" +
    "\t\t\t<a id=\"add-new-button\" class=\"action add\" ng-click=\"addNew()\">Add new</a>\n" +
    "\t\t</header>\n" +
    "\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<div id=\"new-form-holder\" ng-show=\"addFormView\" ng-include=\"getTemplateUrl('','')\"></div>\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t<div id=\"new-form-holder\" ng-show=\"isAddmode\" ng-include=\"getTemplateUrl()\"></div>\n" +
    "\t\t\t<table id=\"brands\" class=\"grid\">\n" +
    "\t\t\t\t<tbody>\n" +
    "\t\t\t\t\t<tr ng-repeat=\"brand in data\" > \n" +
    "\t\t\t\t\t\t<td ng-click=\"editBrand($index,brand.value)\" ng-hide=\"currentClickedElement == $index && isEditmode\" >\n" +
    "\t\t\t\t\t\t\t<a data-item=\"3\" data-colspan=\"2\" class=\"edit-data-inline\"> {{brand.name}} </a>\n" +
    "\t\t\t\t\t\t</td>\t\t\t\t\t\n" +
    "\t\t\t\t\t\t<td ng-include=\"getTemplateUrl($index,brand.value)\" ng-show=\"currentClickedElement == $index && isEditmode\"></td>\n" +
    "\t\t\t\t\t</tr>\n" +
    "\t\t\t\t</tbody>\n" +
    "\t\t\t</table>\n" +
    "\t\t</section>\n" +
    "\t</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/campaigns/adAddCampaign.html',
    "<section class=\"content current\" ng-click='clearErrorMessage()'>\n" +
    "\t<header class=\"content-title\" ng-show=\"mode == 'ADD'\">\n" +
    "\t    <h2 translate>NEW_CAMPAIGN_TITLE</h2>\n" +
    "\t    <a class=\"action back\" ng-click=\"gobackToCampaignListing();\" translate>BACK</a>\n" +
    "\t</header>\n" +
    "\n" +
    "\t<header class=\"content-title\" ng-show=\"mode == 'EDIT'\">\n" +
    "\t    <h2>{{'EDIT_CAMPAIGN_TITLE' |translate}}<span translate> {{campaignData.name}}</span></h2>\n" +
    "\t    <a ng-click=\"gobackToCampaignListing();\" class=\"action back\" translate> BACK</a>\n" +
    "\t    <button type=\"button\" class=\"action remove\" ng-click=\"deleteCampaign();\" translate>DELETE_CAMPAIGN</button>\n" +
    "\t</header>\n" +
    "\t<section class=\"content-scroll\">\n" +
    "\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t<div ng-include=\"'/assets/partials/common/notification_success_message.html'\"></div>\n" +
    "\n" +
    "\t\t<form method=\"post\" action=\"\" id=\"new-campaign\" name=\"new-campaign\" class=\"form campaign-details\">\n" +
    "\t\t    \n" +
    "\t\t    <fieldset class=\"holder left\">\n" +
    "\n" +
    "\t\t        <!-- Campaign details -->\n" +
    "\t\t        <div class=\"form-title\">\n" +
    "\t\t            <h3><span translate>CAMPAIGN</span> {{'DETAILS' |translate}}</h3>\n" +
    "\t\t            <em class=\"status\"> {{ 'MANDATORY_FIELDS_MESSAGE1' | translate }} <strong>*</strong> {{ 'MANDATORY_FIELDS_MESSAGE2' | translate }} </em>\n" +
    "\t\t        </div>\n" +
    "\t\t\t\t<div class=\"entry full-width\" ng-show = \"mode == 'EDIT' && campaignData.status == 'COMPLETED'\">\n" +
    "\t\t            <div id=\"campaign-completed\" class=\"notice success\">\n" +
    "\t\t                <strong translate>COMPLETED</strong>\n" +
    "\t\t                {{campaignData.completed_date}} {{getTimeConverted(campaignData.completed_time)}}\n" +
    "\t\t            </div>\n" +
    "\t\t        </div>\n" +
    "\t\t        <div class=\"entry full-width\" ng-show = \"mode == 'EDIT' && campaignData.status !== 'COMPLETED'\">\n" +
    "                    <label for=\"campaign-status\" translate>STATUS</label>\n" +
    "                    \n" +
    "                    <div class=\"switch-button\" ng-show=\"campaignData.is_recurring == 'true' && (campaignData.status == 'ACTIVE' || campaignData.status == 'INACTIVE')\" ng-class=\"{ 'on' :campaignData.status == 'ACTIVE' }\" ng-click=\"statusChanged()\"> <!-- Remove class \"on\" when checkbox is unchecked -->\n" +
    "                        <input id=\"campaign-status\" type=\"checkbox\"/>\n" +
    "                        <span class=\"switch-icon\"></span>\n" +
    "                    </div>\n" +
    "                </div>\n" +
    "\n" +
    "\t\t        \n" +
    "\t\t        <div class=\"entry full-width\">\n" +
    "\t\t            <label for=\"campaign-name\">{{'CAMPAIGN_NAME'|translate}} <strong>*</strong></label>\n" +
    "\t\t            <input type=\"text\" id=\"campaign-name\" placeholder=\"Enter Campaign name\" ng-model=\"campaignData.name\" value=\"\" required ng-disabled=\"campaignData.status == 'COMPLETED'\" ng-class=\"{'disabled_text':campaignData.status == 'COMPLETED'}\"/>\n" +
    "\t\t        </div>  \n" +
    "\t\t        <div class=\"entry short\">\n" +
    "\t\t            <label for=\"campaign-id\" translate>ID</label>\n" +
    "\t\t            <input type=\"text\" id=\"campaign-id\" value=\"campaignData.id\" ng-model=\"campaignData.id\" readonly/>\n" +
    "\t\t        </div>      \n" +
    "\t\t        <div class=\"entry full-width\">\n" +
    "\t\t            <label for=\"campaign-audience\">{{'AUDIENCE'|translate}} <strong>*</strong></label>\n" +
    "\t\t            <div class=\"boxes\">\n" +
    "\t\t                <label class=\"radio\">\n" +
    "\t\t                    <span class=\"icon-form icon-radio\" ng-class=\"{'checked': campaignData.audience_type =='DUE_IN_GUESTS'}\"></span>\n" +
    "\t\t                    <input name=\"audience\" id=\"audience-duein\" value=\"DUE_IN_GUESTS\" type=\"radio\" ng-model=\"campaignData.audience_type\" ng-disabled=\"campaignData.status == 'COMPLETED'\"/>\n" +
    "\t\t                    <span translate>DUE_IN_GUESTS</span>\n" +
    "\t\t                </label>\n" +
    "\t\t                <label class=\"radio\">\n" +
    "\t\t                    <span class=\"icon-form icon-radio\" ng-class=\"{'checked': campaignData.audience_type =='IN_HOUSE_GUESTS'}\"></span>\n" +
    "\t\t                    <input name=\"audience\" id=\"audience-inhouse\" value=\"IN_HOUSE_GUESTS\" type=\"radio\" ng-model=\"campaignData.audience_type\" ng-disabled=\"campaignData.status == 'COMPLETED'\" ng-disabled=\"campaignData.status == 'COMPLETED'\"/>\n" +
    "\t\t                    <span translate>IN_HOUSE_GUESTS</span>\n" +
    "\t\t                </label>\n" +
    "\t\t                <label class=\"radio\">\n" +
    "\t\t                    <span class=\"icon-form icon-radio\" ng-class=\"{'checked': campaignData.audience_type =='EVERYONE'}\"></span>\n" +
    "\t\t                    <input name=\"audience\" id=\"audience-everyone\" value=\"EVERYONE\" type=\"radio\" ng-model=\"campaignData.audience_type\" ng-disabled=\"campaignData.status == 'COMPLETED'\"/>\n" +
    "\t\t                    <span translate>EVERYONE</span>\n" +
    "\t\t                </label>\n" +
    "\t\t                <label class=\"radio\">\n" +
    "\t\t                    <span class=\"icon-form icon-radio\" ng-class=\"{'checked': campaignData.audience_type =='SPECIFIC_USERS'}\"></span>\n" +
    "\t\t                    <input name=\"audience\" id=\"audience-users\" type=\"radio\" value=\"SPECIFIC_USERS\" ng-model=\"campaignData.audience_type\" ng-disabled=\"campaignData.status == 'COMPLETED'\"/>\n" +
    "\t\t                    <span translate>SPECIFIC_USERS</span>\n" +
    "\t\t                </label>\n" +
    "\t\t                <input id=\"audience-specific-user\" placeholder=\"Enter User Name\" type=\"text\" ng-show=\"campaignData.audience_type =='SPECIFIC_USERS'\" ng-model=\"campaignData.specific_users\" ng-disabled=\"campaignData.status == 'COMPLETED'\" ng-class=\"{'disabled_text':campaignData.status == 'COMPLETED'}\"/> <!-- Remove class \"hidden\" when \"Specific User(s)\" option is selected. Add it back if other option is selected -->\n" +
    "\t\t            </div>\n" +
    "\t\t        </div>\n" +
    "\n" +
    "\t\t        <!-- Message -->\n" +
    "\t\t        <div class=\"form-title\">\n" +
    "\t\t            <h3><span translate>MESSAGE</span> ({{'IN_APP' |translate}})</h3>\n" +
    "\t\t            <em class=\"status\"> {{ 'MANDATORY_FIELDS_MESSAGE1' | translate }} <strong>*</strong> {{ 'MANDATORY_FIELDS_MESSAGE2' | translate }} </em>\n" +
    "\t\t        </div>\n" +
    "\t\t        <div class=\"entry full-width\">\n" +
    "\t\t            <label for=\"message-subject\">{{'MESSAGE_SUBJECT'|translate}}<strong>*</strong></label>\n" +
    "\t\t            <input type=\"text\" id=\"message-subject\" maxlength=\"{{campaignData.messageSubjectMaxLength}}\" placeholder=\"Subject or Message\" value=\"campaignData.subject\" required ng-model=\"campaignData.subject\" ng-disabled=\"campaignData.status == 'COMPLETED'\" ng-class=\"{'disabled_text':campaignData.status == 'COMPLETED'}\"/>\n" +
    "\t\t            <p class=\"counter\"><span ng-class=\"{'done': campaignData.subject.length == campaignData.messageSubjectMaxLength}\">{{campaignData.messageSubjectMaxLength - campaignData.subject.length}}</span> {{'CHARACTERS_REMINING' |translate}}</p>\n" +
    "\t\t            <!-- When counter hits 0, add class \"done\" to span element. So: <span class=\"done\">0</span>-->\n" +
    "\t\t        </div>\n" +
    "\t\t        \n" +
    "\t\t        <div class=\"entry full-width\">\n" +
    "\t\t            <label for=\"message-header\">{{'MESSAGE_HEADER_IMAGE'|translate}}<span translate>IMAGE_TYPE</span></label>\n" +
    "\t\t            <div class=\"file-upload with-preview\">\n" +
    "\t\t            \t<span class=\"input\">{{campaignData.header_file}}</span>\n" +
    "\t\t                <input type=\"file\" id=\"message-header\" ng-model=\"campaignData.header_image\" accept=\"image/*\" app-filereader ng-disabled=\"campaignData.status == 'COMPLETED'\"/>\n" +
    "\t\t                <button type=\"button\" class=\"button brand-colors\" translate>ADD_IMAGE</button>\n" +
    "\t\t            </div>\n" +
    "\t\t            <span class=\"file-preview\"><img ng-src=\"{{campaignData.header_image}}\" alt=\"\" height=\"112\" width=\"auto\"> <em ng-show=\"campaignData.header_image == '' || campaignData.header_image == undefined\" translate>PREVIEW_NOT_AVAILABLE</em></span>\n" +
    "\t\t        </div>   \n" +
    "\t\t        <div class=\"entry full-width\">\n" +
    "\t\t            <label for=\"message-body\">{{'MESSAGE_BODY'|translate}}<strong>*</strong></label>\n" +
    "\t\t            <textarea id=\"message-body\" rows=\"4\" maxlength=\"{{campaignData.messageBodyMaxLength}}\" placeholder=\"Text\" ng-model=\"campaignData.body\" ng-disabled=\"campaignData.status == 'COMPLETED'\" ng-class=\"{'disabled_text':campaignData.status == 'COMPLETED'}\"></textarea>\n" +
    "\t\t            <p class=\"counter\" ng-class = \"{'done': campaignData.messageBodyMaxLength == campaignData.body.length}\"><span>{{campaignData.messageBodyMaxLength - campaignData.body.length}}</span> {{'CHARACTERS_REMINING' |translate}}</p>\n" +
    "\t\t            <!-- When counter hits 0, add class \"done\" to span element. So: <span class=\"done\">0</span>-->\n" +
    "\t\t        </div>\n" +
    "\t\t        <div class=\"entry\">\n" +
    "\t\t            <label for=\"call-label\" translate>CALL_TO_ACTION_LABEL</label>\n" +
    "\t\t            <input type=\"text\" id=\"call-label\" placeholder=\"Text displayed on button\" ng-model=\"campaignData.call_to_action_label\" value=\"campaignData.call_to_action_label\" ng-disabled=\"campaignData.status == 'COMPLETED'\" ng-class=\"{'disabled_text':campaignData.status == 'COMPLETED'}\"/>\n" +
    "\t\t        </div>\n" +
    "\t\t        <div class=\"entry full-width\">\n" +
    "\t\t            <label for=\"call-target\" translate>CALL_TO_ACTION_TARGET</label>\n" +
    "\t\t            <input type=\"text\" id=\"call-target\" placeholder=\"Button link\" ng-model=\"campaignData.call_to_action_target\" value=\"campaignData.call_to_action_target\" ng-disabled=\"campaignData.status == 'COMPLETED'\" ng-class=\"{'disabled_text':campaignData.status == 'COMPLETED'}\"/>\n" +
    "\t\t        </div>\n" +
    "\t\t    </fieldset>\n" +
    "\t    <fieldset class=\"holder right\">\n" +
    "\t        \n" +
    "\t        <!-- Delivery -->\n" +
    "\t        <div class=\"form-title\">\n" +
    "\t            <h3><span translate>DELIVERY</span> {{'DETAILS'|translate}}</h3>\n" +
    "\t            <em class=\"status\">{{'TIME_ZONE'|translate}}<strong class=\"zone\">{{hotelTimeZoneFull}} ({{hotelTimeZoneAbbr}})</strong></em>\n" +
    "\t        </div>\n" +
    "\t        <div class=\"large-block\" ng-class = \"{'open': campaignData.is_recurring == 'false'}\">\n" +
    "\t            <label class=\"radio large\">\n" +
    "\t                <span class=\"icon-form icon-radio\" ng-class = \"{'checked': campaignData.is_recurring == 'false'}\"></span>\n" +
    "\t                <input name=\"delivery\" id=\"delivery-onetime\" value=\"false\" type=\"radio\" ng-model=\"campaignData.is_recurring\" ng-disabled=\"campaignData.status == 'COMPLETED'\"/>\n" +
    "\t                {{'ONE_TIME'|translate}}\n" +
    "\t            </label>\n" +
    "\t            \n" +
    "\t            <!-- Lines 97-148 are For future use, not for CICO-11909  -->\n" +
    "\t            <label class=\"radio small\"> <!-- // Add class \"hidden\" when \"Recurring\" is selected as option. Remove it if \"One time\" is selected as option. -->\n" +
    "\t                <span class=\"icon-form icon-radio\" ng-class = \"{'checked': campaignData.is_recurring == 'false'}\"></span>\n" +
    "\t                <input name=\"delivery-once\" id=\"delivery-immediately\" value=\"immediately\" type=\"radio\" checked />\n" +
    "\t                Immediately\n" +
    "\t            </label>\n" +
    "\t            <!-- \n" +
    "\t            <label class=\"radio small\"> // Add class \"hidden\" when \"Recurring\" is selected as option. Remove it if \"One time\" is selected as option.\n" +
    "\t                <span class=\"icon-form icon-radio\"></span>\n" +
    "\t                <input name=\"delivery-once\" id=\"delivery-scheduled\" value=\"scheduled\" type=\"radio\" />\n" +
    "\t                Scheduled\n" +
    "\t            </label> \n" +
    "\t            <div id=\"delivery-scheduled-options\" class=\"inner-block hidden\"> // Remove class \"hidden\" when Scheduled delivery is selected. Add back if Immediate delivery is selected\n" +
    "\t                <div class=\"entry has-datepicker\">\n" +
    "\t                    <label for=\"delivery-date\">Delivery Date</span></label>\n" +
    "\t                    <input id=\"delivery-date\" placeholder=\"Set Delivery Date\" class=\"datepicker\" type=\"text\" readonly />\n" +
    "\t                </div>\n" +
    "\t                <div class=\"entry\">\n" +
    "\t                    <label for=\"delivery-hour\">Delivery Time</label>\n" +
    "\t                    <div class=\"select select-col col1-3\">\n" +
    "\t                        <select id=\"delivery-hour\" class=\"placeholder\">\n" +
    "\t                            <option value=\"\" selected>HH</option>\n" +
    "\t                            <option value=\"01\">01</option>\n" +
    "\t                            <option value=\"02\">02</option>\n" +
    "\t                            <option value=\"03\">03</option>\n" +
    "\t                            <option value=\"04\">04</option>\n" +
    "\t                            <option value=\"05\">05</option>\n" +
    "\t                            <option value=\"06\">06</option>\n" +
    "\t                            <option value=\"07\">07</option>\n" +
    "\t                            <option value=\"08\">08</option>\n" +
    "\t                            <option value=\"09\">09</option>\n" +
    "\t                            <option value=\"10\">10</option>\n" +
    "\t                            <option value=\"11\">11</option>\n" +
    "\t                            <option value=\"12\">12</option>\n" +
    "\t                        </select>\n" +
    "\t                    </div>\n" +
    "\t                    <div class=\"select select-col col1-3\">\n" +
    "\t                        <select id=\"delivery-minute\" class=\"placeholder\">\n" +
    "\t                            <option value=\"\" selected>MM</option>\n" +
    "\t                            <option value=\"00\">00</option>\n" +
    "\t                            <option value=\"15\">15</option>\n" +
    "\t                            <option value=\"30\">30</option>\n" +
    "\t                            <option value=\"45\">45</option>\n" +
    "\t                        </select>\n" +
    "\t                    </div>\n" +
    "\t                    <div class=\"select select-col col1-3\">\n" +
    "\t                        <select id=\"delivery-daytime\">\n" +
    "\t                            <option value=\"AM\" selected>AM</option>\n" +
    "\t                            <option value=\"PM\">PM</option>\n" +
    "\t                        </select>\n" +
    "\t                    </div>\n" +
    "\t                </div>\n" +
    "\t            </div> -->\n" +
    "\t        </div>\n" +
    "\t        <div class=\"large-block\" ng-class = \"{'open': campaignData.is_recurring == 'true'}\">\n" +
    "\t            <label class=\"radio large\">\n" +
    "\t                <span class=\"icon-form icon-radio\" ng-class = \"{'checked': campaignData.is_recurring == 'true'}\"></span>\n" +
    "\t                <input name=\"delivery\" id=\"delivery-recurring\" value=\"true\" type=\"radio\" ng-model=\"campaignData.is_recurring\" ng-disabled=\"campaignData.status == 'COMPLETED'\"/>\n" +
    "\t                {{'RECURRING'|translate}}\n" +
    "\t            </label>\n" +
    "\t            <div class=\"inner-block\" ng-show=\"campaignData.is_recurring == 'true'\"> <!-- Remove class \"hidden\" when Recurring is selected. Add it back if \"One Time\" is selected as an option -->\n" +
    "\t                <div class=\"entry recurring first\">\n" +
    "\t                    <label class=\"label\" for=\"recurring-dayofweek\" translate>SEND</label>\n" +
    "\t                    <span class=\"delimiter\" translate>EVERY</span>\n" +
    "\t                    <div class=\"select day\">\n" +
    "\t                        <select id=\"recurring-dayofweek\" class=\"placeholder\" ng-model=\"campaignData.day_of_week\" ng-disabled=\"campaignData.status == 'COMPLETED'\">\n" +
    "\t                            <option value=\"\" translate>DAY_OF_WEEK</option>\n" +
    "\t                            <option value=\"MONDAY\" ng-selected=\"campaignData.day_of_week == 'MONDAY'\" translate>MONDAY</option>\n" +
    "\t                            <option value=\"TUESDAY\" ng-selected=\"campaignData.day_of_week == 'TUESDAY'\"translate>TUESDAY</option>\n" +
    "\t                            <option value=\"WEDNESDAY\" ng-selected=\"campaignData.day_of_week == 'WEDNESDAY'\" translate>WEDNESDAY</option>\n" +
    "\t                            <option value=\"THURSDAY\" ng-selected=\"campaignData.day_of_week == 'THURSDAY'\" translate>THURSDAY</option>\n" +
    "\t                            <option value=\"FRIDAY\" ng-selected=\"campaignData.day_of_week == 'FRIDAY'\" translate>FRIDAY</option>\n" +
    "\t                            <option value=\"SATURDAY\" ng-selected=\"campaignData.day_of_week == 'SATURDAY'\" translate>SATURDAY</option>\n" +
    "\t                            <option value=\"SUNDAY\" ng-selected=\"campaignData.day_of_week == 'SUNDAY'\" translate>SUNDAY</option>\n" +
    "\t                        </select>\n" +
    "\t                    </div>\n" +
    "\t                    <span class=\"delimiter\" translate>AT</span>\n" +
    "\t                    <div class=\"select\">\n" +
    "\t                    \t<select ng-model=\"campaignData.delivery_hour\" id=\"delivery-hour\" class=\"placeholder\" ng-disabled=\"campaignData.status == 'COMPLETED'\">\n" +
    "\t\t\t\t\t\t\t\t<option value=\"\" data-text=\"Not set\" class=\"placeholder\" translate>HH</option>\n" +
    "\t\t\t\t\t\t\t\t<option ng-repeat=\"i in [1, 12, 1, 2] | makeRange\" value=\"{{i}}\" ng-selected=\"i==campaignData.delivery_hour\" >{{i}}</option>\n" +
    "\t\t\t\t\t\t\t</select>\n" +
    "\t                    </div>\n" +
    "\t                    <div class=\"select\">\n" +
    "\t                    \t<select ng-model=\"campaignData.delivery_min\" id=\"delivery-minute\" class=\"placeholder\" ng-disabled=\"campaignData.status == 'COMPLETED'\">\n" +
    "\t\t\t\t\t\t\t\t<option value=\"\" data-text=\"Not set\" class=\"placeholder\" translate>MM</option>\n" +
    "\t\t\t\t\t\t\t\t<option ng-repeat=\"i in [0, 45, 15, 2] | makeRange\" value=\"{{i}}\" ng-selected=\"i == campaignData.delivery_min\" >{{i}}</option>\n" +
    "\t\t\t\t\t\t\t</select>\n" +
    "\t                    </div>\n" +
    "\t                    <div class=\"select\" ng-disabled=\"campaignData.status == 'COMPLETED'\" >\n" +
    "\t                        <select id=\"delivery-daytime\" ng-model=\"campaignData.delivery_primetime\" ng-disabled=\"campaignData.status == 'COMPLETED'\">\n" +
    "\t                            <option value=\"AM\" ng-selected=\"campaignData.delivery_primetime == 'AM'\" translate>AM</option>\n" +
    "\t                            <option value=\"PM\" ng-selected=\"campaignData.delivery_primetime == 'PM'\" translate>PM</option>\n" +
    "\t                        </select>\n" +
    "\t                    </div>\n" +
    "\t                </div>\n" +
    "\t                <div class=\"entry recurring\">\n" +
    "\t                    <label class=\"label\" for=\"recurring-enddate\" >{{'END'|translate}}</span></label>\n" +
    "\t                    <label class=\"radio clear\">\n" +
    "\t                        <span class=\"icon-form icon-radio\" ng-class=\"{'checked' : campaignData.recurring_end_type == 'NEVER'}\"></span>\n" +
    "\t                        <input name=\"recurring-tempo\" id=\"recurring-tempo-never\" type=\"radio\" ng-model=\"campaignData.recurring_end_type\" value = \"NEVER\" ng-disabled=\"campaignData.status == 'COMPLETED'\"/>\n" +
    "\t                        {{'NEVER'|translate}}\n" +
    "\t                    </label>\n" +
    "\t                    <label class=\"radio\">\n" +
    "\t                        <span class=\"icon-form icon-radio\" ng-class=\"{'checked' : campaignData.recurring_end_type == 'END_OF_DAY'}\"></span>\n" +
    "\t                        <input name=\"recurring-tempo\" id=\"recurring-tempo-date\" ng-model=\"campaignData.recurring_end_type\" value = \"END_OF_DAY\" type=\"radio\" ng-disabled=\"campaignData.status == 'COMPLETED'\"/>\n" +
    "\t                        {{'AT_END_OF_DAY'|translate}}\n" +
    "\t                    </label>\n" +
    "\t                    <div id=\"recurring-datepicker\" class=\"has-datepicker\" ng-show = \"campaignData.recurring_end_type == 'END_OF_DAY'\"> <!-- Remove class \"hidden\" when \"At End Of Day\" is selected. Add when \"Never\" is selected. -->\n" +
    "\t                        <input id=\"delivery-date\" placeholder=\"Set Delivery Date\" class=\"datepicker\" type=\"text\" readonly ng-click = \"showDatePicker();\" ng-show=\"campaignData.end_date_for_display == '' || campaignData.end_date_for_display == undefined\" ng-disabled=\"campaignData.status == 'COMPLETED'\"/>\n" +
    "\t                        <input id=\"delivery-date\" placeholder=\"{{campaignData.end_date_for_display | date : dateFormat }}\" class=\"datepicker\" type=\"text\" readonly ng-click = \"showDatePicker();\" ng-hide=\"campaignData.end_date_for_display == '' || campaignData.end_date_for_display == undefined\" ng-disabled=\"campaignData.status == 'COMPLETED'\"/>\n" +
    "\t                    </div>\n" +
    "\t                </div>\n" +
    "\t            </div>\n" +
    "\t        </div> \n" +
    "\n" +
    "\t        <!-- Notifications -->\n" +
    "\t        <div class=\"form-title\">\n" +
    "\t            <h3><span translate>NOTIFICATIONS</span> ({{'OUTSIDE_APP'|translate}})</h3>\n" +
    "\t            <em class=\"status\"> {{ 'MANDATORY_FIELDS_MESSAGE1' | translate }} <strong>*</strong> {{ 'MANDATORY_FIELDS_MESSAGE2' | translate }} </em>\n" +
    "\t        </div>\n" +
    "\t        <div class=\"entry full-width\">\n" +
    "\t            <label for=\"notification-ios8\">{{'NOTIFICATION_BANNER_OR_ALERT'|translate}}<span>({{'IOS8'|translate}})</span><strong>*</strong></label>\n" +
    "\t            <textarea id=\"notification-ios8\" rows=\"1\" maxlength=\"{{campaignData.ios8_alert_length}}\" placeholder=\"Text\" ng-model=\"campaignData.alert_ios8\" ng-disabled=\"campaignData.status == 'COMPLETED'\" ng-class=\"{'disabled_text':campaignData.status == 'COMPLETED'}\"></textarea>\n" +
    "\t            <p class=\"counter\"><span ng-class= \"{'done': campaignData.ios8_alert_length == campaignData.alert_ios8.length}\">{{campaignData.ios8_alert_length - campaignData.alert_ios8.length}}</span>&nbsp;{{'CHARACTERS_REMINING' |translate}}</p>\n" +
    "\t            <!-- When counter hits 0, add class \"done\" to span element. So: <span class=\"done\">0</span>-->\n" +
    "\t        </div>\n" +
    "\t        <div class=\"entry full-width\">\n" +
    "\t            <label for=\"notification-ios7\">{{'NOTIFICATION_BANNER_OR_ALERT'|translate}}<span>({{'IOS7'|translate}})</span><strong>*</strong></label>\n" +
    "\t            <textarea id=\"notification-ios7\" rows=\"1\" maxlength=\"{{campaignData.ios7_alert_length}}\" placeholder=\"Text\" ng-model=\"campaignData.alert_ios7\" ng-disabled=\"campaignData.status == 'COMPLETED'\" ng-class=\"{'disabled_text':campaignData.status == 'COMPLETED'}\"></textarea>\n" +
    "\t            <p class=\"counter\"><span ng-class= \"{'done': campaignData.ios7_alert_length == campaignData.alert_ios7.length}\">{{campaignData.ios7_alert_length - campaignData.alert_ios7.length}}</span> {{'CHARACTERS_REMINING' |translate}}</p>\n" +
    "\t            <!-- When counter hits 0, add class \"done\" to span element. So: <span class=\"done\">0</span>-->\n" +
    "\t        </div>          \n" +
    "\t    </fieldset>\n" +
    "\t    \n" +
    "\t    <div class=\"actions\" ng-show = \"mode == 'ADD'\">\n" +
    "\t        <button type=\"button\" class=\"button blank\" ng-click=\"gobackToCampaignListing();\" translate>CANCEL</button>\n" +
    "\t        <button type=\"button\" class=\"button blue\" ng-click=\"saveAsDraft()\" translate>SAVE_AS_DRAFT</button> \n" +
    "\t        <button type=\"button\" class=\"button green\" ng-click=\"startCampaignPressed()\" translate>START_CAMPAIGN</button>\n" +
    "\t    </div>\n" +
    "\n" +
    "\t    <div class=\"actions\" ng-show = \"mode == 'EDIT' && campaignData.status !== 'COMPLETED'\">\n" +
    "            <button type=\"button\" class=\"button blank\" ng-click=\"gobackToCampaignListing();\" translate>CANCEL</button>\n" +
    "            <button type=\"button\" class=\"button green\" ng-click=\"saveAsDraft()\" translate>SAVE</button>\n" +
    "\t        <button type=\"button\" class=\"button green\" ng-click=\"startCampaignPressed()\" ng-show=\"campaignData.status == 'DRAFT'\" translate>START_CAMPAIGN</button>\n" +
    "        </div>\n" +
    "\n" +
    "        <div class=\"actions\" ng-show = \"mode == 'EDIT' && campaignData.status == 'COMPLETED'\">\n" +
    "            <button type=\"button\" class=\"button blank\" ng-click=\"gobackToCampaignListing();\" translate>CLOSE</button>\n" +
    "        </div>\n" +
    "\t</form>\n" +
    "\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/campaigns/adCampaignDatepicker.html',
    "<div ui-date=\"dateOptions\" ng-model=\"campaignData.end_date\" ui-date-format=\"yy-mm-dd\"></div>\n"
  );


  $templateCache.put('/assets/partials/campaigns/adCampaignsList.html',
    "<section class=\"content content-holder current\" id=\"load-listing\" ng-click='clearErrorMessage()'>\n" +
    "\t\t<header class=\"content-title\">\n" +
    "\t\t    <h2 translate>CAMPAIGNS_LIST_TITLE</h2>\n" +
    "\t\t    <a ui-sref=\"admin.addCampaign\" class=\"action add\" translate>CAMPAIGN</a>\n" +
    "\t\t</header>\n" +
    "\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_success_message.html'\"></div>\n" +
    "\t\t\t<!-- <div id=\"new-form-holder\" ng-show=\"currentClickedElement == 'new'\" ng-include=\"'/assets/partials/keyEncoders/adEncoderAdd.html'\"></div> -->\n" +
    "\n" +
    "\t\t\t<!-- <div id=\"new-form-holder\"></div> -->\n" +
    "\n" +
    "\t\t\t<!--ng-table component -->\n" +
    "\t\t\t<table id=\"\" class=\"grid datatable campaign-grid\" ng-table=\"tableParams\" template-pagination=\"custom/pager\">\n" +
    "\t\t\t\t<tbody>\n" +
    "\t\t\t\t\t<tr ng-repeat=\"campaign in $data\"> \n" +
    "\t\t\t\t\t\t<td data-title=\"'ID'\"  header-class=\"id\" >\n" +
    "\t\t\t\t\t\t\t<span> {{campaign.id}}</span>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t<td data-title=\"'Name'\"  sortable=\"'name'\" header-class=\"name\" >\n" +
    "\t\t\t\t\t\t\t<a class=\"edit-data\" ng-click=\"editCampaign(campaign.id, $index)\" >\n" +
    "\t\t\t\t\t\t\t\t<span>\n" +
    "\t\t\t\t\t\t\t\t\t{{campaign.name}}\n" +
    "\t\t\t\t\t\t\t\t</span>\n" +
    "\t\t\t\t\t\t\t</a>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td data-title=\"'Audience'\" sortable=\"'audience_type'\" header-class=\"\" >\n" +
    "\t\t\t\t\t\t\t<span>\n" +
    "\t\t\t\t\t\t\t\t{{campaign.audience_type}}\n" +
    "\t\t\t\t\t\t\t</span>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td data-title=\"'Delivery'\" sortable=\"'delivery'\" header-class=\"\" >\n" +
    "\t\t\t\t\t\t\t<span>\n" +
    "\t\t\t\t\t\t\t\t{{campaign.delivery}}\n" +
    "\t\t\t\t\t\t\t</span>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td data-title=\"'Status'\" sortable=\"'status'\" header-class=\"\" class=\"status\" ng-class=\"{'draft': campaign.status== 'DRAFT', 'active': campaign.status== 'ACTIVE', 'completed': campaign.status== 'COMPLETED'}\">\n" +
    "\t\t\t\t\t\t\t{{campaign.status}}\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\n" +
    "\t\t\t\t\t\t<td data-title=\"'Last Update'\" sortable=\"'last_updated_date'\" header-class=\"\">\n" +
    "\t\t\t\t\t\t\t<em>{{campaign.last_updated_date | date : dateFormat }} {{getTimeConverted(campaign.last_updated_time)}}</em>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\n" +
    "\t\t\t\t\t\t<td class=\"delete\" data-title=\"'Delete'\" header-class=\"delete\">\n" +
    "\t\t\t                <button type=\"button\" class=\"icons icon-delete large-icon\" ng-click=\"deleteCampaign(campaign.id);\">Delete</button>\n" +
    "\t\t\t            </td>\t\t\t\t\t\t\n" +
    "\t\t\t\t\t</tr> \n" +
    "\t\t\t\t</tbody>\n" +
    "\t\t\t</table>\n" +
    "\t\t</section>\n" +
    "\t\t<!--end -->\n" +
    "\n" +
    "\t\t<!--Custom pagination footer goes here-->\n" +
    "\t\t<script type=\"text/ng-template\" id=\"custom/pager\">\n" +
    "\t\t\t<div class = \"pager\">\n" +
    "\t\t\t\t<span ng-show=\"totalCount>0\">Showing {{startCount}} to {{endCount}} of {{totalCount}} items</span>\n" +
    "\t\t\t\t<span ng-show=\"totalCount==0\">Showing 0 items</span>\n" +
    "\t\t\t\t<ul class=\"ng-cloak\">\n" +
    "\t              \t<li ng-repeat=\"page in pages\"\n" +
    "\t\t                ng-class=\"{'previous': page.type == 'prev', 'next': page.type == 'next'}\"\n" +
    "\t\t                ng-show=\"page.type == 'prev' || page.type == 'next'\" ng-switch=\"page.type\">\n" +
    "\t\n" +
    "\t\t                <a ng-switch-when=\"prev\" ng-click=\"params.page(1)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">First</a>\n" +
    "\t\t                <a ng-switch-when=\"prev\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">Previous</a>\n" +
    "\t\t                <a ng-switch-when=\"prev\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">{{page.number}}</a>\n" +
    "\t\t                \n" +
    "\t\t                <a ng-switch-when=\"next\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">{{page.number}}</a>\n" +
    "\t\t                <a ng-switch-when=\"next\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">Next</a>\n" +
    "\t\t                <a ng-switch-when=\"next\" ng-click=\"params.page(totalPage)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">Last</a>\n" +
    "\t\t          \t</li>\n" +
    "\t            </ul>\n" +
    "\t        </div>\n" +
    "\t\t</script>\n" +
    "\t\t<!--end-->\n" +
    "</section>\n" +
    "\n" +
    "<div id=\"new-form-holder\" ng-show=\"isAddmode\" ng-include=\"getAddRateTemplateUrl()\">\n"
  );


  $templateCache.put('/assets/partials/chains/adChainForm.html',
    "<div style=\"display: block;\" id=\"add-new\" class=\"edit-data\">\n" +
    "\t<div class=\"data-holder\" >\n" +
    "\t\t\n" +
    "\t\t<!-- Add chain -->\n" +
    "\t\t<form class=\"form inline-form float\">\n" +
    "\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t<h3>\n" +
    "\t\t\t\t\t<span></span>\n" +
    "\t\t\t\t\t{{formTitle}}\n" +
    "\t\t\t\t</h3>\n" +
    "\t\t\t\t<em class=\"status\">\n" +
    "\t\t\t\t\tFields marked with\n" +
    "\t\t\t\t\t<strong>*</strong>\n" +
    "\t\t\t\t\tare mandatory!\n" +
    "\t\t\t\t</em>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<fieldset class=\"holder left float\">\n" +
    "\n" +
    "\n" +
    "\t\t\t\t<!-- hotel code -->\n" +
    "\n" +
    "\t\t\t\t<ad-textbox value=\"editData.hotel_code\"   label = \"Chain Code\" placeholder = \"Enter chain code\" required = \"yes\" styleclass=\"full-width\"></ad-textbox>\n" +
    "\t\t\t\t<!--  import freaquency -->\n" +
    "\t\t\t\t<ad-textbox value=\"editData.import_frequency\"   label = \"Import Frequency [Minutes]\" placeholder = \"Enter import frequency\" required = \"yes\" styleclass=\"full-width\"></ad-textbox>\n" +
    "\n" +
    "\t\t\t</fieldset>\n" +
    "\t\t\t<fieldset class=\"holder right float\">\n" +
    "\t\t\t\t<!-- name  -->\n" +
    "\n" +
    "\t\t\t\t<ad-textbox value=\"editData.name\"   label = \"Chain Name\" placeholder = \"Enter chain name\" required = \"yes\" styleclass=\"full-width\"></ad-textbox>\n" +
    "\n" +
    "\t\t\t</fieldset>\n" +
    "\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t<h3>\n" +
    "\t\t\t\t\t<span></span>\n" +
    "\t\t\t\t\tSFTP Settings\n" +
    "\t\t\t\t</h3>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<fieldset class=\"holder left float\">\n" +
    "\n" +
    "\t\t\t\t<!-- sftp location -->\n" +
    "\n" +
    "\t\t\t\t<ad-textbox value=\"editData.sftp_location\"   label = \"SFTP Location\" placeholder = \"Enter SFTP Location\"  styleclass=\"full-width\"></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t<!-- sftp port -->\n" +
    "\n" +
    "\t\t\t\t<ad-textbox value=\"editData.sftp_port\"   label = \"SFTP Port\" placeholder = \"Enter SFTP Port\"  styleclass=\"full-width\"></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t<!-- sftp user -->\n" +
    "\n" +
    "\t\t\t\t<ad-textbox value=\"editData.sftp_user\"   label = \"SFTP user\" placeholder = \"Enter SFTP User\"  styleclass=\"full-width\"></ad-textbox>\n" +
    "\n" +
    "\t\t\t</fieldset>\n" +
    "\t\t\t<fieldset class=\"holder right float\">\n" +
    "\n" +
    "\t\t\t\t<!--  sftp password-->\n" +
    "\t\t\t\t<ad-textbox inputtype=\"password\" value=\"editData.sftp_password\"   label = \"SFTP Password\" placeholder = \"Enter SFTP Password\"  styleclass=\"full-width\"></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t<!--  sftp respath-->\n" +
    "\t\t\t\t<ad-textbox value=\"editData.sftp_respath\"   label = \"SFTP Respath\" placeholder = \"Enter SFTP Respath\"  styleclass=\"full-width\"></ad-textbox>\n" +
    "\n" +
    "\t\t\t</fieldset>\n" +
    "\n" +
    "\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t<h3>\n" +
    "\t\t\t\t\t<span></span>\n" +
    "\t\t\t\t\tHotel MLI Settings\n" +
    "\t\t\t\t</h3>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<fieldset class=\"holder right float\">\n" +
    "\t\n" +
    "\t\t\t\t <div class=\"entry full-width\">\n" +
    "\t\t\t\t\t<label for=\"certificate\">CA Certificate </label>\n" +
    "\t\t\t\t\t<div class=\"file-upload\">\n" +
    "\t\t\t\t\t\t<span class=\"input\">{{fileName}}</span>\n" +
    "\t\t\t\t\t\t<input type=\"file\" ng-model=\"editData.ca_certificate\" accept=\"*\" app-filereader />\n" +
    "\t\t\t\t\t\t<button type=\"button\" class=\"button brand-colors\">\n" +
    "\t\t\t\t\t\t\t Attach Certificate\n" +
    "\t\t\t\t\t\t</button> \n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</fieldset>\n" +
    "\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t<h3>\n" +
    "\t\t\t\t\t<span></span>\n" +
    "\t\t\t\t\tSetup Loyalty\n" +
    "\t\t\t\t</h3>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<fieldset class=\"holder left float\">\n" +
    "\t\t\t\t<!-- program name -->\n" +
    "\t\t\t\t<ad-textbox value=\"editData.loyalty_program_name\"   label = \"Program Name\" placeholder = \"Enter Program Name\"  styleclass=\"full-width\"></ad-textbox>\n" +
    "\t\t\t\t<!--  program code-->\n" +
    "\n" +
    "\t\t\t\t<ad-textbox value=\"editData.loyalty_program_code\"   label = \"Program Code\" placeholder = \"Enter Program Code\"  styleclass=\"full-width\"></ad-textbox>\n" +
    "\n" +
    "\n" +
    "\t\t\t</fieldset>\n" +
    "\t\t\t<fieldset class=\"holder right float\">\n" +
    "\t\t\t\t<div id=\"entry-select\" class=\"data-type\">\n" +
    "\t\t\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t\t\t<label for=\"select-option1\">\n" +
    "\t\t\t\t\t\t\tLevels\n" +
    "\t\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t\t<div class=\"entry\" ng-repeat=\"lov in editData.lov track by $index\">\n" +
    "\t\t\t\t\t\t\t<input type=\"text\"  placeholder=\"Add new option\" name=\"lov\" ng-focus=\"onFocus($index)\" ng-blur=\"onBlur($index)\" ng-change=\"textChanged($index)\" data-type=\"select\" class=\"add-new-option\"\n" +
    "\t\t\t\t\t\t\tng-model=\"lov.name\" value=\"{{lov.name}}\" >\n" +
    "\t\t\t\t\t\t\t<input type=\"text\" ng-model=\"lov.value\" ng-hide=\"true\">\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</fieldset>\n" +
    "\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t<h3>\n" +
    "\t\t\t\t\t<span></span>\n" +
    "\t\t\t\t\tSetup Terms and Conditions\n" +
    "\t\t\t\t</h3>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<fieldset class=\"holder left float\">\n" +
    "\t\t\t\t<!-- t&c phone -->\n" +
    "\t\t\t\t<ad-textbox value=\"editData.terms_cond_phone\"   label = \"CONTACT PHONE FOR T&amp;C\" placeholder = \"Enter phone number\"  styleclass=\"full-width\"></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t\t<label for=\"terms_and_condtn\">\n" +
    "\t\t\t\t\t\tTerms &amp; Conditions\n" +
    "\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t<textarea value=\"\" type=\"\" required=\"\" placeholder=\"Enter Terms &amp; Conditions\" name=\"terms_and_condtn\" ng-model=\"editData.terms_cond\" class=\"full-width\"></textarea>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</fieldset>\n" +
    "\t\t\t<fieldset class=\"holder right float\">\n" +
    "\t\t\t\t<!-- t&c email -->\n" +
    "\n" +
    "\t\t\t\t<ad-textbox value=\"editData.terms_cond_email\"   label = \"CONTACT EMAIL FOR T&amp;C\" placeholder = \"Enter e-mail\"  styleclass=\"full-width\"></ad-textbox>\n" +
    "\n" +
    "\t\t\t</fieldset>\n" +
    "\n" +
    "\t\t\t<div class=\"actions float\">\n" +
    "\t\t\t\t<button type=\"button\" ng-click=\"cancelClicked()\" class=\"button blank edit-data-inline\">Cancel</button>\n" +
    "\t\t\t\t<button type=\"button\" id=\"save\" class=\"button green edit-data-inline\" ng-click=\"saveClicked()\">Save changes</button>\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t</form>\n" +
    "\t</div>\n" +
    "</div>\n" +
    "\n"
  );


  $templateCache.put('/assets/partials/chains/adChainList.html',
    "<section id=\"replacing-div-first\" class=\"content current\" ng-click=\"clearErrorMessage()\" ><div data-view=\"HotelChainsView\">\n" +
    "\t<header class=\"content-title float\">\n" +
    "\t\t<h2>\n" +
    "\t\t\tChains\n" +
    "\t\t</h2>\n" +
    "\t\t<span class=\"count\">\n" +
    "\t\t\t(\n" +
    "\t\t\t{{chainsList.length}}\n" +
    "\t\t\t)\n" +
    "\t\t</span>\n" +
    "\t\t<a id=\"add-new-button\" ng-click=\"addNew()\" class=\"action add\">Add new</a>\n" +
    "\t</header>\n" +
    "\t<section class=\"content-scroll\">\n" +
    "\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t<div id=\"new-form-holder\" ng-show=\"isAddmode\" ng-include=\"getTemplateUrl()\">\n" +
    "\t\t</div>\n" +
    "\t\t<table id=\"brands\" class=\"grid\" >\n" +
    "\t\t\t<tbody>\n" +
    "\t\t\t\t<tr ng-repeat=\"chain in chainsList\">\n" +
    "\t\t\t\t\t<td width=\"90%\" ng-click=\"editSelected($index,chain.value)\" ng-hide=\"currentClickedElement == $index && isEditmode\">\n" +
    "\t\t\t\t\t\t<a  data-colspan=\"2\" class=\"edit-data-inline\">\n" +
    "\t\t\t\t\t\t\t{{chain.name}}\n" +
    "\t\t\t\t\t\t</a>\n" +
    "\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t<td width=\"10%\" ng-hide=\"currentClickedElement == $index && isEditmode\">\n" +
    "\t\t\t\t\t\t<em></em>\n" +
    "\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t<td colspan=\"2\" ng-include=\"getTemplateUrl()\" ng-show=\"currentClickedElement == $index && isEditmode\"></td>\n" +
    "\t\t\t\t</tr>\n" +
    "\t\t\t</tbody>\n" +
    "\t\t</table>\n" +
    "\t</section>\n" +
    "</div>\n" +
    "</section>\n" +
    "\n" +
    "\n" +
    "\n" +
    "\n"
  );


  $templateCache.put('/assets/partials/chargeCodes/adChargeCodeDetailsForm.html',
    "<div style=\"display: block;\" id=\"add-new\" class=\"edit-data\">\n" +
    "\t<div class=\"data-holder\">\n" +
    "\t\t<form class=\"form inline-form float\">\n" +
    "\t\t\t<fieldset class=\"holder left\">\n" +
    "\t\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t\t<h3><span translate>CHARGE_CODE</span> {{'DETAILS' | translate}} </h3>\n" +
    "\t\t\t\t\t<em class=\"status\"> {{'MANDATORY_FIELDS_MESSAGE1'| translate}} <strong>*</strong>{{'MANDATORY_FIELDS_MESSAGE2' | translate}} </em>\t\t\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t\t\n" +
    "\t\t\t\t<ad-textbox value=\"prefetchData.code\" label = \"{{'CHARGE_CODE'| translate}}\" placeholder = \"{{'CHARGE_CODE_PLACEHOLDER'| translate}}\" required = \"yes\" styleclass=\"full-width\" ></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t<ad-textarea rows=\"4\" div-class=\"full-width\" text-area-class=\"full-width\" value=\"prefetchData.description\" label = \"{{'DESCRIPTION'| translate}} \" placeholder = \"{{'DESC_PLACEHOLDER' | translate }}\" required=\"true\"></ad-textarea>\n" +
    "\n" +
    "\t\t\t\t<ad-dropdown label=\"{{'CHARGE_GROUP'| translate}}\" label-in-drop-down=\"{{'CHARGE_GROUP'| translate}}\" list=\"prefetchData.charge_groups\" selected-Id='prefetchData.selected_charge_group' required = \"yes\" div-class=\"full-width\"></ad-dropdown>\n" +
    "\n" +
    "\t\t\t\t<ad-dropdown label=\"{{'CHARGE_CODE_TYPE'| translate}}\" label-in-drop-down=\"{{'CHARGE_CODE_TYPE'| translate}}\" list=\"prefetchData.charge_code_types\" selected-Id='prefetchData.selected_charge_code_type' required = \"yes\" div-class=\"full-width\"></ad-dropdown>\n" +
    "\n" +
    "\t\t\t\t<!-- show For charge codes of the code type Payment -->\n" +
    "\t\t\t\t<div class=\"entry full-width\" required=\"required\" ng-show=\"prefetchData.selected_charge_code_type == '2'\" >\n" +
    "\t\t\t\t\t<label class=\"ng-binding\" ng-hide=\"label.length==0\" for=\"\" >\n" +
    "\t\t\t\t\t\t{{'PAYMENT_TYPE'| translate}}\n" +
    "\t\t\t\t\t\t<strong class=\"\" ng-show=\"isStandAlone\"> * </strong>\n" +
    "\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t<div class=\"select\">\n" +
    "\t\t\t\t\t\t<select name=\"payment-type\" ng-model = \"selected_payment_type.id\"   ng-change=\"changeSelectedPaymentType()\" >\n" +
    "\t\t\t\t\t\t\t<option value=\"\" ng-class=\"{'placeholder': selected_payment_type.id == ''}\" translate>PAYMENT_TYPE</option>\n" +
    "\t\t\t\t\t\t\t<option value=\"{{paymentType.id}}\" ng-selected=\"(paymentType.value==prefetchData.selected_payment_type && (paymentType.is_cc_type == prefetchData.is_cc_type))\" ng-repeat=\"paymentType in prefetchData.payment_types\">\n" +
    "\t\t\t\t\t\t\t{{paymentType.description}} \n" +
    "\t\t\t\t\t\t\t</option>\n" +
    "\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t\t<div class=\"entry full-width\" required=\"required\" ng-show=\"prefetchData.selected_charge_code_type == '2'\" >\n" +
    "\t\t\t\t\t<label class=\"ng-binding\" ng-hide=\"label.length==0\" for=\"\" >\n" +
    "\t\t\t\t\t\t{{'FEES'| translate}}\n" +
    "\t\t\t\t\t\t<strong class=\"\" ng-show=\"isStandAlone\"> * </strong>\n" +
    "\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t<div class=\"select\">\n" +
    "\t\t\t\t\t\t<select name=\"payment-type\" ng-model=\"prefetchData.selected_fees_code\">\n" +
    "\t\t\t\t\t\t\t<option value=\"\">Select Fees</option>\n" +
    "\t\t\t\t\t\t\t<option value=\"{{feesCode.value}}\" ng-selected=\"feesCode.value == prefetchData.selected_fees_code\" ng-repeat=\"feesCode in prefetchData.fees_codes\">\n" +
    "\t\t\t\t\t\t\t{{feesCode.name}} {{feesCode.description}}\n" +
    "\t\t\t\t\t\t\t</option>\n" +
    "\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t<!-- show For charge codes of the code type TAX or FEES , for standalone hotels-->\n" +
    "\t\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t\t<ad-textbox value=\"prefetchData.minimum_amount_for_fees\" ng-show=\"(prefetchData.selected_charge_code_type == '1' || prefetchData.selected_charge_code_type == '6') && !isPmsConfigured\" inputtype=\"text\" value=\"\" label = \"{{'MINIMUM_AMOUNT_TO_CHARGE_FEE'| translate}}\" placeholder = \"\" styleclass=\"full-width\" ></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t\t<div ng-show=\"(prefetchData.selected_charge_code_type == '1' || prefetchData.selected_charge_code_type == '6') && !isPmsConfigured\" class=\"entry full-width\" >\n" +
    "\t\t\t\t\t\t<label translate> AMOUNT </label>\n" +
    "\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t<div class=\"select select-col col1-3 \">\n" +
    "\t\t\t\t\t\t\t<select ng-model=\"prefetchData.selected_amount_sign\" class=\"styled\">\n" +
    "\t                        \t<option ng-repeat=\"sign in ['+','-']\" ng-selected=\"sign==prefetchData.selected_amount_sign\" value=\"{{sign}}\">{{sign}}</option>\n" +
    "\t                        </select>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t<div class=\" select-col col1-3 \" >\n" +
    "\t\t\t\t\t\t\t<ad-textbox value=\"prefetchData.amount\" inputtype=\"text\" value=\"\" styleclass = \"col1-3\"\tlabel = \"\" placeholder = \"\" style=\"  margin-top: 0; width: 66px;\"></ad-textbox>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\t\t\t\t\t\t\t<select ng-model=\"prefetchData.selected_amount_symbol\" class=\"styled\">\n" +
    "\t                            <option ng-repeat='symbol in prefetchData.symbolList'  ng-selected=\"symbol.name===prefetchData.selected_amount_symbol\" value=\"{{symbol.name}}\">{{symbol.value}}</option>\n" +
    "\t                        </select>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t<!-- show For charge codes of the code type TAX only -->\n" +
    "\t\t\t\t\t<div ng-show=\"(prefetchData.selected_charge_code_type == '1') && !isPmsConfigured\">\n" +
    "\t\t\t\t\t\t<ad-dropdown label=\"{{'AMOUNT_TYPE' | translate}}\" div-class=\"full-width\"  label-in-drop-down=\"{{'SELECT_AMOUNT_TYPE' | translate}}\" list=\"prefetchData.amount_types\" selected-Id=\"prefetchData.selected_amount_type\" ></ad-dropdown>\n" +
    "\t\t\t\t\t\t<ad-dropdown label=\"{{'POST_TYPE' | translate}}\" div-class=\"full-width\"  label-in-drop-down=\"{{'Select Post Type' | translate}}\" list=\"prefetchData.post_types\" selected-Id=\"prefetchData.selected_post_type\" ></ad-dropdown>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t\t\n" +
    "\n" +
    "\t\t\t</fieldset>\n" +
    "\t\t\t\n" +
    "\t\t\t<fieldset class=\"holder right\">\n" +
    "\t\t\t\t<!-- to hide the chrage codes if type is TAX. Since we need to show the charge codes on change type -->\n" +
    "\t\t\t\t<div ng-hide=\"prefetchData.selected_charge_code_type == '1' || !isPmsConfigured \">\n" +
    "\t\t\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t\t\t<h3><span translate>CHARGE_CODE</span> {{'LINK_WITH' | translate}} </h3>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t\t\t<div id=\"room-key-for-rover\" class=\"boxes\">\n" +
    "\t\t\t\t\t\t\t<div class=\"entry radio-check\" ng-repeat=\"link in prefetchData.link_with\">\n" +
    "\t\t\t\t\t\t\t\t<label class=\"checkbox\" ng-class=\"{ checked : link.is_checked === 'true' }\"> <span class=\"icon-form icon-checkbox\" ng-class=\"{ checked : link.is_checked === 'true' }\"></span> <label for=\"link-with-1\"></label>\n" +
    "\t\t\t\t\t\t\t\t\t<input type=\"checkbox\"  ng-click=\"link.is_checked =(link.is_checked  === 'true')? 'false':'true'\">\n" +
    "\t\t\t\t\t\t\t\t\t{{link.name}} </label>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t\t<!--for charge code type other than PAYMENT or TAX -->\n" +
    "\t\t\t\t<div ng-hide=\"isPmsConfigured || prefetchData.selected_charge_code_type == '1' || prefetchData.selected_charge_code_type == '2'\" ng-include=\"'/assets/partials/chargeCodes/adListTax.html'\" ></div>\n" +
    "\n" +
    "\t\t\t</fieldset>\n" +
    "\n" +
    "\t\t\t<div class=\"actions float\">\n" +
    "\t\t\t\t<button type=\"button\" ng-click=\"clickedCancel()\" class=\"button blank edit-data-inline\" translate>\n" +
    "\t\t\t\t\tCANCEL\n" +
    "\t\t\t\t</button>\n" +
    "\t\t\t\t<button type=\"button\" ng-click=\"clickedSave()\" class=\"button green edit-data-inline\" translate>\n" +
    "\t\t\t\t\tSAVE_CHANGES\n" +
    "\t\t\t\t</button>\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t</form>\n" +
    "\t</div>\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/chargeCodes/adChargeCodes.html',
    "<section id=\"replacing-div-first\" class=\"content current\" ng-click=\"clearErrorMessage()\">\n" +
    "\t<div>\n" +
    "\t\t<header class=\"content-title float\">\n" +
    "\t\t\t<h2 translate>\n" +
    "\t\t\t\tCHARGE_CODE\n" +
    "\t\t\t</h2>\n" +
    "\t\t\t<span class=\"count\">\n" +
    "\t\t\t\t({{totalCount}})\n" +
    "\t\t\t</span>\n" +
    "\t\t\t<a ng-click=\"addNewClicked()\" class=\"action add\" translate>ADD_NEW</a>\n" +
    "\t\t\t<a ng-show=\"is_connected_to_pms =='true'\"  ng-click=\"importFromPmsClicked($event)\" class=\"action import\" translate>IMPORT_FROM_PMS</a>\n" +
    "\t\t</header>\n" +
    "\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_success_message.html'\"></div>\n" +
    "\t\t\t<div id=\"new-form-holder\" ng-if=\"isAdd\" ng-include=\"getTemplateUrl()\"></div>\n" +
    "\t\t\t\n" +
    "\t\t\t<span class=\"count-show\">Show</span>\n" +
    "\t\t\t<div class=\"select table-count rates-table-count\">\n" +
    "\t\t\t\t<select ng-model=\"displyCount\"\tng-options=\"opt for opt in displayCountList\"></select>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<span class=\"count-entries\">entries</span>\n" +
    "\t\t\t\t\n" +
    "\t\t\t<div class=\"entry table-search\">\n" +
    "\t\t\t\t<span class=\"search-text\">Search</span>\n" +
    "\t\t\t\t<span class=\"icons icon-search\" name=\"submit\" type=\"submit\"></span>\n" +
    "\t\t\t\t<input placeholder=\"\" autocomplete=\"off\" type=\"text\" ad-delay-textbox ng-model=\"searchTerm\" delay=\"1000\" function-to-fire=\"searchEntered\" />\n" +
    "\t\t    </div>\n" +
    "\n" +
    "\t\t\t<div id=\"new-form-holder\"></div>\n" +
    "\t\t\t<table class=\"grid datatable\" ng-table=\"tableParams\" template-pagination=\"custom/pager\">\n" +
    "\t\t\t\t<tbody>\n" +
    "\t\t\t\t\t<tr ng-repeat=\"item in $data\">\n" +
    "\t\t\t\t\t\t<td header-class=\"text-left width-20\" data-title=\"'Code'\" sortable=\"'charge_code'\" ng-click=\"editSelected($index, item.value)\" ng-hide=\"currentClickedElement == $index && isEdit\">\n" +
    "\t\t\t\t\t\t\t<a data-colspan=\"1\" class=\"edit-data-inline\">\n" +
    "\t\t\t\t\t\t\t\t{{item.charge_code}}\n" +
    "\t\t\t\t\t\t\t</a>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td header-class=\"text-left width-20\"   header-class=\"text-left\" data-title=\"'Description'\" ng-hide=\"currentClickedElement == $index && isEdit\">\n" +
    "\t\t\t\t\t\t\t{{item.description}}\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td header-class=\"width-20\" data-title=\"'Group'\" sortable=\"'charge_group'\" ng-hide=\"currentClickedElement == $index && isEdit\" >\n" +
    "\t\t\t\t\t\t\t{{item.charge_group}}\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td header-class=\"text-left width-20\" header-class=\"text-center\" data-title=\"'Type'\" ng-hide=\"currentClickedElement == $index && isEdit\">\n" +
    "\t\t\t\t\t\t\t{{item.charge_code_type}}\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td header-class=\"text-left width-20\" data-title=\"'Tax'\"  ng-hide=\"currentClickedElement == $index && isEdit\">\n" +
    "\t\t\t\t\t\t\t<div class=\"linkwith\" ng-repeat=\"link in item.link_with\">\n" +
    "\t\t\t\t\t\t\t\t{{link}}\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td header-class=\"text-left width-20\" data-title=\"'Delete'\"  class=\"delete\" ng-hide=\"currentClickedElement == $index && isEdit\">\n" +
    "\t\t\t\t\t\t\t<a class=\"icons icon-delete large-icon delete_item\" ng-click=\"deleteItem(item.value)\">item.value</a>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t<td colspan=\"6\" ng-include=\"getTemplateUrl()\" ng-if=\"currentClickedElement == $index && isEdit\"></td>\n" +
    "\n" +
    "\t\t\t\t\t</tr>\n" +
    "\t\t\t\t</tbody>\n" +
    "\t\t\t</table>\n" +
    "\t\t</section>\n" +
    "\t\t<!--Custom pagination footer goes here-->\n" +
    "\t\t<script type=\"text/ng-template\" id=\"custom/pager\">\n" +
    "\t\t\t<div class = \"pager\">\n" +
    "\t\t\t\t<span ng-show=\"totalCount>0\">Showing {{startCount}} to {{endCount}} of {{totalCount}} items</span>\n" +
    "\t\t\t\t<span ng-show=\"totalCount==0\">Showing 0 items</span>\n" +
    "\t\t\t\t<ul class=\"ng-cloak\">\n" +
    "\t              \t<li ng-repeat=\"page in pages\"\n" +
    "\t\t                ng-class=\"{'previous': page.type == 'prev', 'next': page.type == 'next'}\"\n" +
    "\t\t                ng-show=\"page.type == 'prev' || page.type == 'next'\" ng-switch=\"page.type\">\n" +
    "\t\n" +
    "\t\t                <a ng-switch-when=\"prev\" ng-click=\"params.page(1)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">First</a>\n" +
    "\t\t                <a ng-switch-when=\"prev\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">Previous</a>\n" +
    "\t\t                <a ng-switch-when=\"prev\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">{{page.number}}</a>\n" +
    "\t\t                \n" +
    "\t\t                <a ng-switch-when=\"next\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">{{page.number}}</a>\n" +
    "\t\t                <a ng-switch-when=\"next\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">Next</a>\n" +
    "\t\t                <a ng-switch-when=\"next\" ng-click=\"params.page(totalPage)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">Last</a>\n" +
    "\t\t          \t</li>\n" +
    "\t            </ul>\n" +
    "\t        </div>\n" +
    "\t\t</script>\n" +
    "\t\t<!--end-->\n" +
    "\t</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/chargeCodes/adListTax.html',
    "<!--for charge code type other than PAYMENT or TAX -->\n" +
    "<div class=\"form-title\">\n" +
    "\t<h3 class=\"ng-binding\"><span translate=\"\" class=\"ng-scope\">Tax Setup</span></h3>\n" +
    "\t<a translate=\"\" style=\"float:right;\" class=\"form-title action add add-tax ng-scope\" ng-click=\"addTaxClicked()\">Add Tax </a>\n" +
    "</div>\n" +
    "<!-- <div class=\"content-title form-title\">\n" +
    "\t<h3 translate>TAX_SETUP </h3>\n" +
    "\t<a ng-click=\"addTaxClicked()\" class=\" action add\" style=\"float:right;\" translate>ADD_TAX</a>\n" +
    "</div> -->\n" +
    "<!--for charge code type other than PAYMENT or TAX -->\n" +
    "\n" +
    "<!-- EDITABLE WHEN 'ADD TAX' IS CLICKED -->\n" +
    "<div id=\"new-form-holder\" ng-show=\"isAddTax\" ng-include=\"'/assets/partials/chargeCodes/adTaxFormAdd.html'\"></div>\n" +
    "<div id=\"new-form-holder\"></div>\n" +
    "<!-- EDITABLE WHEN 'ADD TAX' IS CLICKED -->\n" +
    "<table id=\"taxCalculationList\" class=\"grid datatable\">\n" +
    "\t<tbody>\n" +
    "\t\t<tr ng-repeat=\"row in prefetchData.linked_charge_codes\">\n" +
    "\t\t\t<td ng-hide=\"isEditTax && currentClickedTaxElement === $index\" >\n" +
    "\t\t\t\t<a data-colspan=\"1\" class=\"tax-name edit-data-inline\" ng-click=\"editSelectedTax($index)\"> \n" +
    "\t\t\t\t\t{{'TAX' |translate}} {{$index+1}}\n" +
    "\t\t\t\t</a>\n" +
    "\t\t\t\t<a class=\"icons icon-delete large-icon delete_item pull-right\" ng-click=\"deleteTaxFromCaluculationPolicy($index)\"></a>\n" +
    "\t\t\t</td>\n" +
    "\t\t\t<td data-colspan=\"1\" ng-include=\"'/assets/partials/chargeCodes/adTaxFormEdit.html'\" ng-show=\"isEditTax && currentClickedTaxElement === $index\"></td>\n" +
    "\t\t</tr>\n" +
    "\t\t</tbody>\n" +
    "</table>\n"
  );


  $templateCache.put('/assets/partials/chargeCodes/adTaxFormAdd.html',
    "<!-- EDITABLE WHEN 'ADD TAX' IS CLICKED -->\n" +
    "\n" +
    "<div ng-show=\"isAddTax\">\n" +
    "\t<div class=\"form-title\" >\n" +
    "\t\t<h3>{{'TAX' |translate}} {{addData.id}}</h3>\n" +
    "\t</div>\n" +
    "\n" +
    "\t<div class=\"entry full-width\">\n" +
    "\t\t<div class=\"center_align\">\n" +
    "\t\t\t<div class=\"float_left\">\n" +
    "\t\t\t\t<label class=\"radio\">\n" +
    "\t\t\t\t\t<span ng-class=\"{'checked': addData.is_inclusive}\" class=\"icon-form icon-radio \"></span>\n" +
    "\t\t\t\t\t<input type=\"radio\" ng-click=\"toggleExclusive(0,true)\" >\n" +
    "\t\t\t\t\t{{'INCLUSIVE' |translate}} </label>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<div class=\"float_left rates_exclusive\">\n" +
    "\t\t\t\t<label class=\"radio\" >\n" +
    "\t\t\t\t\t<span ng-class=\"{'checked': !addData.is_inclusive}\" class=\"icon-form icon-radio\" ></span>\n" +
    "\t\t\t\t\t<input type=\"radio\" ng-click=\"toggleExclusive(0,false)\" >\n" +
    "\t\t\t\t\t{{'EXCLUSIVE' |translate}} </label>\n" +
    "\t\t\t</div>\n" +
    "\t\t</div>\n" +
    "\t</div>\n" +
    "\t\n" +
    "\t<div class='entry full-width'  ng-style=\"full-width\">\n" +
    "\t  <label>{{'CHARGE_CODE' |translate}}</label>\n" +
    "\t  <div class='select'>\n" +
    "\t  \t<select ng-model='addData.charge_code_id'>\n" +
    "\t      <option value=\"\" >\n" +
    "\t        {{'CHARGE_CODE_PLACEHOLDER'| translate}}\n" +
    "\t      </option>\n" +
    "\t      <option ng-repeat='code in prefetchData.tax_codes' value='{{code.value}}'  ng-selected=\"code.value==addData.charge_code_id\" >\n" +
    "\t        {{code.name}}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{{code.description}}\n" +
    "\t      </option>\n" +
    "\t    </select>\n" +
    "\t  </div>\n" +
    "\t</div>\n" +
    "\n" +
    "\n" +
    "\t<!-- Show from TAX 2 onwards. -->\n" +
    "\t<ad-dropdown ng-show=\"!addData.is_inclusive && addData.id!==1\" label=\"{{'CALCULATION_RULE' |translate}}\" selbox-class= \"placeholder\" label-in-drop-down=\"{{'SELECT_CALCULATION_RULE' |translate}}\" list=\"addData.calculation_rule_list\" selected-Id=\"addData.selected_calculation_rule\" div-class=\"full-width\"  ></ad-dropdown>\n" +
    "\t\n" +
    "\t<div class=\"actions float\" style=\" padding-top: 10px; height: 73px;\">\n" +
    "\t\t<button type=\"button\" ng-click=\"clickedCancelAddNewTax()\" class=\"button blank edit-data-inline\" translate >\n" +
    "\t\t\tCANCEL\n" +
    "\t\t</button>\n" +
    "\t\t<button type=\"button\" ng-click=\"clickedSaveAddNewTax()\" class=\"button green edit-data-inline\"translate >\n" +
    "\t\t\tOK\n" +
    "\t\t</button>\n" +
    "\t</div>\n" +
    "</div>\n"
  );


  $templateCache.put('/assets/partials/chargeCodes/adTaxFormEdit.html',
    "<!-- EDITABLE WHEN 'ADD TAX' IS CLICKED -->\n" +
    "\n" +
    "<div ng-show=\"isEditTax\">\n" +
    "\t<div class=\"form-title\" >\n" +
    "\t\t<h3>{{'TAX' |translate}} {{$index+1}}</h3>\n" +
    "\t</div>\n" +
    "\n" +
    "\t<div class=\"entry full-width\">\n" +
    "\t\t<div class=\"center_align\">\n" +
    "\t\t\t<div class=\"float_left\">\n" +
    "\t\t\t\t<label class=\"radio\">\n" +
    "\t\t\t\t\t<span ng-class=\"{'checked': row.is_inclusive}\" class=\"icon-form icon-radio \"></span>\n" +
    "\t\t\t\t\t<input type=\"radio\" ng-click=\"toggleExclusive($index,true)\" >\n" +
    "\t\t\t\t\t{{'INCLUSIVE' |translate}} </label>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<div class=\"float_left rates_exclusive\">\n" +
    "\t\t\t\t<label class=\"radio\" >\n" +
    "\t\t\t\t\t<span ng-class=\"{'checked':!row.is_inclusive}\" class=\"icon-form icon-radio\" ></span>\n" +
    "\t\t\t\t\t<input type=\"radio\" ng-click=\"toggleExclusive($index,false)\" >\n" +
    "\t\t\t\t\t{{'EXCLUSIVE' |translate}} </label>\n" +
    "\t\t\t</div>\n" +
    "\t\t</div>\n" +
    "\t</div>\n" +
    "\t\n" +
    "\t<div class='entry full-width'  ng-style=\"full-width\">\n" +
    "\t  <label>{{'CHARGE_CODE' |translate}}</label>\n" +
    "\t  <div class='select'>\n" +
    "\t  \t<select ng-model='row.charge_code_id'>\n" +
    "\t      <option value=\"\">\n" +
    "\t        {{'CHARGE_CODE_PLACEHOLDER'| translate}}\n" +
    "\t      </option>\n" +
    "\t      <option ng-repeat='code in prefetchData.tax_codes' value='{{code.value}}'  ng-selected=\"code.value==row.charge_code_id\" >\n" +
    "\t        {{code.name}}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;{{code.description}}\n" +
    "\t      </option>\n" +
    "\t    </select>\n" +
    "\t  </div>\n" +
    "\t</div>\n" +
    "\t\n" +
    "\t<!-- Show from TAX 2 onwards. -->\n" +
    "\t<ad-dropdown ng-if=\"!row.is_inclusive && $index!==0\" label=\"{{'CALCULATION_RULE' |translate}}\" selbox-class= \"placeholder\" label-in-drop-down=\"{{'SELECT_CALCULATION_RULE' |translate}}\" list=\"row.calculation_rule_list\" selected-Id=\"row.selected_calculation_rule\" div-class=\"full-width\"  ></ad-dropdown>\n" +
    "\t\n" +
    "\t<div class=\"actions float\" style=\" padding-top: 0px; height: 73px;\">\n" +
    "\t\t<button type=\"button\" ng-click=\"clickedCancelEditTax($index)\" class=\"button blank edit-data-inline\" translate>\n" +
    "\t\t\tCANCEL\n" +
    "\t\t</button>\n" +
    "\t\t<button type=\"button\" ng-click=\"clickedUpdateTax($index)\" class=\"button green edit-data-inline\" translate>\n" +
    "\t\t\tOK\n" +
    "\t\t</button>\n" +
    "\t</div>\n" +
    "</div>\n"
  );


  $templateCache.put('/assets/partials/chargeGroups/adChargeGroups.html',
    "<section class=\"content current\" ng-click=\"clearErrorMessage()\">\n" +
    "\t<div class=\"inline-edit\">\n" +
    "\t\t<header class=\"content-title float\">\n" +
    "\t\t\t<h2 translate>CHARGE_GROUPS</h2>\n" +
    "\t\t\t<span class=\"count\"> (\n" +
    "\t\t\t\t{{data.charge_groups.length}}\n" +
    "\t\t\t\t) </span>\n" +
    "\t\t\t<a class=\"action add\" ng-click=\"addNewClicked()\" translate>ADD_NEW</a>\n" +
    "\t\t</header>\n" +
    "\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t\n" +
    "\t\t\t<div id=\"add-new\" ng-show=\"currentClickedElement == 'new'\" ng-include=\"'/assets/partials/chargeGroups/adChargeGroupsAdd.html'\"></div>\t\t\n" +
    "\t\t\t\n" +
    "\t\t\t<table class=\"grid\">\n" +
    "\t\t\t\t<tbody>\n" +
    "\t\t\t\t\t<tr ng-repeat=\"item in data.charge_groups\" > \n" +
    "\t\t\t\t\t\t<td ng-click=\"editItem($index)\" ng-hide=\"currentClickedElement == $index\">\n" +
    "\t\t\t\t\t\t\t<a data-item=\"1\" data-colspan=\"2\" class=\"edit-data-inline\">{{item.name}}</a>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td class=\"delete\" ng-click=\"clickedDelete(item.value)\" ng-hide=\"currentClickedElement == $index\">\n" +
    "\t\t\t\t\t\t\t<a class=\"icons icon-delete large-icon delete_item\"></a>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td colspan=\"2\" ng-include=\"getTemplateUrl($index)\"></td>\n" +
    "\t\t\t\t\t</tr>\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t</tbody>\n" +
    "\t\t\t</table>\n" +
    "\t\t</section>\n" +
    "\t</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/chargeGroups/adChargeGroupsAdd.html',
    "<div class=\"data-holder\">\n" +
    "\t<!-- Add Charge Group -->\n" +
    "\t<form class=\"form inline-form float\">\n" +
    "\t\t<div class=\"form-title\">\n" +
    "\t\t\t<h3><span></span> {{'ADD' | translate}} </h3>\n" +
    "\t\t\t<em class=\"status\"> {{'MANDATORY_FIELDS_MESSAGE1' | translate}} <strong>*</strong> {{'MANDATORY_FIELDS_MESSAGE2' | translate}} </em>\n" +
    "\t\t</div>\n" +
    "\t\t<fieldset class=\"holder left float\">\n" +
    "\t\t\t<ad-textbox value=\"data.name\" name = \"item-name\" label = \"Name\" placeholder = \"Enter charge group\" required = \"yes\"></ad-textbox>\n" +
    "\t\t</fieldset>\n" +
    "\t\t<div class=\"actions float\">\n" +
    "\t\t\t<button type=\"button\" ng-click=\"clickedCancel()\" class=\"button blank edit-data-inline\" translate>\n" +
    "\t\t\t\tCANCEL\n" +
    "\t\t\t</button>\n" +
    "\t\t\t<button type=\"button\" ng-click=\"saveAddNew()\" class=\"button green edit-data-inline\" translate>\n" +
    "\t\t\t\tSAVE_CHANGES\n" +
    "\t\t\t</button>\n" +
    "\t\t</div>\n" +
    "\t</form>\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/chargeGroups/adChargeGroupsEdit.html',
    "<div class=\"data-holder\">\n" +
    "\t<form class=\"form single-field-form float\">\n" +
    "\t\t<ad-textbox value=\"item.name\" name = \"item-name\" label = \"\" placeholder = \"Enter charge group\" required = \"\"></ad-textbox>\n" +
    "\n" +
    "\t\t<div class=\"actions float\">\n" +
    "\t\t\t<button type=\"button\" class=\"button blank edit-data-inline\" ng-click=\"clickedCancel()\" translate>\n" +
    "\t\t\t\tCANCEL \n" +
    "\t\t\t</button>\n" +
    "\t\t\t<button type=\"button\" class=\"button green edit-data-inline\" ng-click=\"updateItem()\" translate>\n" +
    "\t\t\t\tSAVE_CHANGES\n" +
    "\t\t\t</button>\n" +
    "\t\t\t<button type=\"button\" class=\"button red edit-data-inline\" ng-click=\"clickedDelete(item.value)\" translate>\n" +
    "\t\t\t\tDELETE\n" +
    "\t\t\t</button>\n" +
    "\t\t</div>\n" +
    "\t\t\n" +
    "\t</form>\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/checkin/adCheckin.html',
    "\n" +
    "\t<section id=\"replacing-div-second\" class=\"content current\" ng-hide=\"isLoading\" ng-click=\"clearErrorMessage()\"><div data-view=\"ZestCheckinConfiguration\" >\n" +
    "\t\t<header class=\"content-title float\">\n" +
    "\t\t\t<h2>{{ 'GUEST_CHECKIN_SETUP' | translate}}</h2>\n" +
    "\t\t\t<a ui-sref=\"admin.checkinEmail\" class=\"action email\">{{ 'SEND_CHECKIN_EMAIL' | translate}}</a>\n" +
    "\t\t\t<a ng-click=\"goBackToPreviousState()\" data-type=\"load-details\" class=\"action back\">{{ 'BACK' | translate}}</a>\n" +
    "\t\t</header>\n" +
    "\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"  ></div>\n" +
    "\t\t\t<form style=\"overflow-y:auto;\" class=\"form float\" >\n" +
    "\t\t\t\t<fieldset class=\"holder left\">\n" +
    "\n" +
    "\t\t\t\t\t<ad-toggle-button is-checked=\"checkinData.is_send_alert_flag\" label=\"{{ 'SEND_CHECKIN_ALERT' | translate}}\" is-disabled=\"checkinData.is_precheckin_only\"></ad-toggle-button>\n" +
    "\n" +
    "\t\t\t\t\t<ad-toggle-button is-checked=\"checkinData.is_precheckin_only\" label=\"{{ 'PRE_CHECK_IN_ONLY' | translate}}\"  div-class=\"full-width\"></ad-toggle-button>\n" +
    "\n" +
    "\t\t\t\t\t<ad-checkbox is-checked=\"checkinData.is_notify_on_room_ready_flag\" label=\"{{ 'NOTIFY_GUEST_WHEN_ROOM_READY_VACANT_TITLE' | translate}}\" div-class=\"full-width\" is-disabled=\"checkinData.is_precheckin_only\" ng-show=\"!checkinData.is_precheckin_only\"></ad-checkbox>\t\n" +
    "\n" +
    "\t\t\t\t\t<ad-checkbox is-checked=\"checkinData.require_cc_for_checkin_email_flag\" label=\"{{ 'RESERVATION_CC_GUARANTEED' | translate}}\" div-class=\"full-width\"></ad-checkbox>\t\n" +
    "\t\t\t\t</fieldset>\n" +
    "\t\t\t\t<fieldset class=\"holder right holder_margin\">\t\n" +
    "\n" +
    "\t\t\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t\t\t<label>\n" +
    "\t\t\t\t\t\t\t{{ 'EMAIL_TO_ALL_ARRIVALS' | translate}}\n" +
    "\t\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t\t<div class=\"entry full-width float\">\n" +
    "\t\t\t\t\t\t\t<div class=\"select select-col select-margin\">\n" +
    "\t\t\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t\t\t<select ng-model=\"checkinData.checkin_alert_time_hour\">\n" +
    "\t\t\t\t\t\t\t\t\t<option value=\"\">HH</option>\n" +
    "\t\t\t\t\t\t\t\t\t<option ng-repeat=\"hour  in hours\" value=\"{{hour}}\" ng-bind=\"hour\"></option>\n" +
    "\t\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t<div class=\"select select-col select-margin\">\n" +
    "\t\t\t\t\t\t\t\t\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t<select ng-model=\"checkinData.checkin_alert_time_minute\">\n" +
    "\t\t\t\t\t\t\t\t\t<option value=\"\">MM</option>\n" +
    "\t\t\t\t\t\t\t\t\t<option ng-repeat=\"minute  in minutes\" value=\"{{minute}}\" ng-bind=\"minute\"></option>\n" +
    "\t\t\t\t\t\t\t\t</select>\n" +
    "\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t<div class=\"select select-col select-margin\">\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t<select ng-options=\"primeTime for primeTime  in primeTimes\" ng-model=\"checkinData.checkin_alert_primetime\">\n" +
    "\t\t\t\t\t\t\t\t</select>\n" +
    "\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t</fieldset>\n" +
    "\t\t\t\t<fieldset class=\"holder left holder_margin\" ng-show=\"checkinData.is_precheckin_only\">\t\n" +
    "\t\t\t\t\t<div id=\"options\" class=\"entry\" ng-hide=\"hideAddOption\">\n" +
    "\t\t\t\t\t\t<label>\n" +
    "\t\t\t\t\t\t\t{{ 'CHECKIN_ACTION' | translate}}\n" +
    "\t\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t\t<label class=\"radio\" ng-class=\"{'checked':checkinData.checkin_action== 'sent_to_queue'}\">\n" +
    "\t\t\t\t\t\t\t<span class=\"icon-form icon-radio \" ng-class=\"{checked:checkinData.checkin_action=='sent_to_queue'}\"></span>\n" +
    "\t\t\t\t\t\t\t<input type=\"radio\" value=\"sent_to_queue\" ng-model=\"checkinData.checkin_action\"  >\n" +
    "\t\t\t\t\t\t\t{{ 'SENT_TO_QUEUE' | translate}}\n" +
    "\t\t\t\t\t\t</label>\n" +
    "\n" +
    "\t\t\t\t\t\t<label class=\"radio\" ng-class=\"{'checked':checkinData.checkin_action == 'auto_checkin'}\">\n" +
    "\t\t\t\t\t\t\t<span class=\"icon-form icon-radio \" ng-class=\"{checked:checkinData.checkin_action == 'auto_checkin'}\"></span>\n" +
    "\t\t\t\t\t\t\t<input type=\"radio\" value=\"auto_checkin\" ng-model=\"checkinData.checkin_action\" >\n" +
    "\t\t\t\t\t\t\t{{ 'AUTO_CHECK_IN' | translate}}\n" +
    "\t\t\t\t\t\t</label>\n" +
    "\n" +
    "\t\t\t\t\t\t<label class=\"radio\" ng-class=\"{'checked':checkinData.checkin_action == 'none'}\">\n" +
    "\t\t\t\t\t\t\t<span class=\"icon-form icon-radio \" ng-class=\"{checked:checkinData.checkin_action == 'none'}\"></span>\n" +
    "\t\t\t\t\t\t\t<input type=\"radio\" value=\"none\" ng-model=\"checkinData.checkin_action\" >\n" +
    "\t\t\t\t\t\t\t{{ 'NONE' | translate}}\n" +
    "\t\t\t\t\t\t</label>\n" +
    "\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t\t\t<ad-textarea rows=\"4\" div-class=\"full-width\" text-area-class=\"full-width\" value=\"checkinData.checkin_complete_confirmation_screen_text\" label = \"{{ 'CHECK_IN_COMPLETE_CONFIRMATION_SCREEN_TEXT' | translate}}\" placeholder = \"\"></ad-textarea>\n" +
    "\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t<div class=\"entry\" ng-show=\"checkinData.checkin_action == 'sent_to_queue' || checkinData.checkin_action == 'auto_checkin'\">\n" +
    "\t\t\t\t\t\t<label>\n" +
    "\t\t\t\t\t\t\t{{ 'MINUTES_PRIOR_TO_ETA' | translate}}\n" +
    "\t\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t\t<div class=\"entry full-width float\">\n" +
    "\t\t\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\t\t\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t\t\t<select ng-options=\"minute for minute  in prior_minutes\" ng-model=\"checkinData.prior_to_arrival\">\n" +
    "\t\t\t\t\t\t\t\t\t<option style=\"display:none\" value=\"\">MM</option>\n" +
    "\t\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</fieldset>\n" +
    "\t\t\t\t\n" +
    "\t\t\t\t<fieldset class=\"holder left holder_margin\"  ng-show=\"checkinData.checkin_action == 'auto_checkin' && checkinData.is_precheckin_only\">\t\n" +
    "\t\t\t\t\t<div class=\"entry full-width\" >\n" +
    "\t\t\t\t\t\t<label>\n" +
    "\t\t\t\t\t\t\t{{ 'START_AUTO_CHECK_IN_FROM' | translate}}\n" +
    "\t\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t\t\t<div class=\"select select-col select-margin\">\n" +
    "\t\t\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t\t\t<select ng-model=\"checkinData.auto_checkin_from_hour\">\n" +
    "\t\t\t\t\t\t\t\t\t<option value=\"\">HH</option>\n" +
    "\t\t\t\t\t\t\t\t\t<option ng-repeat=\"hour  in hours\" value=\"{{hour}}\" ng-bind=\"hour\"></option>\n" +
    "\t\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t<div class=\"select select-col select-margin\">\n" +
    "\t\t\t\t\t\t\t\t\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t<select ng-model=\"checkinData.auto_checkin_from_minute\">\n" +
    "\t\t\t\t\t\t\t\t\t<option value=\"\">MM</option>\n" +
    "\t\t\t\t\t\t\t\t\t<option ng-repeat=\"minute  in minutes\" value=\"{{minute}}\" ng-bind=\"minute\"></option>\n" +
    "\t\t\t\t\t\t\t\t</select>\n" +
    "\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t<div class=\"select select-col select-margin\">\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t<select ng-options=\"primeTime for primeTime  in primeTimes\" ng-model=\"checkinData.start_auto_checkin_from_prime_time\">\n" +
    "\t\t\t\t\t\t\t\t</select>\n" +
    "\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t</fieldset>\n" +
    "\t\t\t\t<fieldset class=\"holder right holder_margin\" ng-show=\"checkinData.checkin_action == 'auto_checkin' && checkinData.is_precheckin_only\">\t\n" +
    "\t\t\t\t\t<div class=\"entry full-width\" >\n" +
    "\t\t\t\t\t\t<label>\n" +
    "\t\t\t\t\t\t\t{{ 'STOP_AUTO_CHECK_IN_AT' | translate}}\n" +
    "\t\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t\t\t<div class=\"select select-col select-margin\">\n" +
    "\t\t\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t\t\t<select ng-model=\"checkinData.auto_checkin_to_hour\">\n" +
    "\t\t\t\t\t\t\t\t\t<option value=\"\">HH</option>\n" +
    "\t\t\t\t\t\t\t\t\t<option ng-repeat=\"hour  in hours\" value=\"{{hour}}\" ng-bind=\"hour\"></option>\n" +
    "\t\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t<div class=\"select select-col select-margin\">\n" +
    "\t\t\t\t\t\t\t\t\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t<select ng-model=\"checkinData.auto_checkin_to_minute\">\n" +
    "\t\t\t\t\t\t\t\t\t<option value=\"\">MM</option>\n" +
    "\t\t\t\t\t\t\t\t\t<option ng-repeat=\"minute  in minutes\" value=\"{{minute}}\" ng-bind=\"minute\"></option>\n" +
    "\t\t\t\t\t\t\t\t</select>\n" +
    "\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t<div class=\"select select-col select-margin\">\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t<select ng-options=\"primeTime for primeTime  in primeTimes\" ng-model=\"checkinData.start_auto_checkin_to_prime_time\">\n" +
    "\t\t\t\t\t\t\t\t</select>\n" +
    "\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</fieldset>\n" +
    "\n" +
    "\t\t\t\t<fieldset class=\"holder full-width\" ng-show=\"checkinData.is_precheckin_only\">\n" +
    "\t\t\t\t\t<ad-checkbox is-checked=\"checkinData.is_sent_none_cc_reservations_to_front_desk_only\" label=\"{{ 'SENT_NONE_CC_RESERVATIONS_TO_FRONT_DESK_ONLY' | translate}}\" div-class=\"full-width margin-top-30\" ></ad-checkbox>\n" +
    "\t\t\t\t</fieldset>\t\n" +
    "\n" +
    "\t\t\t\t<fieldset class=\"holder left\" ng-hide=\"!checkinData.is_precheckin_only\">\n" +
    "\n" +
    "\t\t\t\t\t<ad-textbox value=\"checkinData.max_webcheckin\" label = \"{{'MAX_NUMBER_OF_WEB_CHECKIN_PER_DAY' | translate}}\" placeholder = \"{{'MAX_NUMBER_OF_WEB_CHECKIN_PER_DAY' | translate}}\"  styleclass=\"full-width\" maxlength=\"4\"></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t\t\t<h3 class=\"ng-binding\"><span class=\"ng-scope\" translate=\"\">PRE_CHECK_IN_EMAIL_FIELDS</span> </h3>\n" +
    "\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t<ad-textbox value=\"checkinData.pre_checkin_email_title\" label = \"{{'PRE_CHECK_IN_EMAIL_TITLE' | translate}}\" placeholder = \"\"  styleclass=\"full-width\" ></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t\t<ad-textarea rows=\"4\" div-class=\"full-width\" text-area-class=\"full-width\" value=\"checkinData.pre_checkin_email_body\" label = \"{{ 'PRE_CHECK_IN_TOP_BODY' | translate}}\" placeholder = \"\"></ad-textarea>\n" +
    "\n" +
    "\t\t\t\t\t<ad-textarea rows=\"4\" div-class=\"full-width\" text-area-class=\"full-width\" value=\"checkinData.pre_checkin_email_bottom_body\" label = \"{{ 'PRE_CHECK_IN_BOTTOM_BODY' | translate}}\" placeholder = \"\"></ad-textarea>\n" +
    "\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t</fieldset>\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t<fieldset class=\"holder full-width\">\n" +
    "\t\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t\t<label translate>RATE_CODES_TO_EXCLUDE_FROM_CHECKIN</label>\n" +
    "\t\t\t\t\t\t<div     \n" +
    "\t\t\t\t\t\tmulti-select\n" +
    "\t\t\t\t\t\tinput-model=\"rate_codes\"\n" +
    "\t\t\t\t\t\tbutton-label=\"name\"\n" +
    "\t\t\t\t\t\titem-label=\"name\"\n" +
    "\t\t\t\t\t\ttick-property=\"ticked\"\n" +
    "\t\t\t\t\t\tmax-labels=\"0\"\n" +
    "\t\t\t\t\t\tdefault-label=\"None selected\"\n" +
    "\t\t\t\t\t\tmax-height=\"300px\"\n" +
    "\t\t\t\t\t\t>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t<div class=\"entry entry-padding-left\"><label>&nbsp;&nbsp;</label>\n" +
    "\t\t\t\t\t\t<button translate=\"\" ng-click=\"clickExcludeRateCode()\"  class=\"button green\" translate=\"\">EXCLUDE_RATE_CODES</button>\n" +
    "\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t<div class=\"entry full-width\" ng-show=\"excludedRateCodes.length>0\">\n" +
    "\t\t\t\t\t\t<div class='entry' >\n" +
    "\t\t\t\t\t\t\t\t<label> <h4 translate>EXCLUDED_RATE_CODES</h4> </label>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t<div id='room-type-details' ng-repeat=\"rateCode in excludedRateCodes\">\t\t\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t\t<div class=\"entry full-width room-type-details\" >\n" +
    "\t\t\t\t\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t\t\t\t\t<span class=\"align-text-center\"> {{rateCode.name}} </span>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t\t\t\t\t<span class=\"entry\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<a class=\"icons icon-delete large-icon align-text-center\" ng-click=\"deleteRateCode(rateCode.id)\"></a>\n" +
    "\t\t\t\t\t\t\t\t\t</span>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t</div>\t\t\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</fieldset>\n" +
    "\t\t\t\t\t<fieldset class=\"holder full-width\">\n" +
    "\t\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t\t<label translate>BLOCK_CODES_EXCLUDE_FROM_CHECKIN</label>\n" +
    "\t\t\t\t\t\t<div     \n" +
    "\t\t\t\t\t\tmulti-select\n" +
    "\t\t\t\t\t\tinput-model=\"block_codes\"\n" +
    "\t\t\t\t\t\tbutton-label=\"group_code\"\n" +
    "\t\t\t\t\t\titem-label=\"group_code\"\n" +
    "\t\t\t\t\t\ttick-property=\"ticked\"\n" +
    "\t\t\t\t\t\tmax-labels=\"0\"\n" +
    "\t\t\t\t\t\tdefault-label=\"None selected\"\n" +
    "\t\t\t\t\t\tmax-height=\"300px\"\n" +
    "\t\t\t\t\t\t>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t<div class=\"entry entry-padding-left\" ><label>&nbsp;&nbsp;</label>\n" +
    "\t\t\t\t\t\t<button translate=\"\" ng-click=\"clickExcludeBlockCode()\"  class=\"button green\" translate=\"\">EXCLUDE_BLOCK_CODES</button>\n" +
    "\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t<div class=\"entry full-width\" ng-show=\"excludedBlockCodes.length>0\">\n" +
    "\t\t\t\t\t\t<div class='entry' >\n" +
    "\t\t\t\t\t\t\t\t<label> <h4 translate>EXCLUDED_BLOCK_CODES</h4> </label>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t<div id='room-type-details' ng-repeat=\"blockCode in excludedBlockCodes\">\t\t\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t\t<div class=\"entry full-width room-type-details\" >\n" +
    "\t\t\t\t\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t\t\t\t\t<span class=\"align-text-center\"> {{blockCode.group_code}} </span>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t\t\t\t\t<span class=\"entry\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<a class=\"icons icon-delete large-icon align-text-center\" ng-click=\"deleteBlockCode(blockCode.id)\"></a>\n" +
    "\t\t\t\t\t\t\t\t\t</span>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t</div>\t\t\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t</div>\t\t\n" +
    "\n" +
    "\t\t\t\t</fieldset>\t\n" +
    "\t\t\t\t\n" +
    "\t\t\t\t<fieldset class=\"holder left\">\n" +
    "\n" +
    "\t\t\t\t\t<ad-toggle-button is-checked=\"checkinData.is_send_checkin_staff_alert_flag\" label=\"{{ 'WEB_CHECKIN_STAFF_ALERT' | translate}}\"></ad-toggle-button>\n" +
    "\n" +
    "\t\t\t\t\t<div id=\"options\" class=\"entry full-width\" ng-hide=\"hideAlertOption\">\n" +
    "\n" +
    "\t\t\t\t\t\t<label class=\"radio\" ng-class=\"{'checked':checkinData.checkin_staff_alert_option=='all'}\">\n" +
    "\t\t\t\t\t\t\t<span class=\"icon-form icon-radio \" ng-class=\"{checked:checkinData.checkin_staff_alert_option == 'all'}\"></span>\n" +
    "\t\t\t\t\t\t\t<input type=\"radio\" ng-model=\"checkinData.checkin_staff_alert_option\" value=\"all\" class=\"change-data\">\n" +
    "\t\t\t\t\t\t\t{{ 'ALL' | translate}}\n" +
    "\t\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t</label>\n" +
    "\n" +
    "\t\t\t\t\t\t<label class=\"radio\" ng-class=\"{'checked':checkinData.require_cc_for_checkin_email_flag}\">\n" +
    "\t\t\t\t\t\t\t<span class=\"icon-form icon-radio \" ng-class=\"{checked:checkinData.checkin_staff_alert_option == 'not_success'}\"></span>\n" +
    "\t\t\t\t\t\t\t<input type=\"radio\" ng-model=\"checkinData.checkin_staff_alert_option\" value=\"not_success\" class=\"change-data\">\n" +
    "\t\t\t\t\t\t\t{{ 'ONLY_WHEN_CHECKIN_NOT_SUCCESSFUL' | translate}}\n" +
    "\t\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t</label>\n" +
    "\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t\t<div class=\"entry full-width\">\n" +
    "\n" +
    "\t\t\t\t\t\t<ad-textarea rows=\"4\" div-class=\"full-width\" text-area-class=\"full-width\" value=\"checkinData.emails\" label = \"{{ 'EMAIL_ACCOUNTS_SEPERATED_BY_SEMICOLON' | translate}}\" placeholder = \"\"></ad-textarea>\n" +
    "\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t<ad-textarea rows=\"4\" div-class=\"full-width\" text-area-class=\"full-width\" value=\"checkinData.checkin_alert_message\" label = \"{{ 'CHECKIN_ALERT' | translate}}\" placeholder = \"\" ng-show=\"hideAddOption\"></ad-textarea>\n" +
    "\n" +
    "\t\t\t\t</fieldset>\n" +
    "\n" +
    "\t\t\t\t<div class=\"actions float\">\n" +
    "\t\t\t\t\t<button type=\"button\" ng-click=\"goBackToPreviousState()\" class=\"button blank add-data-inline\">{{ 'CANCEL' | translate}}</button>\n" +
    "\t\t\t\t\t<button type=\"button\" ng-click=\"saveCheckin()\" class=\"button green\">{{ 'SAVE_CHANGES' | translate}}</button>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</form>\n" +
    "\t\t</section>\n" +
    "\t</div>\n" +
    "\t</section>"
  );


  $templateCache.put('/assets/partials/checkout/adCheckout.html',
    "\t<section id=\"replacing-div-first\" class=\"content current\" style=\"display: block;\" ng-hide=\"isLoading\" ng-click=\"clearErrorMessage()\"><div data-view=\"ZestCheckOutConfiguration\">\n" +
    "\t\t<header class=\"content-title float\">\n" +
    "\t\t\t<h2 translate>GUEST_CHECKOUT_SETUP</h2>\n" +
    "\t\t\t<a ui-sref=\"admin.checkoutEmail\" class=\"action email\" translate>SEND_CHECKOUT_EMAIL</a>\n" +
    "\t\t\t<a ng-click=\"goBackToPreviousState()\" data-type=\"load-details\" class=\"action back\" translate>BACK</a>\n" +
    "\t\t</header\n" +
    ">\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"  ></div>\n" +
    "\t\t\t\t\t<form style=\"overflow-y:auto;\" name=\"edit-social-lobby\" method=\"post\" class=\"form float\">\n" +
    "\t\t\t\t\t\t<fieldset>\n" +
    "\t\t\t\t\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t\t\t\t<label translate>\n" +
    "\t\t\t\t\t\t\t\t\tSEND_CHECKOUT_NOTIFICATON_EMAIL\n" +
    "\t\t\t\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t\t</fieldset>\n" +
    "\t\t\t\t\t\t<fieldset>\n" +
    "\n" +
    "\t\t\t\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select select-col select-med\">\n" +
    "\t\t\t\t\t\t\t\t\t<select ng-options=\"hour for hour  in hours\" ng-model=\"checkoutData.checkout_email_alert_time_hour \">\n" +
    "\t\t\t\t\t\t\t\t\t\t<option  value=\"HH\" translate>HH</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select select-col select-med\">\n" +
    "\t\t\t\t\t\t\t\t\t<select ng-options=\"minute for minute  in minutes\" ng-model=\"checkoutData.checkout_email_alert_time_minute\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<option  value=\"MM\" translate>MM</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select select-col select-med\">\n" +
    "\t\t\t\t\t\t\t\t\t<select name=\"hotel-checkout-primetime\" disabled=\"disabled\" class=\"styled\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<option value=\"AM\" selected=\"\" translate>AM</option>\n" +
    "\t\t\t\t\t\t\t\t\t\t<option value=\"PM\" translate>PM</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t<label class=\"label-checkout\" translate>\n" +
    "\t\t\t\t\t\t\t\t\tAND\n" +
    "\t\t\t\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t\t\t\t<!-- <br> -->\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select select-col select-med\">\n" +
    "\t\t\t\t\t\t\t\t\t<select ng-options=\"hour for hour  in getArrayAfterValue(checkoutData.checkout_email_alert_time_hour)\" ng-model=\"checkoutData.alternate_checkout_email_alert_time_hour\" ng-disabled = \"(checkoutData.checkout_email_alert_time_hour == 'HH' || checkoutData.checkout_email_alert_time_minute == 'MM')\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<option  value=\"HH\" translate>HH</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select select-col select-med\">\n" +
    "\t\t\t\t\t\t\t\t\t<select ng-options=\"minute for minute  in minutes\" ng-model=\"checkoutData.alternate_checkout_email_alert_time_minute\" ng-disabled = \"(checkoutData.checkout_email_alert_time_hour == 'HH' || checkoutData.checkout_email_alert_time_minute == 'MM')\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<option  value=\"MM\" translate>MM</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select select-col select-med\">\n" +
    "\t\t\t\t\t\t\t\t\t<select name=\"hotel-checkout-primetime\" disabled=\"disabled\" class=\"styled\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<option value=\"AM\" selected=\"\" translate>AM</option>\n" +
    "\t\t\t\t\t\t\t\t\t\t<option value=\"PM\" translate>PM</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t<label class=\"label-checkout\" translate>\n" +
    "\t\t\t\t\t\t\t\t\tON_WEEKDAYS\n" +
    "\t\t\t\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\n" +
    "\n" +
    "\n" +
    "\n" +
    "\t\t\t\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t\t\t\t<br>\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select select-col select-med\">\n" +
    "\t\t\t\t\t\t\t\t\t<select ng-options=\"hour for hour  in hours\" ng-model=\"checkoutData.weekends_checkout_email_alert_time_hour\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<option  value=\"HH\" translate>HH</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select select-col select-med\">\n" +
    "\t\t\t\t\t\t\t\t\t<select ng-options=\"minute for minute  in minutes\" ng-model=\"checkoutData.weekends_checkout_email_alert_time_minute\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<option  value=\"MM\" translate>MM</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select select-col select-med\">\n" +
    "\t\t\t\t\t\t\t\t\t<select name=\"hotel-checkout-primetime\" disabled=\"disabled\" class=\"styled\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<option value=\"AM\" selected=\"\" translate>AM</option>\n" +
    "\t\t\t\t\t\t\t\t\t\t<option value=\"PM\" translate>PM</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t<label class=\"label-checkout\" translate>\n" +
    "\t\t\t\t\t\t\t\t\tAND\n" +
    "\t\t\t\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t\t\t\t<br>\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select select-col select-med\">\n" +
    "\t\t\t\t\t\t\t\t\t<select ng-options=\"hour for hour  in getArrayAfterValue(checkoutData.weekends_checkout_email_alert_time_hour)\" ng-model=\"checkoutData.alternate_weekends_checkout_email_alert_time_hour\" ng-disabled = \"(checkoutData.weekends_checkout_email_alert_time_hour == 'HH' || checkoutData.weekends_checkout_email_alert_time_minute == 'MM')\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<option  value=\"HH\" translate>HH</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select select-col select-med\">\n" +
    "\t\t\t\t\t\t\t\t\t<select ng-options=\"minute for minute  in minutes\" ng-model=\"checkoutData.alternate_weekends_checkout_email_alert_time_minute\" ng-disabled = \"(checkoutData.weekends_checkout_email_alert_time_hour == 'HH' || checkoutData.weekends_checkout_email_alert_time_minute == 'MM')\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<option  value=\"MM\" translate>MM</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select select-col select-med\">\n" +
    "\t\t\t\t\t\t\t\t\t<select name=\"hotel-checkout-primetime\" disabled=\"disabled\" class=\"styled\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<option value=\"AM\" selected=\"\" translate>AM</option>\n" +
    "\t\t\t\t\t\t\t\t\t\t<option value=\"PM\" translate>PM</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t<label class=\"label-checkout\" translate>\n" +
    "\t\t\t\t\t\t\t\t\tON_SATURDAY_SUNDAY\n" +
    "\t\t\t\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t\t</fieldset>\n" +
    "\n" +
    "\t\t\t\t\t\t<fieldset class=\"holder left\">\n" +
    "\t\t\t\t\t\t\t<ad-checkbox is-checked=\"require_cc_for_checkout_email_flag\" label=\"{{'CC_GUARENTEED_LABEL' | translate}}\" div-class=\"full-width\"></ad-checkbox>\t\n" +
    "\t\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t\t<ad-checkbox is-checked=\"include_cash_reservationsy_flag\" label=\" {{'CASH_PAYMENT_LABEL' | translate}}\" div-class=\"full-width\"></ad-checkbox>\t\n" +
    "\t\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t\t<ad-toggle-button is-checked=\"is_send_checkout_staff_alert_flag\" label=\"{{'WEB_CHEKOUT_ALERT_LABEL' | translate}}\"></ad-toggle-button>\n" +
    "\n" +
    "\t\t\t\t\t\t\t<div id=\"options\" class=\"entry full-width\" ng-show=\"is_send_checkout_staff_alert_flag\">\n" +
    "\t\t\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t\t\t<label class=\"radio\" ng-class=\"{checked:checkoutData.checkout_staff_alert_option == 'all'}\">\n" +
    "\t\t\t\t\t\t\t\t\t<span class=\"icon-form icon-radio \" ng-class=\"{checked:checkoutData.checkout_staff_alert_option == 'all'}\"></span>\n" +
    "\t\t\t\t\t\t\t\t\t<input type=\"radio\" ng-model=\"checkoutData.checkout_staff_alert_option\" value=\"all\" class=\"change-data\">\n" +
    "\t\t\t\t\t\t\t\t\t{{'ALL'| translate}}\n" +
    "\t\t\t\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t\t\t</label>\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t<label class=\"radio\" ng-class=\"{checked:checkoutData.checkout_staff_alert_option == 'not_success'}\">\n" +
    "\t\t\t\t\t\t\t\t\t<span class=\"icon-form icon-radio \" ng-class=\"{checked:checkoutData.checkout_staff_alert_option == 'not_success'}\"></span>\n" +
    "\t\t\t\t\t\t\t\t\t<input type=\"radio\" ng-model=\"checkoutData.checkout_staff_alert_option\" value=\"not_success\" class=\"change-data\">\n" +
    "\t\t\t\t\t\t\t\t\t{{'CHECKOUT_NOT_SUCESSFULL' | translate}}\n" +
    "\t\t\t\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t\t\t<ad-textarea rows=\"4\" div-class=\"full-width\" text-area-class=\"full-width\" value=\"checkoutData.emails\" label = \"{{'EMAIL_ACCOUNTS_LABEL' | translate}}\" placeholder = \"\"></ad-textarea>\n" +
    "\n" +
    "\t\t\t\t\t\t\t<ad-textarea rows=\"4\" div-class=\"full-width\" text-area-class=\"full-width\" value=\"checkoutData.staff_emails_for_late_checkouts\" label = \"{{'EMAIL_ACCOUNTS_LABEL2' | translate}}\" placeholder = \"\"></ad-textarea>\n" +
    "\n" +
    "\t\t\t\t\t\t\t<ad-textarea rows=\"4\" div-class=\"full-width\" text-area-class=\"full-width\" value=\"checkoutData.room_verification_instruction\" label = \"{{'ROOM_VERIFICATION_INSTRUCTIONS' | translate}}\" placeholder = \"\" maxlength=\"200\"></ad-textarea>\n" +
    "\n" +
    "\t\t\t\t\t\t</fieldset>\n" +
    "\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t<div class=\"actions float\">\n" +
    "\t\t\t\t\t\t\t<button type=\"button\" ng-click=\"goBackToPreviousState()\" class=\"button blank add-data-inline\" translate>CANCEL</button>\n" +
    "\t\t\t\t\t\t\t<button type=\"button\" ng-click=\"saveCheckout()\" class=\"button green\" translate>SAVE_CHANGES</button>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t</form>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</section>\n" +
    "\t</section>\n"
  );


  $templateCache.put('/assets/partials/common/notification_message.html',
    "<div ng-show=\"errorMessage!=''\" ng-class=\"{notice: errorMessage!=''}\" class='error error_message' ng-switch on=\"errorMessage.length\">\n" +
    "\t\n" +
    "\t<span class=\"close-btn\" ng-click=\"clearErrorMessage()\"></span>\n" +
    "\t<span ng-switch-when=\"1\">\n" +
    "\t\t\t{{errorMessage[0]}}\n" +
    "\t</span>\n" +
    "\t<span ng-switch-default>\t\t\n" +
    "\t\t<span ng-repeat=\"message in errorMessage track by $index\" >\n" +
    "\t\t\t<span ng-if=!$last>{{message}}, </span>\n" +
    "\t\t\t<span ng-if=$last> {{message}} </span>\n" +
    "\t\t</span>\n" +
    "\t</span>\t\n" +
    "\t\n" +
    "\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/common/notification_success_message.html',
    "<div ng-show=\"successMessage!=''\" ng-class=\"{notice: successMessage!=''}\" class='success success_message'>\n" +
    "\t<span class=\"close-btn\" ng-click=\"clearErrorMessage()\"></span>\n" +
    "\t<span>\n" +
    "\t\t\t{{successMessage}}\n" +
    "\t</span>\n" +
    "\t\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/contentManagement/adContentManagement.html',
    "<section class=\"content current\" ng-click='clearErrorMessage()'>\n" +
    "\t\n" +
    "    \t<header class=\"content-title\">\n" +
    "            <h2 translate>CONTENT_MANAGEMENT_TITLE</h2>\n" +
    "            <a class=\"action add\" ui-sref = \"admin.contentManagementSectionDetails({id:'new'})\" translate>SECTION_LABEL</a>\n" +
    "            <a class=\"action add\" ui-sref = \"admin.contentManagementCategoryDetails({id:'new'})\" translate>CATEGORY_LABEL</a>\n" +
    "            <a class=\"action add\" ui-sref = \"admin.contentManagementItemDetails({id:'new'})\" translate>ITEM_LABEL</a>\n" +
    "            <div class=\"filters\">\n" +
    "                <ul id=\"view-options\" class=\"cms-view\">\n" +
    "                    <li ng-class= \"{'active':isGridView}\" ng-click=\"isGridView = !isGridView\" ><span translate>VIEW_GRID_LABEL</span></li>\n" +
    "                    <li ng-class= \"{'active':!isGridView}\" ng-click=\"isGridView = !isGridView\" ><span translate>VIEW_TREE_LABEL</span></li>\n" +
    "                </ul>\n" +
    "            </div>\n" +
    "        </header>\n" +
    "        \n" +
    "         <section class=\"content-scroll\" ng-show=\"isGridView\"  ng-include=\"'/assets/partials/contentManagement/adContentManagementGridView.html'\"></section>\n" +
    "         \n" +
    "         <section class=\"content-scroll\" ng-show=\"!isGridView\" ng-include=\"'/assets/partials/contentManagement/adContentManagementTreeView.html'\"></section>\n" +
    "\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/contentManagement/adContentManagementAssignComponentModal.html',
    "<div id=\"modal\" class=\"modal-show\" role=\"dialog\">\n" +
    "    <form method=\"post\" action=\"\" id=\"component-tree\" name=\"component-tree\" class=\"modal-content cms-content\">\n" +
    "        <span class=\"message h3\" ng-show=\"isSection && sections.length > 0\" translate>SELECT_SECTION_LABEL</span>\n" +
    "        <span class=\"message h3\" ng-show=\"!isSection && categories.length > 0\" translate>SELECT_CATEGORY_LABEL</span>\n" +
    "        <ul class=\"cms-tree\" ng-show=\"isSection\">\n" +
    "            <li class=\"section\" ng-class=\"{'selected': isSectionSelected($index)}\" ng-click = \"sectionAdded($index)\" ng-show=\"isComponentAvailable(section)\" ng-repeat=\"section in sections\"> <!-- Add class 'selected' if selected -->\n" +
    "    \t\t\t<div class=\"sort\">\n" +
    "    \t\t\t\t<strong class=\"cms-name\">{{section.name}}</strong>\n" +
    "    \t\t\t\t<span class=\"icons icon-added\" ng-show=\"isSectionSelected($index)\">Selected</span>\n" +
    "    \t\t\t</div>\n" +
    "    \t\t</li>\n" +
    "    \t\t\n" +
    "        </ul>\n" +
    "\n" +
    "        <ul class=\"cms-tree\" ng-show=\"!isSection\">\n" +
    "            <li class=\"categories\" ng-class=\"{'selected': isCategorySelected($index)}\" ng-click = \"categoryAdded($index)\" ng-show=\"isComponentAvailable(category)\" ng-repeat=\"category in categories\"> <!-- Add class 'selected' if selected -->\n" +
    "                <div class=\"sort\">\n" +
    "                    <strong class=\"cms-name\">{{category.name}}</strong>\n" +
    "                    <span class=\"icons icon-added\" ng-show = \"isCategorySelected($index)\" >Selected</span>\n" +
    "                </div>\n" +
    "            </li>\n" +
    "            \n" +
    "        </ul>\n" +
    "\n" +
    "        <span class=\"message h3\" ng-show=\"isSection && sections.length == 0 && isDataFetched\" translate>NO_SECTION_MESSAGE</span>\n" +
    "        <span class=\"message h3\" ng-show=\"!isSection && categories.length == 0 && isDataFetched\" translate>NO_CATEGORY_MESSAGE</span>\n" +
    "\n" +
    "        <div class=\"actions\">\n" +
    "            <button type=\"button\" ng-click=\"confirmClicked()\" ng-show = \"((isSection && sections.length > 0) || (!isSection && categories.length > 0))\" class=\"button green\" translate>CONFIRM_LABEL</button>\n" +
    "            <button type=\"button\" ng-click=\"cancelClicked()\" ng-show = \"((isSection && sections.length > 0) || (!isSection && categories.length > 0))\" class=\"button blank\" translate>CANCEL</button>\n" +
    "            <button type=\"button\" ng-click=\"cancelClicked()\" ng-show = \"!((isSection && sections.length > 0) || (!isSection && categories.length > 0)) && isDataFetched\" class=\"button green\" translate>OK</button>\n" +
    "        </div>\n" +
    "    </form>\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/contentManagement/adContentManagementCategoryDetail.html',
    "<section class=\"content current\" ng-click=\"clearErrorMessage()\">\n" +
    "    <header class=\"content-title\">\n" +
    "        <h2 ng-show=\"!isAddMode\" ><span translate>EDIT_CATEGORY_LABEL</span> <span>{{data.name}}</span></h2>\n" +
    "        <h2 ng-show=\"isAddMode\" translate>ADD_CATEGORY_LABEL</h2>\n" +
    "        <a ng-click=\"goBack()\" class=\"action back\" translate>BACK</a>\n" +
    "        <a class=\"action remove\" ng-hide=\"!data.id \" ng-click=\"deleteItem(data.id)\" translate>DELETE_CATEGORY_LABEL</a>\n" +
    "    </header>\n" +
    "\n" +
    "    <section class=\"content-scroll\">\n" +
    "        <div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "        <form method=\"post\" class=\"form float\">\n" +
    "            <fieldset class=\"holder left\">\n" +
    "                <div class=\"form-title\">\n" +
    "                    <h3><span translate>CATEGORY_LABEL</span> <span translate>DETAILS_LABEL</span></h3>\n" +
    "                    <em class=\"status\" ><span translate>MANDATORY_FIELDS_MESSAGE1</span> <strong>*</strong><span translate>MANDATORY_FIELDS_MESSAGE2</span></em>\n" +
    "                </div>\n" +
    "                <div class=\"entry full-width\">\n" +
    "                    <label for=\"category-availability\" ><span translate>AVAILABILITY_STATUS_LABEL</span><strong>*</strong></label>\n" +
    "                    <div class=\"switch-button\" ng-class=\"{'on':data.status}\">\n" +
    "                        <input name=\"category-availability\" id=\"category-availability\" value=\"1\" type=\"checkbox\" ng-model=\"data.status\" />\n" +
    "                        <span class=\"switch-icon\"></span>\n" +
    "                    </div>\n" +
    "                </div> \n" +
    "                <div class=\"entry\">\n" +
    "                    <label for=\"category-name\"><span translate>CATEGORY_NAME_LABEL</span> <strong>*</strong></label>\n" +
    "                    <input type=\"text\" name=\"category-name\" id=\"category-name\" placeholder=\"Enter category name\" ng-model= \"data.name\" required />\n" +
    "                </div>\n" +
    "                <div class=\"entry full-width\">\n" +
    "                    <label for=\"category-icon\" > <span translate>CATEGORY_ICON_LABEL</span> <span translate>ICON_SPEC</span></label>\n" +
    "                    <div class=\"file-upload with-preview small-preview\">\n" +
    "                        <span class=\"input\">{{fileName}}</span>\n" +
    "                        <input type=\"file\" name=\"category-icon\" ng-model = \"data.icon\" app-filereader id=\"category-icon\" />\n" +
    "                        <button type=\"button\" ng-if=\"data.icon != null && data.icon != ''\" class=\"button brand-colors\" translate>REPLACE_ICON_LABEL</button>\n" +
    "                        <button type=\"button\" ng-if=\"data.icon == null || data.icon == ''\" class=\"button brand-colors\" translate>ADD_ICON_LABEL</button>\n" +
    "                    </div>\n" +
    "                    <span class=\"file-preview small-preview\">\n" +
    "                        <img src=\"{{data.icon}}\" alt=\"\" />\n" +
    "                    </span>\n" +
    "                </div>     \n" +
    "            </fieldset>\n" +
    "            <fieldset class=\"holder right\">\n" +
    "                <div class=\"form-title\">\n" +
    "                    <h3><span translate>TO_SECTION_LABEL</span></h3>\n" +
    "                </div>\n" +
    "                <div class=\"entry full-width\">\n" +
    "                    <ul class=\"boxes cms-tree\">\n" +
    "                        <li class=\"section\" ng-repeat=\"section in data.parent_section\">\n" +
    "                            <div class=\"sort\">\n" +
    "                                <span class=\"cms-name\">{{section.name}}</span>\n" +
    "                                <div class=\"cms-delete\">\n" +
    "                                    <a class=\"icons icon-delete\" ng-click=\"deleteParentSection($index)\">Delete</a>\n" +
    "                                </div>\n" +
    "                            </div>\n" +
    "                        </li>\n" +
    "                        \n" +
    "                        <li class=\"add\">\n" +
    "                            <a  class=\"add-new-button open-modal\" ng-click= \"openAddParentModal(true)\" translate>ADD_SECTION_LABEL</a>\n" +
    "                        </li>\n" +
    "                    </ul>\n" +
    "                </div>\n" +
    "                <div class=\"form-title\">\n" +
    "                    <h3><span translate>TO_CATEGORY_LABEL</span></h3>\n" +
    "                </div>\n" +
    "                <div class=\"entry full-width\">\n" +
    "                    <ul class=\"boxes cms-tree\">\n" +
    "                        <li class=\"category\" ng-repeat=\"category in data.parent_category\">\n" +
    "                            <div class=\"sort\">\n" +
    "                                <span class=\"cms-name\">{{category.name}}</span>\n" +
    "                                <div class=\"cms-delete\">\n" +
    "                                    <a class=\"icons icon-delete\" ng-click=\"deleteParentCategory($index)\">Delete</a>\n" +
    "                                </div>\n" +
    "                            </div>\n" +
    "                        </li>\n" +
    "                        \n" +
    "                        <li class=\"add\">\n" +
    "                            <a class=\"add-new-button open-modal\" ng-click= \"openAddParentModal(false)\" translate>ADD_CATEGORY_LABEL</a>\n" +
    "                        </li>\n" +
    "                    </ul> \n" +
    "                </div>        \n" +
    "            </fieldset>\n" +
    "            <div class=\"actions float\">\n" +
    "                <button type=\"button\" ng-click=\"goBack()\" class=\"button blank\" translate>CANCEL</button>\n" +
    "                <button type=\"button\" ng-click=\"saveCategory()\" class=\"button green\" translate>SAVE_CHANGES</button>  \n" +
    "            </div>\n" +
    "        </form>\n" +
    "    </section>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/contentManagement/adContentManagementChildView.html',
    "<ol ng-controller=\"ADContentManagementChildViewCtrl\">\n" +
    "    <li class=\"branch\" ng-class= \"{'collapsed': !content.isExpanded, 'expanded': content.isExpanded, 'category': content.component_type == 'CATEGORY', 'item': content.component_type == 'PAGE' }\" ng-repeat = \"content in contentList\">\n" +
    "                            <div class=\"sort\">\n" +
    "                                <span class=\"reorder\" ng-show=\"content.children.length > 0\" ng-click= \"toggleExpansion($index)\"></span>\n" +
    "                                <a  ng-click = \"componentSelected(content.component_type, content.id)\" class=\"cms-name\">{{content.name}}</a>\n" +
    "                                <span class=\"cms-type cms-content-type\">{{content.component_type == 'PAGE'? 'ITEM_LABEL' : content.component_type | translate}}</span>\n" +
    "                                <em class=\"cms-date\">{{getFormattedTime(content.updated_at)}}</em>\n" +
    "                                <div class=\"cms-activate\">\n" +
    "                                    <div class=\"switch-button\" ng-class=\"{'on':content.status}\">\n" +
    "                                        <input name=\"category\" ng-change=\"saveAvailabilityStatus(content.id, content.status)\" id=\"category\" value=\"category\" type=\"checkbox\" ng-model=\"content.status\" />\n" +
    "                                        <span class=\"switch-icon\"></span>\n" +
    "                                    </div>\n" +
    "                                </div>\n" +
    "                                <div class=\"cms-delete\">\n" +
    "                                     <a  class=\"icons icon-delete large-icon\" ng-click=\"deleteItem(content.id)\">Delete</a>\n" +
    "                                </div>\n" +
    "                            </div>\n" +
    "\n" +
    "                            <!-- Item -->\n" +
    "                            <div ng-show=\"content.children.length > 0 && content.isExpanded\" ng-include= \"'/assets/partials/contentManagement/adContentManagementChildView.html'\">\n" +
    "                                \n" +
    "                                \n" +
    "                            </div>\n" +
    "    </li>\n" +
    "</ol>"
  );


  $templateCache.put('/assets/partials/contentManagement/adContentManagementGridView.html',
    "    <div ng-controller=\"ADContentManagementGridviewCtrl\" >\n" +
    "        <div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\n" +
    "\n" +
    "        <div id=\"sections\" class=\"cms-grid\">\n" +
    "\n" +
    "            <!-- Grid options -->\n" +
    "            <div class=\"grid-options\">\n" +
    "                <!-- Show sections, categories or items. This template assumes section is default view. If that is changed, then be carefull in hiding items below listed as hidden by default - some should not be hidden if category or item is shown by default -->\n" +
    "                <div class=\"entry filter\">\n" +
    "                    <label for=\"showing-structure\" translate>SHOWING_LABEL</label>\n" +
    "                    <div class=\"select\">\n" +
    "                        <select id=\"showing-structure\" ng-change=\"viewSelected()\" ng-model=\"selectedView\">\n" +
    "                            <option value=\"section\" selected translate>SECTIONS_OPTION</option>\n" +
    "                            <option value=\"category\" translate>CATEGORIES_OPTION</option>\n" +
    "                            <option value=\"item\" translate>ITEMS_OPTION</option>\n" +
    "                        </select>\n" +
    "                    </div>\n" +
    "                </div>\n" +
    "\n" +
    "                <!-- Filter by section, hidden by default - show only when listing categories or items --> \n" +
    "                <div class=\"entry filter\" ng-show=\"selectedView == 'category'\">\n" +
    "                    <label for=\"showing-categories\" translate>FROM_SECTION_LABEL</label>\n" +
    "                    <div class=\"select\">\n" +
    "                        <select id=\"showing-categories\" ng-model=\"fromSection\" ng-change=\"filterBySectionAndCategory()\" class=\"placeholder\" ng-disabled = \"showUnMappedList\">\n" +
    "                            <option value=\"all\" translate>ALL_SECTIONS_LABEL</option>\n" +
    "                            <option value=\"{{section.id}}\" ng-repeat=\"section in sections\">{{section.name}}</option>\n" +
    "                            \n" +
    "                        </select>\n" +
    "                    </div>\n" +
    "                </div>\n" +
    "\n" +
    "                <!--Filter by category, hidden by default - show only when listing items -->\n" +
    "                <div class=\"entry filter\" ng-show=\"selectedView == 'item'\">\n" +
    "                    <label for=\"showing-items\" translate>FROM_CATEGORIES_LABEL</label>\n" +
    "                    <div class=\"select\" >\n" +
    "                        <select id=\"showing-items\" ng-model = \"fromCategory\" ng-change=\"filterBySectionAndCategory()\" class=\"placeholder\" ng-disabled = \"showUnMappedList\">\n" +
    "                            <option value=\"all\" translate>ALL_CATEGORIES_LABEL</option>\n" +
    "                             <option value=\"{{category.id}}\" ng-repeat=\"category in category_options\">{{category.name}}</option>\n" +
    "                            \n" +
    "                        </select>\n" +
    "                    </div>\n" +
    "                </div>\n" +
    "\n" +
    "                <!-- Show only unassigned categories or items, hidden by default - show only when listing items or categories -->\n" +
    "                <div class=\"entry radio-check \" ng-show=\"selectedView != 'section'\">\n" +
    "                    <label for=\"unassigned\" class=\"checkbox\">\n" +
    "                        <span class=\"icon-form icon-checkbox\" ng-class=\"{'checked': showUnMappedList}\"></span>\n" +
    "                        <span translate>SHOW_UNASSIGNED_LABEL</span>\n" +
    "                        <input id=\"unassigned\" name=\"unassigned\" ng-change=\"filterBySectionAndCategory()\" ng-model = \"showUnMappedList\" type=\"checkbox\">\n" +
    "                    </label>\n" +
    "                </div>\n" +
    "\n" +
    "                <!-- Search option -->\n" +
    "                <div class=\"entry search\">\n" +
    "                    <label for=\"structure-search\" translate>SEARCH_LABEL</label>\n" +
    "                    <div class=\"holder\">\n" +
    "                        <button type=\"submit\" name=\"submit\" class=\"icons icon-search\" translate>SEARCH_LABEL</button>\n" +
    "                        <input type=\"search\" class=\"query\" placeholder=\"Search sections, categories or items\" ng-model=\"searchText\"  id=\"structure-search\" autocomplete=\"off\" />\n" +
    "                    </div>\n" +
    "                </div>    \n" +
    "            </div>\n" +
    "\n" +
    "            <!-- Grid content -->\n" +
    "            <table class=\"grid datatable ng-table\" ng-show=\"selectedView == 'section'\" ng-table=\"sectionParams\">\n" +
    "                \n" +
    "                <!-- Section table HTML -->\n" +
    "                <thead>                 \n" +
    "\n" +
    "                    <th class=\"sortable\" ng-class=\"{\n" +
    "                        'sort-asc': sectionParams.isSortBy('name', 'asc'),\n" +
    "                        'sort-desc': sectionParams.isSortBy('name', 'desc')\n" +
    "                      }\"\n" +
    "                        ng-click=\"sectionParams.sorting({'name' : sectionParams.isSortBy('name', 'asc') ? 'desc' : 'asc'})\" rowspan=\"2\">\n" +
    "                        <div><i class=\"glyphicon glyphicon-user\"></i> <span translate>NAME_LABEL</span></div>\n" +
    "                    </th>\n" +
    "                    <th class=\"sortable\" ng-class=\"{\n" +
    "                        'sort-asc': sectionParams.isSortBy('last_updated', 'asc'),\n" +
    "                        'sort-desc': sectionParams.isSortBy('last_updated', 'desc')\n" +
    "                      }\"\n" +
    "                        ng-click=\"sectionParams.sorting({'last_updated' : sectionParams.isSortBy('last_updated', 'asc') ? 'desc' : 'asc'})\" rowspan=\"2\">\n" +
    "                        <div><i class=\"glyphicon glyphicon-user\"></i> <span translate>LAST_UPDATE_LABEL</span></div>\n" +
    "                    </th>       \n" +
    "\n" +
    "                    <th class=\"sortable\" ng-class=\"{\n" +
    "                        'sort-asc': sectionParams.isSortBy('no_of_categories', 'asc'),\n" +
    "                        'sort-desc': sectionParams.isSortBy('no_of_categories', 'desc')\n" +
    "                      }\"\n" +
    "                        ng-click=\"sectionParams.sorting({'no_of_categories' : sectionParams.isSortBy('no_of_categories', 'asc') ? 'desc' : 'asc'})\" rowspan=\"2\">\n" +
    "                        <div><i class=\"glyphicon glyphicon-user\"></i> <span translate>NO_OF_CATEGORIES_LABEL</span></div>\n" +
    "                    </th>    \n" +
    "                    <th class=\"sortable\" ng-class=\"{\n" +
    "                        'sort-asc': sectionParams.isSortBy('no_of_items', 'asc'),\n" +
    "                        'sort-desc': sectionParams.isSortBy('no_of_items', 'desc')\n" +
    "                      }\"\n" +
    "                        ng-click=\"sectionParams.sorting({'no_of_items' : sectionParams.isSortBy('no_of_items', 'asc') ? 'desc' : 'asc'})\" rowspan=\"2\">\n" +
    "                        <div><i class=\"glyphicon glyphicon-user\"></i> <span translate>NO_OF_ITEMS_LABEL</span></div>\n" +
    "                    </th>        \n" +
    "                    <th class=\"sortable\" ng-class=\"{\n" +
    "                        'sort-asc': sectionParams.isSortBy('status', 'asc'),\n" +
    "                        'sort-desc': sectionParams.isSortBy('status', 'desc')\n" +
    "                      }\"\n" +
    "                        ng-click=\"sectionParams.sorting({'status' : sectionParams.isSortBy('status', 'asc') ? 'desc' : 'asc'})\" rowspan=\"2\">\n" +
    "                        <div><i class=\"glyphicon glyphicon-user\"></i> <span translate>STATUS_LABEL</span></div>\n" +
    "                    </th> \n" +
    "                        <th class=\"width-10\" translate> DELETE_LABEL</th>\n" +
    "                </thead>\n" +
    "                <tbody>\n" +
    "                    <tr ng-repeat=\"gridItem in $data | filter:searchText\">\n" +
    "                        <td><a ng-click=\"componentSelected(selectedView, gridItem.id)\">{{gridItem.name}}</a></td>\n" +
    "                        <td><em>{{getFormattedTime(gridItem.last_updated)}}</em></td>\n" +
    "                        <td>{{gridItem.no_of_categories}}</td>\n" +
    "                        <td>{{gridItem.no_of_section_items}}</td>\n" +
    "                        <td >\n" +
    "                            <div class=\"switch-button \" ng-class=\"{'on':gridItem.status}\">\n" +
    "                                <input name=\"status\" id=\"status\" ng-change=\"saveAvailabilityStatus(gridItem.id, gridItem.status)\" value=\"gridItem.status\" type=\"checkbox\" ng-model=\"gridItem.status\"  />\n" +
    "                                <span class=\"switch-icon\"></span>\n" +
    "                            </div>\n" +
    "                        </td>\n" +
    "                        <td class=\"delete\">\n" +
    "                            <a  class=\"icons icon-delete large-icon\" ng-click=\"deleteItem(gridItem.id)\">Delete</a>\n" +
    "                        </td>\n" +
    "                    </tr>\n" +
    "                </tbody>\n" +
    "             </table> \n" +
    "\n" +
    "             <!-- Categories table HTML -->\n" +
    "             <table class=\"grid datatable ng-table\" ng-show=\"selectedView == 'category'\" ng-table=\"categoryParams\">\n" +
    "                \n" +
    "                \n" +
    "                <thead>                 \n" +
    "\n" +
    "                    <th class=\"sortable\" ng-class=\"{\n" +
    "                        'sort-asc': categoryParams.isSortBy('name', 'asc'),\n" +
    "                        'sort-desc': categoryParams.isSortBy('name', 'desc')\n" +
    "                      }\"\n" +
    "                        ng-click=\"categoryParams.sorting({'name' : categoryParams.isSortBy('name', 'asc') ? 'desc' : 'asc'})\" rowspan=\"2\">\n" +
    "                        <div><i class=\"glyphicon glyphicon-user\"></i> <span translate>NAME_LABEL</span></div>\n" +
    "                    </th>\n" +
    "\n" +
    "                    <th class=\"sortable\" ng-class=\"{\n" +
    "                        'sort-asc': categoryParams.isSortBy('last_updated', 'asc'),\n" +
    "                        'sort-desc': categoryParams.isSortBy('last_updated', 'desc')\n" +
    "                      }\"\n" +
    "                        ng-click=\"categoryParams.sorting({'last_updated' : categoryParams.isSortBy('last_updated', 'asc') ? 'desc' : 'asc'})\" rowspan=\"2\">\n" +
    "                        <div><i class=\"glyphicon glyphicon-user\"></i> <span translate>LAST_UPDATE_LABEL</span></div>\n" +
    "                    </th>  \n" +
    "                     \n" +
    "                    <th class=\"sortable\" ng-class=\"{\n" +
    "                        'sort-asc': categoryParams.isSortBy('no_of_items', 'asc'),\n" +
    "                        'sort-desc': categoryParams.isSortBy('no_of_items', 'desc')\n" +
    "                      }\"\n" +
    "                        ng-click=\"categoryParams.sorting({'no_of_items' : categoryParams.isSortBy('no_of_items', 'asc') ? 'desc' : 'asc'})\" rowspan=\"2\">\n" +
    "                        <div><i class=\"glyphicon glyphicon-user\"></i> <span translate>NO_OF_ITEMS_LABEL</span></div>\n" +
    "                    </th>        \n" +
    "                    <th class=\"sortable\" ng-class=\"{\n" +
    "                        'sort-asc': categoryParams.isSortBy('status', 'asc'),\n" +
    "                        'sort-desc': categoryParams.isSortBy('status', 'desc')\n" +
    "                      }\"\n" +
    "                        ng-click=\"categoryParams.sorting({'status' : categoryParams.isSortBy('status', 'asc') ? 'desc' : 'asc'})\" rowspan=\"2\">\n" +
    "                        <div><i class=\"glyphicon glyphicon-user\"></i> <span translate>STATUS_LABEL</span></div>\n" +
    "                    </th> \n" +
    "                        <th class=\"width-10\" translate> DELETE_LABEL</th>\n" +
    "                </thead>\n" +
    "                <tbody>\n" +
    "                    <tr ng-repeat=\"gridItem in $data | filter:searchText\">\n" +
    "                        <td><a ng-click=\"componentSelected(selectedView, gridItem.id)\">{{gridItem.name}}</a></td>\n" +
    "                        <td><em>{{getFormattedTime(gridItem.last_updated)}}</em></td>                        \n" +
    "                        <td>{{gridItem.no_of_items}}</td>\n" +
    "                        <td >\n" +
    "                            <div class=\"switch-button \" ng-class=\"{'on':gridItem.status}\">\n" +
    "                                <input name=\"status\" id=\"status\" ng-change=\"saveAvailabilityStatus(gridItem.id, gridItem.status)\" value=\"gridItem.status\" type=\"checkbox\" ng-model=\"gridItem.status\"  />\n" +
    "                                <span class=\"switch-icon\"></span>\n" +
    "                            </div>\n" +
    "                        </td>\n" +
    "                        <td class=\"delete\">\n" +
    "                            <a  class=\"icons icon-delete large-icon\" ng-click=\"deleteItem(gridItem.id)\">Delete</a>\n" +
    "                        </td>\n" +
    "                    </tr>\n" +
    "                </tbody>\n" +
    "             </table>\n" +
    "\n" +
    "             <!-- Items table HTML -->\n" +
    "             <table class=\"grid datatable ng-table\" ng-show=\"selectedView == 'item'\" ng-table=\"itemParams\">               \n" +
    "                \n" +
    "                <thead>                 \n" +
    "\n" +
    "                    <th class=\"sortable\" ng-class=\"{\n" +
    "                        'sort-asc': itemParams.isSortBy('name', 'asc'),\n" +
    "                        'sort-desc': itemParams.isSortBy('name', 'desc')\n" +
    "                      }\"\n" +
    "                        ng-click=\"itemParams.sorting({'name' : itemParams.isSortBy('name', 'asc') ? 'desc' : 'asc'})\" rowspan=\"2\">\n" +
    "                        <div><i class=\"glyphicon glyphicon-user\"></i> <span translate>NAME_LABEL</span></div>\n" +
    "                    </th>\n" +
    "\n" +
    "                    <th class=\"sortable\" ng-class=\"{\n" +
    "                        'sort-asc': itemParams.isSortBy('page_template', 'asc'),\n" +
    "                        'sort-desc': itemParams.isSortBy('page_template', 'desc')\n" +
    "                      }\"\n" +
    "                        ng-click=\"itemParams.sorting({'page_template' : itemParams.isSortBy('page_template', 'asc') ? 'desc' : 'asc'})\" rowspan=\"2\">\n" +
    "                        <div><i class=\"glyphicon glyphicon-user\"></i> <span translate>TYPE_LABEL</span></div>\n" +
    "                    </th>\n" +
    "                    <th class=\"sortable\" ng-class=\"{\n" +
    "                        'sort-asc': itemParams.isSortBy('last_updated', 'asc'),\n" +
    "                        'sort-desc': itemParams.isSortBy('last_updated', 'desc')\n" +
    "                      }\"\n" +
    "                        ng-click=\"itemParams.sorting({'last_updated' : itemParams.isSortBy('last_updated', 'asc') ? 'desc' : 'asc'})\" rowspan=\"2\">\n" +
    "                        <div><i class=\"glyphicon glyphicon-user\"></i> <span translate>LAST_UPDATE_LABEL</span></div>\n" +
    "                    </th>                            \n" +
    "                    <th class=\"sortable\" ng-class=\"{\n" +
    "                        'sort-asc': itemParams.isSortBy('status', 'asc'),\n" +
    "                        'sort-desc': itemParams.isSortBy('status', 'desc')\n" +
    "                      }\"\n" +
    "                        ng-click=\"itemParams.sorting({'status' : itemParams.isSortBy('status', 'asc') ? 'desc' : 'asc'})\" rowspan=\"2\">\n" +
    "                        <div><i class=\"glyphicon glyphicon-user\"></i> <span translate>STATUS_LABEL</span></div>\n" +
    "                    </th> \n" +
    "                        <th class=\"width-10\" translate> DELETE_LABEL</th>\n" +
    "                </thead>\n" +
    "                <tbody>\n" +
    "                    <tr ng-repeat=\"gridItem in $data | filter:searchText\">\n" +
    "                        <td><a ng-click=\"componentSelected(selectedView, gridItem.id)\">{{gridItem.name}}</a></td>\n" +
    "                        <td>{{gridItem.page_template}}</td>\n" +
    "                        <td><em>{{getFormattedTime(gridItem.last_updated)}}</em></td>                        \n" +
    "                        <td >\n" +
    "                            <div class=\"switch-button \" ng-class=\"{'on':gridItem.status}\">\n" +
    "                                <input name=\"status\" id=\"status\" ng-change=\"saveAvailabilityStatus(gridItem.id, gridItem.status)\" value=\"gridItem.status\" type=\"checkbox\" ng-model=\"gridItem.status\"  />\n" +
    "                                <span class=\"switch-icon\"></span>\n" +
    "                            </div>\n" +
    "                        </td>\n" +
    "                        <td class=\"delete\">\n" +
    "                            <a  class=\"icons icon-delete large-icon\"ng-click=\"deleteItem(gridItem.id)\">Delete</a>\n" +
    "                        </td>\n" +
    "                    </tr>\n" +
    "                </tbody>\n" +
    "             </table>              \n" +
    "            \n" +
    "        </div>\n" +
    "    </div>\n" +
    "       \n"
  );


  $templateCache.put('/assets/partials/contentManagement/adContentManagementItemDetail.html',
    "<section class=\"content current\" ng-click=\"clearErrorMessage()\">\n" +
    "    <header class=\"content-title\">\n" +
    "        <h2 ng-show=\"!isAddMode\" ><span translate>EDIT_ITEM_LABEL</span> <span>{{data.name}}</span></h2>\n" +
    "        <h2 ng-show=\"isAddMode\" translate>ADD_ITEM_LABEL</h2>\n" +
    "        <a ng-click=\"goBack()\" class=\"action back\" translate>BACK</a>\n" +
    "        <a class=\"action remove\" ng-hide=\"!data.id \" ng-click=\"deleteItem(data.id)\" translate>DELETE_ITEM_LABEL</a>\n" +
    "    </header>\n" +
    "\n" +
    "    <section class=\"content-scroll\">\n" +
    "        <div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "        <form method=\"post\" action=\"\" id=\"{add/edit}\" name=\"{add/edit}-item\" class=\"form float\">\n" +
    "            <fieldset class=\"holder left\">\n" +
    "                <div class=\"form-title\">\n" +
    "                    <h3><span translate>ITEM_LABEL</span> <span translate>DETAILS_LABEL</span></h3>\n" +
    "                    <em class=\"status\"><span translate>MANDATORY_FIELDS_MESSAGE1</span> <strong>*</strong> <span translate>MANDATORY_FIELDS_MESSAGE2</span></em>\n" +
    "                </div>\n" +
    "                <div class=\"entry full-width\">\n" +
    "                    <label for=\"item-availability\"><span translate>AVAILABILITY_STATUS_LABEL</span> <strong>*</strong></label>\n" +
    "                    <div class=\"switch-button\" ng-class=\"{'on': data.status}\">\n" +
    "                        <input name=\"item-availability\" ng-model=\"data.status\" id=\"item-availability\" value=\"1\" type=\"checkbox\"  />\n" +
    "                        <span class=\"switch-icon\"></span>\n" +
    "                    </div>\n" +
    "                </div>\n" +
    "                <div class=\"entry\">\n" +
    "                    <label for=\"item-name\"><span translate>ITEM_NAME_LABEL</span> <strong>*</strong></label>\n" +
    "                    <input type=\"text\" name=\"item-name\" ng-model=\"data.name\" id=\"item-name\" placeholder=\"Enter item name\" value=\"{Item Name}\" required />\n" +
    "                </div>\n" +
    "                <div class=\"entry full-width\">\n" +
    "                    <label for=\"item-type\"><span translate>ITEM_TYPE_LABEL</span> <strong>*</strong></label>\n" +
    "                    <div class=\"boxes\">\n" +
    "                        <label class=\"radio\" ng-class = \"{'checked': data.page_template=='POI'}\"> \n" +
    "                            <span class=\"icon-form icon-radio \" ng-class = \"{'checked': data.page_template=='POI'}\"></span>\n" +
    "                            <input type=\"radio\" name=\"item-type\" ng-model=\"data.page_template\" id=\"poi\" value=\"POI\" />\n" +
    "                            <span translate>POI_LABEL</span> \n" +
    "                        </label>\n" +
    "                        <label class=\"radio\" ng-class = \"{'checked': data.page_template=='POI'}\"> \n" +
    "                            <span class=\"icon-form icon-radio\" ng-class = \"{'checked': data.page_template=='GENERAL'}\"></span>\n" +
    "                            <input type=\"radio\" name=\"item-type\" ng-model=\"data.page_template\" id=\"general\" value=\"GENERAL\" />\n" +
    "                            <span translate>GENERAL_LABEL</span> \n" +
    "                        </label>\n" +
    "                        <label class=\"radio\" ng-class = \"{'checked': data.page_template=='POI'}\"> \n" +
    "                            <span class=\"icon-form icon-radio\" ng-class = \"{'checked': data.page_template=='LINK'}\"></span>\n" +
    "                            <input type=\"radio\" name=\"item-type\" ng-model=\"data.page_template\" id=\"link\" value=\"LINK\" />\n" +
    "                           <span translate>LINK_LABEL</span> \n" +
    "                        </label>\n" +
    "                    </div>\n" +
    "                </div>\n" +
    "                <div class=\"entry full-width\">\n" +
    "                    <label for=\"item-image\"><span translate>ITEM_IMAGE_LABEL</span><span translate>IMAGE_SPEC</span></label>\n" +
    "                    <div class=\"file-upload with-preview large-preview\">\n" +
    "                        <span class=\"input\">{{fileName}}</span>\n" +
    "                        <input type=\"file\" name=\"item-image\" ng-model=\"data.image\" app-filereader id=\"item-image\" />\n" +
    "                        <button type=\"button\" ng-if=\"data.image != null && data.image != ''\" class=\"button brand-colors\" translate>REPLACE_IMAGE_LABEL</button>\n" +
    "                        <button type=\"button\" ng-if=\"data.image == null || data.image == ''\" class=\"button brand-colors\" translate>ADD_IMAGE_LABEL</button>\n" +
    "                    </div>\n" +
    "                    <span class=\"file-preview large-preview\">\n" +
    "                        <img src=\"{{data.image}}\" alt=\"\" />\n" +
    "                    </span>\n" +
    "                </div>\n" +
    "                <div class=\"entry full-width\">\n" +
    "                    <label for=\"item-description\" translate>DESCRIPTION_LABEL</label>\n" +
    "                    <textarea name=\"item-description\" ng-model=\"data.description\" id=\"item-description\" rows=\"4\" placeholder=\"Item description ...\"></textarea>\n" +
    "                </div>\n" +
    "                <div class=\"entry\">\n" +
    "                    <label for=\"item-phone\" translate>PHONE_LABEL</label>\n" +
    "                    <input type=\"text\" name=\"item-phone\" ng-model=\"data.phone\" id=\"item-phone\" placeholder=\"Enter Phone number\" value=\"\" />\n" +
    "                </div>\n" +
    "                <div class=\"entry full-width\">\n" +
    "                    <label for=\"item-address\"><span translate>ADDRESS_LABEL</span> <strong ng-show=\"data.page_template=='POI'\">*</strong></label>\n" +
    "                    <input type=\"text\" name=\"aitem-ddress\" ng-model=\"data.address\" id=\"item-address\" placeholder=\"Enter Address\" value=\"\"  />\n" +
    "                </div>\n" +
    "                \n" +
    "                <div class=\"entry full-width\">\n" +
    "                    <label for=\"item-url\"><span translate>URL_LABEL </span><strong ng-show=\"data.page_template=='LINK'\">*</strong></label>\n" +
    "                    <input type=\"text\" name=\"item-url\" ng-model=\"data.website_url\" id=\"item-url\" placeholder=\"Enter URL\" value=\"\"  />\n" +
    "                </div>        \n" +
    "            </fieldset>\n" +
    "            <fieldset class=\"holder right\">\n" +
    "                <div class=\"form-title\">\n" +
    "                    <h3><span translate> TO_CATEGORY_LABEL</span></h3>\n" +
    "                </div>\n" +
    "                <div class=\"entry full-width\">\n" +
    "                    <ul class=\"boxes cms-tree\">\n" +
    "                        <li class=\"category\" ng-repeat=\"category in data.parent_category\">\n" +
    "                            <div class=\"sort\">\n" +
    "                                <span class=\"cms-name\">{{category.name}}</span>\n" +
    "                                <div class=\"cms-delete\">\n" +
    "                                    <a class=\"icons icon-delete\" ng-click=\"deleteParentCategory($index)\">Delete</a>\n" +
    "                                </div>\n" +
    "                            </div>\n" +
    "                        </li>\n" +
    "                        \n" +
    "                        <li class=\"add\">\n" +
    "                            <a  class=\"add-new-button open-modal\" ng-click = \"openAddCategoryModal()\" translate>ADD_CATEGORY_LABEL</a>\n" +
    "                        </li>\n" +
    "                    </ul>\n" +
    "                </div>        \n" +
    "            </fieldset>\n" +
    "            <div class=\"actions float\">\n" +
    "                <button type=\"button\" ng-click=\"goBack()\" class=\"button blank\" translate>CANCEL</button>\n" +
    "                <button type=\"button\" ng-click=\"saveItem()\" class=\"button green\" translate>SAVE_CHANGES</button>  \n" +
    "            </div>\n" +
    "        </form>\n" +
    "    </section>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/contentManagement/adContentManagementSectionDetail.html',
    "<section class=\"content current\" ng-click=\"clearErrorMessage()\">\n" +
    "    <header class=\"content-title\">\n" +
    "        <h2 ng-show=\"!isAddMode\"><span translate>EDIT_SECTION_LABEL</span> <span>{{data.name}}</span></h2>\n" +
    "        <h2 ng-show=\"isAddMode\" translate>ADD_SECTION_LABEL</h2>\n" +
    "        <a ng-click=\"goBack()\" class=\"action back\" translate>BACK</a>\n" +
    "        <a class=\"action remove\" ng-hide=\"!data.id \" ng-click=\"deleteItem(data.id)\" translate>DELETE_SECTION_LABEL</a>\n" +
    "    </header>\n" +
    "    <section class=\"content-scroll\">\n" +
    "        <div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "        <form method=\"post\" action=\"\"  class=\"form float\">\n" +
    "            <fieldset class=\"holder left\">\n" +
    "                <div class=\"form-title\">\n" +
    "                    <h3><span translate>SECTION_LABEL</span> <span translate>DETAILS_LABEL</span></h3>\n" +
    "                    <em class=\"status\"><span translate>MANDATORY_FIELDS_MESSAGE1</span> <strong>*</strong> <span translate>MANDATORY_FIELDS_MESSAGE2</span></em>\n" +
    "                </div>\n" +
    "                <div class=\"entry full-width\">\n" +
    "                    <label for=\"section-availability\"><span translate>AVAILABILITY_STATUS_LABEL</span> <strong>*</strong></label>\n" +
    "                    <div class=\"switch-button\" ng-class=\"{'on': data.status}\">\n" +
    "                        <input name=\"section-availability\" id=\"section-availability\" value=\"1\" type=\"checkbox\" ng-model=\"data.status\" />\n" +
    "                        <span class=\"switch-icon\"></span>\n" +
    "                    </div>\n" +
    "                </div> \n" +
    "                <div class=\"entry\">\n" +
    "                    <label for=\"section-name\"><span translate>SECTION_NAME_LABEL</span> <strong>*</strong></label>\n" +
    "                    <input type=\"text\" name=\"section-name\" id=\"section-name\" placeholder=\"Enter section name\" ng-model=\"data.name\" required />\n" +
    "                </div>\n" +
    "                <div class=\"entry full-width\">\n" +
    "                    <label for=\"section-image\"><span translate>SECTION_ICON_LABEL</span> <span translate>ICON_SPEC</span></label>\n" +
    "                    <div class=\"file-upload with-preview small-preview\">\n" +
    "                        <span class=\"input\">{{fileName}}</span>\n" +
    "                        <input type=\"file\" ng-model=\"data.icon\" accept=\"image/*\" app-filereader name=\"section-image\" id=\"section-image\" />\n" +
    "                        <button type=\"button\" ng-if=\"data.icon != null && data.icon != ''\" class=\"button brand-colors\" translate>REPLACE_ICON_LABEL</button>\n" +
    "                        <button type=\"button\" ng-if=\"data.icon == null || data.icon == ''\" class=\"button brand-colors\" translate>ADD_ICON_LABEL</button>\n" +
    "                    </div>\n" +
    "                    <span class=\"file-preview small-preview\">\n" +
    "                        <img src=\"{{data.icon}}\" alt=\"\" />\n" +
    "                    </span>\n" +
    "                </div>  \n" +
    "                <div class=\"entry full-width\">\n" +
    "                    <label for=\"item-url\"><span translate>URL_LABEL </span></label>\n" +
    "                    <input type=\"text\" name=\"item-url\" ng-model=\"data.website_url\" id=\"item-url\" placeholder=\"Enter URL\" value=\"\"  />\n" +
    "                </div>   \n" +
    "            </fieldset>\n" +
    "            <div class=\"actions float\">\n" +
    "                <button type=\"button\" ng-click=\"goBack()\" class=\"button blank\" translate>CANCEL</button>\n" +
    "                <button type=\"button\" ng-click=\"saveSection()\" class=\"button green\" translate>SAVE_CHANGES</button>  \n" +
    "            </div>\n" +
    "        </form>\n" +
    "    </section>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/contentManagement/adContentManagementTreeView.html',
    "    <div ng-controller=\"ADContentManagementTreeViewCtrl\" >\n" +
    "        <div id=\"sections\" class=\"cms-grid\">\n" +
    "\n" +
    "            <!-- Tree header -->\n" +
    "            <ul class=\"cms-tree-header\">\n" +
    "                <li class=\"cms-name\" translate>NAME_LABEL</li>\n" +
    "                <li class=\"cms-type\" translate>TYPE_LABEL</li>\n" +
    "                <li class=\"cms-date\" translate>LAST_UPDATE_LABEL</li>\n" +
    "                <li class=\"cms-activate\" translate>STATUS_LABEL</li>\n" +
    "                <li class=\"cms-delete\" translate>DELETE_LABEL</li>\n" +
    "            </ul>\n" +
    "\n" +
    "            <!-- Tree content -->\n" +
    "            <ol class=\"cms-tree\">\n" +
    "                <!-- First level: Sections -->\n" +
    "                <li class=\"section branch\" ng-class=\"{'collapsed': !section.isExpanded, 'expanded': section.isExpanded}\"  ng-repeat=\"section in contentList\">\n" +
    "                    <div class=\"sort\">\n" +
    "                        <span class=\"reorder\" ng-click= \"toggleExpansion($index)\"></span>\n" +
    "                        <a ng-click = \"componentSelected(section.component_type, section.id)\" class=\"cms-name\">{{section.name}}</a>\n" +
    "                        <span class=\"cms-type cms-content-type\">{{section.component_type == 'PAGE'? 'ITEM_LABEL' : section.component_type | translate}}</span>\n" +
    "                        <em class=\"cms-date\">{{getFormattedTime(section.updated_at)}}</em>\n" +
    "                        <div class=\"cms-activate\">\n" +
    "                            <div class=\"switch-button\" ng-class=\"{'on':section.status}\">\n" +
    "                                <input name=\"section\" id=\"section\" ng-change=\"saveAvailabilityStatus(section.id, section.status)\" value=\"section\" type=\"checkbox\" ng-model=\"section.status\" />\n" +
    "                                <span class=\"switch-icon\"></span>\n" +
    "                            </div>\n" +
    "                        </div>\n" +
    "                        <div class=\"cms-delete\">\n" +
    "                             <a  class=\"icons icon-delete large-icon\" ng-click=\"deleteItem(section.id)\">Delete</a>\n" +
    "                        </div>\n" +
    "                    </div>\n" +
    "\n" +
    "                    <!-- 1st level category. All deper category levels use same <li class=\"category\"> markup so it's not repeated here. Standard ordered list nesting should be applied. -->\n" +
    "                    <div ng-show=\"section.children.length > 0 && section.isExpanded\" ng-include= \"'/assets/partials/contentManagement/adContentManagementChildView.html'\"></div>\n" +
    "                </li>\n" +
    "                \n" +
    "            </ol>\n" +
    "        </div>\n" +
    "    </div>\n" +
    "   \n" +
    "<!-- </section> -->"
  );


  $templateCache.put('/assets/partials/contentManagement/adDeleteContent.html',
    "<div role=\"dialog\" id=\"modal\" class=\"modal-show\">\n" +
    "\t<div class=\"modal-content cms-content\">\n" +
    "\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t<span class=\"h3 message\" translate>SURE_LABEL</span>\n" +
    "\t\t<span class=\"notice\" ng-show=\"assocatedChildComponents.length > 0\" translate>CONTENT_NOTIFICATION_LABEL </span>\t\t\n" +
    "\t\t<ul class=\"cms-tree boxes\" ng-show=\"assocatedChildComponents.length > 0\">\n" +
    "\t\t\t<li class=\"category\" ng-repeat=\"component in assocatedChildComponents\">\n" +
    "\t\t\t\t<div class=\"sort\">\n" +
    "\t\t\t\t\t<strong class=\"cms-name\" ng-bind=\"component.component_name\"></strong>\n" +
    "\t\t\t\t\t<span class=\"cms-type\" ng-bind=\"component.component_type\"></span>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</li>\n" +
    "\t\t</ul>\n" +
    "\t\t<div class=\"actions\">\n" +
    "\t\t\t<button class=\"button red modal-close\" type=\"button\" ng-click=\"confirmDelete()\" translate>CONFIRM_LABEL\n" +
    "\t\t\t</button><button class=\"button blank modal-close\" type=\"button\" ng-click=\"cancelDelete()\" translate>CANCEL\n" +
    "\t\t</button></div>\n" +
    "\t</div></div>"
  );


  $templateCache.put('/assets/partials/dashboard/adBanner.html',
    "<header role=\"banner\" id=\"global-header\" class=\"float\">\n" +
    "\t<!-- Logo -->\n" +
    "\t<img src=\"/assets/logo.png\" class=\"logo\" alt=\"\">\n" +
    "\n" +
    "\t<form role=\"search\" name=\"search-form\" method=\"get\" id=\"search-form\" class=\"search-form float hidden\" action=\"index.html\">\n" +
    "\t\t<div class=\"entry\">\n" +
    "\t\t\t<a id=\"clear-query\" href=\"#\" class=\"icons icon-clear-search\">Clear query</a>\n" +
    "\t\t\t<button type=\"submit\" name=\"submit\" class=\"icons icon-search\">Search</button>\n" +
    "\t\t\t<input type=\"search\" placeholder=\"Search\" name=\"query\" id=\"query\" autocomplete=\"off\">\n" +
    "\t\t</div>\n" +
    "\t</form>\n" +
    "</header>"
  );


  $templateCache.put('/assets/partials/dashboard/adDashboard.html',
    " <!-- Listing & details holders -->\n" +
    "\n" +
    "   <section id=\"dashboard-hotel\" class=\"content\"  data-drop=\"true\"  jqyoui-droppable=\"{multiple:false, onDrop: 'onDropingMenuItemListing'}\"  ng-model='dropedElementsModel'  style=\"overflow: visible !important;\" data-jqyoui-options=\"{accept: '.in-quick-menu'}\"> <!-- inline overflow style is for drag & drop hiding pblm -->\n" +
    "\n" +
    "      <div ng-include=\"'/assets/partials/common/notification_message.html'\" class=\"error-notification-dashboard\"></div>\n" +
    "      <header class=\"content-title float\">\n" +
    "         <h2>{{selectedMenu.menu_name}} setup</h2>\n" +
    "      </header>\n" +
    "      <section class=\"content-scroll\">\n" +
    "         <ul class=\"dashboard-items float\">\n" +
    "            <li ng-repeat=\"submenu in selectedMenu.components\" >\n" +
    "               <a data-type=\"load-listing\"  \n" +
    "                  class=\"icon-admin-menu {{submenu.icon_class}}\" \n" +
    "\n" +
    "                  data-drag=\"{{bookMarks.length<=7&&!submenu.is_bookmarked}}\"\n" +
    "                  data-jqyoui-options=\"{revert: 'invalid', helper: 'clone',appendTo: 'body'}\" \n" +
    "\n" +
    "                  jqyoui-draggable=\"{index: {{$index}}, placeholder:'keep', animate:'true', onStart: 'onDragStart', onStop: 'onDragStop'}\" \n" +
    "\n" +
    "                  ng-model=\"selectedMenu.components\" \n" +
    "                  ng-click=\"clickedMenuItem($event, submenu.state)\" \n" +
    "                  ng-class=\"{'moved': submenu.is_bookmarked}\">\n" +
    "                  {{submenu.name}}\n" +
    "               </a>\n" +
    "\n" +
    "               <a class=\"text\" data-type=\"load-listing\"  ng-click=\"clickedMenuItem($event, submenu.state)\">{{submenu.name}}</a>\n" +
    "            </li>\n" +
    "         </ul>  \n" +
    "      </section>    \n" +
    "   </section>\n" +
    "\n"
  );


  $templateCache.put('/assets/partials/dashboard/adHeader.html',
    "<!-- Admin header -->\n" +
    "<div id=\"admin-header\" class=\"float\" role=\"navigation\">\n" +
    "\t\n" +
    "   <!-- Switch hotel dropdown : HOTEL ADMIN-->\n" +
    "   <div id=\"change-hotel\" ng-show =\"isHotelAdmin\" class=\"{{hotelListOpen}}\" ng-click=\"isHotelListOpen()\" >\n" +
    "      <h1>{{data.current_hotel}}</h1>\n" +
    "      <dl class=\"dropdown\">\n" +
    "         <dt>Change hotel:</dt>\n" +
    "         <dd ng-repeat=\"hotels in data.hotel_list\">\n" +
    "         \t<a ng-click=\"redirectToHotel(hotels.hotel_id)\">{{hotels.hotel_name}}</a>\n" +
    "         </dd>\n" +
    "      </dl>\n" +
    "   </div>\n" +
    "   \n" +
    "   <!-- For SNT ADMIN header -->\n" +
    "  \t<ul id=\"admin-menu\" class=\"float\" ng-hide =\"isHotelAdmin\" >\n" +
    "\t\t<li>\n" +
    "\t\t\t<a ui-sref=\"admin.snthoteldetails({action:'addfromSetup'})\" class=\"icon-admin-menu icon-new-hotel ui-draggable\">Add new hotel</a>\n" +
    "\t\t</li>\n" +
    "\t\t<li>\n" +
    "\t\t\t<a class=\"icon-admin-menu icon-clone-hotel ui-draggable\">Clone hotel</a>\n" +
    "\t\t</li>\n" +
    "\t</ul>\n" +
    "   \n" +
    "   <!-- Quick navigation -->\n" +
    "\n" +
    "   \n" +
    "   <nav data-place=\"quickmenu\" id=\"quick-menu\" \n" +
    "         ng-class=\"{'has-items': bookMarks.length>0, 'dragging': isDragging==true}\" \n" +
    "         role=\"navigation\" data-drop=\"true\" \n" +
    "\n" +
    "         ng-model='bookMarks' \n" +
    "         jqyoui-droppable=\"{multiple:true, onDrop: 'onDropAtBookmarkArea'}\" \n" +
    "\n" +
    "         data-jqyoui-options=\"{accept: '.icon-admin-menu'}\"\n" +
    "         style=\"overflow: visible !important;min-width:65%;\"> \n" +
    "\n" +
    "   \t<a class=\"icon-admin-menu in-quick-menu {{bookmark.icon_class}}\"  \n" +
    "         style=\"display: block; width: {{bookmark.name.length*10+80}}px;\"\n" +
    "\n" +
    "         ng-repeat=\"bookmark in bookMarks\" \n" +
    "         data-drag=\"true\" \n" +
    "         data-jqyoui-options=\"{revert: 'invalid'}\" \n" +
    "\n" +
    "         jqyoui-draggable=\"{index: {{$index}}, placeholder:false, animate:'true', onStart: 'onDragStart', onStop: 'onDragStop'}\"\n" +
    "\n" +
    "         ng-model=\"bookMarks\" \n" +
    "         ng-hide=\"!bookmark.name\" ng-click=\"clickedMenuItem($event, bookmark.state)\">\n" +
    "\n" +
    "\t\t    {{bookmark.name}}\n" +
    "          \n" +
    "\t   </a>\n" +
    "\n" +
    "   </nav>\t\n" +
    "   \n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/dashboard/adLeftNavbar.html',
    "<!-- NEW CODE -->\n" +
    "<nav id=\"main-menu\" role=\"navigation\" ng-animate=\"animate\" ng-class=\"{'menu-open': menuOpen, 'menu-closing' : !menuOpen}\">\n" +
    "\t<a class=\"nav-toggle\" ng-class=\"{'active': menuOpen}\" ng-click=\"$emit('navToggled')\" >Menu</a>\n" +
    "\t\n" +
    "\t<!--CICO-10216 Seems un necessare check -->\n" +
    "\t<!-- <div id=\"nav\" ng-show=\"isHotelAdmin || isHotelStaff\"> -->\n" +
    "\t<div id=\"nav\">\n" +
    "\t\t<h5 ng-show=\"isHotelAdmin || isHotelStaff\">Menu</h5>\n" +
    "\t\t\n" +
    "\t\t<ul id=\"large-menu\" class=\"main\">\n" +
    "\t\t\t<li ng-repeat=\"menuItem in menu | filter:{hidden:'!'+true}\" ng-hide=\"(isHotelAdmin || isHotelStaff) && menuItem.standAlone && !isStandAlone\" ng-click=\"$emit('updateSubMenu',[$index,menuItem])\" ng-show=\"isHotelAdmin || isHotelStaff\"> \t\t\t\n" +
    "\t\t\t\t<a href=\"{{menuItem.action}}\" class=\"icon-menu {{menuItem.iconClass}}\" ng-class=\"{'open':menuOpen && showSubMenu && menuItem.submenu.length >= 1 && activeSubMenu == menuItem.submenu}\" translate=\"{{menuItem.title}}\"></a>\n" +
    "\t\t\t</li>\n" +
    "\t\t\t<li id=\"settings\" ng-show=\"isHotelAdmin || isHotelStaff\">\n" +
    "\t\t\t\t<a ng-click=\"settingsClicked()\" class=\"icon-menu icon-settings active\">Settings</a>\n" +
    "\t\t\t</li> \n" +
    "\t\t\t<li id=\"sign-out\">\n" +
    "\t\t\t\t<a href=\"/logout\" ng-click=\"toggleDrawerMenu()\" class=\"icon-menu icon-sign-out\">Sign Out</a>\n" +
    "\t\t\t</li>\n" +
    "\t\t</ul>\n" +
    "\n" +
    "\t\t<ul id=\"mobile-menu\" class=\"main\">\n" +
    "\t\t\t<li ng-repeat=\"mobileMenuItem in mobileMenu\" ng-click=\"$emit('updateSubMenu',[$index,menuItem])\" ng-show=\"isHotelAdmin || isHotelStaff\">\n" +
    "\t\t\t\t<a href=\"{{mobileMenuItem.action}}\" class=\"icon-menu {{mobileMenuItem.iconClass}}\" ng-class=\"{'open':menuOpen && showSubMenu && mobileMenuItem.submenu.length >= 1 && activeSubMenu == mobileMenuItem.submenu}\" translate=\"{{mobileMenuItem.title}}\"></a>\n" +
    "\t\t\t</li>\n" +
    "\t\t\t<li id=\"sign-out\">\n" +
    "\t\t\t\t<a href=\"/logout\" ng-click=\"toggleDrawerMenu()\" class=\"icon-menu icon-sign-out\">Sign Out</a>\n" +
    "\t\t\t</li>\n" +
    "\t\t</ul>\n" +
    "\t</div>\n" +
    "\n" +
    "\t<ul id=\"submenu\" class=\"submenu\" ng-class=\"{'active':menuOpen && showSubMenu && activeSubMenu.length > 0}\">\n" +
    "\t\t<li ng-repeat=\"menuItem in activeSubMenu | filter:{hidden:'!'+true}\" ng-hide=\"menuItem.standAlone && !isStandAlone\" ng-click=\"$emit('updateSubMenu',[$index,menuItem])\">\n" +
    "\t\t\t<a href=\"{{menuItem.action}}\" ng-click=\"$emit('navToggled')\" translate=\"{{menuItem.title}}\"></a>\n" +
    "\t\t</li>\n" +
    "\t</ul>\n" +
    "</nav>\n" +
    "\n" +
    "\n" +
    "<!-- OLD CODE -->\n" +
    "<!-- <nav id=\"main-menu\" role=\"navigation\" ng-animate=\"animate\" ng-class=\"{'menu-open': menuOpen, 'menu-closing' : !menuOpen}\">\n" +
    "\t<a id=\"{{menuImage}}\"class=\"nav-toggle updated\" ng-click=\"$emit('navToggled')\"  ng-class=\"{'active': menuOpen}\">Menu\n" +
    "\t\t<span  ng-class=\"{'active': menuOpen}\"></span>\n" +
    "\t</a>\n" +
    "\n" +
    "\t<ul ng-show=\"isHotelAdmin\" for-hotel-admin>\n" +
    "\t\t<li class=\"menu-title\">\n" +
    "\t\t\tMENU\n" +
    "\t\t</li>\n" +
    "\t\t<li ng-repeat=\"menuItem in menu | filter:{hidden:'!'+true}\" ng-click=\"$emit('updateSubMenu',[$index,menuItem])\" ng-class=\"{'active':selectedMenuIndex.length > 0 && (selectedMenuIndex == menuItem.menuIndex || (menuItem.submenu | filter:{menuIndex:selectedMenuIndex}).length > 0), 'last-child' : $last}\" class=\"rover-icon-menu admin-bar {{menuItem.iconClass}}\" ng-hide=\"menuItem.standAlone && !isStandAlone\" > \t\t\t\n" +
    "\t\t\t<a href=\"{{menuItem.action}}\" translate=\"{{menuItem.title}}\">\n" +
    "\t\t\t</a>\n" +
    "\t\t\t<div class=\"pointer\" ng-show=\"menuOpen && showSubMenu && menuItem.submenu.length >= 1 && activeSubMenu == menuItem.submenu\">\n" +
    "\t\t\t</div>\n" +
    "\t\t</li>\n" +
    "\t</ul>\n" +
    "\n" +
    "\t<ul class=\"float-bottom\" ng-show =\"isHotelAdmin\">\n" +
    "\t\t<li class=\"active\">\n" +
    "\t\t\t<label class=\"icon-menu icon-settings active\"></label>\n" +
    "\t\t\t<a ng-click=\"settingsClicked()\">\n" +
    "\t\t\t\tSettings\n" +
    "\t\t\t</a>\n" +
    "\t\t</li> \n" +
    "\n" +
    "\t\t<li >\n" +
    "\t\t\t<a ng-click=\"$emit('navToggled')\" href=\"/logout\">\n" +
    "\t\t\t\t<label class=\"icon-menu icon-sign-out\"></label>\n" +
    "\t\t\t</a>\n" +
    "\t\t\t\t<a ng-click=\"toggleDrawerMenu()\" href=\"/logout\">\n" +
    "\t\t\t\t\tSign Out\n" +
    "\t\t\t\t</a>\n" +
    "\t\t</li>\n" +
    "\t</ul>\n" +
    "\n" +
    "\t<ul ng-hide=\"isHotelAdmin\" for-snt-admin>\n" +
    "\t\t<li id=\"sign-out\">\n" +
    "\t\t\t<a ng-click=\"$emit('navToggled')\" href= \"/logout\">\n" +
    "\t\t\t\t<label class=\"icon-menu icon-sign-out\"></label>\n" +
    "\t\t\t</a>\n" +
    "\t\t\t<a ng-click=\"toggleDrawerMenu()\" href=\"/logout\">\n" +
    "\t\t\t\tSign Out\n" +
    "\t\t\t</a>\n" +
    "\t\t</li>\n" +
    "\t</ul>\n" +
    "\n" +
    "\t<div id=\"submenu\" ng-show=\"menuOpen && \tshowSubMenu && activeSubMenu.length > 0\">\n" +
    "\t\t<ul>\n" +
    "\t\t\t<li class=\"admin\" ng-repeat=\"menuItem in activeSubMenu\" ng-hide=\"menuItem.standAlone && !isStandAlone\" ng-click=\"$emit('updateSubMenu',[$index,menuItem])\">\n" +
    "\t\t\t\t<a href=\"{{menuItem.action}}\" ng-click=\"$emit('navToggled')\" translate=\"{{menuItem.title}}\">\n" +
    "\t\t\t\t</a>\n" +
    "\t\t\t</li>\n" +
    "\t\t</ul>\n" +
    "\t</div>\n" +
    "\n" +
    "\t<ul id=\"submenu\" class=\"submenu\" ng-class=\"{'active':menuOpen && showSubMenu && activeSubMenu.length > 0}\">\n" +
    "\t\t<li ng-repeat=\"menuItem in activeSubMenu\" ng-hide=\"menuItem.standAlone && !isStandAlone\" ng-click=\"$emit('updateSubMenu',[$index,menuItem])\">\n" +
    "\t\t\t<a href=\"{{menuItem.action}}\" ng-click=\"$emit('navToggled')\" translate=\"{{menuItem.title}}\"></a>\n" +
    "\t\t</li>\n" +
    "\t</ul>\n" +
    "</nav> -->"
  );


  $templateCache.put('/assets/partials/departments/adDepartmentsAdd.html',
    "\n" +
    "\t<div style=\"display: block;\" id=\"add-new\" class=\"edit-data\" >\n" +
    "\t\t<div class=\"data-holder\"> \n" +
    "\t\t\t<!-- Edit Department -->\n" +
    "\t\t\t<form class=\"form inline-form float\">\n" +
    "\t\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t\t<h3 translate><span></span> ADD </h3>\n" +
    "\t\t\t\t\t<em class=\"status\" > {{'MANDATORY_FIELDS_MESSAGE1' | translate}} <strong>*</strong> {{'MANDATORY_FIELDS_MESSAGE2' | translate}} </em>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t\t<fieldset class=\"holder left float\">\n" +
    "\t\t\t\t\t<ad-textbox inputtype=\"text\" value=\"departmentData.name\" \n" +
    "\t\t\t\t\t\tlabel = \"{{'NAME' | translate}}\" placeholder = \"{{'DEPARTMENT_NAME_PLACEHOLDER' | translate}}\"  \n" +
    "\t\t\t\t\t\tstyleclass=\"full-width\" required=\"yes\"></ad-textbox>\n" +
    "\t\t\t\t</fieldset>\n" +
    "\t\t\t\t<div class=\"actions float\">\n" +
    "\t\t\t\t\t<button type=\"button\" id=\"cancel\" class=\"button blank edit-data-inline\" ng-click=\"clickCancel()\" translate>\n" +
    "\t\t\t\t\t\tCANCEL\n" +
    "\t\t\t\t\t</button>\n" +
    "\t\t\t\t\t<button type=\"button\" id=\"save\" class=\"button green edit-data-inline\" ng-click=\"saveDepartment()\" translate>\n" +
    "\t\t\t\t\t\tSAVE_CHANGES\n" +
    "\t\t\t\t\t</button>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</form>\n" +
    "\t\t</div>\n" +
    "\t</div>\n"
  );


  $templateCache.put('/assets/partials/departments/adDepartmentsEdit.html',
    "\n" +
    "<div class=\"data-holder\" >\n" +
    "\n" +
    "\t<form class=\"form single-field-form float\">\n" +
    "\t\t <ad-textbox value=\"departmentData.name\" name = \"department-name\" label = \"\" required=\"yes\" placeholder = \"Enter department\" required = \"yes\"></ad-textbox>\n" +
    "\t\t\n" +
    "\t\t<div class=\"actions float\">\n" +
    "\t\t\t<button type=\"button\" id=\"cancel\" class=\"button blank edit-data-inline\" ng-click=\"clickCancel()\" translate>\n" +
    "\t\t\t\tCANCEL\n" +
    "\t\t\t</button>\n" +
    "\t\t\t<button type=\"button\" id=\"update\" class=\"button green edit-data-inline\" ng-click=\"saveDepartment()\" translate>\n" +
    "\t\t\t\tSAVE_CHANGES\n" +
    "\t\t\t</button>\n" +
    "\t\t\t<button type=\"button\" id=\"delete\" class=\"button red edit-data-inline\" ng-click=\"deleteDepartment(currentClickedElement, departmentData.value)\" translate>\n" +
    "\t\t\t\tDELETE\n" +
    "\t\t\t</button>\n" +
    "\t\t</div>\n" +
    "\n" +
    "\t</form>\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/departments/adDepartmentsList.html',
    "<section id=\"replacing-div-first\" class=\"content current\" ng-click='clearErrorMessage()'>\n" +
    "\t\n" +
    "\t<div data-view=\"HotelDepartmentsView\" class=\"inline-edit\">\n" +
    "\t\t<header class=\"content-title float\">\n" +
    "\t\t\t<h2 translate> DEPARTMENTS </h2>\n" +
    "\t\t\t<span class=\"count\"> ({{data.departments.length}}) </span>\n" +
    "\t\t\t<a id=\"add-new-button\" class=\"action add\" ng-click=\"addNew()\" translate>ADD_NEW</a>\n" +
    "\t\t\t\n" +
    "\t\t</header>\n" +
    "\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t<div id=\"new-form-holder\" ng-show=\"currentClickedElement == 'new'\" ng-include=\"'/assets/partials/departments/adDepartmentsAdd.html'\"></div>\t\t\n" +
    "\t\t\t<div id=\"new-form-holder\"></div>\n" +
    "\t\t\t<table id=\"brands\" class=\"grid\">\n" +
    "\t\t\t\t<tbody>\n" +
    "\t\t\t\t\t<tr ng-repeat=\"department in data.departments\" ng-class=\"{'edit-data': currentClickedElement == $index}\"> \n" +
    "\t\t\t\t\t\t<td ng-click=\"editDepartments($index,department.value)\" ng-hide=\"currentClickedElement == $index\" >\n" +
    "\t\t\t\t\t\t\t<a data-item=\"3\" data-colspan=\"2\" class=\"edit-data-inline\">{{department.name}} </a>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td class=\"delete\" ng-hide=\"currentClickedElement == $index\" >\n" +
    "\t\t\t\t\t\t\t<a id=\"3\" class=\"icons icon-delete large-icon delete_item\" ng-click=\"deleteDepartment($index, department.value)\"></a>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td colspan=\"2\" ng-include=\"getTemplateUrl($index,department.value)\"></td>\n" +
    "\t\t\t\t\t</tr>\n" +
    "\t\t\t\t</tbody>\n" +
    "\t\t\t</table>\n" +
    "\t\t</section>\n" +
    "\t</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/deviceMapping/adDeviceMappingDetails.html',
    "\n" +
    "\t<!-- Add new Hotel Loyalty Program -->\n" +
    "\t<div style=\"display: block;\" id=\"add-new\" class=\"edit-data\">\n" +
    "\t\t<div class=\"data-holder\">\n" +
    "\t\t\t<form id=\"add-loyalty\" class=\"form inline-form float\">\n" +
    "\t\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t\t<h3><span>{{addEditTitle }}</span> {{'WORKSTATION' | translate}} </h3>\n" +
    "\t\t\t\t\t<em class=\"status\"> {{'MANDATORY_FIELDS_MESSAGE1' | translate}} <strong>*</strong> {{'MANDATORY_FIELDS_MESSAGE2' | translate}} </em>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t\t<fieldset class=\"holder left float\">\n" +
    "\t\t\t\t\t<ad-textbox inputtype=\"text\" value=\"mapping.name\" \n" +
    "\t\t\t\t\t\tlabel = \"{{'STATION_NAME' | translate}}\" placeholder = \"{{'STATION_NAME'| translate}}\"  \n" +
    "\t\t\t\t\t\tstyleclass=\"full-width\" required=\"yes\"></ad-textbox>\n" +
    "\t\t\t\t\t<ad-textbox inputtype=\"text\" value=\"mapping.station_identifier\" \n" +
    "\t\t\t\t\t\tlabel = \"{{'STATION_ID' | translate}}\" placeholder = \"{{'STATION_ID'| translate}}\"  \n" +
    "\t\t\t\t\t\tstyleclass=\"full-width\" required=\"yes\"></ad-textbox>\n" +
    "\t\t\t\t</fieldset>\n" +
    "\t\t\t\t\n" +
    "\t\t\t\t<div class=\"actions float\">\n" +
    "\t\t\t\t\t<button type=\"button\" id=\"cancel\" class=\"button blank add-data-inline\" ng-click=\"clickCancel()\" translate>\n" +
    "\t\t\t\t\t\tCANCEL\n" +
    "\t\t\t\t\t</button>\n" +
    "\t\t\t\t\t<button type=\"button\" id=\"save\" class=\"button green\" ng-click=\"saveMapping()\" translate>\n" +
    "\t\t\t\t\t\tSAVE_CHANGES\n" +
    "\t\t\t\t\t</button>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</form>\n" +
    "\t\t</div>\n" +
    "\t</div>\n"
  );


  $templateCache.put('/assets/partials/deviceMapping/adDeviceMappingList.html',
    "<section id=\"replacing-div-first\" class=\"content current\" ng-click=\"clearErrorMessage()\">\n" +
    "\t<div class=\"inline-edit\">\n" +
    "\t\t<header class=\"content-title float\">\n" +
    "\t\t\t<h2 translate> WORKSTATIONS </h2>\n" +
    "\t\t\t<span class=\"count\"> (\n" +
    "\t\t\t\t{{data.length}}\n" +
    "\t\t\t\t) </span>\n" +
    "\t\t\t<a id=\"add-new-button\" class=\"action add\" ng-click=\"addNewDeviceMapping()\" translate>ADD_NEW</a>\n" +
    "\t\t</header>\n" +
    "\t\t <section class=\"content-scroll\">\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t\n" +
    "\t\t\t<div id=\"new-form-holder\" ng-show=\"currentClickedElement == 'new'\" ng-include=\"'/assets/partials/deviceMapping/adDeviceMappingDetails.html'\"></div>\n" +
    "\t\t\t\t\n" +
    "\t\t\t<div id=\"new-form-holder\"></div>\n" +
    "\t\t\t<span class=\"count-show\">Show</span>\n" +
    "\t\t\t\t<div class=\"select table-count rates-table-count\">\n" +
    "\t\t\t\t\t<select ng-model=\"displyCount\"\tng-options=\"opt for opt in displayCountList\"></select>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t\t<span class=\"count-entries\">entries</span>\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t<div class=\"entry table-search\">\n" +
    "\t\t    </div>\n" +
    "\t\t\t<table id=\"loyalty\" class=\"grid\" ng-table=\"tableParams\" template-pagination=\"custom/pager\">\n" +
    "\t\t\t\t<tbody>\n" +
    "\t\t\t\t\t<tr ng-repeat=\"workStations in data\">\n" +
    "\t\t\t\t\t\t<td data-title=\"'Workstation Name'\" header-class=\"width-50\" ng-click=\"editDeviceMapping($index, workStations.id)\" ng-hide=\"currentClickedElement == $index\">\n" +
    "\t\t\t\t\t\t\t<a class=\"edit-data-inline\">{{workStations.name}} </a>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td data-title=\"'Workstation ID'\" header-class=\"width-40\" ng-hide=\"currentClickedElement == $index\">\n" +
    "\t\t\t\t\t\t\t{{workStations.station_identifier}}\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td data-title=\"'Action'\" header-class=\"width-10\" class=\"delete\" ng-hide=\"currentClickedElement == $index\" >\n" +
    "\t\t\t\t\t\t\t<a id=\"3\" class=\"icons icon-delete large-icon delete_item\" ng-click=\"deleteDeviceMapping($index, workStations.id)\"></a>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td colspan=\"3\" ng-include=\"getTemplateUrl($index,workStations.id)\" ng-show=\"currentClickedElement == $index && isEditMode\"></td>\n" +
    "\t\t\t\t\t</tr>\n" +
    "\t\t\t\t</tbody>\n" +
    "\t\t\t</table>\n" +
    "\t\t</section> \n" +
    "\t\t<!--Custom pagination footer goes here-->\n" +
    "\t\t<script type=\"text/ng-template\" id=\"custom/pager\">\n" +
    "\t\t\t<div class = \"pager\">\n" +
    "\t\t\t\t<span ng-show=\"totalCount>0\">Showing {{startCount}} to {{endCount}} of {{totalCount}} items</span>\n" +
    "\t\t\t\t<span ng-show=\"totalCount==0\">Showing 0 items</span>\n" +
    "\t\t\t\t<ul class=\"ng-cloak\">\n" +
    "\t              \t<li ng-repeat=\"page in pages\"\n" +
    "\t\t                ng-class=\"{'previous': page.type == 'prev', 'next': page.type == 'next'}\"\n" +
    "\t\t                ng-show=\"page.type == 'prev' || page.type == 'next'\" ng-switch=\"page.type\">\n" +
    "\t\n" +
    "\t\t                <a ng-switch-when=\"prev\" ng-click=\"params.page(1)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">First</a>\n" +
    "\t\t                <a ng-switch-when=\"prev\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">Previous</a>\n" +
    "\t\t                <a ng-switch-when=\"prev\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">{{page.number}}</a>\n" +
    "\t\t                \n" +
    "\t\t                <a ng-switch-when=\"next\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">{{page.number}}</a>\n" +
    "\t\t                <a ng-switch-when=\"next\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">Next</a>\n" +
    "\t\t                <a ng-switch-when=\"next\" ng-click=\"params.page(totalPage)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">Last</a>\n" +
    "\t\t          \t</li>\n" +
    "\t            </ul>\n" +
    "\t        </div>\n" +
    "\t\t</script>\n" +
    "\t\t<!--end-->\n" +
    "\t</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/earlyCheckin/adEarlyCheckin.html',
    "<section id=\"replacing-div-first\" class=\"content current\" ng-click=\"\">\n" +
    "\t<div data-view=\"EarlyCheckinView\">\n" +
    "\t\t<section>\n" +
    "\t\t\t<header class=\"content-title float\">\n" +
    "\t\t\t\t<h2 translate>EARLY_CHECKIN_UPSELL</h2>\n" +
    "\t\t\t\t<a id=\"go_back\" data-type=\"load-details\" class=\"action back\" ng-click=\"goBackToPreviousState()\" translate>BACK</a>\n" +
    "\t\t\t</header>\n" +
    "\t\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t\t<form name=\"upsell-early-checkin\" method=\"post\" id=\"upsell-early-checkin\" class=\"form float\" action=\"\">\n" +
    "\t\t\t\t\t<div class=\"form-title full-width\">\n" +
    "\t\t\t\t\t\t<h3><span translate>EARLY_CHECKIN_GENERAL</span> </h3>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t<fieldset class=\"holder left\">\n" +
    "\t\t\t\t\t\t<div></div>\n" +
    "\n" +
    "\t\t\t\t\t\t<!-- Switch -->\n" +
    "\t\t\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t\t\t<label for=\"early-checkin-upsell\" translate>EARLY_CHECKIN_UPSELL</label>\n" +
    "\t\t\t\t\t\t\t<div id=\"div-early-checkin-upsell\" class=\"switch-button single\" ng-class=\"{ on : upsellData.is_early_checkin_allowed}\"  ng-click=\"switchClicked()\">\n" +
    "\t\t\t\t\t\t\t\t<input type=\"checkbox\" value=\"10\" name=\"late-checkout-upsell\" id=\"late-checkout-upsell\">\n" +
    "\t\t\t\t\t\t\t\t<span class=\"switch-icon\"></span>\n" +
    "\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t</fieldset>\n" +
    "\t\t\t\t\t<fieldset class=\"holder right\">\t\n" +
    "\t\t\t\t\t\t<!-- charge code -->\n" +
    "\t\t\t\t\t\t<ad-dropdown label=\"{{'CHARGE_CODE' | translate}}\" label-in-drop-down=\"{{'CHARGE_CODE' | translate}}\" list=\"charge_codes\" selected-Id='upsellData.early_checkin_charge_code' selbox-class='placeholder'></ad-dropdown>\n" +
    "\t\t\t\t\t</fieldset>\t\t\t\t\t\n" +
    "\t\t\t\t\t\t\n" +
    "\n" +
    "\t\t\t\t\t<div class=\"form-title full-width\">\n" +
    "\t\t\t\t\t\t<h3><span translate>EARLY_CHECKIN_UPSELL_WINDOWS</span> </h3>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t<fieldset class='holder column full-width'>\n" +
    "\t\t\t\t\t\t<div></div>\n" +
    "\t\t\t\t\t\t<div class=\"entry early_checkin_upsell\">\n" +
    "\t\t\t\t\t\t\t<label translate> EARLY_CHECKIN_START_TIME </label>\n" +
    "\t\t\t\t\t\t\t<div class=\"entry full-width float\">\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t\t<select ng-options=\"hour for hour  in hours\" ng-model=\"upsellWindows[0].hours\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<option  value=\"\" translate>HH</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t\t<select ng-options=\"minute for minute  in minutes\" ng-model=\"upsellWindows[0].minutes\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<option  value=\"\" translate>MM</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\t\t\t\t\t\t\t\t\t<select name=\"primetime\" ng-model = \"upsellWindows[0].meridiem\" class=\"styled\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<option value=\"AM\" translate>AM</option>\n" +
    "\t\t\t\t\t\t\t\t\t\t<option value=\"PM\" selected=\"\" translate>PM</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t\t<ad-textbox value=\"upsellWindows[0].charge\"   label = \"{{'EARLY_CHECKIN_CHARGE' | translate}} [{{upsellData.hotel_currency}}]\" placeholder = \"Enter charge\" styleclass=\"early_checkin_upsell\"></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t\t\t<ad-dropdown label=\"{{'EARLY_CHECKIN_ADDON' | translate}}\" label-in-drop-down=\"{{'EARLY_CHECKIN_ADDON' | translate}}\" list=\"addons\" selected-Id='upsellWindows[0].addon_id' required='no' selbox-class='placeholder' div-class=\"early_checkin_upsell\" options = \"{'showOptionsIf': isAddonAvailable}\"></ad-dropdown>\n" +
    "\n" +
    "\t\t\t\t\t\t<div class=\"entry early_checkin_upsell\">\n" +
    "\t\t\t\t\t\t\t<label translate> EARLY_CHECKIN_START_TIME </label>\n" +
    "\t\t\t\t\t\t\t<div class=\"entry full-width float\">\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t\t<select ng-options=\"hour for hour  in hours\" ng-model=\"upsellWindows[1].hours\" >\n" +
    "\t\t\t\t\t\t\t\t\t\t<option  value=\"\" translate>HH</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t\t<select ng-options=\"minute for minute  in minutes\" ng-model=\"upsellWindows[1].minutes\" >\n" +
    "\t\t\t\t\t\t\t\t\t\t<option  value=\"\" translate>MM</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\t\t\t\t\t\t\t\t\t<select name=\"primetime\" class=\"styled\" ng-model=\"upsellWindows[1].meridiem\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<option value=\"AM\" translate>AM</option>\n" +
    "\t\t\t\t\t\t\t\t\t\t<option value=\"PM\" selected=\"\" translate>PM</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t<ad-textbox value=\"upsellWindows[1].charge\"   label = \"{{'EARLY_CHECKIN_CHARGE' | translate}} [{{upsellData.hotel_currency}}]\" placeholder = \"Enter charge\" disabled=\"disableSecondOption\" styleclass=\"early_checkin_upsell\"></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t\t\t<ad-dropdown label=\"{{'EARLY_CHECKIN_ADDON' | translate}}\" label-in-drop-down=\"{{'EARLY_CHECKIN_ADDON' | translate}}\" list=\"addons\" selected-Id='upsellWindows[1].addon_id' required='no' selbox-class='placeholder' div-class=\"early_checkin_upsell\" options = \"{'showOptionsIf': isAddonAvailable}\"></ad-dropdown>\n" +
    "\n" +
    "\t\t\t\t\t\t<div class=\"entry early_checkin_upsell\">\n" +
    "\t\t\t\t\t\t\t<label translate> EARLY_CHECKIN_START_TIME </label>\n" +
    "\t\t\t\t\t\t\t<div class=\"entry full-width float\">\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\t\t\t\t\t\t\t\t\t<select ng-options=\"hour for hour  in hours\" ng-model=\"upsellWindows[2].hours\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<option  value=\"\" translate >HH</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\t\t\t\t\t\t\t\t\t<select ng-options=\"minute for minute  in minutes\" ng-model=\"upsellWindows[2].minutes\" ng-disabled=\"disableThirdOption\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<option  value=\"\" translate >MM</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\t\t\t\t\t\t\t\t\t<select name=\"primetime\" class=\"styled\" ng-model=\"upsellWindows[2].meridiem\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<option value=\"AM\" translate>AM</option>\n" +
    "\t\t\t\t\t\t\t\t\t\t<option value=\"PM\" selected=\"\" translate>PM</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t\t<ad-textbox value=\"upsellWindows[2].charge\"   label = \"{{'EARLY_CHECKIN_CHARGE' | translate}} [{{upsellData.hotel_currency}}]\" placeholder = \"Enter charge\" disabled=\"disableThirdOption\" styleclass=\"early_checkin_upsell\" ></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t\t\t<ad-dropdown label=\"{{'EARLY_CHECKIN_ADDON' | translate}}\" label-in-drop-down=\"{{'EARLY_CHECKIN_ADDON' | translate}}\" list=\"addons\" selected-Id='upsellWindows[2].addon_id' required='no' selbox-class='placeholder' div-class=\"early_checkin_upsell\" options = \"{'showOptionsIf': isAddonAvailable}\"></ad-dropdown>\n" +
    "\n" +
    "\t\t\t\t\t\t<ad-textbox value=\"upsellData.number_of_early_checkins_per_day\"   label = \"{{'NUMBER_OF_EARLY_CHECKINS_PER_DAY' | translate}}\" placeholder = \"{{'TYPE_NUMBER' | translate}}\" ></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t\t</fieldset>\n" +
    "                    <div class=\"form-title full-width\">\n" +
    "\t\t\t\t\t\t<h3><span translate>EARLY_CHECKIN_BY_RATE</span> </h3>\n" +
    "\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t\t\t<label translate> EARLY_CHECKIN_START_TIME </label>\n" +
    "\t\t\t\t\t\t\t<div class=\"entry full-width float\">\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\t\t\t\t\t\t\t\t\t<select ng-options=\"hour for hour  in hours\" ng-model=\"upsell_rate.hours\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<option  value=\"\" translate >HH</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\t\t\t\t\t\t\t\t\t<select ng-options=\"minute for minute  in minutes\" ng-model=\"upsell_rate.minutes\" >\n" +
    "\t\t\t\t\t\t\t\t\t\t<option  value=\"\" translate >MM</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\t\t\t\t\t\t\t\t\t<select name=\"primetime\" class=\"styled\" ng-model=\"upsell_rate.meridiem\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<option value=\"AM\" translate>AM</option>\n" +
    "\t\t\t\t\t\t\t\t\t\t<option value=\"PM\" selected=\"\" translate>PM</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t<fieldset class='holder column full-width'>\n" +
    "\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t<ad-dropdown label-in-drop-down=\"{{'SELECT_RATE' | translate}}\" list=\"rates\" selected-id='upsell_rate.selected_rate_id' selbox-class=\"placeholder\" options = \"{'showOptionsIf': isRateAvailable}\"></ad-dropdown>\n" +
    "\t\t\n" +
    "\t\t\t\t\t\t<div class='entry'>\n" +
    "\t\t\t\t\t\t\t<div class='early_checkin_add_rates'>\n" +
    "\t\t\t\t\t\t\t\t<button class='button green' id='add-room-type' ng-click=\"clickAddRoomType()\" translate>\n" +
    "\t\t\t\t\t\t\t\t\tADD_RATE\n" +
    "\t\t\t\t\t\t\t\t</button>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t<div class='entry full-width' id='room-type-header'>\n" +
    "\t\t\t\t\t\t\t<div class='entry' ng-show=\"isRateSelected\">\n" +
    "\t\t\t\t\t\t\t\t<label> <h4 translate>RATES</h4> </label>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t<!-- <div class='entry' ng-show=\"upsellData.isRoomTypesSelectedFlag\">\n" +
    "\t\t\t\t\t\t\t\t<label> <h4 translate>MAX_PER_DAY </h4> </label>\n" +
    "\t\t\t\t\t\t\t</div> -->\n" +
    "\t\t\t\t\t\t\t<div id='room-type-details' ng-repeat=\"rate in upsellData.early_checkin_rates\">\n" +
    "\t\t\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t\t\t<div class=\"entry full-width room-type-details\" >\n" +
    "\t\t\t\t\t\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<span class=\"align-text-center\"> {{rate.name}} </span>\n" +
    "\t\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<!-- <span class=\"entry\">\n" +
    "\t\t\t\t\t\t\t\t\t\t\t<ad-textbox value=\"roomType.max_late_checkouts\" inputtype=\"number\"></ad-textbox>\n" +
    "\t\t\t\t\t\t\t\t\t\t</span> -->\n" +
    "\t\t\t\t\t\t\t\t\t\t<span class=\"entry\">\n" +
    "\t\t\t\t\t\t\t\t\t\t\t<a class=\"icons icon-delete large-icon align-text-center\" ng-click=\"deleteRate(rate.id,rate.name)\"></a>\n" +
    "\t\t\t\t\t\t\t\t\t\t</span>\n" +
    "\t\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t</fieldset>\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t\t<div class=\"actions float\">\n" +
    "\t\t\t\t\t\t<button type=\"button\" id=\"cancel\" class=\"button blank\" ng-click=\"goBackToPreviousState()\" translate>\n" +
    "\t\t\t\t\t\t\tCANCEL\n" +
    "\t\t\t\t\t\t</button>\n" +
    "\t\t\t\t\t\t<button type=\"button\" id=\"save\" class=\"button green\" ng-click=\"saveClick()\" translate>\n" +
    "\t\t\t\t\t\t\tSAVE_CHANGES\n" +
    "\t\t\t\t\t\t</button>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</form>\n" +
    "\t\t\t</section>\n" +
    "\t\t</section>\n" +
    "\t</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/emailList/adCheckinCheckoutemail.html',
    "\t<section id=\"replacing-div-second\" class=\"content current\" style=\"display: block;\" ng-hide=\"isLoading\" ng-click=\"clearErrorMessage()\"><div data-view=\"CheckoutGuests\">\n" +
    "\t\t<header class=\"content-title float\">\n" +
    "\t\t\t<h2>{{emailTitle}}</h2>\n" +
    "\t\t\t<a id=\"go_back\" data-type=\"load-details\" class=\"action back\" ng-click=\"backActionFromEmail()\" translate>BACK_TO_SETUP</a>\n" +
    "\t\t</header>\n" +
    "\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_success_message.html'\"></div>\n" +
    "\t\t\t<span class=\"count-show\">Show</span>\n" +
    "\t\t\t<div class=\"select table-count rates-table-count\">\n" +
    "\t\t\t\t<select ng-model=\"displyCount\"\tng-options=\"opt for opt in displayCountList\"></select>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<span class=\"count-entries\">entries</span>\n" +
    "\t\t\t\t\n" +
    "\t\t\t<div class=\"entry table-search\">\n" +
    "\t\t\t\t<span class=\"search-text\">Search</span>\n" +
    "\t\t\t\t<span class=\"icons icon-search\" name=\"submit\" type=\"submit\"></span>\n" +
    "\t\t\t\t<input placeholder=\"\" autocomplete=\"off\" type=\"text\" ad-delay-textbox ng-model=\"searchTerm\" delay=\"1000\" function-to-fire=\"searchEntered\" />\n" +
    "\t\t    </div>\n" +
    "\t\t\t<form name=\"zest-checkout-send-email\" method=\"post\" id=\"zest-checkout-send-email\" class=\"form with-grid float\" action=\"\">\n" +
    "\t\t\t\t\n" +
    "\t\t\t\t<table id=\"guests\" class=\"grid datatable table\" ng-table=\"tableParams\" template-pagination=\"custom/pager\">\n" +
    "\t\t\t\t\t<tr ng-repeat=\"emailData in $data\">\n" +
    "\t\t\t\t\t\t<td header-class=\"width-5 padding-checkbox\" style=\"text-align: left; \" header=\"'ng-table/headers/checkbox.html'\">\n" +
    "\t\t\t\t\t\t\t<ad-checkbox is-checked=\"emailData.is_selected\" ></ad-checkbox>\t\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td header-class=\"width-30\" data-title=\"'Name'\" sortable=\"'first_name'\"><a class=\"title\">{{emailData.first_name}}&nbsp;{{emailData.last_name}} </a></td>\n" +
    "\t\t\t\t\t\t<td header-class=\"width-30\" data-title=\"'guest Email'\" sortable=\"'email'\"> {{emailData.email}}  </td>\n" +
    "\t\t\t\t\t\t<td header-class=\"width-20\" data-title=\"'Room'\" sortable=\"'room_number'\"><span class=\"number\"> {{emailData.room_number}} </span></td>\n" +
    "\t\t\t\t\t\t\n" +
    "\t\t\t\t\t</tr>\n" +
    "\n" +
    "\t\t\t\t</table>\n" +
    "\t\t\t\t<!--Custom pagination footer goes here-->\n" +
    "\t\t<script type=\"text/ng-template\" id=\"custom/pager\">\n" +
    "\t\t\t<div class = \"pager\">\n" +
    "\t\t\t\t<span ng-show=\"totalCount>0\">Showing {{startCount}} to {{endCount}} of {{totalCount}} items</span>\n" +
    "\t\t\t\t<span ng-show=\"totalCount==0\">Showing 0 items</span>\n" +
    "\t\t\t\t<ul class=\"ng-cloak\">\n" +
    "\t              \t<li ng-repeat=\"page in pages\"\n" +
    "\t\t                ng-class=\"{'previous': page.type == 'prev', 'next': page.type == 'next'}\"\n" +
    "\t\t                ng-show=\"page.type == 'prev' || page.type == 'next'\" ng-switch=\"page.type\">\n" +
    "\t\n" +
    "\t\t                <a ng-switch-when=\"prev\" ng-click=\"params.page(1)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">First</a>\n" +
    "\t\t                <a ng-switch-when=\"prev\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">Previous</a>\n" +
    "\t\t                <a ng-switch-when=\"prev\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">{{page.number}}</a>\n" +
    "\t\t                \n" +
    "\t\t                <a ng-switch-when=\"next\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">{{page.number}}</a>\n" +
    "\t\t                <a ng-switch-when=\"next\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">Next</a>\n" +
    "\t\t                <a ng-switch-when=\"next\" ng-click=\"params.page(totalPage)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">Last</a>\n" +
    "\t\t          \t</li>\n" +
    "\t            </ul>\n" +
    "\t        </div>\n" +
    "\t\t</script>\n" +
    "\t\t<!--end-->\n" +
    "\n" +
    "\t\t\t\t<script type=\"text/ng-template\" id=\"ng-table/headers/checkbox.html\">\n" +
    "\t\t\t\t\n" +
    "\t\t\t<div class=\"entry radio-check\">\n" +
    "\t\t\t<label class=\"checkbox\" ng-class=\"{'checked': isAllOptionsSelected()}\">\n" +
    "\t\t\t<span class=\"icon-form icon-checkbox\" ng-class=\"{'checked': isAllOptionsSelected()}\"></span>\t\n" +
    "\t\t\t<input type=\"checkbox\" ng-checked=\"isAllOptionsSelected()\" ng-click=\"toggleAllOptions()\">\n" +
    "\t\t\t<strong ng-show = \"required=='yes'\">*</strong>\n" +
    "\t\t    </label>\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t</script>\n" +
    "\n" +
    "\n" +
    "\t\t\t\t<div class=\"actions float\">\n" +
    "\t\t\t\t\t<button type=\"button\" ng-click=\"backActionFromEmail()\" class=\"button blank\" translate>CANCEL</button>\n" +
    "\t\t\t\t\t<button type=\"button\" ng-disabled=\"disableSave\" class=\"button grey\" ng-show=\"disableSave\">{{saveButtonTitle}}</button>\n" +
    "\n" +
    "\t\t\t\t<button type=\"button\" ng-disabled=\"disableSave\" ng-click=\"sendMailClicked()\" class=\"button blue\" ng-hide=\"disableSave\">{{saveButtonTitle}}</button>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</form>\n" +
    "\t\t</section>\n" +
    "\t</div>\n" +
    "\t</section>"
  );


  $templateCache.put('/assets/partials/externalPms/adExternalPmsConnectivity.html',
    "<section class=\"content current\">\n" +
    "\t<div >\n" +
    "\t\t<header class=\"content-title float\">\n" +
    "\t\t\t<h2>OWS Connectivity Setup</h2>\n" +
    "\t\t\t<a id=\"go_back\" data-type=\"load-details\" class=\"action back\" ng-click=\"goBackToPreviousState()\">Back</a>\n" +
    "\t\t</header>\n" +
    "\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_success_message.html'\"></div>\n" +
    "\t\t\t<form style=\"overflow-y:auto;\" name=\"edit-guest-review\" method=\"post\" class=\"form float\">\n" +
    "\t\t\t\t<fieldset class=\"holder left\">\n" +
    "\t\t\t\t\t<ad-textbox value=\"externalPmsConnectivityData.pms_access_url\" styleclass=\"full-width\" name = \"pms-access-url\" id = \"pms-access-url\" label = \"Access Url\" placeholder = \"Enter access url\" required = \"yes\" ></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t\t<ad-textbox value=\"externalPmsConnectivityData.pms_channel_code\" styleclass=\"full-width\" name = \"pms-channel-code\" id = \"pms-channel-code\" label = \"Pms channel code \" placeholder = \"Enter pms cahnnel code\" required = \"yes\" ></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t\t<ad-textbox value=\"externalPmsConnectivityData.pms_user_name\" styleclass=\"full-width\" name = \"pms-user-name\" id = \"pms-user-name\" label = \"PMS Username\" placeholder = \"Enter pms user name\" required = \"yes\" ></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t\t<ad-textbox value=\"externalPmsConnectivityData.pms_timeout\" styleclass=\"full-width\" name = \"pms-timeout\" id = \"pms-timeout\" label = \"PMS Timeout [Seconds]\" placeholder = \"Enter pms timeout\"  ></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t</fieldset>\n" +
    "\t\t\t\t<fieldset class=\"holder right\">\n" +
    "\t\t\t\t\t<ad-textbox inputtype=\"password\" value=\"externalPmsConnectivityData.pms_user_pwd\" styleclass=\"full-width\" name = \"pms-password\" id = \"pms-password\" label = \"PMS password \" placeholder = \"Enter pms password \" required = \"yes\" ></ad-textbox>\n" +
    "\t\t\t\t\t<ad-textbox value=\"externalPmsConnectivityData.pms_hotel_code\" styleclass=\"full-width\" name = \"pms-hotel-code\" id = \"pms-hotel-code\" label = \"Hotel Code \" placeholder = \"Enter Hotel Code\" required = \"yes\" ></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t\t<ad-textbox value=\"externalPmsConnectivityData.pms_chain_code\" styleclass=\"full-width\" name = \"pms-chain-code\" id = \"pms-chain-code\" label = \"Chain Code \" placeholder = \"Enter  Chain Code\" required = \"yes\" ></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t</fieldset>\n" +
    "\t\t\t\t<div class=\"actions float\">\n" +
    "\t\t\t\t\t<button type=\"button\" class=\"button blank add-data-inline\" ng-click=\"goBackToPreviousState()\">\n" +
    "\t\t\t\t\t\tCancel\n" +
    "\t\t\t\t\t</button>\n" +
    "\t\t\t\t\t<button type=\"button\" class=\"button green\" ng-click=\"saveConnectivity()\">\n" +
    "\t\t\t\t\t\tSave changes\n" +
    "\t\t\t\t\t</button>\n" +
    "\t\t\t\t\t<button type=\"button\" class=\"button blue\" ng-click=\"testConnectivity()\">\n" +
    "\t\t\t\t\t\tTest Connectivity\n" +
    "\t\t\t\t\t</button>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</form>\n" +
    "\t\t</section>\n" +
    "\t</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/floorSetups/adFloorDetails.html',
    "<div class=\"data-holder\">\n" +
    "\t<form room_type_id=\"1\" id=\"edit-room-type\" class=\"form inline-form float\">\n" +
    "\t\t<div class=\"form-title\">\n" +
    "\t\t\t<h3 ng-show=\"!isAddMode\"><span translate>EDIT</span> {{floorListData.floortitle}} </h3>\n" +
    "\t\t\t<h3 ng-show=\"isAddMode\"><span translate>ADD</span> </h3>\n" +
    "\t\t\t<em class=\"status\"> <span translate>MANDATORY_FIELDS_MESSAGE1</span> <strong>*</strong> <span translate>MANDATORY_FIELDS_MESSAGE2</span> </em>\n" +
    "\t\t</div>\n" +
    "\t\t\n" +
    "\t\t<fieldset class=\"holder left float\">\n" +
    "\t\t\t\n" +
    "\t\t\t<!-- <ad-textbox value=\"floorListData.floor_number\" name = \"room-type-code\" id = \"room-type-code\" label = \"Floor No\" placeholder = \"Enter Floor No\" required = \"yes\" ></ad-textbox> -->\n" +
    "\n" +
    "\t\t\t<ad-dropdown div-class='full-width' label-in-drop-down=\"{{ 'SELECT_FLOOR' | translate }}\"label=\"{{ 'FLOOR_NO' | translate }}\" sel-class='placeholder'  list='floors' required='yes' selected-Id='floorListData.floor_number'></ad-dropdown>\n" +
    "\t\t\t\n" +
    "\t\t</fieldset>\n" +
    "\t\t<fieldset class=\"holder right float\">\n" +
    "\t\t\t\n" +
    "            <ad-textbox styleclass=\"full-width\" value=\"floorListData.description\" name = \"room-type-name\" id = \"room-type-name\" label = \"{{ 'FLOOR_DESCRIPTION' | translate }}\" placeholder = \"Enter Description\" ></ad-textbox>\n" +
    "\t\t</fieldset> \n" +
    "\t\t\n" +
    "\t\t<div class=\"actions float\">\n" +
    "\t\t\t<button type=\"button\" id=\"cancel\" class=\"button blank add-data-inline\" ng-click=\"clickCancel()\" translate>\n" +
    "\t\t\t\tCANCEL\n" +
    "\t\t\t</button>\n" +
    "\t\t\t<button type=\"button\" like-type=\"common\" id=\"update\" ng-class=\"{ 'green' : validate() }\" class=\"button  ng-binding\" ng-disabled=\"!validate()\" ng-click=\"saveFloor()\" translate>\n" +
    "\t\t\t\tSAVE_CHANGES\n" +
    "\t\t\t</button>\n" +
    "\t\t</div>\n" +
    "\t</form>\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/floorSetups/adFloorSetupList.html',
    "<section class=\"content current\" ng-click='clearErrorMessage()'>\n" +
    "\t\n" +
    "\t<div data-view=\"HotelRoomTypesView\">\n" +
    "\t\t<header class=\"content-title float\">\n" +
    "\t\t\t<h2 translate> FLOORS </h2>\n" +
    "\t\t\t<span class=\"count\"> ({{data.floors.length}}) </span>\n" +
    "\t\t\t<a id=\"import-rooms\" class=\"action add\" ng-click=\"addNewFloor()\"  translate>ADD_NEW</a>\n" +
    "\t\t</header>\n" +
    "\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t<div id=\"new-form-holder\"></div>\n" +
    "\t\t\t<span class=\"grid\" ng-show=\"isAddMode\" ng-include=\"getTemplateUrl(-1)\"></span>\n" +
    "\t\t\t<table id=\"brands\" class=\"grid ng-table\" ng-table=\"tableParams\">\n" +
    "\t\t\t\t<thead>\n" +
    "\t\t\t\t\t<tr>\n" +
    "\t\t\t\t\t\t \n" +
    "\t           <th class=\"sortable\" ng-class=\"{\n" +
    "\t                    'sort-asc': tableParams.isSortBy('floor_number', 'asc'),\n" +
    "\t                    'sort-desc': tableParams.isSortBy('floor_number', 'desc')\n" +
    "\t                  }\"\n" +
    "\t                    ng-click=\"tableParams.sorting({'floor_number' : tableParams.isSortBy('floor_number', 'asc') ? 'desc' : 'asc'})\" rowspan=\"2\">\n" +
    "\t                    <div><i class=\"glyphicon glyphicon-user\"></i> <span translate>FLOOR_NO</span></div>\n" +
    "\t                </th>\n" +
    "\t                <th class=\"sortable\" ng-class=\"{\n" +
    "\t                    'sort-asc': tableParams.isSortBy('description', 'asc'),\n" +
    "\t                    'sort-desc': tableParams.isSortBy('description', 'desc')\n" +
    "\t                  }\"\n" +
    "\t                    ng-click=\"tableParams.sorting({'description' : tableParams.isSortBy('description', 'asc') ? 'desc' : 'asc'})\" rowspan=\"2\">\n" +
    "\t                    <div><i class=\"glyphicon glyphicon-user\"></i> <span translate>FLOOR_DESCRIPTION</span></div>\n" +
    "\t                </th>\t\t\t\t\t\n" +
    "\t\t\t\t\t\t<th class=\"width-10\" translate> DELETE</th>\n" +
    "\n" +
    "\t\t\t\t\t</tr>\n" +
    "\t\t\t\t</thead>\n" +
    "\t\t\t\t<tbody>\n" +
    "\t\t\t\t\t<tr ng-repeat=\"floor in $data\" > \n" +
    "\t\t\t\t\t\t<td  class=\"text-left\" ng-hide=\"currentClickedElement == $index\" >\n" +
    "\t\t\t\t\t\t\t<a  class=\"edit-data-inline\" ng-click=\"editFloor($index)\">{{floor.floor_number}} </a>\n" +
    "\t\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td header-class=\"width-20\"  ng-click=\"editFloor($index)\" ng-hide=\"currentClickedElement == $index\" >\n" +
    "\t\t\t\t\t\t\t<a class=\"edit-data-inline\">{{floor.description}} </a>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td header-class=\" width-10\"  class=\"text-left\" ng-hide=\"currentClickedElement == $index\" >\n" +
    "\t\t\t\t\t\t\t<span ng-click=\"deleteFloor($index)\" class=\"icons icon-delete large-icon floor_delete\">&nbsp;</span>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t<td colspan=\"3\" ng-include=\"getTemplateUrl($index)\" ng-show=\"currentClickedElement == $index\"></td>\n" +
    "\t\t\t\t\t</tr>\n" +
    "\t\t\t\t</tbody>\n" +
    "\t\t\t</table>\n" +
    "\t\t</section>\n" +
    "\t</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/frequentFlyerProgram/adFFPList.html',
    "<section id=\"replacing-div-first\" class=\"content current\" ng-click=\"clearErrorMessage()\">\n" +
    "\t<div data-view=\"GuestCardFFPView\">\n" +
    "\t\t<!-- FFP list -->\n" +
    "\t\t<header class=\"content-title float\">\n" +
    "\t\t\t<h2 translate>FREQUENT_FLYER_PROGRAMS</h2>\n" +
    "\t\t\t<span class=\"count\">({{ ffp.length}})</span>\n" +
    "\t\t</header>\n" +
    "\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t<table class=\"grid datatable table \" ng-table=\"tableParams\" template-pagination=\"nil\">\n" +
    "\t\t\t\t<tbody >\n" +
    "\t\t\t\t\t<tr ffp-id=\"{{item.id}}\" ng-repeat = \"item in ffp\">\n" +
    "\t\t\t\t\t\t<td data-title=\"'Airline'\" sortable=\"'airline'\"><strong> {{item.airline}} </strong></td>\n" +
    "\t\t\t\t\t\t<td data-title=\"'Program name'\" sortable=\"'program_name'\">{{item.program_name}} </td>\n" +
    "\t\t\t\t\t\t<td data-title=\"'Active'\" class=\"activate\">\n" +
    "\t\t\t\t\t\t\t<div class=\"entry\" >\n" +
    "\t\t\t\t\t\t\t\t<label></label>\n" +
    "\t\t\t\t\t\t\t\t<div class=\"switch-button single\"  ng-class=\"{ on : item.is_active }\">\n" +
    "\t\t\t\t\t\t\t\t\t<input type=\"checkbox\" ng-click=\"toggleClicked()\" id=\"ffp-active\" value=\"ffp-active\">\n" +
    "\t\t\t\t\t\t\t\t\t<span class=\"switch-icon\"></span>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t</tr>\n" +
    "\n" +
    "\t\t\t\t</tbody>\n" +
    "\t\t\t</table>\n" +
    "\t\t</section>\n" +
    "\t</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/hotel/adHotelDetails.html',
    "<div id=\"wrapper\" class=\"content current\" ng-click=\"clearErrorMessage()\" >\n" +
    "\t<header class=\"content-title float\">\n" +
    "\t\t<h2>{{title}}</h2>\n" +
    "\t\t<a ng-click =\"back()\" class=\"action back\">Back</a>\n" +
    "\t</header>\n" +
    "\t<section class=\"content-scroll\">\n" +
    "\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t<div ng-include=\"'/assets/partials/common/notification_success_message.html'\"></div> \n" +
    "\t<form class=\"form float\" >\t\t\n" +
    "\t\t<fieldset class=\"holder left\">\n" +
    "\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t<h3><span>Hotel</span> Name and Location </h3>\n" +
    "\t\t\t\t<em class=\"status\"> Fields marked with <strong>*</strong> are mandatory! </em>\n" +
    "\t\t\t</div>\n" +
    "\t\t\n" +
    "\t    \t<ad-textbox value=\"data.hotel_name\" name = \"hotel-name\" id = \"hotel-name\" label = \"Name\" placeholder = \"Enter hotel name\" required = \"yes\" ></ad-textbox>\n" +
    "\t\t\t\n" +
    "\t\t\t<ad-textbox value=\"data.hotel_code\" name = \"hotel-code\" id = \"hotel-code\" label = \"Hotel Code\" placeholder = \"Enter hotel name\" required = \"yes\" readonly=\"{{readOnly}}\"></ad-textbox>\n" +
    "\n" +
    "\t\t\t<ad-textbox label=\"Street\" value=\"data.street\" required=\"yes\" placeholder=\"Enter hotel street\" name=\"hotel-street\" id=\"hotel-street\"></ad-textbox>\n" +
    "\n" +
    "\t\t\t<ad-textbox label=\"Phone\" value=\"data.phone\" required=\"yes\" placeholder=\"Enter hotel phone number\" name=\"hotel-phone\" id=\"hotel-phone\"></ad-textbox>\n" +
    "\n" +
    "\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t<label for=\"hotel-city\"> City <strong>*</strong> </label>\n" +
    "\t\t\t\t<input type=\"text\" ng-model=\"data.city\" value=\"{{data.city}}\" required=\"yes\" placeholder=\"Enter city name\" name=\"hotel-city\" id=\"hotel-city\">\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t<label for=\"hotel-state\"> State </label>\n" +
    "\t\t\t\t<input type=\"text\" ng-model=\"data.state\" value=\"{{data.state}}\" required=\"\" placeholder=\"Enter state name\" name=\"hotel-state\" id=\"hotel-state\">\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t<label for=\"hotel-zipcode\"> ZipCode</label>\n" +
    "\t\t\t\t<input type=\"text\" ng-model=\"data.zipcode\" value=\"{{data.zipcode}}\" required=\"\" placeholder=\"Enter zip code\" name=\"hotel-zipcode\" id=\"hotel-zipcode\">\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t<label for=\"hotel-country\"> Country <strong>*</strong> </label>\n" +
    "\t\t\t\t<div class=\"select\">\n" +
    "\t\t\t\t\t<select ng-model=\"data.country\" name=\"hotel-country\" id=\"hotel-country\" class=\"placeholder\">\n" +
    "\t\t\t\t\t\t<option value=\"\"> Country </option>\n" +
    "\t\t\t\t\t\t<option ng-model=\"country.id\" ng-repeat=\"country in data.countries\" value=\"{{country.id}}\" ng-selected=\"country.id==data.country\"> {{country.name}} </option>\n" +
    "\n" +
    "\t\t\t\t\t</select>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t<label for=\"hotel-longitude\"> Longitude </label>\n" +
    "\t\t\t\t<input type=\"text\" ng-model=\"data.longitude\" value=\"{{data.longitude}}\" required=\"\" readonly=\"readonly\" placeholder=\"Enter hotel longitude\" name=\"hotel-longitude\">\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t<label for=\"hotel-latitude\"> Latitude </label>\n" +
    "\t\t\t\t<input type=\"text\" ng-model=\"data.latitude\" value=\"{{data.latitude}}\" required=\"\" readonly=\"readonly\" placeholder=\"Enter hotel latitude\" name=\"hotel-latitude\" >\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t\t<div class=\"entry full-width registration-for-rover\" ng-hide=\"isAdminSnt\">\n" +
    "\t\t\t\t<label for=\"rover\"> Rover Registration </label>\n" +
    "\t\t\t\t<div  id=\"registration-for-rover\" class=\"boxes\">\n" +
    "\t\t\t\t\t<label class=\"radio\" ng-class=\"{checked: data.required_signature_at == 'CHECKIN'}\"> <span class=\"icon-form icon-radio\" ng-class=\"{checked: data.required_signature_at == 'CHECKIN'}\"></span>\n" +
    "\t\t\t\t\t\t<input ng-model=\"data.required_signature_at\" type=\"radio\" value=\"CHECKIN\" name=\"rover\" id=\"type1\" class=\"change-data\" checked=\"checked\">\n" +
    "\t\t\t\t\t\tRequire Signature at Check In </label>\n" +
    "\t\t\t\t\t<label class=\"radio\" ng-class=\"{checked: data.required_signature_at == 'CHECKOUT'}\"> <span class=\"icon-form icon-radio\" ng-class=\"{checked: data.required_signature_at == 'CHECKOUT'}\"></span>\n" +
    "\t\t\t\t\t\t<input ng-model=\"data.required_signature_at\" type=\"radio\" value=\"CHECKOUT\" name=\"rover\" id=\"type2\" class=\"change-data\">\n" +
    "\t\t\t\t\t\tRequire Signature at Check Out </label>\n" +
    "\t\t\t\t\t<label class=\"radio\" ng-class=\"{checked: data.required_signature_at == 'NO_SIGNATURE'}\"> <span class=\"icon-form icon-radio\" ng-class=\"{checked: data.required_signature_at == 'NO_SIGNATURE'}\"></span>\n" +
    "\t\t\t\t\t\t<input ng-model=\"data.required_signature_at\"type=\"radio\" value=\"NO_SIGNATURE\" name=\"rover\" id=\"type3\" class=\"change-data\">\n" +
    "\t\t\t\t\t\tNo Signature Required </label>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t<label for=\"terms_and_conditions\" translate>\n" +
    "\t\t\t\tTERMS_AND_CONDITIONS_LABEL\n" +
    "\t\t\t\t</label>\n" +
    "\t\t\t\t<textarea class=\"full-width terms_height\" id=\"terms_and_conditions\" type=\"\" ng-model=\"data.terms_and_conditions\"></textarea>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t\n" +
    "\t\t</fieldset>\n" +
    "\t\t\n" +
    "\t\t<fieldset class=\"holder right\">\n" +
    "\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t<h3><span>Hotel</span> Details </h3>\n" +
    "\t\t\t\t<em class=\"status\"> Fields marked with <strong>*</strong> are mandatory! </em>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t\n" +
    "\t\t\t<ad-textbox value=\"data.number_of_rooms\" label = \"Number of rooms\" placeholder = \"Type number\" readonly=\"{{readOnly}}\"></ad-textbox>\n" +
    "\n" +
    "\t\t\t<div class=\"entry is-pms-tokenized\" ng-show=\"isAdminSnt\">\n" +
    "\t\t\t\t<label>Enable single digit room number search</label>\n" +
    "\t\t\t\t<div class=\"switch-button single\" ng-class=\"{ on : data.is_single_digit_search == true }\" ng-click=\"data.is_single_digit_search = !data.is_single_digit_search\">\n" +
    "\t\t\t\t\t<input type=\"checkbox\" value=\"{{data.is_single_digit_search}}\" id=\"is-single-digit-search\">\n" +
    "\t\t\t\t\t<span class=\"switch-icon\"></span>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t<label> Checkin time </label>\n" +
    "\t\t\t\t<div class=\"entry full-width float\">\n" +
    "\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\t\t\t\t\t\t<select ng-model=\"data.check_in_hour\" name=\"hotel-checkin-hour\" id=\"hotel-checkin-hour\" class=\"styled\">\n" +
    "\t\t\t\t\t\t\t\t<option value=\"\" data-text=\"Not set\" class=\"placeholder\">HH</option>\n" +
    "\t\t\t\t\t\t\t\t<option ng-repeat=\"i in [1, 12, 1, 2] | makeRange\" value=\"{{i}}\" ng-selected=\"i==data.check_in_time.hour\" >{{i}}</option>\n" +
    "\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\t\t\t\t\t\t\t<select ng-model=\"data.check_in_min\" name=\"hotel-checkin-minute\" id=\"hotel-checkin-minutes\">\n" +
    "\t\t\t\t\t\t\t\t<option value=\"\" data-text=\"Not set\" class=\"placeholder\">MM</option>\n" +
    "\t\t\t\t\t\t\t\t<option ng-repeat=\"i in [0, 45, 15, 2] | makeRange\" value=\"{{i}}\" ng-selected=\"i==data.check_in_time.minute\" >{{i}}</option>\n" +
    "\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\t\t\t\t\t\t<select ng-model=\"data.check_in_primetime\" class=\"styled\">\n" +
    "\t\t\t\t\t\t\t<!-- || data.check_in_time.primetime.length == '' || data.check_in_time.primetime.length == 0  || !isEdit -->\n" +
    "\t\t\t\t\t\t\t<option ng-selected=\"data.check_in_time.primetime == 'AM'\" value=\"AM\">AM</option>\n" +
    "\t\t\t\t\t\t\t<option ng-selected=\"data.check_in_time.primetime == 'PM'\" value=\"PM\">PM</option>\n" +
    "\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\n" +
    "\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t<label> Checkout time </label>\n" +
    "\t\t\t\t<div class=\"entry full-width float\">\n" +
    "\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\t\t\t\t\t\t<select ng-model=\"data.check_out_hour\" name=\"hotel-checkout-hour\" id=\"hotel-checkout-hour\" class=\"styled\">\n" +
    "\t\t\t\t\t\t\t<option value=\"\" data-text=\"Not set\" class=\"placeholder\">HH</option>\n" +
    "\t\t\t\t\t\t\t<option ng-repeat=\"i in [1, 12, 1, 2] | makeRange\" value=\"{{i}}\" ng-selected=\"i==data.check_out_time.hour\" >{{i}}</option>\n" +
    "\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\t\t\t\t\t\t<select ng-model=\"data.check_out_min\" name=\"hotel-checkout-minute\" id=\"hotel-checkout-minutes\">\n" +
    "\t\t\t\t\t\t\t<option value=\"\" data-text=\"Not set\" class=\"placeholder\">MM</option>\n" +
    "\t\t\t\t\t\t\t<option ng-repeat=\"i in [0, 45, 15, 2] | makeRange\" value=\"{{i}}\" ng-selected=\"i==data.check_out_time.minute\" >{{i}}</option>\n" +
    "\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\t\t\t\t\t\t<select ng-model=\"data.check_out_primetime\" class=\"styled\">\n" +
    "\t\t\t\t\t\t\t<option ng-selected=\"data.check_out_time.primetime == 'AM'\" value=\"AM\">AM</option>\n" +
    "\t\t\t\t\t\t\t<option ng-selected=\"data.check_out_time.primetime == 'PM'\" value=\"PM\">PM</option>\n" +
    "\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t<label for=\"hotel-chain\"> Hotel chain <strong>*</strong> </label>\n" +
    "\t\t\t\t<div class=\"select\">\n" +
    "\t\t\t\t\t<select ng-disabled=\"isHotelChainEditable\" ng-model=\"data.hotel_chain\" name=\"hotel-chain\" id=\"hotel-chain\" class=\"placeholder\">\n" +
    "\t\t\t\t\t\t<option value=\"\"> Hotel chain </option>\n" +
    "\t\t\t\t\t\t<option ng-repeat=\"chain in data.chains\" value=\"{{chain.id}}\" ng-selected=\"chain.id==data.hotel_chain\" >{{chain.name}}</option>\n" +
    "\t\t\t\t\t</select>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t<label for=\"hotel-brand\"> Hotel brand </label>\n" +
    "\t\t\t\t<div class=\"select\">\n" +
    "\t\t\t\t\t<select ng-model=\"data.hotel_brand\" name=\"hotel-brand\" id=\"hotel-brand\" class=\"placeholder\">\n" +
    "\t\t\t\t\t\t<option value=\"\"> Hotel brand </option>\n" +
    "\t\t\t\t\t\t<option ng-repeat=\"brand in data.brands\" value=\"{{brand.id}}\" ng-selected=\"brand.id==data.hotel_brand\">{{brand.name}}</option>\n" +
    "\t\t\t\t\t</select>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t<label for=\"hotel-time-zone\"> Hotel Time Zone <strong>*</strong> </label>\n" +
    "\t\t\t\t<div class=\"select\">\n" +
    "\t\t\t\t\t<select ng-model=\"data.hotel_time_zone\" name=\"hotel-time-zone\" id=\"hotel-time-zone\" class=\"placeholder\" >\n" +
    "\t\t\t\t\t\t<option value=\"\"> Hotel Time Zone </option>\n" +
    "\t\t\t\t\t\t<option ng-repeat=\"timezone in data.time_zones\"  ng-selected=\"timezone.value==data.hotel_time_zone\">{{timezone.value}}</option>\n" +
    "\t\t\t\t\t</select>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t\n" +
    "\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t<label for=\"hotel-time-zone\"> Hotel Date Format <strong>*</strong> </label>\n" +
    "\t\t\t\t<div class=\"select\">\n" +
    "\t\t\t\t\t<select ng-model=\"data.hotel_date_format\" name=\"hotel-time-zone\" id=\"hotel-time-zone\" class=\"placeholder\" >\n" +
    "\t\t\t\t\t\t<option value=\"\"> Hotel Date Format </option>\n" +
    "\t\t\t\t\t\t<option ng-repeat=\"formats in data.date_formats\"  value=\"{{formats.id}}\" ng-selected=\"formats.id==data.hotel_date_format\">{{formats.value}}</option>\n" +
    "\t\t\t\t\t</select>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t\n" +
    "\t\t\t<div class=\"entry hotel-pms-type\" ng-show=\"isAdminSnt\">\n" +
    "\t\t\t\t<label for=\"hotel-pms-type\"> PMS Type</label>\n" +
    "\t\t\t\t<div class=\"select\">\n" +
    "\t\t\t\t\t<select ng-model=\"data.hotel_pms_type\" name=\"hotel-pms-type\" id=\"hotel-pms-type\" class=\"placeholder\">\n" +
    "\t\t\t\t\t\t<option value=\"\"> PMS Type </option>\n" +
    "\t\t\t\t\t\t<option ng-repeat=\"pms_types in data.pms_types\" value=\"{{pms_types.value}}\" ng-selected=\"pms_types.value==data.hotel_pms_type\">{{pms_types.value}}</option>\n" +
    "\t\t\t\t\t</select>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t<label for=\"hotel-currency\"> Hotel Currency <strong>*</strong> </label>\n" +
    "\t\t\t\t<div class=\"select\">\n" +
    "\t\t\t\t\t<select ng-model=\"data.default_currency\" name=\"hotel-currency\" id=\"hotel-currency\" class=\"placeholder\">\n" +
    "\t\t\t\t\t\t<option value=\"\"> Hotel Currency </option>\n" +
    "\t\t\t\t\t\t<option ng-model=\"currency.id\" ng-repeat=\"currency in data.currency_list\" ng-selected=\"currency.id==data.default_currency\" value=\"{{currency.id}}\">{{currency.code}}</option>\n" +
    "\t\t\t\t\t</select>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<div class=\"entry is-pms-tokenized\" ng-show=\"isAdminSnt && data.hotel_pms_type ==='OWS'\">\n" +
    "\t\t\t\t<label for=\"is-pms-tokenized\">PMS Tokenized</label>\n" +
    "\t\t\t\t<div class=\"switch-button single\" ng-class=\"{ on : data.is_pms_tokenized == 'true' }\" ng-click=\"toggleClicked()\">\n" +
    "\t\t\t\t\t<input type=\"checkbox\" value=\"{{data.is_pms_tokenized}}\" name=\"is-pms-tokenized\" id=\"is-pms-tokenized\">\n" +
    "\t\t\t\t\t<span class=\"switch-icon\"></span>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t<label for=\"auto-logout\"> Auto logout delay [Minutes] <strong>*</strong> </label>\n" +
    "\t\t\t\t<input type=\"text\" ng-model=\"data.auto_logout_delay\" value=\"{{data.auto_logout_delay}}\" required=\"yes\" placeholder=\"Enter auto logout delay\" name=\"auto-logout\" id=\"auto-logout\">\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<div class=\"entry\" ng-hide=\"isAdminSnt\">\n" +
    "\t\t\t\t<label for=\"auto-logout\"> Password Expiry [Days] <strong>*</strong> </label>\n" +
    "\t\t\t\t<input type=\"text\" ng-model=\"data.password_expiry\" value=\"{{data.password_expiry}}\" required=\"yes\" placeholder=\"Enter password expiry delay\">\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<div class=\"entry date has-datepicker\" ng-if=\"isAdminSnt\">\n" +
    "\t\t\t\t<label for=\"auto-logout\"> PMS Start Date  </label>\n" +
    "\t\t\t\t<input type=\"text\" ng-model=\"data.pms_start_date\" placeholder=\"Enter PMS start Date\" name=\"pms-start-date\" id=\"pms-start-date\" readonly ng-click=\"setPmsStartDate()\">\n" +
    "\t\t\t\t<button ng-click=\"setPmsStartDate()\" class=\"ui-datepicker-trigger\" type=\"button\">\n" +
    "                         ...\n" +
    "                </button>\n" +
    "\t\t\t</div>\t\t\t\n" +
    "\t\t\t<div class=\"entry full-width\" ng-show=\"isAdminSnt\">\n" +
    "\t\t\t\t<label for=\"hotel-pms-type\"> Language </label>\n" +
    "\t\t\t\t<div class=\"select\">\n" +
    "\t\t\t\t\t<select ng-model=\"data.selected_language\" name=\"hotel-pms-type\" id=\"hotel-pms-type\" class=\"placeholder\">\n" +
    "\t\t\t\t\t\t<option value=\"\"> Language </option>\n" +
    "\t\t\t\t\t\t<option ng-repeat=\"language in languages\" value=\"{{language.id}}\" ng-selected=\"language.id==data.selected_language\">\n" +
    "\t\t\t\t\t\t\t{{language.description}}\n" +
    "\t\t\t\t\t\t</option>\n" +
    "\t\t\t\t\t</select>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t\n" +
    "\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t<label for=\"hotel_from_address\"> EMAIL DOMAIN AND FROM ADDRESS FOR GUESTS <strong>*</strong></label>\n" +
    "\t\t\t\t<input type=\"text\" ng-model=\"data.hotel_from_address\" value=\"{{data.hotel_from_address}}\" placeholder=\"Enter Email domain and from address for GUEST\" name=\"hotel_from_address\" id=\"hotel_from_address\">\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t\t<div class=\"entry is-pms-tokenized\" ng-show=\"isAdminSnt && data.hotel_pms_type ==='OWS'\">\n" +
    "\t\t\t\t<label for=\"use-kiosk-entity-id-for-fetch-booking\">Use KIOSK entity id in FetchBooking</label>\n" +
    "\t\t\t\t<div class=\"switch-button single\" ng-class=\"{ on : data.use_kiosk_entity_id_for_fetch_booking == 'true' }\" ng-click=\"kioskEntityToggleClicked()\">\n" +
    "\t\t\t\t\t<input type=\"checkbox\" value=\"{{data.use_kiosk_entity_id_for_fetch_booking}}\" name=\"use-kiosk-entity-id-for-fetch-booking\" id=\"use-kiosk-entity-id-for-fetch-booking\">\n" +
    "\t\t\t\t\t<span class=\"switch-icon\"></span>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t\t<div class=\"entry is-pms-tokenized\" ng-show=\"isAdminSnt && data.hotel_pms_type ==='OWS'\">\n" +
    "\t\t\t\t<label for=\"use-snt-entity-id-for-checkin-checkout\">Use SNT entity id in Check In/Out</label>\n" +
    "\t\t\t\t<div class=\"switch-button single\" ng-class=\"{ on : data.use_snt_entity_id_for_checkin_checkout == 'true' }\" ng-click=\"sntEntityToggleClicked()\">\n" +
    "\t\t\t\t\t<input type=\"checkbox\" value=\"{{data.use_snt_entity_id_for_checkin_checkout}}\" name=\"use-snt-entity-id-for-checkin-checkout\" id=\"use-snt-entity-id-for-checkin-checkout\">\n" +
    "\t\t\t\t\t<span class=\"switch-icon\"></span>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<div class=\"entry is-pms-tokenized\" ng-show=\"isAdminSnt\">\n" +
    "\t\t\t\t<label for=\"do_not_update_video_checkout\">Do not update video checkout</label>\n" +
    "\t\t\t\t<div class=\"switch-button single\" ng-class=\"{ on : data.do_not_update_video_checkout == 'true' }\" ng-click=\"doNotUpdateVideoToggleClicked()\">\n" +
    "\t\t\t\t\t<input type=\"checkbox\" value=\"{{data.do_not_update_video_checkout}}\" name=\"do-not-update-video-checkout\" id=\"do-not-update-video-checkout\">\n" +
    "\t\t\t\t\t<span class=\"switch-icon\"></span>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<!-- <div class=\"entry\">\n" +
    "\t\t\t\t<label for=\"hotel_from_address\"> LANGUAGE <strong>*</strong></label>\n" +
    "\t\t\t\t<select ng-model=\"data.hotel_pms_type\" name=\"hotel-pms-type\" id=\"hotel-pms-type\" class=\"placeholder\">\n" +
    "\t\t\t\t\t<option value=\"\"> PMS Type </option>\n" +
    "\t\t\t\t\t<option ng-repeat=\"pms_types in data.pms_types\" value=\"{{pms_types.value}}\" ng-selected=\"pms_types.value==data.hotel_pms_type\">{{pms_types.value}}</option>\n" +
    "\t\t\t\t</select>\n" +
    "\t\t\t</div> -->\n" +
    "\n" +
    "\t\t\t<div class=\"entry full-width\" ng-hide=\"isAdminSnt\">\n" +
    "\t\t\t\t<label for=\"hotel-logo\"> Hotel Logo Image for Rover (316x70px 9:2 ratio)  </label>\n" +
    "\t\t\t\t<div class=\"file-upload with-preview\">\n" +
    "\t\t\t\t\t<span class=\"input\">{{hotel_logo_file}}</span>\n" +
    "\t\t\t\t\t<a id=\"deleteLogo\" class=\"icons icon-delete large-icon delete_item\" ng-show=\"isLogoAvailable(data.hotel_logo)\" ng-click = \"data.hotel_logo = 'false'\"></a>\n" +
    "\t\t\t\t\t<input type=\"file\" ng-model=\"data.hotel_logo\" accept=\"image/*\" app-filereader />\n" +
    "\t\t\t\t\t<button type=\"button\" class=\"button brand-colors\">\n" +
    "\t\t\t\t\t\tChoose file\n" +
    "\t\t\t\t\t</button>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t\t<span class=\"file-preview\"> <img ng-src=\"{{data.hotel_logo}}\" alt=\"\" height=\"112\" width=\"auto\"> </span>\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t\t<div class=\"entry full-width\" ng-hide=\"isAdminSnt\">\n" +
    "\t\t\t\t<label for=\"hotel-logo\"> Hotel Logo Image for Templates (500x115px)  </label>\n" +
    "\t\t\t\t<div class=\"file-upload with-preview\">\n" +
    "\t\t\t\t\t<span class=\"input\">{{hotel_template_logo_file}}</span>\n" +
    "\t\t\t\t\t<a id=\"deleteLogo\" class=\"icons icon-delete large-icon delete_item\" ng-show=\"isLogoAvailable(data.hotel_template_logo)\" ng-click = \"data.hotel_template_logo = 'false'\"></a>\n" +
    "\t\t\t\t\t<input type=\"file\" ng-model=\"data.hotel_template_logo\" accept=\"image/*\" app-filereader />\n" +
    "\t\t\t\t\t<button type=\"button\" class=\"button brand-colors\">\n" +
    "\t\t\t\t\t\tChoose file\n" +
    "\t\t\t\t\t</button>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t\t<span class=\"file-preview\"> <img src=\"{{data.hotel_template_logo}}\" alt=\"\" height=\"112\" width=\"auto\"> </span>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t\n" +
    "\t\t</fieldset>\n" +
    "\t\t\n" +
    "\t\t<fieldset class=\"holder left\">\n" +
    "\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t<h3><span>Hotel</span> Main Contact </h3>\n" +
    "\t\t\t\t<em class=\"status\"> Fields marked with <strong>*</strong> are mandatory! </em>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t<label for=\"contact-first-name\"> First Name <strong>*</strong> </label>\n" +
    "\t\t\t\t<input type=\"text\" ng-model=\"data.contact_first_name\" required=\"yes\" placeholder=\"Enter first name\" name=\"contact-first-name\" id=\"contact-first-name\" value=\"{{data.contact_first_name}}\">\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t<label for=\"contact-last-name\"> Last Name <strong>*</strong> </label>\n" +
    "\t\t\t\t<input type=\"text\" ng-model=\"data.contact_last_name\" required=\"yes\" placeholder=\"Enter last name\" name=\"contact-last-name\" id=\"contact-last-name\" value=\"{{data.contact_last_name}}\">\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t<label for=\"contact-email\"> Email <strong>*</strong> </label>\n" +
    "\t\t\t\t<input type=\"text\" ng-model=\"data.contact_email\" value=\"{{data.contact_email}}\" required=\"yes\" placeholder=\"Enter email\" name=\"contact-email\" id=\"contact-email\">\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t<label for=\"contact-phone\"> Phone <strong>*</strong> </label>\n" +
    "\t\t\t\t<input type=\"text\" ng-model=\"data.contact_phone\" value=\"{{data.contact_phone}}\" required=\"yes\" placeholder=\"Enter phone number\" name=\"contact-phone\" id=\"contact-phone\">\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t</fieldset>\n" +
    "\n" +
    "\t\t<fieldset class=\"holder right\" ng-show=\"isAdminSnt\">\n" +
    "\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t<h3><span>Hotel</span> External Reference Import </h3>\n" +
    "\t\t\t\t<em class=\"status\"> Fields marked with <strong>*</strong> are mandatory! </em>\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t\t<div class=\"entry\" ng-show=\"isAdminSnt\">\n" +
    "\t\t\t\t<label for=\"is-external-references-import-on\">Enable</label>\n" +
    "\t\t\t\t<div class=\"switch-button single\" ng-class=\"{ on : data.is_external_references_import_on}\">\n" +
    "\t\t\t\t\t<input type=\"checkbox\" ng-model=\"data.is_external_references_import_on\" value=\"{{data.is_external_references_import_on}}\" name=\"is-external-references-import-on\" id=\"is-external-references-import-on\">\n" +
    "\t\t\t\t\t<span class=\"switch-icon\"></span>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t<label for=\"contact-phone\"> Frequency [Minutes] <!-- strong>*</strong> --> </label>\n" +
    "\t\t\t\t<input type=\"text\" ng-model=\"data.external_references_import_freq\" value=\"{{data.external_references_import_freq}}\"placeholder=\"Enter frequency\" name=\"frequency\" id=\"frequency\">\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t</fieldset>\n" +
    "\t\t\n" +
    "\n" +
    "\t\t<fieldset class=\"holder left\" ng-show=\"isAdminSnt\">\n" +
    "\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t<h3>\n" +
    "\t\t\t\t\t<span>Hotel</span>\n" +
    "\t\t\t\t\t Payment Gateway Settings\n" +
    "\t\t\t\t</h3>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<div class=\"entry \">\n" +
    "\t\t\t\t<label class=\"radio\" ng-class=\"{checked:data.payment_gateway == 'MLI'}\">\n" +
    "\t\t\t\t\t<span class=\"icon-form icon-radio \" ng-class=\"{checked:data.payment_gateway == 'MLI'}\"></span>\n" +
    "\t\t\t\t\t<input type=\"radio\" ng-model=\"data.payment_gateway\" value=\"MLI\" class=\"change-data\">\n" +
    "\t\t\t\t\tMerchantLink Payment\n" +
    "\t\t\t\t</label>\n" +
    "\t\t\t\t<label class=\"radio\" ng-class=\"{checked:data.payment_gateway == 'sixpayments'}\">\n" +
    "\t\t\t\t\t<span class=\"icon-form icon-radio \" ng-class=\"{checked:data.payment_gateway == 'sixpayments'}\"></span>\n" +
    "\t\t\t\t\t<input type=\"radio\" ng-model=\"data.payment_gateway\" value=\"sixpayments\" class=\"change-data\">\n" +
    "\t\t\t\t\tSix Payment\n" +
    "\t\t\t\t</label>\n" +
    "\n" +
    "\t\t\t\t\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<div class=\"entry\"></div>\n" +
    "\t\t\t<div class=\"entry\" ng-show=\"data.payment_gateway == 'MLI'\">\n" +
    "\t\t\t\t<label for=\"mli-payment-gateway-url\">\n" +
    "\t\t\t\t\tMerchantLink payment gateway url\n" +
    "\t\t\t\t</label>\n" +
    "\t\t\t\t<input type=\"text\" ng-model=\"data.mli_payment_gateway_url\" value=\"{{data.mli_payment_gateway_url}}\" placeholder=\"Enter MLI payment gateway url\">\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t\t<div class=\"entry\" ng-show=\"data.payment_gateway == 'MLI'\">\n" +
    "\t\t\t\t<label for=\"mli-merchant-id\">\n" +
    "\t\t\t\t\tMerchantLink Merchant ID\n" +
    "\t\t\t\t</label>\n" +
    "\t\t\t\t<input type=\"text\" ng-model=\"data.mli_merchant_id\" value=\"{{data.mli_merchant_id}}\" placeholder=\"Enter MLI Merchant ID\">\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t\t<div class=\"entry\" ng-show=\"data.payment_gateway == 'MLI'\">\n" +
    "\t\t\t\t<label for=\" mli-api-version\">\n" +
    "\t\t\t\t\tMerchantLink api version\n" +
    "\t\t\t\t</label>\n" +
    "\t\t\t\t<input type=\"text\" ng-model=\"data.mli_api_version\" value=\"{{data.mli_api_version}}\" placeholder=\"Enter MLI api version\">\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t\t<div class=\"entry\" ng-show=\"data.payment_gateway == 'MLI'\">\n" +
    "\t\t\t\t<label for=\"mli-api-key\">\n" +
    "\t\t\t\t\tMerchantLink api key\n" +
    "\t\t\t\t</label>\n" +
    "\t\t\t\t<input type=\"password\" ng-model=\"data.mli_api_key\" value=\"{{data.mli_api_key}}\" placeholder=\"Enter MLI api key\">\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t\t<div class=\"entry\" ng-show=\"data.payment_gateway == 'MLI'\">\n" +
    "\t\t\t\t<label for=\"mli-site-code\">\n" +
    "\t\t\t\t\tMerchantLink site code\n" +
    "\t\t\t\t</label>\n" +
    "\t\t\t\t<input type=\"text\" ng-model=\"data.mli_site_code\" value=\"{{data.mli_site_code}}\" placeholder=\"Enter MLI api key\">\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t\t<div class=\"entry full-width\" ng-show=\"data.payment_gateway == 'MLI'\">\n" +
    "\t\t\t\t<button type=\"button\" id=\"test-mli-payment-gateway\" class=\"button blue\" ng-click=\"testMLIPaymentGateway()\">\n" +
    "\t\t\t\t\tTEST MERCHANTLINK PAYMENT GATEWAY\n" +
    "\t\t\t\t</button>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<div class=\"entry\" ng-show=\"data.payment_gateway == 'sixpayments'\">\n" +
    "\t\t\t\t<label for=\"mli-payment-gateway-url\">\n" +
    "\t\t\t\t\tSix Payments merchant ID\n" +
    "\t\t\t\t</label>\n" +
    "\t\t\t\t<input type=\"text\" ng-model=\"data.six_merchant_id\" value=\"{{data.six_merchant_id}}\" placeholder=\"Enter six payment merchant id\">\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t\t<div class=\"entry\" ng-show=\"data.payment_gateway == 'sixpayments'\">\n" +
    "\t\t\t\t<label for=\"mli-merchant-id\">\n" +
    "\t\t\t\t\tSix Payments validation code\n" +
    "\t\t\t\t</label>\n" +
    "\t\t\t\t<input type=\"text\" ng-model=\"data.six_validation_code\" value=\"{{data.six_validation_code}}\" placeholder=\"Enter six payment validation code\">\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<div class=\"entry\" ng-show=\"data.payment_gateway == 'sixpayments'\">\n" +
    "\t\t\t\t<label for=\"six-ipage-url\">\n" +
    "\t\t\t\t\tSix Payments URL\n" +
    "\t\t\t\t</label>\n" +
    "\t\t\t\t<input type=\"text\" ng-model=\"data.six_ipage_url\" value=\"{{data.six_ipage_url}}\" readonly=\"readonly\">\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<div class=\"entry\" ng-show=\"data.payment_gateway == 'sixpayments'\">\n" +
    "\t\t\t\t<label for=\"six-server-location-id\">\n" +
    "\t\t\t\t\tSix Payments Location Id\n" +
    "\t\t\t\t</label>\n" +
    "\t\t\t\t<input type=\"text\" ng-model=\"data.six_server_location_id\" value=\"{{data.six_server_location_id}}\">\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<div class=\"entry\" ng-show=\"data.payment_gateway == 'sixpayments'\">\n" +
    "\t\t\t\t<label for=\"six-server-ipaddress\">\n" +
    "\t\t\t\t\tSix Payments Server IP\n" +
    "\t\t\t\t</label>\n" +
    "\t\t\t\t<input type=\"text\" ng-model=\"data.six_server_ipaddress\" value=\"{{data.six_server_ipaddress}}\">\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<div class=\"entry\" ng-show=\"data.payment_gateway == 'sixpayments'\">\n" +
    "\t\t\t\t<label for=\"six-server-port\">\n" +
    "\t\t\t\t\tSix Payments Server Port\n" +
    "\t\t\t\t</label>\n" +
    "\t\t\t\t<input type=\"text\" ng-model=\"data.six_server_port\" value=\"{{data.six_server_port}}\">\n" +
    "\t\t\t</div>\n" +
    "\t\t\t\n" +
    "\t\t</fieldset>\n" +
    "\t\t<fieldset class=\"holder right\" ng-show=\"isAdminSnt && data.payment_gateway == 'MLI'\" >\n" +
    "\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t<h3><span>Hotel</span> MerchantLink Settings </h3>\n" +
    "\t\t\t\t<em class=\"status\"> Fields marked with <strong>*</strong> are mandatory! </em>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t<label for=\"mli-hotel-code\"> MerchantLink hotel code </label>\n" +
    "\t\t\t\t<input type=\"text\" ng-model=\"data.mli_hotel_code\" value=\"{{data.mli_hotel_code}}\" placeholder=\"Enter MLI hotel code\" name=\"mli-hotel-code\" id=\"mli-hotel-code\">\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t<label for=\"mli-chain-code\"> MerchantLink chain code </label>\n" +
    "\t\t\t\t<input type=\"text\" ng-model=\"data.mli_chain_code\" value=\"{{data.mli_chain_code}}\" placeholder=\"Enter MLI chain code\" name=\"mli-chain-code\" id=\"mli-chain-code\">\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t<label for=\"certificate\">\n" +
    "\t\t\t\t\t MerchantLink Token Certificate\n" +
    "\t\t\t\t</label>\n" +
    "\t\t\t\t<div class=\"file-upload\">\n" +
    "\t\t\t\t\t<span class=\"input\">{{fileName}}</span>\n" +
    "\t\t\t\t\t<input type=\"file\" ng-model=\"certificate\" accept=\"*\" app-filereader />\n" +
    "\t\t\t\t\t<button type=\"button\" class=\"button brand-colors\">\n" +
    "\t\t\t\t\t\tAttach Certificate\n" +
    "\t\t\t\t\t</button>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t\n" +
    "\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t<label for=\"mli-access-url\"> MerchantLink Access URL </label>\n" +
    "\t\t\t\t<input type=\"text\" ng-model=\"data.mli_access_url\" value=\"{{data.mli_access_url}}\" readonly=\"true\" name=\"mli-access-url\" id=\"mli-access-url\" readonly>\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t\t<button type=\"button\" id=\"test-mli-connectivity\" ng-click=\"clickedTestMliConnectivity()\" class=\"button blue\">\n" +
    "\t\t\t\tTest MerchantLink Connectivity\n" +
    "\t\t\t</button>\n" +
    "\n" +
    "\t\t</fieldset>\n" +
    "\n" +
    "\t\t<div class=\"actions float\">\n" +
    "\t\t\t<button type=\"button\" ng-click =\"back()\" class=\"button blank\">\n" +
    "\t\t\t\tCancel\n" +
    "\t\t\t</button>\n" +
    "\t\t\t<button type=\"button\" ng-click=\"clickedSave()\" class=\"button green\">\n" +
    "\t\t\t\tSave Changes\n" +
    "\t\t\t</button>\n" +
    "\t\t\t<button type=\"button\" ui-sref=\"admin.mapping({hotelId:id})\"  ng-show=\"isAdminSnt && isEdit && data.hotel_pms_type ==='OWS'\" class=\"button green\">\n" +
    "\t\t\t\tMappings\n" +
    "\t\t\t</button>\n" +
    "\t\t\t<button type=\"button\" ui-sref=\"admin.users({id:id})\" ng-show=\"isAdminSnt && isEdit\" class=\"button green\">\n" +
    "\t\t\t\tUser Setup\n" +
    "\t\t\t</button>\n" +
    "\t\t</div>\n" +
    "\n" +
    "\t</form>\n" +
    "\t</section>\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/hotel/adHotelList.html',
    "<section id=\"replacing-div-first\" class=\"content current\" ng-click=\"clearErrorMessage()\">\n" +
    "\t<div data-view=\"HotelListView\">\n" +
    "\t\t<!-- Hotels list -->\n" +
    "\t\t<section>\n" +
    "\t\t\t<header class=\"content-title float\">\n" +
    "\t\t\t\t<h2>Hotels</h2>\n" +
    "\t\t\t\t<span class=\"count\">({{data.hotels.length}})</span>\n" +
    "\t\t\t\t<a ui-sref=\"admin.snthoteldetails({action:'add'})\" class=\"action add\">Add new</a>\n" +
    "\t\t\t</header>\n" +
    "\t\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t\t<table class=\"grid datatable table\" template-pagination=\"nil\" ng-table=\"tableParams\">\n" +
    "\t\t\t\t\t<tbody>\n" +
    "\t\t\t\t\t\t<tr data-hotel-id=\"{{hotel.id}}\" ng-repeat=\"hotel in $data\">\n" +
    "\t\t\t\t\t\t\t<td data-title=\"'Hotel'\" sortable=\"'hotel_name'\" header-class=\"width-40\">\n" +
    "\t\t\t\t\t\t\t\t<a ui-sref=\"admin.snthoteldetails({action:'edit',id:hotel.id})\" class=\"title\">\n" +
    "\t\t\t\t\t\t\t\t\t <strong> {{hotel.hotel_name}} </strong>\n" +
    "\t\t\t\t\t\t\t\t\t <em> {{hotel.city}} , {{hotel.state}} </em>\n" +
    "\t\t\t\t\t\t\t\t</a>\n" +
    "\t\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t\t<td data-title=\"'Room'\" sortable=\"'number_of_rooms'\" header-class=\"width-20\"><span class=\"number\"> {{hotel.number_of_rooms}} </span></td>\n" +
    "\t\t\t\t\t\t\t<td data-title=\"'Chain'\" sortable=\"'chain_name'\" header-class=\"width-20\"> {{hotel.chain_name}} </td>\n" +
    "\t\t\t\t\t\t\t<td data-title=\"'Brand'\" sortable=\"'brand_name'\" header-class=\"width-20\"> {{hotel.brand_name}} </td>\n" +
    "\t\t\t\t\t\t\t<td data-title=\"'Reservation Import'\" class=\"activate long\" header-class=\"width-40\">\n" +
    "\t\t\t\t\t\t\t\t<div class=\"entry\" ng-show=\"hotel.is_external_pms_available ==='true'\">\n" +
    "\t\t\t\t\t\t\t\t\t<label for=\"reservation-import-1\"></label>\n" +
    "\t\t\t\t\t\t\t\t\t<div class=\"switch-button single\" ng-class=\"{ on : hotel.is_res_import_on == 'true' }\" ng-click=\"toggleClicked(hotel)\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<input type=\"checkbox\" name=\"reservation-import\" id=\"reservation-import-1\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<span class=\"switch-icon\"></span>\n" +
    "\t\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t</tr>\n" +
    "\t\t\t\t\t</tbody>\n" +
    "\t\t\t\t</table>\n" +
    "\t\t\t</section>\n" +
    "\t\t</section>\n" +
    "\t</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/hotel/adPmsStartDateCalendarPopup.html',
    "<div ui-date=\"pmsStartDateOptions\" ng-model=\"data.pms_start_date\" ui-date-format=\"mm-dd-yy\"></div>"
  );


  $templateCache.put('/assets/partials/hotelAnnouncementSettings/adHotelAnnounceSettings.html',
    "<section  class=\"content current\" style=\"display: block;\" ng-click=\"clearErrorMessage()\">\n" +
    "\t<div>\n" +
    "\t<header class=\"content-title float\">\n" +
    "\t\t<h2>{{ 'EDIT' | translate }} {{ 'HOTEL_ANNOUNCEMENTS' | translate }}</h2>\n" +
    "\t\t<a id=\"go_back\" data-type=\"load-details\" class=\"action back\" ng-click=\"goBackToPreviousState()\">{{ 'BACK' | translate }}</a>\n" +
    "\t</header>\n" +
    "\t<section class=\"content-scroll\">\n" +
    "\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t<form style=\"overflow-y:auto;\" name=\"edit-hotel-announcement\" method=\"post\" class=\"form float\">\n" +
    "\t\t\t<fieldset class=\"holder column\">\n" +
    "\n" +
    "\t\t\t\t<ad-textarea rows=\"2\" div-class=\"full-width\" value=\"data.guest_zest_welcome_message\" name = \"guest-zest-welcome-message\" id = \"guest-zest-welcome-message\" label = \"{{ 'ZEST_WELCOME_MESSAGE_TITLE' | translate }}\" placeholder = \"Enter Zest Welcome Message\" maxlength=\"200\"></ad-textarea>\n" +
    "\n" +
    "\t\t\t\t<ad-textarea rows=\"2\" div-class=\"full-width\" value=\"data.guest_zest_checkout_complete_message\" name = \"guest-zest-checkout-message\" id = \"guest-zest-checkout-message\" label = \"{{ 'ZEST_CHECKOUT_MESSAGE_TITLE' | translate }}\" placeholder = \"Enter Zest Checkout Message\" maxlength=\"200\" ></ad-textarea>\n" +
    "\n" +
    "\t\t\t\t<ad-textarea rows=\"4\" div-class=\"full-width\" value=\"data.key_delivery_email_message\" name = \"guest-zest-checkout-message\" id = \"guest-zest-key-delivery-email-message\" label = \"{{ 'KEY_DELIVERY_EMAIL_MESSAGE_TITLE' | translate }}\" placeholder = \"Enter Zest Checkout Message\" maxlength=\"500\"></ad-textarea>\n" +
    "\n" +
    "\t\t\t</fieldset>\n" +
    "\t\t\t<div class=\"actions float\">\n" +
    "\t\t\t\t<button type=\"button\" id=\"cancel\" class=\"button blank add-data-inline\" ng-click=\"goBackToPreviousState()\" translate>CANCEL</button>\n" +
    "\t\t\t\t<button type=\"button\" id=\"save_hotel_announcement\" class=\"button green\" ng-click=\"save()\" translate>SAVE_CHANGES</button>\n" +
    "\t\t\t</div>\n" +
    "\t\t</form>\n" +
    "\t</section>\n" +
    "</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/hotelLoyalty/adHotelLoyaltyAdd.html',
    "\n" +
    "\t<!-- Add new Hotel Loyalty Program -->\n" +
    "\t<div style=\"display: block;\" id=\"add-new\" class=\"edit-data\">\n" +
    "\t\t<div class=\"data-holder\">\n" +
    "\t\t\t<form id=\"add-loyalty\" class=\"form inline-form float\">\n" +
    "\t\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t\t<h3><span>{{addEditTitle }}</span> {{'HOTEL_LOYALTY_PROGRAM' | translate}} </h3>\n" +
    "\t\t\t\t\t<em class=\"status\"> {{'MANDATORY_FIELDS_MESSAGE1' | translate}} <strong>*</strong> {{'MANDATORY_FIELDS_MESSAGE2' | translate}} </em>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t\t<fieldset class=\"holder left float\">\n" +
    "\t\t\t\t\t<ad-textbox inputtype=\"text\" value=\"hotelLoyaltyData.name\" \n" +
    "\t\t\t\t\t\tlabel = \"{{'NAME' | translate}}\" placeholder = \"{{'PROGRAM_NAME_PLACEHOLDER'| translate}}\"  \n" +
    "\t\t\t\t\t\tstyleclass=\"full-width\" required=\"yes\"></ad-textbox>\n" +
    "\t\t\t\t\t<ad-textbox inputtype=\"text\" value=\"hotelLoyaltyData.code\" \n" +
    "\t\t\t\t\t\tlabel = \"{{'CODE' | translate}}\" placeholder = \"{{'CODE_NAME_PLACEHOLDER'| translate}}\"  \n" +
    "\t\t\t\t\t\tstyleclass=\"full-width\" required=\"yes\"></ad-textbox>\n" +
    "\t\t\t\t</fieldset>\n" +
    "\t\t\t\t<fieldset class=\"holder right float\">\n" +
    "\t\t\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t\t\t<label for=\"loyalty-option1\" translate> LEVELS </label>\n" +
    "\t\t\t\t\t\t<div class=\"entry\" ng-repeat=\"level in hotelLoyaltyData.levels\">\n" +
    "\t\t\t\t\t\t\t<input type=\"text\"  placeholder=\"{{'ADD_NEW_LEVEL'| translate}}\" name=\"lov\" ng-focus=\"onFocus($index)\" ng-blur=\"onBlur($index)\" ng-change=\"textChanged($index)\" data-type=\"select\" ng-class=\"{'add-new-option': !getEditStatusForLevel($index) }\"\n" +
    "\t\t\t\t\t\t\tng-model=\"level.name\" >\n" +
    "\t\t\t\t\t\t\t<input type=\"text\" ng-model=\"level.value\" ng-hide=\"true\">\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</fieldset>\n" +
    "\t\t\t\t<div class=\"actions float\">\n" +
    "\t\t\t\t\t<button type=\"button\" id=\"cancel\" class=\"button blank add-data-inline\" ng-click=\"clickCancel()\" translate>\n" +
    "\t\t\t\t\t\tCANCEL\n" +
    "\t\t\t\t\t</button>\n" +
    "\t\t\t\t\t<button type=\"button\" id=\"save\" class=\"button green\" ng-click=\"saveHotelLoyalty()\" translate>\n" +
    "\t\t\t\t\t\tSAVE_CHANGES\n" +
    "\t\t\t\t\t</button>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</form>\n" +
    "\t\t</div>\n" +
    "\t</div>\n"
  );


  $templateCache.put('/assets/partials/hotelLoyalty/hotelLoyaltyList.html',
    "<section id=\"replacing-div-first\" class=\"content current\" ng-click=\"clearErrorMessage()\">\n" +
    "\t<div data-view=\"GuestCardHLPView\"  class=\"inline-edit\">\n" +
    "\t\t<header class=\"content-title float\">\n" +
    "\t\t\t<h2 translate> HOTEL_LOYALTY_PROGRAMS </h2>\n" +
    "\t\t\t<span class=\"count\"> (\n" +
    "\t\t\t\t{{data.hotel_loyalty_program.length}}\n" +
    "\t\t\t\t) </span>\n" +
    "\t\t\t<a id=\"add-new-button\" class=\"action add\" ng-click=\"addNewHotelLoyalty()\" translate>ADD_NEW</a>\n" +
    "\t\t</header>\n" +
    "\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t<div id=\"new-form-holder\" ng-show=\"currentClickedElement == 'new'\" ng-include=\"'/assets/partials/hotelLoyalty/adHotelLoyaltyAdd.html'\"></div>\n" +
    "\t\t\t<div id=\"new-form-holder\"></div>\n" +
    "\t\t\t<table id=\"loyalty\" class=\"grid\">\n" +
    "\t\t\t\t<tbody>\n" +
    "\t\t\t\t\t<tr ng-repeat=\"hotelLoyalty in data.hotel_loyalty_program\">\n" +
    "\t\t\t\t\t\t<td ng-click=\"editHotelLoyalty($index,hotelLoyalty.value)\" ng-hide=\"currentClickedElement == $index\">\n" +
    "\t\t\t\t\t\t\t<a class=\"edit-data-inline\">{{hotelLoyalty.name}} </a></td>\n" +
    "\t\t\t\t\t\t<td class=\"activate\" ng-hide=\"currentClickedElement == $index\">\n" +
    "\t\t\t\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t\t\t\t<label for=\"1\"></label>\n" +
    "\t\t\t\t\t\t\t\t<div class=\"switch-button single\" ng-class=\"{ on : hotelLoyalty.is_active == 'true' }\" ng-click=\"activateInactivate(hotelLoyalty.value, hotelLoyalty.is_active, $index)\">\n" +
    "\t\t\t\t\t\t\t\t\t<input type=\"checkbox\" checked=\"checked\">\n" +
    "\t\t\t\t\t\t\t\t\t<span class=\"switch-icon\" ></span>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td colspan=\"2\" ng-include=\"getTemplateUrl($index,hotelLoyalty.value)\"></td>\n" +
    "\t\t\t\t\t</tr>\n" +
    "\t\t\t\t</tbody>\n" +
    "\t\t\t</table>\n" +
    "\t\t</section>\n" +
    "\t</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/hotelSocialLobbySettings/adHotelSocialLobbySettings.html',
    "<section  class=\"content current\" style=\"display: block;\" ng-click=\"clearErrorMessage()\">\n" +
    "\t<div>\n" +
    "\t\t<header class=\"content-title float\">\n" +
    "\t\t\t<h2 translate>SOCIAL_LOBBY_SETUP</h2>\n" +
    "\t\t\t<a id=\"go_back\" data-type=\"load-details\" class=\"action back\" ng-click=\"goBackToPreviousState()\" translate> BACK</a>\n" +
    "\t\t</header>\n" +
    "\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t<form style=\"overflow-y:auto;\" name=\"edit-social-lobby\" method=\"post\" class=\"form float\">\n" +
    "\t\t\t\t<fieldset class=\"holder column\">\n" +
    "\t\t\t\t\t<div></div>\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t\t<ad-toggle-button label=\"{{'SOCIAL_LOBBY' | translate}}\" is-checked=\"data.is_social_lobby_on\" ></ad-toggle-button>\n" +
    "\n" +
    "\t\t\t\t\t<ad-toggle-button label=\"{{'MY_GROUP' | translate}}\" is-checked=\"data.is_my_group_on\" ></ad-toggle-button>\n" +
    "\n" +
    "\t\t\t\t\t<ad-dropdown label=\"{{'ARRIVAL_GRACE_DAYS' | translate}}\"  list=\"arrival_grace_days_list\" selected-Id='data.arrival_grace_days'  id=\"arrival-grace-days\"></ad-dropdown>\n" +
    "\n" +
    "\t\t\t\t\t<ad-dropdown label=\"{{'DEPARTURE_GRACE_DAYS' | translate}}\" list=\"departure_grace_days_list\" selected-Id='data.departure_grace_days'  id=\"departure-grace-days\"></ad-dropdown>\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t</fieldset>\n" +
    "\t\t\t\t<div class=\"actions float\">\n" +
    "\t\t\t\t\t<button type=\"button\" id=\"cancel\" class=\"button blank add-data-inline\" ng-click=\"goBackToPreviousState()\" translate>CANCEL</button>\n" +
    "\t\t\t\t\t<button type=\"button\" id=\"save_social_lobby\" class=\"button green\" ng-click=\"save()\" translate>SAVE_CHANGES</button>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</form>\n" +
    "\t\t</section>\n" +
    "\t</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/housekeeping/adDailyWorkAssignment.html',
    "<section id=\"daily-work-assignment\" class=\"content current\" style=\"display: block;\" ng-click=\"clearErrorMessage()\">\n" +
    "\t<div>\n" +
    "\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\n" +
    "\t\t<header class=\"content-title float\" style=\"position:static;margin:0;\">\n" +
    "\t\t\t<h2 translate>Work Type</h2>\n" +
    "\t\t\t<span class=\"count\">({{ workType.length }})</span>\n" +
    "\t\t\t<a id=\"add-new-button\" class=\"action add ng-scope\" ng-click=\"openWorkTypeForm('new')\" translate=\"\">Add Work Type</a>\n" +
    "\t\t</header>\n" +
    "\t\t<div id=\"new-form-holder-work-type\" ng-show=\"workTypeClickedElement == 'new'\" ng-include=\"'/assets/partials/housekeeping/adHKAddWorkType.html'\"></div>\n" +
    "\t\t<table id=\"task-types\" class=\"grid\">\n" +
    "\t\t\t<tbody>\n" +
    "\t\t\t\t<tr ng-repeat=\"item in workType\">\n" +
    "\t\t\t\t\t<td ng-if=\"!item.is_system\" width=\"50%\" ng-click=\"openWorkTypeForm($index)\" ng-hide=\"workTypeClickedElement == $index\">\n" +
    "\t\t\t\t\t\t<a>{{ item.name }}</a>\n" +
    "\t\t\t\t\t\t<span ng-if=\"item.is_system\" class=\"bold\">{{ item.name }}</span>\n" +
    "\t\t\t\t\t\t<em ng-if=\"item.is_system\">&nbsp;{{ 'SYSTEM_DEFINED' | translate }}</em>\n" +
    "\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t<td ng-if=\"item.is_system\" width=\"50%\">\n" +
    "\t\t\t\t\t\t<span class=\"bold\">{{ item.name }}</span>\n" +
    "\t\t\t\t\t\t<em>&nbsp;{{ 'SYSTEM_DEFINED' | translate }}</em>\n" +
    "\t\t\t\t\t</td>\n" +
    "\n" +
    "\t\t\t\t\t<td class=\"delete\" ng-hide=\"workTypeClickedElement == $index\">\n" +
    "\t\t\t\t\t\t<a ng-if=\"!item.is_system\" ng-click=\"deleteWorkType()\" class=\"icons icon-delete large-icon delete_item\"></a>\n" +
    "\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t<td class=\"activate\" ng-hide=\"workTypeClickedElement == $index\">\n" +
    "\t\t\t\t\t\t<div class=\"entry\" ng-if=\"!item.is_system\">\n" +
    "\t\t\t\t\t\t\t<label></label>\n" +
    "\t\t\t\t\t\t\t<div class=\"switch-button single\"  ng-class=\"{ on : item.is_active}\" ng-click=\"toggleActive()\">\n" +
    "\t\t\t\t\t\t\t\t<input type=\"checkbox\" is_system=\"item.system_defined\" value=\"\" name=\"\" id=\"\">\n" +
    "\t\t\t\t\t\t\t\t<span class=\"switch-icon\"></span>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t<td colspan=\"3\" ng-show=\"workTypeClickedElement == $index\" ng-include=\"'/assets/partials/housekeeping/adHKAddWorkType.html'\"></td>\n" +
    "\t\t\t\t</tr>\n" +
    "\t\t\t</tbody>\n" +
    "\t\t</table>\n" +
    "\n" +
    "\n" +
    "\n" +
    "\n" +
    "\n" +
    "\n" +
    "\t\t<header class=\"content-title float\" style=\"position:static;margin:0;\">\n" +
    "\t\t\t<h2 translate>Task List</h2>\n" +
    "\t\t\t<span class=\"count\">({{ taskList.length }})</span>\n" +
    "\t\t\t<a id=\"add-new-button\" class=\"action add ng-scope\" ng-click=\"openTaskListForm('new')\" translate=\"\">Add Task</a>\n" +
    "\t\t</header>\n" +
    "\t\t<div id=\"new-form-holder-task-list\" ng-show=\"taskListClickedElement == 'new'\" ng-include=\"'/assets/partials/housekeeping/adHKAddToTaskList.html'\"></div>\n" +
    "\t\t<table id=\"task-types\" class=\"grid\">\n" +
    "\t\t\t<tbody>\n" +
    "\t\t\t\t<tr ng-repeat=\"item in taskList\">\n" +
    "\t\t\t\t\t<td width=\"30%\" ng-click=\"openTaskListForm($index)\" ng-hide=\"taskListClickedElement == $index\">\n" +
    "\t\t\t\t\t\t<a ng-class=\"{'bold' : item.is_system}\">{{ item.name }}</a>\n" +
    "\t\t\t\t\t\t<em ng-if=\"item.is_system\">&nbsp;{{'SYSTEM_DEFINED' | translate }}</em>\n" +
    "\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t<td width=\"30%\" ng-hide=\"taskListClickedElement == $index\">\n" +
    "\t\t\t\t\t\t<span>{{ item.work_type_name }}</span>\n" +
    "\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t<td ng-hide=\"taskListClickedElement == $index\">\n" +
    "\t\t\t\t\t\t<span>{{ item.completion_time }}</span>\n" +
    "\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t<td class=\"delete\" ng-hide=\"taskListClickedElement == $index\">\n" +
    "\t\t\t\t\t\t<a ng-if=\"!item.is_system\" ng-click=\"deleteTaskListItem()\" class=\"icons icon-delete large-icon delete_item\"></a>\n" +
    "\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t<td colspan=\"4\" ng-show=\"taskListClickedElement == $index\" ng-include=\"'/assets/partials/housekeeping/adHKAddToTaskList.html'\"></td>\n" +
    "\t\t\t\t</tr>\n" +
    "\t\t\t</tbody>\n" +
    "\t\t</table>\n" +
    "\n" +
    "\n" +
    "\n" +
    "\n" +
    "\n" +
    "\n" +
    "\t\t<header class=\"content-title float\" style=\"position:static;margin:0;\">\n" +
    "\t\t\t<h2 translate>Employee Working Shifts</h2>\n" +
    "\t\t\t<span class=\"count\">({{ workShift.length }})</span>\n" +
    "\t\t\t<a id=\"add-new-button\" class=\"action add ng-scope\" ng-click=\"openWorkShiftForm('new')\" translate=\"\">Add Shift</a>\n" +
    "\t\t</header>\n" +
    "\t\t<div id=\"new-form-holder-work-shift\" ng-show=\"workShiftClickedElement == 'new'\" ng-include=\"'/assets/partials/housekeeping/adHKAddWorkShift.html'\"></div>\n" +
    "\t\t<table id=\"task-types\" class=\"grid\">\n" +
    "\t\t\t<tbody>\n" +
    "\t\t\t\t<tr ng-repeat=\"item in workShift\">\n" +
    "\t\t\t\t\t<td width=\"50%\" ng-click=\"openWorkShiftForm($index)\" ng-hide=\"workShiftClickedElement == $index\">\n" +
    "\t\t\t\t\t\t<a ng-class=\"{'bold' : item.is_system}\">{{ item.name }}</a>\n" +
    "\t\t\t\t\t\t<em ng-if=\"item.is_system\">&nbsp;{{ 'SYSTEM_DEFINED' | translate }}</em>\n" +
    "\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t<td ng-hide=\"workShiftClickedElement == $index\">\n" +
    "\t\t\t\t\t\t<span>{{ item.time }}</span>\n" +
    "\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t<td class=\"delete\" ng-hide=\"workShiftClickedElement == $index\">\n" +
    "\t\t\t\t\t\t<a ng-if=\"!item.is_system\" ng-click=\"deleteWorkShift()\" class=\"icons icon-delete large-icon delete_item\"></a>\n" +
    "\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t<td colspan=\"3\" ng-show=\"workShiftClickedElement == $index\" ng-include=\"'/assets/partials/housekeeping/adHKAddWorkShift.html'\"></td>\n" +
    "\t\t\t\t</tr>\n" +
    "\t\t\t</tbody>\n" +
    "\t\t</table>\n" +
    "\n" +
    "\t</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/housekeeping/adHKAddToTaskList.html',
    "<div class=\"data-holder\">\n" +
    "\t<form id=\"\" class=\"form float\">\n" +
    "\t\t<div class=\"form-title\" style=\"margin-bottom: 25px;\">\n" +
    "\t\t\t<h3>\n" +
    "\t\t\t\t<span ng-if=\"taskListForm == 'add'\">{{'ADD' | translate}}</span> \n" +
    "\t\t\t\t<span ng-if=\"taskListForm == 'edit'\">{{'EDIT' | translate}}</span> \n" +
    "\t\t\t\t Task\n" +
    "\t\t\t</h3>\n" +
    "\t\t\t<em class=\"status\"> <span translate=\"\" class=\"ng-scope\">Fields marked with</span> <strong>*</strong> <span translate=\"\" class=\"ng-scope\">are mandatory!</span> </em>\n" +
    "\t\t</div>\n" +
    "\n" +
    "\t\t<fieldset class=\"holder left float\">\n" +
    "\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t<label>Task <strong> * </strong></label>\n" +
    "\t\t\t\t<input type=\"text\" placeholder=\"Enter the task name\" ng-model=\"eachTaskList.name\">\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t<label>Work Type <strong> * </strong></label>\n" +
    "\t\t\t\t<div class=\"select\">\n" +
    "\t\t\t\t\t<select class=\"daily-task-worktype\" ng-model=\"eachTaskList.work_type_id\" ng-options=\"item.id as item.name for item in workType\">\n" +
    "\t\t\t\t\t\t<option value=\"\" class=\"placeholder\">Choose work type</option>\n" +
    "\t\t\t\t\t</select>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t    <label for=\"item-type\">Room Type <strong>*</strong></label>\n" +
    "\t\t\t    <div class=\"boxes\">\n" +
    "\t\t\t        <label class=\"checkbox inline\" ng-repeat=\"item in roomTypesList\">\n" +
    "\t\t\t            <span class=\"icon-form icon-checkbox\" ng-class=\"{'checked' : eachTaskList.room_type_ids[$index]}\"></span>\n" +
    "\t\t\t            <input type=\"checkbox\" ng-model=\"eachTaskList.room_type_ids[$index]\">\n" +
    "\t\t\t            {{ item.name }}\n" +
    "\t\t\t        </label>\n" +
    "\t\t\t    </div>\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t    <label for=\"item-type\">Reservation status <strong>*</strong></label>\n" +
    "\t\t\t    <div class=\"boxes\">\n" +
    "\t\t\t        <label class=\"checkbox inline\" ng-repeat=\"item in resHkStatusList\">\n" +
    "\t\t\t            <span class=\"icon-form icon-checkbox\" ng-class=\"{'checked' : eachTaskList.reservation_statuses_ids[$index]}\"></span>\n" +
    "\t\t\t            <input type=\"checkbox\" ng-model=\"eachTaskList.reservation_statuses_ids[$index]\">\n" +
    "\t\t\t            {{ item.description }}\n" +
    "\t\t\t        </label>\n" +
    "\t\t\t    </div>\n" +
    "\t\t\t</div>\n" +
    "\t\t</fieldset>\n" +
    "\n" +
    "\t\t<fieldset class=\"holder right float\">\t\t\t\n" +
    "\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t    <label for=\"item-type\">Fo status <strong>*</strong></label>\n" +
    "\t\t\t    <div class=\"boxes\">\n" +
    "\t\t\t        <label class=\"checkbox inline\" ng-repeat=\"item in foStatusList\">\n" +
    "\t\t\t            <span class=\"icon-form icon-checkbox\" ng-class=\"{'checked' : eachTaskList.front_office_status_ids[$index]}\"></span>\n" +
    "\t\t\t            <input type=\"checkbox\" ng-model=\"eachTaskList.front_office_status_ids[$index]\">\n" +
    "\t\t\t            {{ item.description }}\n" +
    "\t\t\t        </label>\n" +
    "\t\t\t    </div>\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t<label>Task completion time</label>\n" +
    "\t\t\t\t<div class=\"entry full-width float\">\n" +
    "\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\t\t\t\t\t\t<select ng-model=\"eachTaskList.hours\" class=\"styled\" ng-change=\"updateIndividualTimes()\">\n" +
    "\t\t\t\t\t\t\t<option value=\"\" data-text=\"Not set\" class=\"placeholder\">HH</option>\n" +
    "\t\t\t\t\t\t\t<option ng-repeat=\"i in [0, 12, 1, 2] | makeRange\" value=\"{{i}}\" ng-selected=\"i==eachTaskList.hours\">{{i}}</option>\n" +
    "\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\t\t\t\t\t\t<select ng-model=\"eachTaskList.mins\" ng-change=\"updateIndividualTimes()\">\n" +
    "\t\t\t\t\t\t\t<option value=\"\" data-text=\"Not set\" class=\"placeholder\">MM</option>\n" +
    "\t\t\t\t\t\t\t<option ng-repeat=\"i in [0, 45, 15, 2] | makeRange\" value=\"{{i}}\" ng-selected=\"i==eachTaskList.mins\">{{i}}</option>\n" +
    "\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t<label>Task completion HK status</label>\n" +
    "\t\t\t\t<div class=\"select\">\n" +
    "\t\t\t\t\t<select ng-model=\"eachTaskList.task_completion_hk_status_id\" ng-options=\"item.id as item.description for item in HkStatusList\">\n" +
    "\t\t\t\t\t\t<option value=\"\" class=\"placeholder\">Choose HK status</option>\n" +
    "\t\t\t\t\t</select>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</div>\n" +
    "\t\t</fieldset>\n" +
    "\n" +
    "\t\t<fieldset style=\"clear:both; width:80%;\" ng-if=\"(eachTaskList.room_type_ids | filter:anySelected(true)).length\">\n" +
    "\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t<label>Task completion Time (Individual rooms)</label>\n" +
    "\t\t\t\t<div class=\"boxes\">\n" +
    "\t\t\t\t\t<div ng-repeat=\"room in roomTypesList\" ng-show=\"eachTaskList.room_type_ids[$index]\">\t\t\t\t\n" +
    "\t\t\t\t\t\t<div class=\"float\">\n" +
    "\t\t\t\t\t\t\t<div class=\"select select-col col1-4 no-bg\">\n" +
    "\t\t\t\t\t\t\t\t<span>{{room.name}}</span>\n" +
    "\t\t\t\t\t\t\t</div>\t\t\t\n" +
    "\t\t\t\t\t\t\t<div class=\"select select-col col1-4\">\n" +
    "\t\t\t\t\t\t\t\t<select ng-model=\"eachTaskList.rooms_task_completion[room.id].hours\" class=\"styled\">\n" +
    "\t\t\t\t\t\t\t\t\t<option value=\"\" data-text=\"Not set\" class=\"placeholder\">HH</option>\n" +
    "\t\t\t\t\t\t\t\t\t<option ng-repeat=\"i in [0, 12, 1, 2] | makeRange\" value=\"{{i}}\" ng-selected=\"i==eachTaskList.rooms_task_completion[room.id].hours\">{{i}}</option>\n" +
    "\t\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t<div class=\"select select-col col1-4\">\n" +
    "\t\t\t\t\t\t\t\t<select ng-model=\"eachTaskList.rooms_task_completion[room.id].mins\">\n" +
    "\t\t\t\t\t\t\t\t\t<option value=\"\" data-text=\"Not set\" class=\"placeholder\">MM</option>\n" +
    "\t\t\t\t\t\t\t\t\t<option ng-repeat=\"i in [0, 45, 15, 2] | makeRange\" value=\"{{i}}\" ng-selected=\"i==eachTaskList.rooms_task_completion[room.id].mins\">{{i}}</option>\n" +
    "\t\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t<div class=\"select select-col col1-4 no-bg\" ng-show=\"checkCopyBtnShow(room.id)\">\n" +
    "\t\t\t\t\t\t\t\t<button type=\"button\" class=\"button green edit-data-inline\" ng-click=\"copyNpaste(room.id)\">Copy paste</button>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t</div>\t\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</div>\n" +
    "\t\t</fieldset>\n" +
    "\n" +
    "\n" +
    "\t\t<div class=\"actions float\">\n" +
    "\t\t\t<button type=\"button\" class=\"button blank edit-data-inline\" ng-click=\"closeTaskListForm()\" translate>CANCEL</button>\n" +
    "\n" +
    "\t\t\t<button ng-if=\"taskListForm == 'add'\" type=\"button\" class=\"button green edit-data-inline\" ng-click=\"addTaskListItem()\" translate>SAVE_CHANGES</button>\n" +
    "\t\t\t<button ng-if=\"taskListForm == 'edit'\" type=\"button\" class=\"button green edit-data-inline\" ng-click=\"updateTaskListItem()\" translate>SAVE_CHANGES</button>\n" +
    "\n" +
    "\t\t\t<button ng-if=\"taskListForm == 'edit'\" ng-hide=\"chosenItem.newItem\" type=\"button\" class=\"button red edit-data-inline\" ng-click=\"deleteTaskListItem()\" translate>DELETE</button>\n" +
    "\t\t</div>\n" +
    "\t</form>\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/housekeeping/adHKAddWorkShift.html',
    "<div class=\"data-holder\">\n" +
    "\t<form class=\"form float\">\n" +
    "\t\t<div class=\"form-title\" style=\"margin-bottom: 25px;\">\n" +
    "\t\t\t<h3>\n" +
    "\t\t\t\t<span ng-if=\"workShiftForm == 'add'\">{{'ADD' | translate}}</span> \n" +
    "\t\t\t\t<span ng-if=\"workShiftForm == 'edit'\">{{'EDIT' | translate}}</span> \n" +
    "\t\t\t\t Work Shift\n" +
    "\t\t\t</h3>\n" +
    "\t\t\t<em class=\"status\"> <span translate=\"\" class=\"ng-scope\">All Fields</span> <span translate=\"\" class=\"ng-scope\">are mandatory!</span> </em>\n" +
    "\t\t</div>\n" +
    "\n" +
    "\t\t<fieldset class=\"holder left float\">\n" +
    "\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t<label>Shift Name</label>\n" +
    "\t\t\t\t<input type=\"text\" placeholder=\"Enter shift name\" ng-model=\"eachWorkShift.name\">\n" +
    "\t\t\t</div>\n" +
    "\t\t</fieldset>\n" +
    "\n" +
    "\t\t<fieldset class=\"holder right float\">\n" +
    "\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t<label>Time</label>\n" +
    "\t\t\t\t<div class=\"entry full-width float\">\n" +
    "\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\t\t\t\t\t\t<select ng-model=\"eachWorkShift.hours\" class=\"styled\">\n" +
    "\t\t\t\t\t\t\t<option value=\"00\" data-text=\"Not set\" class=\"placeholder\">HH</option>\n" +
    "\t\t\t\t\t\t\t<option ng-repeat=\"i in [1, 12, 1, 2] | makeRange\" value=\"{{i}}\" ng-selected=\"i==eachWorkShift.hours\">{{i}}</option>\n" +
    "\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\t\t\t\t\t\t<select ng-model=\"eachWorkShift.mins\">\n" +
    "\t\t\t\t\t\t\t<option value=\"00\" data-text=\"Not set\" class=\"placeholder\">MM</option>\n" +
    "\t\t\t\t\t\t\t<option ng-repeat=\"i in [0, 45, 15, 2] | makeRange\" value=\"{{i}}\" ng-selected=\"i==eachWorkShift.mins\">{{i}}</option>\n" +
    "\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</div>\n" +
    "\t\t</fieldset>\n" +
    "\n" +
    "\t\t<div class=\"actions float\">\n" +
    "\t\t\t<button type=\"button\" class=\"button blank edit-data-inline\" ng-click=\"closeWorkShiftForm()\" translate>CANCEL</button>\n" +
    "\n" +
    "\t\t\t<button ng-if=\"workShiftForm == 'add'\" type=\"button\" class=\"button green edit-data-inline\" ng-click=\"addWorkShift()\" translate>SAVE_CHANGES</button>\n" +
    "\t\t\t<button ng-if=\"workShiftForm == 'edit'\" type=\"button\" class=\"button green edit-data-inline\" ng-click=\"updateWorkShift()\" translate>SAVE_CHANGES</button>\n" +
    "\n" +
    "\t\t\t<button ng-if=\"workShiftForm == 'edit'\" ng-hide=\"chosenItem.newItem\" type=\"button\" class=\"button red edit-data-inline\" ng-click=\"deleteWorkShift()\" translate>DELETE</button>\n" +
    "\t\t</div>\n" +
    "\t</form>\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/housekeeping/adHKAddWorkType.html',
    "<div class=\"data-holder\">\n" +
    "\t<form class=\"form single-field-form float\">\n" +
    "\t\t<div class=\"form-title\" style=\"margin-bottom: 20px;\">\n" +
    "\t\t\t<h3>\n" +
    "\t\t\t\t<span ng-if=\"workTypeForm == 'add'\">{{'ADD' | translate}}</span> \n" +
    "\t\t\t\t<span ng-if=\"workTypeForm == 'edit'\">{{'EDIT' | translate}}</span> \n" +
    "\t\t\t\t Work Type\n" +
    "\t\t\t</h3>\n" +
    "\t\t\t<em class=\"status\"> <span translate=\"\" class=\"ng-scope\">All Fields</span> <span translate=\"\" class=\"ng-scope\">are mandatory!</span> </em>\n" +
    "\t\t</div>\n" +
    "\n" +
    "\t\t<div class=\"entry\"><input type=\"text\" placeholder=\"Enter task type\" ng-model=\"eachWorkType.name\"></div>\n" +
    "\n" +
    "\t\t<div class=\"actions float\">\n" +
    "\t\t\t<button type=\"button\" class=\"button blank edit-data-inline\" ng-click=\"closeWorkTypeForm()\" translate>\n" +
    "\t\t\t\tCANCEL \n" +
    "\t\t\t</button>\n" +
    "\n" +
    "\t\t\t<button ng-if=\"workTypeForm == 'add'\" type=\"button\" class=\"button green edit-data-inline\" ng-click=\"addWorkType()\" translate>\n" +
    "\t\t\t\tSAVE_CHANGES\n" +
    "\t\t\t</button>\n" +
    "\t\t\t<button ng-if=\"workTypeForm == 'edit'\" type=\"button\" class=\"button green edit-data-inline\" ng-click=\"updateWorkType()\" translate>\n" +
    "\t\t\t\tSAVE_CHANGES\n" +
    "\t\t\t</button>\n" +
    "\n" +
    "\t\t\t<button ng-if=\"workTypeForm == 'edit'\" ng-hide=\"chosenItem.newItem\" type=\"button\" class=\"button red edit-data-inline\" ng-click=\"deleteWorkType()\" translate>\n" +
    "\t\t\t\tDELETE\n" +
    "\t\t\t</button>\n" +
    "\t\t</div>\n" +
    "\t</form>\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/housekeeping/adHousekeeping.html',
    "<section  class=\"content current\" style=\"display: block;\" ng-click=\"clearErrorMessage()\">\n" +
    "\t<div>\n" +
    "\t\t<header class=\"content-title float\">\n" +
    "\t\t\t<h2 translate>HOUSEKEEPING_SETTINGS</h2>\n" +
    "\t\t</header>\n" +
    "\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t<form style=\"overflow-y:auto;\"  method=\"post\" class=\"form float\">\n" +
    "\t\t\t\t<fieldset class=\"holder left\">\n" +
    "\t\t\t\t\t<ad-toggle-button label=\"{{'USE_INSPECTED_ROOM_STATUS' | translate}}\" is-checked=\"data.use_inspected\" div-class=\"\"></ad-toggle-button>\n" +
    "\t\t\t\t\t<ad-toggle-button label=\"{{'USE_PICKUP_ROOM_STATUS' | translate}}\" is-checked=\"data.use_pickup\" div-class=\"\"></ad-toggle-button>\n" +
    "\t\t\t\t\t<ad-toggle-button label=\"{{'ENABLE_QUEUE_ROOMS' | translate}}\" is-checked=\"data.is_queue_rooms_on\" div-class=\"\"></ad-toggle-button>\n" +
    "\t\t\t\t\t<ad-textarea rows=\"4\" div-class=\"full-width\" text-area-class=\"full-width\" value=\"data.email\" label = \"{{'EMAIL_ACCOUNTS_TO_RECIEVE_QUEUE_RES_ALERT'| translate}} \" placeholder = \"{{'EMAIL_ACCOUNTS_TO_RECIEVE_QUEUE_RES_ALERT'|translate }}\" disabled=\"!data.is_queue_rooms_on\" ></ad-textarea>\t\n" +
    "\t\t\t\t\t<ad-checkbox is-disabled=\"!data.use_inspected\" is-checked=\"data.checkin_inspected_only\" label=\"{{'CHECK_IN_TO_INSPECTED_ROOMS_ONLY' | translate}}\" div-class=\"full-width\"></ad-checkbox>\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t\t<ad-checkbox is-checked=\"data.enable_room_status_at_checkout\" label=\"{{'ROOM_STATUS_UPDATE_CHECKOUT_LABEL' | translate}}\" div-class=\"full-width\"></ad-checkbox>\n" +
    "\t\t\t\t</fieldset>\n" +
    "\t\t\t\t\n" +
    "\t\t\t\t<div class=\"actions float\">\n" +
    "\t\t\t\t\t<button type=\"button\" id=\"cancel\" class=\"button blank add-data-inline\" ng-click=\"backClicked()\" translate>CANCEL</button>\n" +
    "\t\t\t\t\t<button type=\"button\" id=\"save_social_lobby\" class=\"button green\" ng-click=\"save()\" translate>SAVE_CHANGES</button>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</form>\n" +
    "\t\t</section>\n" +
    "\t</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/iBeaconSettings/adiBeaconDetails.html',
    "<section id=\"replacing-div-second\" class=\"content current\" ng-hide=\"isLoading\" ng-click=\"clearErrorMessage()\"><div data-view=\"ZestCheckinConfiguration\" >\n" +
    "\t<header class=\"content-title float\">\n" +
    "\t\t<h2>{{displayMessage}}</h2>\n" +
    "\t\t<a ng-click=\"goBackToPreviousState()\" class=\"action back\" translate=\"BACK\"></a>\n" +
    "\t</header>\n" +
    "\t<section class=\"content-scroll\">\n" +
    "\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"  ></div>\n" +
    "\t<div ng-include=\"'/assets/partials/common/notification_success_message.html'\"  ></div>\n" +
    "\t<!--- form starts here -->\n" +
    "\t<form style=\"overflow-y:auto;\" class=\"form float inline-form\" >\n" +
    "\t\t<fieldset class=\"holder left\">\t\t\t\t\n" +
    "\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t<label>{{'BEACON_ID'|translate}} <strong>*</strong></label>\n" +
    "\t\t\t\t<input type=\"text\"  class=\"proximity-field\" placeholder=\"{{'PROXIMITY_ID_PLACEHOLDER'|translate}}\" disabled ng-model=\"data.proximity_id\">\n" +
    "\t\t\t\t<input type=\"text\" class=\"majorid-field\" placeholder=\"{{'MAJOR_ID_PLACEHOLDER'|translate}}\" disabled ng-model=\"data.major_id\">\n" +
    "\t\t\t\t<input type=\"text\" class=\"majorid-field\" placeholder=\"{{'MINOR_ID_PLACEHOLDER'|translate}}\" disabled ng-model=\"data.minor_id\">\t\t\t\t\t\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t<label>&nbsp;&nbsp;</label>\n" +
    "\t\t\t\t<button type=\"button\" ng-disabled=\"data.uuid.length===0 || !isIpad || isBeaconLinked\" class=\"button\" ng-class=\"{ 'brand-colors' :data.proximity_id.length>0 && data.minor_id.length>0 && data.major_id.length>0 && isIpad && addmode &&  !isBeaconLinked, 'red' :data.proximity_id.length>0 && data.minor_id.length>0 && data.major_id.length>0 && isIpad && !addmode &&  !isBeaconLinked}\" translate=\"LINK_BEACON\" ng-click=\"linkiBeacon()\"></button>\n" +
    "\t\t\t</div> \t\n" +
    "\t\t</fieldset>\n" +
    "\t\t<fieldset class=\"holder right\">\n" +
    "\t\t\t<ad-textbox inputtype=\"text\" value=\"data.location\" label = \"{{ 'LOCATION' | translate }}\" placeholder = \"{{'ENTER_LOCATION'|translate}}\" required=\"yes\"></ad-textbox>\t\t\t \n" +
    "\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t<label>{{'TYPE'|translate}} <strong>*</strong></label>\n" +
    "\t\t\t\t<div class=\"select\">\n" +
    "\t\t\t\t\t<select class=\"placeholder\" ng-model=\"data.type\" ng-options=\"ibeacon.value as ibeacon.value for ibeacon in beaconTypes\">\n" +
    "\t\t\t\t\t\t<option value=\"\" disabled translate=\"SELECT_TYPE\"></option>\n" +
    "\t\t\t\t\t</select>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</div>  \n" +
    "\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t<label>{{'TRIGGER'|translate}} <strong>*</strong></label>\n" +
    "\t\t\t\t\t<div class=\"select\">\n" +
    "\t\t\t\t\t\t<select class=\"placeholder\" ng-model=\"data.trigger_range\" ng-options=\"trigger.value as trigger.value for trigger in triggerTypes\">\n" +
    "\t\t\t\t\t\t\t<option value=\"\" disabled translate=\"SELECT_TRIGGER\"></option>\n" +
    "\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t<label ng-hide=\"label.length ==0\" for=\"\" translate=\"STATUS\"></label>\n" +
    "\t\t\t\t\t<div class=\"switch-button single\" ng-class=\"{'on': data.status}\">\n" +
    "\t\t\t\t\t\t<input type=\"checkbox\"  ng-click=\"toggleStatus()\">\n" +
    "\t\t\t\t\t\t<span class=\"switch-icon\"></span>\n" +
    "\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</div>\t\t\t\t\n" +
    "\t\t</fieldset>\n" +
    "\t\t<fieldset class=\"holder left\">\n" +
    "\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t<label>{{'NEARBY_BEACONS'|translate}}</label>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<select multiple ng:model=\"data.neighbours\" ng-options=\"beaconNeighbour.beacon_id as beaconNeighbour.location for beaconNeighbour in beaconNeighbours\" >\n" +
    "\t \t\t </select>\n" +
    " \t</fieldset>\n" +
    "\t\t\t<div class=\"form-title\" style=\"margin-bottom:32px;\">\n" +
    "\t\t\t\t<h3><span translate=\"GUEST_MESSAGE\"></span></h3>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<fieldset class=\"holder left\" ng-hide=\"data.type !='PROMOTION'\">\n" +
    "\t\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t\t<label for=\"room-type-picture\" translate=\"PICTURE\"></label>\n" +
    "\t\t\t\t\t<div class=\"file-upload with-preview\">\n" +
    "\t\t\t\t\t\t<span class=\"input\" >{{fileName}}</span>\n" +
    "\t\t\t\t\t\t<input type=\"file\" ng-model=\"data.picture\" accept=\"image/*\" app-filereader />\n" +
    "\t\t\t\t\t\t<button type=\"button\" class=\"button brand-colors\" translate=\"PICTURE\">\n" +
    "\t\t\t\t\t\t</button> \n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t<span class=\"file-preview\"><img ng-src=\"{{data.picture}}\" id=\"file-preview\" alt=\"\"> </span>\n" +
    "\t\t\t\t</div> \n" +
    "\t\t\t</fieldset>\n" +
    "\t\t\t\n" +
    "\t\t\t<fieldset class=\"holder left\" ng-show=\"data.type !='PROMOTION'\">\n" +
    "\t\t\t\t<ad-textbox inputtype=\"text\" styleclass=\"full-width\" value=\"data.message\" label = \"{{ 'MESSAGE' | translate }}\" placeholder = \"{{'ENTER_MESSAGE'|translate}}\" required=\"no\"></ad-textbox>\n" +
    "\t\t\t</fieldset>\n" +
    "\n" +
    "\t\t\t<fieldset class=\"holder right\" ng-hide=\"data.type !='PROMOTION'\">\n" +
    "\t\t\t\t<ad-textbox inputtype=\"text\" styleclass=\"full-width\" value=\"data.title\" label = \"{{ 'TITLE' | translate }}\" placeholder = \"{{'ENTER_TITLE'|translate}}\" required=\"no\"></ad-textbox>\n" +
    "\t\t\t\t<ad-textarea rows=\"4\" div-class=\"full-width\" text-area-class=\"full-width\" value=\"data.description\" label = \"{{ 'DESCRIPTION' | translate }}\" maxlength=\"200\" placeholder = \"{{'ENTER_DESCRIPTION'|translate}}\"></ad-textarea>\n" +
    "\t\t\t</fieldset>\n" +
    "\t\t\t<div class=\"actions float\">\n" +
    "\n" +
    "\t\t\t\t<button type=\"button\" ng-click=\"backClicked()\" class=\"button blank add-data-inline actions_margin_top\" translate=\"CANCEL\"></button>\n" +
    "\t\t\t\t<button type=\"button\" ng-click=\"saveBeacon()\" class=\"button green actions_margin_top\" translate=\"SAVE_CHANGES\"></button>\n" +
    "\t\t\t</div>\n" +
    "\t\t</form>\n" +
    "\t\t</section>\n" +
    "<!--- form ends here -->\n" +
    "\t</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/iBeaconSettings/adibeaconSettings.html',
    "<section class=\"content current\" ng-click='clearErrorMessage()'>\n" +
    "\t<div>\n" +
    "\t\t<header class=\"content-title float\">\n" +
    "\t\t\t<h2 translate=\"IBEACON_SETUP\"></h2>\n" +
    "\t\t\t<span class=\"count\"> ({{totalCount}}) </span>\n" +
    "\t\t\t<a class=\"action add\" ui-sref=\"admin.iBeaconNewDetails({action:'add'})\" ng-click=\"showLoader()\" ng-show=\"isIpad\" translate=\"ADD_NEW_SMALL\"></a>\n" +
    "\t\t\t<a class=\"action back\" ng-click=\"goBackToPreviousState()\"translate=\"BACK\"></a>\n" +
    "\t\t</header>\n" +
    "\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_success_message.html'\"></div>\n" +
    "\n" +
    "\t\t\t<div id=\"new-form-holder\"></div>\n" +
    "\t\t\t<!--ng-table component -->\n" +
    "\t\t\t<table class=\"grid\" ng-table=\"tableParams\" template-pagination=\"custom/pager\">\n" +
    "\t\t\t\t<tbody>\n" +
    "\t\t\t\t\t<tr ng-repeat=\"ibeacon in $data\" ng-class = \"{'inactive': !ibeacon.status}\"> \n" +
    "\t\t\t\t\t\t<td data-title=\"'Location'\" sortable=\"'location'\" header-class=\"width-15\">\n" +
    "\t\t\t\t\t\t\t<a ui-sref='admin.iBeaconDetails({action:ibeacon.beacon_id})' class=\"edit-data beacon-id\" ng-click=\"showLoader()\">\n" +
    "\t\t\t\t\t\t\t\t<strong> {{ibeacon.location}}</strong>\n" +
    "\t\t\t\t\t\t\t</a>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td data-title=\"'ID'\"  sortable=\"'beacon_id'\" header-class=\"width-10\">\n" +
    "\t\t\t\t\t\t\t<a ui-sref='admin.iBeaconDetails({action:ibeacon.beacon_id})' class=\"edit-data beacon-id\" ng-click=\"showLoader()\">\n" +
    "\t\t\t\t\t\t\t\t{{proximityId}}{{majorId}}{{ibeacon.minor_id}}\n" +
    "\t\t\t\t\t\t\t</a>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td data-title=\"'Type'\" sortable=\"'beacon_type'\" header-class=\"width-15\">\n" +
    "\t\t\t\t\t    \t<div class=\"entry\">                     \n" +
    "\t\t\t\t                </div>\t\n" +
    "\t\t\t\t                <strong>{{ibeacon.type}}</strong>\n" +
    "\t\t              \t\t</div>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td data-title=\"'Status'\" sortable=\"'status'\" ng-class = \"{'green': ibeacon.beacon_status}\" header-class=\"width-15\">\n" +
    "\t\t\t\t\t\t\t<div class=\"entry\" >\n" +
    "\t\t\t\t\t\t\t\t<div class=\"switch-button single\" ng-class=\"{'on': ibeacon.status}\" ng-click=\"toggleActive(ibeacon.beacon_id,ibeacon.status)\">\n" +
    "\t\t\t\t\t\t\t\t\t<input type=\"checkbox\"  ng-checked=\"ibeacon.status\">\n" +
    "\t\t\t\t\t\t\t\t\t<span class=\"switch-icon\"></span>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td data-title=\"'Delete'\" header-class=\"width-15\">\n" +
    "\t\t\t\t\t\t\t <span class=\"icons icon-delete large-icon cursor_pointer\" ng-click=\"deleteBeacon(ibeacon.beacon_id)\"  ng-hide=\"false\">&nbsp;</span>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t</tr>\n" +
    "\t\t\t\t</tbody>\n" +
    "\t\t\t</table>\n" +
    "\t\t</section>\n" +
    "\t\t<!--end -->\n" +
    "\n" +
    "\t\t<!--Custom pagination footer goes here-->\n" +
    "\t\t<script type=\"text/ng-template\" id=\"custom/pager\">\n" +
    "\t\t\t<div class = \"pager\">\n" +
    "\t\t\t\t<span ng-show=\"totalCount>0\">Showing {{startCount}} to {{endCount}} of {{totalCount}} items</span>\n" +
    "\t\t\t\t<span ng-show=\"totalCount==0\">Showing 0 items</span>\n" +
    "\t\t\t\t<ul class=\"ng-cloak\">\n" +
    "\t              \t<li ng-repeat=\"page in pages\"\n" +
    "\t\t                ng-class=\"{'previous': page.type == 'prev', 'next': page.type == 'next'}\"\n" +
    "\t\t                ng-show=\"page.type == 'prev' || page.type == 'next'\" ng-switch=\"page.type\">\n" +
    "\t\n" +
    "\t\t                <a ng-switch-when=\"prev\" ng-click=\"params.page(1)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">First</a>\n" +
    "\t\t                <a ng-switch-when=\"prev\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">Previous</a>\n" +
    "\t\t                <a ng-switch-when=\"prev\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">{{page.number}}</a>\n" +
    "\t\t                \n" +
    "\t\t                <a ng-switch-when=\"next\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">{{page.number}}</a>\n" +
    "\t\t                <a ng-switch-when=\"next\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">Next</a>\n" +
    "\t\t                <a ng-switch-when=\"next\" ng-click=\"params.page(totalPage)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">Last</a>\n" +
    "\t\t          \t</li>\n" +
    "\t            </ul>\n" +
    "\t        </div>\n" +
    "\t\t</script>\n" +
    "\t\t<!--end-->\n" +
    "\t</div>\n" +
    "</section>\n" +
    "\n"
  );


  $templateCache.put('/assets/partials/icare/adIcareServices.html',
    "<section id=\"replacing-div-first\" class=\"content current\" ng-click=\"clearErrorMessage()\">\n" +
    "\t<div id=\"selected_hotel\" data-view=\"ICareServicesView\">\n" +
    "\t\t<section>\n" +
    "\t\t\t<header class=\"content-title float\">\n" +
    "\t\t\t\t<h2 translate>ICARE_SERVICES</h2>\n" +
    "\t\t\t\t<a class=\"action back\"  ng-click=\"goBackToPreviousState()\" translate>BACK</a>\n" +
    "\t\t\t</header>\n" +
    "\t\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t\t<form name=\"icare-services\" method=\"post\" class=\"form float\" action=\"\">\n" +
    "\n" +
    "\t\t\t\t\t<fieldset class=\"holder left\">\n" +
    "\t\t\t\t\t\t<ad-toggle-button is-checked=\"icare.icare_enabled\" label=\"{{'iCARE_ON_OFF' | translate}}\" div-class=\"full-width\"></ad-toggle-button>\n" +
    "\t\t\t\t\t</fieldset>\n" +
    "\t\t\t\t\t<fieldset class=\"holder right\">\n" +
    "\t\t\t\t\t\t<ad-toggle-button is-checked=\"icare.save_customer_info\" label=\" {{'SAVE_GUEST_NAME_TO_ICARE' | translate}}\" div-class=\"full-width\"></ad-toggle-button>\n" +
    "\t\t\t\t\t\t<ad-toggle-button is-checked=\"icare.combined_key_room_charge_create\" label=\"{{'COMBINED_KEY_ROOM_CHARGE'| translate}}\" div-class=\"full-width\"></ad-toggle-button>\n" +
    "\t\t\t\t\t</fieldset>\n" +
    "\n" +
    "\t\t\t\t\t<fieldset class=\"holder left\">\n" +
    "\t\t\t\t\t\t<ad-textbox value=\"icare.icare_url\" name = \"access-url\" label = \"{{'ICARE_ACCESS_URL'| translate}}\" placeholder = \"{{'ENTER_ICARE_ACCESS_URL'| translate}}\" required = \"yes\" styleclass=\"full-width\"></ad-textbox>\n" +
    "\t\t\t\n" +
    "\t\t\t\t\t\t<ad-textbox value=\"icare.icare_username\" name = \"icare-username\" label = \"{{'iCARE_USERNAME'| translate}}\" placeholder = \"{{'ENTER_iCARE_USERNAME'| translate}}\" required = \"yes\" styleclass=\"full-width\"></ad-textbox>\n" +
    "\t\t\t\n" +
    "\t\t\t\t\t\t<ad-textbox value=\"icare.icare_password\" name = \"icare-password\" label = \"{{'iCARE_PASSWORD'| translate}}\" placeholder = \"{{'ENTER_iCARE_PASSWORD'| translate}}\" required = \"yes\" styleclass=\"full-width\" inputtype=\"password\"></ad-textbox>\n" +
    "\t\t\t\n" +
    "\t\t\t\t\t\t<ad-textbox value=\"icare.icare_account_preamble\" name = \"account-prefix\" label = \"{{'iCARE_ACCOUNT_PRE_FIX'| translate}}\" placeholder = \"{{'ENTER_iCARE_ACCOUNT_PRE_FIX'| translate}}\" styleclass=\"full-width\"></ad-textbox>\n" +
    "\t\t\t\n" +
    "\t\t\t\t\t\t<ad-textbox value=\"icare.icare_account_length\" name = \"account-length\" label = \"{{'iCARE_ACCOUNT_LENGTH'| translate}}\" placeholder = \"{{'iCARE_ACCOUNT_LENGTH'| translate}}\" required = \"yes\" styleclass=\"full-width\"></ad-textbox>\n" +
    "\t\t\t\t\t</fieldset>\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t\t<fieldset class=\"holder right\">\n" +
    "\t\t\t\t\t\t<ad-dropdown label=\"Debit Charge Code\" div-class=\"full-width\" label-in-drop-down=\"{{'iCARE_DEBIT_CHARGE_CODE'| translate}}\" list=\"icare.charge_codes\" selected-Id=\"icare.icare_debit_charge_code_id\"  required='yes' ></ad-dropdown>\n" +
    "\t\t\t\t\t\t<ad-dropdown label=\"Credit Charge Code\" div-class=\"full-width\" label-in-drop-down=\"{{'iCARE_CREDIT_CHARGE_CODE'| translate}}\" list=\"icare.charge_codes\" selected-Id=\"icare.icare_credit_charge_code_id\"  required='yes' ></ad-dropdown>\n" +
    "\t\t\t\t\t\t<ad-textbox value=\"icare.pms_alert_code\" name = \"account-length\" label = \"{{'FIXED_BAND_PMS_ALERT_CODE'| translate}}\" placeholder = \"{{'ENTER_FIXED_BAND_PMS_ALERT_CODE'| translate}}\" required = \"yes\" styleclass=\"full-width\"></ad-textbox>\n" +
    "\t\t\t\t\t\t\n" +
    "\t\t\t\t\t</fieldset>\n" +
    "\t\t\t\t\t\t\n" +
    "\t\t\t\t\t<div class=\"actions float\">\n" +
    "\t\t\t\t\t\t<button type=\"button\" class=\"button blank\" ng-click=\"goBackToPreviousState()\" translate>\n" +
    "\t\t\t\t\t\t\tCANCEL\n" +
    "\t\t\t\t\t\t</button>\n" +
    "\t\t\t\t\t\t<button type=\"button\" class=\"button green\" ng-click=\"saveClick()\" translate>\n" +
    "\t\t\t\t\t\t\tSAVE_CHANGES\n" +
    "\t\t\t\t\t\t</button>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</form>\n" +
    "\t\t\t</services>\n" +
    "\t\t</section>\n" +
    "\t</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/items/adItemDetails.html',
    "<section class=\"content current\" ng-click=\"clearErrorMessage()\"><!-- Add new Item -->\n" +
    "\t<div id=\"add-new-item\" data-view=\"ItemsDetailsView\">\n" +
    "\t\t<header class=\"content-title float\">\n" +
    "\t\t\t<h2 ng-show=\"mod == 'edit'\">{{'EDIT' | translate}} <span>{{itemDetails.item_description}} </span></h2>\n" +
    "\t\t\t<h2 ng-show=\"mod == 'add'\" translate>ADD_NEW_ITEM</h2>\n" +
    "\t\t\t\n" +
    "\t\t\t<a data-type=\"load-details\" class=\"action back\" ng-click=\"goBack()\" translate>BACK_TO_ITEMS</a>\n" +
    "\t\t\t<em class=\"status required\" ng-show=\"mod == 'edit'\">\n" +
    "\t\t\t\t{{'MANDATORY_FIELDS_MESSAGE1' | translate}}\n" +
    "\t\t\t\t<strong>*</strong>\n" +
    "\t\t\t\t{{'MANDATORY_FIELDS_MESSAGE2' | translate}}\n" +
    "\t\t\t</em>\n" +
    "\t\t</header>\n" +
    "\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t<form name=\"item-details\" method=\"post\" class=\"form float\">\n" +
    "\t\t\t\t<fieldset class=\"holder full-width float\" ng-show=\"mod == 'add'\">\n" +
    "\t\t\t\t\t<div class=\"form-title\" >\n" +
    "\t\t\t\t\t\t<h3>\n" +
    "\t\t\t\t\t\t\t<span translate>ADD_NEW</span>\n" +
    "\t\t\t\t\t\t\t{{'ITEM' | translate}}\n" +
    "\t\t\t\t\t\t</h3>\n" +
    "\t\t\t\t\t\t<em class=\"status\">\n" +
    "\t\t\t\t\t\t\t{{'MANDATORY_FIELDS_MESSAGE1' | translate}}\n" +
    "\t\t\t\t\t\t\t<strong>*</strong>\n" +
    "\t\t\t\t\t\t\t{{'MANDATORY_FIELDS_MESSAGE2' | translate}}\n" +
    "\t\t\t\t\t\t</em>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</fieldset>\n" +
    "\t\t\t\t<fieldset class=\"holder left float\">\n" +
    "\t\t\t\t\t<ad-textbox value=\"itemDetails.item_description\" name = \"item_desc\" id = \"item_desc\" label = \"{{'ITEM_DESCRIPTION' |translate}}\" placeholder = \"{{'ITEM_DESCRIPTION_PLACEHOLDER' |translate}}\" required = \"yes\" styleclass=\"full-width\" ></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t\t<ad-textbox value=\"itemDetails.unit_price\" name = \"unit_price\" id = \"unit_price\" label = \"{{'UNIT_PRICE' |translate}}\" placeholder = \"{{'UNIT_PRICE_PLACEHOLDER' |translate}}\" required = \"no\" styleclass=\"full-width\" ></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t</fieldset>\n" +
    "\t\t\t\t<fieldset ng-class=\"(mod == 'add') ? 'holder right float' :  'holder left float'\">\n" +
    "\t\t\t\t\t<ad-dropdown label=\"{{'SELECT_CHARGE_CODE' |translate}}\" label-in-drop-down=\"{{'SELECT_CHARGE_CODE' |translate}}\" list=\"itemDetails.charge_code\" selected-Id='itemDetails.selected_charge_code' required = \"yes\" div-class=\"full-width\" id=\"charge_code\"></ad-dropdown>\t\t\t\t\t\t\n" +
    "\t\t\t\t</fieldset>\n" +
    "\t\t\t\t<fieldset class=\"holder left float\">\n" +
    "\t\t\t\t\t<ad-checkbox is-checked=\"itemDetails.is_favourite\" label=\"{{'FAVOURITE' |translate}}\" name=\"favorite\" id=\"favorite\"></ad-checkbox>\t\n" +
    "\n" +
    "\t\t\t\t</fieldset>\n" +
    "\t\t\t<div class=\"actions float\">\n" +
    "\t\t\t\t<button type=\"button\" id=\"cancel\" class=\"button blank add-data-inline\" ng-click=\"goBack()\" translate>CANCEL</button>\n" +
    "\n" +
    "\t\t\t\t<button type=\"button\" id=\"save\" class=\"button green add-data-inline\"  ng-click=\"saveItemDetails()\" translate>SAVE_CHANGES</button>\n" +
    "\n" +
    "\t\t\t</div>\n" +
    "\t\t</form>\n" +
    "\t</section>\n" +
    "</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/items/adItemList.html',
    "<section id=\"replacing-div-first\" class=\"content current\"><div data-view=\"ItemsListView\">\n" +
    "\t<header class=\"content-title float\">\n" +
    "\t\t<h2 translate>\n" +
    "\t\t\tITEMS\n" +
    "\t\t</h2>\n" +
    "\t\t<span class=\"count\">\n" +
    "\t\t\t(\n" +
    "\t\t\t{{data.items.length}}\n" +
    "\t\t\t)\n" +
    "\t\t</span>\n" +
    "\t\t<a id=\"add-new-button\" ui-sref=\"admin.itemdetails({itemid:''})\" class=\"action add\" translate>ADD_NEW</a>\n" +
    "\t</header>\n" +
    "\t<section class=\"content-scroll\">\n" +
    "\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t<div id=\"new-form-holder\"></div>\n" +
    "\t\t<table id=\"items\" class=\"grid datatable dataTable\" ng-table=\"itemList\" template-pagination=\"nil\">\n" +
    "\n" +
    "\n" +
    "\t\t\n" +
    "\t\t\t<tr role=\"row\" ng-repeat=\"item in $data\">\n" +
    "\t\t\t\t<td width=\"25%\" class=\"sorting\" data-title=\"'Description'\" sortable=\"'item_description'\">\n" +
    "\t\t\t\t\t<a ui-sref=\"admin.itemdetails({itemid: item.item_id})\">{{item.item_description}}</a>\n" +
    "\t\t\t\t</td>\n" +
    "\t\t\t\t<td width=\"25%\" class=\"sorting\" data-title=\"'Charge Group'\" sortable=\"'category_name'\">\n" +
    "\t\t\t\t\t{{item.category_name}}\n" +
    "\t\t\t\t</td>\n" +
    "\t\t\t\t<td width=\"14%\" class=\"\" data-title=\"'Unit Price'\" style=\"text-align:center;\">\n" +
    "\t\t\t\t\t{{item.currency_symbol}} {{item.unit_price}}\n" +
    "\t\t\t\t</td>\n" +
    "\t\t\t\t<td width=\"14%\" class=\"activate\" data-title=\"'Favorite'\">\n" +
    "\t\t\t\t\t<ad-toggle-button is-checked=\"item.is_favourite\" ng-click='toggleFavourite(item.item_id, item.is_favourite)'></ad-toggle-button>\n" +
    "\t\t\t\t</td>\n" +
    "\t\t\t\t<td width=\"12%\" class=\"delete\" data-title=\"'Delete'\">\n" +
    "\t\t\t\t\t<a class=\"icons icon-delete large-icon\" ng-click=\"deleteItem($index, item.item_id)\"></a>\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t</td>\n" +
    "\t\t\t</tr>\n" +
    "\t\t\t\n" +
    "\t\t</table>\n" +
    "\t</section>\n" +
    "</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/keyEncoders/adEncoderAdd.html',
    "<div style=\"display: block;\" id=\"add-new\" class=\"edit-data\">\n" +
    "\t<div class=\"data-holder\">\n" +
    "\t\t<!-- Edit Brands -->\n" +
    "\t\t<form class=\"form inline-form float\">\n" +
    "\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t<h3><span translate>ADD_NEW </span> {{'ENCODER' | translate}}</h3>\n" +
    "\t\t\t\t<em class=\"status\"> {{ 'MANDATORY_FIELDS_MESSAGE1' | translate }} <strong>*</strong> {{ 'MANDATORY_FIELDS_MESSAGE2' | translate }} </em>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<fieldset class=\"holder left float\">\n" +
    "\t\t\t\t<ad-textbox inputtype=\"text\" value=\"encoderData.description\"\n" +
    "\t\t\t\tlabel = \" {{'DESCRIPTION_LABEL' | translate}}\" required = \"yes\" placeholder = \"{{'ENTER_DESCRIPTION' | translate}}\"\n" +
    "\t\t\t\tstyleclass = \"full-width\"></ad-textbox>\n" +
    "\t\t\t\t<ad-textbox inputtype=\"text\" value=\"encoderData.encoder_id\"\n" +
    "\t\t\t\tlabel = \" {{'ECODER_ID_LABEL' | translate}}\" required = \"yes\" placeholder = \"{{'ENCODER_ID_PLACEHOLDER' | translate}}\"\n" +
    "\t\t\t\tstyleclass = \"full-width\"></ad-textbox>\n" +
    "\t\t\t</fieldset>\n" +
    "\n" +
    "\t\t\t<fieldset class=\"holder right\">\n" +
    "\t\t\t\t<ad-textbox inputtype=\"text\" value=\"encoderData.location\"\n" +
    "\t\t\t\tlabel = \" {{'LOCATION_LABEL' | translate}}\" required = \"yes\" placeholder = \"{{'ENTER_LOCATION' | translate}}\"\n" +
    "\t\t\t\tstyleclass = \"full-width\"></ad-textbox>\n" +
    "\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t<label translate>STATUS_LABEL</label>\n" +
    "\t\t\t\t\t<div id=\"encoder-status\" class=\"switch-button single\" ng-class=\"{ on : encoderData.enabled == true }\">\n" +
    "\t\t\t\t\t\t<input type=\"checkbox\" ng-click=\"encoderData.enabled = !encoderData.enabled\">\n" +
    "\t\t\t\t\t\t<span class=\"switch-icon\"></span>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t\t\n" +
    "\n" +
    "\t\t\t</fieldset>\n" +
    "\n" +
    "\t\t\t<div class=\"actions float\">\n" +
    "\t\t\t\t<button type=\"button\" id=\"cancel\" class=\"button blank edit-data-inline\"  ng-click=\"clickCancel()\" translate>\n" +
    "\t\t\t\t\tCANCEL\n" +
    "\t\t\t\t</button>\n" +
    "\t\t\t\t<button type=\"button\" id=\"save\" class=\"button green edit-data-inline\" ng-click=\"saveEncoder()\" translate>\n" +
    "\t\t\t\t\tSAVE_CHANGES\n" +
    "\t\t\t\t</button>\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t</form>\n" +
    "\t</div>\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/keyEncoders/adEncoderEdit.html',
    "<div style=\"display: block;\" id=\"add-new\" class=\"edit-data\">\n" +
    "\t<div class=\"data-holder\">\n" +
    "\t\t<!-- Edit Brands -->\n" +
    "\t\t<form class=\"form inline-form float\">\n" +
    "\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t<h3><span translate>EDIT </span> {{'ENCODER' | translate}}</h3>\n" +
    "\t\t\t\t<em class=\"status\"> {{ 'MANDATORY_FIELDS_MESSAGE1' | translate }} <strong>*</strong> {{ 'MANDATORY_FIELDS_MESSAGE2' | translate }} </em>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<fieldset class=\"holder left float\">\n" +
    "\t\t\t\t<ad-textbox inputtype=\"text\" value=\"encoderData.description\"\n" +
    "\t\t\t\tlabel = \" {{'DESCRIPTION_LABEL' | translate}}\" required = \"yes\" placeholder = \"{{'ENTER_DESCRIPTION' | translate}}\"\n" +
    "\t\t\t\tstyleclass = \"full-width\"></ad-textbox>\n" +
    "\t\t\t\t<ad-textbox inputtype=\"text\" value=\"encoderData.encoder_id\"\n" +
    "\t\t\t\tlabel = \" {{'ECODER_ID_LABEL' | translate}}\" required = \"yes\" placeholder = \"{{'ENCODER_ID_PLACEHOLDER' | translate}}\"\n" +
    "\t\t\t\tstyleclass = \"full-width\"></ad-textbox>\n" +
    "\t\t\t</fieldset>\n" +
    "\n" +
    "\t\t\t<fieldset class=\"holder right\">\n" +
    "\t\t\t\t<ad-textbox inputtype=\"text\" value=\"encoderData.location\"\n" +
    "\t\t\t\tlabel = \" {{'LOCATION_LABEL' | translate}}\" required = \"yes\" placeholder = \"{{'ENTER_LOCATION' | translate}}\"\n" +
    "\t\t\t\tstyleclass = \"full-width\"></ad-textbox>\n" +
    "\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t<label translate>STATUS_LABEL</label>\n" +
    "\t\t\t\t\t<div id=\"encoder-status\" class=\"switch-button single\" ng-class=\"{ on : encoderData.enabled == true }\">\n" +
    "\t\t\t\t\t\t<input type=\"checkbox\" ng-click=\"encoderData.enabled = !encoderData.enabled\">\n" +
    "\t\t\t\t\t\t<span class=\"switch-icon\"></span>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</fieldset>\n" +
    "\n" +
    "\t\t\t<div class=\"actions float\">\n" +
    "\t\t\t\t<button type=\"button\" id=\"cancel\" class=\"button blank edit-data-inline\"  ng-click=\"clickCancel()\" translate>\n" +
    "\t\t\t\t\tCANCEL\n" +
    "\t\t\t\t</button>\n" +
    "\t\t\t\t<button type=\"button\" id=\"save\" class=\"button green edit-data-inline\" ng-click=\"saveEncoder()\" translate>\n" +
    "\t\t\t\t\tSAVE_CHANGES\n" +
    "\t\t\t\t</button>\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t</form>\n" +
    "\t</div>\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/keyEncoders/adKeyEncoderList.html',
    "<section class=\"content current\" ng-click='clearErrorMessage()'>\n" +
    "\t<div>\n" +
    "\t\t<header class=\"content-title float\">\n" +
    "\t\t\t<h2> Key Encoders </h2>\n" +
    "\t\t\t<span class=\"count\"> ({{totalCount}}) </span>\n" +
    "\t\t\t<a class=\"action add\" ng-click=\"addNew()\" translate>ADD_NEW</a>\n" +
    "\t\t</header>\n" +
    "\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_success_message.html'\"></div>\n" +
    "\t\t\t<div id=\"new-form-holder\" ng-show=\"currentClickedElement == 'new'\" ng-include=\"'/assets/partials/keyEncoders/adEncoderAdd.html'\"></div>\n" +
    "\t\t\t\n" +
    "\t\t\t\n" +
    "\t\t\t<span class=\"count-show\">Show</span>\n" +
    "\t\t\t<div class=\"select table-count rates-table-count\">\n" +
    "\t\t\t\t<select ng-model=\"displyCount\"\tng-options=\"opt for opt in displayCountList\"></select>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<span class=\"count-entries\">entries</span>\n" +
    "\t\t\t\t\n" +
    "\t\t\t<div class=\"entry table-search\">\n" +
    "\t\t\t\t<span class=\"search-text\">Search</span>\n" +
    "\t\t\t\t<span class=\"icons icon-search\" name=\"submit\" type=\"submit\"></span>\n" +
    "\t\t\t\t<input placeholder=\"\" autocomplete=\"off\" type=\"text\" ad-delay-textbox ng-model=\"searchTerm\" delay=\"1000\" function-to-fire=\"searchEntered\" />\n" +
    "\t\t    </div>\n" +
    "\t\t\t\n" +
    "\n" +
    "\t\t\t<div id=\"new-form-holder\"></div>\n" +
    "\n" +
    "\t\t\t<!--ng-table component -->\n" +
    "\t\t\t<table class=\"grid\" ng-table=\"tableParams\" template-pagination=\"custom/pager\" ng-class=\"{'edit-data': currentClickedElement == $index}\">\n" +
    "\t\t\t\t<tbody>\n" +
    "\t\t\t\t\t<tr ng-repeat=\"encoder in $data\"> \n" +
    "\t\t\t\t\t\t<td data-title=\"'Description'\" header-class=\"width-30\" ng-hide=\"currentClickedElement == $index\">\n" +
    "\t\t\t\t\t\t\t<a class=\"edit-data\" ng-click=\"editEncoder(encoder.id, $index)\" >\n" +
    "\t\t\t\t\t\t\t\t<strong> {{encoder.description}}</strong>\n" +
    "\t\t\t\t\t\t\t</a>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t\t\t<td data-title=\"'Location'\"  header-class=\"width-30\" ng-hide=\"currentClickedElement == $index\">\n" +
    "\t\t\t\t\t\t\t<span>\n" +
    "\t\t\t\t\t\t\t\t{{encoder.location}}\n" +
    "\t\t\t\t\t\t\t</span>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td data-title=\"'Encoder ID'\" header-class=\"width-25\" ng-hide=\"currentClickedElement == $index\">\n" +
    "\t\t\t\t\t\t\t<span>\n" +
    "\t\t\t\t\t\t\t\t<strong>{{encoder.encoder_id}}</strong>\n" +
    "\t\t\t\t\t\t\t</span>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\n" +
    "\t\t\t\t\t\t<td data-title=\"'Status'\" header-class=\"width-25\" ng-hide=\"currentClickedElement == $index\">\n" +
    "\t\t\t\t\t\t\t<div id=\"encoder-status\" class=\"switch-button single\" ng-class=\"{ on : encoder.enabled == true }\">\n" +
    "\t\t\t\t\t\t\t\t<input type=\"checkbox\" ng-click=\"statusToggle($index)\">\n" +
    "\t\t\t\t\t\t\t\t<span class=\"switch-icon\"></span>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t<td colspan=\"5\" header-class=\"width-0\" ng-include=\"getTemplateUrl($index, encoder.id)\" ></td>\n" +
    "\t\t\t\t\t</tr> \n" +
    "\t\t\t\t</tbody>\n" +
    "\t\t\t</table>\n" +
    "\t\t</section>\n" +
    "\t\t<!--end -->\n" +
    "\n" +
    "\t\t<!--Custom pagination footer goes here-->\n" +
    "\t\t<script type=\"text/ng-template\" id=\"custom/pager\">\n" +
    "\t\t\t<div class = \"pager\">\n" +
    "\t\t\t\t<span ng-show=\"totalCount>0\">Showing {{startCount}} to {{endCount}} of {{totalCount}} items</span>\n" +
    "\t\t\t\t<span ng-show=\"totalCount==0\">Showing 0 items</span>\n" +
    "\t\t\t\t<ul class=\"ng-cloak\">\n" +
    "\t              \t<li ng-repeat=\"page in pages\"\n" +
    "\t\t                ng-class=\"{'previous': page.type == 'prev', 'next': page.type == 'next'}\"\n" +
    "\t\t                ng-show=\"page.type == 'prev' || page.type == 'next'\" ng-switch=\"page.type\">\n" +
    "\t\n" +
    "\t\t                <a ng-switch-when=\"prev\" ng-click=\"params.page(1)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">First</a>\n" +
    "\t\t                <a ng-switch-when=\"prev\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">Previous</a>\n" +
    "\t\t                <a ng-switch-when=\"prev\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">{{page.number}}</a>\n" +
    "\t\t                \n" +
    "\t\t                <a ng-switch-when=\"next\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">{{page.number}}</a>\n" +
    "\t\t                <a ng-switch-when=\"next\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">Next</a>\n" +
    "\t\t                <a ng-switch-when=\"next\" ng-click=\"params.page(totalPage)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">Last</a>\n" +
    "\t\t          \t</li>\n" +
    "\t            </ul>\n" +
    "\t        </div>\n" +
    "\t\t</script>\n" +
    "\t\t<!--end-->\n" +
    "\t</div>\n" +
    "</section>\n" +
    "\n" +
    "<div id=\"new-form-holder\" ng-show=\"isAddmode\" ng-include=\"getAddRateTemplateUrl()\">\n"
  );


  $templateCache.put('/assets/partials/maintenanceReasons/adMaintenanceReasons.html',
    "<section class=\"content current\" ng-click=\"clearErrorMessage()\">\n" +
    "\t<div  class=\"inline-edit\">\n" +
    "\t\t<header class=\"content-title float\">\n" +
    "\t\t\t<h2 translate> MAINTENANCE_REASONS </h2>\n" +
    "\t\t\t<span class=\"count\"> (\n" +
    "\t\t\t\t{{data.maintenance_reasons.length}}\n" +
    "\t\t\t\t) </span>\n" +
    "\t\t\t<a class=\"action add\" ng-click=\"addNewClicked()\" translate>ADD_NEW</a>\n" +
    "\t\t</header>\n" +
    "\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t\n" +
    "\t\t\t<div id=\"add-new\" ng-show=\"currentClickedElement == 'new'\" ng-include=\"'/assets/partials/maintenanceReasons/adMaintenanceReasonsAdd.html'\"></div>\t\t\n" +
    "\t\t\t\n" +
    "\t\t\t<table class=\"grid\">\n" +
    "\t\t\t\t<tbody>\n" +
    "\t\t\t\t\t<tr ng-repeat=\"item in data.maintenance_reasons\" > \n" +
    "\t\t\t\t\t\t<td ng-click=\"editItem($index)\" ng-hide=\"currentClickedElement == $index\">\n" +
    "\t\t\t\t\t\t\t<a data-item=\"1\" data-colspan=\"2\" class=\"edit-data-inline\">{{item.name}} </a>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td class=\"delete\" ng-click=\"clickedDelete(item.value)\" ng-hide=\"currentClickedElement == $index\">\n" +
    "\t\t\t\t\t\t\t<a class=\"icons icon-delete large-icon delete_item\"></a>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td colspan=\"2\" ng-include=\"getTemplateUrl($index)\"></td>\n" +
    "\t\t\t\t\t</tr>\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t</tbody>\n" +
    "\t\t\t</table>\n" +
    "\t\t</section>\n" +
    "\t</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/maintenanceReasons/adMaintenanceReasonsAdd.html',
    "<div class=\"data-holder\">\n" +
    "\t<!-- Add Charge Group -->\n" +
    "\t<form class=\"form inline-form float\">\n" +
    "\t\t<div class=\"form-title\">\n" +
    "\t\t\t<h3><span></span> {{'ADD'|translate}} </h3>\n" +
    "\t\t\t<em class=\"status\">{{'MANDATORY_FIELDS_MESSAGE1' | translate}} <strong>*</strong> {{'MANDATORY_FIELDS_MESSAGE2' | translate}} </em>\n" +
    "\t\t</div>\n" +
    "\t\t<fieldset class=\"holder left float\">\n" +
    "\t\t\t<ad-textbox value=\"data.name\" name = \"item-name\" label = \"{{'NAME' | translate}}\" placeholder = \"{{'MAINTENANCE_REASON_PLACEHOLDER' | translate}}\" required = \"yes\"></ad-textbox>\n" +
    "\t\t</fieldset>\n" +
    "\t\t<div class=\"actions float\">\n" +
    "\t\t\t<button type=\"button\" ng-click=\"clickedCancel()\" class=\"button blank edit-data-inline\" translate>\n" +
    "\t\t\t\tCANCEL\n" +
    "\t\t\t</button>\n" +
    "\t\t\t<button type=\"button\" ng-click=\"saveAddNew()\" class=\"button green edit-data-inline\" translate>\n" +
    "\t\t\t\tSAVE_CHANGES\n" +
    "\t\t\t</button>\n" +
    "\t\t</div>\n" +
    "\t</form>\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/maintenanceReasons/adMaintenanceReasonsEdit.html',
    "<div class=\"data-holder\">\n" +
    "\t<form class=\"form single-field-form float\">\n" +
    "\t\t<ad-textbox value=\"item.name\" name = \"item-name\" label = \"\" placeholder = \"{{'MAINTENANCE_REASON_PLACEHOLDER' | translate}}\" required = \"\"></ad-textbox>\n" +
    "\n" +
    "\t\t<div class=\"actions float\">\n" +
    "\t\t\t<button type=\"button\" class=\"button blank edit-data-inline\" ng-click=\"clickedCancel()\" translate>\n" +
    "\t\t\t\tCANCEL\n" +
    "\t\t\t</button>\n" +
    "\t\t\t<button type=\"button\" class=\"button green edit-data-inline\" ng-click=\"updateItem()\" translate>\n" +
    "\t\t\t\tSAVE_CHANGES\n" +
    "\t\t\t</button>\n" +
    "\t\t\t<button type=\"button\" class=\"button red edit-data-inline\" ng-click=\"clickedDelete(item.value)\" translate>\n" +
    "\t\t\t\tDELETE\n" +
    "\t\t\t</button>\n" +
    "\t\t</div>\n" +
    "\t\t\n" +
    "\t</form>\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/mapping/adExternalMapping.html',
    "<section id=\"replacing-div-first\" class=\"content current\" ng-click=\"clearErrorMessage()\">\n" +
    "\t<div id=\"selected_hotel\" data-view=\"HotelExternalMappingsView\">\n" +
    "\t\t<!-- Hotels list -->\n" +
    "\t\t<section>\n" +
    "\t\t\t<header class=\"content-title float\">\n" +
    "\t\t\t\t<h2>External Mappings</h2>\n" +
    "\t\t\t\t<span class=\"count\">({{data.total_count}})</span>\n" +
    "\t\t\t\t<a ng-click=\"addNew()\" ng-show=\"addFormView\" class=\"action add\" >Add new</a>\n" +
    "\t\t\t\t<a class=\"action back\" ui-sref=\"admin.snthoteldetails({action:'edit',id: hotelId})\">Back</a>\n" +
    "\t\t\t\t\n" +
    "\t\t\t\t<div class=\"filters\">\n" +
    "\t\t\t\t\t<div class=\"filter hidden\"></div>\n" +
    "\t\t\t\t\t<div class=\"filter hidden\"></div>\n" +
    "\t\t\t\t\t<div id=\"filter-brand\" class=\"filter select\">\n" +
    "\t\t\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t\t\t<label for=\"hotel-chain\"> </label>\n" +
    "\t\t\t\t\t\t\t<div class=\"select\">\n" +
    "\t\t\t\t\t\t\t\t<select ng-model=\"data.mapping_type\" name=\"hotel-chain\" id=\"hotel-chain\" class=\"placeholder\">\n" +
    "\t\t\t\t\t\t\t\t\t<option value=\"\"> Filter By Chain </option>\n" +
    "\t\t\t\t\t\t\t\t\t<option ng-selected=\"mapping === data.mapping_type\" ng-repeat=\"mapping in data.mapping\">{{mapping.mapping_type}}</option>\n" +
    "\t\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t</header>\n" +
    "\t\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div> \n" +
    "\t\t\t\t<div id=\"new-form-holder\" ng-show=\"isAdd\" ng-include=\"getTemplateUrl()\"></div>\n" +
    "\t\t\t\t<table class=\"grid \">\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t\t<thead>\n" +
    "\t\t\t\t\t\t<tr role=\"row\">\n" +
    "\t\t\t\t\t\t\t<th width=\"30%\" class=\"sorting\"> Mapping Type </th>\n" +
    "\t\t\t\t\t\t\t<th width=\"25%\" class=\"sorting\"> SNT Value </th>\n" +
    "\t\t\t\t\t\t\t<th width=\"25%\" class=\"sorting\"> External Value </th>\n" +
    "\t\t\t\t\t\t\t<th width=\"10%\" class=\"activate long\"> Delete </th>\n" +
    "\t\t\t\t\t\t</tr>\n" +
    "\t\t\t\t\t</thead>\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t\t<tbody ng-repeat=\"mapping in data.mapping\">\n" +
    "\n" +
    "\t\t\t\t\t\t<tr ng-repeat=\"mapping_value in mapping.mapping_values\">\n" +
    "\t\t\t\t\t\t\t<td width=\"30%\" ng-click=\"editSelected(mapping_value.value)\" ng-hide=\"currentClickedElement == mapping_value.value && isEdit\" name=\"{{$index}}\">\n" +
    "\t\t\t\t\t\t\t\t<a  data-item=\"3\" data-colspan=\"2\" class=\"edit-data-inline\">{{mapping.mapping_type}}</a>\n" +
    "\t\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t\t<td width=\"25%\" ng-hide=\"currentClickedElement == mapping_value.value && isEdit\">\n" +
    "\t\t\t\t\t\t\t\t<a data-item=\"3\" data-colspan=\"2\" class=\"edit-data-inline\">{{mapping_value.snt_value}}</a>\n" +
    "\t\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t\t<td width=\"25%\" ng-hide=\"currentClickedElement == mapping_value.value && isEdit\">\n" +
    "\t\t\t\t\t\t\t\t<a data-item=\"3\" data-colspan=\"2\" class=\"edit-data-inline\">{{mapping_value.external_value}}</a>\n" +
    "\t\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t\t<td class=\"delete\" ng-click=\"clickedDelete(mapping_value.value)\" ng-hide=\"currentClickedElement == mapping_value.value && isEdit\" width=\"10%\">\n" +
    "\t\t\t\t\t\t\t\t<a class=\"icons icon-delete large-icon delete_item\"></a>\n" +
    "\t\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t\t<td colspan=\"4\" ng-include=\"getTemplateUrl()\" ng-show=\"currentClickedElement == mapping_value.value && isEdit\"></td>\n" +
    "\t\t\t\t\t\t</tr>\n" +
    "\n" +
    "\t\t\t\t\t</tbody>\n" +
    "\t\t\t\t</table>\n" +
    "\t\t\t</section>\n" +
    "\t\t</section>\n" +
    "\t</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/mapping/adExternalMappingDetails.html',
    "<div style=\"display: block;\" id=\"add-new\" class=\"edit-data\">\n" +
    "\t<div class=\"data-holder\">\n" +
    "\t\t<!-- Add new external mappings -->\n" +
    "\t\t<form class=\"form inline-form float\">\n" +
    "\n" +
    "\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t<h3 ng-show = \"isAdd\"><span> Add New </span> External Mapping </h3>\n" +
    "\t\t\t\t<h3 ng-hide = \"isAdd\"><span> Edit </span> External Mapping </h3>\n" +
    "\t\t\t\t<em class=\"status\"> Fields marked with <strong>*</strong> are mandatory! </em>\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t\t<fieldset class=\"holder left float\">\n" +
    "\n" +
    "\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t<label for=\"mapping-type\"> Mapping type <strong>*</strong> </label>\n" +
    "\t\t\t\t\t<div class=\"select\">\n" +
    "\t\t\t\t\t\t<select ng-model=\"editData.mapping_value\" name=\"mapping-type\" class=\"placeholder\">\n" +
    "\t\t\t\t\t\t\t<option  value=\"\"> Mapping type </option>\n" +
    "\t\t\t\t\t\t\t<option ng-repeat=\"mapping in editData.mapping_type\" value=\"{{mapping.name}}\" ng-selected=\"mapping.name==editData.selected_mapping_type\" >{{mapping.name}} </option>\n" +
    "\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t\t\n" +
    "\t\t\t\t<div id=\"hideDiv\" class=\"entry\"></div>\n" +
    "\t\t\t\t<div class=\"entry sntvalue\">\n" +
    "\t\t\t\t\t<label for=\"snt-value\"> Snt Value <strong>*</strong> </label>\n" +
    "\t\t\t\t\t<div class=\"select\">\n" +
    "\t\t\t\t\t\t<select ng-model=\"editData.snt_value\" name=\"snt-value\" class=\"placeholder\">\n" +
    "\t\t\t\t\t\t\t<option value=\"\"> Snt Value </option>\n" +
    "\t\t\t\t\t\t\t<option ng-repeat=\"sntVal in editData.sntValues\" value=\"{{sntVal.name}}\" ng-selected=\"sntVal.name==editData.selected_snt_value\" >{{sntVal.name}} </option>\n" +
    "\n" +
    "\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t<label for=\"external-value\"> External Value <strong>*</strong> </label>\n" +
    "\t\t\t\t\t<input type=\"text\" ng-model=\"editData.external_value\" value=\"editData.external_value\" required=\"yes\" placeholder=\"Enter value\" name=\"external-value\">\n" +
    "\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t</fieldset>\n" +
    "\n" +
    "\t\t\t<div class=\"actions float\">\n" +
    "\t\t\t\t<button type=\"button\" ng-click=\"closeInlineTab()\" class=\"button blank edit-data-inline\">\n" +
    "\t\t\t\t\tCancel\n" +
    "\t\t\t\t</button>\n" +
    "\t\t\t\t<button type=\"button\" ng-click=\"clickedSave()\" class=\"button green edit-data-inline\">\n" +
    "\t\t\t\t\tSave changes\n" +
    "\t\t\t\t</button>\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t</form>\n" +
    "\t</div>\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/markets/adMarkets.html',
    "<section  class=\"content current\" ng-click=\"clearErrorMessage()\">\n" +
    "\t<div  class=\"inline-edit\">\n" +
    "\t\t<header class=\"content-title float\">\n" +
    "\t\t\t<h2 translate> MARKET </h2>\n" +
    "\t\t\t<span class=\"count\"> (\n" +
    "\t\t\t\t{{data.markets.length}}\n" +
    "\t\t\t\t) </span>\n" +
    "\t\t\t<a class=\"action add\" ng-hide=\"!data.is_use_markets\" ng-click=\"addNewClicked()\" translate>ADD_NEW</a>\n" +
    "\t\t\t<ad-toggle-button is-checked=\"data.is_use_markets\" div-class=\"header-title\" ng-click=\"clickedUsedMarkets()\" label=\"{{'USE_MARKETS' | translate}}\"></ad-toggle-button>\n" +
    "\t\t</header>\n" +
    "\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t\n" +
    "\t\t\t<div id=\"add-new\" ng-show=\"currentClickedElement == 'new'\" ng-include=\"'/assets/partials/markets/adMarketsAdd.html'\"></div>\t\t\n" +
    "\t\t\t\n" +
    "\t\t\t<table class=\"grid\" ng-disabled=\"data.is_use_markets\" ng-class=\"{'overlay' : !data.is_use_markets}\">\n" +
    "\t\t\t\t<tbody>\n" +
    "\t\t\t\t\t<tr ng-repeat=\"item in data.markets\" > \n" +
    "\t\t\t\t\t\t<td ng-click=\"editItem($index)\" ng-hide=\"currentClickedElement == $index\">\n" +
    "\t\t\t\t\t\t\t<a data-item=\"1\" data-colspan=\"2\" class=\"edit-data-inline\">{{item.name}} </a>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td class=\"activate\" ng-click=\"updateItem($index)\" ng-hide=\"currentClickedElement == $index\">\n" +
    "\t\t\t\t\t\t\t<ad-toggle-button is-checked=\"item.is_active\" ></ad-toggle-button>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td colspan=\"2\" ng-include=\"getTemplateUrl($index)\"></td>\n" +
    "\t\t\t\t\t</tr>\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t</tbody>\n" +
    "\t\t\t</table>\n" +
    "\t\t</section>\n" +
    "\t</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/markets/adMarketsAdd.html',
    "<div class=\"data-holder\">\n" +
    "\t<!-- Add Charge Group -->\n" +
    "\t<form class=\"form inline-form float\">\n" +
    "\t\t<div class=\"form-title\">\n" +
    "\t\t\t<h3><span></span> {{'ADD'| translate}} </h3>\n" +
    "\t\t\t<em class=\"status\"> {{'MANDATORY_FIELDS_MESSAGE1' | translate}} <strong>*</strong> {{'MANDATORY_FIELDS_MESSAGE2' | translate}}</em>\n" +
    "\t\t</div>\n" +
    "\t\t<fieldset class=\"holder left float\">\n" +
    "\t\t\t<ad-textbox value=\"data.name\"  name = \"item-name\" label = \"{{'NAME'| translate}}\" placeholder = \"{{'MARKET_NAME_PLACEHOLDER'| translate}}\" required = \"yes\"></ad-textbox>\n" +
    "\t\t</fieldset>\n" +
    "\t\t<div class=\"actions float\">\n" +
    "\t\t\t<button type=\"button\" ng-click=\"clickedCancel()\" class=\"button blank edit-data-inline\" translate>\n" +
    "\t\t\t\tCANCEL\n" +
    "\t\t\t</button>\n" +
    "\t\t\t<button type=\"button\" ng-click=\"saveAddNew()\" class=\"button green edit-data-inline\" translate>\n" +
    "\t\t\t\tSAVE_CHANGES\n" +
    "\t\t\t</button>\n" +
    "\t\t</div>\n" +
    "\t</form>\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/markets/adMarketsEdit.html',
    "<div class=\"data-holder\">\n" +
    "\t<form class=\"form single-field-form float\">\n" +
    "\t\t<ad-textbox value=\"item.name\" name = \"item-name\" label = \"\" placeholder = \"{{'MARKET_NAME_PLACEHOLDER'| translate}}\" required = \"\"></ad-textbox>\n" +
    "\n" +
    "\t\t<div class=\"actions float\">\n" +
    "\t\t\t<button type=\"button\" class=\"button blank edit-data-inline\" ng-click=\"clickedCancel()\" translate>\n" +
    "\t\t\t\tCANCEL\n" +
    "\t\t\t</button>\n" +
    "\t\t\t<button type=\"button\" class=\"button green edit-data-inline\" ng-click=\"updateItem()\" translate>\n" +
    "\t\t\t\tSAVE_CHANGES\n" +
    "\t\t\t</button>\n" +
    "\t\t\t<button type=\"button\" class=\"button red edit-data-inline\" ng-click=\"clickedDelete(item.value)\" translate>\n" +
    "\t\t\t\tDELETE\n" +
    "\t\t\t</button>\n" +
    "\t\t</div>\n" +
    "\t\t\n" +
    "\t</form>\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/origins/adOrigins.html',
    "<section  class=\"content current\" ng-click=\"clearErrorMessage()\">\n" +
    "\t<div class=\"inline-edit\">\n" +
    "\t\t<header class=\"content-title float\">\n" +
    "\t\t\t<h2 translate> ORIGINS </h2>\n" +
    "\t\t\t<span class=\"count\"> (\n" +
    "\t\t\t\t{{data.booking_origins.length}}\n" +
    "\t\t\t\t) </span>\n" +
    "\t\t\t<a class=\"action add\" ng-hide=\"!data.is_use_origins\" ng-click=\"addNewClicked()\" translate>ADD_NEW</a>\n" +
    "\t\t\t<ad-toggle-button is-checked=\"data.is_use_origins\" div-class=\"header-title\" ng-click=\"clickedUsedOrigins()\" label=\"{{'USE_ORIGIN_OF_BOOKING' | translate}}\"></ad-toggle-button>\n" +
    "\t\t</header>\n" +
    "\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t\n" +
    "\t\t\t<div id=\"add-new\" ng-show=\"currentClickedElement == 'new'\" ng-include=\"'/assets/partials/origins/adOriginsAdd.html'\"></div>\t\t\n" +
    "\t\t\t\n" +
    "\t\t\t<table class=\"grid\" ng-disabled=\"data.is_use_origins\" ng-class=\"{'overlay' : !data.is_use_origins}\">\n" +
    "\t\t\t\t<tbody>\n" +
    "\t\t\t\t\t<tr ng-repeat=\"item in data.booking_origins\" > \n" +
    "\t\t\t\t\t\t<td ng-click=\"editItem($index)\" ng-hide=\"currentClickedElement == $index\">\n" +
    "\t\t\t\t\t\t\t<a data-item=\"1\" data-colspan=\"2\" class=\"edit-data-inline\">{{item.name}} </a>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td class=\"activate\" ng-click=\"updateItem($index)\" ng-hide=\"currentClickedElement == $index\">\n" +
    "\t\t\t\t\t\t\t<ad-toggle-button is-checked=\"item.is_active\" ></ad-toggle-button>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td colspan=\"2\" ng-include=\"getTemplateUrl($index)\"></td>\n" +
    "\t\t\t\t\t</tr>\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t</tbody>\n" +
    "\t\t\t</table>\n" +
    "\t\t</section>\n" +
    "\t</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/origins/adOriginsAdd.html',
    "<div class=\"data-holder\">\n" +
    "\t<form class=\"form inline-form float\">\n" +
    "\t\t<div class=\"form-title\">\n" +
    "\t\t\t<h3><span></span> {{'ADD'| translate}} </h3>\n" +
    "\t\t\t<em class=\"status\"> {{'MANDATORY_FIELDS_MESSAGE1' | translate}} <strong>*</strong> {{'MANDATORY_FIELDS_MESSAGE2' | translate}} </em>\n" +
    "\t\t</div>\n" +
    "\t\t<fieldset class=\"holder left float\">\n" +
    "\t\t\t<ad-textbox value=\"data.name\"  name = \"item-name\" label = \"{{'NAME' | translate}}\" placeholder = \"{{'ORIGIN_NAME_PLACEHOLDER' | translate}}\" required = \"yes\"></ad-textbox>\n" +
    "\t\t</fieldset>\n" +
    "\t\t<div class=\"actions float\">\n" +
    "\t\t\t<button type=\"button\" ng-click=\"clickedCancel()\" class=\"button blank edit-data-inline\" translate>\n" +
    "\t\t\t\tCANCEL\n" +
    "\t\t\t</button>\n" +
    "\t\t\t<button type=\"button\" ng-click=\"saveAddNew()\" class=\"button green edit-data-inline\" translate>\n" +
    "\t\t\t\tSAVE_CHANGES\n" +
    "\t\t\t</button>\n" +
    "\t\t</div>\n" +
    "\t</form>\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/origins/adOriginsEdit.html',
    "<div class=\"data-holder\">\n" +
    "\t<form class=\"form single-field-form float\">\n" +
    "\t\t<ad-textbox value=\"item.name\" name = \"item-name\" label = \"\" placeholder = \"Enter origin name\" required = \"\"></ad-textbox>\n" +
    "\n" +
    "\t\t<div class=\"actions float\">\n" +
    "\t\t\t<button type=\"button\" class=\"button blank edit-data-inline\" ng-click=\"clickedCancel()\" translate>\n" +
    "\t\t\t\tCANCEL\n" +
    "\t\t\t</button>\n" +
    "\t\t\t<button type=\"button\" class=\"button green edit-data-inline\" ng-click=\"updateItem()\" translate>\n" +
    "\t\t\t\tSAVE_CHANGES\n" +
    "\t\t\t</button>\n" +
    "\t\t\t<button type=\"button\" class=\"button red edit-data-inline\" ng-click=\"clickedDelete(item.value)\" translate>\n" +
    "\t\t\t\tDELETE\n" +
    "\t\t\t</button>\n" +
    "\t\t</div>\n" +
    "\t\t\n" +
    "\t</form>\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/paymentMethods/adAddPaymentMethod.html',
    "<div class='edit-data' id='add-new' style='display: block;'>\n" +
    "\t<div class='data-holder'>\n" +
    "\t\t<!-- Add payment type -->\n" +
    "\t\t<form class='form inline-form float'>\n" +
    "\t\t\t<div class='form-title'>\n" +
    "\t\t\t\t<h3 translate>ADD</h3>\n" +
    "\t\t\t\t<em class='status'>{{ 'MANDATORY_FIELDS_MESSAGE1' | translate }} <strong>*</strong> {{ 'MANDATORY_FIELDS_MESSAGE2' | translate }} </em>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<fieldset class='holder left'>\n" +
    "\t\t\t\t<ad-textbox inputtype=\"text\" value=\"addData.description\"\n" +
    "\t\t\t\tlabel = \"Description\" placeholder = \"Enter payment description\"\n" +
    "\t\t\t\trequired=\"yes\" styleclass=\"full-width\"></ad-textbox>\n" +
    "\t\t\t</fieldset>\n" +
    "\t\t\t<fieldset class='holder right'>\n" +
    "\t\t\t\t<ad-textbox inputtype=\"text\" value=\"addData.value\"\n" +
    "\t\t\t\tlabel = \"Code\" styleclass=\"full-width\" placeholder = \"Enter code\"\n" +
    "\t\t\t\trequired=\"yes\"></ad-textbox>\n" +
    "\t\t\t</fieldset>\n" +
    "\t\t\t<fieldset class='holder left'>\n" +
    "\t\t\t\t<ad-checkbox is-checked=\"addData.is_cc\" label=\"{{ 'CC' | translate}}\" div-class=\"full-width\" ></ad-checkbox>\n" +
    "\t\t\t\t<div ng-hide=\"!addData.is_cc\">\n" +
    "\t\t\t\t\t<ad-checkbox is-checked=\"addData.is_offline\" label=\"{{ 'OFFLINE' | translate}}\" div-class=\"full-width\"></ad-checkbox>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</fieldset>\n" +
    "\t\t\t<fieldset class='holder right'>\n" +
    "\t\t\t\t<ad-checkbox is-checked=\"addData.is_rover_only\" label=\"{{ 'ROVER_ONLY' | translate}}\" div-class=\"full-width\" change=\"roverOnlyChanged()\"></ad-checkbox>\n" +
    "\t\t\t\t<ad-checkbox is-checked=\"addData.is_web_only\" label=\"{{ 'WEB_ONLY' | translate}}\" div-class=\"full-width\" change=\"webOnlyChanged()\"></ad-checkbox>\n" +
    "\t\t\t\t<ad-checkbox is-checked=\"addData.is_display_reference\" label=\"{{ 'DISPLAY_REFERENCE' | translate}}\" div-class=\"full-width\"></ad-checkbox>\n" +
    "\t\t\t</fieldset>\n" +
    "\t\t\t<div class='actions float'>\n" +
    "\t\t\t\t<button class='button blank edit-data-inline' id='cancel' type='button' ng-click=\"clickCancel()\" translate>\n" +
    "\t\t\t\t\tCANCEL\n" +
    "\t\t\t\t</button>\n" +
    "\t\t\t\t<button class='button green edit-data-inline' id='save' type='button' ng-click=\"savePaymentMethod()\" translate>\n" +
    "\t\t\t\t\tSAVE_CHANGES\n" +
    "\t\t\t\t</button>\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t</form>\n" +
    "\t</div>\n" +
    "</div>\n"
  );


  $templateCache.put('/assets/partials/paymentMethods/adEditPaymentMethod.html',
    "<div class='data-holder move50'>\n" +
    "\t<!-- Edit payment type -->\n" +
    "\t<form class='form float inline-form'>\n" +
    "\t\t<ad-textbox value=\"editData.description\" readonly=\"{{editData.is_system_defined ? 'yes':'no'}}\" name = \"payment-description\" label = \"Description\" placeholder = \"Enter payment description\" required = \"yes\"></ad-textbox>\n" +
    "\t\t<ad-textbox value=\"editData.value\" readonly=\"{{editData.is_system_defined ? 'yes':'no'}}\" name = \"payment-code\" label = \"Code\" placeholder = \"Enter payment code\" required = \"yes\"></ad-textbox>\n" +
    "\n" +
    "\t\t<fieldset class='holder left'>\n" +
    "\t\t\t<ad-checkbox is-checked=\"editData.is_cc\" label=\"{{ 'CC' | translate}}\" div-class=\"full-width\" is-disabled=\"editData.is_system_defined\"></ad-checkbox>\n" +
    "\t\t\t<div ng-hide=\"!editData.is_cc\">\n" +
    "\t\t\t\t<ad-checkbox is-checked=\"editData.is_offline\" label=\"{{ 'OFFLINE' | translate}}\" div-class=\"full-width\"></ad-checkbox>\n" +
    "\t\t\t</div>\n" +
    "\t\t</fieldset>\n" +
    "\t\t<fieldset class='holder right'>\n" +
    "\t\t\t<ad-checkbox is-checked=\"editData.is_rover_only\" label=\"{{ 'ROVER_ONLY' | translate}}\" div-class=\"full-width\" change=\"roverOnlyChanged()\"></ad-checkbox>\n" +
    "\n" +
    "\t\t\t<ad-checkbox is-checked=\"editData.is_web_only\" label=\"{{ 'WEB_ONLY' | translate}}\" div-class=\"full-width\" change=\"webOnlyChanged()\"></ad-checkbox>\n" +
    "\n" +
    "\t\t\t<ad-checkbox is-checked=\"editData.is_display_reference\" label=\"{{ 'DISPLAY_REFERENCE' | translate}}\" div-class=\"full-width\"></ad-checkbox>\n" +
    "\t\t</fieldset>\n" +
    "\t\t<div class='actions float'>\n" +
    "\t\t\t<button class='button blank edit-data-inline' id='cancel' type='button' ng-click=\"clickCancel()\" translate>\n" +
    "\t\t\t\tCANCEL\n" +
    "\t\t\t</button>\n" +
    "\t\t\t<button class='button green edit-data-inline' id='update' type='button' ng-click=\"savePaymentMethod()\" translate>\n" +
    "\t\t\t\tSAVE_CHANGES\n" +
    "\t\t\t</button>\n" +
    "\t\t\t<button ng-hide=\"editData.is_system_defined\" class='button red edit-data-inline' id='delete' type='button' ng-click=\"deletePaymentMethod(editData.id)\" translate>\n" +
    "\t\t\t\tDELETE\n" +
    "\t\t\t</button>\n" +
    "\t\t</div>\n" +
    "\n" +
    "\t</form>\n" +
    "</div>\n"
  );


  $templateCache.put('/assets/partials/paymentMethods/adPaymentMethods.html',
    "<section  class=\"content current\">\n" +
    "\t<div data-view=\"PaymentMethodsView\" class=\"inline-edit\">\n" +
    "\t\t<header class=\"content-title float\">\n" +
    "\t\t\t<h2 translate> PAYMENT_METHODS </h2>\n" +
    "\t\t\t<span class=\"count\"> (\n" +
    "\t\t\t\t{{data.payments.length}}\n" +
    "\t\t\t\t) </span>\n" +
    "\t\t\t<a class='action add' ng-click=\"addNew()\" translate>ADD_NEW</a>\n" +
    "\t\t</header>\n" +
    "\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t<div id = \"new-form-holder\" ng-show=\"currentClickedElement == 'new'\" ng-include=\"'/assets/partials/paymentMethods/adAddPaymentMethod.html'\"></div>\t\t\n" +
    "\n" +
    "\t\t\t<table class=\"grid\">\n" +
    "\t\t\t\t<tbody ng-repeat=\"payment in data.payments\">\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t\t<tr>\n" +
    "\t\t\t\t\t\t<td ng-if=\"payment.is_system_defined\" ng-click=\"editPaymentMethod($index)\" ng-hide=\"currentClickedElement == $index\">\n" +
    "\t\t\t\t\t\t\t<a><strong>{{payment.description}}</strong></a>\n" +
    "\t\t\t\t\t\t\t<em ng-if=\"payment.is_system_defined\" translate>SYSTEM_DEFINED</em>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td ng-if=\"!payment.is_system_defined\" ng-click=\"editPaymentMethod($index)\" ng-hide=\"currentClickedElement == $index\">\n" +
    "\t\t\t\t\t\t\t<a><strong>{{payment.description}}</strong></a>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t<td class=\"activate\" ng-hide=\"currentClickedElement == $index\">\n" +
    "\t\t\t\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t\t\t\t<td class=\"activate\" ng-hide=\"currentClickedElement == $index\">\n" +
    "\t\t\t\t\t\t\t\t\t<div class=\"entry\" >\n" +
    "\t\t\t\t\t\t\t\t\t\t<div class=\"switch-button single\"  ng-class=\"{ on : payment.is_active == 'true' }\" ng-click=\"toggleClickedPayment($index,false)\">\n" +
    "\t\t\t\t\t\t\t\t\t\t\t<input type=\"checkbox\">\n" +
    "\t\t\t\t\t\t\t\t\t\t\t<span class=\"switch-icon\"></span>\n" +
    "\t\t\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td colspan=\"3\" ng-include=\"getTemplateUrl($index)\"></td>\n" +
    "\t\t\t\t\t</tr>\n" +
    "\t\t\t\t\t<!--- Sub list for Payment type Credit card ---->\n" +
    "\t\t\t\t\t<tr ng-show=\"payment.description == 'Credit Card' && payment.is_active == 'true'\">\n" +
    "\t\t\t\t\t\t<td colspan=\"3\" class=\"nested-table\">\n" +
    "\t\t\t\t\t\t\t<table id=\"credit_cards_types\" class=\"grid\">\n" +
    "\t\t\t\t\t\t\t\t<tbody>\n" +
    "\t\t\t\t\t\t\t\t\t<tr data-credit-card-id=\"1\" ng-repeat=\"cc in data.credit_card_types\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<td ng-if=\"cc.is_system_defined\" ng-click=\"editPaymentMethodCC($index)\" ng-hide=\"currentClickedElementCC == $index\">\n" +
    "\t\t\t\t\t\t\t\t\t\t\t<a><strong>{{cc.description}}</strong></a>\n" +
    "\t\t\t\t\t\t\t\t\t\t\t<em translate>SYSTEM_DEFINED</em>\n" +
    "\t\t\t\t\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t\t\t\t\t<td ng-if=\"!cc.is_system_defined\" ng-click=\"editPaymentMethodCC($index)\" ng-hide=\"currentClickedElementCC == $index\">\n" +
    "\t\t\t\t\t\t\t\t\t\t\t<a><strong>{{cc.description}}</strong></a>\n" +
    "\t\t\t\t\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t\t\t\t\t<td class=\"activate\" ng-hide=\"currentClickedElementCC == $index\">\n" +
    "\t\t\t\t\t\t\t\t\t\t\t<div class=\"entry\" >\n" +
    "\t\t\t\t\t\t\t\t\t\t\t\t<div ng-if=\"cc.is_system_defined\" class=\"switch-button single\"  ng-class=\"{ on : cc.is_active == 'true' }\" ng-click=\"toggleClickedCC($index)\">\n" +
    "\t\t\t\t\t\t\t\t\t\t\t\t\t<input type=\"checkbox\">\n" +
    "\t\t\t\t\t\t\t\t\t\t\t\t\t<span class=\"switch-icon\"></span>\n" +
    "\t\t\t\t\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t\t\t\t\t<div ng-if=\"!cc.is_system_defined\" class=\"switch-button single\"  ng-class=\"{ on : cc.is_active == 'true' }\" ng-click=\"toggleClickedPayment($index,true)\">\n" +
    "\t\t\t\t\t\t\t\t\t\t\t\t\t<input type=\"checkbox\">\n" +
    "\t\t\t\t\t\t\t\t\t\t\t\t\t<span class=\"switch-icon\"></span>\n" +
    "\t\t\t\t\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t\t\t\t\t<td colspan=\"3\" ng-include=\"getTemplateUrlCC($index)\"></td>\n" +
    "\t\t\t\t\t\t\t\t\t</tr>\n" +
    "\t\t\t\t\t\t\t\t</tbody>\n" +
    "\t\t\t\t\t\t\t</table>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t</tr>\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t</tbody>\n" +
    "\t\t\t</table>\n" +
    "\t\t</section>\n" +
    "\t</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/rateTypes/adRateTypeAdd.html',
    "<div style=\"display: block;\" id=\"add-new\" class=\"edit-data\">\n" +
    "\t<div class=\"data-holder\">\n" +
    "\t\t<!-- Edit Brands -->\n" +
    "\t\t<form class=\"form inline-form float\">\n" +
    "\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t<h3><span translate>ADD_NEW </span>{{'RATE_TYPE' | translate}}</h3>\n" +
    "\t\t\t\t<em class=\"status\"> {{ 'MANDATORY_FIELDS_MESSAGE1' | translate }} <strong>*</strong> {{ 'MANDATORY_FIELDS_MESSAGE2' | translate }} </em>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<fieldset class=\"holder left float\">\n" +
    "\t\t\t\t<ad-textbox inputtype=\"text\" value=\"rateTypeData.name\"\n" +
    "\t\t\t\tlabel = \" {{'RATE_TYPE' | translate}}\" required = \"yes\" placeholder = \"{{'RATE_TYPE_PLACEHOLDER' | translate}}\"\n" +
    "\t\t\t\tstyleclass = \"full-width\"></ad-textbox>\n" +
    "\t\t\t</fieldset>\n" +
    "\n" +
    "\t\t\t<div class=\"actions float\">\n" +
    "\t\t\t\t<button type=\"button\" id=\"cancel\" class=\"button blank edit-data-inline\"  ng-click=\"clickCancel()\" translate>\n" +
    "\t\t\t\t\tCANCEL\n" +
    "\t\t\t\t</button>\n" +
    "\t\t\t\t<button type=\"button\" id=\"save\" class=\"button green edit-data-inline\" ng-click=\"saveRateType()\" translate>\n" +
    "\t\t\t\t\tSAVE_CHANGES\n" +
    "\t\t\t\t</button>\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t</form>\n" +
    "\t</div>\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/rateTypes/adRateTypeEdit.html',
    "<div class=\"data-holder\" >\n" +
    "\n" +
    "\t<form class=\"form single-field-form float\">\n" +
    "\t\t<ad-textbox value=\"rateTypeData.name\" label = \"\" placeholder = \"Enter rate type\" required = \"yes\"></ad-textbox>\n" +
    "\t\t\n" +
    "\t\t<div class=\"actions float\">\n" +
    "\t\t\t<button type=\"button\" id=\"cancel\" class=\"button blank edit-data-inline\" ng-click=\"clickCancel()\" translate>\n" +
    "\t\t\t\tCANCEL\n" +
    "\t\t\t</button>\n" +
    "\t\t\t<button type=\"button\" id=\"update\" class=\"button green edit-data-inline\" ng-click=\"saveRateType()\" translate>\n" +
    "\t\t\t\tSAVE_CHANGES\n" +
    "\t\t\t</button>\n" +
    "\t\t\t<button type=\"button\" id=\"delete\" class=\"button red edit-data-inline\" ng-click=\"deleteRateType(currentClickedElement, rateTypeData.id)\" translate>\n" +
    "\t\t\t\tDELETE\n" +
    "\t\t\t</button>\n" +
    "\t\t</div>\n" +
    "\n" +
    "\t</form>\n" +
    "</div>\n"
  );


  $templateCache.put('/assets/partials/rateTypes/adRateTypeList.html',
    "<section id=\"replacing-div-first\" class=\"content current\" ng-click='clearErrorMessage()'>\n" +
    "\t<div data-view=\"RateTypeListView\">\n" +
    "\t\t<header class=\"content-title float\">\n" +
    "\t\t\t<h2 translate> RATE_TYPES </h2>\n" +
    "\t\t\t<span class=\"count\"> ({{data.length}})</span>\n" +
    "\t\t\t<a id=\"add-new-button\" class=\"action add\" ng-click=\"addNew()\" translate>ADD_NEW</a>\n" +
    "\t\t</header>\n" +
    "\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t<div id=\"new-form-holder\" ng-show=\"currentClickedElement == 'new'\" ng-include=\"'/assets/partials/rateTypes/adRateTypeAdd.html'\"></div>\n" +
    "\n" +
    "\t\t\t<div id=\"new-form-holder\"></div>\n" +
    "\n" +
    "\t\t\t<table id=\"rate-types\" class=\"grid\">\n" +
    "\n" +
    "\t\t\t\t<tbody>\n" +
    "\n" +
    "\t\t\t\t\t<tr ng-repeat = \"ratetype in data\" data-rate-type-id=\"{{ratetype.id}}\">\n" +
    "\n" +
    "\t\t\t\t\t\t<td width = \"50%\" ng-show=\"ratetype.system_defined ===true\"><strong>{{ratetype.name}}</strong><em> {{'SYSTEM_DEFINED' | translate}}</em></td>\n" +
    "\n" +
    "\t\t\t\t\t\t<td ng-hide=\"ratetype.system_defined ===true || currentClickedElement == $index\" ng-click = \"editRateTypes($index,ratetype.id)\"><a class=\"edit-data-inline\">{{ratetype.name}} </a>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\n" +
    "\t\t\t\t\t\t<td ng-hide=\"currentClickedElement == $index\" style=\"overflow: visible;\">\n" +
    "\t\t\t\t\t\t\t<span class= \"tooltip-wrapper\" ng-mouseenter=\"showRates($index, ratetype.id, ratetype.rate_count)\" ng-mouseleave=\"mouseLeavePopover()\">\n" +
    "\t\t\t\t\t\t\t\t<em>{{ratetype.rate_count}} rates</em>\n" +
    "\t\t\t\t\t\t\t\t<span ng-class=\"{ 'tooltip-indicator': ratetype.rate_count > 0 }\">\n" +
    "\t\t\t\t\t\t\t\t\t<div ng-show = \"popoverRates.total_count > 0\" \n" +
    "\t\t\t\t\t\t\t\t\t\t class=\"tooltip\" \n" +
    "\t\t\t\t\t\t\t\t\t\t ng-class=\"{'polarize': $index >= halfwayPoint}\" \n" +
    "\t\t\t\t\t\t\t\t\t\t ng-include=\"getPopoverTemplate($index,ratetype.id)\"></div>\n" +
    "\t\t\t\t\t\t\t\t</span>\n" +
    "\t\t\t\t\t\t\t</span>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td class=\"delete\"  ng-hide=\"currentClickedElement ==$index\"><a ng-hide=\"ratetype.system_defined ===true\" id=\"3\" ng-click=\"deleteRateType($index,ratetype.id)\" class=\"icons icon-delete large-icon delete_item\"  ></a></td>\n" +
    "\n" +
    "\t\t\t\t\t\t<td class=\"activate\" ng-hide=\"currentClickedElement == $index\" >\n" +
    "\t\t\t\t\t\t\t<div class=\"entry\" >\n" +
    "\t\t\t\t\t\t\t<label ></label>\n" +
    "\t\t\t\t\t\t\t<div class=\"switch-button single\"  ng-class=\"{ on : ratetype.activated}\" ng-click=\"toggleClicked($index)\">\n" +
    "\t\t\t\t\t\t\t\t<input type=\"checkbox\" is_system_defined=\"ratetype.system_defined\"  value=\"\" name=\"\" id=\"\">\n" +
    "\t\t\t\t\t\t\t\t<span class=\"switch-icon\"></span>\n" +
    "\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t</div></td>\n" +
    "\n" +
    "\t\t\t\t\t\t<td colspan=\"4\" ng-include=\"getTemplateUrl($index,ratetype.id)\"></td>\n" +
    "\n" +
    "\t\t\t\t\t</tr>\n" +
    "\n" +
    "\t\t\t\t</tbody>\n" +
    "\t\t\t</table>\n" +
    "\t\t</section>\n" +
    "\t</div>\n" +
    "</section>\n"
  );


  $templateCache.put('/assets/partials/rateTypes/adRateTypePopover.html',
    "<div ng-show=\"$index < halfwayPoint\" class=\"title\">{{popoverRates.total_count}} {{popoverRates.results[0].rate_type.name}}</div>\n" +
    "<ul>\n" +
    "    <li ng-repeat = \"rate in popoverRates.results\" ui-sref=\"admin.rateDetails({ rateId: rate.id })\" ng-click=\"showLoader()\">{{rate.name}}</li>\n" +
    "</ul>\n" +
    "<div ng-show=\"$index >= halfwayPoint\" class=\"title\">{{popoverRates.total_count}} {{popoverRates.results[0].rate_type.name}}</div>\n"
  );


  $templateCache.put('/assets/partials/rates/adAddRateConfig.html',
    "<div class=\"config-wrapper\">\n" +
    "    <ul class=\"date-wrapper\" ng-class=\"{'inactive': currentClickedSet != $index}\">\n" +
    "        <li style=\"width:30px;\">\n" +
    "            <span class=\"icons delete_small\" ng-click=\"confirmDeleteSet(set.id, $index, set.name)\"  ng-hide=\"!is_date_range_editable(dateRange.end_date)\">&nbsp;</span>\n" +
    "        </li>\n" +
    "        <li style=\"width:25%\" ng-hide=\"currentClickedSet == $index\">{{set.name}}</li>\n" +
    "        <li ng-show=\"currentClickedSet == $index\" style=\"width:20%\">\n" +
    "            <ad-textbox disabled=\"!is_date_range_editable(dateRange.end_date)\" value=\"set.name\" style=\"width:150px; margin-top:10px;\"></ad-textbox>\n" +
    "        </li>\n" +
    "\n" +
    "        <li style=\"width:58%\">\n" +
    "            <ad-checkboxtext-left style=\"float:left;width:70px;margin:5px;\" is-disabled=\"!is_date_range_editable(dateRange.end_date)\" is-checked=\"set.monday\" ng-click=\"toggleDays($index, 'monday')\" label=\"MON\"></ad-checkboxtext-left>\n" +
    "            <ad-checkboxtext-left style=\"float:left;width:70px;margin:5px;\" is-disabled=\"!is_date_range_editable(dateRange.end_date)\" is-checked=\"set.tuesday\" ng-click=\"toggleDays($index, 'tuesday')\" label=\"TUE\"></ad-checkboxtext-left>\n" +
    "            <ad-checkboxtext-left style=\"float:left;width:70px;margin:5px;\" is-disabled=\"!is_date_range_editable(dateRange.end_date)\" is-checked=\"set.wednesday\" ng-click=\"toggleDays($index, 'wednesday')\" label=\"WED\"></ad-checkboxtext-left>\n" +
    "            <ad-checkboxtext-left style=\"float:left;width:70px;margin:5px;\" is-disabled=\"!is_date_range_editable(dateRange.end_date)\" is-checked=\"set.thursday\" ng-click=\"toggleDays($index, 'thursday')\" label=\"THU\"></ad-checkboxtext-left>\n" +
    "            <ad-checkboxtext-left style=\"float:left;width:70px;margin:5px;\" is-disabled=\"!is_date_range_editable(dateRange.end_date)\" is-checked=\"set.friday\" ng-click=\"toggleDays($index, 'friday')\" label=\"FRI\"></ad-checkboxtext-left>\n" +
    "            <ad-checkboxtext-left style=\"float:left;width:70px;margin:5px;\" is-disabled=\"!is_date_range_editable(dateRange.end_date)\" is-checked=\"set.saturday\" ng-click=\"toggleDays($index, 'saturday')\" label=\"SAT\"></ad-checkboxtext-left>\n" +
    "            <ad-checkboxtext-left style=\"float:left;width:70px;margin:5px;\" is-disabled=\"!is_date_range_editable(dateRange.end_date)\" is-checked=\"set.sunday\" ng-click=\"toggleDays($index, 'sunday')\" label=\"SUN\"></ad-checkboxtext-left>\n" +
    "        </li>\n" +
    "        \n" +
    "        <li class=\"arrow-right\" ng-hide=\"currentClickedSet == $index\">\n" +
    "            <span class=\"cursor-hand\"><img src=\"/assets/arrow-down.png\" ng-click=\"setCurrentClickedSet($index)\"></span>\n" +
    "        </li>\n" +
    "        \n" +
    "      \n" +
    "        <li ng-show=\"currentClickedSet == $index\" style=\"width:9%;\">\n" +
    "            <span class=\"icons icon-calendar\" style=\"width:40px;\" ng-click=\"popupCalendar()\" ng-hide=\"!is_date_range_editable(dateRange.end_date)\">&nbsp;</span>\n" +
    "        </li>\n" +
    "        <li ng-if=\"currentClickedSet == $index && rateData.is_hourly_rate\" style=\"width: 9%; float: right;\">\n" +
    "            <button ng-click=\"saveSet(dateRange.id, $index)\" class=\"green button\" type=\"button\">SAVE</button>\n" +
    "        </li>\n" +
    "        \n" +
    "    </ul>\n" +
    "</div>\n" +
    "\n" +
    "<div class=\"rate-config\" ng-if=\"!rateData.is_hourly_rate\">\n" +
    "    <table width=\"100%\" border=\"0\" align=\"right\" cellspacing=\"0\" cellpadding=\"0\" id=\"ratetable\" ng-show=\"currentClickedSet == $index\">\n" +
    "        <tr>\n" +
    "            <td width=\"20%\" align=\"right\">&nbsp;</td>\n" +
    "            <td width=\"2%\">&nbsp;</td>\n" +
    "            <td width=\"16%\" align=\"left\">Single ({{currencySymbol}})</td>\n" +
    "            <td width=\"5%\" align=\"center\">&nbsp;</td>\n" +
    "            <td width=\"16%\" align=\"left\">Double ({{currencySymbol}})</td>\n" +
    "            <td width=\"4%\" align=\"center\">&nbsp;</td>\n" +
    "            <td width=\"16%\" align=\"left\">Extra Adult (+{{currencySymbol}})</td>\n" +
    "            <td width=\"4%\" align=\"center\">&nbsp;</td>\n" +
    "            <td width=\"16%\" align=\"left\">Child (+{{currencySymbol}})</td>\n" +
    "            <td width=\"4%\" align=\"center\">&nbsp;</td>\n" +
    "        </tr>\n" +
    "        <tr ng-repeat=\"room_rate in set.room_rates\">\n" +
    "            <td align=\"right\" class=\"room-type\">{{room_rate.name}}</td>\n" +
    "            <td align=\"center\">&nbsp;</td>\n" +
    "            <td align=\"left\">\n" +
    "                <div class =\"rate_entry\">\n" +
    "                    <input type=\"text\" ng-model=\"room_rate.single\" ng-disabled=\"!is_date_range_editable(dateRange.end_date)\" ng-change=\"rateSetChanged(dateRange, $index)\">\n" +
    "                </div>\n" +
    "            </td>\n" +
    "            <td align=\"center\" ng-hide=\"!is_date_range_editable(dateRange.end_date)\">\n" +
    "                <span class=\"icons right-arrow-grey\" ng-click=\"moveSingleToDouble($parent.$index,$index)\">&nbsp;</span>\n" +
    "            </td>\n" +
    "            <!-- To compensate for arrows. in date range not editable case -->\n" +
    "            <td align=\"center\" ng-show=\"!is_date_range_editable(dateRange.end_date)\">\n" +
    "                &nbsp;\n" +
    "            </td>\n" +
    "\n" +
    "            <td align=\"left\">\n" +
    "                <div class =\"rate_entry\"><input type=\"text\" ng-model=\"room_rate.double\" ng-disabled=\"!is_date_range_editable(dateRange.end_date)\" ng-change=\"rateSetChanged(dateRange, $index)\"></div>\n" +
    "            </td>\n" +
    "            <td align=\"center\">&nbsp;</td>\n" +
    "            <td align=\"left\">\n" +
    "                <div class =\"rate_entry\"><input type=\"text\" ng-model=\"room_rate.extra_adult\" ng-disabled=\"!is_date_range_editable(dateRange.end_date)\" ng-change=\"rateSetChanged(dateRange, $index)\"></div>\n" +
    "            </td>\n" +
    "            <td align=\"center\">&nbsp;</td>\n" +
    "            <td align=\"left\">\n" +
    "                <div class =\"rate_entry\"><input type=\"text\" ng-model=\"room_rate.child\" ng-disabled=\"!is_date_range_editable(dateRange.end_date)\" ng-change=\"rateSetChanged(dateRange, $index)\"></div>\n" +
    "            </td>\n" +
    "            <td align=\"center\">&nbsp;</td>\n" +
    "        </tr>\n" +
    "      <tr>\n" +
    "        <td width=\"20%\" align=\"right\">&nbsp;</td>\n" +
    "        <td width=\"2%\">&nbsp;</td>\n" +
    "        <td width=\"16%\" align=\"left\">&nbsp;</td>\n" +
    "        <td width=\"4%\" align=\"center\">\n" +
    "            <span class=\"icons right-arrow-green\" ng-hide=\"!is_date_range_editable(dateRange.end_date)\" ng-click=\"moveAllSingleToDouble($index)\">&nbsp;</span>\n" +
    "        </td>\n" +
    "        <td width=\"16%\" align=\"left\">&nbsp;</td>\n" +
    "        <td width=\"4%\" align=\"center\">&nbsp;</td>\n" +
    "        <td width=\"15%\" style=\"text-align:right;\" colspan=\"3\">\n" +
    "            <button type=\"button\" class=\"button\" ng-click=\"saveSet(dateRange.id, $index)\" ng-hide=\"set.isSaved\" ng-disabled=\"!checkFieldEntered($index)\" ng-class=\"(set.isEnabled) ? 'green' : 'grey'\">SAVE&nbsp;SET</button>\n" +
    "            <button type=\"button\" class=\"button\" ng-click=\"saveSet(dateRange.id, $index)\" ng-show=\"set.isSaved\" ng-disabled=\"!checkFieldEntered($index)\" ng-class=\"(set.isEnabled) ? 'green' : 'grey'\">UPDATE&nbsp;SET</button>\n" +
    "            <button type=\"button\" ng-click=\"collapse($index)\" class=\"button blank\">\n" +
    "                Cancel\n" +
    "            </button>\n" +
    "        </td>\n" +
    "\n" +
    "         </tr>\n" +
    "       \n" +
    "    </table>\n" +
    "</div>\n" +
    "\n" +
    "\n" +
    "<div class=\"rate-config\" ng-if=\"rateData.is_hourly_rate\" ng-show=\"currentClickedSet == $index\">\n" +
    "    <div class=\"hourly-config day\">\n" +
    "        <label class=\"day_rates\">Day Rates</label>\n" +
    "        <table width=\"100%\" border=\"0\" align=\"right\" cellspacing=\"0\" cellpadding=\"0\" id=\"ratetable\">\n" +
    "            <tr class=\"day_night_rates\">                \n" +
    "                <td width=\"5%\" align=\"left\">Min. Hours</td>\n" +
    "                <td width=\"1%\" align=\"center\">&nbsp;</td>\n" +
    "                <td width=\"5%\" align=\"left\">Max. hours</td>\n" +
    "                <td width=\"1%\" align=\"center\">&nbsp;</td>\n" +
    "                <td width=\"13%\" align=\"left\">Check out cut-off</td>                \n" +
    "            </tr>\n" +
    "            <tr>               \n" +
    "                <td align=\"left\">\n" +
    "                    <div class =\"rate_entry\">\n" +
    "                        <input ng-model=\"set.day_min_hours\" type=\"text\" >\n" +
    "                    </div>\n" +
    "                </td>\n" +
    "                <td align=\"center\">&nbsp;</td>\n" +
    "\n" +
    "                <td align=\"left\">\n" +
    "                    <div class =\"rate_entry\">\n" +
    "                        <input ng-model=\"set.day_max_hours\" type=\"text\" >\n" +
    "                    </div>\n" +
    "                </td>\n" +
    "                <td align=\"center\">&nbsp;</td>\n" +
    "                <td align=\"left\">\n" +
    "                    <div class=\"entry full-width float\">\n" +
    "                        <div class=\"select select-col col1-3\">\n" +
    "\n" +
    "                            <select ng-model=\"set.checkout.hh\" class=\"styled\">\n" +
    "                                <option value=\"\" data-text=\"Not set\" class=\"placeholder\">HH</option>\n" +
    "                                <option ng-repeat=\"i in [1, 12, 1, 2] | makeRange\" value=\"{{i}}\" ng-selected=\"i==set.checkout.hh\">{{i}}</option>\n" +
    "                            </select>\n" +
    "                        </div>\n" +
    "                        <div class=\"select select-col col1-3\">\n" +
    "\n" +
    "                            <select ng-model=\"set.checkout.mm\">\n" +
    "                                <option value=\"\" data-text=\"Not set\" class=\"placeholder\">MM</option>\n" +
    "                                <option ng-repeat=\"i in [0, 45, 15, 2] | makeRange\" value=\"{{i}}\" ng-selected=\"i==set.checkout.mm\">{{i}}</option>\n" +
    "                            </select>\n" +
    "                        </div>\n" +
    "                        <div class=\"select select-col col1-3\">\n" +
    "                            <select ng-model=\"set.checkout.am\" name=\"hotel-checkout-primetime\" class=\"styled\">\n" +
    "                                <option value=\"AM\" selected=\"\" translate>AM</option>\n" +
    "                                <option value=\"PM\" translate>PM</option>\n" +
    "                            </select>\n" +
    "                        </div>\n" +
    "                    </div>\n" +
    "                </td>                \n" +
    "            </tr>           \n" +
    "        </table>\n" +
    "    </div>\n" +
    "   <!--  <div style=\"width:10%\"></div> -->\n" +
    "    <div class=\"full-width\">\n" +
    "        <label class=\"night_rates\">Night Rates</label>\n" +
    "        <table width=\"100%\" border=\"0\" align=\"right\" cellspacing=\"0\" cellpadding=\"0\" id=\"ratetable\" >\n" +
    "            <tr class=\"day_night_rates\">\n" +
    "                <td width=\"11%\" align=\"left\">NIGHT STARTS</td>\n" +
    "                <td width=\"1%\" align=\"center\">&nbsp;</td>\n" +
    "                <td width=\"11%\" align=\"left\">NIGHT ENDS</td>\n" +
    "                <td width=\"1%\" align=\"center\">&nbsp;</td>\n" +
    "                <td width=\"11%\" align=\"left\">CHECK OUT CUT-OFF</td>\n" +
    "                <td width=\"1%\" align=\"center\">&nbsp;</td>\n" +
    "                <td width=\"6%\" align=\"left\">&nbsp;</td>\n" +
    "            </tr>\n" +
    "            <tr>\n" +
    "                <td align=\"left\">\n" +
    "                   <div class=\"entry full-width float\">\n" +
    "                        <div class=\"select select-col col1-3\">\n" +
    "\n" +
    "                            <select ng-model=\"set.dusk.hh\" class=\"styled\">\n" +
    "                                <option value=\"\" data-text=\"Not set\" class=\"placeholder\">HH</option>\n" +
    "                                <option ng-repeat=\"i in [1, 12, 1, 2] | makeRange\" value=\"{{i}}\" ng-selected=\"i==set.dusk.hh\">{{i}}</option>\n" +
    "                            </select>\n" +
    "                        </div>\n" +
    "                        <div class=\"select select-col col1-3\">\n" +
    "\n" +
    "                            <select ng-model=\"set.dusk.mm\">\n" +
    "                                <option value=\"\" data-text=\"Not set\" class=\"placeholder\">MM</option>\n" +
    "                                <option ng-repeat=\"i in [0, 45, 15, 2] | makeRange\" value=\"{{i}}\" ng-selected=\"i==set.dusk.mm\">{{i}}</option>\n" +
    "                            </select>\n" +
    "                        </div>\n" +
    "                        <div class=\"select select-col col1-3\">\n" +
    "                            <select ng-model=\"set.dusk.am\" name=\"hotel-checkout-primetime\" class=\"styled\">\n" +
    "                                <option value=\"AM\" selected=\"\" translate>AM</option>\n" +
    "                                <option value=\"PM\" translate>PM</option>\n" +
    "                            </select>\n" +
    "                        </div>\n" +
    "                    </div>\n" +
    "                </td>\n" +
    "                <td align=\"center\">&nbsp;</td>\n" +
    "\n" +
    "                <td align=\"left\">\n" +
    "                    <div class=\"entry full-width float\">\n" +
    "                        <div class=\"select select-col col1-3\">\n" +
    "\n" +
    "                            <select ng-model=\"set.dawn.hh\" class=\"styled\">\n" +
    "                                <option value=\"\" data-text=\"Not set\" class=\"placeholder\">HH</option>\n" +
    "                                <option ng-repeat=\"i in [1, 12, 1, 2] | makeRange\" value=\"{{i}}\" ng-selected=\"i==set.dawn.hh\">{{i}}</option>\n" +
    "                            </select>\n" +
    "                        </div>\n" +
    "                        <div class=\"select select-col col1-3\">\n" +
    "\n" +
    "                            <select ng-model=\"set.dawn.mm\">\n" +
    "                                <option value=\"\" data-text=\"Not set\" class=\"placeholder\">MM</option>\n" +
    "                                <option ng-repeat=\"i in [0, 45, 15, 2] | makeRange\" value=\"{{i}}\" ng-selected=\"i==set.dawn.mm\">{{i}}</option>\n" +
    "                            </select>\n" +
    "                        </div>\n" +
    "                        <div class=\"select select-col col1-3\">\n" +
    "                            <select ng-model=\"set.dawn.am\" name=\"hotel-checkout-primetime\" class=\"styled\">\n" +
    "                                <option value=\"AM\" selected=\"\" translate>AM</option>\n" +
    "                                <option value=\"PM\" translate>PM</option>\n" +
    "                            </select>\n" +
    "                        </div>\n" +
    "                    </div>\n" +
    "                </td>\n" +
    "                <td align=\"center\">&nbsp;</td>\n" +
    "\n" +
    "                <td align=\"left\">\n" +
    "                    <div class=\"entry full-width float\">\n" +
    "                        <div class=\"select select-col col1-3\">\n" +
    "                            <select ng-model=\"set.night_checkout.hh\" class=\"styled\">\n" +
    "                                <option value=\"\" data-text=\"Not set\" class=\"placeholder\">HH</option>\n" +
    "                                <option ng-repeat=\"i in [1, 12, 1, 2] | makeRange\" value=\"{{i}}\" ng-selected=\"i==set.night_checkout.hh\">{{i}}</option>\n" +
    "                            </select>\n" +
    "                        </div>\n" +
    "                        <div class=\"select select-col col1-3\">\n" +
    "                            <select ng-model=\"set.night_checkout.mm\">\n" +
    "                                <option value=\"\" data-text=\"Not set\" class=\"placeholder\">MM</option>\n" +
    "                                <option ng-repeat=\"i in [0, 45, 15, 2] | makeRange\" value=\"{{i}}\" ng-selected=\"i==set.night_checkout.mm\">{{i}}</option>\n" +
    "                            </select>\n" +
    "                        </div>\n" +
    "                        <div class=\"select select-col col1-3\">\n" +
    "                            <select ng-model=\"set.night_checkout.am\" name=\"hotel-checkout-primetime\" class=\"styled\">\n" +
    "                                <option value=\"AM\" selected=\"\" translate>AM</option>\n" +
    "                                <option value=\"PM\" translate>PM</option>\n" +
    "                            </select>\n" +
    "                        </div>\n" +
    "                    </div>\n" +
    "                </td>\n" +
    "                <td align=\"center\">&nbsp;</td>\n" +
    "\n" +
    "                <td align=\"left\">\n" +
    "                    <div class =\"rate_entry\">\n" +
    "                        <button ng-if=\"!set.isSaved\" ng-click=\"saveSet(dateRange.id, $index, 'saveGrid')\" class=\"green button\" type=\"button\">Create</button>\n" +
    "                        <button ng-if=\"set.isSaved\" ng-click=\"saveSet(dateRange.id, $index, 'saveGrid')\" class=\"green button\" type=\"button\">Update</button>\n" +
    "                    </div>\n" +
    "                </td>                \n" +
    "            </tr>\n" +
    "           \n" +
    "           \n" +
    "        </table>\n" +
    "    </div>\n" +
    "\n" +
    "\n" +
    "    <div class=\"hourly_rates_grid\" ng-show=\"set.showRoomRate || set.isSaved\">\n" +
    "        <div class=\"night_rates\">\n" +
    "            <table width=\"100%\" border=\"0\" align=\"left\" cellspacing=\"0\" cellpadding=\"0\">\n" +
    "                <tr>\n" +
    "                    <td width=\"10%\" align=\"right\">&nbsp;</td>\n" +
    "                    <td width=\"2%\">&nbsp;</td>                    \n" +
    "                </tr>\n" +
    "                <tr ng-repeat=\"room_rate in set.room_rates\">\n" +
    "                    <td align=\"right\" class=\"room-type\">{{room_rate.name}}</td>\n" +
    "                    <td align=\"center\">&nbsp;</td>                    \n" +
    "                </tr>\n" +
    "            </table>\n" +
    "        </div>\n" +
    "        <div id=\"hourlyRateDraw\" ng-init=\"hourlyDraw = false\">            \n" +
    "            <div class=\"draw\" ng-class=\"{'closed':!hourlyDraw , 'open':hourlyDraw}\">                \n" +
    "                <span ng-click=\"hourlyDraw = !hourlyDraw\" ng-class=\"{'closed':!hourlyDraw , 'open':hourlyDraw}\">Increments & Nightly Rates</span>                \n" +
    "                <table width=\"100%\" border=\"0\" align=\"left\" cellspacing=\"0\" cellpadding=\"0\">\n" +
    "                    <tr>\n" +
    "                        <td width=\"30%\" align=\"right\">ADD PER HOUR ON DAY RATE</td>\n" +
    "                        <td width=\"2%\">&nbsp;</td>\n" +
    "                        <td class=\"nightly\" width=\"30%\" align=\"center\">NIGHLTY RATE</td>                    \n" +
    "                        <td width=\"2%\" align=\"center\">&nbsp;</td>\n" +
    "                        <td class=\"nightly\" width=\"30%\" align=\"center\">ADD HOURLY IN DAY ON RATE</td>                    \n" +
    "                        <td width=\"2%\" align=\"center\">&nbsp;</td>\n" +
    "                    </tr>\n" +
    "                    <tr ng-repeat=\"room_rate in set.room_rates\">\n" +
    "                        <td align=\"left\">\n" +
    "                            <div class =\"night_rate_entry\">\n" +
    "                                <input ng-model=\"room_rate.day_per_hour\" type=\"text\">\n" +
    "                            </div>                        \n" +
    "                        </td>\n" +
    "                        <td align=\"center\">&nbsp;</td>\n" +
    "                        <td align=\"left\">\n" +
    "                            <div class =\"night_rate_entry\">\n" +
    "                                <input ng-model=\"room_rate.nightly_rate\" type=\"text\">\n" +
    "                            </div>                        \n" +
    "                        </td>\n" +
    "                        <td align=\"center\">&nbsp;</td>\n" +
    "                        <td align=\"left\">\n" +
    "                            <div class =\"night_rate_entry\">\n" +
    "                                <input ng-model=\"room_rate.night_per_hour\" type=\"text\">\n" +
    "                            </div>                        \n" +
    "                        </td>\n" +
    "                        <td align=\"center\">&nbsp;</td>\n" +
    "                    </tr>\n" +
    "                </table>\n" +
    "            </div>\n" +
    "        </div>\n" +
    "        <div class=\"hourly_rate_state\">\n" +
    "            <table  border=\"0\" align=\"center\" cellspacing=\"0\" cellpadding=\"0\">                \n" +
    "                <tr>\n" +
    "                    <!-- The nightly time span will be greyed out as the default nightly price applies. Add class \"default_night_price\" in <td> -->\n" +
    "                    <!-- The Day Check Out time should be indicated in colour.Add class \"day_checkout_time\"-->\n" +
    "                    <td width=\"10%\" class=\"hourly_grid_time\" align=\"center\" ng-repeat=\"i in [0, 23, 1, 2] | makeRange\" value=\"{{i}}\" ng-class=\"{'day_checkout_time' : $index == (set.checkout.am == 'AM' ? set.checkout.hh : 12 + set.checkout.hh), 'night_time' : checkNightly(set, $index) }\"> {{i}}:00</td>\n" +
    "                    <td width=\"2%\" align=\"center\">&nbsp;</td>\n" +
    "                </tr>\n" +
    "                <tr ng-repeat=\"room_rate in set.room_rates\">\n" +
    "                    <td width=\"10%\" align=\"center\" ng-repeat=\"i in [0, 23, 1, 2] | makeRange\" value=\"{{i}}\">\n" +
    "\n" +
    "                        <!-- The nightly time span will be greyed out as the default nightly price applies. Add class \"default_night_price\" along with \"night_rate_entry\"-->\n" +
    "                        <div class =\"night_rate_entry\" ng-class=\"{'default_night_price' : checkNightly(set, $index)}\">\n" +
    "                            <input ng-disabled=\"checkNightly(set, $index)\" ng-model=\"room_rate.hourly[$index]\" type=\"text\">\n" +
    "                        </div>\n" +
    "                    </td>\n" +
    "                    \n" +
    "                </tr>\n" +
    "              \n" +
    "            </table>\n" +
    "           \n" +
    "        </div>\n" +
    "\n" +
    "        <div class=\"entry movers\" ng-hide=\"true\">\n" +
    "            <span  class=\"icons icon-mover-right to-target\" data-type=\"target\">Move right</span>\n" +
    "            <span class=\"icons icon-mover-left to-source\" data-type=\"source\">Move left</span>\n" +
    "        </div>\n" +
    "    </div>\n" +
    "\n" +
    "\n" +
    "    \n" +
    "</div>\n" +
    "\n" +
    "\n" +
    "    \n" +
    "    \n" +
    "        \n" +
    "\n"
  );


  $templateCache.put('/assets/partials/rates/adAddRatesCalendarPopup.html',
    "<form ng-cloak class=\"form grey-texture-bg-color\">\n" +
    "\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t<fieldset class=\"holder full-width grey-texture-bg-color\">\n" +
    "\t\t<div class=\"form-title\">\n" +
    "\t\t\t<h3><span>Date</span>&nbsp;Range Update</h3>\n" +
    "\t\t</div>\n" +
    "\t</fieldset>\n" +
    "<fieldset class=\"from-calendar left grey-texture-bg-color\">\n" +
    "<div class=\"center_align grey-texture-bg-color\"><em>From</em>&nbsp;\n" +
    "\t<span class=\"italic_text\">{{fromDate | date:'MMMM dd, y'}}</span></div>\n" +
    "\t<div ui-date=\"fromDateOptions\" ng-model=\"fromDate\" ui-date-format=\"yy-mm-dd\"></div>\n" +
    "</fieldset>\n" +
    "<fieldset class=\"to-calendar right grey-texture-bg-color\">\n" +
    "<div class=\"center_align grey-texture-bg-color\"><em>To </em>&nbsp;\n" +
    "\t<span class=\"italic_text\">{{toDate | date:'MMMM dd, y'}}</span></div>\n" +
    "\t<div ui-date=\"toDateOptions\" ng-model=\"toDate\" ui-date-format=\"yy-mm-dd\"></div>\n" +
    "</fieldset>\n" +
    "<div class=\"actions float\">\n" +
    "\t\t\t\t<button class=\"button blank add-data-inline\" type=\"button\" ng-click=\"cancelClicked()\">Cancel</button>\n" +
    "\t\t\t\t<button class=\"button green\" ng-click=\"updateClicked()\" type=\"button\">Update Date Range</button>\n" +
    "\t\t\t</div>\n" +
    "</form>"
  );


  $templateCache.put('/assets/partials/rates/adDateRangePopover.html',
    "<div class=\"title\">{{rate.name}} - Rate date ranges</div>\n" +
    "\t<ul>\n" +
    "\t\t<li ng-repeat = \"date in popoverRates\">{{date.begin_date|date:longDateFormat}} to {{date.end_date|date:longDateFormat}}</li>\n" +
    "\t</ul>\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/rates/adNewAddon.html',
    "<div style=\"display: block;\" id=\"add-new\" class=\"edit-data\" ng-cloak>\n" +
    "\t<div class=\"data-holder\">\n" +
    "\t\t<form id=\"add-addon\" name=\"add-addon\" class=\"form inline-form float\">\n" +
    "\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t<h3>\n" +
    "\t\t\t\t\t<span>{{ addonTitle }}</span>\n" +
    "\t\t\t\t\t{{ addonSubtitle }}\n" +
    "\t\t\t\t</h3>\n" +
    "\t\t\t\t<em class=\"status\">\n" +
    "\t\t\t\t\t{{'MANDATORY_FIELDS_MESSAGE1'| translate}}\n" +
    "\t\t\t\t\t<strong>*</strong>\n" +
    "\t\t\t\t\t{{'MANDATORY_FIELDS_MESSAGE2'| translate}}\n" +
    "\t\t\t\t</em>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t\n" +
    "\t\t\t<fieldset class=\"holder left float\">\n" +
    "\t\t\t\t<ad-textbox styleclass=\"full-width\"\n" +
    "\t\t\t\t\tvalue=\"singleAddon.name\"\n" +
    "\t\t\t\t\tname=\"name\"\n" +
    "\t\t\t\t\tid=\"name\"\n" +
    "\t\t\t\t\tlabel=\"{{'NAME' | translate}}\"\n" +
    "\t\t\t\t\tplaceholder=\"{{'ENTER_ADDON_NAME' | translate}}\"\n" +
    "\t\t\t\t\trequired=\"yes\"></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t<ad-textarea rows=\"4\"\n" +
    "\t\t\t\t\tdiv-class=\"full-width\"\n" +
    "\t\t\t\t\ttext-area-class=\"full-width\"\n" +
    "\t\t\t\t\tvalue=\"singleAddon.description\"\n" +
    "\t\t\t\t\tname=\"desc\"\n" +
    "\t\t\t\t\tid=\"desc\"\n" +
    "\t\t\t\t\tlabel=\"{{'DESCRIPTION' | translate}}\"\n" +
    "\t\t\t\t\tplaceholder=\"{{'ENTER_ADDON_DESCRIPTION' | translate}}\"\n" +
    "\t\t\t\t\trequired=\"yes\"></ad-textarea>\n" +
    "\n" +
    "\t\t\t\t<div ng-hide=\"isConnectedToPMS\" class=\"entry full-width radio-check\">\n" +
    "\t\t\t\t\t<label class=\"checkbox\">\n" +
    "\t\t\t\t\t\t<span class=\"icon-form icon-checkbox\" ng-class=\"{ checked : singleAddon.bestseller }\"></span>\n" +
    "\t\t\t\t\t\t<label>{{'BESTSELLER' | translate}}</label>\n" +
    "\t\t\t\t\t\t<input type=\"checkbox\" ng-model=\"singleAddon.bestseller\">\n" +
    "\t\t\t\t\t</label>\n" +
    "\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t<div ng-hide=\"isConnectedToPMS\" class=\"entry full-width radio-check\">\n" +
    "\t\t\t\t\t<label class=\"checkbox\">\n" +
    "\t\t\t\t\t\t<span class=\"icon-form icon-checkbox\" ng-class=\"{ checked : singleAddon.rate_code_only }\"></span>\n" +
    "\t\t\t\t\t\t<label>{{'RATE_ONLY' | translate}}</label>\n" +
    "\t\t\t\t\t\t<input type=\"checkbox\" ng-model=\"singleAddon.rate_code_only\" ng-change=\"rateOnlyChanged()\">\n" +
    "\t\t\t\t\t</label>\n" +
    "\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t<div ng-hide=\"isConnectedToPMS\" class=\"entry full-width radio-check\">\n" +
    "\t\t\t\t\t<label class=\"checkbox\">\n" +
    "\t\t\t\t\t\t<span class=\"icon-form icon-checkbox\" ng-class=\"{ checked : singleAddon.is_reservation_only }\"></span>\n" +
    "\t\t\t\t\t\t<label>{{'RESERVATION_ONLY' | translate}}</label>\n" +
    "\t\t\t\t\t\t<input type=\"checkbox\" ng-model=\"singleAddon.is_reservation_only\" ng-change=\"reservationOnlyChanged()\">\n" +
    "\t\t\t\t\t</label>\n" +
    "\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t</fieldset>\n" +
    "\n" +
    "\n" +
    "\t\t\t<fieldset class=\"holder right float\">\n" +
    "\t\t\t\t<div ng-hide=\"isConnectedToPMS\" class=\"entry has-datepicker margin\">\n" +
    "                    <label>{{'FROM_DATE' | translate}}\n" +
    "                    </label>\n" +
    "                    <input type=\"text\" ng-model=\"singleAddon.begin_date_for_display\" readonly=\"\" placeholder=\"Select Start Date\" class=\"date-picker-input-small\">\n" +
    "                    <button ng-click=\"popupCalendar('From')\" class=\"ui-datepicker-trigger date-picker-small ui-datepicker-trigger-btn\" type=\"button\">\n" +
    "                         ...\n" +
    "                    </button>\n" +
    "                    <div class=\"date-delete-wrapper\">\n" +
    "                        <span class=\"icons delete_small rate_end_delete cursor_pointer date-delete\" ng-click=\"resetDate('From')\">&nbsp;</span>\n" +
    "                    </div>\n" +
    "                </div>\n" +
    "\n" +
    "\t\t\t\t\n" +
    "\t\t\t\t<div ng-hide=\"isConnectedToPMS\" class=\"entry has-datepicker margin\">\n" +
    "                    <label>{{'TO_DATE' | translate}}\n" +
    "                    </label>\n" +
    "                    <input type=\"text\" ng-model=\"singleAddon.end_date_for_display\" readonly=\"\" placeholder=\"Select End Date\" class=\"date-picker-input-small\">\n" +
    "                    <button ng-click=\"popupCalendar('To')\" class=\"ui-datepicker-trigger date-picker-small ui-datepicker-trigger-btn\" type=\"button\">\n" +
    "                         ...\n" +
    "                    </button>\n" +
    "                    <div class=\"date-delete-wrapper\">\n" +
    "                        <span class=\"icons delete_small rate_end_delete cursor_pointer date-delete\" ng-click=\"resetDate('To')\">&nbsp;</span>\n" +
    "                    </div>\n" +
    "                </div>\n" +
    "\t\t\t\n" +
    "\n" +
    "\t\t\t\t<div ng-hide=\"isConnectedToPMS\" class=\"entry\">\n" +
    "\t\t\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t\t\t<label for=\"charge-group-id\">\n" +
    "\t\t\t\t\t\t\t{{'CHARGE_GROUP' | translate}}\n" +
    "\t\t\t\t\t\t\t<strong>*</strong>\n" +
    "\t\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t\t<div class=\"select\">\n" +
    "\t\t\t\t\t\t\t<select name=\"charge-group-id\"\n" +
    "\t\t\t\t\t\t\t\tid=\"charge-group-id\"\n" +
    "\t\t\t\t\t\t\t\tng-model=\"singleAddon.charge_group_id\"\n" +
    "\t\t\t\t\t\t\t\tng-options=\"group.id as group.name for group in chargeGroups\"\n" +
    "\t\t\t\t\t\t\t\tng-change=\"chargeGroupChage()\"\n" +
    "\t\t\t\t\t\t\t\t></select>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t\t<div ng-hide=\"isConnectedToPMS\" class=\"entry\">\n" +
    "\t\t\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t\t\t<label for=\"charge-group-id\">\n" +
    "\t\t\t\t\t\t\t{{'CHARGE_CODE' | translate}}\n" +
    "\t\t\t\t\t\t\t<strong>*</strong>\n" +
    "\t\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t\t<div class=\"select\">\n" +
    "\t\t\t\t\t\t\t<select name=\"charge-code-id\"\n" +
    "\t\t\t\t\t\t\t\tid=\"charge-code-id\"\n" +
    "\t\t\t\t\t\t\t\tng-model=\"singleAddon.charge_code_id\"\n" +
    "\t\t\t\t\t\t\t\tng-options=\"code.id as code.name  + ' - ' + code.description for code in chargeCodesForChargeGrp\"></select>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</div>\t\t\t\t\t\t\t\n" +
    "\t\t\t\t\n" +
    "\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t<ad-textbox styleclass=\"full-width\"\n" +
    "\t\t\t\t\t\tvalue=\"singleAddon.amount\"\n" +
    "\t\t\t\t\t\tname=\"amount\"\n" +
    "\t\t\t\t\t\tid=\"amount\"\n" +
    "\t\t\t\t\t\tlabel=\"{{'AMOUNT' | translate}} [{{currencySymbol}}]\"\n" +
    "\t\t\t\t\t\tplaceholder=\"Enter the amount\"\n" +
    "\t\t\t\t\t\trequired=\"yes\"></ad-textbox>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t\t<div ng-hide=\"isConnectedToPMS\" class=\"entry\">\n" +
    "\t\t\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t\t\t<label for=\"amount-type-id\">\n" +
    "\t\t\t\t\t\t\t{{'AMOUNT_TYPE' | translate}} \n" +
    "\t\t\t\t\t\t\t<strong>*</strong>\n" +
    "\t\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t\t<div class=\"select\">\n" +
    "\t\t\t\t\t\t\t<select name=\"amount-type-id\"\n" +
    "\t\t\t\t\t\t\t\tid=\"amount-type-id\"\n" +
    "\t\t\t\t\t\t\t\tng-model=\"singleAddon.amount_type_id\"\n" +
    "\t\t\t\t\t\t\t\tng-options=\"type.id as type.description for type in amountTypes\"></select>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t<div ng-hide=\"isConnectedToPMS\" class=\"entry full-width\">\n" +
    "\t\t\t\t\t<label for=\"amount-type-id\">\n" +
    "\t\t\t\t\t\t{{'POST_TYPE' | translate}}\n" +
    "\t\t\t\t\t\t<strong>*</strong>\n" +
    "\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t<div class=\"select\">\n" +
    "\t\t\t\t\t\t<select name=\"post-type-id\"\n" +
    "\t\t\t\t\t\t\tid=\"post-type-id\"\n" +
    "\t\t\t\t\t\t\tng-model=\"singleAddon.post_type_id\"\n" +
    "\t\t\t\t\t\t\tng-options=\"type.id as type.description for type in postTypes\"></select>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</fieldset>\n" +
    "\n" +
    "\n" +
    "\t\t\t<div class=\"actions float\">\n" +
    "\t\t\t\t<button type=\"button\"\n" +
    "\t\t\t\t\tid=\"cancel\"\n" +
    "\t\t\t\t\tclass=\"button blank add-data-inline\"\n" +
    "\t\t\t\t\tng-click=\"cancelCliked()\">{{'CANCEL' | translate}}</button>\n" +
    "\t\t\t\t<button type=\"button\"\n" +
    "\t\t\t\t\tlike-type=\"common\"\n" +
    "\t\t\t\t\tid=\"update\"\n" +
    "\t\t\t\t\tclass=\"button green add-data-inline\"\n" +
    "\t\t\t\t\tng-click=\"addUpdateAddon()\">{{'SAVE_CHANGES' | translate}}</button>\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t</form>\n" +
    "\t</div>\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/rates/adNewRate.html',
    "<div id=\"wrapper\" class=\"content current\" ng-click=\"clearErrorMessage()\" outside-click-handler>\n" +
    "    <header class=\"content-title float\">\n" +
    "        <div>\n" +
    "            <h2 ng-if=\"!is_edit\">Add new Rate</h2>\n" +
    "            <div ng-show=\"is_edit\">\n" +
    "                <h2>Edit Rate <span>{{ rateData.name }}</span></h2>\n" +
    "            </div>\n" +
    "            <a class=\"action back\" ng-click=\"backToRates($event)\">Back to rates</a>\n" +
    "        </div>\n" +
    "    </header>\n" +
    "    <section class=\"content-scroll\">\n" +
    "        <div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "        <table class=\"grid\">\n" +
    "            <!-- Render Rate Details View -->\n" +
    "            <tr>\n" +
    "                <td ng-include=\"'/assets/partials/rates/adRatesAddDetails.html'\"></td>\n" +
    "            </tr>\n" +
    "            <!-- Render Rate Room Types View -->\n" +
    "            <!-- TODO Hide row for Add Mode -->\n" +
    "            <tr ng-show=\"rateData.id > 0\">\n" +
    "                <td ng-include=\"'/assets/partials/rates/adRatesAddRoomTypes.html'\"></td>\n" +
    "            </tr>\n" +
    "            <!-- to be done-->\n" +
    "            <tr ng-repeat =\"dateRange in rateData.date_ranges\">\n" +
    "                <td ng-include=\"'/assets/partials/rates/adRatesAddConfigure.html'\" ng-controller=\"ADRatesAddConfigureCtrl\"></td>\n" +
    "            </tr>\n" +
    "           <!--  <tr ng-show=\"rateMenu ==='ADD_NEW_DATE_RANGE'\">\n" +
    "                <td ng-include=\"'/assets/partials/rates/adRatesAddRange.html'\"></td>\n" +
    "            </tr> -->\n" +
    "\n" +
    "        </table>\n" +
    "          <div ng-show=\"rateMenu ==='ADD_NEW_DATE_RANGE'\">\n" +
    "            <div ng-include=\"'/assets/partials/rates/adRatesAddRange.html'\"></div>\n" +
    "        </div>\n" +
    "        <!-- template to add new date range -->\n" +
    "        \n" +
    "\n" +
    "        <div ng-click=\"addNewDateRange()\" ng-show=\"shouldShowAddNewDateRange()\" class=\"center_align add_new_date_range_container newset-container\"> \n" +
    "            <a class=\"icons icon-add\">\n" +
    "            <span>NEW DATE RANGE</span>\n" +
    "            </a>\n" +
    "        </div>\n" +
    "    </section>\n" +
    "</div>\n"
  );


  $templateCache.put('/assets/partials/rates/adRateAdditionalDetails.html',
    "<!-- Header Collapse View -->\n" +
    "<div ng-hide=\"detailsMenu ==='additionalDetails'\">\n" +
    "    <div class=\"form-title cursor_pointer\" ng-click=\"changeDetailsMenu('additionalDetails')\">\n" +
    "        <div class=\"rate_additional_details_heading\">\n" +
    "            ADDITIONAL DETAILS\n" +
    "            <div class=\"cursor_pointer rate_additional_details_pointers\">\n" +
    "                <img src=\"/assets/arrow-down.png\">\n" +
    "            </div>\n" +
    "        </div>\n" +
    "  </div>\n" +
    "</div>\n" +
    "<!-- Expanded View -->\n" +
    "<div ng-show=\"detailsMenu ==='additionalDetails'\" class=\"form_add_new_rate\" >\n" +
    "    <div class=\"form-title cursor_pointer \" ng-click=\"changeDetailsMenu('')\">\n" +
    "        <div class=\"rate_additional_details_heading\">\n" +
    "            ADDITIONAL DETAILS\n" +
    "            <div class=\"cursor_pointer rate_additional_details_pointers\">\n" +
    "                <img src=\"/assets/arrow-up.png\">\n" +
    "            </div>\n" +
    "        </div>       \n" +
    "  </div>\n" +
    "\t <!-- <fieldset class=\"holder full-width\"> -->\n" +
    "\t \t<fieldset class=\"holder left\">\n" +
    "                <div class=\"entry has-datepicker margin\">\n" +
    "                    <label for=\"endDate\"> end date &nbsp;<span  class=\"rate_end_date_desc\">(overrides date range)</span>\n" +
    "                    </label>\n" +
    "                    <input type=\"text\" ng-model=\"rateData.end_date_for_display\" readonly=\"\" maxlength=\"8\"  placeholder=\"Set end date\" class=\"date-picker-input-small\">\n" +
    "                    <button ng-click=\"popupCalendar()\" class=\"ui-datepicker-trigger date-picker-small\" type=\"button\">\n" +
    "                         ...\n" +
    "                    </button>\n" +
    "                    <div class=\"date-delete-wrapper\">\n" +
    "                        <span class=\"icons delete_small rate_end_delete cursor_pointer date-delete\" ng-click=\"deleteEndDate()\">&nbsp;</span>\n" +
    "                    </div>\n" +
    "                </div>\n" +
    "\t \t\t   <div class=\"entry full-width\">\n" +
    "\t \t\t   \t<div class=\"entry\" ng-hide=\"!rateTypesDetails.is_use_markets\">\n" +
    "                <label>Market</label>\n" +
    "                <div class=\"select\">\n" +
    "                    <select class=\"placeholder\" ng-model=\"rateData.market_segment_id\" ng-options=\"market.value as market.name for market in rateTypesDetails.markets\">\n" +
    "                        <option value=\"\" disabled>Select Market</option>\n" +
    "                    </select>\n" +
    "                </div>\n" +
    "                </div>\n" +
    "                <div class=\"entry\"  ng-hide=\"!rateTypesDetails.is_use_sources\">\n" +
    "                <label>Source</label>\n" +
    "                <div class=\"select\">\n" +
    "                    <select class=\"placeholder\" ng-model=\"rateData.source_id\" ng-options=\"source.value as source.name for source in rateTypesDetails.sources\">\n" +
    "                        <option value=\"\" disabled>Select Source</option>\n" +
    "                    </select>\n" +
    "                </div>\n" +
    "          \t\t</div>\n" +
    "            </div>\n" +
    "           \n" +
    "\t \t</fieldset>\n" +
    "\t \t<fieldset class=\"holder right\">\n" +
    "\t \t\t<ad-toggle-button is-checked=\"rateData.is_commission_on\" label=\"COMMISSION\"></ad-toggle-button>\n" +
    "\t \t\t<ad-toggle-button is-checked=\"rateData.is_discount_allowed_on\" label=\"DISCOUNT ALLOWED\"></ad-toggle-button>\n" +
    "\t \t\t<ad-toggle-button is-checked=\"rateData.is_suppress_rate_on\" label=\"SUPPRESS RATE\"></ad-toggle-button>\n" +
    "\t \t</fieldset>\n" +
    "\t <!-- </fieldset> -->\n" +
    "\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/rates/adRateDetailsAddons.html',
    "<!-- Header Collapse View -->\n" +
    "<div ng-hide=\"detailsMenu ==='addOns'\">\n" +
    "\t<div class=\"form-title cursor_pointer\" ng-click=\"changeDetailsMenu('addOns')\">\n" +
    "\t\t<div class=\"rate_additional_details_heading\">\n" +
    "\t\t\tADD-ONS\n" +
    "\t        <div class=\"cursor_pointer rate_additional_details_pointers\">\n" +
    "\t            <img src=\"/assets/arrow-down.png\">\n" +
    "\t        </div>\n" +
    "\t    </div>\n" +
    "\t</div>\n" +
    "</div>\n" +
    "<!-- Expanded View -->\n" +
    "<div ng-show=\"detailsMenu ==='addOns'\" class=\"form_add_new_rate\">\n" +
    "\t<div class=\"form-title cursor_pointer\" ng-click=\"changeDetailsMenu('')\">\n" +
    "\t\t<div class=\"rate_additional_details_heading\">\n" +
    "\t\t\tADD-ONS\n" +
    "            <div class=\"cursor_pointer rate_additional_details_pointers\">\n" +
    "                <img src=\"/assets/arrow-up.png\">\n" +
    "            </div>\n" +
    "\t\t</div>\n" +
    "\t</div>\n" +
    "\t<table class=\"grid rate_addons\">\n" +
    "\t\t<col width=\"20%\">\n" +
    "\t\t<col width=\"20%\">\n" +
    "\t\t<col width=\"30%\">\n" +
    "\t\t<col width=\"8%\">\n" +
    "\t\t<thead>\n" +
    "\t\t\t<th class=\"header\">ADD-ON</th>\n" +
    "\t\t\t<th class=\"header\">PRICE</th>\n" +
    "\t\t\t<th class=\"header\">INCLUSIVE/EXCLUSIVE</th>\n" +
    "\t\t\t<th class=\"header center_align\">USE</th>\n" +
    "\t\t</thead>\n" +
    "\t\t<tbody>\n" +
    "\t\t\t<tr ng-repeat=\"addon in rateData.addOns\">\n" +
    "\t\t\t\t<td>{{addon.name}}</td>\n" +
    "\t\t\t\t<td>\n" +
    "\t\t\t\t\t<span ng-show=\"addon.amount.length>0\">{{currencySymbol}} {{addon.amount |number:2}} &nbsp;&nbsp;<span class=\"rate_perstay\">{{addon.post_type.description}}</span>\n" +
    "\t\t\t\t\t</span>\n" +
    "\t\t\t\t</td>\n" +
    "\t\t\t\t<td>\n" +
    "\t\t\t\t\t<div class=\"center_align\">\n" +
    "\t\t\t\t\t\t<div class=\"float_left\">\n" +
    "\t\t\t\t\t\t\t<label class=\"radio\" ng-class=\"{checked:addon.is_inclusive_in_rate == 'true'}\">\n" +
    "\t\t\t\t\t\t\t\t<span class=\"icon-form icon-radio \" ng-class=\"{checked:addon.is_inclusive_in_rate == 'true'}\"></span>\n" +
    "\t\t\t\t\t\t\t\t<input type=\"radio\" ng-model=\"addon.is_inclusive_in_rate\" value=\"true\" class=\"change-data\">\n" +
    "\t\t\t\t\t\t\t\tInclusive\n" +
    "\t\t\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t<div class=\"float_left rates_exclusive\">\n" +
    "\t\t\t\t\t\t\t<label class=\"radio\" ng-class=\"{checked:addon.is_inclusive_in_rate == 'false'}\">\n" +
    "\t\t\t\t\t\t\t\t<span class=\"icon-form icon-radio \" ng-class=\"{checked:addon.is_inclusive_in_rate == 'false'}\"></span>\n" +
    "\t\t\t\t\t\t\t\t<input type=\"radio\" ng-model=\"addon.is_inclusive_in_rate\" value=\"false\" class=\"change-data\">\n" +
    "\t\t\t\t\t\t\t\tExclusive\n" +
    "\t\t\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</td>\n" +
    "\t\t\t\t<td><div class=\"center_align\" style=\"margin-top:-22px;\"><ad-toggle-button is-checked=\"addon.isSelected\" ></ad-toggle-button></td>\n" +
    "\t\t\t</tr>\n" +
    "\t\t</tbody>\t\t\n" +
    "\t</table>\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/rates/adRateInlineEdit.html',
    "<div class=\"data-holder\">\n" +
    "\t<form class=\"form inline-form float\" id=\"edit-rates\" rate_id=\"5\">\n" +
    "\t   <div class=\"form-title\">\n" +
    "\t      <h3>\n" +
    "\t         <span>Edit</span>\n" +
    "\t         {{rateDetailsForNonStandalone.name}}\n" +
    "\t      </h3>\n" +
    "\t      <em class=\"status\">\n" +
    "\t      Fields marked with\n" +
    "\t      <strong>*</strong>\n" +
    "\t      are mandatory!\n" +
    "\t      </em>\n" +
    "\t   </div>\n" +
    "\t   <fieldset class=\"holder left float\">\n" +
    "\t   \t\t<ad-textbox value=\"rateDetailsForNonStandalone.name\" name = \"rate-name\" id = \"rate-name\" label = \"Name\" placeholder = \"Enter rate name\" required = \"yes\" ></ad-textbox>\n" +
    "\t   \t\t<ad-textarea rows=\"4\" div-class=\"full-width\" text-area-class=\"full-width\" value=\"rateDetailsForNonStandalone.description\" label = \"Description\" placeholder = \"Enter Rate Description\"></ad-textarea>\n" +
    "\t   </fieldset>\n" +
    "\t   <div class=\"actions float\">\n" +
    "\t      <button class=\"button blank add-data-inline\" id=\"cancel\" type=\"button\" ng-click=\"clickCancelForInlineEdit()\">Cancel</button>\n" +
    "\t      <button class=\"button green add-data-inline\" id=\"update\" type=\"button\" ng-click=\"saveRateForNonStandalone()\">Save changes</button>\n" +
    "\t   </div>\n" +
    "\t</form>\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/rates/adRatePopover.html',
    "<div class=\"title\">{{popoverRates.total_count}}\n" +
    "\t<span ng-show=\"popoverRates.total_count > 1\">Rates Based on</span><span ng-hide=\"popoverRates.total_count > 1\">Rate Based on</span>\n" +
    "\t<label ng-click=\"editRatesClicked(popoverRates.results[0].based_on.id, '')\">{{popoverRates.results[0].based_on.name}}</label>\n" +
    "</div>\n" +
    "<ul>\n" +
    "\t<li ng-repeat = \"rate in popoverRates.results\" ng-click=\"editRatesClicked(rate.id, $index)\">{{rate.name}}</li>\t\t\t\n" +
    "</ul>\n"
  );


  $templateCache.put('/assets/partials/rates/adRateRulesAndRestrictions.html',
    "<!-- Header Collapse View -->\n" +
    "<div ng-hide=\"detailsMenu ==='rulesAndRestrictions'\" ng-click=\"changeDetailsMenu('rulesAndRestrictions')\" class=\"cursor_pointer\">\n" +
    "\t<div class=\"form-title cursor_pointer\" ng-click=\"changeDetailsMenu('rulesAndRestrictions')\">\n" +
    "\t\t<div class=\"rate_additional_details_heading\">\n" +
    "\t\t\tRULES & RESTRICTIONS\n" +
    "\t\t\t<div class=\"cursor_pointer rate_additional_details_pointers\">\n" +
    "\t\t\t\t<img src=\"/assets/arrow-down.png\">\n" +
    "\t\t\t</div>\n" +
    "\t\t</div>\n" +
    "\t</div>\n" +
    "</div>\n" +
    "<!-- Expanded View for hourly -->\n" +
    "<div ng-if=\"detailsMenu ==='rulesAndRestrictions' && rateData.is_hourly_rate\" class=\"form_add_new_rate\" >\n" +
    "\t<fieldset class=\"holder left\" ng-show=\"depositRequiredActivated\">\n" +
    "\t\t<div class=\"entry full-width rates_deposit_requirements\" >\n" +
    "\t\t\t<label>deposit requirements</label>\n" +
    "\t\t\t<div class=\"select\">\n" +
    "\t\t\t\t<select class=\"placeholder\" ng-model=\"rateData.deposit_policy_id\" ng-options=\"policy.id as policy.displayData for policy in rateTypesDetails.depositPolicies\">\n" +
    "\t\t\t\t\t<option value=\"\">Select Deposit Requirements</option>\n" +
    "\t\t\t\t</select>\n" +
    "\t\t\t</div>\n" +
    "\t\t</div>\t\t\n" +
    "\t</fieldset>\n" +
    "\t<fieldset class=\"holder right\" ng-show=\"cancelPenaltiesActivated\">\n" +
    "\t\t<div class=\"entry full-width\" >\n" +
    "\t\t\t<label>cancellation penalties</label>\n" +
    "\t\t\t<div class=\"select\">\n" +
    "\t\t\t\t<select class=\"placeholder\" ng-model=\"rateData.cancellation_policy_id\" ng-options=\"penalty.id as penalty.displayData for penalty in rateTypesDetails.cancelationPenalties\">\n" +
    "\t\t\t\t\t<option value=\"\">Select Cancellation Penalties</option>\n" +
    "\t\t\t\t</select>\n" +
    "\t\t\t</div>\n" +
    "\t\t</div>\n" +
    "\t</fieldset>\n" +
    "</div>\n" +
    "<!-- Expanded View for non hourly -->\n" +
    "<div ng-if=\"detailsMenu ==='rulesAndRestrictions' && !rateData.is_hourly_rate\" class=\"form_add_new_rate\" >\n" +
    "\t<div class=\"form-title cursor_pointer\" ng-click=\"changeDetailsMenu('')\">\n" +
    "\t\t<div class=\"rate_additional_details_heading\">\n" +
    "\t\t\tRULES & RESTRICTIONS\n" +
    "\t\t\t<div class=\"cursor_pointer rate_additional_details_pointers\">\n" +
    "\t\t\t\t<img src=\"/assets/arrow-up.png\">\n" +
    "\t\t\t</div>\n" +
    "\t\t</div>\n" +
    "\t</div>\n" +
    "\t<!-- <fieldset class=\"holder full-width\"> -->\n" +
    "\t<fieldset class=\"holder left\">\n" +
    "\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t<ad-textbox inputtype=\"text\" value=\"rateData.min_advanced_booking\" label = \"min. advanced booking\" placeholder = \"Enter Number of Days\" ng-show=\"minAdvancedBookingActivated\"></ad-textbox>\n" +
    "\t\t\t<ad-textbox inputtype=\"text\" value=\"rateData.max_advanced_booking\" label = \"max. advanced booking\" placeholder = \"Enter Number of Days\" ng-show=\"maxAdvancedBookingActivated\" ></ad-textbox>\n" +
    "\t\t</div>\n" +
    "\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t<ad-textbox inputtype=\"text\" value=\"rateData.min_stay\" label = \"min. length of stay\" placeholder = \"Enter Number of Days\" ng-show=\"minStayLengthActivated\"></ad-textbox>\n" +
    "\t\t\t<ad-textbox inputtype=\"text\" value=\"rateData.max_stay\" label = \"max. length of stay\" placeholder = \"Enter Number of Days\" ng-show=\"maxStayLengthActivated\"></ad-textbox>\n" +
    "\t\t</div>\n" +
    "\t\t<!-- TODO :  part of future functionality <ad-checkbox is-checked=\"rateData.use_rate_levels\" label=\"Use Rate Levels\" div-class=\"full-width\"></ad-checkbox> -->\n" +
    "\t</fieldset>\n" +
    "\t<fieldset class=\"holder right\">\n" +
    "\t\t<div class=\"entry full-width rates_deposit_requirements\" ng-show=\"depositRequiredActivated\">\n" +
    "\t\t\t<label>deposit requirements</label>\n" +
    "\t\t\t<div class=\"select\">\n" +
    "\t\t\t\t<select class=\"placeholder\" ng-model=\"rateData.deposit_policy_id\" ng-options=\"policy.id as policy.displayData for policy in rateTypesDetails.depositPolicies\">\n" +
    "\t\t\t\t\t<option value=\"\">Select Deposit Requirements</option>\n" +
    "\t\t\t\t</select>\n" +
    "\t\t\t</div>\n" +
    "\t\t</div>\n" +
    "\t\t<div class=\"entry full-width\" ng-show=\"cancelPenaltiesActivated\">\n" +
    "\t\t\t<label>cancellation penalties</label>\n" +
    "\t\t\t<div class=\"select\">\n" +
    "\t\t\t\t<select class=\"placeholder\" ng-model=\"rateData.cancellation_policy_id\" ng-options=\"penalty.id as penalty.displayData for penalty in rateTypesDetails.cancelationPenalties\">\n" +
    "\t\t\t\t\t<option value=\"\">Select Cancellation Penalties</option>\n" +
    "\t\t\t\t</select>\n" +
    "\t\t\t</div>\n" +
    "\t\t</div>\n" +
    "\t</fieldset>\n" +
    "\t<!-- </fieldset> -->\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/rates/adRateTypePopover.html',
    "<div class=\"title\">{{popoverRates.total_count}} {{popoverRates.results[0].rate_type.name}}</div>\n" +
    "<ul>\n" +
    "\t<li ng-repeat = \"rate in popoverRates.results\" ng-click=\"editRatesClicked(rate.id, $index)\">{{rate.name}}</li>\t\t\t\t\t\t\t\t\t\n" +
    "</ul>\n" +
    "\t\t\t\t\t\t\t\t\n"
  );


  $templateCache.put('/assets/partials/rates/adRatesAddConfigure.html',
    "<!-- Collapse View -->\n" +
    "<div ng-hide=\"rateMenu === 'dateRange.{{ dateRange.id }}'\" ng-click=\"getDateRangeData(dateRange.id)\" class=\"cursor_pointer\">\n" +
    "    <span class=\"italic_text\">{{dateRange.begin_date | date:'MMMM dd, y'}}</span>\n" +
    "    <span style=\"margin:0 5px;\">to</span>\n" +
    "    <span class=\"italic_text\">{{dateRange.end_date | date:'MMMM dd, y'}}</span>  \n" +
    "    <div style=\"float:right\"><img src=\"/assets/arrow-down.png\"></div>\n" +
    "</div>\n" +
    "<!-- Expanded View -->\n" +
    "    <div ng-show=\"rateMenu === 'dateRange.{{ dateRange.id }}'\">\n" +
    "    <form class=\"form form-rate-config\">\n" +
    "        <div style=\"width:100%;\">\n" +
    "            <ul>        \n" +
    "                <li ng-click=\"closeDateRangeGrid()\" class=\"cursor-hand\">\n" +
    "                    <span  class=\"italic_text\">{{dateRange.begin_date | date:'MMMM dd, y'}}</span>\n" +
    "                    <span style=\"margin:0 5px;\">to</span>\n" +
    "                    <span  class=\"italic_text\">{{dateRange.end_date | date:'MMMM dd, y'}}</span>\n" +
    "                    <span style=\"float:right\"><img src=\"/assets/arrow-up.png\"></span>\n" +
    "\n" +
    "                </li>\n" +
    "                \n" +
    "                <br clear=\"all\"/>\n" +
    "            </ul>\n" +
    "\n" +
    "            <table width=\"100%\">\n" +
    "                <tr ng-repeat=\"set in data.sets\">\n" +
    "                    <td ng-include=\"'/assets/partials/rates/adAddRateConfig.html'\" style=\"padding:0px !important;\"></td>\n" +
    "                </tr>\n" +
    "            </table>\n" +
    "        </div>\n" +
    "    </form>\n" +
    "    <div ng-click=\"createNewSetClicked()\" class=\"center_align add_new_date_range_container\" style=\"margin-bottom: 10px;\"> \n" +
    "        <span class=\"icons icon-add cursor-hand\" style=\"display: inline;\">\n" +
    "        <span class=\"cursor-hand\" ng-class=\"{'inactive': !isAllSetsSaved()}\">NEW SET</span>\n" +
    "    </div>\n" +
    "</div>\n"
  );


  $templateCache.put('/assets/partials/rates/adRatesAddDetails.html',
    "<!-- Header Collapse View -->\n" +
    "<div ng-hide=\"rateMenu ==='Details'\" ng-click=\"$emit('changeMenu','Details')\" class=\"cursor_pointer\">\n" +
    "\t<em class=\"rate_step_title\">Rate</em>&nbsp;<span class=\"italic_text\">Details</span>\n" +
    "\t<div class=\"rate_additional_details_pointers\"><img src=\"/assets/arrow-down.png\">\n" +
    "\t</div>\n" +
    "</div>\n" +
    "\n" +
    "<!-- Expanded View -->\n" +
    "<form ng-show=\"rateMenu ==='Details'\" class=\"form float form_add_new_rate\" ng-controller=\"ADaddRatesDetailCtrl\" >\n" +
    "\t<fieldset class=\"holder full-width\">\n" +
    "\t\t<div class=\"form-title\">\n" +
    "\t\t\t<h3><span>Rate</span> Details </h3>\n" +
    "\t\t\t<em class=\"status\"> Fields marked with <strong>*</strong> are mandatory! </em>\n" +
    "\t\t</div>\n" +
    "\t\t<fieldset class=\"holder left\">\n" +
    "\t\t\t<div></div>\n" +
    "\t\t\t<ad-textbox styleclass=\"full-width\" inputtype=\"text\" value=\"rateData.name\" label = \"Name\" placeholder = \"Enter Rate Name\" required=\"yes\"></ad-textbox>\n" +
    "\t\t\t<div class=\"entry margin\">\n" +
    "\t\t\t\t<label>Type <strong>*</strong> </label>\n" +
    "\t\t\t\t<div class=\"select\">\n" +
    "\t\t\t\t\t<select class=\"placeholder\" ng-model=\"rateData.rate_type.id\" ng-options=\"rate_type.id as rate_type.name for rate_type in rateTypesDetails.rate_types\">\n" +
    "\t\t\t\t\t\t<option value=\"\" disabled>Select Rate Type</option>\n" +
    "\t\t\t\t\t</select>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<div class=\"entry\" ng-if=\"isHourlyRatesEnabled\">\n" +
    "\t\t\t\t<label>Periodicity </label>\n" +
    "\t\t\t\t<div class=\"switch\" ng-class=\"{'disabled' : rateData.date_ranges.length > 1}\">\n" +
    "\t\t\t\t\t<span ng-click=\"toggleHourlyRate(true)\" ng-class=\"{'active' : rateData.is_hourly_rate}\">Hourly</span>\n" +
    "\t\t\t\t\t<span ng-click=\"toggleHourlyRate(false)\" ng-class=\"{'active' : !rateData.is_hourly_rate}\">Daily</span>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<div class=\"entry margin\">\n" +
    "\t\t\t\t<label>Charge code <strong>*</strong> </label>\n" +
    "\t\t\t\t<div class=\"select\">\n" +
    "\n" +
    "\t\t\t\t\t<select class=\"placeholder\" ng-model=\"rateData.charge_code_id\" ng-options=\"charge_code.id as charge_code.description for charge_code in rateTypesDetails.charge_codes\">\n" +
    "\t\t\t\t\t\t<option value=\"\">Select Charge Code</option>\n" +
    "\t\t\t\t\t</select>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t\t<div class=\"entry \">\n" +
    "\n" +
    "\t\t\t\t<div class=\" select-col col1-2 disabled-bg\" >\n" +
    "\n" +
    "\t\t\t\t\t<ad-textbox label = \"Tax\" inputtype=\"text\" value=\"rateData.tax_inclusive_or_exclusive\" readonly='yes' styleclass = \"col1-2\"\n" +
    "\t\t\t\t\tlabel = \"\" placeholder = \"\" style=\" width: 100px;\"></ad-textbox>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t\t<label style=\" padding-left: 113px;\">currency <strong>*</strong> </label>\n" +
    "\n" +
    "\t\t\t\t<div class=\"select select-col col1-2 \" style=\"float: right;\">\n" +
    "\t\t\t\t\t<select class=\"placeholder\" disabled=\"disabled\" class=\"styled\">\n" +
    "\t\t\t\t\t\t<option selected>{{currencySymbol}}</option>\n" +
    "\t\t\t\t\t</select>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<!-- CICO-9289 Hourly Rates Hiding the Based On thing until implementation is completed -->\n" +
    "\t\t\t<!-- TODO : Once thebased on rates is handled for hourly, do away with the ng-show conditon -->\n" +
    "\t\t\t<div class=\"entry margin\" ng-show=\"!rateData.is_hourly_rate\">\n" +
    "\t\t\t\t<label ng-hide=\"isPromotional() || hideBasedOn()\">Based On</label>\n" +
    "\t\t\t\t<label ng-show=\"isPromotional()\">Copy From</label>\n" +
    "\t\t\t\t<div class=\"select\" ng-hide= \"!isPromotional() && hideBasedOn()\">\n" +
    "\t\t\t\t\t<select class=\"placeholder\" ng-model=\"rateData.based_on.id\" ng-options=\"basedOnrateType.id as basedOnrateType.name for basedOnrateType in rateTypesDetails.based_on.results\">\n" +
    "\t\t\t\t\t\t<option value=\"\">Select Rate</option>\n" +
    "\t\t\t\t\t</select>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<!-- CICO-9289 Hourly Rates Hiding the Based On thing until implementation is completed -->\n" +
    "\t\t\t<!-- TODO : Once thebased on rates is handled for hourly, do away with the rateData.is_hourly_rate in ng-hide conditon -->\n" +
    "\t\t\t<div class=\"entry\" ng-hide=\"hideBasedOn() || rateData.is_hourly_rate\">\n" +
    "\t\t\t\t<div class=\"select select-col col1-3 actions_margin_top\">\n" +
    "\t\t\t\t\t<select  class=\"styled\" ng-model=\"rateData.based_on.value_sign\">\n" +
    "\t\t\t\t\t\t<option value=\"+\">+</option>\n" +
    "\t\t\t\t\t\t<option value=\"-\">-</option>\n" +
    "\t\t\t\t\t</select>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t\t<div class=\" select-col col1-3 actions_margin_top\" >\n" +
    "\t\t\t\t\t<ad-textbox inputtype=\"text\" value=\"rateData.based_on.value_abs\" styleclass = \"col1-3\"\n" +
    "\t\t\t\t\tlabel = \"\" placeholder = \"\" style=\" width: 66px;\"\n" +
    "\t\t\t\t\t></ad-textbox>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\t\t\t\t\t<select class=\"styled\" ng-model=\"rateData.based_on.type\">\n" +
    "\t\t\t\t\t\t<option value=\"amount\" >{{currencySymbol}}</option>\n" +
    "\t\t\t\t\t\t<option value=\"percent\">%</option>\n" +
    "\t\t\t\t\t</select>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</div>\n" +
    "\t\t</fieldset>\n" +
    "\n" +
    "\t\t<fieldset class=\"holder right\">\n" +
    "\t\t\t<ad-textarea rows=\"2\" div-class=\"full-width\" text-area-class=\"full-width rate_description\" value=\"rateData.description\" label = \"Description \" placeholder = \"Enter Rate Description\" required=\"true\"></ad-textarea>\n" +
    "\t\t</fieldset>\n" +
    "\t\t<fieldset class=\"holder left\" ng-show=\"isPromotional()\">\n" +
    "\t\t\t<ad-textbox inputtype=\"text\" value=\"rateData.promotion_code\" label = \"Promotions Code\" placeholder = \"Enter Promotional Code\" required=\"no\"></ad-textbox>\n" +
    "\t\t</fieldset>\n" +
    "\n" +
    "\t\t<div ng-include=\"'/assets/partials/rates/adRateAdditionalDetails.html'\"></div>\n" +
    "\t\t<div ng-include=\"'/assets/partials/rates/adRateRulesAndRestrictions.html'\"></div>\n" +
    "\t\t<div ng-include=\"'/assets/partials/rates/adRateDetailsAddons.html'\"></div>\n" +
    "\n" +
    "\t</fieldset>\n" +
    "\t<div class=\"actions float actions_margin_top\">\n" +
    "\t\t<button type=\"button\" ng-click=\"cancelMenu()\" class=\"button blank add-data-inline\">\n" +
    "\t\t\tCancel\n" +
    "\t\t</button>\n" +
    "\t\t<button type=\"button\" ng-hide=\"rateData.id > 0\" ng-click=\"saveRateDetails()\" ng-disabled=\"!isFormValid()\" class=\"button\" ng-class=\"{ 'brand-colors' : isFormValid() }\" >\n" +
    "\t\t\tStep 2 - Select Room Types\n" +
    "\t\t</button>\n" +
    "\t\t<button type=\"button\" ng-show=\"rateData.id > 0\" ng-click=\"saveRateDetails()\" ng-disabled=\"!isFormValid()\" class=\"button\" ng-class=\"{ 'green' : (rateData.id > 0 && isFormValid()) }\">\n" +
    "\t\t\tSave\n" +
    "\t\t</button>\n" +
    "\t</div>\n" +
    "</form>\n"
  );


  $templateCache.put('/assets/partials/rates/adRatesAddRange.html',
    "<form class=\"form\" ng-controller=\"ADAddRateRangeCtrl\">\n" +
    "\t<div class=\"grey-texture-bg-color\" style=\"padding:2%;\">\n" +
    "\t\t<!--<fieldset class=\"holder full-width\">\n" +
    "\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t<h3><span>Date</span>&nbsp;Range</h3>\n" +
    "\t\t\t</div>\n" +
    "\t\t</fieldset>-->\n" +
    "\t\t<!--BEGIN NEW INSERT-->\n" +
    "\t\t<fieldset class=\"holder full-width grey-texture-bg-color\" style=\"margin-bottom:0px;\">\n" +
    "\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t<h3><span>Date</span>&nbsp;Range Update</h3>\n" +
    "\t\t\t</div>\n" +
    "\t\t</fieldset>\n" +
    "\t\t<!--END NEW INSERT-->\n" +
    "\t\t<fieldset class=\"from-calendar left\">\n" +
    "\t\t\t<div class=\"center_align\"><em>From</em>&nbsp;\n" +
    "\t\t\t\t<span class=\"italic_text\" ng-show=\"begin_date.length>0\">{{begin_date | date:'MMMM dd, y'}}</span>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<div ui-date=\"fromDateOptions\" ng-model=\"begin_date\" ui-date-format=\"yy-mm-dd\"></div>\n" +
    "\t\t</fieldset>\n" +
    "\t\t<fieldset class=\"to-calendar right\">\n" +
    "\t\t\t<div class=\"center_align\"><em>To </em>&nbsp;\n" +
    "\t\t\t\t<span  class=\"italic_text\">{{end_date | date:'MMMM dd, y'}}</span>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<div ui-date=\"toDateOptions\" ng-model=\"end_date\" ui-date-format=\"yy-mm-dd\"></div>\n" +
    "\t\t</fieldset>\n" +
    "\t\t<table class=\"date_range_set_table\">\n" +
    "\t\t\t<tr ng-repeat=\"set in Sets\">\n" +
    "\t\t\t\t<td width=\"5%\">\n" +
    "\t\t\t\t\t<a class=\"icons icon-delete  delete_item\" ng-hide=\"($index === 0) && !($index ==6)\"ng-click=\"deleteSet($index)\"></a>\n" +
    "\t\t\t\t</td>\n" +
    "\t\t\t\t<td width=\"20%\">\n" +
    "\t\t\t\t\t<ad-textbox value=\"set.setName\" style=\"width:150px;\"></ad-textbox>\n" +
    "\t\t\t\t</td>\n" +
    "\t\t\t\t<td width=\"70%\" class=\"date_range_checkbox_td\">\n" +
    "\t\t\t\t\t<ad-checkboxtext-left class=\"rate_range_checkbox\" ng-repeat=\"day in set.days\" is-checked=\"day.checked\" label=\"{{day.name}}\"  ng-click=\"checkboxClicked($index,$parent.$index)\" width=\"70px\"></ad-checkboxtext-left>\t\n" +
    "\t\t\t\t</td>\n" +
    "\t\t\t\t<td>\n" +
    "\t\t\t\t\t<a class=\"icons icon-add\" ng-show=\"($index === Sets.length-1) && !($index ==6)\" ng-click=\"addNewSet($index)\"></a>\n" +
    "\n" +
    "\t\t\t\t</td>\n" +
    "\t\t\t\t<tr>\n" +
    "\t\t\t\t</table>\n" +
    "\t\t\t\t<div class=\"actions float center_align\">\n" +
    "\t\t\t\t\t<button type=\"button\" ui-sref=\"admin.rates\" class=\"button blank add-data-inline\">\n" +
    "\t\t\t\t\t\tCancel\n" +
    "\t\t\t\t\t</button>\n" +
    "\t\t\t\t\t<button type=\"button\" ng-click=\"saveDateRange()\" ng-hide=\"rateDate.date_ranges.length > 0\" class=\"button\" ng-class=\"{ 'brand-colors' : allFieldsFilled() }\" ng-disabled=\"!allFieldsFilled()\">\n" +
    "\t\t\t\t\t\tConfigure Rate\n" +
    "\t\t\t\t\t</button>\n" +
    "\t\t\t\t\t<button type=\"button\" ng-click=\"saveDateRange()\" ng-show=\"rateDate.date_ranges.length > 0\" class=\"button\" ng-class=\"{ 'green' : (rateData.id > 0 && allFieldsFilled()) }\" ng-disabled=\"allFieldsFilled()\">\tSave\n" +
    "\t\t\t\t\t</button>\n" +
    "\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</div>\n" +
    "\t\t</form>\n" +
    "\t\t\t\t<!--<div id=\"modal\" class=\"calendar-popup modal-show\">\n" +
    "\t<form ng-cloak class=\"form grey-texture-bg-color\">\n" +
    "\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t<fieldset class=\"holder full-width grey-texture-bg-color\" style=\"margin-bottom:0px;\">\n" +
    "\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t<h3><span>Date</span>&nbsp;Range Update</h3>\n" +
    "\t\t\t</div>\n" +
    "\t\t</fieldset>\n" +
    "\t\t<fieldset class=\"holder left grey-texture-bg-color\">\n" +
    "\t\t\t<div class=\"center_align grey-texture-bg-color\"><em>From</em>&nbsp;\n" +
    "\t\t\t<span class=\"italic_text\">{{currentFilterData.begin_date| date:'MMMM dd, y'}}</span></div>\n" +
    "\t\t\t<div ui-date=\"fromDateOptions\" ng-model=\"currentFilterData.begin_date\" ui-date-format=\"yy-mm-dd\"></div>\n" +
    "\t\t</fieldset>\n" +
    "\t\t<fieldset class=\"holder right grey-texture-bg-color\">\n" +
    "\t\t\t<div class=\"center_align grey-texture-bg-color\"><em>To </em>&nbsp;\n" +
    "\t\t\t<span class=\"italic_text\">{{currentFilterData.end_date | date:'MMMM dd, y'}}</span></div>\n" +
    "\t\t\t<div ui-date=\"toDateOptions\" ng-model=\"currentFilterData.end_date\" ui-date-format=\"yy-mm-dd\"></div>\n" +
    "\t\t</fieldset>\n" +
    "\t\t<div class=\"actions float\">\n" +
    "\t\t\t<button class=\"button blank add-data-inline\" type=\"button\" ng-click=\"cancelClicked()\">Cancel</button>\n" +
    "\t\t\t<button class=\"button green\" ng-click=\"updateClicked()\" type=\"button\">Ok</button>\n" +
    "\t\t</div>\n" +
    "\t</form>\n" +
    "</div>-->"
  );


  $templateCache.put('/assets/partials/rates/adRatesAddRoomTypes.html',
    "<!-- Collapse View -->\n" +
    "<div ng-hide=\"rateMenu ==='Room types'\" ng-click=\"$emit('changeMenu','Room types')\" class=\"cursor_pointer\">\n" +
    "\t<em class=\"rate_step_title\">Room</em>&nbsp;<span class=\"italic_text\">Types</span>\n" +
    "\t<div style=\"float:right\"><img src=\"/assets/arrow-down.png\"></div>\n" +
    "</div>\n" +
    "\n" +
    "<!-- Expanded View -->\n" +
    "<div ng-show=\"rateMenu ==='Room types'\" ng-controller=\"ADAddRateRoomTypeCtrl\">\n" +
    "\t<form user=\"2\"  class=\"form float form_add_new_rate\">\n" +
    "\t\t<fieldset class=\"holder full-width\">\n" +
    "\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t<h3>\n" +
    "\t\t\t\t\t<span>Room</span>\n" +
    "\t\t\t\t\tTypes\n" +
    "\t\t\t\t</h3>\n" +
    "\t\t\t\t<em class=\"status\">\n" +
    "\t\t\t\t\t<span>Assign at least 1 room type</span>\n" +
    "\t\t\t\t</em>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<div class=\"entry has-sortable\">\n" +
    "\t\t\t\t<label class=\"center_align\"><em class=\"rate_roomtype_text\">Available Room Types</em></label>\n" +
    "\n" +
    "\t\t\t\t<ul class=\"boxes sortable ui-sortable short-list\" data-type=\"source\" data-drop=\"true\" ng-model=\"nonAssignedroomTypes\" style=\"overflow-y: scroll !important;\" jqyoui-droppable=\"{multiple:true}\" data-jqyoui-options=\"{accept:'.assigned-room-types'}\">\n" +
    "\n" +
    "\t\t\t\t\t<li ng-repeat = \"roomtype in nonAssignedroomTypes\" \n" +
    "\n" +
    "\t\t\t\t\t\tdata-drag = \"true\"\n" +
    "\t\t\t\t\t\tng-model = \"nonAssignedroomTypes\"\n" +
    "\t\t\t\t\t\tjqyoui-draggable =\"{index: {{$index}}, animate:false, onStart:'hideCurrentDragItem', onStop:'showCurrentDragItem' }\"\n" +
    "\t\t\t\t\t\tdata-jqyoui-options=\"{revert: 'invalid', helper:'clone',appendTo: 'body'}\"  class=\"non-assigned-room-types li-draggable\"\n" +
    "\t\t\t\t\t\tng-click = \"unAssignedRoomSelected($event, $index)\"\n" +
    "\t\t\t\t\t\tng-class = '{selected: selectedUnAssignedRoomIndex === $index}' \n" +
    "\t\t\t\t\t\t>\n" +
    "\n" +
    "\t\t\t\t\t<span class=\"icons icon-handle\"></span>\n" +
    "\t\t\t\t\t<span class=\"icons icon-handle\"></span>\n" +
    "\t\t\t\t\t{{roomtype.name}}\n" +
    "\t\t\t\t</li>\n" +
    "\t\t\t</ul>\n" +
    "\t\t</div>\n" +
    "\t\t<div class=\"entry movers rates_mover\" >\n" +
    "\t\t\t<span class=\"top_mover\" >\n" +
    "\t\t\t\t<span class=\"icons icon-mover-right to-target\" data-type=\"target\" ng-click=\"topMoverightClicked()\"\n" +
    "\t\t\t\tng-class=\"{active: selectedUnAssignedRoomIndex!=-1}\" data-type=\"source\">unassign room(s)</span>\n" +
    "\t\t\t\t<span class=\"icons icon-mover-left to-source\" data-type=\"source\"\n" +
    "\t\t\t\tng-click=\"topMoveleftClicked()\"ng-class=\"{active: selectedAssignedRoomIndex!=-1}\">Assign room(s)</span>\n" +
    "\t\t\t</span>\n" +
    "\t\t\t<span>\n" +
    "\t\t\t\t<div class=\"green_gradient icons\">\n" +
    "\t\t\t\t\t<span class=\"to-source green_mover icons_rates\" data-type=\"source\" ng-click=\"bottomMoverightClicked()\">Assign room(s)</span>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t\t<div class=\"red_gradient icons\">\n" +
    "\t\t\t\t\t<span class=\"to-target  red_mover icons_rates\" data-type=\"target\" ng-click=\"bottomMoveleftClicked()\"\n" +
    "\t\t\t\t\t>unassign room(s)</span>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t\t\n" +
    "\t\t\t</span>\n" +
    "\t\t</div>\n" +
    "\t\t<div class=\"entry has-sortable\">\n" +
    "\t\t\t<label class=\"center_align\">\n" +
    "\t\t\t\t<span class=\"assigned_room_text\">Assigned Room Types</span></label>\n" +
    "\t\t\t\t<ul class=\"boxes sortable ui-sortable short-list\" \n" +
    "\t\t\t\t\tdata-type=\"target\" \n" +
    "\t\t\t\t\tdata-drop=\"true\" \n" +
    "\t\t\t\t\tng-model=\"assignedRoomTypes\"  \n" +
    "\t\t\t\t\tstyle=\"overflow-y: scroll !important;\" \n" +
    "\t\t\t\t\tjqyoui-droppable=\"{multiple:true, onOver: 'reachedAssignedRoomTypes'}\"  data-jqyoui-options=\"{accept:'.non-assigned-room-types'}\">\n" +
    "\t\t\t\t\t\t<li ng-repeat=\"roomtype in assignedRoomTypes\"\n" +
    "\t\t\t\t\t\tng-click=\"assignedRoomSelected($event,$index)\"\n" +
    "\t\t\t\t\t\tng-class='{selected: selectedAssignedRoomIndex === $index}' class=\"assigned-room-types li-draggable\"\n" +
    "\t\t\t\t\t\tdata-jqyoui-options=\"{revert: 'invalid', helper:'clone',appendTo: 'body'}\"\n" +
    "\t\t\t\t\t\tdata-drag = \"true\"\n" +
    "\t\t\t\t\t\tng-model = \"assignedRoomTypes\"\n" +
    "\t\t\t\t\t\tjqyoui-draggable =\"{index: {{$index}}, animate:false, onStart:'hideCurrentDragItem', onStop:'showCurrentDragItem' }\">\n" +
    "\t\t\t\t\t\t\t<span class=\"icons icon-handle\"></span>\n" +
    "\t\t\t\t\t\t\t<span class=\"icons icon-handle\"></span>\n" +
    "\t\t\t\t\t\t\t{{roomtype.name}}\n" +
    "\t\t\t\t\t\t</li> \n" +
    "\t\t\t\t</ul>\n" +
    "\t\t</div>\n" +
    "\t</fieldset>\n" +
    "\t<div class=\"actions float\">\n" +
    "\t\t<button type=\"button\" id=\"cancel\" class=\"button blank add-data-inline\" ng-click=\"cancelMenu()\">Cancel</button>\n" +
    "\t\t<button type=\"button\" id=\"send-email\" ng-hide=\"rateData.room_type_ids.length > 0\"  class=\"button\" ng-class=\"{ 'brand-colors' : anyRoomSelected() }\" ng-disabled=\"!anyRoomSelected()\" ng-click=\"saveRoomTypes()\" >\n" +
    "\t\t\tStep 3 - Set date range\n" +
    "\t\t</button>\n" +
    "\t\t<button type=\"button\" id=\"send-email\" ng-show=\"rateData.room_type_ids.length > 0\"  class=\"button\" ng-class=\"{ 'green' : (rateData.id > 0 && anyRoomSelected()) }\" ng-disabled=\"!anyRoomSelected()\" ng-click=\"saveRoomTypes()\" >\n" +
    "\t\t\tSave\n" +
    "\t\t</button>\n" +
    "\t</div>\n" +
    "</form>\n" +
    "</div>\n"
  );


  $templateCache.put('/assets/partials/rates/adRatesAdditionalDetailsPicker.html',
    "<div ui-date=\"dateOptions\" ng-model=\"rateData.end_date\" ui-date-format=\"yy-mm-dd\"></div>\n" +
    "\n"
  );


  $templateCache.put('/assets/partials/rates/adRatesAddons.html',
    "<section id=\"replacing-div-first\"\n" +
    "\t\t\tclass=\"content current\" ng-cloak ng-click=\"clearErrorMessage()\">\n" +
    "\t<div data-view=\"GuestCardLikesView\">\n" +
    "\t\t<header class=\"content-title float\">\n" +
    "\t\t\t<h2>Add-Ons</h2>\n" +
    "\t\t\t<span class=\"count\">\n" +
    "\t\t\t\t({{ totalCount }})\n" +
    "\t\t\t</span>\n" +
    "\t\t\t<a id=\"add-new-button\" ng-hide=\"isConnectedToPMS\" class=\"action add\" ng-click=\"addNew()\">{{ 'ADD_NEW' | translate }}</a>\n" +
    "\t\t\t<a class=\"action import\" ng-click=\"importFromPms($event)\" ng-show=\"isConnectedToPMS\">IMPORT FROM PMS</a>\n" +
    "\t\t</header>\n" +
    "\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_success_message.html'\"></div>\n" +
    "\t\t\t<div ng-hide=\"isAddMode\">\n" +
    "\t\t\t\t<span class=\"count-show\">Show</span>\n" +
    "\t\t\t\t<div class=\"select table-count rates-table-count\">\n" +
    "\t\t\t\t\t<select ng-model=\"displyCount\"\tng-options=\"opt for opt in displayCountList\"></select>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t\t<span class=\"count-entries\">entries</span>\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t<div class=\"entry table-search\">\n" +
    "\t\t\t\t\t<span class=\"search-text\">Search</span>\n" +
    "\t\t\t\t\t<span class=\"icons icon-search\" name=\"submit\" type=\"submit\"></span>\n" +
    "\t\t\t\t\t<input placeholder=\"\" autocomplete=\"off\" type=\"text\" ad-delay-textbox ng-model=\"searchTerm\" delay=\"1000\" function-to-fire=\"searchEntered\" />\n" +
    "\t\t\t    </div>\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\n" +
    "\t\t\t<div id=\"new-form-holder\" ng-show=\"isAddMode\" ng-include=\"getTemplateUrl()\"></div>\n" +
    "\n" +
    "\t\t\t<table id=\"addons\" class=\"grid\" ng-table=\"tableParams\" ng-hide=\"isAddMode\" template-pagination=\"custom/pager\" template-header=\"custom/header\">\n" +
    "\t\t\t\t<tbody>\n" +
    "\t\t\t\t\t<tr ng-repeat=\"item in  data track by $index\">\n" +
    "\t\t\t\t\t\t<td header-class=\"width-30\" ng-click=\"editSingle()\" ng-hide=\"currentClickedAddon === $index\" >\n" +
    "\t\t\t\t\t\t\t<a class=\"edit-data-inline\">{{ item.name }}</a>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\n" +
    "\t\t\t\t\t\t<td header-class=\"width-50\" ng-hide=\"currentClickedAddon === $index\" >\t\n" +
    "\t\t\t\t\t\t\t{{ item.description }}\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\n" +
    "\t\t\t\t\t\t<td header-class=\"width-10\" class=\"activate text-left\" ng-hide=\"currentClickedAddon === $index\">\n" +
    "\t\t\t\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t\t\t\t<div class=\"switch-button single\"\n" +
    "\t\t\t\t\t\t\t\t\t\tng-class=\"{ on: item.activated }\">\n" +
    "\t\t\t\t\t\t\t\t\t<input type = \"checkbox\"\n" +
    "\t\t\t\t\t\t\t\t\t\t\tid = \"rates-addons\"\n" +
    "\t\t\t\t\t\t\t\t\t\t\tname = \"rates-addons\"\n" +
    "\t\t\t\t\t\t\t\t\t\t\tng-click = \"switchActivation()\">\n" +
    "\t\t\t\t\t\t\t\t\t<span class=\"switch-icon\"></span>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\n" +
    "\t\t\t\t\t\t<td header-class=\"width-10\" class=\"delete\" ng-hide=\"currentClickedAddon === $index\">\n" +
    "\t\t\t\t\t\t\t<a class=\"icons icon-delete large-icon\" ng-click=\"deleteAddon()\">Delete this addon</a>\t\t\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\n" +
    "\t\t\t\t\t\t<td colspan=\"4\" ng-include=\"getTemplateUrl()\" ng-show=\"currentClickedAddon === $index\"></td>\n" +
    "\t\t\t\t\t</tr>\n" +
    "\t\t\t\t</tbody>\n" +
    "\t\t\t</table>\n" +
    "\t\t</section>\n" +
    "\n" +
    "\t\t<script id=\"custom/header\" type=\"text/ng-template\">\n" +
    "\t\t  <tr>\n" +
    "\t\t\t\t\t\t \n" +
    "\t           <th class=\"width-30\" ng-class=\"{\n" +
    "\t           \t\t\t'sortable': currentClickedAddon == -1,\n" +
    "\t                    'sort-asc': tableParams.isSortBy('name', 'asc'),\n" +
    "\t                    'sort-desc': tableParams.isSortBy('name', 'desc')\n" +
    "\t                  }\"\n" +
    "\t                  \n" +
    "\t                    ng-click=\"sortByName()\" rowspan=\"2\">\n" +
    "\t                    <div><i class=\"glyphicon glyphicon-user\" ></i> <span translate>NAME</span></div>\n" +
    "\t                </th>\n" +
    "\t                <th class=\"width-30\"  ng-class=\"{\n" +
    "\t                \t'sortable': currentClickedAddon == -1,\n" +
    "\t                    'sort-asc': tableParams.isSortBy('description', 'asc'),\n" +
    "\t                    'sort-desc': tableParams.isSortBy('description', 'desc')\n" +
    "\t                  }\"\n" +
    "\t                  \n" +
    "\t                    ng-click=\"sortByDescription()\" rowspan=\"2\">\n" +
    "\t                    <div><i class=\"glyphicon glyphicon-user\" ></i> <span translate>DESCRIPTION</span></div>\n" +
    "\t                </th>                \t\t\n" +
    "\t\t\t\t\t<th class=\"width-20\" ><span class=\"addon-header\" translate> ACTIVE </span></th>\n" +
    "\t\t\t\t\t<th  class=\"width-20\"><span class=\"addon-header\" translate> DELETE </span> </th>\t\t\t\t\t\t\t\t\n" +
    "\t\t\t\t\t</tr>\n" +
    "\t\t</script>\n" +
    "\n" +
    "\t\t<!--Custom pagination footer goes here-->\n" +
    "\t\t<script type=\"text/ng-template\" id=\"custom/pager\">\n" +
    "\t\t\t<div class=\"pager\" ng-show=\"totalCount > 0\">\n" +
    "\t\t\t\t<span ng-show=\"totalCount > 0\">Showing {{ startCount }} to {{ endCount }} of {{ totalCount }} items</span>\n" +
    "\t\t\t\t<span ng-show=\"totalCount == 0\">Showing 0 items</span>\n" +
    "\t\t\t\t<ul class=\"ng-cloak\">\n" +
    "\t              \t<li ng-repeat=\"page in pages\"\n" +
    "\t\t                ng-class=\"{'previous': page.type == 'prev', 'next': page.type == 'next'}\"\n" +
    "\t\t                ng-show=\"page.type == 'prev' || page.type == 'next'\" ng-switch=\"page.type\">\n" +
    "\t\n" +
    "\t\t                <a ng-switch-when=\"prev\" ng-click=\"params.page(1)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">First</a>\n" +
    "\t\t                <a ng-switch-when=\"prev\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">Previous</a>\n" +
    "\t\t                <a ng-switch-when=\"prev\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">{{page.number}}</a>\n" +
    "\t\t                \n" +
    "\t\t                <a ng-switch-when=\"next\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">{{page.number}}</a>\n" +
    "\t\t                <a ng-switch-when=\"next\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">Next</a>\n" +
    "\t\t                <a ng-switch-when=\"next\" ng-click=\"params.page(totalPage)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">Last</a>\n" +
    "\t\t          \t</li>\n" +
    "\t            </ul>\n" +
    "\t        </div>\n" +
    "\t\t</script>\n" +
    "\t\t<!--end-->\n" +
    "\n" +
    "\t</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/rates/adRatesEndDateValidationPopup.html',
    "<form ng-cloak class=\"grey-texture-bg-color rate_end_date_form\">\n" +
    "\t<fieldset class=\"holder grey-texture-bg-color\">\n" +
    "\t\t<div class=\"center_align rate_end_date_validation_message\">\n" +
    "\t\t\tActive contracts exist for this rate. Please review contract end dates.\n" +
    "\t\t</div>\n" +
    "\t\t<div class=\"actions float\">\n" +
    "\t\t\t<button ng-click=\"cancelClicked()\" type=\"button\" class=\"button blank add-data-inline\">Cancel</button>\n" +
    "\t\t\t<button type=\"button\" ng-click=\"proceedSave()\" class=\"button green\">Proceed</button>\n" +
    "\t\t</div>\n" +
    "\t</fieldset>\n" +
    "</form>\n"
  );


  $templateCache.put('/assets/partials/rates/adRatesList.html',
    "<section class=\"content current\" ng-click='clearErrorMessage()'>\n" +
    "\t<div>\n" +
    "\t\t<header class=\"content-title float\">\n" +
    "\t\t\t<h2> Rates </h2>\n" +
    "\t\t\t<span class=\"count\"> ({{totalCount}}) </span>\n" +
    "\t\t\t<a class=\"action add\" ui-sref=\"admin.addRate\" ng-click=\"showLoader()\" ng-hide=\"isConnectedToPMS\">Add new</a>\n" +
    "\n" +
    "\t\t\t<a class=\"action import\" ng-click=\"importFromPms($event)\" ng-show=\"isConnectedToPMS\">IMPORT FROM PMS</a>\n" +
    "\n" +
    "\t\t\t<div class=\"filters\">\n" +
    "\t\t\t\t<div class=\"filter select\">\n" +
    "\t\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t\t<div class=\"select\">\n" +
    "\t\t\t\t\t\t\t<select class=\"placeholder\" ng-model=\"filterType\" ng-options=\"opt.name for opt in filterList\">\n" +
    "\t\t\t\t\t\t\t\t<option value=\"\">Filter by Rate Type</option>\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</div>\n" +
    "\t\t</header>\n" +
    "\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_success_message.html'\"></div>\n" +
    "\t\t\t\n" +
    "\t\t\t\n" +
    "\t\t\t<span class=\"count-show\">Show</span>\n" +
    "\t\t\t<div class=\"select table-count rates-table-count\">\n" +
    "\t\t\t\t<select ng-model=\"displyCount\"\tng-options=\"opt for opt in displayCountList\"></select>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<span class=\"count-entries\">entries</span>\n" +
    "\t\t\t\t\n" +
    "\t\t\t<div class=\"entry table-search\">\n" +
    "\t\t\t\t<span class=\"search-text\">Search</span>\n" +
    "\t\t\t\t<span class=\"icons icon-search\" name=\"submit\" type=\"submit\"></span>\n" +
    "\t\t\t\t<input placeholder=\"\" autocomplete=\"off\" type=\"text\" ad-delay-textbox ng-model=\"searchTerm\" delay=\"1000\" function-to-fire=\"searchEntered\" />\n" +
    "\t\t    </div>\n" +
    "\t\t\t\n" +
    "\n" +
    "\t\t\t<div id=\"new-form-holder\"></div>\n" +
    "\t\t\t<!--ng-table component -->\n" +
    "\t\t\t<table class=\"grid\" ng-table=\"tableParams\" template-pagination=\"custom/pager\" ng-class=\"{'edit-data': currentClickedElement == $index}\">\n" +
    "\t\t\t\t<tbody>\n" +
    "\t\t\t\t\t<tr ng-repeat=\"rate in $data\" ng-class = \"{'inactive': !rate.status}\"> \n" +
    "\t\t\t\t\t\t<td data-title=\"'Name'\" sortable=\"'rate'\" header-class=\"width-25\" ng-hide=\"currentClickedElement == $index\">\n" +
    "\t\t\t\t\t\t\t<a class=\"edit-data\" ng-click=\"editRatesClicked(rate.id, $index)\" >\n" +
    "\t\t\t\t\t\t\t\t<strong> {{rate.name}}</strong>\n" +
    "\t\t\t\t\t\t\t</a>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\n" +
    "\t\t\t\t\t\t<td data-title=\"'Based on'\"  sortable=\"'based_on'\" header-class=\"width-20\" ng-hide=\"currentClickedElement == $index\">\n" +
    "\t\t\t\t\t\t\t<span qtip category='rateType' url='/api/rates.json?based_on_rate_id={{rate.based_on.id}}' title=\"Rate based on {{rate.based_on.name}}\">\n" +
    "\t\t\t\t\t\t\t\t{{rate.based_on.name}}\n" +
    "\t\t\t\t\t\t\t</span>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td data-title=\"'Type'\" sortable=\"'rate_type'\" header-class=\"width-15\" ng-hide=\"currentClickedElement == $index\">\n" +
    "\t\t\t\t\t\t\t<span qtip category='rateType' url='/api/rates.json?rate_type_id={{rate.rate_type.id}}' title=\"{{rate.rate_type.name}}\">\n" +
    "\t\t\t\t\t\t\t\t<strong>{{rate.rate_type.name}}</strong>\n" +
    "\t\t\t\t\t\t\t</span>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td data-title=\"'Date Ranges'\" header-class=\"width-15\" class = \"center_align\" ng-hide=\"currentClickedElement == $index\">\n" +
    "\t\t\t\t\t\t\t<span ng-show=\"rate.date_range_count > 0\" qtip title=\"{{rate.name}} - RATE DATE RANGES\" category='dateRange' url='/api/rates/{{rate.id}}/rate_date_ranges'>\n" +
    "\t\t\t\t\t\t\t\t{{rate.date_range_count}}\n" +
    "\t\t\t\t\t\t\t</span>\n" +
    "\t\t\t\t\t\t\t<span ng-show=\"rate.date_range_count == 0\">\n" +
    "\t\t\t\t\t\t\t\t{{rate.date_range_count}}\n" +
    "\t\t\t\t\t\t\t</span>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td data-title=\"'Status'\" sortable=\"'status'\" ng-class = \"{'green': rate.status}\" header-class=\"width-15\" ng-hide=\"currentClickedElement == $index\">\n" +
    "\t\t\t\t\t\t\t<div class=\"entry\" ng-click=\"toggleActive(rate.id,rate.status,rate.is_activation_allowed)\">\n" +
    "\t\t\t\t\t\t\t\t<div class=\"switch-button single\" ng-class=\"{'on': rate.status}\">\n" +
    "\t\t\t\t\t\t\t\t\t<input type=\"checkbox\"  ng-checked=\"rate.status\">\n" +
    "\t\t\t\t\t\t\t\t\t<span class=\"switch-icon\"></span>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t<!-- {{rate.status ? 'ACTIVE' : 'INACTIVE'}} -->\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td header-class=\"width-10\" ng-hide=\"currentClickedElement == $index\">\n" +
    "\t\t\t\t\t\t\t <span class=\"icons delete_small cursor_pointer\" ng-click=\"deleteRate(rate.id)\" ng-hide=\"false\">&nbsp;</span>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td colspan=\"6\" header-class=\"width-0\" ng-include=\"getTemplateUrl($index, rate.id)\"></td> \n" +
    "\t\t\t\t\t</tr>\n" +
    "\t\t\t\t</tbody>\n" +
    "\t\t\t</table>\n" +
    "\t\t</section>\n" +
    "\t\t<!--end -->\n" +
    "\n" +
    "\t\t<!--Custom pagination footer goes here-->\n" +
    "\t\t<script type=\"text/ng-template\" id=\"custom/pager\">\n" +
    "\t\t\t<div class = \"pager\">\n" +
    "\t\t\t\t<span ng-show=\"totalCount>0\">Showing {{startCount}} to {{endCount}} of {{totalCount}} items</span>\n" +
    "\t\t\t\t<span ng-show=\"totalCount==0\">Showing 0 items</span>\n" +
    "\t\t\t\t<ul class=\"ng-cloak\">\n" +
    "\t              \t<li ng-repeat=\"page in pages\"\n" +
    "\t\t                ng-class=\"{'previous': page.type == 'prev', 'next': page.type == 'next'}\"\n" +
    "\t\t                ng-show=\"page.type == 'prev' || page.type == 'next'\" ng-switch=\"page.type\">\n" +
    "\t\n" +
    "\t\t                <a ng-switch-when=\"prev\" ng-click=\"params.page(1)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">First</a>\n" +
    "\t\t                <a ng-switch-when=\"prev\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">Previous</a>\n" +
    "\t\t                <a ng-switch-when=\"prev\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">{{page.number}}</a>\n" +
    "\t\t                \n" +
    "\t\t                <a ng-switch-when=\"next\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">{{page.number}}</a>\n" +
    "\t\t                <a ng-switch-when=\"next\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">Next</a>\n" +
    "\t\t                <a ng-switch-when=\"next\" ng-click=\"params.page(totalPage)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">Last</a>\n" +
    "\t\t          \t</li>\n" +
    "\t            </ul>\n" +
    "\t        </div>\n" +
    "\t\t</script>\n" +
    "\t\t<!--end-->\n" +
    "\t</div>\n" +
    "</section>\n" +
    "\n" +
    "<div id=\"new-form-holder\" ng-show=\"isAddmode\" ng-include=\"getAddRateTemplateUrl()\">\n"
  );


  $templateCache.put('/assets/partials/rates/addonsDateRangeCalenderPopup.html',
    "<div ui-date=\"dateOptions\" ng-model=\"datePickerDate\" ui-date-format=\"yy-mm-dd\"></div>\n"
  );


  $templateCache.put('/assets/partials/rates/confirmDeleteSetDialog.html',
    "<div class=\"confirm-delete\">\n" +
    "    <header class=\"\">\n" +
    "        Rate set {{ deleteSetName }} will be deleted. Confirm?\n" +
    "    </header>\n" +
    "    <div class=\"confirm-button\">\n" +
    "\t    <button type=\"button\" id=\"cancel\" class=\"button blank edit-data-inline float_left\" ng-click=\"closeDialog()\">\n" +
    "\t        No\n" +
    "\t    </button>\n" +
    "\t    <button type=\"button\" id=\"update\" class=\"button green edit-data-inline float_left\" ng-click=\"deleteSet()\">\n" +
    "\t        Yes\n" +
    "\t    </button>\n" +
    "\t\t<br clear='all'/>    \n" +
    "\t</div>\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/rates/confirmRateSaveDialog.html',
    "<div ng-cloak class=\"confirm-save grey-texture-bg-color \">\n" +
    "    <fieldset class=\"holder grey-texture-bg-color\">\n" +
    "      <div class=\"form_title\">\n" +
    "          Save change to Rate set for date range {{otherData.activeDateRange.begin_date | date:'MMMM dd, y'}} to {{otherData.activeDateRange.end_date | date:'MMMM dd, y'}}\n" +
    "      </div>\n" +
    "      <div class=\"actions float\">\n" +
    "        <button type=\"button\" id=\"cancel\" class=\"button blank\" ng-click=\"closeDialog()\">\n" +
    "            Cancel\n" +
    "        </button>\n" +
    "        <button type=\"button\" id=\"cancel\" class=\"button blank\" ng-click=\"discardRateSetChange()\">\n" +
    "            Discard\n" +
    "        </button>\n" +
    "        <button type=\"button\" id=\"update\" class=\"button green\" ng-click=\"saveSet(otherData.activeDateRange.id, otherData.activeDateRangeIndex)\">\n" +
    "            Save\n" +
    "        </button> \n" +
    "      </div>\n" +
    "    </fieldset>\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/reservationTypes/adReservationTypeList.html',
    "<section id=\"replacing-div-first\" class=\"content current\" ng-click='clearErrorMessage()'>\n" +
    "\t<div data-view=\"ReservationTypeListView\">\n" +
    "\t\t<header class=\"content-title float\">\n" +
    "\t\t\t<h2 translate> RESERVATION_TYPE_LABEL </h2>\n" +
    "\t\t\t<span class=\"count\"> ({{data.length}})</span>\n" +
    "\t\t</header>\n" +
    "\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\n" +
    "\n" +
    "\t\t\t<table id=\"reservation-types\" class=\"grid\">\n" +
    "\n" +
    "\t\t\t\t<tbody>\n" +
    "\n" +
    "\t\t\t\t\t<tr ng-repeat = \"resevationtype in data\" >\n" +
    "\n" +
    "\t\t\t\t\t\t<td width = \"50%\" ><strong>{{resevationtype.name}}</strong><em translate> SYSTEM_DEFINED_LABEL</em></td>\n" +
    "\n" +
    "\n" +
    "\t\t\t\t\t\t<td class=\"activate\" >\n" +
    "\t\t\t\t\t\t\t<div class=\"entry\" >\n" +
    "\t\t\t\t\t\t\t<label ></label>\n" +
    "\t\t\t\t\t\t\t<div class=\"switch-button single\" ng-click=\"saveReservationType($index)\" ng-class=\"{ on : resevationtype.is_active}\" >\n" +
    "\t\t\t\t\t\t\t\t<input type=\"checkbox\" ng-model=\"resevationtype.is_active\"  value=\"\" name=\"\"  id=\"\">\n" +
    "\t\t\t\t\t\t\t\t<span class=\"switch-icon\"></span>\n" +
    "\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t</div></td>\n" +
    "\n" +
    "\t\t\t\t\t</tr>\n" +
    "\n" +
    "\t\t\t\t</tbody>\n" +
    "\t\t\t</table>\n" +
    "\t\t</section>\n" +
    "\t</div>\n" +
    "</section>\n"
  );


  $templateCache.put('/assets/partials/reservations/adReservationSettings.html',
    "<section id=\"replacing-div-second\" class=\"content current\" ng-hide=\"isLoading\" ng-click=\"clearErrorMessage()\"><div data-view=\"ZestCheckinConfiguration\" >\n" +
    "\t\n" +
    "\t<header class=\"content-title float\">\n" +
    "\t\t<h2 translate>RESERVATION_SETTINGS</h2>\n" +
    "\t\t<a ng-click=\"goBackToPreviousState()\" data-type=\"load-details\" class=\"action back\" translate>BACK</a>\n" +
    "\t</header>\n" +
    "\t<section class=\"content-scroll\">\n" +
    "\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"  ></div>\n" +
    "\n" +
    "\t\t<form style=\"overflow-y:auto;\" class=\"form float\" >\n" +
    "\t\t\t<fieldset class=\"holder full-width\">\n" +
    "\n" +
    "\t\t\t\t<fieldset class=\"holder left\">\n" +
    "\t\t\t\t\t<div style=\"height:20px;\"></div>\n" +
    "\t\t\t\t\t<!-- <ad-checkbox is-checked=\"reservationSettingsData.recommended_rate_display\" label=\"{{'USE_RECOMMENDED_RATE_DISPLAY' | translate}}\" div-class=\"full-width\"></ad-checkbox> -->\n" +
    "\t\t\t\t\t<ad-toggle-button label=\"{{'USE_RECOMMENDED_RATE_DISPLAY' | translate}}\" is-checked=\"reservationSettingsData.recommended_rate_display\" ></ad-toggle-button>\n" +
    "\n" +
    "\n" +
    "\n" +
    "\t\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t\t<label translate>DEFAULT_RATE_DISPLAY</label>\n" +
    "\t\t\t\t\t\t<div class=\"select\">\n" +
    "\t\t\t\t\t\t\t<select class=\"placeholder\" ng-model=\"reservationSettingsData.default_rate_display_name\" ng-options=\"rate_type.name as rate_type.name for rate_type in defaultRateDisplays\">\n" +
    "\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</fieldset>\n" +
    "\n" +
    "\t\t\t\t<!-- max guest counts starts here -->\n" +
    "\n" +
    "\t\t\t\t<fieldset class=\"holder right\">\n" +
    "\t\t\t\t\t<div class=\"entry full-width\"> \n" +
    "\t\t\t\t\t\t<div class=\" col1-3 actions_margin_top\">           \n" +
    "\t\t\t\t\t\t\t<ad-textbox inputtype=\"text\" value=\"reservationSettingsData.max_guests.max_adults\" styleclass = \"col1-3\"\n" +
    "\t\t\t\t\t\t\tlabel = \"{{'MAX_ADULTS' | translate}}\" placeholder = \"\" style=\" width: 100px;\"\n" +
    "\t\t\t\t\t\t\t></ad-textbox>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t<div class=\" actions_margin_top\" >\n" +
    "\t\t\t\t\t\t\t<ad-textbox inputtype=\"text\" value=\"reservationSettingsData.max_guests.max_children\" styleclass = \"col1-3\"\n" +
    "\t\t\t\t\t\t\tlabel = \"{{'MAX_CHILDREN' | translate}}\" placeholder = \"\" style=\" width: 100px;\"\n" +
    "\t\t\t\t\t\t\t></ad-textbox>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t<div class=\"col1-3\">\n" +
    "\t\t\t\t\t\t\t<ad-textbox inputtype=\"text\" value=\"reservationSettingsData.max_guests.max_infants\" styleclass = \"col1-3\"\n" +
    "\t\t\t\t\t\t\tlabel = \"{{'MAX_INFANTS' | translate}}\" placeholder = \"\" style=\" width: 100px;\"\n" +
    "\t\t\t\t\t\t\t></ad-textbox>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t</div>    \n" +
    "\t\t\t\t</fieldset>\n" +
    "\t\t\t\t<!-- max guest counts ends here -->\n" +
    "\n" +
    "\t\t\t\t<fieldset class=\"holder left\">\n" +
    "\t\t\t\t\t<div style=\"height:20px;\"></div>\n" +
    "\t\t\t\t\t<ad-toggle-button label=\"Hourly Rates\" is-checked=\"reservationSettingsData.is_hourly_rate_on\" ></ad-toggle-button>\n" +
    "\t\t\t\t\t<ad-toggle-button label=\"{{'ADDONS_FOR_RESERVATIONS' | translate}}\" is-checked=\"reservationSettingsData.is_addon_on\" ></ad-toggle-button>\n" +
    "\t\t\t\t</fieldset>\n" +
    "\t\t\t\t<fieldset class=\"holder left\">\n" +
    "\t\t\t\t\t<div style=\"height:20px;\"></div>\n" +
    "\t\t\t\t\t<ad-checkbox is-checked=\"reservationSettingsData.disable_cc_swipe\" label=\"{{ 'DISABLE_CC_SWIPE_AT_CHECK_IN' | translate}}\" div-class=\"full-width\" ></ad-checkbox>\n" +
    "\t\t\t\t\t<ad-checkbox is-checked=\"reservationSettingsData.disable_terms_conditions_checkin\" label=\"{{ 'DISABLE_TERMS_AND_CONDITIONS_AT_CHECK_IN' | translate}}\" div-class=\"full-width\"  ></ad-checkbox>\n" +
    "\t\t\t\t\t<ad-checkbox is-checked=\"reservationSettingsData.disable_email_phone_dialog\" label=\"{{ 'DISABLE_EMAIL_PHONE_DIALOGUE' | translate}}\" div-class=\"full-width\" ></ad-checkbox>\n" +
    "\t\t\t\t\t<ad-checkbox is-checked=\"reservationSettingsData.disable_early_departure_penalty\" label=\"{{ 'DISABLE_EARLY_DEPARTURE_PENALTY' | translate}}\" div-class=\"full-width\" ></ad-checkbox>\n" +
    "\t\t\t\t\t<ad-checkbox is-checked=\"reservationSettingsData.disable_reservation_posting_control\" label=\"{{ 'DISABLE_RESERVATION_POSTING_CONTROL' | translate}}\" div-class=\"full-width\" ></ad-checkbox>\n" +
    "\t\t\t\t</fieldset>\n" +
    "\n" +
    "\t\t\t</fieldset>\n" +
    "\t\t\t<div class=\"actions float\">\n" +
    "\t\t\t\t<button type=\"button\" ng-click=\"goBackToPreviousState()\" class=\"button blank add-data-inline\" translate>CANCEL</button>\n" +
    "\t\t\t\t<button type=\"button\" ng-click=\"saveChanges()\" class=\"button green\" translate>SAVE_CHANGES</button>\n" +
    "\t\t\t</div>\n" +
    "\t\t</form>\n" +
    "\t</section>\n" +
    "</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/reviews_setups/adGuestReviewSetup.html',
    "<section class=\"content current\" ng-click=\"clearErrorMessage()\">\n" +
    "\t<div>\n" +
    "\t\t<header class=\"content-title float\">\n" +
    "\t\t\t<h2 translate>GUEST_REVIEW_SETUP</h2>\n" +
    "\t\t\t<a id=\"go_back\" data-type=\"load-details\" class=\"action back\" ng-click=\"goBackToPreviousState()\" translate>BACK</a>\n" +
    "\t\t</header>\n" +
    "\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t<form style=\"overflow-y:auto;\" name=\"edit-guest-review\" method=\"post\" class=\"form float\">\n" +
    "\t\t\t\t<fieldset class=\"holder column\">\n" +
    "\t\t\t\t\t<ad-toggle-button label=\"{{'GUEST_REVIEWS' | translate}}\" div-class=\"full-width\" is-checked=\"data.is_guest_reviews_on\" ></ad-toggle-button>\n" +
    "\n" +
    "\t\t\t\t\t<ad-textbox value=\"data.number_of_reviews\"   label = \"{{'NUMBER_OF_REVIEWS' | translate}}\" placeholder = \"{{'NUMBER_OF_REVIEWS_PLACEHOLDER' | translate}}\" name=\"number-of-reviews\" id=\"number-of-reviews\"></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t\t<ad-dropdown label=\"{{'RATING_LIMIT' | translate}}\" list=\"rating_list\" selected-Id='data.rating_limit'  id=\"rating-limit\"></ad-dropdown>\n" +
    "\n" +
    "\t\t\t\t</fieldset>\n" +
    "\t\t\t\t<div class=\"actions float\">\n" +
    "\t\t\t\t\t<button type=\"button\" id=\"cancel\" class=\"button blank add-data-inline\" ng-click=\"goBackToPreviousState()\" translate>CANCEL</button>\n" +
    "\t\t\t\t\t<button type=\"button\" id=\"save_guest_review\" class=\"button green\" ng-click=\"save()\" translate>SAVE_CHANGES</button>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</form>\n" +
    "\t\t</section>\n" +
    "\t</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/roomKeyDelivery/roomKeyDelivery.html',
    "<section id=\"replacing-div-first\" class=\"content current\" ng-click=\"clearErrorMessage()\" >\n" +
    "\t<div data-view=\"RoomKeyDeliveryView\">\n" +
    "\t\t<header class=\"content-title float\">\n" +
    "\t\t\t<h2 translate>ROOM_KEY_DELIVERY_SETUP</h2>\n" +
    "\t\t\t<a ng-click=\"goBackToPreviousState()\" data-type=\"load-details\" class=\"action back\" translate>BACK</a>\n" +
    "\t\t</header>\n" +
    "\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t\n" +
    "\t\t\t<form style=\"overflow-y:auto;\" name=\"room-delivery-view\" method=\"post\" class=\"form float\">\n" +
    "\t\t\t\t\n" +
    "\t\t\t\t<fieldset class=\"holder left\">\n" +
    "\t\t\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t\t\t<h3><span translate>ZEST</span> {{'CHECKINS' | translate}} </h3>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t\t\t<div class=\"boxes\">\n" +
    "\t\t\t\t\t\t\t<label class=\"radio\" ng-class=\"{checked: data.room_key_delivery_for_guestzest_check_in == 'email'}\">\n" +
    "\t\t\t\t\t\t\t\t<span class=\"icon-form icon-radio\" ng-class=\"{checked: data.room_key_delivery_for_guestzest_check_in == 'email'}\"></span>\n" +
    "\t\t\t\t\t\t\t\t<input ng-model=\"data.room_key_delivery_for_guestzest_check_in\" type=\"radio\" value=\"email\" name=\"guest-zest\" id=\"type1\" class=\"change-data\">\n" +
    "\t\t\t\t\t\t\t\t{{'DELIVER_QR_CODE_FOR_ROOM_KEY' | translate }}\n" +
    "\t\t\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t\t\t<label class=\"radio\" ng-class=\"{checked: data.room_key_delivery_for_guestzest_check_in == 'smartphone'}\">\n" +
    "\t\t\t\t\t\t\t\t<span class=\"icon-form icon-radio\" ng-class=\"{checked: data.room_key_delivery_for_guestzest_check_in == 'smartphone'}\"></span>\n" +
    "\t\t\t\t\t\t\t\t<input ng-model=\"data.room_key_delivery_for_guestzest_check_in\" type=\"radio\" value=\"smartphone\" name=\"guest-zest\" id=\"type2\" class=\"change-data\">\n" +
    "\t\t\t\t\t\t\t\t{{'DELIVER_QR_CODE_TO_GUESTZEST_APP' | translate }}\t\n" +
    "\t\t\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t\t\t<label class=\"radio\" ng-class=\"{checked: data.room_key_delivery_for_guestzest_check_in == 'front_desk'}\">\n" +
    "\t\t\t\t\t\t\t\t<span class=\"icon-form icon-radio\" ng-class=\"{checked: data.room_key_delivery_for_guestzest_check_in == 'front_desk'}\"></span>\n" +
    "\t\t\t\t\t\t\t\t<input ng-model=\"data.room_key_delivery_for_guestzest_check_in\" type=\"radio\" value=\"front_desk\" name=\"guest-zest\" id=\"type3\" class=\"change-data\">\n" +
    "\t\t\t\t\t\t\t\t{{'DELIVER_MSG_TO_GUEST' | translate }}\n" +
    "\t\t\t\t\t\t\t</label>\n" +
    "\n" +
    "\t\t\t\t\t\t\t<ad-textarea rows=\"2\" ng-if=\"data.room_key_delivery_for_guestzest_check_in == 'front_desk'\" div-class=\"full-width\" text-area-class=\"full-width\" value=\"data.key_delivery_message\" label = \"{{ 'ROOM_KEY_DELIVERY_MESSAGE_TITLE' | translate}}\" placeholder = \"\"></ad-textarea>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t</fieldset>\n" +
    "\t\t\t\t\n" +
    "\t\t\t\t<fieldset class=\"holder right\">\n" +
    "\t\t\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t\t\t<h3><span>ROVER</span> {{'CHECKINS' | translate}} </h3>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t\t\t<div class=\"boxes\">\n" +
    "\t\t\t\t\t\t\t<label class=\"radio\" ng-class=\"{checked: data.room_key_delivery_for_rover_check_in == 'email'}\">\n" +
    "\t\t\t\t\t\t\t\t<span class=\"icon-form icon-radio\" ng-class=\"{checked: data.room_key_delivery_for_rover_check_in == 'email'}\"></span>\n" +
    "\t\t\t\t\t\t\t\t<input ng-model=\"data.room_key_delivery_for_rover_check_in\" type=\"radio\" value=\"email\" name=\"guest-zest\" id=\"type1\" class=\"change-data\">\n" +
    "\t\t\t\t\t\t\t\t{{'DELIVER_QR_CODE_FOR_ROOM_KEY' | translate }}\n" +
    "\t\t\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t\t\t<label class=\"radio\" ng-class=\"{checked: data.room_key_delivery_for_rover_check_in == 'encode'}\">\n" +
    "\t\t\t\t\t\t\t\t<span class=\"icon-form icon-radio\" ng-class=\"{checked: data.room_key_delivery_for_rover_check_in == 'encode'}\"></span>\n" +
    "\t\t\t\t\t\t\t\t<input ng-model=\"data.room_key_delivery_for_rover_check_in\" type=\"radio\" value=\"encode\" name=\"guest-zest\" id=\"type2\" class=\"change-data\">\n" +
    "\t\t\t\t\t\t\t\t{{'MAKE_KEY_FOR_RFID_READER' | translate }}\n" +
    "\t\t\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t\t\t<label class=\"radio\" ng-class=\"{checked: data.room_key_delivery_for_rover_check_in == 'qr_code_tablet'}\">\n" +
    "\t\t\t\t\t\t\t\t<span class=\"icon-form icon-radio\" ng-class=\"{checked: data.room_key_delivery_for_rover_check_in == 'qr_code_tablet'}\"></span>\n" +
    "\t\t\t\t\t\t\t\t<input ng-model=\"data.room_key_delivery_for_rover_check_in\" type=\"radio\" value=\"qr_code_tablet\" name=\"guest-zest\" id=\"type3\" class=\"change-data\">\n" +
    "\t\t\t\t\t\t\t\t{{'SHOW_QR_CODE_FOR_ROOM_KEY' | translate }}\n" +
    "\t\t\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t</fieldset>\n" +
    "\t\t\t\t\n" +
    "\t\t\t\t<div class=\"entry full-width\" ng-show=\"isRoverCheckinRFID\">\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t\t<ad-dropdown label=\"{{'ROOM_KEY_SYSTEM_VENDOR' | translate }}\" label-in-drop-down=\"{{'ROOM_KEY_SYSTEM_VENDOR' | translate }}\" list=\"data.key_systems\" selected-Id='data.selected_key_system' required = \"yes\"></ad-dropdown>\n" +
    "\n" +
    "\t\t    \t\t<ad-textbox value=\"data.key_access_url\" label = \"{{'KEY_SYSTEM_ACCESS_URL' | translate }}\" placeholder = \"{{'KEY_SYSTEM_ACCESS_URL_PLACEHOLDER' | translate }}\" required = \"yes\" ></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t\t<ad-textbox value=\"data.key_access_port\" label = \"{{'KEY_SYSTEM_ACCESS_PORT' | translate }}\" placeholder = \"{{'KEY_SYSTEM_ACCESS_PORT_PLACEHOLDER' | translate }}\" required = \"\" ></ad-textbox>\n" +
    "\t\t    \t\t\n" +
    "\t\t    \t\t<ad-textbox value=\"data.key_username\" label = \"{{'KEY_SYSTEM_USENAME' | translate }}\" placeholder = \"{{'KEY_SYSTEM_USENAME_PLACEHOLDER' | translate }}\" required = \"\" ></ad-textbox>\n" +
    "\n" +
    "\t\t    \t\t<ad-textbox value=\"data.key_password\" inputtype=\"password\" label = \"{{'KEY_SYSTEM_PASSWORD' | translate }}\" placeholder = \"{{'KEY_SYSTEM_PASSWORD_PLACEHOLDER' | translate }}\" required = \"\" ></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t\t\n" +
    "\t\t\t\t<div class=\"actions float\">\n" +
    "\t\t\t\t\t<button type=\"button\" ng-click=\"goBackToPreviousState()\" class=\"button blank add-data-inline\" translate>\n" +
    "\t\t\t\t\t\tCANCEL\n" +
    "\t\t\t\t\t</button>\n" +
    "\t\t\t\t\t<button type=\"button\" ng-click=\"save()\" class=\"button green\" translate>\n" +
    "\t\t\t\t\t\tSAVE_CHANGES\n" +
    "\t\t\t\t\t</button>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</form>\n" +
    "\t\t</section>\n" +
    "\t</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/roomTypes/adRoomTypesDetails.html',
    "<div class=\"data-holder\">\n" +
    "\t<form room_type_id=\"1\" id=\"edit-room-type\" class=\"form inline-form float\">\n" +
    "\t\t<div class=\"form-title\">\n" +
    "\t\t\t<h3>\n" +
    "\t\t\t\t<span ng-hide=\"isAddMode\">{{ 'EDIT' | translate }}</span>\n" +
    "\t\t\t\t<span ng-show=\"isAddMode\">{{ 'ADD' | translate }}</span>\n" +
    "\t\t\t\t {{roomTypeData.room_type_name}} </h3>\n" +
    "\t\t\t<em class=\"status\"> {{ 'MANDATORY_FIELDS_MESSAGE1' | translate }} <strong>*</strong> {{ 'MANDATORY_FIELDS_MESSAGE2' | translate }}</em>\n" +
    "\t\t</div>\n" +
    "\t\t\n" +
    "\t\t<fieldset class=\"holder left float\">\n" +
    "\t\t\t\n" +
    "\t\t\t<ad-textbox styleclass=\"full-width\" value=\"roomTypeData.room_type_name\" name = \"room-type-name\" id = \"room-type-name\" label = \"{{ 'ROOM_TYPE_NAME' | translate }}\" placeholder = \"{{ 'ROOM_TYPE_PLACE_HOLDER' | translate }}\" required = \"yes\" ></ad-textbox>\n" +
    "\t\t\t\n" +
    "\t\t\t<ad-textarea rows=\"4\" div-class=\"full-width\" text-area-class=\"full-width\" value=\"roomTypeData.snt_description\" name = \"snt-desc\" id = \"snt-desc\" label = \"{{ 'SNT_DESCRIPTION' | translate }}\" placeholder = \"{{ 'SNT_DESCRIPTION_PLACE_HOLDER' | translate }}\"></ad-textarea>\n" +
    "\n" +
    "\t\t</fieldset>\n" +
    "\t\t<fieldset class=\"holder right float\">\n" +
    "\t\t\t<ad-textbox value=\"roomTypeData.room_type_code\" name = \"room-type-code\" id = \"room-type-code\" label = \"{{ 'CODE' | translate }}\" placeholder = \"{{ 'ROOM_TYPE__CODE_PLACE_HOLDER' | translate }}\" required = \"yes\" ></ad-textbox>\n" +
    "            <ad-textbox value=\"roomTypeData.max_occupancy\" name = \"max-occupancy\" id = \"max-occupancy\" label = \"{{ 'MAX_OCCUPANCY' | translate }} \" placeholder = \"{{ 'MAX_OCCUPANCY_PLACE_HOLDER' | translate }}\" required = \"\" ></ad-textbox>\n" +
    "\t\t\t \n" +
    "\t\t\t <div class=\"entry full-width\">\n" +
    "\t\t\t\t<label for=\"room-type-picture\"> {{ 'CHOOSE_FILE' | translate }} </label>\n" +
    "\t\t\t\t<div class=\"file-upload with-preview\">\n" +
    "\t\t\t\t\t<span class=\"input\">{{fileName}}</span>\n" +
    "\t\t\t\t\t<input type=\"file\" ng-model=\"roomTypeData.image_of_room_type\" accept=\"image/*\" app-filereader />\n" +
    "\t\t\t\t\t<button type=\"button\" class=\"button brand-colors\">\n" +
    "\t\t\t\t\t\t{{ 'PICTURE' | translate }}\n" +
    "\t\t\t\t\t</button> \n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t\t<span class=\"file-preview\"><img ng-src=\"{{roomTypeData.image_of_room_type}}\" id=\"file-preview\" alt=\"\"> </span>\n" +
    "\t\t\t</div> \n" +
    "\t\t\t<ad-checkbox div-class=\"full-width\" is-checked=\"roomTypeData.is_pseudo_room_type\" label=\"{{ 'PSEUDO_ROOM_TYPE' | translate }}\"></ad-checkbox>\n" +
    "\t\t\t<ad-checkbox div-class=\"full-width\" is-checked=\"roomTypeData.is_suite\" label=\"{{ 'SUITE_ROOM_TYPE' | translate }}\"></ad-checkbox>\n" +
    "\t\t</fieldset>\n" +
    "\t\t<div class=\"actions float\">\n" +
    "\t\t\t<button type=\"button\" id=\"cancel\" class=\"button blank add-data-inline\" ng-click=\"clickCancel()\">\n" +
    "\t\t\t\t{{ 'CANCEL' | translate }}\n" +
    "\t\t\t</button>\n" +
    "\t\t\t<button type=\"button\" like-type=\"common\" id=\"update\" class=\"button green add-data-inline\" ng-click=\"saveRoomTypes()\">\n" +
    "\t\t\t\t{{ 'SAVE_CHANGES' | translate }}\n" +
    "\t\t\t</button>\n" +
    "\t\t</div>\n" +
    "\t</form>\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/roomTypes/adRoomTypesList.html',
    "<section class=\"content current\" ng-click='clearErrorMessage()'>\n" +
    "\t\n" +
    "\t<div data-view=\"HotelRoomTypesView\">\n" +
    "\t\t<header class=\"content-title float\">\n" +
    "\t\t\t<h2> {{ 'ROOM_TYPES' | translate }} </h2>\n" +
    "\t\t\t<span class=\"count\"> ({{data.room_types.length}}) </span>\n" +
    "\t\t\t<a id=\"import-rooms\" class=\"action import\" ng-click=\"importFromPms($event)\" ng-show=\"data.is_import_available\">{{ 'IMPORT_FROM_PMS' | translate }}</a>\n" +
    "\t\t\t<a id=\"add-rooms\" class=\"action add\" ng-click=\"addNewRoomType()\" >{{ 'ADD_NEW' | translate }}</a>\n" +
    "\t\t</header>\n" +
    "\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_success_message.html'\"></div>\n" +
    "\t\t\t<div id=\"new-form-holder\"></div>\n" +
    "\t\t\t<span id=\"new-form-holder\" class=\"grid\" ng-if=\"isAddMode\" ng-include=\"'/assets/partials/roomTypes/adRoomTypesDetails.html'\"></span>\t\n" +
    "\t\t\t<table id=\"brands\" class=\"grid \" ng-table=\"tableParams\" template-pagination=\"nil\">\n" +
    "\t\t\t\t<thead>\n" +
    "\t\t\t\t\t<tr>\n" +
    "\t\t\t\t\t\t \n" +
    "\t           \t\t<th width=\"45%\" ng-class=\"{\n" +
    "\t           \t\t\t'sortable': currentClickedElement == -1,\n" +
    "\t                    'sort-asc': tableParams.isSortBy('name', 'asc'),\n" +
    "\t                    'sort-desc': tableParams.isSortBy('name', 'desc')\n" +
    "\t                  }\"\n" +
    "\t                  \n" +
    "\t                    ng-click=\"sortByName()\" rowspan=\"2\">\n" +
    "\t                    <div><i class=\"glyphicon glyphicon-user\" ></i> <span >Room Type</span></div>\n" +
    "\t                </th>\n" +
    "\t                <th width=\"40%\" ng-class=\"{\n" +
    "\t                \t'sortable': currentClickedElement == -1,\n" +
    "\t                    'sort-asc': tableParams.isSortBy('code', 'asc'),\n" +
    "\t                    'sort-desc': tableParams.isSortBy('code', 'desc')\n" +
    "\t                  }\"\n" +
    "\t                  \n" +
    "\t                    ng-click=\"sortByCode()\" rowspan=\"2\">\n" +
    "\t                    <div><i class=\"glyphicon glyphicon-user\" ></i> <span >Room Code</span></div>\n" +
    "\t                </th>\n" +
    "\t                <th width=\"15%\" class=\"text-center-important\" ng-show=\"isStandAlone\"><div><span>Delete</span></div>\n" +
    "\t                </th>\n" +
    "\t\t\t\t\t</tr>\n" +
    "\t\t\t\t</thead>\n" +
    "\t\t\t\t<tbody>\n" +
    "\t\t\t\t\t<tr ng-repeat=\"room_types in $data\" > \n" +
    "\t\t\t\t\t\t<td ng-click=\"editRoomTypes($index,room_types.id)\" ng-hide=\"currentClickedElement == $index\" >\n" +
    "\t\t\t\t\t\t\t<a data-item=\"3\" data-colspan=\"2\" class=\"edit-data-inline\">{{room_types.name}} </a>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td class=\"text-left\" ng-hide=\"currentClickedElement == $index\" >\n" +
    "\t\t\t\t\t\t\t{{room_types.code}}\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td ng-hide=\"currentClickedElement == $index|| !isStandAlone\">\n" +
    "\t\t\t\t\t\t\t<a class=\"icons icon-delete large-icon\" ng-click=\"deleteRoomTypes(room_types.id)\" ></a>\t\t\t\t\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t</td>\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t<td colspan=\"3\" ng-include=\"getTemplateUrl($index, room_types.id)\" ng-show=\"currentClickedElement == $index\">\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t</tr>\n" +
    "\t\t\t\t</tbody>\n" +
    "\t\t\t</table>\n" +
    "\t\t</section>\n" +
    "\t</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/roomUpsell/roomUpsell.html',
    "<section id=\"replacing-div-first\" class=\"content current\" ng-click=\"clearErrorMessage()\">\n" +
    "\t<div id=\"upsell_room_details\" data-view=\"UpsellRoomDetailsView\">\n" +
    "\t\t<section>\n" +
    "\t\t\t<header class=\"content-title float\">\n" +
    "\t\t\t\t<h2 translate>DAILY_UPSELL_SETUP</h2>\n" +
    "\t\t\t\t<a id=\"go_back\" data-type=\"load-details\" ng-click=\"goBackToPreviousState()\" class=\"action back\" translate>BACK</a>\n" +
    "\t\t\t</header>\n" +
    "\t\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t<form name=\"upsell_rooms\" method=\"post\" id=\"upsell_rooms\" class=\"form float\" action=\"\">\n" +
    "\t\t\t\t<fieldset class=\"holder column\">\n" +
    "\n" +
    "\t\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t\t<label for=\"upsell-rooms\" translate>UPSELL_ROOMS</label>\n" +
    "\t\t\t\t\t\t<div id=\"div-upsell-rooms\" class=\"switch-button single\" ng-class=\"{ on : upsellData.upsell_setup.is_upsell_on === 'true' }\">\n" +
    "\t\t\t\t\t\t\t<input type=\"checkbox\"  name=\"upsell-rooms\" id=\"upsell-rooms\" ng-click=\"switchClicked()\">\n" +
    "\t\t\t\t\t\t\t<span class=\"switch-icon\"></span>\n" +
    "\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t</fieldset>\n" +
    "\t\t\t\t<fieldset class=\"holder left\">\n" +
    "\t\t\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t\t\t<h3><span translate>DAILY_UPSELL</span> {{'TARGETS' | translate}} </h3>\n" +
    "\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t<ad-textbox value=\"upsellData.upsell_setup.total_upsell_target_amount\"   label = \"{{'TARGET' | translate}} [{{currencySymbol}}]\" ></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t\t<ad-textbox value=\"upsellData.upsell_setup.total_upsell_target_rooms\"   label = \"{{'ROOMS' | translate}}\" ></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t\t<!-- Checkbox -->\n" +
    "\t\t\t\t\t<div class=\"entry radio-check\" >\n" +
    "\t\t\t\t\t\t<label class=\"checkbox\"> <span class=\"icon-form icon-checkbox\" ng-class=\"{ checked : upsellData.upsell_setup.is_one_night_only === 'true' }\"></span> {{'UPSELL_ONE_NIGHT_STAYS' |translate}}\n" +
    "\t\t\t\t\t\t\t<input type=\"checkbox\" ng-click=\"oneNightcheckBoxClicked()\" />\n" +
    "\t\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t<!-- Checkbox -->\n" +
    "\t\t\t\t\t<div class=\"entry radio-check\" >\n" +
    "\t\t\t\t\t\t<label class=\"checkbox\"> <span class=\"icon-form icon-checkbox\" ng-class=\"{ checked : upsellData.upsell_setup.is_force_upsell === 'true' }\"></span> {{'FORCE_UPSELL'|translate}}\n" +
    "\t\t\t\t\t\t\t<input type=\"checkbox\"  ng-click=\"forceUpsellcheckBoxClicked()\"/>\n" +
    "\t\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t</fieldset>\n" +
    "\t\t\t\t<fieldset class=\"holder right\">\n" +
    "\t\t\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t\t\t<h3><span translate>DAILY_UPSELL</span> {{'ROOM_LEVEL_TARGETS'|translate}} </h3>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t<input type=\"hidden\" value=\"1\" name=\"level_from_0\" id=\"level_from_0\">\n" +
    "\t\t\t\t\t<input type=\"hidden\" value=\"2\" name=\"level_to_0\" id=\"level_to_0\">\n" +
    "\t\t\t\t\t\n" +
    "\n" +
    "\n" +
    "\t\t\t\t\t<ad-textbox value=\"upsellData.upsell_amounts[0].amount\"   label = \"Level 1 to 2  p/night [{{currencySymbol}}]\" ></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t\t<input type=\"hidden\" value=\"1\" name=\"level_from_1\" id=\"level_from_1\">\n" +
    "\t\t\t\t\t<input type=\"hidden\" value=\"3\" name=\"level_to_1\" id=\"level_to_1\">\n" +
    "\n" +
    "\t\t\t\t\t<ad-textbox value=\"upsellData.upsell_amounts[1].amount\"   label = \"Level 1 to 3  p/night [{{currencySymbol}}]\" ></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t\t<input type=\"hidden\" value=\"2\" name=\"level_from_2\" id=\"level_from_2\">\n" +
    "\t\t\t\t\t<input type=\"hidden\" value=\"3\" name=\"level_to_2\" id=\"level_to_2\">\n" +
    "\n" +
    "\t\t\t\t\t<ad-textbox value=\"upsellData.upsell_amounts[2].amount\"   label = \"Level 2 to 3  p/night [{{currencySymbol}}]\" ></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t\t<input type=\"hidden\" value=\"3\" name=\"upsell_amounts_count\" id=\"upsell_amounts_count\">\n" +
    "\t\t\t\t\t<input type=\"hidden\" value=\"3\" name=\"total_level_count\" id=\"total_level_count\">\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t\t<ad-dropdown label=\"Charge Code\" label-in-drop-down=\"Charge Code\" list=\"upsellData.charge_codes\" selected-Id='upsellData.selected_charge_code' required='yes'></ad-dropdown>\n" +
    "\n" +
    "\t\t\t\t</fieldset>\n" +
    "\t\t\t\t<div class=\"entry\"></div>\n" +
    "\t\t\t\t<fieldset class=\"holder full-width\">\n" +
    "\t\t\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t\t\t<h3><span translate>DAILY_UPSELL</span> {{'LEVELS'|translate}} </h3>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t<div id=\"upsell_level\" class=\"float\" >\n" +
    "\t\t\t\t\t\t<div class=\"entry has-sortable col3\">\n" +
    "\t\t\t\t\t\t\t<label translate> LEVEL_ONE </label>\n" +
    "\n" +
    "\t\t\t\t\t\t\t<ul id=\"level_1\" data-placeholder=\"{{'DROP_HERE_FOR_LEVEL_ONE'|translate}}\" class=\"boxes sortable empty short-list\" data-drop=\"true\" jqyoui-droppable=\"{multiple:true}\" ng-model=\"levelOne\" data-jqyoui-options=\"{accept: '.acceptable_room_upsell_level2,.acceptable_room_upsell_level3'}\" style=\"overflow: scroll !important;\">\n" +
    "\t\t\t\t\t\t\t\t<li ng-repeat=\"level1 in levelOne\"\n" +
    "\t\t\t\t\t\t\t\tng-model=\"levelOne\" data-drag=\"true\" data-jqyoui-options=\"{revert: 'invalid',helper:'clone',appendTo: 'body'}\" \n" +
    "\t\t\t\t\t\t\t\tjqyoui-draggable=\"{index: {{$index}}, placeholder:false, animate:false, onStart:'hideCurrentDragItem', onStop:'showCurrentDragItem'}\" \n" +
    "\t\t\t\t\t\t\t\tclass='acceptable_room_upsell_level1 li-draggable'\n" +
    "\t\t\t\t\t\t\t\tng-hide=\"!level1.room_type_name\">\n" +
    "\t\t\t\t\t\t\t\t<span class=\"icons icon-handle\"> </span>{{level1.room_type_name}}\n" +
    "\t\t\t\t\t\t\t</li>\n" +
    "\t\t\t\t\t\t</ul>\n" +
    "\n" +
    "\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t<div class=\"entry has-sortable col3\">\n" +
    "\t\t\t\t\t\t<label translate> LEVEL_TWO </label>\n" +
    "\t\t\t\t\t\t<ul id=\"level_2\" data-placeholder=\"{{'DROP_HERE_FOR_LEVEL_TWO'|translate}}\" class=\"boxes sortable empty short-list\" data-drop=\"true\" jqyoui-droppable=\"{multiple:true}\" ng-model=\"levelTwo\" style=\"overflow: scroll !important;\" data-jqyoui-options=\"{accept: '.acceptable_room_upsell_level1,.acceptable_room_upsell_level3'}\">\n" +
    "\t\t\t\t\t\t\t<li ng-repeat=\"level2 in levelTwo\"\n" +
    "\t\t\t\t\t\t\tng-model=\"levelTwo\" \n" +
    "\t\t\t\t\t\t\tdata-drag=\"true\"\n" +
    "\t\t\t\t\t\t\tdata-jqyoui-options=\"{revert: 'invalid',helper:'clone',appendTo: 'body'}\" \n" +
    "\t\t\t\t\t\t\tjqyoui-draggable=\"{index: {{$index}}, placeholder:false, animate:false, onStart:'hideCurrentDragItem', onStop:'showCurrentDragItem'}\" \n" +
    "\t\t\t\t\t\t\tclass='acceptable_room_upsell_level2 li-draggable'\n" +
    "\t\t\t\t\t\t\tng-hide=\"!level2.room_type_name\">\n" +
    "\t\t\t\t\t\t\t<span class=\"icons icon-handle\"> </span>{{level2.room_type_name}}\n" +
    "\t\t\t\t\t\t\t</li>\n" +
    "\t\t\t\t\t\t</ul>\n" +
    "\t\t\t\t\t</div>\n" +
    "\n" +
    "\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t<div class=\"entry has-sortable col3\">\n" +
    "\t\t\t\t\t<label translate> Level 3 </label>\n" +
    "\n" +
    "\n" +
    "\t\t\t\t\t<ul id=\"level_3\" data-placeholder=\"{{'DROP_HERE_FOR_LEVEL_THREE'|translate}}\" class=\"boxes sortable empty short-list\" data-drop=\"true\" jqyoui-droppable=\"{multiple:true}\" ng-model=\"levelThree\" style=\"overflow: scroll !important;\" data-jqyoui-options=\"{accept: '.acceptable_room_upsell_level2,.acceptable_room_upsell_level1'}\">\n" +
    "\t\t\t\t\t\t<li data-drag=\"true\" \n" +
    "\t\t\t\t\t\tng-repeat=\"level3 in levelThree\"\n" +
    "\t\t\t\t\t\tng-model=\"levelThree\" data-jqyoui-options=\"{revert: 'invalid',helper:'clone',appendTo: 'body'}\" jqyoui-draggable=\"{index: {{$index}}, placeholder:false, animate:false, onStart:'hideCurrentDragItem', onStop:'showCurrentDragItem'}\" \n" +
    "\t\t\t\t\t\tclass='acceptable_room_upsell_level3 li-draggable'\n" +
    "\t\t\t\t\t\tng-hide=\"!level3.room_type_name\">\n" +
    "\t\t\t\t\t\t<span class=\"icons icon-handle\"> </span>{{level3.room_type_name}}\n" +
    "\n" +
    "\t\t\t\t\t\t</li>\n" +
    "\t\t\t\t\t</ul>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t</div>\n" +
    "\t</fieldset>\n" +
    "\t<div class=\"actions\">\n" +
    "\t\t<button type=\"button\" ng-click=\"goBackToPreviousState()\" class=\"button blank\"translate>\n" +
    "\t\t\tCANCEL\n" +
    "\t\t</button>\n" +
    "\t\t<button type=\"button\" ng-click=\"saveClick()\" class=\"button green\" translate>\n" +
    "\t\t\tSAVE_CHANGES\n" +
    "\t\t</button>\n" +
    "\t</div>\n" +
    "</form>\n" +
    "</section>\n" +
    "</section>\n" +
    "</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/rooms/adRoomDetails.html',
    "<section class=\"content current\" ng-click=\"clearErrorMessage()\"><!-- Edit Room -->\n" +
    "\t<div >\n" +
    "\t\t<div class=\"data-holder\">\n" +
    "\t\t\t<header class=\"content-title float\">\n" +
    "\t\t\t\t<h2>\n" +
    "\t\t\t\t\t<span ng-show=\"editMode\">{{ 'EDIT_ROOM' | translate }}</span>\n" +
    "\t\t\t\t\t<span ng-hide=\"editMode\">{{ 'ADD_ROOM' | translate }}</span>\n" +
    "\t\t\t\t\t<span>\n" +
    "\t\t\t\t\t\t{{roomNumber}}\n" +
    "\t\t\t\t\t</span>\n" +
    "\t\t\t\t</h2>\n" +
    "\t\t\t\t<a ng-click=\"goBack()\" id=\"go_back\" data-type=\"load-details\" class=\"action back\">{{ 'BACK_TO_ROOMS' | translate }}</a>\n" +
    "\t\t\t</header>\n" +
    "\t\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t<form name=\"edit-room\" id=\"edit-room\" data-room-id=\"{{data.room_id}}\" class=\"form float\">\n" +
    "\t\t\t\t<fieldset class=\"holder left\">\n" +
    "\t\t\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t\t\t<h3>\n" +
    "\t\t\t\t\t\t\t<span>{{ 'ROOM' | translate }}</span>\n" +
    "\t\t\t\t\t\t\t{{ 'DETAILS' | translate }}\n" +
    "\t\t\t\t\t\t</h3>\n" +
    "\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t<ad-textbox value=\"data.room_number\" name=\"room-number\" id=\"room-number\" label=\"Number\" placeholder=\"{{ 'ENTER_ROOM_NUMBER' | translate }}\"required=\"\" maxlength=10>\n" +
    "\t\t\t\t</ad-textbox>\t\n" +
    "\n" +
    "\t\t\t\t<ad-textbox value=\"data.max_occupancy\" name=\"max-occupancy\" id=\"max-occupancy\" label=\"Max Occupancy \" placeholder=\"Enter Max Occupancy\" required=\"\"></ad-textbox>\t\n" +
    "\n" +
    "\t\t\t\t<ad-dropdown div-class='full-width' label-in-drop-down=\"{{ 'SELECT_FLOOR' | translate }}\"label=\"{{ 'SELECT_FLOOR' | translate }}\" sel-class='placeholder'  list='floors' required='yes' selected-Id='data.selected_floor'></ad-dropdown>\n" +
    "\n" +
    "\t\t\t\t<ad-dropdown div-class='full-width' label-in-drop-down=\"{{ 'SELECT_ROOM_TYPE' | translate }}\"label='Select room type' sel-class='placeholder' id='room-type' name='room-type' list='data.room_types' required='yes' selected-Id='data.room_type_id'></ad-dropdown>\n" +
    "\n" +
    "\t\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t\t<label for=\"room-picture\">\n" +
    "\t\t\t\t\t\t{{ 'IMAGE' | translate }}\n" +
    "\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t<div class=\"file-upload with-preview\">\n" +
    "\t\t\t\t\t\t<span class=\"input\">{{fileName}}</span>\n" +
    "\t\t\t\t\t\t<input ng-model=\"data.room_image\" type=\"file\" accept=\"image/*\" name=\"room-picture\" id=\"room-picture\" value=\"{{data.room_image}}\" app-filereader>\n" +
    "\t\t\t\t\t\t<button type=\"button\" class=\"button brand-colors\" >{{ 'REPLACE_IMAGE' | translate }}</button>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t<span class=\"file-preview\">\n" +
    "\t\t\t\t\t\t<img ng-src=\"{{data.room_image}}\" id=\"file-preview\" alt=\"\">\n" +
    "\t\t\t\t\t</span>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</fieldset>\n" +
    "\t\t\t<fieldset class=\"holder right\">\n" +
    "\t\t\t\t<!-- Room Features -->\n" +
    "\t\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t\t<h3>\n" +
    "\t\t\t\t\t\t<span>{{ 'ROOM' | translate }}</span>\n" +
    "\t\t\t\t\t\t{{ 'FEATURES' | translate }}\n" +
    "\t\t\t\t\t</h3>\n" +
    "\t\t\t\t\t<em class=\"status\">\n" +
    "\t\t\t\t\t\t<span>{{ 'ROOM_FEATURES_TEXT' | translate }}</span>\n" +
    "\t\t\t\t\t</em>\n" +
    "\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t\t<div id=\"room-features\" class=\"boxes col2\">\n" +
    "\t\t\t\t\t\t<ad-checkbox ng-repeat=\"room_feature in data.room_features\" is-checked=\"room_feature.selected\" label=\"{{room_feature.name}}\" parent-label-class=\"room-likes\" span-class=\"checkbox-background\"></ad-checkbox>\n" +
    "\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</fieldset>\n" +
    "\t\t\t<fieldset class=\"holder right\">\n" +
    "\t\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t\t<h3>\n" +
    "\t\t\t\t\t\t<span>{{ 'ROOM' | translate }}</span>\n" +
    "\t\t\t\t\t\t{{ 'LIKES' | translate }}\n" +
    "\t\t\t\t\t</h3>\n" +
    "\t\t\t\t\t<em class=\"status\">\n" +
    "\t\t\t\t\t\t<span>{{ 'ROOM_LIKE_TEXT' | translate }}</span>\n" +
    "\t\t\t\t\t</em>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t\t<div id=\"room-likes\" class=\"boxes col2\">\n" +
    "\t\t\t\t\t\t<div ng-repeat=\"room_likes in data.room_likes\">\n" +
    "\t\t\t\t\t\t\t<ad-checkbox ng-repeat=\"option in room_likes.options\" is-checked=\"option.selected\" label=\"{{option.name}}\" datagroup='{{room_likes.group_name}}' index=\"{{$index}}\" change='changed' parent-label-class='room-likes' span-class=\"checkbox-background\" ></ad-checkbox>\n" +
    "\t\t\t\t\t\t</div>\t\t\t\t\t\t\n" +
    "\t\t\t\t\t</div>\t\t\t\t\t\t\t\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</fieldset>\n" +
    "\t\t\t<div class=\"actions float\">\n" +
    "\t\t\t\t<button type=\"button\" id=\"cancel\" ng-click=\"goBack()\" class=\"button blank add-data-inline\">{{ 'CANCEL' | translate }}</button>\n" +
    "\t\t\t\t<button type=\"button\" id=\"update\" class=\"button green add-data-inline\" ng-click=\"updateRoomDetails()\">{{ 'SAVE_CHANGES' | translate }}</button>\n" +
    "\t\t\t</div>\n" +
    "\t\t</form>\n" +
    "\t\t</section>\n" +
    "\t</div>\n" +
    "\n" +
    "\n" +
    "</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/rooms/adRoomList.html',
    "<section class=\"content current\" ng-click=\"clearErrorMessage()\">\n" +
    "\t<div>\n" +
    "\t<section>\n" +
    "\t\t<header class=\"content-title float\">\n" +
    "\t\t\t<h2>\n" +
    "\t\t\t\t{{ 'ROOMS' | translate }}\n" +
    "\t\t\t</h2>\n" +
    "\t\t\t<span class=\"count\">\n" +
    "\t\t\t\t( {{totalCount}} )\n" +
    "\t\t\t\t<span class=\"status\">\n" +
    "\t\t\t\t\t{{totalCount}} {{ 'OF' | translate }} {{\t}} {{ 'LICENSED_ROOMS_CONFIGURED' | translate }}\n" +
    "\t\t\t\t</span>\n" +
    "\t\t    </span>\n" +
    "\t\t\t<a id=\"add-rooms\" class=\"action add\" ui-sref='admin.roomdetails({})' ng-show=\"is_add_available === 'yes'\">{{ 'ADD_NEW' | translate }}</a>\n" +
    "\t\t</header>\n" +
    "\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t<span class=\"count-show\">Show</span>\n" +
    "\t\t\t<div class=\"select table-count rates-table-count\">\n" +
    "\t\t\t\t<select ng-model=\"displyCount\"\tng-options=\"opt for opt in displayCountList\"></select>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<span class=\"count-entries\">entries</span>\n" +
    "\t\t\t\t\n" +
    "\t\t\t<div class=\"entry table-search\">\n" +
    "\t\t\t\t<span class=\"search-text\">Search</span>\n" +
    "\t\t\t\t<span class=\"icons icon-search\" name=\"submit\" type=\"submit\"></span>\n" +
    "\t\t\t\t<input placeholder=\"\" autocomplete=\"off\" type=\"text\" ad-delay-textbox ng-model=\"searchTerm\" delay=\"1000\" function-to-fire=\"searchEntered\" />\n" +
    "\t\t    </div>\n" +
    "\t\t\t<table id=\"rooms\" class=\"grid datatable\" ng-table=\"tableParams\" template-pagination=\"custom/pager\">\n" +
    "\t\t\t\t<tbody>\n" +
    "\t\t\t\t\t<tr ng-repeat=\"room in $data\" room-id=\"{{room.room_id}}\">\n" +
    "\t\t\t\t\t\t<td data-title=\"'Room Number'\" sortable=\"'room_number'\"  header-class=\"width-50\">\n" +
    "\t\t\t\t\t\t\t<a ui-sref='admin.roomdetails({roomId:room.room_id})' class=\"number edit-data\">\n" +
    "\t\t\t\t\t\t\t\t{{room.room_number}}\n" +
    "\t\t\t\t\t\t\t</a>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td data-title=\"'Room Type'\" sortable=\"'room_type'\" header-class=\"width-50\">\n" +
    "\t\t\t\t\t\t\t{{room.room_type}}\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td data-title=\"'Delete'\" ng-click=\"deleteRoom($index, room.room_id)\" header-class=\"width-15 text-center-important\" ng-show=\"isStandAlone\">\n" +
    "\t\t\t\t\t\t\t<a class=\"icons icon-delete large-icon \" ></a>\t\t\t\t\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t</tr>\n" +
    "\t\t\t\t</tbody>\n" +
    "\t\t\t</table>\n" +
    "\t\t</section>\n" +
    "\n" +
    "\t\t<!--Custom pagination footer goes here-->\n" +
    "\t\t<script type=\"text/ng-template\" id=\"custom/pager\">\n" +
    "\t\t\t<div class = \"pager\">\n" +
    "\t\t\t\t<span ng-show=\"totalCount>0\">Showing {{startCount}} to {{endCount}} of {{totalCount}} items</span>\n" +
    "\t\t\t\t<span ng-show=\"totalCount==0\">Showing 0 items</span>\n" +
    "\t\t\t\t<ul class=\"ng-cloak\">\n" +
    "\t              \t<li ng-repeat=\"page in pages\"\n" +
    "\t\t                ng-class=\"{'previous': page.type == 'prev', 'next': page.type == 'next'}\"\n" +
    "\t\t                ng-show=\"page.type == 'prev' || page.type == 'next'\" ng-switch=\"page.type\">\n" +
    "\t\n" +
    "\t\t                <a ng-switch-when=\"prev\" ng-click=\"params.page(1)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">First</a>\n" +
    "\t\t                <a ng-switch-when=\"prev\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">Previous</a>\n" +
    "\t\t                <a ng-switch-when=\"prev\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">{{page.number}}</a>\n" +
    "\t\t                \n" +
    "\t\t                <a ng-switch-when=\"next\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">{{page.number}}</a>\n" +
    "\t\t                <a ng-switch-when=\"next\" ng-click=\"params.page(page.number)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">Next</a>\n" +
    "\t\t                <a ng-switch-when=\"next\" ng-click=\"params.page(totalPage)\" class=\"page\" ng-class=\"{'disabled': !page.active}\">Last</a>\n" +
    "\t\t          \t</li>\n" +
    "\t            </ul>\n" +
    "\t        </div>\n" +
    "\t\t</script>\n" +
    "\t\t<!--end-->\n" +
    "\t</section>\n" +
    "</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/rulesRestriction/adCancellationPenaltiesRules.html',
    "<table class=\"grid sub-grid\">\n" +
    "\t<tr ng-hide=\"showCancelForm || !showCancelList\" ng-repeat=\"rule in cancelRulesList\">\n" +
    "\t\t<td class=\"offset\"> &nbsp; </td>\n" +
    "\t\t<td ng-click=\"editSingleRule(rule, 'Cancellation Penalties')\"><a href>{{ rule.name }}</a></td>\n" +
    "\n" +
    "\t\t<td>{{ rule.description }}</td>\n" +
    "\n" +
    "\t\t<td width=\"10\" class=\"delete\">\n" +
    "\t\t\t<a class=\"icons icon-delete large-icon\" ng-click=\"deleteRule(rule, 'Cancellation Penalties')\"translate>DELETE_RULE</a>\t\t\n" +
    "\t\t</td>\n" +
    "\t</tr>\n" +
    "\n" +
    "\t<tr ng-show=\"showCancelForm\">\n" +
    "\t\t<td class=\"offset\"> &nbsp; </td>\n" +
    "\t\t<td>\n" +
    "\t\t\t<div style=\"display: block;\" id=\"add-new\" class=\"edit-data\">\n" +
    "\t\t\t\t<div class=\"data-holder\">\n" +
    "\t\t\t\t\t<form id=\"add-addon\" name=\"add-addon\" class=\"form inline-form float\">\n" +
    "\t\t\t\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t\t\t\t<h3>\n" +
    "\t\t\t\t\t\t\t\t<span>{{ rulesTitle }}</span>\n" +
    "\t\t\t\t\t\t\t\t{{ rulesSubtitle }}\n" +
    "\t\t\t\t\t\t\t</h3>\n" +
    "\t\t\t\t\t\t\t<em class=\"status\">\n" +
    "\t\t\t\t\t\t\t\t{{'MANDATORY_FIELDS_MESSAGE1'| translate}}\n" +
    "\t\t\t\t\t\t\t\t<strong>*</strong>\n" +
    "\t\t\t\t\t\t\t\t{{'MANDATORY_FIELDS_MESSAGE2'| translate}}\n" +
    "\t\t\t\t\t\t\t</em>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t\t<fieldset class=\"holder left float\">\t\n" +
    "\t\t\t\t\t\t\t<ad-textbox styleclass=\"full-width\"\n" +
    "\t\t\t\t\t\t\t\tvalue=\"singleRule.name\"\n" +
    "\t\t\t\t\t\t\t\tname=\"name\"\n" +
    "\t\t\t\t\t\t\t\tid=\"name\"\n" +
    "\t\t\t\t\t\t\t\tlabel=\"Request name\"\n" +
    "\t\t\t\t\t\t\t\tplaceholder=\"{{'ENTER_THE_REQUEST_NAME'|translate}}\"\n" +
    "\t\t\t\t\t\t\t\trequired=\"yes\"></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t\t\t\t<ad-textarea rows=\"4\"\n" +
    "\t\t\t\t\t\t\t\tdiv-class=\"full-width\"\n" +
    "\t\t\t\t\t\t\t\ttext-area-class=\"full-width\"\n" +
    "\t\t\t\t\t\t\t\tvalue=\"singleRule.description\"\n" +
    "\t\t\t\t\t\t\t\tname=\"desc\"\n" +
    "\t\t\t\t\t\t\t\tid=\"desc\"\n" +
    "\t\t\t\t\t\t\t\tlabel=\"Description\"\n" +
    "\t\t\t\t\t\t\t\tplaceholder=\"{{'ENTER_THE_REQUEST_DESC'|translate}}\"\n" +
    "\t\t\t\t\t\t\t\trequired=\"yes\"></ad-textarea>\n" +
    "\t\t\t\t\t\t</fieldset>\n" +
    "\n" +
    "\t\t\t\t\t\t<fieldset class=\"holder right float\">\n" +
    "\t\t\t\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t\t\t\t<ad-textbox styleclass=\"full-width\"\n" +
    "\t\t\t\t\t\t\t\t\tvalue=\"singleRule.amount\"\n" +
    "\t\t\t\t\t\t\t\t\tname=\"amount\"\n" +
    "\t\t\t\t\t\t\t\t\tid=\"amount\"\n" +
    "\t\t\t\t\t\t\t\t\tlabel=\"Amount[{{ currencySymbol }}]\"\n" +
    "\t\t\t\t\t\t\t\t\tplaceholder=\"{{'ENTER_THE_AMT'|translate}}\"\n" +
    "\t\t\t\t\t\t\t\t\trequired=\"yes\"></ad-textbox>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t\t\t\t\t\t<label for=\"amount-type-id\">\n" +
    "\t\t\t\t\t\t\t\t\t\t{{'AMOUNT_TYPE'|translate}}\n" +
    "\t\t\t\t\t\t\t\t\t\t<strong>*</strong>\n" +
    "\t\t\t\t\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t\t\t\t\t<div class=\"select\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<select name=\"amount-type-id\" id=\"amount-type-id\" ng-model=\"singleRule.amount_type\">\n" +
    "\t\t\t\t\t\t\t\t\t\t\t<option value=\"\" data-text=\"Not set\" class=\"placeholder\">Choose amount type</option>\n" +
    "\t\t\t\t\t\t\t\t\t\t\t<option value=\"amount\">{{'AMOUNT'|translate}}[{{ currencySymbol }}]</option>\n" +
    "\t\t\t\t\t\t\t\t\t\t\t<option value=\"percent\" translate>PERCENTAGE</option>\n" +
    "\t\t\t\t\t\t\t\t\t\t\t<option value=\"day\" translate>NIGHTS</option>\n" +
    "\t\t\t\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t\t\t<div class=\"entry full-width\" ng-show=\"singleRule.amount_type === 'percent'\">\n" +
    "\t\t\t\t\t\t\t\t<label for=\"amount-type-id\">\n" +
    "\t\t\t\t\t\t\t\t\t{{'PER_NIGHT_OR_STAY'|translate}}\n" +
    "\t\t\t\t\t\t\t\t\t<strong>*</strong>\n" +
    "\t\t\t\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select\">\n" +
    "\t\t\t\t\t\t\t\t\t<select name=\"amount-type-id\" id=\"amount-type-id\" ng-model=\"singleRule.post_type_id\" ng-options=\"type.id as type.description for type in postTypes\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<option value=\"\" data-text=\"Not set\" class=\"placeholder\" translate>CHOOSE_NIGHT_OR_STAY</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t\t\t<div class=\"entry margin-right\">\n" +
    "\t\t\t\t\t\t\t\t<ad-textbox styleclass=\"full-width\"\n" +
    "\t\t\t\t\t\t\t\t\tvalue=\"singleRule.advance_days\"\n" +
    "\t\t\t\t\t\t\t\t\tname=\"name\"\n" +
    "\t\t\t\t\t\t\t\t\tid=\"name\"\n" +
    "\t\t\t\t\t\t\t\t\tlabel=\"Days In advance\"\n" +
    "\t\t\t\t\t\t\t\t\tplaceholder=\"{{'ENTER_THE_NUM_OF_DAYS'|translate}}\"></ad-textbox>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t<div class=\"entry no-margin-right\">\n" +
    "\t\t\t\t\t\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t\t\t\t\t\t<label translate>TIME</label>\n" +
    "\t\t\t\t\t\t\t\t\t<div>\n" +
    "\t\t\t\t\t\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\t\t\t\t\t\t\t\t\t\t\t<select ng-model=\"singleRule.advance_hour\" name=\"hotel-checkin-hour\" id=\"hotel-checkin-hour\" class=\"styled\">\n" +
    "\t\t\t\t\t\t\t\t\t\t\t\t<option value=\"\" data-text=\"Not set\" class=\"placeholder\" translate>HH</option>\n" +
    "\t\t\t\t\t\t\t\t\t\t\t\t<option ng-repeat=\"i in [1, 12, 1, 2] | makeRange\" value=\"{{i}}\" ng-selected=\"i==singleRule.advance_hour\" >{{i}}</option>\n" +
    "\t\t\t\t\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\t\t\t\t\t\t\t\t\t\t\t<select ng-model=\"singleRule.advance_min\" name=\"hotel-checkin-minute\" id=\"hotel-checkin-minutes\">\n" +
    "\t\t\t\t\t\t\t\t\t\t\t\t<option value=\"\" data-text=\"Not set\" class=\"placeholder\" translate>MM</option>\n" +
    "\t\t\t\t\t\t\t\t\t\t\t\t<option ng-repeat=\"i in [0, 45, 15, 2] | makeRange\" value=\"{{i}}\" ng-selected=\"i==singleRule.advance_min\" >{{i}}</option>\n" +
    "\t\t\t\t\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\t\t\t\t\t\t\t\t\t\t\t<select ng-model=\"singleRule.advance_primetime\" class=\"styled\">\n" +
    "\t\t\t\t\t\t\t\t\t\t\t\t<option ng-selected=\"singleRule.advance_primetime == 'AM'\" value=\"AM\" translate>AM</option>\n" +
    "\t\t\t\t\t\t\t\t\t\t\t\t<option ng-selected=\"singleRule.advance_primetime == 'PM'\" value=\"PM\" translate>PM</option>\n" +
    "\t\t\t\t\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t<div class=\"entry margin\">\n" +
    "\t\t\t\t\t\t\t\t<label translate>CANCELLATION_CHARGE_CODE</label>\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select\">\n" +
    "\t\t\t\t\t\t\t\t\t<select class=\"placeholder\" ng-model=\"singleRule.charge_code_id\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<option value=\"\" ng-selected=\"singleRule.charge_code_id == ''\" translate>SELECT_CHARGE_CODE</option>\n" +
    "\t\t\t\t\t\t\t\t\t\t<option ng-selected=\"singleRule.charge_code_id == charge_code.charge_code\" value=\"{{charge_code.value}}\" ng-repeat=\"charge_code in chargeCodes\" >{{charge_code.charge_code+' '+charge_code.description}}</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t\t\t<div class=\"entry full-width radio-check\">\n" +
    "\t\t\t\t\t\t\t\t<label class=\"checkbox\">\n" +
    "\t\t\t\t\t\t\t\t\t<span class=\"icon-form icon-checkbox\" ng-class=\"{ checked : singleRule.apply_to_all_bookings }\"></span>\n" +
    "\t\t\t\t\t\t\t\t\t<label translate>APPLY_TO_ALL_BOOKINGS</label>\n" +
    "\t\t\t\t\t\t\t\t\t<input type=\"checkbox\" ng-model=\"singleRule.apply_to_all_bookings\">\n" +
    "\t\t\t\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t</fieldset>\n" +
    "\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t<div class=\"actions float\">\n" +
    "\t\t\t\t\t\t\t<button type=\"button\"\n" +
    "\t\t\t\t\t\t\t\tid=\"cancel\"\n" +
    "\t\t\t\t\t\t\t\tclass=\"button blank add-data-inline\"\n" +
    "\t\t\t\t\t\t\t\tng-click=\"cancelCliked()\" translate>CANCEL</button>\n" +
    "\t\t\t\t\t\t\t<button type=\"button\"\n" +
    "\t\t\t\t\t\t\t\tlike-type=\"common\"\n" +
    "\t\t\t\t\t\t\t\tid=\"update\"\n" +
    "\t\t\t\t\t\t\t\tclass=\"button green add-data-inline\"\n" +
    "\t\t\t\t\t\t\t\tng-click=\"saveUpdateRule('Cancellation Penalties')\" translate>SAVE_CHANGES</button>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t</form>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</div>\t\n" +
    "\t\t</td>\n" +
    "\t</tr>\n" +
    "</table>"
  );


  $templateCache.put('/assets/partials/rulesRestriction/adDepositRequestRules.html',
    "<table class=\"grid sub-grid\">\n" +
    "\t<tr ng-hide=\"showDepositForm || !showDepositList\" ng-repeat=\"rule in depositRuleslList\">\n" +
    "\t\t<td class=\"offset\"> &nbsp; </td>\n" +
    "\t\t<td ng-click=\"editSingleRule(rule, 'Deposit Requests')\"><a href>{{ rule.name }}</a></td>\n" +
    "\n" +
    "\t\t<td>{{ rule.description }}</td>\n" +
    "\n" +
    "\t\t<td width=\"10\" class=\"delete\">\n" +
    "\t\t\t<a class=\"icons icon-delete large-icon\" ng-click=\"deleteRule(rule, 'Deposit Requests')\" translate>DELETE_RULE</a>\t\t\n" +
    "\t\t</td>\n" +
    "\t</tr>\n" +
    "\n" +
    "\t<tr ng-show=\"showDepositForm\">\n" +
    "\t\t<td class=\"offset\"> &nbsp; </td>\n" +
    "\t\t<td>\n" +
    "\t\t\t\n" +
    "\t\t\t<div style=\"display: block;\" id=\"add-new\" class=\"edit-data\">\n" +
    "\t\t\t\t<div class=\"data-holder\">\n" +
    "\t\t\t\t\t<form id=\"add-addon\" name=\"add-addon\" class=\"form inline-form float\">\n" +
    "\t\t\t\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t\t\t\t<h3>\n" +
    "\t\t\t\t\t\t\t\t<span>{{ rulesTitle }}</span>\n" +
    "\t\t\t\t\t\t\t\t{{ rulesSubtitle }}\n" +
    "\t\t\t\t\t\t\t</h3>\n" +
    "\t\t\t\t\t\t\t<em class=\"status\">\n" +
    "\t\t\t\t\t\t\t\t{{'MANDATORY_FIELDS_MESSAGE1'| translate}}\n" +
    "\t\t\t\t\t\t\t\t<strong>*</strong>\n" +
    "\t\t\t\t\t\t\t\t{{'MANDATORY_FIELDS_MESSAGE2'| translate}}\n" +
    "\t\t\t\t\t\t\t</em>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t\t<fieldset class=\"holder left float\">\n" +
    "\t\t\t\t\t\t\t<ad-textbox styleclass=\"full-width\"\n" +
    "\t\t\t\t\t\t\t\tvalue=\"singleRule.name\"\n" +
    "\t\t\t\t\t\t\t\tname=\"name\"\n" +
    "\t\t\t\t\t\t\t\tid=\"name\"\n" +
    "\t\t\t\t\t\t\t\tlabel=\"Policy name\"\n" +
    "\t\t\t\t\t\t\t\tplaceholder=\"{{'ENTER_THE_POLICY_NAME'|translate}}\"\n" +
    "\t\t\t\t\t\t\t\trequired=\"yes\"></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t\t\t\t<ad-textarea rows=\"4\"\n" +
    "\t\t\t\t\t\t\t\tdiv-class=\"full-width\"\n" +
    "\t\t\t\t\t\t\t\ttext-area-class=\"full-width\"\n" +
    "\t\t\t\t\t\t\t\tvalue=\"singleRule.description\"\n" +
    "\t\t\t\t\t\t\t\tname=\"desc\"\n" +
    "\t\t\t\t\t\t\t\tid=\"desc\"\n" +
    "\t\t\t\t\t\t\t\tlabel=\"Description\"\n" +
    "\t\t\t\t\t\t\t\tplaceholder=\"{{'ENTER_THE_POLICY_DESC'|translate}}\"\n" +
    "\t\t\t\t\t\t\t\trequired=\"yes\"></ad-textarea>\n" +
    "\t\t\t\t\t\t</fieldset>\n" +
    "\n" +
    "\t\t\t\t\t\t<fieldset class=\"holder right float\">\n" +
    "\t\t\t\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t\t\t\t<ad-textbox styleclass=\"full-width\"\n" +
    "\t\t\t\t\t\t\t\t\tvalue=\"singleRule.amount\"\n" +
    "\t\t\t\t\t\t\t\t\tname=\"amount\"\n" +
    "\t\t\t\t\t\t\t\t\tid=\"amount\"\n" +
    "\t\t\t\t\t\t\t\t\tlabel=\"Amount[{{ currencySymbol }}]\"\n" +
    "\t\t\t\t\t\t\t\t\tplaceholder=\"{{'ENTER_THE_AMT'|translate}}\"\n" +
    "\t\t\t\t\t\t\t\t\trequired=\"yes\"></ad-textbox>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t\t\t\t\t\t<label for=\"amount-type-id\">\n" +
    "\t\t\t\t\t\t\t\t\t\t{{'AMOUNT_TYPE'|translate}}\n" +
    "\t\t\t\t\t\t\t\t\t\t<strong>*</strong>\n" +
    "\t\t\t\t\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t\t\t\t\t<div class=\"select\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<select name=\"amount-type-id\" id=\"amount-type-id\" ng-model=\"singleRule.amount_type\">\n" +
    "\t\t\t\t\t\t\t\t\t\t\t<option value=\"\" data-text=\"Not set\" class=\"placeholder\">Choose amount type</option>\n" +
    "\t\t\t\t\t\t\t\t\t\t\t<option value=\"amount\">{{'AMOUNT'|translate}}[{{ currencySymbol }}]</option>\n" +
    "\t\t\t\t\t\t\t\t\t\t\t<option value=\"percent\" translate>PERCENTAGE</option>\n" +
    "\t\t\t\t\t\t\t\t\t\t\t<option value=\"day\" translate>NIGHTS</option>\n" +
    "\t\t\t\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t\t\t<div class=\"entry full-width\" ng-show=\"singleRule.amount_type === 'percent'\">\n" +
    "\t\t\t\t\t\t\t\t<label for=\"amount-type-id\"> \n" +
    "\t\t\t\t\t\t\t\t\t{{'PER_NIGHT_OR_STAY'|translate}}\n" +
    "\t\t\t\t\t\t\t\t\t<strong>*</strong>\n" +
    "\t\t\t\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select\">\n" +
    "\t\t\t\t\t\t\t\t\t<select name=\"amount-type-id\" id=\"amount-type-id\" ng-model=\"singleRule.post_type_id\" ng-options=\"type.id as type.description for type in postTypes\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<option value=\"\" data-text=\"Not set\" class=\"placeholder\" translate>CHOOSE_NIGHT_OR_STAY</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t\t\t\t<ad-textbox styleclass=\"full-width\"\n" +
    "\t\t\t\t\t\t\t\t\tvalue=\"singleRule.advance_days\"\n" +
    "\t\t\t\t\t\t\t\t\tname=\"name\"\n" +
    "\t\t\t\t\t\t\t\t\tid=\"name\"\n" +
    "\t\t\t\t\t\t\t\t\tlabel=\"Days In advance\"\n" +
    "\t\t\t\t\t\t\t\t\tplaceholder=\"{{'ENTER_THE_NUM_OF_DAYS'|translate}}\"></ad-textbox>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t\t\t<div class=\"entry full-width radio-check\">\n" +
    "\t\t\t\t\t\t\t\t<label class=\"checkbox\">\n" +
    "\t\t\t\t\t\t\t\t\t<span class=\"icon-form icon-checkbox\" ng-class=\"{ checked : singleRule.apply_to_all_bookings }\"></span>\n" +
    "\t\t\t\t\t\t\t\t\t<label translate>APPLY_TO_ALL_BOOKINGS</label>\n" +
    "\t\t\t\t\t\t\t\t\t<input type=\"checkbox\" ng-model=\"singleRule.apply_to_all_bookings\">\n" +
    "\t\t\t\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t<div class=\"entry full-width radio-check\">\n" +
    "\t\t\t\t\t\t\t\t<label class=\"checkbox\">\n" +
    "\t\t\t\t\t\t\t\t\t<span class=\"icon-form icon-checkbox\" ng-class=\"{ checked : singleRule.allow_deposit_edit }\"></span>\n" +
    "\t\t\t\t\t\t\t\t\t<label>Allow editing of Deposit Payment</label>\n" +
    "\t\t\t\t\t\t\t\t\t<input type=\"checkbox\" ng-model=\"singleRule.allow_deposit_edit\">\n" +
    "\t\t\t\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t</fieldset>\n" +
    "\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t<div class=\"actions float\">\n" +
    "\t\t\t\t\t\t\t<button type=\"button\"\n" +
    "\t\t\t\t\t\t\t\tid=\"cancel\"\n" +
    "\t\t\t\t\t\t\t\tclass=\"button blank add-data-inline\"\n" +
    "\t\t\t\t\t\t\t\tng-click=\"cancelCliked()\" translate>CANCEL</button>\n" +
    "\t\t\t\t\t\t\t<button type=\"button\"\n" +
    "\t\t\t\t\t\t\t\tlike-type=\"common\"\n" +
    "\t\t\t\t\t\t\t\tid=\"update\"\n" +
    "\t\t\t\t\t\t\t\tclass=\"button green add-data-inline\"\n" +
    "\t\t\t\t\t\t\t\tng-click=\"saveUpdateRule('Deposit Requests')\" translate>SAVE_CHANGES</button>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t</form>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</div>\n" +
    "\t\t</td>\n" +
    "\t</tr>\n" +
    "</table>"
  );


  $templateCache.put('/assets/partials/rulesRestriction/adRulesRestriction.html',
    "<section id=\"replacing-div-first\"\n" +
    "\t\t\tclass=\"content current\" ng-click=\"clearErrorMessage()\">\n" +
    "\n" +
    "\t<div data-view=\"GuestCardLikesView\">\n" +
    "\t\t<header class=\"content-title float\">\n" +
    "\t\t\t<h2 translate>\n" +
    "\t\t\t\tRULES_AND_RESTRICTIONS\n" +
    "\t\t\t</h2>\n" +
    "\t\t</header>\n" +
    "\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\n" +
    "\t\t\t<div id=\"new-form-holder\"\n" +
    "\t\t\t\t\tng-show=\"isAddmode\"\n" +
    "\t\t\t\t\tng-include=\"getTemplateUrl()\"></div>\n" +
    "\n" +
    "\t\t\t<table id=\"rules\">\n" +
    "\t\t\t\t<tbody>\n" +
    "\t\t\t\t\t<tr><td><br><strong class=\"sep-heading\" translate>RESTRICTIONS</strong></td></tr>\n" +
    "\n" +
    "\t\t\t\t\t<tr ng-repeat=\"item in ruleList | filter: { editable: false }\">\n" +
    "\t\t\t\t\t\t<td>\n" +
    "\t\t\t\t\t\t\t<table class=\"grid\">\n" +
    "\t\t\t\t\t\t\t\t<td>\n" +
    "\t\t\t\t\t\t\t\t\t<strong> {{ item.description }} </strong>\n" +
    "\t\t\t\t\t\t\t\t\t<em translate>SYSTEM_DEFINED</em>\n" +
    "\t\t\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t\t\t<td class=\"activate text-left\">\n" +
    "\t\t\t\t\t\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<label></label>\n" +
    "\t\t\t\t\t\t\t\t\t\t<div class=\"switch-button single\"\n" +
    "\t\t\t\t\t\t\t\t\t\t\t\tng-class=\"{ on: item.activated }\">\n" +
    "\t\t\t\t\t\t\t\t\t\t\t<input type = \"checkbox\"\n" +
    "\t\t\t\t\t\t\t\t\t\t\t\t\tid = \"upsell-rooms\"\n" +
    "\t\t\t\t\t\t\t\t\t\t\t\t\tname = \"upsell-rooms\"\n" +
    "\t\t\t\t\t\t\t\t\t\t\t\t\tng-click = \"switchClicked(item)\">\n" +
    "\t\t\t\t\t\t\t\t\t\t\t<span class=\"switch-icon\"></span>\n" +
    "\t\t\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t\t</table>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t</tr>\n" +
    "\n" +
    "\t\t\t\t\t<tr><td><br><br><strong class=\"sep-heading\" translate>RULES</strong></td></tr>\n" +
    "\n" +
    "\t\t\t\t\t<tr ng-repeat=\"item in ruleList | filter: { editable: true }\" ng-hide=\"{{ item.description === 'Levels' }}\">\n" +
    "\t\t\t\t\t\t<td>\n" +
    "\t\t\t\t\t\t\t<table class=\"grid\">\n" +
    "\t\t\t\t\t\t\t\t<td>\n" +
    "\t\t\t\t\t\t\t\t\t<span class=\"toggle\" ng-click=\"toggleRulesListShow()\" ng-show=\"showPolicyArrow()\"></span>\n" +
    "\t\t\t\t\t\t\t\t\t<a class=\"inline\" ng-click=\"toggleRulesListShow()\"> {{ item.description }} </a>\n" +
    "\t\t\t\t\t\t\t\t\t<em class=\"action add\" ng-click=\"openAddNewRule()\" translate>ADD_NEW_RULE</em>\n" +
    "\t\t\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t\t\t<td class=\"activate text-left\">\n" +
    "\t\t\t\t\t\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<label></label>\n" +
    "\t\t\t\t\t\t\t\t\t\t<div class=\"switch-button single\"\n" +
    "\t\t\t\t\t\t\t\t\t\t\t\tng-class=\"{ on: item.activated }\">\n" +
    "\t\t\t\t\t\t\t\t\t\t\t<input type = \"checkbox\"\n" +
    "\t\t\t\t\t\t\t\t\t\t\t\t\tid = \"upsell-rooms\"\n" +
    "\t\t\t\t\t\t\t\t\t\t\t\t\tname = \"upsell-rooms\"\n" +
    "\t\t\t\t\t\t\t\t\t\t\t\t\tng-click = \"switchClicked(item)\">\n" +
    "\t\t\t\t\t\t\t\t\t\t\t<span class=\"switch-icon\"></span>\n" +
    "\t\t\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t\t</table>\n" +
    "\t\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t\t<div ng-include=\"getTemplateUrl()\"></div>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t</tr>\n" +
    "\t\t\t\t</tbody>\n" +
    "\t\t\t</table>\n" +
    "\t\t</section>\n" +
    "\t</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/settingsAndParams/adSettingsAndParams.html',
    "<section id=\"replacing-div-first\" class=\"content current\" ng-click=\"clearErrorMessage()\">\n" +
    "\t<div data-view=\"UpsellLateCheckoutView\">\n" +
    "\t\t<section>\n" +
    "\t\t\t<header class=\"content-title float\">\n" +
    "\t\t\t\t<h2 translate>SETTINGS_AND_PARAMS</h2>\n" +
    "\t\t\t\t<a id=\"go_back\" data-type=\"load-details\" class=\"action back\" ng-click=\"goBackToPreviousState()\"translate>BACK</a>\n" +
    "\t\t\t</header>\n" +
    "\t\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t\t<form  class=\"form float\" >\n" +
    "\t\t\t\t\t<div class=\"form-title full-width\">\n" +
    "\t\t\t\t\t\t<h3><span translate>CHANGE_BUSSINESS_DAY</span></h3>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t<fieldset class=\"holder left\">\n" +
    "\t\t\t\t\t\t<div></div>\n" +
    "\n" +
    "\t\t\t\t\t\t<!-- Switch -->\n" +
    "\t\t\t\t\t\t<ad-toggle-button is-checked=\" data.is_auto_change_bussiness_date\" label=\"Auto Change Business Date\"></ad-toggle-button>\n" +
    "\n" +
    "\t\t\t\t\t\t<div class=\"entry margin\">\n" +
    "\t\t\t\t\t\t\t\t<label translate>NO_SHOW_CHARGE_CODE</label>\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select\">\n" +
    "\t\t\t\t\t\t\t\t\t<select class=\"placeholder\" ng-model=\"selected_charge_code\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<option value=\"\" ng-selected=\"selected_charge_code == ''\"translate>SELECT_CHARGE_CODE</option>\n" +
    "\t\t\t\t\t\t\t\t\t\t<option ng-selected=\"selected_charge_code == charge_code.charge_code\" value=\"{{charge_code.charge_code}}\" ng-repeat=\"charge_code in chargeCodes\" >{{charge_code.charge_code+' '+charge_code.description}}</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t</fieldset>\n" +
    "\t\t\t\t\t<fieldset class=\"holder right\">\n" +
    "\n" +
    "\t\t\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t\t\t<label translate>TIME_TO_CHANGE_BUSSINESS_DATE</label>\n" +
    "\t\t\t\t\t\t\t<div class=\"entry full-width float\">\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t<!--  hour -->\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t\t<select ng-options=\"hour for hour  in hours\" ng-model=\"data.changing_hour\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<option style=\"display:none\" value=\"\">HH</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t<!--  minute -->\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\t\t\t\t\t\t\t\t\t<select ng-options=\"minute for minute  in minutes\" ng-model=\"data.changing_minute\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<option style=\"display:none\" value=\"\">MM</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\t\t\t\t\t\t\t\t\t<select name=\"hotel-checkout-primetime\"class=\"styled\" ng-model=\"data.business_date_prime_time\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<option value=\"AM\">AM</option>\n" +
    "\t\t\t\t\t\t\t\t\t\t<option value=\"PM\">PM</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\n" +
    "\t\t\t\t\t</fieldset>\n" +
    "\n" +
    "\t\t\t\t\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t\t<div class=\"actions float\">\n" +
    "\t\t\t\t\t\t<button type=\"button\" id=\"cancel\" class=\"button blank\" ng-click=\"goBackToPreviousState()\"translate>\n" +
    "\t\t\t\t\t\t\tCANCEL\n" +
    "\t\t\t\t\t\t</button>\n" +
    "\t\t\t\t\t\t<button type=\"button\" id=\"save\" class=\"button green\" ng-click=\"saveClick()\"translate>\n" +
    "\t\t\t\t\t\t\tSAVE_CHANGES\n" +
    "\t\t\t\t\t\t</button>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</form>\n" +
    "\t\t\t</section>\n" +
    "\t\t</section>\n" +
    "\t</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/sources/adSources.html',
    "<section  class=\"content current\" ng-click=\"clearErrorMessage()\">\n" +
    "\t<div class=\"inline-edit\">\n" +
    "\t\t<header class=\"content-title float\">\n" +
    "\t\t\t<h2 translate> SOURCES </h2>\n" +
    "\t\t\t<span class=\"count\"> (\n" +
    "\t\t\t\t{{data.sources.length}}\n" +
    "\t\t\t\t) </span>\n" +
    "\t\t\t<a class=\"action add\" ng-hide=\"!data.is_use_sources\" ng-click=\"addNewClicked()\" translate>ADD_NEW</a>\n" +
    "\t\t\t<ad-toggle-button is-checked=\"data.is_use_sources\" div-class=\"header-title\" ng-click=\"clickedUsedSources()\" label=\"{{'USE_SOURCES' | translate}}\"></ad-toggle-button>\n" +
    "\t\t</header>\n" +
    "\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t\n" +
    "\t\t\t<div id=\"add-new\" ng-show=\"currentClickedElement == 'new'\" ng-include=\"'/assets/partials/sources/adSourcesAdd.html'\"></div>\t\t\n" +
    "\t\t\t\n" +
    "\t\t\t<table class=\"grid\" ng-disabled=\"data.is_use_sources\" ng-class=\"{'overlay' : !data.is_use_sources}\">\n" +
    "\t\t\t\t<tbody>\n" +
    "\t\t\t\t\t<tr ng-repeat=\"item in data.sources\" > \n" +
    "\t\t\t\t\t\t<td ng-click=\"editItem($index)\" ng-hide=\"currentClickedElement == $index\">\n" +
    "\t\t\t\t\t\t\t<a data-item=\"1\" data-colspan=\"2\" class=\"edit-data-inline\">{{item.name}} </a>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td class=\"activate\" ng-click=\"updateItem($index)\" ng-hide=\"currentClickedElement == $index\">\n" +
    "\t\t\t\t\t\t\t<ad-toggle-button is-checked=\"item.is_active\" ></ad-toggle-button>\n" +
    "\t\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t\t<td colspan=\"2\" ng-include=\"getTemplateUrl($index)\"></td>\n" +
    "\t\t\t\t\t</tr>\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t</tbody>\n" +
    "\t\t\t</table>\n" +
    "\t\t</section>\n" +
    "\t</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/sources/adSourcesAdd.html',
    "<div class=\"data-holder\">\n" +
    "\t<form class=\"form inline-form float\">\n" +
    "\t\t<div class=\"form-title\">\n" +
    "\t\t\t<h3><span></span> {{'ADD'| translate}}  </h3>\n" +
    "\t\t\t<em class=\"status\"> {{'MANDATORY_FIELDS_MESSAGE1' | translate}} <strong>*</strong> {{'MANDATORY_FIELDS_MESSAGE2' | translate}} </em>\n" +
    "\t\t</div>\n" +
    "\t\t<fieldset class=\"holder left float\">\n" +
    "\t\t\t<ad-textbox value=\"data.name\"  name = \"item-name\" label = \"{{'NAME' | translate }}\" placeholder = \"{{'SOURCE_NAME_PLACEHOLDER' | translate }}\" required = \"yes\"></ad-textbox>\n" +
    "\t\t</fieldset>\n" +
    "\t\t<div class=\"actions float\">\n" +
    "\t\t\t<button type=\"button\" ng-click=\"clickedCancel()\" class=\"button blank edit-data-inline\" translate>\n" +
    "\t\t\t\tCANCEL\n" +
    "\t\t\t</button>\n" +
    "\t\t\t<button type=\"button\" ng-click=\"saveAddNew()\" class=\"button green edit-data-inline\" translate>\n" +
    "\t\t\t\tSAVE_CHANGES\n" +
    "\t\t\t</button>\n" +
    "\t\t</div>\n" +
    "\t</form>\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/sources/adSourcesEdit.html',
    "<div class=\"data-holder\">\n" +
    "\t<form class=\"form single-field-form float\">\n" +
    "\t\t<ad-textbox value=\"item.name\" name = \"item-name\" label = \"\" placeholder = \"Enter source name\" required = \"\"></ad-textbox>\n" +
    "\n" +
    "\t\t<div class=\"actions float\">\n" +
    "\t\t\t<button type=\"button\" class=\"button blank edit-data-inline\" ng-click=\"clickedCancel()\" translate>\n" +
    "\t\t\t\tCANCEL\n" +
    "\t\t\t</button>\n" +
    "\t\t\t<button type=\"button\" class=\"button green edit-data-inline\" ng-click=\"updateItem()\" translate>\n" +
    "\t\t\t\tSAVE_CHANGES\n" +
    "\t\t\t</button>\n" +
    "\t\t\t<button type=\"button\" class=\"button red edit-data-inline\" ng-click=\"clickedDelete(item.value)\" translate>\n" +
    "\t\t\t\tDELETE\n" +
    "\t\t\t</button>\n" +
    "\t\t</div>\n" +
    "\t\t\n" +
    "\t</form>\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/stationary/adStationary.html',
    "<div id=\"wrapper\" class=\"content current\" ng-click=\"clearErrorMessage()\" >\n" +
    "\t<header class=\"content-title float\">\n" +
    "\t\t<h2 translate>STATIONARY</h2>\n" +
    "\t\t<a ng-click =\"goBackToPreviousState()\" class=\"action back\" translate> BACK</a>\n" +
    "\t</header>\n" +
    "\t<section class=\"content-scroll\">\n" +
    "\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t<div ng-include=\"'/assets/partials/common/notification_success_message.html'\"></div> \n" +
    "\t<form class=\"form float\" >\t\t\n" +
    "\t\t<fieldset class=\"holder left\">\n" +
    "\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t<h3>\n" +
    "\t\t\t\t\t<span>{{'CUSTOMIZE' | translate}}</span>\n" +
    "\t\t\t\t\t{{'GUEST_BILL_TITLE' | translate}}\n" +
    "\t\t\t\t</h3>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t<label for=\"guest-bill-template\" translate>GUEST_BILL_TEMPLATE </label>\n" +
    "\t\t\t\t<div class=\"select\" >\n" +
    "\t\t\t\t\t<select ng-model=\"data.selected_guest_bill_template\" name=\"guest-bill-template\" class=\"placeholder\">\n" +
    "\t\t\t\t\t\t<option value=\"\" translate> SELECT_GUEST_BILL </option>\n" +
    "\t\t\t\t\t\t<option ng-repeat=\"item in data.guest_bill_template\" value=\"{{item.value}}\" ng-selected=\"item.value == data.selected_guest_bill_template\">{{item.name}}</option>\n" +
    "\t\t\t\t\t</select>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t<label for=\"hotel-logo\" translate> HOTEL_LOGO </label>\n" +
    "\t\t\t\t<div class=\"select\" >\n" +
    "\t\t\t\t\t<select ng-model=\"data.logo_type\" name=\"hotel-logo\" class=\"placeholder\">\n" +
    "\t\t\t\t\t\t<option value=\"\" translate> SELECT_LOGO_TYPE </option>\n" +
    "\t\t\t\t\t\t<option ng-repeat=\"item in data.hotel_logo\" value=\"{{item.value}}\" ng-selected=\"item.value == data.logo_type\">{{item.name}}</option>\n" +
    "\t\t\t\t\t</select>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t\n" +
    "\t\t\t<ad-toggle-button label=\"{{'SHOW_HOTEL_ADDRESS' | translate}}\" is-checked=\"data.show_hotel_address\"></ad-toggle-button>\n" +
    "\t\t\t\n" +
    "\t\t\t<div class=\"entry\"></div>\n" +
    "\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t<label translate>CUSTOM_TEXT</label>\n" +
    "\n" +
    "\t\t\t\t<ad-textarea rows=\"4\" div-class=\"full-width\" text-area-class=\"full-width\" value=\"data.custom_text_header\" label = \"{{'HEADER'| translate}} \" placeholder = \"{{'CUSTOM_TEXT_PLACEHOLDER' | translate }}\" ></ad-textarea>\n" +
    "\n" +
    "\t\t\t\t<ad-textarea rows=\"4\" div-class=\"full-width\" text-area-class=\"full-width\" value=\"data.custom_text_footer\" label = \"{{'FOOTER'| translate}} \" placeholder = \"{{'CUSTOM_TEXT_PLACEHOLDER' | translate }}\" ></ad-textarea>\n" +
    "\t\t\t\t\n" +
    "\t\t\t</div>\n" +
    "\t\t</fieldset>\n" +
    "\t\t<fieldset class=\"holder right\">\n" +
    "\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t<h3>\n" +
    "\t\t\t\t\t<span>{{'CUSTOMIZE' | translate}}</span>\n" +
    "\t\t\t\t\t{{'CONFIRMATION_COMMUNICATION' | translate}}\n" +
    "\t\t\t\t</h3>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t<label translate>GETTING_TO_THE_HOTEL</label>\n" +
    "\t\t\t\t<ad-textarea rows=\"4\" div-class=\"full-width\" text-area-class=\"full-width\" value=\"data.confirmation_template_text\"></ad-textarea>\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t<label translate>LOCATION_IMAGE</label>\n" +
    "\t\t\t\t<div class=\"file-upload with-preview\">\n" +
    "\t\t\t\t\t<span class=\"input\">{{location_image_file}}</span>\n" +
    "\t\t\t\t\t<a id=\"deleteLogo\" class=\"icons icon-delete large-icon delete_item\" ng-show=\"isLogoAvailable(data.location_image)\" ng-click = \"data.location_image = 'false'\"></a>\n" +
    "\t\t\t\t\t<input type=\"file\" ng-model=\"data.location_image\" accept=\"image/*\" app-filereader />\n" +
    "\t\t\t\t\t<button type=\"button\" class=\"button brand-colors\">\n" +
    "\t\t\t\t\t\tChoose file\n" +
    "\t\t\t\t\t</button>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t\t<span class=\"file-preview\"> <img ng-src=\"{{data.location_image}}\" alt=\"\" height=\"112\" width=\"auto\"> </span>\n" +
    "\t\t\t</div>\n" +
    "\n" +
    "\n" +
    "\t\t</fieldset>\n" +
    "\t\t<fieldset class=\"holder left\">\n" +
    "\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t<h3>\n" +
    "\t\t\t\t\t<span>{{'CANCELLATION' | translate}}</span>\n" +
    "\t\t\t\t\t{{'COMMUNICATIONS' | translate}}\n" +
    "\t\t\t\t</h3>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t<ad-textbox value=\"data.cancellation_communication_title\" label = \"{{'TITLE'| translate}}\" placeholder = \"{{'ENTER_TITLE'| translate}}\" ></ad-textbox>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t<ad-textarea rows=\"4\" div-class=\"full-width\" text-area-class=\"full-width\" value=\"data.cancellation_communication_text\" label = \"{{'CANCELLATION_TEXT'| translate}} \" placeholder = \"{{'CANCELLATION_TEXT_PLACEHOLDER' | translate }}\" ></ad-textarea>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t\n" +
    "\t\t\t\n" +
    "\t\t</fieldset>\n" +
    "\n" +
    "\t\t<div class=\"actions float\">\n" +
    "\t\t\t<button type=\"button\" ng-click =\"goBackToPreviousState()\" class=\"button blank\" translate>CANCEL\n" +
    "\t\t\t</button>\n" +
    "\t\t\t<button type=\"button\" ng-click=\"clickedSave()\" class=\"button green\" translate>SAVE_CHANGES\n" +
    "\t\t\t</button>\n" +
    "\t\t\t\n" +
    "\t\t</div>\n" +
    "\t</form>\n" +
    "\t</section>\n" +
    "</div>\n"
  );


  $templateCache.put('/assets/partials/templateConfiguration/adHotelConfigurationEdit.html',
    "<div style=\"display: block;border-bottom:none\" id=\"add-new\" class=\"edit-data\">\n" +
    "\t<div class=\"data-holder\">\n" +
    "\t\t<!-- Edit Brands -->\n" +
    "\t\t<form name=\"edit-brand\" method=\"post\" id=\"edit-brand-details\" data-brand-id=\"2\" class=\"form inline-form float\">\n" +
    "\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t<h3><span ng-show=\"isEditmode\"> Edit </span> {{formTitle}} </h3>\n" +
    "\t\t\t\t<em class=\"status\"> Fields marked with <strong>*</strong> are mandatory! </em>\n" +
    "\t\t\t</div>\n" +
    "\t\t\t<fieldset class=\"holder left float full-width\">\n" +
    "\t\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t\t<label for=\"hotel-chain\"> Hotel Theme  </label>\n" +
    "\t\t\t\t\t<div class=\"select\">\n" +
    "\t\t\t\t\t\t<select name=\"hotel-chain\" id=\"hotel-chain\" class=\"placeholder\" ng-model=\"hotelConfig.theme\" ng-change=\"displayThemeTemplates()\">\n" +
    "\t\t\t\t\t\t\t<option value=''>Hotel Theme</option>\n" +
    "\t\t\t\t\t\t\t<option value=\"{{theme.id}}\" ng-repeat=\"theme in hotelConfig.themes\" ng-selected=\"theme.id == hotelConfig.existing_email_template_theme\"> {{theme.name}} </option>\n" +
    "\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t\t<div id=\"room-features\" class=\"col2\">\n" +
    "\t\t\t\t\t\t<ad-checkbox ng-repeat=\"template in hotelConfig.email_templates\" ng-model=\"template.selected\" is-checked=\"template.selected\" label=\"{{template.title}}\" parent-label-class=\"room-likes\" span-class=\"checkbox-background\"></ad-checkbox>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</fieldset>\n" +
    "\t\t\t<div class=\"actions float\">\n" +
    "\t\t\t\t<button type=\"button\" id=\"cancel\" class=\"button blank edit-data-inline\" ng-click=\"cancelClicked()\">\n" +
    "\t\t\t\t\tCancel\n" +
    "\t\t\t\t</button>\n" +
    "\t\t\t\t<button type=\"button\" id=\"update\" class=\"button green edit-data-inline\" ng-click=\"updateTemplateConfiguration()\">\n" +
    "\t\t\t\t\tSave changes\n" +
    "\t\t\t\t</button>\n" +
    "\t\t\t</div>\n" +
    "\t\t</form>\n" +
    "\t</div>\n" +
    "</div>"
  );


  $templateCache.put('/assets/partials/templateConfiguration/adListHotel.html',
    "<section class=\"content current\" ng-click=\"clearErrorMessage()\">\n" +
    "\t<div data-view=\"HotelBrandsView\">\n" +
    "\t\t<header class=\"content-title float\">\n" +
    "\t\t\t<h2> {{'TEMPLATE_CONFIGURATION' | translate}} </h2>\n" +
    "\t\t\t<!-- <span class=\"count\">({{data.length}})</span> -->\n" +
    "\t\t\t\n" +
    "\t\t</header>\n" +
    "\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t<div id=\"new-form-holder\" ng-show=\"isAddmode\" ng-include=\"getTemplateUrl()\"></div>\n" +
    "\t\t\t<table class=\"grid\">\n" +
    "\t\t\t\t<tbody>\n" +
    "\t\t\t\t\t<tr ng-repeat=\"hotel in data\" > \n" +
    "\t\t\t\t\t\t<td ng-click=\"editHotelConfiguration($index,hotel.id)\" ng-hide=\"currentClickedElement == $index && isEditmode\" >\n" +
    "\t\t\t\t\t\t\t<a data-item=\"3\" data-colspan=\"2\" class=\"edit-data-inline\"> {{hotel.hotel_name}}</a>\n" +
    "\t\t\t\t\t\t</td>\t\t\t\t\t\n" +
    "\t\t\t\t\t\t<td ng-include=\"getTemplateUrl($index,hotel.id)\" ng-if=\"currentClickedElement == $index && isEditmode\"></td>\n" +
    "\t\t\t\t\t</tr>\n" +
    "\t\t\t\t</tbody>\n" +
    "\t\t\t</table>\n" +
    "\t\t</section>\n" +
    "\t</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/upsellLatecheckout/upsellLatecheckout.html',
    "<section id=\"replacing-div-first\" class=\"content current\" ng-click=\"clearErrorMessage()\">\n" +
    "\t<div data-view=\"UpsellLateCheckoutView\">\n" +
    "\t\t<section>\n" +
    "\t\t\t<header class=\"content-title float\">\n" +
    "\t\t\t\t<h2 translate>LATE_CHECKOUT_UPSELL</h2>\n" +
    "\t\t\t\t<a id=\"go_back\" data-type=\"load-details\" class=\"action back\" ng-click=\"goBackToPreviousState()\" translate>BACK</a>\n" +
    "\t\t\t</header>\n" +
    "\t\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t\t<div id=\"new-form-holder\" ng-show=\"isAddmode\" ng-include=\"getTemplateUrl()\"></div>\n" +
    "\t\t\t\t<form name=\"upsell-late-checkout\" method=\"post\" id=\"upsell-late-checkout\" class=\"form float\" action=\"\">\n" +
    "\t\t\t\t\t<div class=\"form-title full-width\">\n" +
    "\t\t\t\t\t\t<h3><span translate>LATE_CHECKOUT</span> {{'UPSELL' | translate}} </h3>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t<fieldset class=\"holder left\">\n" +
    "\t\t\t\t\t\t<div></div>\n" +
    "\n" +
    "\t\t\t\t\t\t<!-- Switch -->\n" +
    "\t\t\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t\t\t<label for=\"late-checkout-upsell\" translate>LATE_CHECKOUT_UPSELL</label>\n" +
    "\t\t\t\t\t\t\t<div id=\"div-late-checkout-upsell\" class=\"switch-button single\" ng-class=\"{ on : upsellData.is_late_checkout_set === 'true' }\"  ng-click=\"switchClicked()\">\n" +
    "\t\t\t\t\t\t\t\t<input type=\"checkbox\" value=\"10\" name=\"late-checkout-upsell\" id=\"late-checkout-upsell\">\n" +
    "\t\t\t\t\t\t\t\t<span class=\"switch-icon\"></span>\n" +
    "\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t\t<!-- Checkbox -->\n" +
    "\t\t\t\t\t\t<div class=\"entry radio-check\">\n" +
    "\t\t\t\t\t\t\t<label class=\"checkbox\"> <span class=\"icon-form icon-checkbox\" ng-class=\"{ checked : upsellData.is_exclude_guests === 'true' }\"></span> <label for=\"exclude-guest-pre-allocated-room\" translate>EXCULUDE_GUEST_IN_PRE_ALLOCATED_ROOMS</label>\n" +
    "\t\t\t\t\t\t\t\t<input type=\"checkbox\" value=\"testing\" name=\"exclude-guest-pre-allocated-room\" id=\"exclude-guest-pre-allocated-room\" ng-click=\"checkBoxClicked()\">\n" +
    "\t\t\t\t\t\t\t</label>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t<!-- charge code -->\n" +
    "\t\t\t\t\t\t<ad-dropdown label=\"{{'CHARGE_CODE' | translate}}\" label-in-drop-down=\"{{'CHARGE_CODE' | translate}}\" list=\"upsellData.charge_codes\" selected-Id='upsellData.selected_charge_code' required='yes' selbox-class='placeholder'></ad-dropdown>\n" +
    "\n" +
    "\t\t\t\t\t\t<!-- Hiding the field  according to CICO-9841 -->\n" +
    "\t\t\t\t\t\t<div class=\"entry\" ng-show=\"false\">\n" +
    "\t\t\t\t\t\t\t<label translate> SEND_UPSELL_ALERT_TO_ALL_GUESTS</label>\n" +
    "\t\t\t\t\t\t\t<div class=\"entry full-width float\">\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t<!-- alert hour -->\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t\t<select ng-options=\"hour for hour  in hours\" ng-model=\"upsellData.alert_hour\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<option style=\"display:none\" value=\"\" translate>HH</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t<!-- alert minute -->\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\t\t\t\t\t\t\t\t\t<select ng-options=\"minute for minute  in minutes\" ng-model=\"upsellData.alert_minute\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<option style=\"display:none\" value=\"\" translate>MM</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\t\t\t\t\t\t\t\t\t<select name=\"hotel-checkout-primetime\" disabled=\"disabled\" class=\"styled\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<option value=\"AM\" selected=\"\" translate>AM</option>\n" +
    "\t\t\t\t\t\t\t\t\t\t<option value=\"PM\" translate>PM</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t<ad-textbox value=\"upsellData.allowed_late_checkout\"   label = \"{{'NUMBER_OF_LATE_CHECKOUTS_PER_DAY' | translate}}\" placeholder = \"{{'TYPE_NUMBER' | translate}}\" ></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t\t</fieldset>\n" +
    "\t\t\t\t\t<fieldset class=\"holder right\">\n" +
    "\t\t\t\t\t\t<div></div>\n" +
    "\t\t\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t\t\t<label translate> CHECKOUT_TIME_EXTENDED_TO </label>\n" +
    "\t\t\t\t\t\t\t<div class=\"entry full-width float\">\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t\t<select ng-options=\"hour for hour  in hours\" ng-model=\"upsellData.extended_checkout_charge_0.time\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<option style=\"display:none\" value=\"\" translate>HH</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\t\t\t\t\t\t\t\t\t<select name=\"primetime\" disabled=\"disabled\" class=\"styled\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<option value=\"AM\" translate>AM</option>\n" +
    "\t\t\t\t\t\t\t\t\t\t<option value=\"PM\" selected=\"\" translate>PM</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t\t<ad-textbox value=\"upsellData.extended_checkout_charge_0.charge\"   label = \"{{'CHARGE' | translate}} [{{currency_code}}]\" placeholder = \"Enter charge\"  ></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t\t\t<label translate> CHECKOUT_TIME_EXTENDED_TO </label>\n" +
    "\t\t\t\t\t\t\t<div class=\"entry full-width float\">\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t\t<select ng-options=\"hour for hour  in hours\" ng-model=\"upsellData.extended_checkout_charge_1.time\" ng-disabled=\"disableSecondOption\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<option style=\"display:none\" value=\"\" translate>HH</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\t\t\t\t\t\t\t\t\t<select name=\"primetime\" disabled=\"disabled\" class=\"styled\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<option value=\"AM\" translate>AM</option>\n" +
    "\t\t\t\t\t\t\t\t\t\t<option value=\"PM\" selected=\"\" translate>PM</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t<ad-textbox value=\"upsellData.extended_checkout_charge_1.charge\"   label = \"{{'CHARGE' | translate}} [{{currency_code}}]\" placeholder = \"Enter charge\" disabled=\"disableSecondOption\" ></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t\t\t<label translate> CHECKOUT_TIME_EXTENDED_TO </label>\n" +
    "\t\t\t\t\t\t\t<div class=\"entry full-width float\">\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\t\t\t\t\t\t\t\t\t<select ng-options=\"hour for hour  in hours\" ng-model=\"upsellData.extended_checkout_charge_2.time\" ng-disabled=\"disableThirdOption\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<option style=\"display:none\" value=\"\" translate >HH</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t<div class=\"select select-col col1-3\">\n" +
    "\t\t\t\t\t\t\t\t\t<select name=\"primetime\" disabled=\"disabled\" class=\"styled\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<option value=\"AM\" translate>AM</option>\n" +
    "\t\t\t\t\t\t\t\t\t\t<option value=\"PM\" selected=\"\" translate>PM</option>\n" +
    "\t\t\t\t\t\t\t\t\t</select>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t\t<ad-textbox value=\"upsellData.extended_checkout_charge_2.charge\"   label = \"{{'CHARGE' | translate}} [{{currency_code}}]\" placeholder = \"Enter charge\" disabled=\"disableThirdOption\" ></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t\t</fieldset>\n" +
    "\n" +
    "\t\t\t\t\t<fieldset class='holder column full-width'>\n" +
    "\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t<ad-dropdown label=\"{{'LIMITED_LATE_CHECK_OUTS_BY_ROOM_TYPE' | translate}}\" label-in-drop-down=\"{{'SELECT_ROOM_TYPE' | translate}}\" list=\"upsellData.room_types_list\" selected-Id='upsellData.selected_room_type' selbox-class=\"placeholder\"></ad-dropdown>\n" +
    "\t\t\n" +
    "\t\t\t\t\t\t<div class='entry'>\n" +
    "\t\t\t\t\t\t\t<div class='add-room-type'>\n" +
    "\t\t\t\t\t\t\t\t<button class='button green' id='add-room-type' ng-click=\"clickAddRoomType()\" translate>\n" +
    "\t\t\t\t\t\t\t\t\tADD_ROOM_TYPE\n" +
    "\t\t\t\t\t\t\t\t</button>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t<div class='entry full-width' id='room-type-header'>\n" +
    "\t\t\t\t\t\t\t<div class='entry' ng-show=\"upsellData.isRoomTypesSelectedFlag\">\n" +
    "\t\t\t\t\t\t\t\t<label> <h4 translate>ROOM_TYPE</h4> </label>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t<div class='entry' ng-show=\"upsellData.isRoomTypesSelectedFlag\">\n" +
    "\t\t\t\t\t\t\t\t<label> <h4 translate>MAX_PER_DAY </h4> </label>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t<div id='room-type-details' ng-repeat=\"roomType in upsellData.room_types\">\n" +
    "\t\t\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t\t\t<div class=\"entry full-width room-type-details\" ng-show=\"roomType.max_late_checkouts !==''\">\n" +
    "\t\t\t\t\t\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<span class=\"align-text-center\"> {{roomType.name}} </span>\n" +
    "\t\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t\t<div class=\"entry\">\n" +
    "\t\t\t\t\t\t\t\t\t\t<span class=\"entry\">\n" +
    "\t\t\t\t\t\t\t\t\t\t\t<ad-textbox value=\"roomType.max_late_checkouts\" inputtype=\"number\"></ad-textbox>\n" +
    "\t\t\t\t\t\t\t\t\t\t</span>\n" +
    "\t\t\t\t\t\t\t\t\t\t<span class=\"entry\">\n" +
    "\t\t\t\t\t\t\t\t\t\t\t<a class=\"icons icon-delete large-icon align-text-center\" ng-click=\"deleteRoomType(roomType.id,roomType.name)\"></a>\n" +
    "\t\t\t\t\t\t\t\t\t\t</span>\n" +
    "\t\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t</fieldset>\n" +
    "\t\t\t\t\t\n" +
    "\t\t\t\t\t<div class=\"actions float\">\n" +
    "\t\t\t\t\t\t<button type=\"button\" id=\"cancel\" class=\"button blank\" ng-click=\"goBackToPreviousState()\" translate>\n" +
    "\t\t\t\t\t\t\tCANCEL\n" +
    "\t\t\t\t\t\t</button>\n" +
    "\t\t\t\t\t\t<button type=\"button\" id=\"save\" class=\"button green\" ng-click=\"saveClick()\" translate>\n" +
    "\t\t\t\t\t\t\tSAVE_CHANGES\n" +
    "\t\t\t\t\t\t</button>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t</form>\n" +
    "\t\t\t</section>\n" +
    "\t\t</section>\n" +
    "\t</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/users/adLinkExistingUser.html',
    "<section id=\"replacing-div-fourth\" class=\"content current\">\n" +
    "\t<div data-view=\"UserDetailsView\">\n" +
    "\t\t<header class=\"content-title float\">\n" +
    "\t\t\t<h2>Link Existing User</h2>\n" +
    "\t\t\t<a id=\"go_back\" data-type=\"load-details\" class=\"action back\" ui-sref=\"admin.users({id:hotelId})\">Back</a>\n" +
    "\t\t</header>\n" +
    "\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<form name=\"link-existing-user\" method=\"post\" id=\"add-user\" class=\"form float\">\n" +
    "\t\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t\t<fieldset class=\"holder left\">\n" +
    "\t\t\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t\t\t<h3><span>Find User</span></h3>\n" +
    "\t\t\t\t\t\t<em class=\"status\"> Fields marked with <strong>*</strong> are mandatory! </em>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t\t\t<label for=\"email\"> Email <strong>*</strong> </label>\n" +
    "\t\t\t\t\t\t<input type=\"text\" required=\"yes\" placeholder=\"Enter email address\" name=\"email\" ng-model=\"data.email\" autocomplete=\"off\">\n" +
    "\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t</fieldset>\n" +
    "\t\t\t\t<div class=\"actions float\">\n" +
    "\t\t\t\t\t<button type=\"button\" id=\"cancel\" class=\"button blank add-data-inline\" ui-sref=\"admin.users({id:hotelId})\">\n" +
    "\t\t\t\t\t\tCancel\n" +
    "\t\t\t\t\t</button>\n" +
    "\t\t\t\t\t<button type=\"button\" id=\"link_existing_user\" class=\"button green add-data-inline\" ng-click=\"linkExistingUser()\">\n" +
    "\t\t\t\t\t\tLink Existing User\n" +
    "\t\t\t\t\t</button>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</form>\n" +
    "\t\t</section>\n" +
    "\t</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/users/adUserDetails.html',
    "<section id=\"replacing-div-first\" class=\"content current \" ng-click=\"clearErrorMessage()\">\n" +
    "\t<div>\n" +
    "\t\t<header class=\"content-title float\">\n" +
    "\t\t\t<h2 ng-show=\"mod == 'edit'\">Edit User</h2>\n" +
    "\t\t\t<h2 ng-show=\"mod == 'add'\">Add New User</h2>\n" +
    "\t\t\t<a id=\"go_back\" data-type=\"load-details\" class=\"action back\" ui-sref='{{BackAction}}'>Back</a>\n" +
    "\t\t</header>\n" +
    "\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t<form user=\"2\" id=\"edit-user\" class=\"form float\">\n" +
    "\t\t\t\t<fieldset class=\"holder left\">\n" +
    "\t\t\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t\t\t<h3><span>User</span> details </h3>\n" +
    "\t\t\t\t\t\t<em class=\"status\"> Fields marked with <strong>*</strong> are mandatory! </em>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t<ad-textbox value=\"data.first_name\" name = \"first-name\" id = \"first-name\" label = \"First Name\" placeholder = \"Enter first name\" required = \"yes\" ></ad-textbox>\n" +
    "\t\t\t\t\t<ad-textbox value=\"data.last_name\" name = \"last-name\" id = \"last-name\" label = \"Last Name\" placeholder = \"Enter last name\" required = \"yes\" ></ad-textbox>\n" +
    "\t\t\t\t\t<ad-dropdown id=\"department\" selbox-class=\"placeholder\" label=\"Department\" div-class=\"full-width\" label-in-drop-down=\"Department\" list=\"data.departments\" selected-Id='data.user_department' >\n" +
    "\t\t\t\t\t</ad-dropdown>\n" +
    "\t\t\t\t\t<div></div>\n" +
    "\t\t\t\t\t<ad-textbox value=\"data.job_title\" name = \"job-title\" id = \"job-title\" label = \"Job title\" placeholder = \"Enter job title\" required = \"yes\" ></ad-textbox>\n" +
    "\t\t\t\t\t<ad-textbox value=\"data.phone\" name = \"phone\" id = \"phone\" label = \"Phone\" placeholder = \"Enter phone\" required = \"no\" ></ad-textbox>\n" +
    "\n" +
    "\n" +
    "\n" +
    "\t\t\t\t\t\n" +
    "\n" +
    "\n" +
    "\n" +
    "\t\t\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t\t\t<label for=\"user-picture\"> Picture </label>\n" +
    "\t\t\t\t\t\t<div class=\"file-upload with-preview\">\n" +
    "\t\t\t\t\t\t\t<span class=\"input\">{{fileName}}</span>\n" +
    "\t\t\t\t\t\t\t<input type=\"file\" ng-model=\"image\" accept=\"image/*\" app-filereader />\n" +
    "\t\t\t\t\t\t\t<button type=\"button\" class=\"button brand-colors\">\n" +
    "\t\t\t\t\t\t\t\t Choose file\n" +
    "\t\t\t\t\t\t\t</button> \n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t<span class=\"file-preview\"> <img ng-src=\"{{image}}\" id=\"file-preview\" alt=\"\"> </span>\n" +
    "\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t</fieldset>\n" +
    "\t\t\t\t<fieldset class=\"holder right\">\n" +
    "\t\t\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t\t\t<h3><span>User</span> credentials </h3>\n" +
    "\t\t\t\t\t\t<em class=\"status\"> <strong>All fields are mandatory!</strong> </em>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t<ad-textbox value=\"data.email\" name = \"email\" id = \"email\" label = \"Email\" placeholder = \"Enter email address\" required = \"yes\" styleclass=\"full-width\" ></ad-textbox>\n" +
    "\t\t\t\t\t<ad-textbox value=\"data.confirm_email\" name = \"re-email\" id = \"re-email\" label = \"Re-type email\" placeholder = \"Enter email address\" required = \"yes\" styleclass=\"full-width\" ></ad-textbox>\n" +
    "\n" +
    "\t\t\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t\t\t<label for=\"password\"> Password <strong>*</strong> </label>\n" +
    "\t\t\t\t\t\t<input type=\"password\" ng-model=\"data.password\" required=\"yes\" placeholder=\"Enter password\" name=\"password\" id=\"password\" autocomplete=\"off\" focus-me=\"focusOnPassword\">\n" +
    "\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t\t\t<label for=\"confirm-password\"> Re-type password <strong>*</strong> </label>\n" +
    "\t\t\t\t\t\t<input type=\"password\" ng-model=\"data.confirm_password\" required=\"yes\" placeholder=\"Confirm password\" name=\"re-password\" id=\"confirm-password\" autocomplete=\"off\">\n" +
    "\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t\t<!-- Activation Status -->\n" +
    "\t\t\t\t\t<div class=\"entry re-invite\" ng-show=\"mod == 'edit'\">\n" +
    "\t\t\t\t\t\t<label> Activation Status </label>\n" +
    "\t\t\t\t\t\t<div ng-show=\"data.is_activated == 'true'\">\n" +
    "\t\t\t\t\t\t\tACTIVATED\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t<div ng-show=\"data.is_activated == 'false'\">\n" +
    "\t\t\t\t\t\t\tPENDING\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t<div class=\"entry re-invite\" ng-show=\"mod == 'edit'\">\n" +
    "\t\t\t\t\t\t<label>\n" +
    "\t\t\t\t\t\t\t<button id=\"re-invite\" ng-click=\"sendInvitation(data.user_id)\" class=\"button\" ng-disabled=\"disableReInviteButton(data)\" ng-class=\"{'green': !disableReInviteButton(data), 'grey': disableReInviteButton(data)}\">\n" +
    "\t\t\t\t\t\t\t\tRe-Invite\n" +
    "\t\t\t\t\t\t\t</button> </label>\n" +
    "\t\t\t\t\t</div>\n" +
    "\n" +
    "\t\t\t\t</fieldset>\n" +
    "\n" +
    "\t\t\t\t<fieldset class=\"holder full-width\" ng-hide=\"isAdminSnt\">\n" +
    "\t\t\t\t\t<!-- Needs in future -->\n" +
    "\t\t\t\t\t<div class=\"form-title\">\n" +
    "\t\t\t\t\t\t<h3><span>User</span> roles </h3>\n" +
    "\t\t\t\t\t\t<em class=\"status\"> <span>User can have multiple roles</span> </em>\n" +
    "\t\t\t\t\t</div>\n" +
    "\n" +
    "\n" +
    "\n" +
    "\t\t\t\t\t<div class=\"entry has-sortable\">\n" +
    "\t\t\t\t\t\t<label>Assigned Roles</label>\n" +
    "\t\t\t\t\t\t<ul id=\"assigned-roles\" \n" +
    "\t\t\t\t\t\tdata-placeholder=\"Drop a role here to assign it to the user\"\n" +
    "\n" +
    "\t\t\t\t\t\tdata-jqyoui-options=\"{accept:'.unassigned-user-roles'}\"\n" +
    "\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\tclass=\"boxes sortable empty short-list\" data-drop=\"true\" \n" +
    "\t\t\t\t\t\tng-model='assignedRoles' \n" +
    "\n" +
    "\t\t\t\t\t\tjqyoui-droppable=\"{multiple:true, onOver: 'reachedAssignedRoles'}\" \n" +
    "\n" +
    "\t\t\t\t\t\tstyle=\"overflow-y: scroll !important;\" data-type=\"target\">\n" +
    "\n" +
    "\t\t\t\t\t\t\t<li ng-repeat=\"role in assignedRoles\" \n" +
    "\t\t\t\t\t\t\tclass=\"assigned-user-roles li-draggable\"\n" +
    "\n" +
    "\t\t\t\t\t\t\tdata-drag=\"true\" data-jqyoui-options=\"{revert: 'invalid', helper:'clone',appendTo: 'body'}\"\n" +
    "\t\t\t\t\t\t\tng-model=\"assignedRoles\" \n" +
    "\n" +
    "\t\t\t\t\t\t\tjqyoui-draggable=\"{index: {{$index}}, placeholder:false, animate:false, onStart:'hideCurrentDragItem', onStop:'showCurrentDragItem'}\" \n" +
    "\t\t\t\t\t\t\tng-hide=\"!role.name\" \n" +
    "\n" +
    "\t\t\t\t\t\t\tng-class=\"{selected: selectedAssignedRole == $index, justDropped: justDropped == $index}\" \n" +
    "\n" +
    "\t\t\t\t\t\t\tng-click=\"selectAssignedRole($event, $index)\">\n" +
    "\n" +
    "\t\t\t\t\t\t\t\t<span class=\"icons icon-handle\"></span>\n" +
    "\t\t\t\t\t\t\t\t<span class=\"icons icon-handle\"></span>\n" +
    "\t\t\t\t\t\t\t\t{{role.name}}\n" +
    "\t\t\t\t\t\t\t</li>\n" +
    "\t\t\t\t\t\t\t<span class=\"placeholder ui-state-disabled\"  ng-show=\"assignedRoles.length == 0\">Drop a role here to assign it to the user</span>\n" +
    "\t\t\t\t\t\t</ul>\n" +
    "\t\t\t\t\t</div>\n" +
    "\n" +
    "\n" +
    "\t\t\t\t\t<div class=\"entry movers\">\n" +
    "\t\t\t\t\t\t<span data-type=\"target\" class=\"icons icon-mover-right to-target\" ng-click=\"leftToRight()\" ng-class=\"{active: selectedAssignedRole!=-1}\">Assign role(s)</span>\n" +
    "\t\t\t\t\t\t<span data-type=\"source\" class=\"icons icon-mover-left to-source\" ng-click=\"rightToleft()\" ng-class=\"{active: selectedUnassignedRole!=-1}\">Unassign role(s)</span>\n" +
    "\t\t\t\t\t</div>\n" +
    "\n" +
    "\n" +
    "\n" +
    "\t\t\t\t\t<div class=\"entry has-sortable\" >\n" +
    "\t\t\t\t\t\t<label>Not Assigned Roles</label>\n" +
    "\t\t\t\t\t\t<ul data-placeholder=\"To remove a role for the user simply drop it here\" \n" +
    "\n" +
    "\t\t\t\t\t\tclass=\"boxes sortable short-list\"  style=\"overflow-y: scroll !important;\" \n" +
    "\t\t\t\t\t\tdata-drop=\"true\" ng-model='unAssignedRoles' \n" +
    "\n" +
    "\t\t\t\t\t\tdata-jqyoui-options=\"{accept:'.assigned-user-roles'}\"\n" +
    "\t\t\t\t\t\tjqyoui-droppable=\"{multiple:true, onOver: 'reachedUnAssignedRoles' }\" data-type=\"source\">\n" +
    "\t\t\t\t\t\t\n" +
    "\t\t\t\t\t\t\t<li ng-repeat=\"role in unAssignedRoles\" \n" +
    "\t\t\t\t\t\t\tclass=\"unassigned-user-roles li-draggable\"\n" +
    "\t\t\t\t\t\t\tdata-drag=\"true\" data-jqyoui-options=\"{revert: 'invalid', helper:'clone',appendTo: 'body'}\" \n" +
    "\n" +
    "\t\t\t\t\t\t\tng-model=\"unAssignedRoles\" \n" +
    "\n" +
    "\t\t\t\t\t\t\tjqyoui-draggable=\"{index: {{$index}}, placeholder:false,animate:false, onStart:'hideCurrentDragItem', onStop:'showCurrentDragItem'}\" \n" +
    "\n" +
    "\t\t\t\t\t\t\tng-hide=\"!role.name\" ng-class=\"{selected: selectedUnassignedRole == $index}\" \n" +
    "\n" +
    "\t\t\t\t\t\t\tng-click=\"selectUnAssignedRole($event, $index)\">\n" +
    "\t\t\t\t\t\t\t\t<span class=\"icons icon-handle\"></span>\n" +
    "\t\t\t\t\t\t\t\t<span class=\"icons icon-handle\"></span>\n" +
    "\t\t\t\t\t\t\t\t{{role.name}}\n" +
    "\t\t\t\t\t\t\t</li>\n" +
    "\t\t\t\t\t\t</ul>\n" +
    "\t\t\t\t\t</div> \n" +
    "\n" +
    "\t\t\t\t</fieldset>\n" +
    "\t\t\t\t<fieldset class=\"holder left\">\n" +
    "\t\t\t\t\t<div class=\"entry full-width\">\n" +
    "\t\t\t\t\t\t\t<label for=\"defaultdashboard\" >{{'DEFAULT_DASHBOARD'|translate}}<strong > * </strong></label>\n" +
    "\t\t                <div class=\"select\">\n" +
    "\t\t                    <select id=\"defaultdashboard\" ng-required=\"true\" class=\"placeholder\" ng-model = \"data.default_dashboard_id\" ng-options=\"dashboard.dashboard_id as dashboard.dashboard_name for dashboard in getMyDashboards()\" >\n" +
    "\t\t                      <option value=\"\" disabled translate>SELECT_DEFAULT_DASHBOARD</option>\n" +
    "\t\t                    </select>\n" +
    "\t\t                </div>\n" +
    "\t\t            </div>\n" +
    "\t\t\t\t</fieldset>\n" +
    "\t\t\t\t<div class=\"actions float\">\n" +
    "\t\t\t\t\t<button type=\"button\" id=\"cancel\" class=\"button blank add-data-inline\" ui-sref='admin.users'>\n" +
    "\t\t\t\t\t\tCancel\n" +
    "\t\t\t\t\t</button>\n" +
    "\t\t\t\t\t<button type=\"button\" id=\"save\" class=\"button green add-data-inline\" ng-click=\"saveUserDetails()\">\n" +
    "\t\t\t\t\t\tSave changes\n" +
    "\t\t\t\t\t</button>\n" +
    "\t\t\t\t</div>\n" +
    "\t\t\t</form>\n" +
    "\t\t</section>\n" +
    "\t</div>\n" +
    "</section>"
  );


  $templateCache.put('/assets/partials/users/adUserList.html',
    "<section id=\"replacing-div-first\" class=\"content current \">\n" +
    "\t<div id=\"users_list\" data-view=\"UsersListView\">\n" +
    "\t\t<!-- Hotels list -->\n" +
    "\t\t<section>\n" +
    "\t\t\t<header class=\"content-title float\">\n" +
    "\t\t\t\t<h2>Users</h2>\n" +
    "\t\t\t\t<span class=\"count\">({{data.users.length}})</span>\n" +
    "\t\t\t\t<a id=\"add_new_user\" class=\"action add\" ui-sref=\"admin.userdetails({ page: 'add', id: '', hotelId: hotelId })\">Add New</a>\n" +
    "\t\t\t\t<a id=\"find_existing_user\" class=\"action link\" ng-show=\"isAdminSnt\" ui-sref=\"admin.linkexisting({id:hotelId})\" >Link Existing</a>\n" +
    "\t\t\t\t<a id=\"go_back\" data-type=\"load-details\" class=\"action back\" ng-show=\"isAdminSnt\" ui-sref=\"admin.snthoteldetails({action:'edit',id:hotelId})\">Back</a>\n" +
    "\t\t\t</header>\n" +
    "\t\t\t<section class=\"content-scroll\">\n" +
    "\t\t\t<div ng-include=\"'/assets/partials/common/notification_message.html'\"></div>\n" +
    "\t\t\t<table id=\"users_list_table\" class=\"grid datatable table\" ng-table=\"tableParams\"\n" +
    "\t\t\ttemplate-pagination=\"nil\">\n" +
    "\t\t\t\t<tr ng-repeat=\"user in $data\">\n" +
    "\t\t\t\t\t<td data-title=\"'Name'\" sortable=\"'full_name'\"><a ui-sref=\"admin.userdetails({ page: 'edit', id: user.id, hotelId: hotelId, isUnlocking: false })\"  class=\"title\">{{user.full_name}} </a></td>\n" +
    "\t\t\t\t\t<td data-title=\"'Email'\" sortable=\"'email'\"> {{user.email}}  </td>\n" +
    "\t\t\t\t\t<td data-title=\"'Department'\" sortable=\"'department'\">{{user.department}}</td>\n" +
    "\t\t\t\t\t<td data-title=\"'Last Login'\" sortable=\"'last_login'\"><span class=\"login\">{{user.last_login_date | date : dateFormat}} {{user.last_login_time}}</span></td>\n" +
    "\t\t\t\t\t<td data-title=\"'Active'\" user=\"2\" id=\"activate-inactivate-button_2\" header-class=\"activate\"  class=\"activate activate-inactivate-button\">\n" +
    "\t\t\t\t\t\t<div class=\"entry\" ng-show=\"user.can_delete\">\n" +
    "\t\t\t\t\t\t\t<label for=\"\"></label>\n" +
    "\t\t\t\t\t\t\t<div class=\"switch-button single\" ng-class=\"{ on : user.is_active == 'true' }\" ng-click=\"activateInactivate(user.id, user.is_active, $index)\">\n" +
    "\t\t\t\t\t\t\t\t<input type=\"checkbox\" value=\"\" name=\"\" id=\"\">\n" +
    "\t\t\t\t\t\t\t\t<span class=\"switch-icon\"></span>\n" +
    "\t\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t\t</div>\n" +
    "\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t<td data-title=\"'Locked'\" class=\"delete\" header-class=\"delete\">\n" +
    "\t\t\t\t\t\t<button type=\"button\" ui-sref=\"admin.userdetails({ page: 'edit', id: user.id, hotelId: hotelId, isUnlocking: true})\" class=\"icons icon-lock\" ng-if=\"user.is_locked\">Locked</button>\n" +
    "\t\t\t\t\t</td>\n" +
    "\t\t\t\t\t<td data-title=\"'Delete'\" class=\"delete\" header-class=\"delete\">\n" +
    "\t\t\t\t\t\t<a id=\"165\" ng-show=\"user.can_delete\" class=\"icons icon-delete large-icon\" ng-click=\"deleteUser($index, user.id)\">Delete this user</a>\t\t\t\t\t\t\t\n" +
    "\t\t\t\t\t</td>\n" +
    "\t\t\t\t</tr>\n" +
    "\t\t\t</table>\n" +
    "\t\t</section>\n" +
    "\t\t</section>\n" +
    "\t</div>\n" +
    "</section>"
  );

}]);
