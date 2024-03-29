#=============================================================================#
#   Multi-random Item Affixies                                                #
#   Version: 1.1.0                                                            #  
#   Author: Compeador                                                         #  
#   Last update: 2021.09.18                                                   #  
#=============================================================================#
$imported = {} if $imported.nil?
$imported["COMP_MRANDOM_AFFIX"] = true
#=============================================================================#
#                               ** Update log **                              #
#-----------------------------------------------------------------------------#
#                                                                             #
# -- 2021.09.18: Complete all new requests                                    #
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
#   Format:                                                                   #
#   <random prefix({CHANCE_FLOAT}): {ID}@{WEIGHT}, {ID}@{WEIGHT}...>          #
#   <random suffix({CHANCE_FLOAT}): {ID}@{WEIGHT}, {ID}@{WEIGHT}...>          #
#                                                                             #
#   Example:                                                                  #
#   Just one prefix that guaranteed to get                                    #
#     <random prefix(1.0): 123@1>                                             #
#   * Chance is set to 1.0 (100%), with prefix id 123 and weight is 1         #
#                                                                             #
#   80% Chance to get one of two prefix:                                      #
#     <random prefix(0.8): 123@1, 456@1>                                      #
#   * Chance = 0.8 (80%)                                                      #
#   * ID=123 with weight=1, ID=456 with weight=1. Since they have same        #
#     weight so the chance to get one of them are 50-50                       #
#                                                                             #
#   Chance to get one of multiple preix with different chance                 #
#     <random prefix(0.85): 100@6, 101@5, 102@4, 103@3>                       #
#   * Chance = 0.85 (85%)                                                     #
#   * The total weight is 6+5+4+3=18, so the chance to get each               #
#     prefix is:                                                              #
#     ID 100 => 6 / 18                                                        #
#     ID 101 => 5 / 18                                                        #
#     ID 102 => 4 / 18                                                        #
#     ID 103 => 3 / 18                                                        #
#                                                                             #
#   If you want to set multiple prefix/suffix, be sure `AllowMultipleAffixes` #
#   option is set to `true`; then just add another line in the note.          #
#   Example:                                                                  #  
#     <random prefix(0.85): 100@6, 101@5, 102@4, 103@3>                       #
#     <random prefix(0.1): 123@1, 456@1>                                      #
#     <random suffix(0.7): 500@2, 501@1>                                      #
#     <random suffix(0.01): 510@10, 511@1>                                    #
#                                                                             #
#=============================================================================#
#                            ** Compatibility **                              #
#-----------------------------------------------------------------------------#
#   > Hime's Instance Items is required                                       #
#   > Hime's Item Affixes is required                                         #
#   > Selchar's Random Affixes                                                #
#   > (Optional) Compeador's Multi-Affix Item scipt                           #
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
    RandAffixInfo = Struct.new(:chance, :ids, :weights)
  end
end

if COMP::MultiRandomAffix::Enabled
  if !$imported[:Sel_Random_Affixes] || !$imported["TH_InstanceItems"] || !$imported[:TH_ItemAffixes]
    msgbox %{[WARNING] The dependency for MultiRandomAffixies are missing.
    Please make sure the scripts is placed in right order!
    (place MultiRandomAffix sciprt after the depended script)
    }
    exit
  end
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
        next unless $1.downcase == 'pre'
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
        next unless $1.downcase == 'suf'
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
    @prefix_id_multi ||= []
    @suffix_id_multi ||= []

    # Save the multi-affix effect, let the InstanceManager handle the effects
    case affix_sym
    when :prefix; @prefix_id_multi += ret;
    when :suffix; @suffix_id_multi += ret;
    end

    # Avoid original random_affixes script mess up stuff
    return 0
  end
end
#-----------------------------------------------------------------------------
end