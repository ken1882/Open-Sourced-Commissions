#===============================================================================
# Script: Random Affixes
# Author: Selchar
# Credit: Tsukihime - Instance Items/Item Affixes Scripts
#===============================================================================
=begin
This script is an extention of Tsukihime's Item Affixes, which also utilizes
Instance Items.  By default you have to manually add affixes to equipment, this
script does so automatically when you obtain the item, and allows you some
freedom for randomization.

#-------------------------------------------------------------------------------
# Instructions:
#-------------------------------------------------------------------------------
1: Setup your affixes using the instructions in the Item Affixes script.
2: Tag your equips with the below Notetags.
3: Select which scenes will be allowed to add your affixes, and which won't
   down below.

#-------------------------------------------------------------------------------
# Equip Notetag
#-------------------------------------------------------------------------------
<rand prefix: x> ||| <rand prefix: x,y,z>
Use this to allow for random prefixes upon item creation.  You can have multiple
prefix id's, and you can use the number 0 for "no prefix" instances.  To do
multiple lines, keep typing and let the editor make it's own line breaks.

<rand suffix: x> ||| <rand suffix: x,y,z>
Use this to allow for random suffixes upon item creation.  You can have multiple
suffix id's, and you can use the number 0 for "no suffix" instances.  To do
multiple lines, keep typing and let the editor make it's own line breaks.
=end
module TH_Instance
  module Equip
    #Select which scenes will allow affixes, I have the most common default
    #scenes listed below.
    Random_Affix_Allowed = {
      #Scene => Condition - The condition is eval'd, so you could use, say,
      #$game_switches[1] to determine it by a switch.
      
      'Scene_Title' => 'false', #At game start, initial equips.
      'Scene_Map' => 'true',
      'Scene_Battle' => 'true', #Doesn't display affixes in item gain window.
      'Scene_Shop' => 'false',  #Random upon purchase, you don't get to choose.
      
    #Add more above this line if needed, don't forget the , at the end.
    }#Do Note Remove
  end
end
#===============================================================================
# Rest of the Script
#===============================================================================
$imported = {} if $imported.nil?
$imported[:Sel_Random_Affixes] = true
unless $imported["TH_InstanceItems"]
  msgbox("Tsukihime's Instance not detected, exiting")
  exit
end
unless $imported[:TH_ItemAffixes]
  msgbox("Tsukihime's Item Affixes not detected, exiting")
  exit
end
#===============================================================================
# Notetags
#===============================================================================
class RPG::EquipItem
  def random_prefix
    if @random_prefix.nil?
      @random_prefix = []
      if @note =~ /<rand[-_ ]?prefix:\s*(.*)\s*>/i
        $1.split(',').each {|i|@random_prefix << i.to_i}
      else
        @random_prefix << 0
      end
    end
    return @random_prefix.sample
  end
  def random_suffix
    if @random_suffix.nil?
      @random_suffix = []
      if @note =~ /<rand[-_ ]?suffix:\s*(.*)\s*>/i
        $1.split(',').each {|i|@random_suffix << i.to_i}
      else
        @random_suffix << 0
      end
    end
    return @random_suffix.sample
  end
end
#===============================================================================
# Instance Manager: setup_instance
#===============================================================================
module InstanceManager
  class << self
    alias :random_affix_equip_setup :setup_equip_instance
  end
  
  def self.setup_equip_instance(obj)
    random_affix_equip_setup(obj)
    return if TH_Instance::Equip::Random_Affix_Allowed[SceneManager.scene.class.to_s].nil?
    if eval(TH_Instance::Equip::Random_Affix_Allowed[SceneManager.scene.class.to_s])
      obj.prefix_id = obj.random_prefix
      obj.suffix_id = obj.random_suffix
    end
  end
end
#===============================================================================
# End of File
#===============================================================================