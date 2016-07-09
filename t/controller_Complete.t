use strict;
use warnings;
use Test::More;


use Catalyst::Test 'FormsApp';
use FormsApp::Controller::Complete;

ok( request('/complete')->is_success, 'Request should succeed' );
done_testing();
