#=============================================================================#
#   Patch for Yanfly Engine Ace - Skill Restrictions                          #
#   Version: 1.0.0                                                            #  
#   Author: Compeador                                                         #  
#   Last update: 2019.04.27                                                   #
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
# ** COMP
#------------------------------------------------------------------------------
#  Module of this script, this option will only available if my script 
#  "Counter Attack+" is installed.
#==============================================================================
if $imported["COMP_CAP"]
module COMP
  module YEASRPatch
    # If set this flag to true, the counterskill will display as a skill type 
    # in actor battle command window
    DisplayUnlearnedSkill = true

    # The name for counter skill type
    CounterSkillTypeName  = "Counterskill"

    # If set this flag to true, player will be able the counterskill from the 
    # skill list even if the counterskill is not learned yet
    AllowManualUse        = false
    #=============================================================================#
    #        Don't edit anything below unless you know what you're doing          #
  end
end
end # if import CAP
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
    @cooldown.each_key do |skill|
      skill = $data_skills[skill] if !skill.is_a?(RPG::Skill)
      next if stype_id != 0 && skill.stype_id != stype_id
      next if skill_id != 0 && skill.id != skill_id
      set_cooldown(skill, cooldown?(skill) + amount)
    end
  end
end
#==============================================================================
if $imported["COMP_CAP"] && COMP::YEASRPatch::DisplayUnlearnedSkill
#==============================================================================
# ** Window_ActorCommand
#==============================================================================
class Window_ActorCommand < Window_Command
  #--------------------------------------------------------------------------
  # * Alias: add skill commands
  #--------------------------------------------------------------------------
  alias add_skill_commands_counter add_skill_commands 
  def add_skill_commands
    unless @actor.counterskill.empty?
      name = COMP::YEASRPatch::CounterSkillTypeName
      add_command(name, :skill, true, :counterskill)
    end
    add_skill_commands_counter
  end
end
#==============================================================================
# ** Window_BattleSkill
#==============================================================================
class Window_BattleSkill < Window_SkillList
  #--------------------------------------------------------------------------
  # * Alias: make item list
  #--------------------------------------------------------------------------
  alias make_item_list_counter make_item_list 
  def make_item_list
    return make_item_list_counter unless @stype_id == :counterskill
    @data = @actor.counterskill.collect{|sk| $data_skills[sk.skill_id]}
  end
  #--------------------------------------------------------------------------
  # * Alias: enable?
  #--------------------------------------------------------------------------
  alias :enable_counter? :enable?
  def enable?(item)
    re = enable_counter?(item)
    return re unless @stype_id == :counterskill
    return re && COMP::YEASRPatch::AllowManualUse
  end
  #--------------------------------------------------------------------------
end # class Window_SkillList
end # if DisplayUnlearnedSkill
end # $imported["YEA-SkillRestrictions"]