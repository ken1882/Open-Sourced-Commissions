#=============================================================================#
#   Lizzie's Quest Menu Tweak                                                 #
#   Version: 1.0.0                                                            #  
#   Author: Compeador                                                         #  
#   Last update: 2021.09.05                                                   #  
#=============================================================================#
$imported = {} if $imported.nil?
$imported["COMP_LIZZIE_QM_TWEAK"] = true
#=============================================================================#
#                               ** Update log **                              #
#-----------------------------------------------------------------------------#
#                                                                             #
# -- 2021.09.15: Start the script and completed                               #
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
#       This script alter the default pageup/down to scroll the quest         #
# description window to using left and right instead.                         #
#=============================================================================#
#                            ** Compatibility **                              #
#-----------------------------------------------------------------------------#
#   > Qust Menu by Lizzie S is required                                       #
#   > (Optional) Keyboard Input script                                        #
#                                                                             #
#       ** Place this script below the scripts mentioned above **             #
#=============================================================================#

#==============================================================================
# ** COMP
#------------------------------------------------------------------------------
#  Module of this script
#==============================================================================
module COMP
  module LizzieQuestMenuTweak
    # whether enable the script
    Enabled = true

    # If you're using keyboard script and supports such as WASD to navigate
    # the window, set this to true and set the SYM_VK_A and SYM_VK_D to
    # corresponding keymap symbol
    KeyboardSupport = true
    SYM_VK_A = :LETTER_A
    SYM_VK_D = :LETTER_D

  end
end
#=====================================================================#
# Please don't edit anything below unless you know what you're doing! #
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^#
if COMP::LizzieQuestMenuTweak::Enabled && (!defined?(Window_Missions) || !defined?(Scene_Mission))
  msgbox %{[WARNING] Lizzie's Quest Menu is not found, Tweaks will is disabled.
  Please make sure the scripts is placed in right order!
  (place tweak script after the quest menu script)
  }
else
#===============================================================================
#  *  Window_Missions
#===============================================================================
class Window_Missions < Window_Selectable

  #--------------------------------------------------------------------------
  # * New mentod: Supports for full keyboard input
  #--------------------------------------------------------------------------
if COMP::LizzieQuestMenuTweak::KeyboardSupport
  def process_cursor_move
    super
    return unless cursor_movable?
    cursor_left  if Input.repeat?(COMP::LizzieQuestMenuTweak::SYM_VK_A)
    cursor_right if Input.repeat?(COMP::LizzieQuestMenuTweak::SYM_VK_D)
  end
end
  #--------------------------------------------------------------------------
  # * Overwrite: Cursor left and right for scrolling quest desc instead
  #--------------------------------------------------------------------------
  def cursor_left(*args)
    call_handler(:LEFT)
  end
  def cursor_right(*args)
    call_handler(:RIGHT)
  end
end
#===============================================================================
#  *  Scene_Mission
#===============================================================================
class Scene_Mission < Scene_MenuBase
  #--------------------------------------------------------------------------
  # * Overwrite: Using left and right for scrolling desc window instead of 
  #              page up and down
  #--------------------------------------------------------------------------
  def create_list_window
    @list_window = Window_Missions.new
    @list_window.set_handler(:cancel, method(:return_scene))
    @list_window.set_handler(:RIGHT, method(:scroll_down))
    @list_window.set_handler(:LEFT, method(:scroll_up))
  end
end
#--------------------------------------------------------------------------
end # if defined? Window_Missions