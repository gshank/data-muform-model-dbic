package BookDB::Form::BookM2M;
use Moo;
use Data::MuForm::Meta;
extends 'Data::MuForm::Model::DBIC';

=head1 NAME

Form object for the Book Controller

=head1 SYNOPSIS

Form used for book/add and book/edit actions

=head1 DESCRIPTION

Catalyst Form.

=cut

has '+model_class' => ( default => 'Book' );

sub field_list {
    [
        title => {
            type             => 'Text',
            required         => 1,
            required_message => 'A book must have a title.',
            label            => 'Title',
            order            => '1',
        },
        author => {
            type  => 'Text',
            label => 'Author:',
            order => '2',
        },

        # has_many relationship pointing to mapping table
        genres => {
            type         => 'Multiple',
            label        => 'Genres:',
            label_column => 'name',
            order        => '3',
        },
        isbn => {
            type   => 'Text',
            label  => 'ISBN:',
            order  => '5',
            unique => 1,
        },
        publisher => {
            type  => 'Text',
            label => 'Publisher:',
            order => '4',
        },
        format => {
            type  => 'Select',
            label => 'Format:',
            order => '6',
        },
        year => {
            type        => 'Integer',
            range_start => '1900',
            range_end   => '2020',
            label       => 'Year:',
            order       => '7',
        },
        pages => {
            type  => 'Integer',
            label => 'Pages:',
            order => '8',
        },
        comment => {
            type  => 'Text',
            order => 9,
        },
    ];
}

sub validate_year {
    my ( $self, $field ) = @_;
    $field->add_error('Invalid year')
      if ( ( $field->value > 3000 ) || ( $field->value < 1600 ) );
}

=head1 AUTHOR

Gerda Shank

=head1 LICENSE AND COPYRIGHT

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=cut

1;
