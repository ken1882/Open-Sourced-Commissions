#=============================================================================#
#   Patch for Yanfly Engine Ace - Skill Restrictions                          #
#   Version: 1.0.0                                                            #  
#   Author: Compeador                                                         #  
#   Last update: 2019.04.23                                                   #
#   Require Script:                                                           #
#    * Yanfly Engine Ace - Skill Restrictions                                 #
#=============================================================================#
$imported = {} if $imported.nil?

if $imported["YEA-SkillRestrictions"]
$imported["COMP_YEA_SR_PATCH"] = true
#=============================================================================#
#                               ** Update log **                              #
#-----------------------------------------------------------------------------#
#                                                                             #
# -- 2019.04.23: Start the script and completed                               #
#                                                                             #
#=============================================================================#
#                              ** User Manual **                              #
#-----------------------------------------------------------------------------#
# > Introduction:                                                             #
#   This script is intend for fix a bug in YEA's skill restriction that won't #
# update cooldown for the skill not learned; and put this script under it.    #
#=============================================================================#

#==============================================================================
# ** Game_BattlerBase
#==============================================================================
class Game_BattlerBase
  #--------------------------------------------------------------------------
  # * Overweite: update_cooldowns
  #--------------------------------------------------------------------------
  def update_cooldowns(amount = -1, stype_id = 0, skill_id = 0)
    return if cooldown_lock?
    reset_cooldowns if @cooldown.nil?
    @cooldown.each do |skill, cdt|
      skill = $data_skills[skill] if !skill.is_a?(RPG::Skill)
      next if stype_id != 0 && skill.stype_id != stype_id
      next if skill_id != 0 && skill.id != skill_id
      set_cooldown(skill, cooldown?(skill) + amount)
    end
  end
end
end # $imported["YEA-SkillRestrictions"]