{if $banner}
    {assign var="id" value=$banner.banner_id}
{else}
    {assign var="id" value=0}
{/if}


{** banners section **}

{$allow_save = $banner|fn_allow_save_object:"banners"}
{$hide_inputs = ""|fn_check_form_permissions}
{assign var="b_type" value=$banner.type|default:"G"}

{capture name="mainbox"}

    <form action="{""|fn_url}" method="post" class="form-horizontal form-edit{if !$allow_save || $hide_inputs} cm-hide-inputs{/if}" name="banners_form" enctype="multipart/form-data">
        <input type="hidden" class="cm-no-hide-input" name="fake" value="1" />
        <input type="hidden" class="cm-no-hide-input" name="banner_id" value="{$id}" />
        <input type="hidden" class="cm-no-hide-input" name="link_id" value="{$banner.link_id}" />

        {capture name="tabsbox"}

            <div id="content_general">
                {hook name="banners:general_content"}
                    <div class="control-group">
                        <label for="elm_banner_name" class="control-label cm-required">{__("name")}</label>
                        <div class="controls">
                            <input type="text" name="banner_data[banner]" id="elm_banner_name" value="{$banner.banner}" size="25" class="input-large" /></div>
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
                            <select name="banner_data[type]" id="elm_banner_type" onchange="Tygh.$('#banner_graphic').toggle();  Tygh.$('#banner_text').toggle(); Tygh.$('#banner_url').toggle();  Tygh.$('#banner_target').toggle();">
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


                    {include file="views/localizations/components/select.tpl" data_name="banner_data[localization]" data_from=$banner.localization}

                    {include file="common/select_status.tpl" input_name="banner_data[status]" id="elm_banner_status" obj_id=$id obj=$banner hidden=true}
                {/hook}
                <!--content_general--></div>

            <div id="content_addons" class="hidden clearfix">
                {hook name="banners:detailed_content"}
                {/hook}
                <!--content_addons--></div>

            {hook name="banners:tabs_content"}
            {/hook}

        {/capture}
        {include file="common/tabsbox.tpl" content=$smarty.capture.tabsbox active_tab=$smarty.request.selected_section track=true}

        {capture name="buttons"}
            {if !$id}
                {include file="buttons/save_cancel.tpl" but_role="submit-link" but_target_form="banners_form" but_name="dispatch[banners.update]"}
            {else}
                {if "ULTIMATE"|fn_allowed_for && !$allow_save}
                    {assign var="hide_first_button" value=true}
                    {assign var="hide_second_button" value=true}
                {/if}
                {include file="buttons/save_cancel.tpl" but_name="dispatch[banners.update]" but_role="submit-link" but_target_form="banners_form" hide_first_button=$hide_first_button hide_second_button=$hide_second_button save=$id}
            {/if}
        {/capture}

    </form>

{/capture}

{notes}
{hook name="banners:update_notes"}
{__("banner_details_notes", ["[layouts_href]" => fn_url('block_manager.manage')]) nofilter}
{/hook}
{/notes}

{include file="common/mainbox.tpl"
title=($id) ? $banner.banner : __("banners.new_banner")
content=$smarty.capture.mainbox
buttons=$smarty.capture.buttons
select_languages=true}

{** banner section **}
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const checkbox = document.getElementById('elm_copy');
        const container = document.getElementById('storefronts_container');

        checkbox.addEventListener('change', function() {
            if (this.checked) {
                container.style.display = 'block';
            } else {
                container.style.display = 'none';
            }
        });
    });
</script>
