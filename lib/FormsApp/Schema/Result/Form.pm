use utf8;
package FormsApp::Schema::Result::Form;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

FormsApp::Schema::Result::Form

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

=head1 TABLE: C<forms>

=cut

__PACKAGE__->table("forms");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 title

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 desc

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 created

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: current_timestamp
  is_nullable: 0

=head2 updated

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "title",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "description",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "created",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => \"current_timestamp",
    is_nullable => 0,
    set_on_create => 1,
  },
  "updated",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
    set_on_create => 1,
    set_on_update => 1,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 form_fields

Type: has_many

Related object: L<FormsApp::Schema::Result::FormField>

=cut

__PACKAGE__->has_many(
  "form_fields",
  "FormsApp::Schema::Result::FormField",
  { "foreign.form_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 submissions

Type: has_many

Related object: L<FormsApp::Schema::Result::Submission>

=cut

__PACKAGE__->has_many(
  "submissions",
  "FormsApp::Schema::Result::Submission",
  { "foreign.form_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-07-03 17:27:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:f67DE+yZ9b9sVH1TQYnEew


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
