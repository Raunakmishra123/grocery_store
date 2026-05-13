<?php
// Include your database connection file
include 'dbcon.php';

// Get the product ID from the URL
if (isset($_GET['pid']) && is_numeric($_GET['pid'])) {
    $product_id = $_GET['pid'];

    // Prepare a SQL query to fetch the main product details
    $sql = "SELECT p.pid, p.name, p.price, p.discount, p.weight, p.pic, p.cid, c.name AS category_name
            FROM product p
            JOIN category c ON p.cid = c.cid
            WHERE p.pid = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $product_id);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows == 1) {
        $product = $result->fetch_assoc();
        $category_id = $product['cid'];
        $category_name = $product['category_name'];

        // Calculate discounted price
        $discounted_price = $product['price'];
        if ($product['discount'] > 0) {
            $discount_amount = ($product['price'] * $product['discount']) / 100;
            $discounted_price = $product['price'] - $discount_amount;
        }

        // Prepare a SQL query to fetch recommended products from the same category (excluding the current product)
        $sql_recommended = "SELECT pid, name, pic, price, discount
                            FROM product
                            WHERE cid = ?
                            AND pid != ?
                            ORDER BY RAND()
                            LIMIT 4"; // Fetch up to 4 random products
        $stmt_recommended = $conn->prepare($sql_recommended);
        $stmt_recommended->bind_param("ii", $category_id, $product_id);
        $stmt_recommended->execute();
        $result_recommended = $stmt_recommended->get_result();
        $recommended_products = $result_recommended->fetch_all(MYSQLI_ASSOC);

        ?>
        <!DOCTYPE html>
        <html>
        <head>
        <title><?php echo htmlspecialchars(ucwords($product['name'])); ?> - Grocery Store</title>
        <link href="css/bootstrap.css" rel="stylesheet" type="text/css" media="all" />
        <link href="css/style.css" rel="stylesheet" type="text/css" media="all" />
        <link href="css/font-awesome.css" rel="stylesheet" type="text/css" media="all" />
        <link href="css/jquery.jqZoom.css" rel="stylesheet" type="text/css">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta name="keywords" content="Grocery Store Responsive web template, Bootstrap Web Templates, Flat Web Templates, Android Compatible web template,
        Smartphone Compatible web template, free webdesigns for Nokia, Samsung, LG, SonyEricsson, Motorola web design" />
        <script type="application/x-javascript"> addEventListener("load", function() { setTimeout(hideURLbar, 0); }, false);
                        function hideURLbar(){ window.scrollTo(0,1); } </script>
        <link href='//fonts.googleapis.com/css?family=Ubuntu:400,300,300italic,400italic,500,500italic,700,700italic' rel='stylesheet' type='text/css'>
        <link href='//fonts.googleapis.com/css?family=Open+Sans:400,300,300italic,400italic,600,600italic,700,700italic,800,800italic' rel='stylesheet' type='text/css'>
        <script type="text/javascript" src="js/jquery-1.11.1.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
        <script src="js/jquery.jqZoom.js" type="text/javascript"></script>
        <script type="text/javascript">
            $(document).ready(function() {
                $('.jqzoom').jqZoom({
                    zoomType: 'innerzoom',
                    preloadImages: false,
                    alwaysOn:false
                });
            });
        </script>
        <script type="text/javascript" src="js/move-top.js"></script>
        <script type="text/javascript" src="js/easing.js"></script>
        <script type="text/javascript">
            jQuery(document).ready(function($) {
                $(".scroll").click(function(event){
                    event.preventDefault();
                    $('html,body').animate({scrollTop:$(this.hash).offset().top},1000);
                });
            });
        </script>
        </head>
        <body>
            <?php include 'header.php'?>
            <div class="w3l_banner_nav_right">
                <div class="w3l_banner_nav_right_banner3">
                    <h3>Best Deals For New Products<span class="blink_me"></span></h3>
                </div>
                <div class="agileinfo_single">
                    <h5><?php echo htmlspecialchars(ucwords($product['name'])); ?> <?php if (!empty($product['weight'])): ?>(<?php echo htmlspecialchars($product['weight']); ?>)<?php endif; ?></h5>
                    <div class="col-md-4 agileinfo_single_left">
                        <img src="<?php echo htmlspecialchars($product['pic']); ?>" alt="<?php echo htmlspecialchars(ucwords($product['name'])); ?>" class="img-responsive jqzoom" data-jqzoom-image="<?php echo htmlspecialchars($product['pic']); ?>" id="jqzoomImg">
                        </div>
                    <div class="col-md-8 agileinfo_single_right">
                        <div class="rating1">
                            <span class="starRating">
                                <input id="rating5" type="radio" name="rating" value="5">
                                <label for="rating5">5</label>
                                <input id="rating4" type="radio" name="rating" value="4">
                                <label for="rating4">4</label>
                                <input id="rating3" type="radio" name="rating" value="3" checked>
                                <label for="rating3">3</label>
                                <input id="rating2" type="radio" name="rating" value="2">
                                <label for="rating2">2</label>
                                <input id="rating1" type="radio" name="rating" value="1">
                                <label for="rating1">1</label>
                            </span>
                        </div>
                        <div class="w3agile_description">
                            <h4>Description :</h4>
                            <p>No description available for this product at the moment.</p>
                            <?php if (!empty($product['weight'])): ?>
                                <p>Weight: <?php echo htmlspecialchars($product['weight']); ?></p>
                            <?php endif; ?>
                        </div>
                        <div class="snipcart-item block">
                            <div class="snipcart-thumb agileinfo_single_right_snipcart">
                                <h4>₹<?php echo htmlspecialchars(number_format($discounted_price, 2)); ?> <?php if ($product['discount'] > 0): ?><span>₹<?php echo htmlspecialchars(number_format($product['price'], 2)); ?></span><?php endif; ?></h4>
                            </div>
                            <div class="snipcart-details agileinfo_single_right_details">
                                <form action="#" method="post">
                                    <fieldset>
                                        <input type="hidden" name="cmd" value="_cart" />
                                        <input type="hidden" name="add" value="1" />
                                        <input type="hidden" name="business" value=" " />
                                        <input type="hidden" name="item_name" value="<?php echo htmlspecialchars(substr(ucwords($product['name']), 0, 20)); ?>" />
                                        <input type="hidden" name="amount" value="<?php echo htmlspecialchars(number_format($discounted_price, 2)); ?>" />
                                        <?php if ($product['discount'] > 0): ?>
                                            <input type="hidden" name="discount_amount" value="<?php echo htmlspecialchars(number_format($discount_amount, 2)); ?>" />
                                        <?php endif; ?>
                                        <input type="hidden" name="currency_code" value="INR" />
                                        <input type="hidden" name="return" value=" " />
                                        <input type="hidden" name="cancel_return" value=" " />
                                        <input type="submit" name="submit" value="Add to cart" class="button" />
                                    </fieldset>
                                </form>
                            </div>
                        </div>
                    </div>
                    <div class="clearfix"> </div>
                </div>
            </div>
            <div class="clearfix"></div>
        </div>
        <?php if (!empty($recommended_products)): ?>
        <div class="w3ls_w3l_banner_nav_right_grid w3ls_w3l_banner_nav_right_grid_popular">
            <div class="container">
                <h3>Recommended Products in <?php echo htmlspecialchars(ucwords($category_name)); ?></h3>
                <div class="w3ls_w3l_banner_nav_right_grid1">
                    <?php foreach ($recommended_products as $recommended_item):
                        $recommended_discounted_price = $recommended_item['price'];
                        if ($recommended_item['discount'] > 0) {
                            $recommended_discount_amount = ($recommended_item['price'] * $recommended_item['discount']) / 100;
                            $recommended_discounted_price = $recommended_item['price'] - $recommended_discount_amount;
                        }
                        ?>
                    <div class="col-md-3 w3ls_w3l_banner_left">
                        <div class="hover14 column">
                            <div class="agile_top_brand_left_grid w3l_agile_top_brand_left_grid">
                                <div class="agile_top_brand_left_grid_pos">
                                    <img src="images/offer.png" alt=" " class="img-responsive" />
                                </div>
                                <div class="agile_top_brand_left_grid1">
                                    <figure>
                                        <div class="snipcart-item block">
                                            <div class="snipcart-thumb">
                                                <a href="single.php?pid=<?php echo htmlspecialchars($recommended_item['pid']); ?>"><img src="<?php echo htmlspecialchars($recommended_item['pic']); ?>" alt="<?php echo htmlspecialchars(ucwords($recommended_item['name'])); ?>" class="img-responsive" /></a>
                                                <p><?php echo htmlspecialchars(substr(ucwords($recommended_item['name']), 0, 20)); ?>...</p>
                                                <h4>₹<?php echo htmlspecialchars(number_format($recommended_discounted_price, 2)); ?> <?php if ($recommended_item['discount'] > 0): ?><span>₹<?php echo htmlspecialchars(number_format($recommended_item['price'], 2)); ?></span><?php endif; ?></h4>
                                            </div>
                                            <div class="snipcart-details">
                                                <form action="#" method="post">
                                                    <fieldset>
                                                        <input type="hidden" name="cmd" value="_cart" />
                                                        <input type="hidden" name="add" value="1" />
                                                        <input type="hidden" name="business" value=" " />
                                                        <input type="hidden" name="item_name" value="<?php echo htmlspecialchars(substr(ucwords($recommended_item['name']), 0, 20)); ?>" />
                                                        <input type="hidden" name="amount" value="<?php echo htmlspecialchars(number_format($recommended_discounted_price, 2)); ?>" />
                                                        <?php if ($recommended_item['discount'] > 0): ?>
                                                            <input type="hidden" name="discount_amount" value="<?php echo htmlspecialchars(number_format(($recommended_item['price'] * $recommended_item['discount']) / 100, 2)); ?>" />
                                                        <?php endif; ?>
                                                        <input type="hidden" name="currency_code" value="INR" />
                                                        <input type="hidden" name="return" value=" " />
                                                        <input type="hidden" name="cancel_return" value=" " />
                                                        <input type="submit" name="submit" value="Add to cart" class="button" />
                                                    </fieldset>
                                                </form>
                                            </div>
                                        </div>
                                    </figure>
                                </div>
                            </div>
                        </div>
                    </div>
                    <?php endforeach; ?>
                    <div class="clearfix"> </div>
                </div>
            </div>
        </div>
        <?php endif; ?>
        <?php include 'footer.php'?>
        <script src="js/jquery.easing.min.js"></script>
        <script src="js/jquery.magnific-popup.js" type="text/javascript"></script>
        <link href="css/magnific-popup.css" rel="stylesheet" type="text/css">
        <script>
            $(document).ready(function() {
                $('.popup-with-zoom-anim').magnificPopup({
                    type: 'inline',
                    fixedContentPos: false,
                    fixedBgPos: true,
                    overflowBg: false,
                    closeBtnInside: true,
                    preloader: false,
                    midClick: true,
                    removalDelay: 300,
                    mainClass: 'my-mfp-zoom-in'
                });
            });
        </script>
        <script type="text/javascript">
                $(document).ready(function() {
                    /*
                        var defaults = {
                        containerID: 'toTop', // fading element id
                        containerHoverID: 'toTopHover', // fading element hover id
                        scrollSpeed: 1200,
                        easingType: 'linear'
                        };
                    */

                    $().UItoTop({ easingType: 'easeOutQuart' });

                    });
            </script>
        <script src="js/minicart.js"></script>
        <script>
            $(document).ready(function () {
                w3ls.minicart.init();
            });
        </script>
    </body>
    </html>
    <?php
        $stmt->close();
        if (isset($stmt_recommended)) {
            $stmt_recommended->close();
        }
    } else {
        // Handle the case where the product ID is not found
        echo "Product not found.";
    }
} else {
    // Handle the case where no product ID is provided or it's not numeric
    echo "Invalid product ID.";
}
$conn->close();
?>