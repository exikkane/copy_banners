{if $banner.type == $smarty.const.ABT__UT2_BANNER_TYPE or $smarty.request.type == $smarty.const.ABT__UT2_BANNER_TYPE}
<input type="hidden" class="" name="selected_section" id="selected_section">
{if $banner.banner_image_id}
<input type="hidden" class="" name="banner_data[banner_image_id]" value="{$banner.banner_image_id}">
{/if}
{hook name="banners:general_content"}
<div class="control-group">
<label for="elm_banner_name" class="control-label cm-required">{__("name")}</label>
<div class="controls">
<input type="text" name="banner_data[banner]" id="elm_banner_name" value="{$banner.banner}" size="25" class="input-large" /></div>
</div>
<div class="control-group">
<label for="elm_banner_type" class="control-label">{__("abt__ut2.banner.banner_group")}</label>
<div class="controls">
<select name="banner_data[group_id]" id="elm_banner_group_id">
<option value="0">--</option>
{foreach fn_abt__ut2_get_banner_groups_list() as $group_id => $group_name}
<option {if $banner.group_id == $group_id}selected="selected"{/if} value="{$group_id}">{$group_name}</option>
{/foreach}
</select>
</div>
</div>
{if "ULTIMATE"|fn_allowed_for}
{include file="views/companies/components/company_field.tpl"
name="banner_data[company_id]"
id="banner_data_company_id"
selected=$banner.company_id
}
{/if}
<div class="control-group">
<label for="elm_banner_type" class="control-label cm-required">{__("type")}</label>
<div class="controls">
<select name="banner_data[type]" id="elm_banner_type">
<option {if $banner.type == $smarty.const.ABT__UT2_BANNER_TYPE}selected="selected"{/if} value="{$smarty.const.ABT__UT2_BANNER_TYPE}">{__("banner_type.`$smarty.const.ABT__UT2_BANNER_TYPE`")}</option>
</select>
</div>
</div>
{include file="addons/abt__unitheme2/views/banners/components/abt__ut2_fields.tpl"}
<hr/>
{foreach ['tablet', 'mobile'] as $device}
{$field="`$device`_use"}{$elm="abt__ut2_`$field`"}
<div class="control-group{if $disabled} hidden{/if}">
<label for="elm_banner_{$elm}" class="control-label">{__("abt__ut2.banner.params.{$field}")}{include file="common/tooltip.tpl" tooltip=__("abt__ut2.banner.params.{$field}.tooltip")}</label>
<div class="controls">
<input type="hidden" name="banner_data[{$elm}]" value="N"/>
<input type="checkbox" name="banner_data[{$elm}]" id="elm_banner_{$elm}" value="Y" {if $banner.$elm == "YesNo::YES"|enum}checked="checked"{/if}/>
</div>
</div>
{/foreach}
<hr/>
<div class="control-group">
<label class="control-label" for="elm_banner_timestamp_{$id}">{__("creation_date")}</label>
<div class="controls">
{include file="common/calendar.tpl" date_id="elm_banner_timestamp_`$id`" date_name="banner_data[timestamp]" date_val=$banner.timestamp|default:$smarty.const.TIME start_year=$settings.Company.company_start_year}
</div>
</div>
{include file="views/localizations/components/select.tpl" data_name="banner_data[localization]" data_from=$banner.localization}
{include file="common/select_status.tpl" input_name="banner_data[status]" id="elm_banner_status" obj_id=$id obj=$banner hidden=true}
{/hook}
{else}
{hook name="banners:general_content"}
<div class="control-group">
<label for="elm_banner_name" class="control-label cm-required">{__("name")}</label>
<div class="controls">
<input type="text" name="banner_data[banner]" id="elm_banner_name" value="{$banner.banner}" size="25" class="input-large" /></div>
</div>
<div class="control-group">
<label for="elm_banner_type" class="control-label">{__("abt__ut2.banner.banner_group")}</label>
<div class="controls">
<select name="banner_data[group_id]" id="elm_banner_group_id">
<option value="0">--</option>
{foreach fn_abt__ut2_get_banner_groups_list() as $group_id => $group_name}
<option {if $banner.group_id == $group_id}selected="selected"{/if} value="{$group_id}">{$group_name}</option>
{/foreach}
</select>
</div>
</div>
{if "ULTIMATE"|fn_allowed_for}
{include file="views/companies/components/company_field.tpl"
name="banner_data[company_id]"
id="banner_data_company_id"
selected=$banner.company_id
}
{/if}
<div class="control-group">
<label for="elm_banner_type" class="control-label cm-required">{__("type")}</label>
<div class="controls">
<select name="banner_data[type]" id="elm_banner_type" onchange="Tygh.$('#banner_graphic').toggle(); Tygh.$('#banner_text').toggle(); Tygh.$('#banner_url').toggle(); Tygh.$('#banner_target').toggle();">
<option {if $banner.type == "G"}selected="selected"{/if} value="G">{__("graphic_banner")}</option>
<option {if $banner.type == "T"}selected="selected"{/if} value="T">{__("text_banner")}</option>
</select>
</div>
</div>
<div class="control-group {if $b_type != "G"}hidden{/if}" id="banner_graphic">
<label class="control-label">{__("image")}</label>
<div class="controls">
{include file="common/attach_images.tpl"
image_name="banners_main"
image_object_type="promo"
image_pair=$banner.main_pair
image_object_id=$id
no_detailed=true
hide_titles=true
}
</div>
</div>
<div class="control-group {if $b_type == "G"}hidden{/if}" id="banner_text">
<label class="control-label" for="elm_banner_description">{__("description")}:</label>
<div class="controls">
<textarea id="elm_banner_description" name="banner_data[description]" cols="35" rows="8" class="cm-wysiwyg input-large">{$banner.description}</textarea>
</div>
</div>
<div class="control-group {if $b_type == "T"}hidden{/if}" id="banner_target">
<label class="control-label" for="elm_banner_target">{__("open_in_new_window")}</label>
<div class="controls">
<input type="hidden" name="banner_data[target]" value="T" />
<input type="checkbox" name="banner_data[target]" id="elm_banner_target" value="B" {if $banner.target == "B"}checked="checked"{/if} />
</div>
</div>
<div class="control-group {if $b_type == "T"}hidden{/if}" id="banner_url">
<label class="control-label" for="elm_banner_url">{__("url")}:</label>
<div class="controls">
<input type="text" name="banner_data[url]" id="elm_banner_url" value="{$banner.url}" size="25" class="input-large" />
</div>
</div>
<div class="control-group">
<label class="control-label" for="elm_banner_timestamp_{$id}">{__("creation_date")}</label>
<div class="controls">
{include file="common/calendar.tpl" date_id="elm_banner_timestamp_`$id`" date_name="banner_data[timestamp]" date_val=$banner.timestamp|default:$smarty.const.TIME start_year=$settings.Company.company_start_year}
</div>
</div>
{include file="views/localizations/components/select.tpl" data_name="banner_data[localization]" data_from=$banner.localization}
{include file="common/select_status.tpl" input_name="banner_data[status]" id="elm_banner_status" obj_id=$id obj=$banner hidden=true}
{/hook}
<!--content_general--></div>
<div id="content_addons" class="hidden clearfix">
{hook name="banners:detailed_content"}
{/hook}
{/if}
{if $id}

<div class="control-group" id="banner_copy">
    <label class="control-label" for="elm_copy">Копировать на другие витрины</label>
    <div class="controls">
        <input type="checkbox" name="banner_data[copy]" id="elm_copy" value="1"/>
    </div>
</div>

<div id="storefronts_container" style="display: none;">
    <input type="hidden"
           name="banner_data[storefronts_banners]"
           value=""
    />

    {include file="common/double_selectboxes.tpl"
    title=__("storefronts")
    first_name="banner_data[storefronts_banners]"
    second_name="all_countries"
    second_data=$storefronts_data
    }
</div>

{/if}