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

    [$banners] = fn_get_banners(['item_ids' => $banner_id], DESCR_SL);

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
                $b_id = fn_banners_update_banner($_REQUEST['banner_data'], $child_banner['banner_id']);
                db_query("UPDATE ?:banners SET link_id = ?i WHERE banner_id = ?i", $link_id, $b_id);

                fn_banners_images_clone($banners, DESCR_SL, $child_banner['banner_id']);
            }
        } else {
            $_REQUEST['banner_data']['company_id'] = $storefront->storefront_id;
            $b_id = fn_banners_update_banner($_REQUEST['banner_data'], 0);
            db_query("UPDATE ?:banners SET link_id = ?i WHERE banner_id = ?i", $banner_id, $b_id);
            foreach (array_keys(fn_get_languages()) as $lang_code) {
                fn_banners_images_clone($banners, $lang_code, $b_id);
            }
        }
    }
}

function fn_banners_images_clone($banners, $lang_code, $child_banner_id)
{
    foreach ($banners as $banner) {
        if (empty($banner['main_pair']['pair_id'])) {
            continue;
        }

        $data_banner_image = [
            'banner_id' => $child_banner_id,
            'lang_code' => $lang_code
        ];

        $banner_image_id = db_query("REPLACE INTO ?:banner_images ?e", $data_banner_image);
        fn_add_image_link($banner_image_id, $banner['main_pair']['pair_id']);
    }
}