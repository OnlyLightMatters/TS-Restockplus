package UserConfig ;

use strict ;
use warnings ;

require Exporter ;
our @ISA = qw(Exporter) ;
our @EXPORT = qw(%_CONFIG);

our %_CONFIG = (
    _ADD_ON_PREFIX       => "TweakScaleCompanion_",
    
    _PROGRAM_DIR         => "C:/Dev/TS-Restockplus/Program/",
    _TS_CFG_OUTDIR       => "C:/Dev/TS-Restockplus/Config/",
    _TS_GAMEDATA_PATH    => "C:/Program Files (x86)/Steam/steamapps/common/KSP18_2DLC_TestTS/GameData/",


    # Program will look all part cfg files into folder _TS_GAMEDATA_PATH . "/" . _name . "/Parts"
    _ADD_ONS => [
                    { _name        => "Restockplus",
                      _part_prefix => "restock",
                      _out_file    => "Restockplus_TweakScale.cfg",
                      _test_file   => "Restockplus_TweakScale.csv",
                      _common_name => "ReStockPlus", }, 
                    { _name        => "RestockRigidLegs",
                      _part_prefix => "restock",
                      _out_file    => "RestockRigidLegs_TweakScale.cfg",
                      _test_file   => "RestockRigidLegs_TweakScale.csv",
                      _common_name => "ReStockRigidLegs",},
                    { _name        => "NearFutureSolar",
                      _part_prefix => "nfs",
                      _out_file    => "NFS_TweakScale.cfg",
                      _test_file   => "NFS_TweakScale.csv",
                      _common_name => "NFS",},

    ],
) ;


1;
