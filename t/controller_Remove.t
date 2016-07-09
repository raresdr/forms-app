use strict;
use warnings;
use Test::More;


use Catalyst::Test 'FormsApp';
use FormsApp::Controller::Remove;

ok( request('/remove')->is_success, 'Request should succeed' );
done_testing();
