package BookDB::Schema::Result::AuthorOld;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("author_old");
__PACKAGE__->add_columns(
  "last_name",
  { data_type => "VARCHAR", is_nullable => 0, size => 16 },
  "first_name",
  { data_type => "VARCHAR", is_nullable => 0, size => 16 },
  "country_iso",
  { data_type => "character", default_value => undef, is_nullable => 1, size => 2, },
  "birthdate",
  { data_type => "DATETIME", is_nullable => 0 },
  "foo" => {},
  "bar" => {},
);
__PACKAGE__->set_primary_key("first_name", "last_name");

__PACKAGE__->belongs_to(
  'country',
  'BookDB::Schema::Result::Country',
  { iso => 'country_iso' },
);

__PACKAGE__->add_unique_constraint(
  author_foo_bar => [qw(foo bar) ]
);
1;
