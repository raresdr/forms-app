package FormsApp::Process;

use Moose;

has 'schema' => (
	is => 'ro',
	isa => 'DBIx::Class::Schema',
	required => 1
);

__PACKAGE__->meta()->make_immutable();

1;