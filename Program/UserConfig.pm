package UserConfig ;

use strict ;
use warnings ;

require Exporter ;
our @ISA    = qw(Exporter) ;
our @EXPORT = qw(%_CONFIG);

our %_CONFIG = (
    _ADD_ON_PREFIX       => "TweakScaleCompanion_",
    
    _PROGRAM_DIR         => "C:/Dev/TS-Restockplus/Program/",
    _TS_CFG_OUTDIR       => "C:/Dev/TS-Restockplus/Config/",
    _TS_GAMEDATA_PATH    => "C:/Program Files (x86)/Steam/steamapps/common/Kerbal Space Program/GameData/",


    # Program will look all part cfg files into folder _TS_GAMEDATA_PATH . "/" . $_source_addonname . "/Parts"
    _ADD_ONS => [
        #    _source_addonname => The name of the AddOn in GameData
        #    _part_prefix      => The prefix of all parts for a given AddOn
        #    _out_file         => The pluging file to be produced
        #    _test_file        => The csv file for testing purposes 
        #    _out_addonname    => The name of the addon for which the pluging is produced
        #    _common_name      => Short name or common name for the source AddOn
        {
            _source_addonname => "Restockplus",
            _part_prefix      => "restock",
            _out_file         => "Restockplus_TweakScale.cfg",
            _test_file        => "Restockplus_TweakScale.csv",
            _out_addonname    => "TweakScaleCompanion_Restockplus",
            _common_name      => "ReStockPlus", }, 
        {
            _source_addonname => "RestockRigidLegs",
            _part_prefix      => "restock",
            _out_file         => "RestockRigidLegs_TweakScale.cfg",
            _test_file        => "RestockRigidLegs_TweakScale.csv",
            _out_addonname    => "TweakScaleCompanion_Restockplus",                      
            _common_name      => "ReStockRigidLegs",},
        # {
        #     _source_addonname => "NearFutureSolar",
        #     _part_prefix      => "nfs",
        #     _out_file         => "NFS_TweakScale.cfg",
        #     _test_file        => "NFS_TweakScale.csv",
        #     _out_addonname    => "TweakScaleCompanion_NFS",                      
        #     _common_name      => "NFS", },
    ],
) ;


1;
