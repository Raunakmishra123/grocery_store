
<!DOCTYPE html>
<html>
<head>
<title>Grocery Store</title>
<body>
<?php
require 'dbcon.php';
require 'header.php';
?>
<?php
$msg = '';
if (isset($_POST['Name']) && isset($_POST['Mobile']) && isset($_POST['msg'])) {
    $n = $conn->real_escape_string($_POST['Name']);
    $m = $conn->real_escape_string($_POST['Mobile']);
    $p = $conn->real_escape_string($_POST['msg']);
    $sql = "INSERT INTO feedback (`name`, `mobile`, `msg`) VALUES ('$n', '$m' ,'$p')";

    if ($conn->query($sql)) {
        $msg = 'Feedback Saved';
    } else {
        $msg = 'Error: '.$conn->error;
    }
}
?>
		<div class="w3l_banner_nav_right">
<!-- mail -->
		<div class="mail">
			<h3>Mail Us</h3>
			<div class="agileinfo_mail_grids">
				<div class="col-md-4 agileinfo_mail_grid_left">
					<ul>
						<li><i class="fa fa-home" aria-hidden="true"></i></li>
						<li>address<span>BB MART LAW GATE ,PHAGWARA ,PUNJAB</span></li>
					</ul>
					<ul>
						<li><i class="fa fa-envelope" aria-hidden="true"></i></li>
						<li>email<span><a href="mailto:info@example.com">bbmartservices@gmail.com</a></span></li>
					</ul>
					<ul>
						<li><i class="fa fa-phone" aria-hidden="true"></i></li>
						<li>call to us<span>(+91) 9041222267</span></li>
					</ul>
				</div>
				<div class="col-md-8 agileinfo_mail_grid_right">
					<form action="" method="post">
                        <div><?php echo $msg; ?></div>
                        
						<div class="col-md-6 wthree_contact_left_grid">
							<input type="text" name="Name" value="Name*" onfocus="this.value = '';" onblur="if (this.value == '') {this.value = 'Name*';}" required="">
							
						</div>
						<div class="col-md-6 wthree_contact_left_grid">
							<input type="text" name="Mobile" value="Mobile" onfocus="this.value = '';" onblur="if (this.value == '') {this.value = 'Telephone*';}" required="">
                        </div>
						<div class="clearfix"> </div>
						<textarea  name="msg" onfocus="this.value = '';" onblur="if (this.value == '') {this.value = 'Message...';}" required>Message...</textarea>

                        <input type="submit"  name="submit" value="Submit">
						<input type="reset" value="Clear">
					</form>
				</div>
				<div class="clearfix"> </div>
			</div>
		</div>
<!-- //mail -->
		</div>
		<div class="clearfix"></div>
	</div>
<!-- //banner -->
<!-- map -->
	<div class="map">
		</div>
<!-- //map -->
<!-- newsletter -->
	<div class="newsletter">
		<div class="container">
			
			<div class="clearfix"> </div>
		</div>
	</div>
<?php include 'footer.php'?>
</body>
</html>
