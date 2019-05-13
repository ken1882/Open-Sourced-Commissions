#=============================================================================#
#   YEA Shop Data Tweak Patch                                                 #
#   Version: 1.0.1                                                            #  
#   Author: Compeador                                                         #  
#   Last update: 2019.05.13                                                   #  
#=============================================================================#
$imported = {} if $imported.nil?
$imported[:CRDE_YSTP] = true
#=============================================================================#
#                               ** Update log **                              #
#-----------------------------------------------------------------------------#
#                                                                             #
# -- 2019.05.13: Start the script and completed                               #
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
#       This script changes the hud in YEA's shop that showing equipment      #
# status to party member info since my shop status script can do it.          #
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

#=============================================================================
# * Module of this script
#=============================================================================
module CRDE
  module YEAShopDataTweak

    # If true, the equippable actor's name will changing its color response
    # to performance change of the equipment
    PerformanceChangeColor = false
  end
end
#==============================================================================
# ** Window_ShopData
#==============================================================================
class Window_ShopData < Window_Base
  include CRDE::YEAShopDataTweak
  #--------------------------------------------------------------------------
  def col_max
    return 3
  end
  #--------------------------------------------------------------------------
  def row_max
    return 4
  end
  #--------------------------------------------------------------------------
  # * Overwrite: draw_item_stats
  #--------------------------------------------------------------------------
  def draw_item_stats
    return unless @item.is_a?(RPG::Weapon) || @item.is_a?(RPG::Armor)
    dx = 96; dy = 0
    dw = (contents.width - 96) / col_max
    n = [$game_party.members.size, col_max * row_max].min
    n.times do |i|
      sx = dx + (i % col_max) * dw
      sy = (i / col_max) * line_height
      draw_actor_equip_info($game_party.members[i], sx, sy, dw)
    end
  end
  #--------------------------------------------------------------------------
  # * overwrite method: draw_actor_equip_info
  #--------------------------------------------------------------------------
  def draw_actor_equip_info(actor, dx, dy, dw)
    draw_background_box(dx, dy, dw)
    item1 = current_equipped_item(actor, @item.etype_id)
    delta = (@item.performance rescue 0) - (item1.performance rescue 0)
    enabled = actor.equippable?(@item)
    performance_change_color(delta, enabled)
    draw_text(dx + 2, dy, dw - 2, line_height, actor.name)
    change_color(normal_color, enabled)
  end
  #--------------------------------------------------------------------------
  def performance_change_color(delta, enabled)
    clr = PerformanceChangeColor && enabled ? param_change_color(delta) : normal_color
    change_color(clr, enabled)
  end
  #--------------------------------------------------------------------------
  def draw_background_box(dx, dy, dw)
    colour = Color.new(0, 0, 0, translucent_alpha/2)
    rect = Rect.new(dx+1, dy+1, dw-2, line_height-2)
    contents.fill_rect(rect, colour)
  end
  #--------------------------------------------------------------------------
  def current_equipped_item(actor, etype_id)
    list = []
    actor.equip_slots.each_with_index do |slot_etype_id, i|
      list.push(actor.equips[i]) if slot_etype_id == etype_id
    end
    list.min_by {|item| item ? item.params[param_id] : 0 }
  end
  #--------------------------------------------------------------------------
  def param_id
    @item.is_a?(RPG::Weapon) ? 2 : 3
  end
  #--------------------------------------------------------------------------
end