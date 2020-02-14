#!/usr/bin/perl

use strict ;
use warnings ;

use constant {
    _TS_CFG_OUTDIR       => "<OUTPUT_FILE_DIRECTORY>",
    _TS_CFG_OUTFILE      => "Restockplus_Tweakscale.cfg",

    _RESTOCKPLUS_PART_PATH => "<PATH_TO_GAMEDATA>/Restockplus/Parts",
    _RESTOCKRIGIDLEGS_PART_PATH => "<PATH_TO_GAMEDATA>/RestockRigidLegs/Parts",


    _TS_CFG_NONE          => "TS_none.cfg",
    _TS_CFG_BEHAVIOR      => "TS_Behavior.cfg",
    _TS_CFG_SCALE         => "TS_Scale.cfg",
    _TS_CFG_SCALEBEHAVIOR => "TS_ScaleBehavior.cfg",
} ;

my @parts ;

#restock- decoupler        -1875     -1
#restock- fueltank-adapter -1875-0625-1
#restock  item             part_size1[-part_size2] [-part_variant]

#restock-(.*)-(\d+)-(\d+)-(\d+) part_size1 part_size2 part_variant
#restock-(.*)-(\d+)-(\d+) part_size1 part_variant
#restock-(.*)-(\d+) part_variant

my %sizes = (
# in meters 
    "-1"   => "-1",
    "0625" => "0.625",
    "625"  => "0.625",
    "125"  => "1.25",
    "1875" => "1.875",
    "25"   => "2.5",
    "375"  => "3.75",
    "50"   => "5",
) ;

# parts with radial -> free
# parts with size -> stack
# anything not matching -> free

my @preferred_scale_method = (
    {radial        => "free"},
    {reactionwheel => "stack"},
    {heatshield    => "stack_square"},
    {servicebay    => "stack"},
    {decoupler     => "stack"},
    {separator     => "free"},
    {nosecone      => "stack_square"},
    {cockpit       => "stack_square"},
    {service       => "stack"},
    # docking     => "this is a bad idea",
    {battery       => "stack"},
    # fairing     => "issues with tweakcale",
    {adapter       => "stack"},
    {antenna       => "free_square"},
    {inline        => "stack"},
    {engine        => "stack"},
    {relay         => "free_square"},
    {claw          => "free"},
    {tank          => "stack"},
    {drone         => "stack"},
    {solar         => "free_square"},
    {truss         => "free"},
    {cabin         => "stack_square"},
    {wing          => "free_square"},
    {rcs           => "free"},
    {pod           => "stack_square"},
    {srb           => "stack"},
    {leg           => "free"},
) ;

# Possible behaviors
# Science, SRB, Engine, Decoupler

my %behaviors = (
    science   => "Science",
    srb       => "SRB",
    engine    => "Engine",
    decoupler => "Decoupler",
) ;

sub getCFGFile
# Config file for Tweakscale sizing rules to be followed
{
    my $file = shift ;

    open (my $fh, "./" . $file) or die "Cannot open config file $file" ;
    my @content = <$fh> ;
    my $s = join ("", @content) ;
    close $fh ; 

    return $s ;
} # getCFGFile()

my $string_part_config_behavior_scale = getCFGFile(_TS_CFG_SCALEBEHAVIOR) ;
my $string_part_config_behavior       = getCFGFile(_TS_CFG_BEHAVIOR) ;
my $string_part_config_scale          = getCFGFile(_TS_CFG_SCALE) ;
my $string_part_config                = getCFGFile(_TS_CFG_NONE) ; ;

#   defaultScale = 1.875 meters 

#    scaleFactors   = 0.1,  0.3,   0.625, 1.25,  1.875, 2.5,  3.75, 5.0, 7.5, 10, 20
#    incrementSlide = 0.01, 0.025, 0.025, 0.025, 0.025, 0.05, 0.05, 0.1, 0.1, 0.2

sub getNormalizedSize
# Arg 1 is scalar from 
{
    my $arg = shift ;

    #printf("%s-%s\n", $arg, $sizes{$arg}) ;
    return ( defined $arg ? $sizes{$arg} : undef ) ;
}

sub readModFolder
# Arg is a valid path to a mod part folder
{
    my $pdir = shift ;

    opendir(my $dh, $pdir) || die "Can't opendir $pdir: $!";
    my @entries = grep { /^(?!\..*)/ && ((-d "$pdir/$_") || ( /\.cfg$/ )) } readdir($dh);
    closedir $dh;

    my ($mod_name) = $pdir =~ m/.*\/(.+)\/Parts/ ;

    foreach (@entries)
    {
       if ( -d "$pdir/$_" )
       # Go deeper
       {
           readModFolder("$pdir/$_") ;
       }
       else
       # Process .cfg part file
       {
           my $part_is_radial = 0 ;

           open(my $fh, "$pdir/$_") || die "Can't open $pdir/$_: $!" ;
           my @lines = <$fh> ;
           close ($fh) ;
           chomp(@lines) ;


           # loop on all lines until name has been found
           my $line = "" ;
           my $part_found = 0 ;
           my $finished = 0 ;
           my $part_description = "" ; # such as "// 2x size static ladder"
           my $part_name        = "" ; # such as "  name = restock-ladder-static-2"

           until ( $finished )
           {
                $line = shift @lines ;
                
                ($line =~ m/ReStock\+/) && next ;
                ($line =~ m/NOTE:/)     && next ;
                ( length($line) <2 ) && next ;
                ($line =~ m/PART/)      && do { $part_found = 1 ; next ;} ;


                (!$part_found) && do { $part_description = $part_description . $line ; next ;} ;
                
                # Here PART line has been found - remove spaces
                $line =~ s/[\n\r\s]+//g ;
               
                if ($line =~ m/name=/)
                {
                    ($part_name) = $line =~ /.*=(.*)/ ; # take the right part from =
                    $finished = 1 ;
                }   
           }

           my ($item, $part_size1, $part_size2, $part_variant) = $part_name =~ /^restock-(.*)-(\d+)-(\d+)-(\d+)$/ ;

           if ( !defined $item )
           {
               ($item, $part_size1, $part_variant) = $part_name =~ /^restock-(.*)-(\d+)-(\d+)$/ ;
               $part_size2 = -1 ;
           }
           if ( !defined $item )
           {
               ($item, $part_variant) = $part_name =~ /^restock-(.*)-(\d+)$/ ;
               $part_size1 = -1 ;
               $part_size2 = -1 ;
           }
           if ( !defined $item )
           {
               ($item) = $part_name =~ /^restock-(.*)$/ ;
               my ($oside) = $pdir =~ /.*\/([^\/]+)/ ;

               $part_is_radial = ($oside =~ m/radial/ ? 1      :  0) ;
               $part_size1     = ($oside =~ m/\d+/    ? $oside : -1) ; # May inlude radial
               $part_size2     = -1 ;
           }

           # Last check on part name to detect a radial part
           if ($item =~ m/radial/)
           {
               $part_is_radial = 1 ;
            }

           # Back listed item : docking ports, fairings.
           ( $item =~ /dock|fairing/ ) && do next ;

           my $struct = {
              part_name        => $part_name,
              part_description => $part_description,
              item             => $item,
              part_size1       => getNormalizedSize($part_size1),
              part_size2       => getNormalizedSize($part_size2),
              part_variant     => $part_variant,
              path             => $pdir,
              part_is_radial   => $part_is_radial,
              scale_method     => undef,
              scale_behavior   => undef,
              mod_name         => $mod_name,
           } ;
           push @parts, $struct ;
        }
    }
}

sub getScaleBehaviorFromPart
# Arg is $h from foreach my $h (@parts)
{
    my $h = shift ;
    my $name = $h->{part_name} ;
    my $behavior = undef ;


    if ($name =~ /srb/)
    {
        $behavior = "SRB" ;
    }
    elsif ($name =~ /engine/)
    {
        $behavior = "Engine" ;   
    }
    elsif ($name =~ /decoupler/)
    {
        $behavior = "Decoupler" ;   
    }
    elsif ($name =~ /science/)
    {
        $behavior = "Science" ;   
    }
    else
    {
        $behavior = "none" ;
    }
    return $behavior ;
} # --- getBehaviorFromPart() ---


sub getScaleMethodFromPart
# Arg is $h from foreach my $h (@parts)
{
    my $h = shift ;
    my $item = $h->{item} ;

    foreach my $i ( @preferred_scale_method )
    {
        my @k = keys %{$i} ;
        my $scale_entry = shift @k ;

        if ( $$h{item} =~ /$scale_entry/ )
        # Found a matching
        {
            return ${$i}{$scale_entry} ;
        }
    }
    return "none" ;
}


sub parse
{
    readModFolder _RESTOCKPLUS_PART_PATH ;
    readModFolder _RESTOCKRIGIDLEGS_PART_PATH ;
}

sub process
{
    foreach my $h (@parts)
    {
        $h->{scale_method}   = getScaleMethodFromPart($h) ;
        $h->{scale_behavior} = getScaleBehaviorFromPart($h) ;
    }
}

sub writeCFG
{ 
    open (my $fh, ">" . _TS_CFG_OUTDIR . "/" . _TS_CFG_OUTFILE) or die "KAPUT FILE @!" ;
    open (my $fhtest, ">" . _TS_CFG_OUTDIR . "/" . _TS_CFG_OUTFILE . ".test.csv") or die "KAPUT FILE @!" ;


    print $fh "// Tweakscale File for Restockplus & Rigid legs\n" ;
    print $fh "// ALPHA VERSION USE AT YOUR OWN RISKS\n" ;
    print $fh "// xot1643\@Github\n" ;
    print $fh "// To be placed in <KSP ROOT>/GameData/TweakScale/patches\n\n" ;

    foreach my $h (@parts)
    {
        my $string_to_write ;

        # Size is defined, a behavior has been identified,  
        if ( ($h->{scale_behavior} ne "none") && ($h->{part_size1} != -1) )
        {
            $string_to_write = $string_part_config_behavior_scale ;
            $string_to_write =~ s/__BEHAVIOR__/$h->{scale_behavior}/g ;
            $string_to_write =~ s/__SIZE__/$h->{part_size1}/g ;
        }
        elsif ( ($h->{scale_behavior} ne "none") && ($h->{part_size1} == -1) )
        {
            $string_to_write = $string_part_config_behavior ;
            $string_to_write =~ s/__BEHAVIOR__/$h->{scale_behavior}/g ;
        }
        elsif ( ($h->{scale_behavior} eq "none") && ($h->{part_size1} != -1) )
        {
            $string_to_write = $string_part_config_scale ;
            $string_to_write =~ s/__SIZE__/$h->{part_size1}/g ;
        }
        else
        # ($$h{scale_behavior} eq "none") && ($$h{part_size1} == -1)
        {
            $string_to_write = $string_part_config ;
        }
        $string_to_write =~ s/__MODNAME__/$h->{mod_name}/g ;
        $string_to_write =~ s/__PARTNAME__/$h->{part_name}/g ;
        $string_to_write =~ s/__PARTDESC__/$h->{part_description}/g ;
        $string_to_write =~ s/__SCALETYPE__/$h->{scale_method}/g ;

        print $fh $string_to_write . "\n" ;

        print $fhtest join (";", $h->{mod_name}, $h->{part_name}, $h->{part_description}, $h->{scale_method}, $h->{scale_behavior}, $h->{part_size1}, "\n") ;

    }
    close $fh ;
    close $fhtest ;
}

parse ;
process ;
writeCFG ; 
