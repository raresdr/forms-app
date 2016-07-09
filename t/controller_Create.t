use strict;
use warnings;
use Test::More;


use Catalyst::Test 'FormsApp';
use FormsApp::Controller::Create;

ok( request('/create')->is_success, 'Request should succeed' );
done_testing();
