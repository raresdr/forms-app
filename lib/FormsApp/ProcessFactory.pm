package FormsApp::ProcessFactory;

use MooseX::AbstractFactory;

implementation_class_via sub {
	return sprintf( 'FormsApp::Processes::%s', ucfirst(shift) );
};

1;