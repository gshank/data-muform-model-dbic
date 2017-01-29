use Test::More;
use lib 'dbt/lib';

use_ok('HTML::FormHandler::Model::DBIC');

use BookDB::Schema;

my $schema = BookDB::Schema->connect('dbi:SQLite:dbt/db/book.db');

{
   package My::Form;
   use Moo;
   use Data::MuForm::Meta;
   extends 'Data::MuForm::Model::DBIC';

   has '+model_class' => ( default => 'Book' );
   has_field 'title' => ( type => 'Text', required => 1 );
   has_field 'author' => ( type => 'Text' );
   has_field 'publisher' => ( no_update => 1 );
#  sub init_value_author
#  {
#     'Pick a Better Author'
#  }
}

my $init_object = {
    'title' => 'Fill in the title',
    'author' => 'Enter an Author',
    'publisher' => 'something',
};

my $form = My::Form->new( init_object => $init_object, schema => $schema );

ok( $form, 'get form');

my $title_field = $form->field('title');
is( $title_field->value, 'Fill in the title', 'get title from init_object');

my $author_field = $form->field('author');
is( $author_field->value, 'Enter an Author', 'get init value from init_value_author' );

is( $form->field('publisher')->fif, 'something', 'no_update fif from init_obj' );
$form->processed(0); # to unset processed flag caused by fif

my $params = {
    'title' => 'We Love to Test Perl Form Processors',
    'author' => 'B.B. Better',
    'publisher' => 'anything',
};

ok( $form->process( $params ), 'validate data' );
ok( $form->field('title')->value ne $form->field('title')->init_value, 'init_value ne value');
is( $form->field('publisher')->value, 'anything', 'value for no_update field' );
is( $form->field('author')->value, 'B.B. Better', 'right value for author' );
my $values = $form->value;
ok( !exists $values->{publisher}, 'no publisher in values' );

ok( $form->update_model, 'update validated data');

my $book = $form->model;
is( $book->title, 'We Love to Test Perl Form Processors', 'title updated');
is( $book->publisher, undef, 'no publisher' );

$book->delete;

done_testing;
