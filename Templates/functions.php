<?php 

declare(strict_types=1);

namespace ThemeName;

defined('THEME_DEBUG') OR define('THEME_DEBUG', false);

add_action( 'init', '\ThemeName\disable_emojicons' );
add_action('wp_enqueue_scripts', '\ThemeName\dequeue_assets');
add_action('wp_enqueue_scripts', '\ThemeName\enqueue_assets');

remove_filter('the_content', '\ThemeName\wpautop'); 

// remove Open Sans font
add_action('wp_enqueue_scripts', 'deregister_styles', 100);

// Set the meta description for the main page
add_action('wp', '\ThemeName\home_check');

function dequeue_assets()
{
	wp_dequeue_style('classic-theme-styles');
	wp_dequeue_style('global-styles');

	// Remove Gutenberg Block Library CSS from loading on the frontend.
	wp_dequeue_style('wp-block-library');
	wp_dequeue_style('wp-block-library-theme');
}

function disable_emojicons_tinymce( $plugins )
{
	$result = [];

	if (is_array($plugins))
	{
		$result = array_diff($plugins, array('wpemoji'));
	}

	return $result;
}

function disable_emojicons()
{
	// all actions related to emojis
	remove_action('admin_print_styles', 'print_emoji_styles');
	remove_action('wp_head', 'print_emoji_detection_script', 7);
	remove_action('admin_print_scripts', 'print_emoji_detection_script');
	remove_action('wp_print_styles', 'print_emoji_styles');
	remove_filter('wp_mail', 'wp_staticize_emoji_for_email');
	remove_filter('the_content_feed', 'wp_staticize_emoji');
	remove_filter('comment_text_rss', 'wp_staticize_emoji');

	// filter to remove TinyMCE emojis
	add_filter( 'tiny_mce_plugins', 'disable_emojicons_tinymce' );
}

function enqueue_assets()
{
	enqueue_styles();
	enqueue_scripts();
}

function enqueue_scripts()
{
	$parent_path = get_template_directory_uri();
	$child_path = get_stylesheet_directory_uri();

	$js_path = $child_path . '/assets/js/';
}

function enqueue_styles()
{
	$parent_path = get_template_directory_uri();
	$child_path = get_stylesheet_directory_uri();

	$theme = wp_get_theme();
	$version = $theme->get('Version');

	$css_path = $child_path . '/assets/css/';

	if (THEME_DEBUG === true)
	{
	}
	else
	{
	}
}
