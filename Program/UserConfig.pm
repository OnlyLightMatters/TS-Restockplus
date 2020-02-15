package UserConfig ;

use strict ;
use warnings ;

require Exporter ;
our @ISA = qw(Exporter) ;
our @EXPORT = qw(%_CONFIG);

our %_CONFIG = (

    _PROGRAM_DIR         => "C:/Users/y.mornet/Documents/Personnel/Dev",
    _TS_CFG_OUTDIR       => "C:/Users/y.mornet/Documents/Personnel/Dev",
    _TS_GAMEDATA_PATH    => "C:/Program Files (x86)/Steam/steamapps/common/KSP18_2DLC_TestTS/GameData/",


    # Program will look all part cfg files into folder _TS_GAMEDATA_PATH . "/" . _name . "/Parts"
    _ADD_ONS => [
                    { _name      => "Restockplus",
                      _out_file  => undef, # if not defined at all or with a length of < 5 will be _name . "_Tweakscale.cfg"
                      _test_file => undef, }, 
                    { _name      => "RestockRigidLegs",
                      _out_file  => undef,
                      _test_file => undef, },
                    { _name      => "NearFutureSolar",
                      _out_file  => undef,
                      _test_file => undef, },

    ],
) ;


1;