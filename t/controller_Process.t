use strict;
use warnings;
use Test::More;


use Catalyst::Test 'FormsApp';
use FormsApp::Controller::Process;

ok( request('/process')->is_success, 'Request should succeed' );
done_testing();
