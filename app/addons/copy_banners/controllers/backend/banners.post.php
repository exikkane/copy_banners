<?php

if ($mode === 'update' && !empty($_REQUEST['banner_data']['copy']) && !empty($_REQUEST['banner_id'])) {
    $storefront_repository = Tygh::$app['storefront.repository'];
    $storefronts = $storefront_repository->find();

    $banner_id = (int) $_REQUEST['banner_id'];
    $link_id = (int) ($_REQUEST['link_id'] ?? 0);

    if (!$link_id) {
        $link_id = $banner_id;
        db_query("UPDATE ?:banners SET link_id = ?i WHERE banner_id = ?i", $banner_id, $banner_id);
    }

    $child_banners = db_get_array(
        "SELECT banner_id, company_id FROM ?:banners WHERE link_id = ?i AND banner_id != ?i",
        $link_id,
        $banner_id
    );

    foreach (reset($storefronts) as $storefront) {
        if ($_REQUEST['banner_data']['company_id'] == $storefront->storefront_id) {
            continue;
        }

        if (!empty($child_banners)) {
            foreach ($child_banners as $child_banner) {
                if ($child_banner['banner_id'] == $_REQUEST['banner_id']) {
                    continue;
                }
                $_REQUEST['banner_data']['company_id'] = $child_banner['company_id'];
                $_REQUEST['banners_main_image_data'][0]['object_id'] = $child_banner['banner_id'];
                $_REQUEST['banners_main_image_data'][0]['pair_id'] = $_REQUEST['banners_main_image_data'][0]['pair_id'] + 1;
                $b_id = fn_banners_update_banner($_REQUEST['banner_data'], $child_banner['banner_id']);
                db_query("UPDATE ?:banners SET link_id = ?i WHERE banner_id = ?i", $link_id, $b_id);
            }
        } else {
            $_REQUEST['banner_data']['company_id'] = $storefront->storefront_id;
            $b_id = fn_banners_update_banner($_REQUEST['banner_data'], 0);
            db_query("UPDATE ?:banners SET link_id = ?i WHERE banner_id = ?i", $banner_id, $b_id);
        }
    }
}