use utf8;
package FormsApp::Schema::Result::FormField;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

FormsApp::Schema::Result::FormField

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=item * L<DBIx::Class::TimeStamp>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp");

=head1 TABLE: C<form_fields>

=cut

__PACKAGE__->table("form_fields");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 form_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 field_type_id

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 question

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "form_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "field_type_id",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "question",
  { data_type => "varchar", is_nullable => 0, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 answers

Type: has_many

Related object: L<FormsApp::Schema::Result::Answer>

=cut

__PACKAGE__->has_many(
  "answers",
  "FormsApp::Schema::Result::Answer",
  { "foreign.field_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 field_options

Type: has_many

Related object: L<FormsApp::Schema::Result::FieldOption>

=cut

__PACKAGE__->has_many(
  "field_options",
  "FormsApp::Schema::Result::FieldOption",
  { "foreign.field_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 field_type

Type: belongs_to

Related object: L<FormsApp::Schema::Result::FieldType>

=cut

__PACKAGE__->belongs_to(
  "field_type",
  "FormsApp::Schema::Result::FieldType",
  { id => "field_type_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 form

Type: belongs_to

Related object: L<FormsApp::Schema::Result::Form>

=cut

__PACKAGE__->belongs_to(
  "form",
  "FormsApp::Schema::Result::Form",
  { id => "form_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-07-03 17:27:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3ZGDQOd+JNL5nMjDU8HdpQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
