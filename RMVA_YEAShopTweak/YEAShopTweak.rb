#=============================================================================#
#   YEA Shop Tweak Patch                                                      #
#   Version: 1.0.0                                                            #  
#   Author: Compeador                                                         #  
#   Last update: 2019.05.11                                                   #  
#=============================================================================#
$imported = {} if $imported.nil?
$imported[:CRDE_YSTP] = true
#=============================================================================#
#                               ** Update log **                              #
#-----------------------------------------------------------------------------#
#                                                                             #
# -- 2019.05.11: Start the script and completed                               #
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
#       This script changes the hud in YEA's shop that showing item status    #
# to party member info since my shop status script can do it.                 #
#=============================================================================#
#                            ** Compatibility **                              #
#-----------------------------------------------------------------------------#
#   > CRDE Kernel is required                                                 #
#   > CRDE Equipment info is required                                         #
#   > YEA's shop option script is required.                                   #
#                                                                             #
#       ** Place this script below the scripts mentioned above **             #
#=============================================================================#

if !$imported[:CRDE_Kernel] || !$imported[:CRDE_EQInfo]
  raise LoadError, "CRDE Kernel and equipment info is required for YEA shop tweak script"
end

#==============================================================================
# ** Window_ShopData
#==============================================================================
class Window_ShopData < Window_Base
  
end