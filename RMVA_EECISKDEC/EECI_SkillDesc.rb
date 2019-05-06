#=============================================================================#
#   EECI Patch - Skill Description                                            #
#   Version: 1.0.0                                                            #  
#   Author: Compeador                                                         #  
#   Last update: 2018.05.06                                                   #  
#=============================================================================#
$imported = {} if $imported.nil?
$imported["COMP_EECISDEC"] = true
#=============================================================================#
#                               ** Update log **                              #
#-----------------------------------------------------------------------------#
#                                                                             #
# -- 2019.05.06: Start the script and completed                               #
#                                                                             #
#=============================================================================#
#                       ** End-User License Agreement **                      #
#-----------------------------------------------------------------------------#
# ┌─────────────────────────────────────────────────────────────────────────┐ #
# │         ** THIS IS A PAID SCRIPT, RE-DISTRIBUTE WITH CAUTION! **        │ #
# └─────────────────────────────────────────────────────────────────────────┘ #
#  1. Copyright and Redistribution:                                           #
#       All codes were written by me(Compeador), and you(the user) may edit   #
#  the code for your own need without permission (duh).                       #
#  Redistribute this script must agreed by VaiJack8, who commissioned this    #
#  script, and you must share the original version released by the author     #
#  without edits with credits.                                                #
#   If you edited the scripts and claimed it as your own, this will resulted  #
#  in copywrite law violation and also proves you're an a$$hole.              #
#                                                                             #
# 2. Service Information:                                                     #
#       I only responsible for the edits requested by VaiJack8(the client).   #
# If you got this script from the redistribution, I'm not responsible for any #
# bug and malfunction occurred in your project.                               #
#                                                                             #
# *You can still try to request me tho, but I won't 100% guaranteed for reply #
#=============================================================================#
#                              ** User Manual **                              #
#-----------------------------------------------------------------------------#
# > Introduction:                                                             #
#       This script will change the display of original parameter comparison  #

#=============================================================================#
#                            ** Compatibility **                              #
#-----------------------------------------------------------------------------#
#   > Require: Extended Equipment Comparison Info                             #
#                                                                             #
#       ** Place this script below the scripts mentioned above **             #
#                                                                             #
#=============================================================================#

if $imported["COMP_EECI"]
#=============================================================================
# * Module of this script
#=============================================================================
module COMP
  module EECI
    DescSkillRegex = /<EECI DESC>/i
  end
end


else
  msgbox("Warning: EECI is not installed, Skill Description script is disabled." + 
         "\nPlease make sure you have place the script ar right place.")
end # if imported EECI