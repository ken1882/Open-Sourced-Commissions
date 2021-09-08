#=============================================================================#
#   Spawn Affix Item                                                          #
#   Version: 1.1.0                                                            #  
#   Author: Compeador                                                         #  
#   Last update: 2021.09.07                                                   #  
#=============================================================================#
$imported = {} if $imported.nil?
$imported["COMP_SPAWN_AFFITEM"] = true
#=============================================================================#
#                               ** Update log **                              #
#-----------------------------------------------------------------------------#
#                                                                             #
# -- 2021.09.08: Add possibility to add multiple affixies                     #
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
#   Returns the instance item gave to player if the function successed        #
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
#   If option 'AllowMultipleAffixes' is enabled, change single int to array   #
#   to apply multiple affixies.                                               #
#     give_affix_weapon(12, [60,65,78], 0)                                    #
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

    # if this option is enabled, this script will try to alter the template data
    # i.e. $data_items/weapons/armors directly instead of instances
    # from Hime's scripts, maybe will make this script compatible with other
    # scripts that does not acknowledge the instances but could cause issues
    UseTemplateShifter = true

    # An overhaul of Hime's script that allow multiple affixes applied to
    # an item, may cause issues
    AllowMultipleAffixes = true
    
    #=====================================================================#
    # Please don't edit anything below unless you know what you're doing! #
    #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^#

    # Defined in Hime's script
    InstanceAttrs = [
      :name, :params, :price, :features, :note, :icon_index, 
      :description
    ]
  end
end
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
# ** Check script availability
#==============================================================================
if COMP::SpawnAffixItem::Enabled && (!$imported["TH_InstanceItems"] || !$imported[:TH_ItemAffixes])
  msgbox %{[WARNING] Hime's instance and affix item scripts are missing, SpawnAffixItem script will be disalbed.
  Please make sure the scripts is placed in right order!
  (place SpawnAffix sciprt after Hime's Instance/Affix item script)
  }
else
#==============================================================================
# ** DataManager
# ----------------------------------------------------------------------------
#   Load database and copy as primitive set to restore later
#==============================================================================
if COMP::SpawnAffixItem::UseTemplateShifter
module DataManager
  class << self
    attr_reader :primitive_items
    attr_reader :primitive_weapons
    attr_reader :primitive_armors

    alias :comp_insitem_primitive_load_database :load_database
  end

  def self.load_database
    comp_insitem_primitive_load_database
    @primitive_items   = Marshal.load(Marshal.dump($data_items))
    @primitive_weapons = Marshal.load(Marshal.dump($data_weapons))
    @primitive_armors  = Marshal.load(Marshal.dump($data_armors))
  end

end # DataManager
end # if use template shifter
#===============================================================================
# > Define multi-affix attributes if enabled
#   The attributes are used to track applied affix effects
if COMP::SpawnAffixItem::AllowMultipleAffixes
#===============================================================================
# ** RPG::EquipItem
#===============================================================================
class RPG::EquipItem
  attr_accessor :prefix_id_multi
  attr_accessor :suffix_id_multi
end
#===============================================================================
# ** RPG::Item
#===============================================================================
class RPG::Item
  attr_accessor :prefix_id_multi
  attr_accessor :suffix_id_multi
end
end
#==============================================================================
# ** Module from Hime's script
#==============================================================================
module InstanceManager
  #------------------------------------------------------------------------------
  # * New method: spawn item with prefix/suffix
  #------------------------------------------------------------------------------
  def spawn_affix_item(tmp_item, prefix=nil, suffix=nil)
    $game_party.gain_item(tmp_item, 1)
    ins_item = $game_party.find_instance_item(tmp_item, true)
    [prefix || 0].flatten.each do |pid|
      next if pid == 0
      if COMP::SpawnAffixItem::AllowMultipleAffixes
        extend_affix_effect(tmp_item, pid, 0)
      else
        ins_item.prefix_id = pid
      end
    end
    [suffix || 0].flatten.each do |sid|
      next if sid == 0
      if COMP::SpawnAffixItem::AllowMultipleAffixes
        extend_affix_effect(tmp_item, 0, sid)
      else
        ins_item.suffix_id = sid
      end
    end
    return ins_item unless COMP::SpawnAffixItem::UseTemplateShifter
    ret = make_full_copy(ins_item)
    restore_template(tmp_item)
    return ret
  end
#------------------------------------------------------------------------------
# * This part of code are considered hacky, but perhaps compatible with more
#   scripts because are accessing $data_xxxxx directly
if COMP::SpawnAffixItem::UseTemplateShifter
  #------------------------------------------------------------------------------
  # * New method: Get primitive item
  #------------------------------------------------------------------------------
  def self.get_primitive_item(tmp_item)
    id = tmp_item.template_id
    return DataManager.primitive_items[id]    if tmp_item.is_a?(RPG::Item)
    return DataManager.primitive_weapons[id]  if tmp_item.is_a?(RPG::Weapon)
    return DataManager.primitive_armors[id]   if tmp_item.is_a?(RPG::Armor)
  end
  #------------------------------------------------------------------------------
  # * New method: Alter the template item without changing it back
  #     The given block should accept first param as the template item
  #------------------------------------------------------------------------------
  def self.alter_template!(item, &block)
    block.call(get_template(item))
  end
  #------------------------------------------------------------------------------
  # * New method: Alter the template item and change it back immediately
  #     The given block should accept first param as the template item
  #------------------------------------------------------------------------------
  def self.alter_template(item, &block)
    block.call(get_template(item))
    restore_template(item)
  end
  #------------------------------------------------------------------------------
  # * New method: Restore template item to its primitive state
  #------------------------------------------------------------------------------
  def self.restore_template(item)
    pitem = get_primitive_item(item)
    tid   = item.template_id
    return unless pitem
    if item.is_a?(RPG::Item)
      $data_items[tid] = pitem
    elsif item.is_a?(RPG::Weapon)
      $data_weapons[tid] = pitem
    elsif item.is_a?(RPG::Armor)
      $data_armors[tid] = pitem
    end 
  end
  #------------------------------------------------------------------------------
  # * New method: Extend affix effect on given item (hacky)
  #------------------------------------------------------------------------------
  def extend_affix_effect(item, pfid, sfid)
    alter_template! do |tmp_item|
      if pfid > 0
        tmp_item.prefix_id = pfid 
        tmp_item.prefix_id_multi = (tmp_item.prefix_id_multi || []) << sfid
      end
      if sfid > 0
        tmp_item.suffix_id = sfid
        tmp_item.suffix_id_multi = (tmp_item.suffix_id_multi || []) << sfid
      end
    end
  end
#------------------------------------------------------------------------------
# * The code below are considered safe
else
  #------------------------------------------------------------------------------
  # * New method: Extend affix effect on given item
  #------------------------------------------------------------------------------
  def extend_affix_effect(item, pfid, sfid)
    item = make_full_copy(item)
    convert2stackable_instance!(item)
    if pfid > 0
      item.prefix_id = pfid 
      item.prefix_id_multi = (tmp_item.prefix_id_multi || []) << sfid
    end
    if sfid > 0
      item.suffix_id = sfid
      item.suffix_id_multi = (tmp_item.suffix_id_multi || []) << sfid
    end
    item
  end
  #------------------------------------------------------------------------------
  # * New method: [DANGER] rewrite Hime's item refresh behaviors
  #------------------------------------------------------------------------------
  def convert2stackable_instance!(item)
    item.refresh
    _parent_instance = make_full_copy(item)    
    class << item
      attr_reader :parent_instance
      def refresh
        COMP::SpawnAffixItem::InstanceAttrs.each do |attr|
          _method = methods(:"make_#{attr}")
          pvar = @parent_instance.instance_variable_get(:"@#{attr}")
          instance_variable_set(:"@#{attr}", _method.call(pvar))
        end
      end

      def parent_instance=(pins)
        @parent_instance = pins
        refresh
      end
    end
    item.parent_instance = _parent_instance
    item.instance_eval("@prefix_id = @suffix_id = 0")
    return item
  end
end # if using template shifter 
end # InstanceManager
#==============================================================================
# ** Game_Interpreter
#==============================================================================
class Game_Interpreter
  #------------------------------------------------------------------------------
  # * New method: Give item/weapon/armor with prefix/suffix
  #------------------------------------------------------------------------------
  def give_affix_item(id, prefix_id=0, suffix_id=0)
    tmp_item = $data_items[id]
    return InstanceManager.spawn_affix_item(tmp_item, prefix_id, suffix_id)
  end
  #------------------------------------------------------------------------------
  def give_affix_weapon(id, prefix_id=0, suffix_id=0)
    tmp_item = $data_weapons[id]
    return InstanceManager.spawn_affix_item(tmp_item, prefix_id, suffix_id)
  end
  #------------------------------------------------------------------------------
  def give_affix_armor(id, prefix_id=0, suffix_id=0)
    tmp_item = $data_armors[id]
    return InstanceManager.spawn_affix_item(tmp_item, prefix_id, suffix_id)
  end
  #------------------------------------------------------------------------------
  # * New method: Reset item/weapon/armor to primitive stat
  #------------------------------------------------------------------------------
  def reset_affix_item(id)
    return unless InstanceManager.respond_to? :restore_template
    InstanceManager.restore_template($data_items[id])
  end
  #------------------------------------------------------------------------------
  def reset_affix_weapon(id)
    return unless InstanceManager.respond_to? :restore_template
    InstanceManager.restore_template($data_weapons[id])
  end
  #------------------------------------------------------------------------------
  def reset_affix_armor(id)
    return unless InstanceManager.respond_to? :restore_template
    InstanceManager.restore_template($data_armors[id])
  end
  #------------------------------------------------------------------------------
end # Game_Interpreter
end # if script enabled