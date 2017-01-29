use strict;
use warnings;
use Test::More;

use lib 'dbt/lib';
use BookDB::Schema;
use_ok('BookDB::Form::Author');
my $schema = BookDB::Schema->connect('dbi:SQLite:dbt/db/book.db');
ok($schema, 'get db schema');
my $author = $schema->resultset('Author')->find(1);

my $form = BookDB::Form::Author->new;

ok( $form, 'form built' );

$form->process( model => $author, params => {});

is($form->field('books.0.genres')->num_options, 6, 'got right number of genre options' );

is($form->field('books.0.format')->num_options, 6, 'got right number of format options');

my $fif = $form->fif;

done_testing;
