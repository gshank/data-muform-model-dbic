use strict;
use warnings;

use Test::More;
use lib 'dbt/lib';

use_ok( 'BookDB::Form::User');
use_ok( 'BookDB::Schema');
use_ok( 'BookDB::Form::BookWithOwner' );

my $schema = BookDB::Schema->connect('dbi:SQLite:dbt/db/book.db');
ok($schema, 'get db schema');

my $user = $schema->resultset('User')->find( 1 );

my $form;
my $options;

$form = BookDB::Form::User->new( model => $user );
ok( $form, 'User form created' );
$options = $form->field( 'country' )->options;
is( @$options, 16, 'Options loaded from the model' );

my $fif = $form->fif;
$fif->{country} = 'PL';
# update user with new country
$form->process( model => $user, params => $fif );
is( $form->model->country_iso, 'PL', 'country updated correctly');
$fif->{country} = 'US';  # change back
$form->process( model => $user, params => $fif );

$form = BookDB::Form::User->new( schema => $schema, model_class => 'User' );
ok( $form, 'User form created' );
$options = $form->field( 'country' )->options;
is( @$options, 16, 'Options loaded from the model - simple' );

$form = BookDB::Form::BookWithOwner->new( schema => $schema, model_class => 'Book' );
ok( $form, 'Book with Owner form created' );
$options = $form->field( 'owner' )->field(  'country' )->options;
is( @$options, 16, 'Options loaded from the model - recursive' );

my $book = $schema->resultset('Book')->find(1);
$form = BookDB::Form::BookWithOwner->new( model => $book );
ok( $form, 'Book with Owner form created' );
$options = $form->field( 'owner' )->field(  'country' )->options;
is( $form->field( 'owner' )->field(  'country' )->value, 'GB', 'Select value loaded in a related record');

done_testing;
