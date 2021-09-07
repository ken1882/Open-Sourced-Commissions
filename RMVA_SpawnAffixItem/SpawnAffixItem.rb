#=============================================================================#
#   Spawn Affix Item                                                          #
#   Version: 1.0.0                                                            #  
#   Author: Compeador                                                         #  
#   Last update: 2021.09.07                                                   #  
#=============================================================================#
$imported = {} if $imported.nil?
$imported["COMP_SPAWN_AFFITEM"] = true
#=============================================================================#
#                               ** Update log **                              #
#-----------------------------------------------------------------------------#
#                                                                             #
# -- 2021.09.07: Start the script and completed                               #
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
#       This script adds script calls to give instance items with affixes.    #
#                                                                             #
#   script call usage:                                                        #
#                                                                             #
#     give_affix_item(<item id>, <prefix id>, <suffix id>)                    #
#     give_affix_weapon(<weapon id>, <prefix id>, <suffix id>)                #
#     give_affix_armor(<armor id>, <prefix id>, <suffix id>)                  #
#                                                                             #
#   If you don't need the prefix or suffix, replace with 0 (numeric zero)     #
#   Returns the instance item gave to player if the function successed         #
#                                                                             #
#   For example give player with tempalte weapon id 12, prefix id 60          #
#   and no suffix:                                                            #
#     give_affix_weapon(12, 60, 0)                                            #
#                                                                             #
#   Armor id 35, no prefix and suffix id 97:                                  #
#     give_affix_weapon(35, 0, 97)                                            #
#                                                                             #
#   Item id 65, prefix id 98 and suffix id 103:                               #
#     give_affix_item(65, 98, 103)                                            #
#                                                                             #
#   If you need neither, just use "Change Item/Weapon/Armor" in the event UI  #
#                                                                             #
#=============================================================================#
#                            ** Compatibility **                              #
#-----------------------------------------------------------------------------#
#   > Hime's Instance Items is required                                       #
#   > Hime's Item Affixes is required                                         #
#                                                                             #
#       ** Place this script below the scripts mentioned above **             #
#=============================================================================#

#==============================================================================
# ** COMP
#------------------------------------------------------------------------------
#  Module of this script
#==============================================================================
module COMP
  module SpawnAffixItem
    # whether enable the script
    Enabled = true
  end
end
#=====================================================================#
# Please don't edit anything below unless you know what you're doing! #
#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^#
if COMP::SpawnAffixItem::Enabled && (!$imported["TH_InstanceItems"] || !$imported[:TH_ItemAffixes])
  msgbox %{[WARNING] Hime's instance and affix item scripts are missing, SpawnAffixItem script will be disalbed.
  Please make sure the scripts is placed in right order!
  (place SpawnAffix sciprt after Hime's Instance/Affix item script)
  }
else
#==============================================================================
# ** Game_Party
#==============================================================================
class Game_Party < Game_Unit
  #-----------------------------------------------------------------------------
  # * Alias method: find instance item with option to find latest
  #-----------------------------------------------------------------------------
  alias :comp_find_instance_item :find_instance_item
  def find_instance_item(template_item, latest=false)
    return comp_find_instance_item(template_item) unless latest
    container_list = item_container_list(template_item)
    return container_list.reverse.find{|obj| obj.template_id == template_item.template_id }
  end
end
#==============================================================================
# ** Game_Interpreter
#==============================================================================
class Game_Interpreter
  #------------------------------------------------------------------------------
  # * New method: Give item with prefix/suffix
  #------------------------------------------------------------------------------
  def give_affix_item(id, prefix_id=0, suffix_id=0)
    tmp_item = $data_items[id]
    $game_party.gain_item(tmp_item, 1)
    ins_item = $game_party.find_instance_item(tmp_item, true)
    return unless ins_item
    set_prefix(ins_item, prefix_id) if prefix_id > 0
    set_suffix(ins_item, suffix_id) if suffix_id > 0
    return ins_item
  end
  #------------------------------------------------------------------------------
  # * New method: Give weapon with prefix/suffix
  #------------------------------------------------------------------------------
  def give_affix_weapon(id, prefix_id=0, suffix_id=0)
    tmp_item = $data_weapons[id]
    $game_party.gain_item(tmp_item, 1)
    ins_item = $game_party.find_instance_item(tmp_item, true)
    return unless ins_item
    set_prefix(ins_item, prefix_id) if prefix_id > 0
    set_suffix(ins_item, suffix_id) if suffix_id > 0
    return ins_item
  end
  #------------------------------------------------------------------------------
  # * New method: Give armor with prefix/suffix
  #------------------------------------------------------------------------------
  def give_affix_armor(id, prefix_id=0, suffix_id=0)
    tmp_item = $data_armors[id]
    $game_party.gain_item(tmp_item, 1)
    ins_item = $game_party.find_instance_item(tmp_item, true)
    return unless ins_item
    set_prefix(ins_item, prefix_id) if prefix_id > 0
    set_suffix(ins_item, suffix_id) if suffix_id > 0
    return ins_item
  end
end
end # if script enabled