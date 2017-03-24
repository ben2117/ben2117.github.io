---
layout: post
title:  "wordpress: custom post types, taxonomies and making wordpress do stuff it wasnt really designed for"
date:   2017-03-24 11:18:44 +1100
categories: php wordpress
---
lets say we want to create an online shop in worpress, we would first create a custom post type that would hold our items we want to sell

{% highlight php %}
function item_custom_post_type() {

  $labels = array(
    'name'                => _x( 'Item' ),
    'singular_name'       => _x( 'Item' ),
    'menu_name'           => __( 'Item' ),
    'parent_item_colon'   => __( 'Parent Item' ),
    'all_items'           => __( 'All Items' ),
    'view_item'           => __( 'View Items'),
    'add_new_item'        => __( 'Add New Item' ),
    'add_new'             => __( 'Add New' ),
    'edit_item'           => __( 'Edit Item' ),
    'update_item'         => __( 'Update Item' ),
    'search_items'        => __( 'Search Items'),
    'not_found'           => __( 'Not Found'),
    'not_found_in_trash'  => __( 'Not found in Trash' ),
  );
  
  $supports = array( 
    'title', 
    'editor', 
    'excerpt', 
    'author', 
    'thumbnail', 
    'comments', 
    'revisions', 
    'custom-fields' );

  $args = array(
    'label'               => __( 'items' ),
    'description'         => __( 'items' ),
    'labels'              => $labels,
    'supports'            => $supports,
    'hierarchical'        => true,
    'public'              => true,
    'show_ui'             => true,
    'show_in_menu'        => true,
    'show_in_nav_menus'   => true,
    'show_in_admin_bar'   => true,
    'menu_position'       => 5,
    'can_export'          => true,
    'has_archive'         => true,
    'exclude_from_search' => false,
    'publicly_queryable'  => true,
    'capability_type'     => 'page',
  );
  
  register_post_type( 'items', $args );

}

add_action( 'init', 'item_custom_post_type', 0 );
{% endhighlight %}

then we can create a taxonomy for each category we might be selling, below is an example for a books taxonomy

{% highlight php %}
function create_book_taxonomy() {
  $labels = array(
      'name' => _x( 'Books', 'taxonomy general name' ),
      'singular_name' => _x( 'Book', 'taxonomy singular name' ),
      'search_items' =>  __( 'Search Books' ),
      'all_items' => __( 'All Books' ),
      'parent_item' => __( 'Parent Book' ),
      'parent_item_colon' => __( 'Parent Book:' ),
      'edit_item' => __( 'Edit Book' ), 
      'update_item' => __( 'Update Book' ),
      'add_new_item' => __( 'Add New Book' ),
      'new_item_name' => __( 'New Book Name' ),
      'menu_name' => __( 'Books' ),
    );


    $args = array(
      'hierarchical' => true,
      'labels' => $labels,
      'show_ui' => true,
      'show_admin_column' => true,
      'query_var' => true,
      'rewrite' => array( 'slug' => 'book' ),
    );
    
    //note here we register it to the items custome post type
    register_taxonomy('books', 'items', $args);
}

add_action( 'init', 'create_book_taxonomy', 0 );

{% endhighlight %}

now in the wordpress console we create a couple of book taxonomies for such as cooking, sci-fi and history. we then create a couple of items and assign them to the varias book taxonomy. When we are in the book page we can get the book items and their taxonomy with a wordpress query

{% highlight php %}
$bookCategories = get_terms( array(
    'taxonomy' => 'books',
    'hide_empty' => false
  ));

function get_items_posts($bookTax){
  $returnPost = get_posts(array(
    'showposts' => -1,
    'post_type' => 'items',
    'tax_query' => array(
      array(
      'taxonomy' => 'books',
      'field' => 'name',
      'terms' => array($bookTax))
    )
  ));
  return $returnPost;
}

foreach ($bookCategories as $bookcat){
  echo $bookcat->name;
  $book_shop_items = get_items_posts($bookcat->name);
  foreach ($book_shop_items as $book_item) {
    echo $book_item->post_title; 
    echo $book_item->post_content; 
    echo $book_item->price;
  }
}
{% endhighlight %}

now we have access to all the books from each category of the books taxonomy