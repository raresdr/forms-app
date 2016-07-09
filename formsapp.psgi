use strict;
use warnings;

use FormsApp;

my $app = FormsApp->apply_default_middlewares(FormsApp->psgi_app);
$app;

