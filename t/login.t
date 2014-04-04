use Test::More;
use Test::Mojo;

# Include application
use FindBin;
require "$FindBin::Bin/../hello.pl";

my $t = Test::Mojo->new;

# Allow 302 redirect responses
$t->ua->max_redirects(1);

# Test if the HTML login form exists
$t->get_ok('/login')
  ->status_is(200)
  ->element_exists('form input[name="user"]')
  ->element_exists('form input[name="pass"]')
  ->element_exists('form input[type="submit"]');

# Test login with valid credentials
$t->post_ok('/login' => form => {user => 'sri', pass => 'secr3t'})
  ->status_is(200)->text_like('html body strong' => qr/You are now logged in!/);

# Test accessing a protected page
$t->get_ok('/')->status_is(200)->text_like('footer a' => qr/Logout/);

# Test if HTML login form shows up again after logout
$t->get_ok('/logout')
  ->status_is(200)
  ->text_like('html body strong' => qr/You are now logged out!/)
  ->element_exists('form input[name="user"]')
  ->element_exists('form input[name="pass"]')
  ->element_exists('form input[type="submit"]');

done_testing();
