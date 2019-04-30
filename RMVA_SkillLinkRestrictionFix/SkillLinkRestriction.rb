#=============================================================================#
#   Patch for Hime Skill Link                                                 #
#   Version: 1.0.0                                                            #  
#   Author: Compeador                                                         #  
#   Last update: 2019.04.23                                                   #
#   Require Script:                                                           #
#    * Yanfly Engine Ace - Skill Restrictions                                 #
#    * Hime's Skill Link Script                                               #
#    * Hime's SKill Link Condition Plugin                                     #
#=============================================================================#
$imported = {} if $imported.nil?

if $imported["YEA-SkillRestrictions"] && $imported[:TH_SkillLinks] && 
  $imported["RDeus - Hime Skill Links Plugin"]
$imported["COMP_THSLSR_PATCH"] = true
#=============================================================================#
#                               ** Update log **                              #
#-----------------------------------------------------------------------------#
#                                                                             #
# -- 2019.04.27: Start the script and completed                               #
#                                                                             #
#=============================================================================#
#                              ** User Manual **                              #
#-----------------------------------------------------------------------------#
# > Introduction:                                                             #
#   This script is intend for patching Hime's Skill Link Script, which        #
# originally ignores YEA's skill restriciton script, now you can decide       #
# whether to ignore it or be restricted.                                      #
#                                                                             #
# > Usage:                                                                    #
#   The original usage in skill link condition script is:                     #
#                                                                             #
#   <link_skill_cond>                                                         #
#   id: X                                                                     #
#   chance: Y                                                                 #
#   condition: Z                                                              #
#   <free_link>                                                               #
#   </link_skill_cond>                                                        #
#                                                                             #
#   Now you can add 'restr: true/false/1/0' to set whether the skill link     #
# will check the YEA's restriction script or not.                             #
#                                                                             #
#   <link_skill_cond>                                                         #
#   id: X                                                                     #
#   chance: Y                                                                 #
#   condition: Z                                                              #
#   restr: W                                                                  #
#   <free_link>                                                               #
#   </link_skill_cond>                                                        #
#                                                                             #
#   'W' could be:                                                             #
#    true  => will check restriction                                          #
#    1     => lazy short version for true, will check                         #
#    false => will NOT check restriction                                      #
#    0     => lazy short version for false, won't check                       #
#                                                                             #
#=============================================================================#
#==============================================================================
# ** Module of this script
#==============================================================================
module COMP
  module THSLRPatch
    # Whether the skill link is restricted by default
    DefaultLinkRestriction = true

    #=============================================================================#
    #        Don't edit anything below unless you know what you're doing          #

    RestrictCondRegex = /restr:(.*)/i
  end
end
#===============================================================================
# ** This class is original in skill link plugin script
#===============================================================================
class RD_Data_SkillLink
  attr_accessor :restricted
  #----------------------------------------------------------------------------
end
#==============================================================================
# ** RPG::UsableItem
#==============================================================================
class RPG::UsableItem < RPG::BaseItem
  #-----------------------------------------------------------------------------
  # * Overwrite the function in skill link condition script
  #-----------------------------------------------------------------------------
  def skill_links_conditional_data
    return @skill_links_conditional_data if @skill_links_conditional_data
    
    @skill_links_conditional_data = []
    stuff = self.skill_links_conditional
    stuff.each do |link|
      id = 0
      chance = 1
      condition = "true"
      free = false
      restr = COMP::THSLRPatch::DefaultLinkRestriction

      data = link[0].strip.split(/[\r\n]+/)
      for option in data
        case option
        when /id:\s*(\d+)/i
          id = $1.to_i
        when /chance:\s*(.*)/i
          chance = $1.to_f if $1
        when /condition:\s*(.*)/i
          condition = $1 if $1
        when /(<free_link>)/i
          free = true if $1
        # only added this part
        when COMP::THSLRPatch::RestrictCondRegex
          opt = $1.strip
          restr = true  if opt.downcase == 'true'  || opt == '1'
          restr = false if opt.downcase == 'false' || opt == '0'
        end
      end
      cond_link = RD_Data_SkillLink.new(id)
      cond_link.chance = chance
      cond_link.condition = condition 
      cond_link.free = free 
      cond_link.restricted = restr
      @skill_links_conditional_data << cond_link
    end
    return @skill_links_conditional_data
  end
  #-----------------------------------------------------------------------------
end
#===============================================================================
# ** Scene Battle
#===============================================================================
class Scene_Battle < Scene_Base
  #-----------------------------------------------------------------------------
  # * Alias: link condition met?
  #-----------------------------------------------------------------------------
  alias :link_condition_met_restricted? :link_conditions_met?
  def link_conditions_met?(orig_item, link_item, cond_link)
    re = link_condition_met_restricted?(orig_item, link_item, cond_link)
    return re if !re || !cond_link.restricted
    return re && @subject.skill_conditions_met?(link_item)
  end
end
end # $imported