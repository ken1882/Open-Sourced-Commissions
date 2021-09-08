#=============================================================================#
#   Multi-random Item Affixies                                                #
#   Version: 1.0.0                                                            #  
#   Author: Compeador                                                         #  
#   Last update: 2021.09.0*                                                   #  
#=============================================================================#
$imported = {} if $imported.nil?
$imported["COMP_MRANDOM_AFFIX"] = true
#=============================================================================#
#                               ** Update log **                              #
#-----------------------------------------------------------------------------#
#                                                                             #
# -- 2021.09.08: Start the script and completed                               #
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
#   This script adds additional notetag optional to allow weighted and        #
# multiple affixies (if avaiable) applies to an item, also script call to     #
# apply the same random effect.                                               #
#                                                                             #
#=============================================================================#
#                            ** Compatibility **                              #
#-----------------------------------------------------------------------------#
#   > Hime's Instance Items is required                                       #
#   > Hime's Item Affixes is required                                         #
#   > Selchar's Random Affixes                                                #
#   > (Optional) Compeador's Spawn Affix Item scipt                           #
#                with AllowMultipleAffixes option enabled                     #
#                                                                             #
#       ** Place this script below the scripts mentioned above **             #
#=============================================================================#

#==============================================================================
# ** COMP
#------------------------------------------------------------------------------
#  Module of this script
#==============================================================================
module COMP
  module MultiRandomAffix
    # whether enable the script
    Enabled = true

    #=====================================================================#
    # Please don't edit anything below unless you know what you're doing! #
    #^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^#

    RegexFormat = /<random (suf|pre)fix\s?\((\d[.]\d+)?\):(.*)>/i
    IdSep       = ','
    WeightSep   = '@'

    RandAffixInfo = Struct.new(:chance, :ids, :weights)
  end
end

if COMP::MultiRandomAffix::Enabled && (!$imported[:Sel_Random_Affixes] || 
  !$imported["TH_InstanceItems"] || !$imported[:TH_ItemAffixes])
  msgbox %{[WARNING] The dependency for MultiRandomAffixies are missing.
  Please make sure the scripts is placed in right order!
  (place SpawnAffix sciprt after the depended script)
  }
else
#===============================================================================
# ** RPG::EquipItem
#===============================================================================
class RPG::EquipItem
  #-----------------------------------------------------------------------------
  # * Overwrite method: Notetag parsing for random_prefix and random_suffix
  #-----------------------------------------------------------------------------
  def random_prefix
    if @random_prefix.nil?
      @random_prefix = []
      @note.split(/[\r\n]+/).each do |line|
        next unless line =~ COMP::MultiRandomAffix::RegexFormat
        affix = COMP::MultiRandomAffix::RandAffixInfo.new($2.to_f, [], [])
        $3.split(',').each do |pair|
          id,weight = pair.split('@')
          affix.ids << id.to_i
          affix.weights << weight.to_i
        end
        @random_prefix << affix
      end
      @random_prefix = 0 if @random_prefix.empty?
    end
    return roll_random_affix(@random_prefix, :prefix)
  end
  #-----------------------------------------------------------------------------
  def random_suffix
    if @random_suffix.nil?
      @random_suffix = []
      @note.split(/[\r\n]+/).each do |line|
        next unless line =~ COMP::MultiRandomAffix::RegexFormat
        affix = COMP::MultiRandomAffix::RandAffixInfo.new($2.to_f, [], [])
        $3.split(',').each do |pair|
          id,weight = pair.split('@')
          affix.ids << id.to_i
          affix.weights << weight.to_i
        end
        @random_suffix << affix
      end
      @random_suffix = 0 if @random_suffix.empty?
    end
    return roll_random_affix(@random_suffix, :suffix)
  end
  #-----------------------------------------------------------------------------
  def roll_random_affix(affixies, affix_sym)
    return affixies if affixies.is_a?(Numeric)
    ret = []
    affixies.each do |aff|
      next if rand() > aff.chance
      dice = rand(aff.weights.sum)
      s = 0
      aff.weights.each_with_index do |w,i|
        if dice.between?(s, s+w-1)
          ret << aff.ids[i]
          break
        end
        s += w
      end
    end
    ret = [0] if ret.empty?
    
    # return random affix if only single affix allowed
    return ret.sample if !$imported["COMP_SPAWN_AFFITEM"] || !COMP::SpawnAffixItem::AllowMultipleAffixes

    # Save the multi-affix effect, let the InstanceManager handle the effects
    case affix_sym
    when :prefix; @prefix_id_multi = ret;
    when :suffix; @suffix_id_multi = ret;
    end

    # Avoid original random_affixes script mess up stuff
    return 0
  end
end
#===============================================================================
# * Check multi-affixies available
if $imported["COMP_SPAWN_AFFITEM"] && COMP::SpawnAffixItem::AllowMultipleAffixes
#===============================================================================
# ** InstanceManager
#===============================================================================
module InstanceManager
  #-----------------------------------------------------------------------------
  # * Alias method: setup equip instance then apply multi-affix, if available
  #-----------------------------------------------------------------------------
  class << self; alias mulrand_affix_equip_setup setup_equip_instance; end
  def self.setup_equip_instance(obj)
    mulrand_affix_equip_setup(obj)
    if obj.prefix_id_multi
      ids = obj.prefix_id_multi.dup 
      obj.prefix_id_multi.clear
      ids.each{|i| extend_affix_effect(obj, i, 0)}
    end
    if obj.suffix_id_multi
      ids = obj.prefix_id_multi.dup 
      obj.suffix_id_multi.clear
      ids.each{|i| extend_affix_effect(obj, 0, i)}
    end
  end
end
end # if multi-affixies available
#-----------------------------------------------------------------------------
end