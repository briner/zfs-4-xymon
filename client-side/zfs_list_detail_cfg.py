# LTRESHOLD is a list composed of tuple.
#
# the first tuple is the default configuration
# e.g: (80, 90)
#        |   \ red alert's treshold
#      yellow alert's treshold  
#
# the followings one are treshold for specific FS.
# the FS is given, with a RE.
# e.g : ('root_pool', 5, 10)
#            |        |   \ red alert's treshold
#            |        yellow alert's treshold
#         the RE which defines on wich FS the treshold is applied
#
# so gor e.g: LTRESHOLD should looks like
# LTRESHOLD=[(80, 90)
#           ,('root_pool', 70, 90)
#           ,('tsm.*', 30, 40)
#           ]
#
# default configuration (<yellow_value>, <red_value>)
LTRESHOLD=[(80,90) # default config
          ,('tsm_.*', 100, 100)
          ]


# LEXCLUDE_FS is a list composed of RE
LEXCLUDE=['.*/\.backup$']

#
ZPOOL_VERSION=2
