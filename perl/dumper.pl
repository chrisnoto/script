use Data::Dumper;
my %HoH = (
Jacinta => {
age => 26,
favourite_colour => "blue",
sport => "swimming",
language => "Perl",
},
Paul => {
age => 27,
favourite_colour => "green",
sport => "cycling",
language => "Perl",
},
);
print Dumper \%HoH;