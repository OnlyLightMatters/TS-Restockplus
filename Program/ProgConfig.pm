# 4/1/2020 - updated for new restock+ parts : wheel, structural tubes.

package ProgConfig ;

use strict ;
use warnings ;

use UserConfig ;

require Exporter ;
our @ISA = qw(Exporter) ;
our @EXPORT = qw(%EXISTING_SIZES @PREFERED_SCALE_METHOD %BEHAVIORS
    _PROG_VERSION
    _PART_CFG_NONE _PART_CFG_SCALE _PART_CFG_BEHAVIOR _PART_CFG_SCALEBEHAVIOR);

use constant {
    _PROG_VERSION           => "v2.0",

    _PART_CFG_NONE          => $_CONFIG{_PROGRAM_DIR} . "/TemplateCfg/Part_TS_none.cfg",
    _PART_CFG_SCALE         => $_CONFIG{_PROGRAM_DIR} . "/TemplateCfg/Part_TS_Scale.cfg",
    _PART_CFG_BEHAVIOR      => $_CONFIG{_PROGRAM_DIR} . "/TemplateCfg/Part_TS_Behavior.cfg",
    _PART_CFG_SCALEBEHAVIOR => $_CONFIG{_PROGRAM_DIR} . "/TemplateCfg/Part_TS_ScaleBehavior.cfg",
} ;


#   scaleFactors   = 0.1,  0.3,   0.625, 1.25,  1.875, 2.5,  3.75, 5.0, 7.5, 10, 20
#   incrementSlide = 0.01, 0.025, 0.025, 0.025, 0.025, 0.05, 0.05, 0.1, 0.1, 0.2
our %EXISTING_SIZES = (
# in meters 
    "-1"   => "-1",
    "0625" => "0.625",
    "625"  => "0.625",
    "125"  => "1.25",
    "1875" => "1.875",
    "25"   => "2.5",
    "375"  => "3.75",
    "50"   => "5",
    "5"    => "5",
    "75"   => "7.5", # Near Future Suite proposes 7.5m parts
) ;


# The following array lists expected scale behviors from part names
# The order stands for priority : as soon as a match is found, it stops matchings
our @PREFERED_SCALE_METHOD = (
    {relay => "free_square"},
    {panel => "free_square"},
    {solar => "free_square"},

    {radial        => "free"},
    {reactionwheel => "stack"},
    {goocanister   => "stack"},  
    {heatshield    => "stack_square"},
    {servicebay    => "stack"},
    {decoupler     => "stack"},
    {separator     => "stack"},
    {nosecone      => "stack_square"},
    {ctrlsrf       => "stack_square"},
    {tailfin       => "stack_square"},
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
    {claw          => "stack"},
    {tank          => "stack"},
    {drone         => "stack"},
    {solar         => "free_square"},
    {truss         => "free"},
    {cabin         => "stack_square"},    
    {stack         => "stack"},
    {delta         => "free_square"},
    {wheel         => "free"},
    {wing          => "free_square"},
    {tube          => "stack"},
    {rcs           => "free"},
    {pod           => "stack_square"},
    {srb           => "stack"},
    {leg           => "free"},
    {ladder        => "free"},
    {fairing       => "stack_square"},
    {dock          => "stack"},
) ;


# Possible behaviors
# Science, SRB, Engine, Decoupler

our %BEHAVIORS = (
    science   => "Science",
    srb       => "SRB",
    engine    => "Engine",
    decoupler => "Decoupler",
) ;


1;